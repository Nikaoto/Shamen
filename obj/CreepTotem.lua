package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
require "obj/Totem"
require "obj/HealingParticleSystem"

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

function CreepTotem:checkShake(dt)
	if self.complete and not self.shook then --redundant first part, leave for readability
		if player1:willCollideWith(self.x, self.ox, self.z, self.depth) then
			self:hitShaman(player1)
		elseif player2:willCollideWith(self.x, self.ox, self.z, self.depth) then
			self:hitShaman(player2)
		end
		self.shook = true
		self.healpartsys = HealingParticleSystem({x = self.x + self.ox, y = self.z - self.depth/2})
		screen:setShake(Totem.SHAKE_AMOUNT)
	end
end

function CreepTotem:updatePartSys(dt)
	if not self.dead then
		if self.partsys then
			self.partsys:update(dt)
		end
		if self.healpartsys then
			self.healpartsys:update(dt)
		end
	end
end


function CreepTotem:drawPartSys()
	if not self.dead then
		if self.partsys then
			self.partsys:draw()
		end
		if self.healpartsys then
			self.healpartsys:draw()
		end
	end
end