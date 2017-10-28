package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
require "obj/Totem"

CreepTotem = Totem:extend()


function CreepTotem:new(name, coords, areal, color, sprite)
  local currentSprite = love.graphics.newImage("res/totem_creep.png")
  CreepTotem.super.new(self, name, coords, areal, color, currentSprite)
end

function CreepTotem:cast()
end

CreepTotem.__tostringx = function (p)
    return ""
end

CreepTotem.__tostring = CreepTotem.__tostringx
