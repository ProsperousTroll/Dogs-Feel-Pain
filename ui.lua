-- Require Slab, set up ui table.
local Slab = require 'libraries/Slab'
local objects = require 'objects'
local ui = {}

-- Width and Height variables for windows per gamestate
local uiWidth = {}
local uiHeight = {}

uiWidth.Shop = 175
uiHeight.Shop = 200

uiWidth.Menu = 100
uiHeight.Menu = 50

uiWidth.sButton = 250
uiHeight.sButton = 75

local itemPurchased = {
    axeBat = false,
    beerBottle = false,
    poopSock = false,
    poopSockPrice = "Poop Sock - $2.50",
    beerBottlePrice = "Beer Bottle - $0.50",
    axeBatPrice = "Axe Bat - $10"
}

local uiAssets = {
    Shop = love.graphics.newImage("assets/Ui/shop.png"),
    ShopHovered = love.graphics.newImage("assets/Ui/shopHovered.png"),
}


function ui.load(args)
    Slab.Initialize(args)
    


end



function ui.update(dt)
    Slab.Update(dt)
    
    if gameState.Menu then
        Slab.BeginWindow('Main Menu', {
            ResetPosition = true,
            ResetSize = true,
            W = uiWidth.Menu,
            H = uiHeight.Menu,
            X = winWidth/2-uiWidth.Menu/2,
            Y = winHeight/2+250,
            AllowMove = false,
            AllowResize = false,
            AutoSizeWindow = false,
            NoSavedSettings = true,
        })
        
        if Slab.Button("Begin.") then
            initMain() end
        
        if Slab.Button("I can't...") then
           love.window.close() 
        end
 
        Slab.EndWindow()
    end
    
    if gameState.Main then
        Slab.BeginWindow('initShop', {
            ResetPosition = true,
            ResetSize = true,
            W = uiWidth.sButton,
            H = uiHeight.sButton,
            X = winWidth-50-uiWidth.sButton,
            Y = 25,
            BgColor = {0.0, 0.0, 0.0, 0.0},
            NoOutline = true, 
            AllowMove = false,
            AllowResize = false,
            AutoSizeWindow = false,
            AutoSizeContent = false,
            NoSavedSettings = true,
            ShowMinimize = false,
            ShowScrollbarX = false, 
            ShowScrollbarY = false,
        })
        
        Slab.Image('ShopButton', {Image = uiAssets.Shop, ReturnOnClick = true})
        if Slab.IsControlClicked() then
            initShop()
        end
        
        if Slab.IsControlHovered() then
            Image = uiAssets.ShopHovered
        end

        Slab.EndWindow()
    end
    
    if gameState.Shop then
       Slab.BeginWindow('Shop', { 
            ResetPosition = true,
            ResetSize = true,
            W = uiWidth.Shop,
            H = uiHeight.Shop,
            X = winWidth/2-uiWidth.Shop/2, 
            Y = winHeight/2-uiHeight.Shop/2, 
            AllowMove = false,
            AllowResize = false,
            AutoSizeWindow = false,
            NoSavedSettings = true,
        })
        
        
       if Slab.Button("Ikea Bag") and not items.ikeaBag then
            objects:destroy()
            loadIkeaBag()
       end


       if Slab.Button(itemPurchased.beerBottlePrice) and not items.beerBottle then
            if not itemPurchased.beerBottle and cash.Wallet >= 0.50 then
                cash.Wallet = cash.Wallet - 0.50
                itemPurchased.beerBottlePrice = "Beer Bottle"
                itemPurchased.beerBottle = true
                objects:destroy()
                loadBeer()
            elseif itemPurchased.beerBottle then
                objects:destroy()
                loadBeer()
            end
       end
       
       if Slab.Button(itemPurchased.poopSockPrice) and not items.poopSock then
           if not itemPurchased.poopSock and cash.Wallet >= 2.50 then
               cash.Wallet = cash.Wallet - 2.50
               itemPurchased.poopSockPrice = "Poop Sock"
               itemPurchased.poopSock = true
               objects:destroy()
               loadPoopSock()
           elseif itemPurchased.poopSock then
               objects:destroy()
               loadPoopSock()
           end
       end

        if Slab.Button(itemPurchased.axeBatPrice) and not items.axeBat then
            if not itemPurchased.axeBat and cash.Wallet >= 10 then
                cash.Wallet = cash.Wallet - 10.00
                itemPurchased.axeBatPrice = "Axe Bat"
                itemPurchased.axeBat = true
                objects:destroy()
                loadAxeBat()
            elseif itemPurchased.axeBat then
                objects:destroy()
                loadAxeBat()
            end
        end

       if Slab.Button("Return") then
            initMain()
       end
        
       if Slab.Button ("Stop hurting...") then
            initMenu()
       end

       Slab.EndWindow()
    end

end

function ui.draw()
    Slab.Draw()
end

return ui