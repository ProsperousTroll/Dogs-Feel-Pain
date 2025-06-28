-- Potential list of items player can buy:
--
-- A mean note [ - ]
-- Ikea bag [ X ]
-- Poop Sock [ X ]
-- Chocolate [ - ]
-- Beer bottle [ - ]
-- Frisbee [ - ]
-- Shock Collar [ - ] 
-- Meat hook [ - ]
-- Bat [ X ]
-- Red Hot Nickel Ball [ - ]
-- Hot Car [ - ]
-- Nana + pop pop's house [ - ]
-- Injection [ - ]
-- Piss Nuke [ - ]
-- The Legendary Brofist [ - ]


local objects = {}

-- Items
items = {
    ikeaBag = false,
    poopSock = false,
    beerBottle = false,
    bat = false,
}

function objects.load()

    -- Misc art assets    
    miscART = {}
    miscART.bat = love.graphics.newImage("assets/bat.png")
    miscART.bottle = love.graphics.newImage("assets/beer bottle.png")
    miscART.ikeaBag = love.graphics.newImage("assets/ikeabag.png")
    miscART.poopSock1 = love.graphics.newImage("assets/poopSock1.png")
    miscART.poopSock2 = love.graphics.newImage("assets/poopSock2.png")
    

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

function loadPoopSock()
    
    items.poopSock = true
    
    items.poopSockCol2 = world:newRectangleCollider(winWidth/2+80-75, 100, 100, 50)
    items.poopSockCol1 = world:newRectangleCollider(winWidth/2-75, 100, 100, 50)
    
    items.poopSockCol1:setCollisionClass('Object')
    items.poopSockCol2:setCollisionClass('Object')
    
    items.PoopSockJoint = world:addJoint('RevoluteJoint', items.poopSockCol1, items.poopSockCol2, winWidth/2+25, 125, false)

end

function loadBeer()
    
    items.beerBottle = true

-- Beer bottle collider
    items.beerBottleCol = world:newRectangleCollider(winWidth/2-36/2, 100, 36, 112)
    items.beerBottleCol:setRestitution(0.4)
    items.beerBottleCol:setCollisionClass('Object')
    
end

function loadBat()
    items.bat = true

-- Temp bludgeoning tool
    items.batCol = world:newRectangleCollider(winWidth/2-250/2, 100, 250, 40)
    items.batCol:setCollisionClass('Object')
    items.batCol:setRestitution(0.3)
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
    

end


-- Function that matches sprite position to collider position..
function positionMatch(inCol, Sprite)
    X, Y = inCol:getPosition()
    Angle = inCol:getAngle()
    love.graphics.draw(Sprite, X, Y, Angle, 1, 1, Sprite:getWidth()/2, Sprite:getHeight()/2)
end


function objects.draw()
    local objPOS = {}

    if items.bat then
        positionMatch(items.batCol, miscART.bat)
    end
    
    if items.beerBottle then
        positionMatch(items.beerBottleCol, miscART.bottle)
    end
    
    if items.ikeaBag then 
        
        objPOS.bagX, objPOS.bagY = items.ikeaBagCol1:getPosition()
        objPOS.bagAngle = items.ikeaBagCol1:getAngle()
        
        love.graphics.draw(miscART.ikeaBag, objPOS.bagX, objPOS.bagY, objPOS.bagAngle, 1, 1, miscART.ikeaBag:getWidth()/2, miscART.ikeaBag:getHeight())
    end
    
    if items.poopSock then 
        positionMatch(items.poopSockCol2, miscART.poopSock2)
        positionMatch(items.poopSockCol1, miscART.poopSock1)
    end

end

return objects