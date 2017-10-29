package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
require "obj/Totem"

RootTotem = Totem:extend()


function RootTotem:new(name, coords, areal, color, sprite)
  local currentSprite = love.graphics.newImage("res/totem_root.png")
  RootTotem.super.new(self, name, coords, areal, color, currentSprite)
end

function RootTotem:cast()
end