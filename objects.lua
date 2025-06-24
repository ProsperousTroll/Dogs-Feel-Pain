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

-- Item states 
itemState = {
    note = false,
    ikeaBag = false,
    poopSock = false,
    chocolate = false,
    beerBottle = false,
    frisbee = false,
    shockCollar = false,
    meatHook = false,
    axeBat = false,
    nickeBall = false,
    hotCar = false,
    nanaPop = false,
    injection = false,
    pissNuke = false,
    brofist = false,
}

function objects.load()

    -- Misc art assets    
    miscART = {}
    miscART.bat = love.graphics.newImage("assets/bat.png")
    miscART.bottle = love.graphics.newImage("assets/beer bottle.png")
    

end

function loadBeer()
    itemState.beerBottle = true

-- Beer bottle collider
    BOTTLE = {}    

    BOTTLE.col = world:newRectangleCollider(350, 100, 36, 112)
    BOTTLE.col:setRestitution(0.4)
    BOTTLE.col:setCollisionClass('Interactive')
end

function loadAxeBat()
    itemState.axeBat = true

-- Temp bludgeoning tool
    BAT = {}
    BAT.col = world:newRectangleCollider(350, 100, 250, 40)
    BAT.col:setCollisionClass('Interactive')
    BAT.col:setRestitution(0.3)
end

function objects.destroy()
    
    if itemState.axeBat then
        BAT.col:destroy()
        itemState.axeBat = false
    end
    
    if itemState.beerBottle then
        BOTTLE.col:destroy()
        itemState.beerBottle = false
    end

end

function objects.draw()

     local objPOS = {}
    
    if itemState.axeBat then
        
    -- Get object position and angl
        objPOS.batX, objPOS.batY = BAT.col:getPosition()
        objPOS.batAngle = BAT.col:getAngle()


    -- Draw object sprites over colliders
        love.graphics.draw(miscART.bat, objPOS.batX, objPOS.batY, objPOS.batAngle, 1, 1, miscART.bat:getWidth()/2, miscART.bat:getHeight()/2)

    end
    
    if itemState.beerBottle then
        objPOS.bottleX, objPOS.bottleY = BOTTLE.col:getPosition()
        objPOS.bottleAngle = BOTTLE.col:getAngle()
        
        love.graphics.draw(miscART.bottle, objPOS.bottleX, objPOS.bottleY, objPOS.bottleAngle, 1, 1, miscART.bottle:getWidth()/2, miscART.bottle:getHeight()/2)

    end

end

return objects