package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
require "lib/deep"

Totem = Object:extend()

Totem.WIDTH = 50
Totem.HEIGHT = 50
Totem.DEFAULT_AREAL_SIZE = 60
Totem.DEFAULT_COLOR = {255, 255, 255}

function Totem:new(coords, color, areal)
  areal = areal or Totem.DEFAULT_AREAL_SIZE
  color = color or Totem.DEFAULT_COLOR

  self.x , self.y , self.z = coords.x , coords.y , coords.z
  self.width = Totem.WIDTH
  self.height = Totem.HEIGHT
end

function Totem:draw()
  deep:rectangleC("fill",self.x,self.z,self.width,self.height)
end

function Totem:update()
end

function Totem:cast()
end

function Totem:setAreal()
end
