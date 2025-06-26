-- Require Slab, set up ui table.
local Slab = require 'libraries/Slab'
local objects = require 'objects'
local ui = {}

-- Width and Height variables for windows per gamestate
local uiWidth = {}
local uiHeight = {}

uiWidth.Shop = 150
uiHeight.Shop = 200

uiWidth.Menu = 100
uiHeight.Menu = 50

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

       if Slab.Button("Axe Bat") and not items.axeBat then
            objects:destroy()
            loadAxeBat()
       end

       if Slab.Button("Beer Bottle") and not items.beerBottle then
            objects:destroy()
            loadBeer()
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