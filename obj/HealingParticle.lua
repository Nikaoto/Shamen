package.path = package.path .. ";../?.lua"
Object = require "lib/classic"

HealingParticleSystem = Object:extend()

function HealingParticleSystem:new(coords)
  self.x , self.y = coords.x , coords.y
	self.psystem = love.graphics.newParticleSystem(getBubble(15), 800)
	self.psystem:setSpeed(-210,110)
  self.psystem:setEmissionRate(50)
  self.psystem:setParticleLifetime(0.5, 0.9)
	self.psystem:setSizeVariation(0)
	self.psystem:setAreaSpread("uniform",145,60)
	self.psystem:setLinearAcceleration(0, 500, 0, 700)
	self.psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0)
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
  color = color or {121,229,39}
  local bubble = love.graphics.newCanvas(size, size)
  love.graphics.setCanvas(bubble)
  love.graphics.setColor(color)
  love.graphics.ellipse("fill", size/2, size/2, size/2, size/4)
  love.graphics.setCanvas()
  return bubble
end
