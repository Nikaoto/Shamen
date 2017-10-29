package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
require "obj/Totem"

FireTotem = Totem:extend()
FireTotem.sprite = love.graphics.newImage("res/totem_fire.png")

function FireTotem:new(name, coords, areal, color, sprite)
  FireTotem.super.new(self, name, coords, areal, color, FireTotem.sprite)
end

function FireTotem:cast()

end