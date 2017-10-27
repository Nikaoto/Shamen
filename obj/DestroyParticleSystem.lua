package.path = package.path .. ";../?.lua"
Object = require "lib/classic"

DestroyParticleSystem = Object:extend()

function DestroyParticleSystem:new(coords)
  self.x , self.y = coords.x , coords.y
	self.psystem = love.graphics.newParticleSystem(getBubble(25, {130, 82, 1}), 32)
	self.psystem:setSpeed(-210,210)
  self.psystem:setParticleLifetime(0.4, 0.6)
	self.psystem:setSizeVariation(1)
	self.psystem:setAreaSpread("normal",10,10)
	self.psystem:setLinearAcceleration(0, 1000, 0, 2000)
	self.psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0)
  self.psystem:setRelativeRotation(true)
  self.psystem:setRotation(0,270)
end

function DestroyParticleSystem:draw()
	love.graphics.draw(self.psystem, self.x, self.y)
end

function DestroyParticleSystem:update(dt)
	self.psystem:update(dt)
end

function DestroyParticleSystem:emit(pN)
  self.psystem:emit(pN)
end

function getBubble(size,color)
  color = color or {124,104,255}
  local bubble = love.graphics.newCanvas(size, size)
  love.graphics.setCanvas(bubble)
  love.graphics.setColor(color)
  --TODO vertex
  love.graphics.ellipse("fill", size, size, size/2, size/4)
  love.graphics.setCanvas()
  return bubble
end
