package.path = package.path .. ";../?.lua"
Object = require "lib/classic"

WindParticle = Object:extend()

function WindParticle:new(coords)
  self.x , self.y = coords.x , coords.y
	self.psystem = love.graphics.newParticleSystem(getBubble(12), 800)
	self.psystem:setSpeed(-700,700)
  self.psystem:setParticleLifetime(0.1, 0.25)
	self.psystem:setSizeVariation(1)
	self.psystem:setAreaSpread("normal",35,13)
  self.psystem:setRelativeRotation(true)
  self.psystem:setRotation(0, math.rad(360))
	--self.psystem:setLinearAcceleration(0, 10, 0, 20)
	self.psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0)
  self.timer = getTime() + 200
end

function WindParticle:draw()
	love.graphics.draw(self.psystem, self.x, self.y)
end

function WindParticle:update(dt)
  if(getTime() < self.timer) then
	   self.psystem:update(dt)
    self:emit(30)
  else
    self.shouldDestroy = true
  end
end

function WindParticle:emit(n)
  self.psystem:emit(n)
end

function getBubble(size,color)
  color = color or {230,235,237}
  local bubble = love.graphics.newCanvas(size, size)
  love.graphics.setCanvas(bubble)
  love.graphics.setColor(color)
  love.graphics.ellipse("fill", size/2, size/2, size/2, size/4)
  love.graphics.setCanvas()
  return bubble
end
