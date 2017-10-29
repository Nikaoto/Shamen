package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
require "obj/Totem"

CreepTotem = Totem:extend()

CreepTotem.sprite = love.graphics.newImage("res/totem_creep.png")

CreepTotem.HEAL_AMOUNT = 7

function CreepTotem:new(name, coords, areal, color, sprite)
  CreepTotem.super.new(self, name, coords, areal, color, CreepTotem.sprite)
end

function CreepTotem:update(dt)
	CreepTotem.super.update(self, dt)

	if self.name == player1.name then
		if player1:inAreal(self.x, self.z, self.arealX, self.arealY) then
			player1:takeDamage(-CreepTotem.HEAL_AMOUNT * dt)
		end
	elseif player2:inAreal(self.x, self.z, self.arealX, self.arealY) then
		player2:takeDamage(-CreepTotem.HEAL_AMOUNT * dt)
	end
end
