local TAU = math.pi * 2
local canvas
local particleSystem
local MS = 1
local PSIZE = 40

function loadWelcomeScreen()
  --titleImage = love.graphics.newImage("/res/title.png")
  font = love.graphics.newFont("res/shafont.ttf", 350)
  titleText = love.graphics.newText(font, "SHAMEN")
  textColor = {0,0,0}
  bgColor = {1.0, 0.51, 0.18, 0.74}
  bgoffset = 10
  love.graphics.setDefaultFilter('linear', 'linear', 4)

  canvas = love.graphics.newCanvas(PSIZE, PSIZE)

  canvas:renderTo(function()
    --love.graphics.clear(255,255,255,0)
    love.graphics.rectangle('fill', 0, 0, PSIZE, PSIZE)
    --love.graphics.circle('fill', PSIZE/2, PSIZE/2, PSIZE/2-2, 100)
    --love.graphics.polygon('fill', 1, 16, 30, 16, 16, 1)
  end)

  --canvas = love.graphics.newImage "particle.png"
  particleSystem = love.graphics.newParticleSystem(canvas, 4096)
  particleSystem:setParticleLifetime(0.1, 10)
  particleSystem:setEmissionRate(100)
  particleSystem:setSizes(1.5, 0.6)
  particleSystem:setLinearAcceleration(10, 10, -10, -10)
  particleSystem:setLinearDamping(0.2)
  particleSystem:setEmissionArea('uniform', screenWidth / 2, 0)
  particleSystem:setDirection(math.rad(90))
  particleSystem:setPosition(screenWidth/2, 0)
  particleSystem:setSpeed(410, 1000)
	particleSystem:setColors(0.388, 0.784, 0, 0.705,   0.5, 0, 0.98, 0.509,  0, 0, 0, 0)
  canvas = love.graphics.newCanvas(screenWidth * MS, screenHeight * MS)
end

function updateWelcomeScreen(dt)
  particleSystem:update(dt)
end

function drawSky()
	love.graphics.setColor(world.skyColor)
	love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
end

function drawWelcomeScreen()
  drawSky()
  canvas:renderTo(function()
    --love.graphics.clear(0,0,0,0.01)
    love.graphics.setBlendMode('subtract', 'premultiplied')
    love.graphics.setColor(0.015, 0.078, 255, 0.039)
    love.graphics.rectangle('fill', 0, 0, screenWidth * MS, screenHeight * MS)

    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(particleSystem)
  end)

  love.graphics.setBlendMode('alpha', 'alphamultiply')
  love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
  love.graphics.draw(canvas, 0, 0, 0, 1/MS, 1/MS)

--draw PRESS ANY KEY TO START GAME
  
  love.graphics.setColor(bgColor)
  love.graphics.rectangle("fill", 0, screenHeight/10 - bgoffset, screenWidth, titleText:getHeight() + bgoffset*2)
  love.graphics.setColor(textColor)
  love.graphics.draw(titleText, (screenWidth - titleText:getWidth()) / 2, screenHeight/10)
end