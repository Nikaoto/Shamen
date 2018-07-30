package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
require "world"

DestroyParticleSystem = Object:extend()

DestroyParticleSystem.EMIT_DEFAULT = 30
DestroyParticleSystem.COLOR_DEFAULT = {0.504, 0.321, 0.003}
DestroyParticleSystem.SPAWN_TIME = 500
DestroyParticleSystem.SIZE = 20

-- Use only with object pool
function DestroyParticleSystem:new(coords, spawnTime, emmisionRate, size, color, rot, l1, l2)
  self.x , self.y = coords.x , coords.y
  self.spawnTime = spawnTime or DestroyParticleSystem.SPAWN_TIME
  self.size = size or DestroyParticleSystem.SIZE
	self.psystem = love.graphics.newParticleSystem(getBubble(self.size, color or DestroyParticleSystem.COLOR_DEFAULT), 32)
  self.emissionRate = emmisionRate or DestroyParticleSystem.EMIT_DEFAULT
  --self.psystem:setEmissionRate(self.emissionRate)
	self.psystem:setSpeed(-210, 210)
  self.psystem:setParticleLifetime(0.3, self.spawnTime / 1000)
	self.psystem:setSizeVariation(1)
	self.psystem:setAreaSpread("normal",10,10)
	self.psystem:setLinearAcceleration(0, l1 or 1000, 0, l2 or 2000)
	self.psystem:setColors(1, 1, 1, 1, 1, 1, 1, 0)
  self.psystem:setRelativeRotation(true)
  self.psystem:setRotation(math.rad(rot or 270))
  self.timer = self.spawnTime + getTime()
end

function DestroyParticleSystem:draw()
	love.graphics.draw(self.psystem, self.x, self.y)
end

function DestroyParticleSystem:update(dt)
  if getTime() < self.timer then
    self.psystem:update(dt)
    self:emit()
  else
    self.shouldDestroy = true
  end
end

function DestroyParticleSystem:setPosition(coords)
  self.x, self.y = coords.x, coords.y
end

function DestroyParticleSystem:emit(pN)
  if not self.emitted then
    self.emitted = true
    self.psystem:emit(pN or self.emissionRate)
  end
end

function getBubble(size, color)
  local color = color
  local bubble = love.graphics.newCanvas(size, size)
  love.graphics.setCanvas(bubble)
  love.graphics.setColor(color)
  --TODO vertex
  love.graphics.ellipse("fill", size, size, size/2, size/4)
  love.graphics.setCanvas()
  return bubble
end
