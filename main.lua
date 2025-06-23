-- Load libraries and other .lua files
local wf = require 'libraries/windfield/windfield'
local dog = require 'dog'
local objects = require 'objects'

-- For mouse grabbing logic
local grabbedCollider = nil
local mouseJoint = nil

-- States
local debugMode = false
gameState = {
    Main = false,
    Menu = true,    
    Pause = false,
}

function love.load()

    -- Creating the main game world
    world = wf.newWorld(0, 0, true)
    world:setGravity(0, 1028)
    
    -- establish collision classes
    world:addCollisionClass('Interactive')
    world:addCollisionClass('dogBody')
    world:addCollisionClass('dogLimb', {ignores = {'dogBody'}})

     -- Load dog
    dog.load()   

    -- Load objects
    objects.load()

    -- The walls/floor of the world
    
    ground = world:newRectangleCollider(0, 550, 800, 50)
    ceiling = world:newRectangleCollider(0, -50, 800, 50)
    wall_left = world:newRectangleCollider(0, 0, 50, 600)
    wall_right = world:newRectangleCollider(750, 0, 50, 600)
    ground:setType('static')
    ceiling:setType('static')
    wall_left:setType('static')
    wall_right:setType('static')

end

-- Keyboard input handling
function love.keypressed(key, isrepeat)

    -- Toggle debug mode with "0"
    if key == "0" and debugMode == false then
        debugMode = true
    elseif key == "0" and debugMode == true  then
        debugMode = false
    end
    
    
    -- Pause game with "escape"
    if key == "escape" and gameState.Main == true then
        gameState.Main = false
        gameState.Pause = true
        -- Disable player from being able to interact with objects while paused
        if mouseJoint then
            mouseJoint:destroy()
            mouseJoint = nil
            grabbedCollider = nil
        end
    elseif key == "escape" and gameState.Pause == true then
        gameState.Pause = false
        gameState.Main = true
    end
    
    -- Begin game with "enter"
    if key == "return" and gameState.Menu then
        gameState.Menu = false
        gameState.Main = true
    end

end

function love.mousepressed(x, y, button)
    
-- Create mouse joint if mouse button 1 is clicked over interactive object
    if button == 1 and not grabbedCollider and not gameState.Pause then
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
    if gameState.Main then
        world:update(dt)
    end
end

function love.draw()
    -- Draw dog sprites over colliders 
    if gameState.Main or gameState.Pause then
       dog.draw()
    end

    -- Draw object sprites over colliders
    if gameState.Main or gameState.Pause then
        objects.draw()
    end

    -- Enable debug mode 
    if debugMode then
        world:draw()
    end
    
    -- Pause text 
    if gameState.Pause then
        love.graphics.print("Pawsed", 325, 275)
    end
    
    -- Main menu logo (VERY TEMPORARY)
    local logo = love.graphics.newImage("assets/templogo.png")
    if gameState.Menu then
        love.graphics.draw(logo, 200, 200)
        love.graphics.print("Press Enter", 360, 350)
        
    end
    
    -- background 
    local r, g, b = love.math.colorFromBytes(22, 28, 75)
    love.graphics.setBackgroundColor(r,g,b)
end