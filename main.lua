package.path = package.path .. ";../?.lua"

require "obj/Player"
require "lib/deep"
require "ui"
screen = require "lib/shack"

local p1
local p2

local red = {255, 0, 0}
local green = {0, 255, 0}

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

function love.load()
	screen:setDimensions(screenWidth, screenHeight)
	love.window.setMode(screenWidth, screenHeight, _)
	love.window.setFullscreen(isFullscreen)
	p1 = Player(love.graphics.newImage("res/sprite.png"), red, love.joystick.getJoysticks()[1],
		{x = 200, y = 200})
	p2 = Player(love.graphics.newImage("res/sprite2.png"), green, love.joystick.getJoysticks()[2], {x = 300, y = 300})
end

function love.update(dt)
	screen:update(dt)
	p1:update(dt)
	p2:update(dt)
	ui:update(p1:getStats(), p2:getStats())
end

function love.draw()
	screen:apply()
	world:draw()
	p1:draw()
	p2:draw()
	local x, y = p1:getCoords()
	
	love.graphics.print(love.timer.getFPS().." FPS")
	deep:draw()
	ui:draw()
end

function love.joystickpressed(joystick, button)
	p1:joystickpressed(joystick, button)
	p2:joystickpressed(joystick, button)
end
