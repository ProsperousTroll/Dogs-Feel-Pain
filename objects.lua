-- Potential list of items player can buy:
--
-- A mean note
-- Ikea bag
-- Poop Sock
-- Chocolate
-- Beer bottle
-- Frisbee
-- Shock Collar 
-- Meat hook
-- Axe bat
-- Red Hot Nickel Ball
-- Hot Car
-- Nana + pop pop's house
-- Injection 
-- Piss Nuke 
-- The Legendary Brofist


local objects = {}

-- Items
items = {
    beerBottle = false,
    axeBat = false,
}

function objects.load()

    -- Misc art assets    
    miscART = {}
    miscART.bat = love.graphics.newImage("assets/bat.png")
    miscART.bottle = love.graphics.newImage("assets/beer bottle.png")
    

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

function objects.speed()
    for k, v in pairs(items) do
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
    
    -- for loop to run destroy function, breaks game. will come back later.

  --[[  for k, v in pairs(items) do
         if type(v) == "boolean" then
            v = false
        end

        if type(v) == "table" and v.destroy then
            v:destroy()
        end
    end
 --]]
    if items.axeBat then
        items.axeBat = false
        items.axeBatCol:destroy()
    end
    
    if items.beerBottle then
        items.beerBottle = false 
        items.beerBottleCol:destroy()
    end

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

end

return objects