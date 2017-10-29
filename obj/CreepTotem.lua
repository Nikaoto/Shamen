package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
require "obj/Totem"

CreepTotem = Totem:extend()

CreepTotem.sprite = love.graphics.newImage("res/totem_creep.png")

function CreepTotem:new(name, coords, areal, color, sprite)
  CreepTotem.super.new(self, name, coords, areal, color, CreepTotem.sprite)
end

function CreepTotem:cast()
end
