
local wf = require 'libraries/windfield/windfield'
local grabbedCollider = nil
local mouseJoint = nil

function love.load()
    -- Creating the main game world
    world = wf.newWorld(0, 0, true)
    world:setGravity(0, 1024)
    
    -- establish collision classes
     
    world:addCollisionClass('Interactive')
    world:addCollisionClass('dogBody')
    world:addCollisionClass('dogLimb', {ignores = {'dogBody'}})


    -- Temporary bludgening tool 
    
    testBox = world:newRectangleCollider(600 - 50/2, 0, 200, 50)
    testBox:setCollisionClass('Interactive')

    -- The Dog Who Feels Pain -- 

    -- colliders 
    DOG = {}
    DOG.frLeg = world:newBSGRectangleCollider(350 - 50/2, 30, 10, 60, 5)
    DOG.bkLeg = world:newBSGRectangleCollider(435 - 50/2, 30, 10, 60, 5)
    DOG.tail = world:newBSGRectangleCollider(435 - 50/2, -40, 10, 50, 5)
    DOG.butt = world:newBSGRectangleCollider(400 - 50/2, 0, 45, 50, 10)
    DOG.chest = world:newBSGRectangleCollider(340 - 50/2, 0, 54, 50, 10)
    DOG.head = world:newBSGRectangleCollider(290 - 50/2, -40, 70, 50, 10)
    
    -- joints
    DOG.joint1 = world:addJoint('RevoluteJoint', DOG.butt, DOG.chest, 375, 25, true)
    DOG.joint2 = world:addJoint('RevoluteJoint', DOG.chest, DOG.head, 325, 0, true)
    DOG.joint3 = world:addJoint('RevoluteJoint', DOG.frLeg, DOG.chest, 355 - 50/2, 30, false)
    DOG.joint4 = world:addJoint('RevoluteJoint', DOG.bkLeg, DOG.butt, 440 - 50/2, 30, false)
    DOG.joint5 = world:addJoint('RevoluteJoint', DOG.tail, DOG.butt, 440 - 50/2, 0, true)
    
    -- setting restitution to entire dog to 0.6 (global bouncy value)
    DOG.frLeg:setRestitution(0.6)
    DOG.bkLeg:setRestitution(0.6)
    DOG.tail:setRestitution(0.6)
    DOG.head:setRestitution(0.6)
    DOG.chest:setRestitution(0.6)
    DOG.butt:setRestitution(0.6)
    
    -- setting entire dog to class 'interactive' (making all parts clickable)
    DOG.head:setCollisionClass('Interactive', 'dogBody')            
    DOG.chest:setCollisionClass('Interactive', 'dogBody')
    DOG.butt:setCollisionClass('Interactive', 'dogBody')
    DOG.frLeg:setCollisionClass('Interactive', 'dogLimb')
    DOG.bkLeg:setCollisionClass('Interactive', 'dogLimb')
    DOG.tail:setCollisionClass('Interactive', 'dogLimb')
    
    
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
        local colliders = world:queryCircleArea(x, y, 25, {'Interactive'})

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
    world:update(dt)
end

function love.draw()
    world:draw()
end