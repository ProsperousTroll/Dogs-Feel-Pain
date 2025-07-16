--------------------
---- VARIABLES -----
--------------------

-- Load libraries and other .lua files
local wf = require 'libraries/windfield/windfield'
local Slab = require 'libraries/Slab'
local dog = require 'dog'
local objects = require 'objects'
local ui = require 'ui'
local sound = require 'sound'
local ux = require 'ux'

-- Placeholder vars for logo and bg images
local logo
local bg

-- For mouse grabbing logic
local grabbedCollider = nil
local mouseJoint = nil

-- Money system
cash = {
    Wallet = 0,
    Base = 0.02,
    Multiplier = 1,
} 

-- Combo system
combo = {
    count = 0,
    maxMultiplier = 25,
    multiTimer = 1,
}

-- Concern
concern = { 
    level = 0,
    fillRate = 30,
    decayRate = 25,
    fullMeter = BAR.H,
}


-- States
local debugMode = false
gameState = {
    Main = false,
    Menu = true,    
    Shop = false,
    gameOver = false,
}



---------------------
----- LOVE.LOAD -----
---------------------

function love.load()

    -- custom UX
    ux.load()

    -- Load slab
    ui.load()
    sound.load()
    
    -- Get window width + height
    winWidth, winHeight = love.graphics.getDimensions() 

    -- Creating the main game world
    world = wf.newWorld(0, 0, true)
    world:setGravity(0, 1028)
    
    -- establish collision classes
    world:addCollisionClass('Interactive')
    world:addCollisionClass('World')
    world:addCollisionClass('Object')
    world:addCollisionClass('Dog')
    world:addCollisionClass('Handle', {ignores = {'Dog'}})

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
    
    ground:setCollisionClass('World')
    ceiling:setCollisionClass('World')
    wall_left:setCollisionClass('World')
    wall_right:setCollisionClass('World')
    
    
    -- Images
    logo = love.graphics.newImage("assets/templogo.png")
    vign = love.graphics.newImage("assets/vign.png")
    gameOver = love.graphics.newImage("assets/gameover.png")
    bg = love.graphics.newImage("assets/BG.png")
    

    
    impactFrame = false
    impactTimer = 0
    
    SFX.bgmusic[1]:play()
    
    speed = 0 
end


---------------------
----- FUNCTIONS -----
---------------------

-- Function to switch states, allows only one state to be true at a time.
function setGameState(stateName)
    for k in pairs(gameState) do gameState[k] = false end
    gameState[stateName] = true
end


function initMain()    
    if not gameState.Main then
        setGameState("Main")
        if dogVisible == false then
            dog.load()
        end
        SFX.bgmusic[1]:stop()
    end
end

function initMenu()
    if not gameState.Menu then
        if dogVisible then
           dog.destroy()
        end
        if mouseJoint then
            mouseJoint:destroy()
            mouseJoint = nil
            grabbedCollider = nil
        end
        objects.destroy()
        concern.level = 0
        setGameState("Menu")
        SFX.bgmusic[1]:play()
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

function initGameOver()
    if not gameState.gameOver then
        if dogVisible then
            dog.destroy()
        end
        if mouseJoint then
            mouseJoint:destroy()
            mouseJoint = nil
            grabbedCollider = nil
        end
        objects.destroy()
        setGameState("gameOver")
        combo.count = 0
        concern.level = 0
    end
end

------------------
----- INPUTS -----
------------------

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
    
    
    -- TEMP DEBUG KEYS, WILL BE REMOVED
    
    if key == "1" then
        setSkin("base")
    end
    
    if key == "2" then
        setSkin("benny")
    end
    
    if key == "3" then
        setSkin("photobash")
    end
    
    if key == "4" then
        setSkin("red")
    end
    
    if key == "5" then
        setSkin("daisy")
    end
    
    if key == "6" then
        setSkin("annoying")
    end
    
    if key == "space" then
        cash.Wallet = cash.Wallet + 15
    end
    
    
    if key == 'f' then 
        DOG.joint1:destroy()
    end
    
    if key == 'g' then
        DOG.joint2:destroy()
    end


end


function love.mousepressed(x, y, button)
    
-- Create mouse joint if mouse button 1 is clicked over interactive object
    if button == 1 and not grabbedCollider and gameState.Main then
        -- find interactable collider under mouse
        colliders = world:queryCircleArea(x, y, 20, {'Object', 'Dog', 'Handle'})

        if #colliders > 0 then
            grabbedCollider = colliders[1]
            local body = grabbedCollider.body
            mouseJoint = love.physics.newMouseJoint(body, x, y)
            -- this looks retarded but it makes moving things around feel good
            mouseJoint:setMaxForce(999999999999999999999999)
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
        speed = 0
    end
end

-------------------
--- LOVE UPDATE ---
-------------------

function love.update(dt)

    ux.update(dt)

    fps = love.timer.getFPS()
    
    -- Update slab (ui library)
    ui.update(dt)

    if impactFrame then
        impactTimer = impactTimer + 1
        if impactTimer >= 0.07 * fps then
            impactFrame = false
            impactTimer = 0
            if combo.count < combo.maxMultiplier then
                combo.count = combo.count + 1
            end
            combo.multiTimer = fps * 1
        end
    end

    -- Update physics world (windfield) 
    if gameState.Main and not impactFrame then
        world:update(dt)
        dog:update(dt)
    end
    
    -- Combo (crude spaghetti)
    if gameState.Main and combo.count > 0 then
        cash.Multiplier = combo.count + concern.level 
        combo.multiTimer = combo.multiTimer - 1
        if combo.multiTimer == 0 then
            combo.count = 0
            cash.Multiplier = 1
            combo.multiTimer = 1 * dt
        end
    end
    
    if gameState.Main and concern.level >= 0 then
        concern.level = concern.level - (concern.decayRate * dt)
    end
    
    
    if concern.level > concern.fullMeter then
        initGameOver()
    end

    
    -- Calculate object speed
    if gameState.Main and mouseJoint then
        objects.speed(colliders)
    end
    
    if gameState.Main and mouseJoint then
        sound.playRandom(SFX.swoosh)
    end
    
end

---------------------
----- LOVE.DRAW -----
---------------------

function love.draw()
    

    -- Draw background
    love.graphics.draw(bg, winWidth/2-bg:getWidth()/2, winHeight/2-bg:getHeight()/2)

    if impactFrame then
    --    love.graphics.rectangle("fill", winHeight/2-2000/2, winWidth/2-2000/2, 2000, 2000)
        love.graphics.draw(vign, winWidth/2-vign:getWidth()/2, winHeight/2-vign:getHeight()/2)
    end

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

    -- Draw UI elements (Slab)
    ui.draw()
    
    if gameState.gameOver then 
        love.graphics.draw(gameOver, winWidth/2-gameOver:getWidth()/2, winHeight/2-gameOver:getHeight()/2)
    end
    
    -- TEMP print cash value 
    if gameState.Main or gameState.Shop then
        love.graphics.print("Wallet: $" .. cash.Wallet, 50, 50)
        love.graphics.print("Combo: " .. combo.count, 50, 100)
      --love.graphics.print("Concern: " .. concern.level, 50, 150)
    end
    
    if gameState.Main or gameState.shop then
        ux.draw()
    end
end