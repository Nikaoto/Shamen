package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
tween = require "lib/tween"
--screen = require "lib/shack"
require "lib/deep"

Totem = Object:extend()

Totem.WIDTH = 50
Totem.HEIGHT = 70
Totem.DEFAULT_AREAL_Z = 2
Totem.DEFAULT_AREAL_SIZE = 60
Totem.DEFAULT_COLOR = {0, 255, 255}
Totem.DEFAULT_FALL_TIME = 0.08
Totem.DEFAULT_SHAKE_AMOUNT = 20

function Totem:new(coords, areal, color)
  self.areal = areal or Totem.DEFAULT_AREAL_SIZE
  self.color = color or Totem.DEFAULT_COLOR
  self.arealColor = {color[1], color[2], color[3], 100}
  self.width = Totem.WIDTH
  self.height = Totem.HEIGHT

  self.ox = self.width / 2
  self.oy = self.height / 2
  self.startY = coords.y - screenHeight
  self.endY = coords.y - self.height
  self.x , self.y , self.z = coords.x - self.ox , self.startY , math.floor(coords.z)
  self.tween = tween.new(Totem.DEFAULT_FALL_TIME, self, { y = self.endY }, tween.easing.expoIn)
  return self
end

function Totem:log()
  deep:print("x = " .. self.x .. ", y = ".. self.y .. ", z = " .. self.z, self.x, self.y, self.z)
end

function Totem:draw()
  deep:rectangleC(self.color, "fill", self.x, self.y, self.z, self.width, self.height)
  if self.complete then
    deep:ellipseC(self.color, "line", self.x + self.ox, self.y + self.oy, Totem.DEFAULT_AREAL_Z, self.areal, self.areal / 2)
  end
  self:log()
end

function Totem:update(dt)
  self.complete = self.tween:update(dt)
  self.z = math.floor(self.y + self.height)
  if self.complete and not self.shook then
    screen:setShake(Totem.DEFAULT_SHAKE_AMOUNT)
    self.shook = true
  end
end

function Totem:animate()
end

function Totem:cast()
end

-- setter / getters
function Totem:setAreal()
end
