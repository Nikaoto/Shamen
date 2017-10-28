package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
require "obj/Totem"

FireTotem = Totem:extend()


function FireTotem:new(name, coords, areal, color, sprite)
  local currentSprite = love.graphics.newImage("res/totem_fire.png")
  FireTotem.super.new(self, name, coords, areal, color, currentSprite)
end

function FireTotem:cast()
end

FireTotem.__tostringx = function (p)
    return ""
end

FireTotem.__tostring = FireTotem.__tostringx
