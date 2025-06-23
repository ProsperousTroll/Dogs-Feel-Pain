local objects = {}

function objects.load()

    -- Misc art assets    
    miscART = {}
    miscART.bat = love.graphics.newImage("assets/bat.png")
    
    -- Temp bludgeoning tool
    BAT = {}
    BAT.col = world:newRectangleCollider(400 - 50/2, 0, 250, 40)
    BAT.col:setCollisionClass('Interactive')
    
end

function objects.draw()

    -- Get object position and angl
    local objPOS = {}
    objPOS.batX, objPOS.batY = BAT.col:getPosition()
    objPOS.batAngle = BAT.col:getAngle()

        -- Draw object sprites over colliders
    love.graphics.draw(miscART.bat, objPOS.batX, objPOS.batY, objPOS.batAngle, 1, 1, miscART.bat:getWidth()/2, miscART.bat:getHeight()/2)

end

return objects