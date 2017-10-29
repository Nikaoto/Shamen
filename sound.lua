package.path = package.path .. ";../?.lua"

sound = {}
sound.music = love.audio.newSource("res/bgmusic.mp3")
sound.totem_drop = love.audio.newSource("res/totem_drop.wav")
sound.totem_stack = love.audio.newSource("res/totem_stack.wav")
sound.totem_break = love.audio.newSource("res/totem_break.wav")
sound.wind = love.audio.newSource("res/wind.wav")
sound.fireball = love.audio.newSource("res/fireball.wav")

function sound:load()
	sound.music:setLooping(true)
	sound.music:setVolume(0.5)
	sound.music:play()
end