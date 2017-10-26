package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
require "lib/deep"

Totem = Object:extend()

Totem.WIDTH = 50
Totem.HEIGHT = 50
Totem.DEFAULT_AREAL_SIZE = 60
Totem.DEFAULT_COLOR = {255, 255, 255}
Totem.DEFAULT_FALL_TIME = 0.08
Totem.DEFAULT_SHAKE_AMOUNT = 30

function Totem:new(coords,areal,startY,color)
  self.areal = areal or Totem.DEFAULT_AREAL_SIZE
  self.color = color or Totem.DEFAULT_COLOR

  self.x , self.y , self.z = coords.x , coords.y , coords.z
  self.width = Totem.WIDTH
  self.height = Totem.HEIGHT
end

function Totem:draw()
  deep:rectangleC(self.color, "fill", self.x, self.y, self.z, self.width, self.height)
  deep:ellipseC(self.color, "line", self.x, self.y, self.z, self.areal, self.areal / 2)
end

function Totem:update(dt)
end

function Totem:animate()
end

function Totem:cast()
end

-- setter / getters
function Totem:setAreal()
end
