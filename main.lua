-- Load libraries and other .lua files
local wf = require 'libraries/windfield/windfield'
local Slab = require 'libraries/Slab'
local dog = require 'dog'
local objects = require 'objects'
local ui = require 'ui'

-- Placeholder vars for logo and bg images
local logo
local bg

-- For mouse grabbing logic
local grabbedCollider = nil
local mouseJoint = nil

-- States
local debugMode = false
gameState = {
    Main = false,
    Menu = true,    
    Shop = false,
}


-- Function to switch states, allows only one state to be true at a time.
function setGameState(stateName)
    for k in pairs(gameState) do gameState[k] = false end
    gameState[stateName] = true
end

----- LOVE.LOAD -----

function love.load()

    -- Load slab
    ui.load()
    

    -- Get window width + height
    winWidth, winHeight = love.graphics.getDimensions() 

    -- Creating the main game world
    world = wf.newWorld(0, 0, true)
    world:setGravity(0, 1028)
    
    -- establish collision classes
    world:addCollisionClass('Interactive')
    world:addCollisionClass('dogBody')
    world:addCollisionClass('dogLimb', {ignores = {'dogBody'}})

    -- Load objects art assets
    objects.load()

    -- The walls/floor of the world
    
    ground = world:newRectangleCollider(0, winHeight-50, winWidth, 50)
    ceiling = world:newRectangleCollider(0, -50, winWidth, 50)
    wall_left = world:newRectangleCollider(0, 0, 50, winHeight)
    wall_right = world:newRectangleCollider(winWidth-50, 0, 50, winHeight)
    ground:setType('static')
    ceiling:setType('static')
    wall_left:setType('static')
    wall_right:setType('static')
    
    
    -- Images
    logo = love.graphics.newImage("assets/templogo.png")
    bg = love.graphics.newImage("assets/BG.png")

end


function initMain()    
    if not gameState.Main then
        setGameState("Main")
        if dogVisible == false then
            dog.load()
        end
    end
end

function initMenu()
    if not gameState.Menu then
        if dogVisible then
           dog.destroy()
        end
        objects.destroy()
        setGameState("Menu")
    end
end

    
function initShop()
    if not gameState.Shop then
        setGameState("Shop")
        if mouseJoint then
            mouseJoint:destroy()
            mouseJoint = nil
            grabbedCollider = nil
        end
    end
end

-- Keyboard input handling
function love.keypressed(key, isrepeat)

    -- Toggle debug mode with "0"
    if key == "0" and debugMode == false then
        debugMode = true
    elseif key == "0" and debugMode == true  then
        debugMode = false
    end
    
    -- Pause game / open shop with "escape"
    if key == "escape" and gameState.Main then
        initShop()
    elseif key == "escape" and gameState.Shop then
        initMain()
    end
    
    -- Begin game with "enter"
    if key == "return" and gameState.Menu then
        initMain()
    end
    
    
    -- TEMP DEBUG... "Q" to delete current object
    if key == "q" and gameState.Main and not grabbedCollider then
        objects.destroy()
    end

end

function love.mousepressed(x, y, button)
    
-- Create mouse joint if mouse button 1 is clicked over interactive object
    if button == 1 and not grabbedCollider and gameState.Main then
        -- find interactable collider under mouse
        local colliders = world:queryCircleArea(x, y, 20, {'Interactive'})

        if #colliders > 0 then
            grabbedCollider = colliders[1]
            local body = grabbedCollider.body
            mouseJoint = love.physics.newMouseJoint(body, x, y)
        end
       

    end

end

function love.mousemoved(x, y, dx, dy)
-- Make mouse joint follow mouse while held
    if mouseJoint then
        mouseJoint:setTarget(x,y)
    end
end

function love.mousereleased(x, y, button)
-- Remove mouse joint when mouse 1 released
    if button == 1 and mouseJoint then
        mouseJoint:destroy()
        mouseJoint = nil
        grabbedCollider = nil
    end
    
end


function love.update(dt)
    
    -- Update slab (ui library)
    ui.update(dt)

    if gameState.Main then
        world:update(dt)
    end
end

function love.draw()
    -- Draw background
    love.graphics.draw(bg, winWidth/2-bg:getWidth()/2, winHeight/2-bg:getHeight()/2)



    -- Draw dog sprites over colliders 
    if gameState.Main or gameState.Shop then
        dog.draw()
    end

    -- Draw object sprites over colliders
    if gameState.Main or gameState.Shop then
        objects.draw()
    end

    -- Enable debug mode 
    if debugMode then
       world:draw()
    end
    
    -- Main menu logo (VERY TEMPORARY)
    if gameState.Menu then
        love.graphics.draw(logo, winWidth/2-logo:getWidth()/2, winHeight/2-logo:getHeight()/2)
    end
    
    -- Draw shop

    if gameState.Shop then
        love.graphics.print("Shop", winWidth/2-85, winHeight/2-200, 0, 5)
    end

    -- Draw UI elements (Slab)
    ui.draw()


    -- background 
    local r, g, b = love.math.colorFromBytes(22, 28, 75)
    love.graphics.setBackgroundColor(r,g,b)
end