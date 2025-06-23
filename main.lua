-- Load libraries and other .lua files
local wf = require 'libraries/windfield/windfield'
local dog = require 'dog'

-- For mouse grabbing logic
local grabbedCollider = nil
local mouseJoint = nil

function love.load()


    -- Creating the main game world
    world = wf.newWorld(0, 0, true)
    world:setGravity(0, 1028)



    -- ART ASSETS 
    
    miscART = {}
    miscART.bat = love.graphics.newImage("assets/bat.png")
    
    -- establish collision classes
     
    world:addCollisionClass('Interactive')
    world:addCollisionClass('dogBody')
    world:addCollisionClass('dogLimb', {ignores = {'dogBody'}})

     -- Load dog
    dog.load()   

    -- Temp bludgeoning tool
    BAT = {}
    BAT.col = world:newRectangleCollider(400 - 50/2, 0, 250, 40)
    BAT.col:setCollisionClass('Interactive')

    
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

function love.mousepressed(x, y, button)
    if button == 1 and not grabbedCollider then
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
    if mouseJoint then
        mouseJoint:setTarget(x,y)
    end
end

function love.mousereleased(x, y, button)
    if button == 1 and mouseJoint then
        mouseJoint:destroy()
        mouseJoint = nil
        grabbedCollider = nil
    end
end

function love.update(dt)
    dog.update(dt)
    world:update(dt)
end

function love.draw()
    -- Draw
    dog.draw()
    
    -- Get object position and angle
    local objPOS = {}
    objPOS.batX, objPOS.batY = BAT.col:getPosition()
    objPOS.batAngle = BAT.col:getAngle()


    -- Draw object sprites over colliders
    love.graphics.draw(miscART.bat, objPOS.batX, objPOS.batY, objPOS.batAngle, 1, 1, miscART.bat:getWidth()/2, miscART.bat:getHeight()/2)

    -- Debug, draw collision boxes when 'd' key is held down 
    if love.keyboard.isDown("d") then
        world:draw()
    end
    
    -- background 
    local r, g, b = love.math.colorFromBytes(22, 28, 75)
    love.graphics.setBackgroundColor(r,g,b)
end