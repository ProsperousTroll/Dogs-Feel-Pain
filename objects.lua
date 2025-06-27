-- Potential list of items player can buy:
--
-- A mean note [ - ]
-- Ikea bag [ X ]
-- Poop Sock [ - ]
-- Chocolate [ - ]
-- Beer bottle [ - ]
-- Frisbee [ - ]
-- Shock Collar [ - ] 
-- Meat hook [ - ]
-- Axe bat [ - ]
-- Red Hot Nickel Ball [ - ]
-- Hot Car [ - ]
-- Nana + pop pop's house [ - ]
-- Injection [ - ]
-- Piss Nuke [ - ]
-- The Legendary Brofist [ - ]


local objects = {}

-- Items
items = {
    beerBottle = false,
    axeBat = false,
    ikeaBag = false,
}

function objects.load()

    -- Misc art assets    
    miscART = {}
    miscART.bat = love.graphics.newImage("assets/bat.png")
    miscART.bottle = love.graphics.newImage("assets/beer bottle.png")
    miscART.ikeaBag = love.graphics.newImage("assets/ikeabag.png")
    

end

function loadIkeaBag()

    items.ikeaBag = true
    
    items.ikeaBagCol1 = world:newRectangleCollider(winWidth/2-250/2, 100+150, 250, 10)
    items.ikeaBagCol2 = world:newRectangleCollider(winWidth/2-(20-250/2), 100, 20, 150)
    items.ikeaBagCol3 = world:newRectangleCollider(winWidth/2-(250/2), 100, 20, 150)
    items.ikeaBagHandle = world:newRectangleCollider(winWidth/2-100/2, 50, 100, 10)
    

    items.ikeaBagCol1:setCollisionClass('Object')
    items.ikeaBagCol2:setCollisionClass('Object')
    items.ikeaBagCol3:setCollisionClass('Object')
    items.ikeaBagHandle:setCollisionClass('Handle')
    
    items.ikeaBagJoint1 = world:addJoint('WeldJoint', items.ikeaBagCol1, items.ikeaBagCol2, winWidth/2-(10-260/2), 250, false)
    items.ikeaBagJoint2 = world:addJoint('WeldJoint', items.ikeaBagCol1, items.ikeaBagCol3, winWidth/2-(240/2), 250, false)
    items.ikeaBagJoint3 = world:addJoint('WeldJoint', items.ikeaBagCol1, items.ikeaBagHandle, winWidth/2-100/2, 100, false)

end

function loadBeer()
    
    items.beerBottle = true

-- Beer bottle collider
    items.beerBottleCol = world:newRectangleCollider(winWidth/2-36/2, 100, 36, 112)
    items.beerBottleCol:setRestitution(0.4)
    items.beerBottleCol:setCollisionClass('Object')
    
end

function loadAxeBat()
    items.axeBat = true

-- Temp bludgeoning tool
    items.axeBatCol = world:newRectangleCollider(winWidth/2-250/2, 100, 250, 40)
    items.axeBatCol:setCollisionClass('Object')
    items.axeBatCol:setRestitution(0.3)
end

-- Detect how fast the active object is moving, in order to register dog.hurt()
function objects.speed(Table)
    for k, v in pairs(Table) do
        if type(v) == "table" and v.body and not v.body:isDestroyed() then
            local vx, vy = v:getLinearVelocity()
            speed = (vx+vy)/2
            if speed < 0 then
                speed = speed * -1
            end
            return speed
        end
    end
end

function objects.destroy()
    
    -- for loop to run destroy function. NO LONGER BREAKS GAME. I AM SO SMART.

    for k, v in pairs(items) do
        if items[k] == true then
            items[k] = false
        end

        if type(v) == "table" and v.body and not v:isDestroyed() then
            v:destroy()
        end
    end
    
    cash.Multiplier = 0.03

end


function objects.draw()

     local objPOS = {}
    
    if items.axeBat then
        
    -- Get object position and angl
        objPOS.batX, objPOS.batY = items.axeBatCol:getPosition()
        objPOS.batAngle = items.axeBatCol:getAngle()


    -- Draw object sprites over colliders
        love.graphics.draw(miscART.bat, objPOS.batX, objPOS.batY, objPOS.batAngle, 1, 1, miscART.bat:getWidth()/2, miscART.bat:getHeight()/2)

    end
    
    if items.beerBottle then

        objPOS.bottleX, objPOS.bottleY = items.beerBottleCol:getPosition()
        objPOS.bottleAngle = items.beerBottleCol:getAngle()
        
        love.graphics.draw(miscART.bottle, objPOS.bottleX, objPOS.bottleY, objPOS.bottleAngle, 1, 1, miscART.bottle:getWidth()/2, miscART.bottle:getHeight()/2)

    end
    
    if items.ikeaBag then 
        
        objPOS.bagX, objPOS.bagY = items.ikeaBagCol1:getPosition()
        objPOS.bagAngle = items.ikeaBagCol1:getAngle()
        
        love.graphics.draw(miscART.ikeaBag, objPOS.bagX, objPOS.bagY, objPOS.bagAngle, 1, 1, miscART.ikeaBag:getWidth()/2, miscART.ikeaBag:getHeight())
    end

end

return objects