local sound = {}
local hasPlayed = false

function sound.load()

    SFX= {}

    SFX.swoosh = {
        love.audio.newSource("assets/AUDIO/SFX/swoosh1.wav", 'static'),
        love.audio.newSource("assets/AUDIO/SFX/swoosh2.wav", 'static'),
        love.audio.newSource("assets/AUDIO/SFX/swoosh3.wav", 'static'),
        love.audio.newSource("assets/AUDIO/SFX/swoosh4.wav", 'static'),
        love.audio.newSource("assets/AUDIO/SFX/swoosh5.wav", 'static'),
        love.audio.newSource("assets/AUDIO/SFX/swoosh6.wav", 'static'),
    }
    
    SFX.doghurt = {
        love.audio.newSource("assets/AUDIO/SFX/doghurt1.wav", 'static'),
        love.audio.newSource("assets/AUDIO/SFX/doghurt2.wav", 'static'),
    }
    

end

function sound.play()
    local rndsnd = math.random(1, #SFX.swoosh)
    if not hasPlayed and speed > 3500 then
       SFX.swoosh[rndsnd]:play()
       hasPlayed = true
    elseif speed <= 3500 then
        hasPlayed = false
    end
end

function sound.doghurt()
   local dogrnd = math.random(1, #SFX.doghurt)
   SFX.doghurt[dogrnd]:play()
end

return sound