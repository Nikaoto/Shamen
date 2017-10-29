package.path = package.path .. ";../?.lua"
require "welcomescreen"
require "obj/Player"

require "ui"
require "sound"
require "lib/deep"
screen = require "lib/shack"


gameStart = false
local red = {255, 0, 0}
local green = {0, 255, 0}
local blue = {0, 0, 255}

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

	screen:setDimensions(screenWidth, screenHeight)
	love.window.setMode(screenWidth, screenHeight, _)
	love.window.setFullscreen(isFullscreen)
function love.load()
	sound:load()
	p1Sprite = love.graphics.newImage("res/sprite.png")
	p2Sprite = love.graphics.newImage("res/sprite3.png")
	loadWelcomeScreen()
	world:load()
end

function startGame()
	local joys = love.joystick.getJoysticks()
	player1 = Player("1", p1Sprite, red, joys[1], {x = 200, y = 400})
	player2 = Player("2", p2Sprite, blue, joys[2], {x = 1000, y = 400})
	gameStart = true
end

function love.update(dt)
	if not gameStart then
		updateWelcomeScreen(dt)
	else
		screen:update(dt)
		world:update(dt)
		if player1.update then
			player1:update(dt)
		end
		if player2.update then
			player2:update(dt)
		end
		if player1.getStats and player2.getStats then
			ui:update(player1:getStats(), player2:getStats(), dt)
		end
	end
end

function love.draw()
	if not gameStart then
		drawWelcomeScreen()
	else
		screen:apply()
		player1:draw()
		player2:draw()
		deep:draw()
		ui:draw()
		player1:drawPartSys()
		player2:drawPartSys()
		world:draw()
	end
end
 
function love.joystickpressed(joystick, button)
	if not gameStart then
		startGame()
	else
	   	player1:joystickpressed(joystick, button)
		player2:joystickpressed(joystick, button) 
	end
end

function resetGame()
	gameStart = false
	local joys = love.joystick.getJoysticks()
	player1 = Player("1", p1Sprite, red, joys[1], {x = 200, y = 400})
	player2 = Player("2", p2Sprite, blue, joys[2], {x = 1000, y = 400})
	Player.allTotems = {}
	loadWelcomeScreen()
end
