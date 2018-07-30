package.path = package.path .. ";../?.lua"
Object = require "lib/classic"

HealingParticleSystem = Object:extend()

function HealingParticleSystem:new(coords)
  self.x , self.y = coords.x , coords.y
	self.psystem = love.graphics.newParticleSystem(getBubble(15), 8000)
	self.psystem:setSpeed(0,0)
  self.psystem:setEmissionRate(0.98)
  self.psystem:setParticleLifetime(0.5, 0.9)
	self.psystem:setSizeVariation(0)
	self.psystem:setAreaSpread("ellipse", Totem.AREAL_SIZE_X, Totem.AREAL_SIZE_Y)
	self.psystem:setLinearAcceleration(0, -400, 0, -550)
	self.psystem:setColors(1, 1, 1, 1, 1, 1, 1, 0)
end

function HealingParticleSystem:draw()
	love.graphics.draw(self.psystem, self.x, self.y)
end

function HealingParticleSystem:update(dt)
  self.psystem:update(dt)
end

function HealingParticleSystem:emit(n)
  self.psystem:emit(n)
end

function getBubble(size,color)
  color = color or {0.474, 0.898, 0.152}
  local bubble = love.graphics.newCanvas(size, size)
  love.graphics.setCanvas(bubble)
  love.graphics.setColor(color)
  love.graphics.ellipse("fill", size/2, size/2, size/2, size/4)
  love.graphics.setCanvas()
  return bubble
end
