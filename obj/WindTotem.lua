package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
require "obj/Totem"

WindTotem = Totem:extend()


function WindTotem:new(name, coords, areal, color, sprite)
  local currentSprite = love.graphics.newImage("res/totem_wind.png")
  WindTotem.super.new(self, name, coords, areal, color, currentSprite)
end

function WindTotem:cast()
end