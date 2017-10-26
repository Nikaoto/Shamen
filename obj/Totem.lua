package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
tween = require "lib/tween"
--screen = require "lib/shack"
require "lib/deep"

Totem = Object:extend()

Totem.WIDTH = 50
Totem.HEIGHT = 50
Totem.DEFAULT_AREAL_SIZE = 60
Totem.DEFAULT_COLOR = {0, 255, 255}
Totem.DEFAULT_FALL_TIME = 0.08
Totem.DEFAULT_SHAKE_AMOUNT = 30

function Totem:new(coords, areal, color)
  self.areal = areal or Totem.DEFAULT_AREAL_SIZE
  self.color = color or Totem.DEFAULT_COLOR
  self.startY = coords.y - screenHeight
  self.endY = coords.y
  self.x , self.y , self.z = coords.x , self.startY , coords.z
  self.width = Totem.WIDTH
  self.height = Totem.HEIGHT
  self.tween = tween.new(Totem.DEFAULT_FALL_TIME, self, { y = coords.y }, tween.easing.expoIn)
  return self
end

function Totem:draw()
  deep:rectangleC(self.color, "fill", self.x, self.y, self.z, self.width, self.height)
  --deep:ellipseC(self.color, "line", self.x, self.y, self.z, self.areal, self.areal / 2)
end

function Totem:update(dt)
  local complete = self.tween:update(dt)
  if complete and not self.shook then
    screen:setShake(Totem.DEFAULT_SHAKE_AMOUNT)
    self.shook = true
  end

  print("totem table " .. self.x .. "; ".. self.y)
end

function Totem:animate()
end

function Totem:cast()
end

-- setter / getters
function Totem:setAreal()
end
