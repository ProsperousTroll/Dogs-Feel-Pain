local ux = {}

-- This file is for custom made UX elements because the slab library doesn't actually have a bar. Might end up making my own UX library to replace SLAB
-- as it doesn't really suit my needs entirely. 



-- Concern meter UI
BAR = {
        progress = 0,
        percent = 0,
        TEMPLATE = nil,
        W = 25,
        H = 350,
        X = 450,
        Y = nil,
        R = 10,
        colorFadeG = 0,
        colorFadeB = 0,
    }




function ux.load()
    
end

function ux.update(dt)
    
        
        percent = -concern.level


end

function ux.draw()
    
    if concern.level >= 0 then
        BAR.progress = love.graphics.rectangle("fill", (winWidth/2-BAR.W/2) - BAR.X, winHeight/2+BAR.H/2, BAR.W, percent)
    end

    BAR.TEMPLATE = love.graphics.rectangle("line", (winWidth/2-BAR.W/2) - BAR.X, winHeight/2-BAR.H/2, BAR.W, BAR.H)

end



return ux 