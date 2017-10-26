package.path = package.path .. ";../?.lua"

require "obj/Player"
require "lib/deep"
screen = require "lib/shack"

screenWidth = 1366
screenHeight = 768
isFullscreen = true

world = {
	limitTop = screenHeight*2/9,
	limitBottom = screenHeight,
	limitLeft = 0,
	limitRight = screenWidth,
	shake = 20,
}
world.zRange = world.limitBottom - world.limitTop

local p1
local p2

local red = {255, 0, 0}
local green = {0, 255, 0}

function love.keypressed()
	love.event.quit()
end

function love.load()
	screen:setDimensions(screenWidth, screenHeight)
	love.window.setMode(screenWidth, screenHeight, _)
	love.window.setFullscreen(isFullscreen)
	p1 = Player(love.graphics.newImage("res/sprite.png"), red, love.joystick.getJoysticks()[1], 
		100, 100, 50)
	p2 = Player(love.graphics.newImage("res/sprite.png"), green, love.joystick.getJoysticks()[2], 
		300, 300, 50)
end

function love.update(dt)
	screen:update(dt)
	p1:update(dt)
	p2:update(dt)
end

function love.draw()
	screen:apply()
	draw_world()
	p1:draw()
	p2:draw()
	
	love.graphics.print(love.timer.getFPS().." FPS")
	deep:draw()
end

function draw_world()
	deep:rectangleC({20, 80, 20}, "fill", 0, world.limitTop, 1, screenWidth, screenHeight)
end