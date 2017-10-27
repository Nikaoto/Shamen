package.path = package.path .. ";../?.lua"

require "obj/Player"
require "lib/deep"
require "ui"
screen = require "lib/shack"

local red = {255, 0, 0}
local green = {0, 255, 0}
local blue = {0, 0, 255}

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

function love.load()
	screen:setDimensions(screenWidth, screenHeight)
	love.window.setMode(screenWidth, screenHeight, _)
	love.window.setFullscreen(isFullscreen)
	local joys = love.joystick.getJoysticks()
	player1 = Player("1", love.graphics.newImage("res/sprite.png"), red, joys[1], {x = 200, y = 200})
	player2 = Player("2", love.graphics.newImage("res/sprite2.png"), blue, joys[2], {x = 300, y = 300})
end

function love.update(dt)
	screen:update(dt)
	player1:update(dt)
	player2:update(dt)
	ui:update(player1:getStats(), player2:getStats())
end

function love.draw()
	screen:apply()
	world:draw()
	player1:draw()
	player2:draw()
	local x, y = player1:getCoords()
	
	love.graphics.print(love.timer.getFPS().." FPS")
	deep:draw()
	ui:draw()
end

function love.joystickpressed(joystick, button)
	player1:joystickpressed(joystick, button)
	player2:joystickpressed(joystick, button)
end
