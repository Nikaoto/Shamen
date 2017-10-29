package.path = package.path .. ";../?.lua"

sound = {}
sound.music = love.audio.newSource("res/bgmusic.mp3",  "stream")
sound.totem_drop = love.audio.newSource("res/totem_drop.wav", "static")
sound.totem_stack = love.audio.newSource("res/totem_stack.wav", "static")
sound.totem_break = love.audio.newSource("res/totem_break.wav", "static")
sound.wind = love.audio.newSource("res/wind.wav", "static")
sound.fireball = love.audio.newSource("res/fireball.wav", "static")

function sound:load()
	sound.music:setLooping(true)
	sound.music:setVolume(0.5)
	sound.music:play()
end