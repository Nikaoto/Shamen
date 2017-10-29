package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
require "obj/Totem"

RootTotem = Totem:extend()
RootTotem.sprite = love.graphics.newImage("res/totem_root.png")

function RootTotem:new(name, coords, areal, color, sprite)
  RootTotem.super.new(self, name, coords, areal, color, RootTotem.sprite)
  self.rooted = true
  self.alpha = 100
  self.rootList = {}
end

function RootTotem:update(dt)
	RootTotem.super.update(self, dt)
	--
	if not self.silenced then
		self:cast(dt)
	else
		self:clearRootList()
	end
end

function RootTotem:drawAreal()
	if self.complete then
		self.color[4] = self.alpha
		deep:ellipseC(self.color, "fill", self.x + self.ox, self.y + self.oy, Totem.AREAL_Z, self.arealX, self.arealY)
	end
end

function RootTotem:clearRootList()
	for k, v in pairs(self.rootList) do
		v.rooted = false
	end
	self.rootList = {}
end


function RootTotem:destroy(shouldEmitParticles)
	RootTotem.super.destroy(self, shouldEmitParticles)
	self:clearRootList()
end


function RootTotem:cast(dt)
	if self.shook and not self.dead then
		--Check players
		if self.name == player1.name then
			if player2:inAreal(self.x, self.z, self.arealX, self.arealY)
			 and not player2.rooted then
				table.insert(self.rootList, player2)
			end
		end
		if self.name == player2.name then
			if player1:inAreal(self.x, self.z, self.arealX, self.arealY) 
			 and not player1.rooted then
				table.insert(self.rootList, player1)
			end
		end
		--Check totems
		for _, v in pairs(Player.allTotems) do
			if v:inAreal(self.x, self.z, self.arealX, self.arealY)
			 and not v.rooted then
				table.insert(self.rootList, v)
			end
		end

		for k, v in pairs(self.rootList) do
			v.rooted = true
		end
	end
end