package.path = package.path .. ";../?.lua"
Object = require "lib/classic"

StackParticleSystem = Object:extend()

function StackParticleSystem:new(coords)
  self.x , self.y = coords.x , coords.y
	self.psystem = love.graphics.newParticleSystem(getBubble(15, {255,252,84}), 32)
	self.psystem:setSpeed(-210,210)
  self.psystem:setParticleLifetime(0.3, 0.5)
	self.psystem:setSizeVariation(0)
	self.psystem:setAreaSpread("ellipse",15,5)
	self.psystem:setLinearAcceleration(0, 200, 0, 300)
	self.psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0)
end

function StackParticleSystem:draw()
	love.graphics.draw(self.psystem, self.x, self.y)
end

function StackParticleSystem:update(dt)
	self.psystem:update(dt)
end

function getBubble(size,color)
  color = color or {124,104,255}
  local bubble = love.graphics.newCanvas(size, size)
  love.graphics.setCanvas(bubble)
  love.graphics.setColor(color)
  love.graphics.ellipse("fill", size/2, size/2, size/2, size/4)
  love.graphics.setCanvas()
  return bubble
end
