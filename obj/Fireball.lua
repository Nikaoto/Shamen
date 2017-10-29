package.path = package.path .. ";../?.lua"
Object = require "lib/classic"

Fireball = Object:extend()
Fireball.sprite = love.graphics.newImage("res/fireball.png")
Fireball.ballSpeed = 700
Fireball.DAMAGE_AMOUNT = 5
Fireball.RADIUS = 20

function Fireball:new(startPos, target)
  self.target = target
  self.x , self.y, self.z = startPos.x , startPos.y, startPos.z
  self.sound = love.audio.newSource("res/fireball.wav", "static")
  self.sound:play()
  self.radius = Fireball.RADIUS
end

function Fireball:draw()
  if not self.targetHit then
    deep:queue(Fireball.sprite, self.x, self.y, self.z + 1, 0)
  end
end

function Fireball:update(dt)
  if not self.targetHit then
    if self.x < self.target.x then
      self.x = self.x + (Fireball.ballSpeed * dt)
    end

    if self.x > self.target.x then
      self.x = self.x - (Fireball.ballSpeed * dt)
    end

    if self.y < self.target.y then
      self.y = self.y + (Fireball.ballSpeed * dt)
    end

    if self.y > self.target.y then
      self.y = self.y - (Fireball.ballSpeed * dt)
    end

    self.z = math.floor(self.y + self.radius)
    self:checkHitTarget(target)
  end
end

function Fireball:checkHitTarget(target)
  if dist(self.x, self.y, self.target.x, self.target.y) <= self.radius then
    print("HIT --")
    self.target:takeDamage(Fireball.DAMAGE_AMOUNT)
    self.targetHit = true
  end
end
