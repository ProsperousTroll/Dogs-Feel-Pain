
local wf = require 'libraries/windfield/windfield'
local grabbedCollider = nil
local mouseJoint = nil

function love.load()
    -- Creating the main game world
    world = wf.newWorld(0, 0, true)
    world:setGravity(0, 1024)
    
    -- establish collision classes
     
    world:addCollisionClass('Interactive')


    -- Temporary box collision body 
    
    testBox = world:newRectangleCollider(600 - 50/2, 0, 200, 50)
    
    box1 = world:newBSGRectangleCollider(400 - 50/2, 0, 50, 50, 10)
    box1:setRestitution(0.6)
    box2 = world:newBSGRectangleCollider(340 - 50/2, 0, 50, 50, 10)
    box2:setRestitution(0.6)
    box3 = world:newBSGRectangleCollider(290 - 50/2, -40, 75, 50, 10)
    box3:setRestitution(0.6)
    joint = world:addJoint('RevoluteJoint', box1, box2, 375, 25, true)
    joint2 = world:addJoint('RevoluteJoint', box3, box2, 325, 0, true)
    box1:setCollisionClass('Interactive')
    box2:setCollisionClass('Interactive')
    box3:setCollisionClass('Interactive')
    testBox:setCollisionClass('Interactive')
    
    -- The walls/floor of the world
    ground = world:newRectangleCollider(0, 550, 800, 50)
    wall_left = world:newRectangleCollider(0, 0, 50, 600)
    wall_right = world:newRectangleCollider(750, 0, 50, 600)
    ground:setType('static')
    wall_left:setType('static')
    wall_right:setType('static')
    

end

function love.mousepressed(x, y, button)
    if button == 1 and not grabbedCollider then
        -- find collider under mouse
        local colliders = world:queryCircleArea(x, y, 25, {'Interactive'})

        if #colliders > 0 then
            grabbedCollider = colliders[1]
            local body = grabbedCollider.body
            mouseJoint = love.physics.newMouseJoint(body, x, y)
            -- mouseJoint:setDampingRatio(0.8)
            -- mouseJoint:setFrequency(4.00)
            -- mouseJoint:setMaxForce(16000 * body:getMass())
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
    world:update(dt)
end

function love.draw()
    world:draw()
end