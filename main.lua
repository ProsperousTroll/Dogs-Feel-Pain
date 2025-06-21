
local wf = require 'libraries/windfield/windfield'
local grabbedCollider = nil
local mouseJoint = nil

function love.load()
    -- Creating the main game world
    world = wf.newWorld(0, 0, true)
    world:setGravity(0, 1028)
    
    -- ART ASSETS 
    dogART = {}
    dogART.head = love.graphics.newImage("assets/ugly dog head.png")
    dogART.chest = love.graphics.newImage("assets/ugly dog chest.png")
    dogART.butt = love.graphics.newImage("assets/ugly dog butt.png")
    dogART.tail = love.graphics.newImage("assets/ugly dog tail.png")
    dogART.frleg = love.graphics.newImage("assets/ugly dog fleg.png")
    dogART.bkleg = love.graphics.newImage("assets/ugly dog bkleg.png")
    
    miscART = {}
    miscART.bat = love.graphics.newImage("assets/bat.png")
    
    -- establish collision classes
     
    world:addCollisionClass('Interactive')
    world:addCollisionClass('dogBody')
    world:addCollisionClass('dogLimb', {ignores = {'dogBody'}})

    -- Temp bludgeoning tool
    BAT = {}
    BAT.col = world:newRectangleCollider(400 - 50/2, 0, 250, 40)
    BAT.col:setCollisionClass('Interactive')

    -- This felt like shit to swing around, going with a simpler approach  
    -- BAT = {}
    -- BAT.shaft = world:newRectangleCollider(450 - 50/2, 0, 150, 25)
    -- BAT.handle = world:newRectangleCollider(600 - 50/2, 0, 50, 25)
    -- BAT.weld = world:addJoint('WeldJoint', BAT.handle, BAT.shaft, 600 - 50/2, 10, true)
    -- BAT.handle:setCollisionClass('Interactive')

    -- The Dog Who Feels Pain -- 

    -- colliders 
    DOG = {}
    DOG.frLeg = world:newBSGRectangleCollider(350 - 50/2, 50, 10, 40, 5)
    DOG.bkLeg = world:newBSGRectangleCollider(435 - 50/2, 50, 10, 40, 5)
    DOG.tail = world:newBSGRectangleCollider(435 - 50/2, -40, 10, 50, 5)
    DOG.butt = world:newBSGRectangleCollider(400 - 50/2, 0, 45, 50, 10)
    DOG.chest = world:newBSGRectangleCollider(340 - 50/2, 0, 54, 50, 10)
    DOG.head = world:newBSGRectangleCollider(290 - 50/2, -40, 70, 50, 10)
    
    -- joints
    DOG.joint1 = world:addJoint('RevoluteJoint', DOG.butt, DOG.chest, 375, 25, true)
    DOG.joint2 = world:addJoint('RevoluteJoint', DOG.chest, DOG.head, 325, 0, true)
    DOG.joint3 = world:addJoint('RevoluteJoint', DOG.frLeg, DOG.chest, 355 - 50/2, 30, true)
    DOG.joint4 = world:addJoint('RevoluteJoint', DOG.bkLeg, DOG.butt, 440 - 50/2, 30, true)
    DOG.joint5 = world:addJoint('RevoluteJoint', DOG.tail, DOG.butt, 440 - 50/2, 0, false)
    
    -- Setting rotation limit of tail (looks more natural)
    DOG.joint5:setLimitsEnabled(true)
    DOG.joint5:setLimits(-1, 0)
    
    -- setting restitution to entire dog to 0.6 (global bouncy value, horrifically ugly code)
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
    world:update(dt)
end

function love.draw()
    -- Declaring position variables to match sprite position to collision position
    dogPOS = {}
    dogPOS.headX, dogPOS.headY = DOG.head:getPosition()
    dogPOS.headAngle = DOG.head:getAngle()
    
    dogPOS.chestX, dogPOS.chestY = DOG.chest:getPosition()
    dogPOS.chestAngle = DOG.chest:getAngle()
    
    dogPOS.buttX, dogPOS.buttY = DOG.butt:getPosition()
    dogPOS.buttAngle = DOG.butt:getAngle()
    
    dogPOS.tailX, dogPOS.tailY = DOG.tail:getPosition()
    dogPOS.tailAngle = DOG.tail:getAngle()
    
    dogPOS.frlegX, dogPOS.frlegY = DOG.frLeg:getPosition()
    dogPOS.frlegAngle = DOG.frLeg:getAngle()
    
    dogPOS.bklegX, dogPOS.bklegY = DOG.bkLeg:getPosition()
    dogPOS.bklegAngle = DOG.bkLeg:getAngle()
    
    objPOS = {}
    objPOS.batX, objPOS.batY = BAT.col:getPosition()
    objPOS.batAngle = BAT.col:getAngle()

    -- Draw dog sprites over colliders 
    love.graphics.draw(dogART.butt, dogPOS.buttX, dogPOS.buttY, dogPOS.buttAngle, 1, 1, dogART.butt:getWidth()/2-10, dogART.butt:getHeight()/2)
    love.graphics.draw(dogART.tail, dogPOS.tailX, dogPOS.tailY, dogPOS.tailAngle, 1, 0.65, dogART.tail:getWidth()/2, dogART.tail:getHeight()/2-15)
    love.graphics.draw(dogART.chest, dogPOS.chestX, dogPOS.chestY, dogPOS.chestAngle, 1, 1, dogART.chest:getWidth()/2+20, dogART.chest:getHeight()/2+7)
    love.graphics.draw(dogART.head, dogPOS.headX, dogPOS.headY, dogPOS.headAngle, 1, 1, dogART.head:getWidth()/2, dogART.head:getHeight()/2)
    love.graphics.draw(dogART.frleg, dogPOS.frlegX, dogPOS.frlegY, dogPOS.frlegAngle, 1, 1, dogART.frleg:getWidth()/2, dogART.frleg:getHeight()/2+15)
    love.graphics.draw(dogART.bkleg, dogPOS.bklegX, dogPOS.bklegY, dogPOS.bklegAngle, 1, 1, dogART.bkleg:getWidth()/2, dogART.bkleg:getHeight()/2+15)

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