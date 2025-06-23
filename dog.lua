local dog = {}
local xOffset = 0
local yOffset = 400

function dog.load()
    
    -- ART ASSETS 
    dogART = {}
    dogART.head = love.graphics.newImage("assets/ugly dog head.png")
    dogART.chest = love.graphics.newImage("assets/ugly dog chest.png")
    dogART.butt = love.graphics.newImage("assets/ugly dog butt.png")
    dogART.tail = love.graphics.newImage("assets/ugly dog tail.png")
    dogART.frleg = love.graphics.newImage("assets/ugly dog fleg.png")
    dogART.bkleg = love.graphics.newImage("assets/ugly dog bkleg.png")
    
     -- colliders 
    DOG = {}
    DOG.frLeg = world:newBSGRectangleCollider(350 - 50/2, 55+yOffset, 10, 35, 5)
    DOG.bkLeg = world:newBSGRectangleCollider(435 - 50/2, 50+yOffset, 10, 40, 5)
    DOG.tail = world:newBSGRectangleCollider(445 - 50/2, -40+yOffset, 10, 50, 5)
    DOG.butt = world:newBSGRectangleCollider(400 - 50/2, 0+yOffset, 45, 50, 10)
    DOG.chest = world:newBSGRectangleCollider(340 - 50/2, 0+yOffset, 54, 50, 10)
    DOG.head = world:newBSGRectangleCollider(290 - 50/2, -40+yOffset, 70, 50, 10)
    
    -- joints
    DOG.joint1 = world:addJoint('RevoluteJoint', DOG.butt, DOG.chest, 375, 25+yOffset, true)
    DOG.joint2 = world:addJoint('RevoluteJoint', DOG.chest, DOG.head, 325, 0+yOffset, true)
    DOG.joint3 = world:addJoint('RevoluteJoint', DOG.frLeg, DOG.chest, 355 - 50/2, 30+yOffset, true)
    DOG.joint4 = world:addJoint('RevoluteJoint', DOG.bkLeg, DOG.butt, 440 - 50/2, 30+yOffset, true)
    DOG.joint5 = world:addJoint('RevoluteJoint', DOG.tail, DOG.butt, 450 - 50/2, 0+yOffset, false)

    -- Setting rotation limit of tail (looks more natural)
     
    DOG.joint4:setLimitsEnabled(true)
    DOG.joint4:setLimits(-1, 1)

    DOG.joint5:setLimitsEnabled(true)
    DOG.joint5:setLimits(-0.4, 0)
    
    DOG.joint3:setLimitsEnabled(true)
    DOG.joint3:setLimits(-1, 0)
    
        -- setting restitution to entire dog to 0.6 (global bouncy value, horrifically ugly code)
    DOG.frLeg:setRestitution(0.8)
    DOG.bkLeg:setRestitution(0.8)
    DOG.tail:setRestitution(0.8)
    DOG.head:setRestitution(0.8)
    DOG.chest:setRestitution(0.8)
    DOG.butt:setRestitution(0.8)
    
        -- setting entire dog to class 'interactive' (making all parts clickable)
    DOG.head:setCollisionClass('Interactive', 'dogBody')            
    DOG.chest:setCollisionClass('Interactive', 'dogBody')
    DOG.butt:setCollisionClass('Interactive', 'dogBody')
    DOG.frLeg:setCollisionClass('Interactive', 'dogLimb')
    DOG.bkLeg:setCollisionClass('Interactive', 'dogLimb')
    DOG.tail:setCollisionClass('Interactive', 'dogLimb')

end


function dog.draw()

-- Declaring position variables to match sprite position to collision position
    local dogPOS = {}
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

    -- Draw dog sprites over colliders 
    love.graphics.draw(dogART.butt, dogPOS.buttX, dogPOS.buttY, dogPOS.buttAngle, 1, 1, dogART.butt:getWidth()/2-10, dogART.butt:getHeight()/2)
    love.graphics.draw(dogART.chest, dogPOS.chestX, dogPOS.chestY, dogPOS.chestAngle, 1, 1, dogART.chest:getWidth()/2+20, dogART.chest:getHeight()/2+7)
    love.graphics.draw(dogART.head, dogPOS.headX, dogPOS.headY, dogPOS.headAngle, 1, 1, dogART.head:getWidth()/2, dogART.head:getHeight()/2)
    love.graphics.draw(dogART.frleg, dogPOS.frlegX, dogPOS.frlegY, dogPOS.frlegAngle, 1, 1, dogART.frleg:getWidth()/2, dogART.frleg:getHeight()/2+15)
    love.graphics.draw(dogART.bkleg, dogPOS.bklegX, dogPOS.bklegY, dogPOS.bklegAngle, 1, 1, dogART.bkleg:getWidth()/2, dogART.bkleg:getHeight()/2+10)
    love.graphics.draw(dogART.tail, dogPOS.tailX, dogPOS.tailY, dogPOS.tailAngle, 1, 0.65, dogART.tail:getWidth()/2, dogART.tail:getHeight()/2-15)
    
end

return dog