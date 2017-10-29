package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
require "obj/Totem"
require "lib/deep"
require "obj/Fireball"
local tween = require "lib/tween"

FireTotem = Totem:extend()
FireTotem.sprite = love.graphics.newImage("res/totem_fire.png")
FireTotem.fireballSprite = love.graphics.newImage("res/fireball.png")
FireTotem.ballSpeed = 700
FireTotem.fireInterval = 250

function FireTotem:new(name, coords, areal, color, sprite)
	FireTotem.super.new(self, name, coords, areal, color, FireTotem.sprite)
	self.fireballs = {}
	self.timer = 0
end

function FireTotem:update(dt)
	FireTotem.super.update(self,dt)
	if self:isCooledDown() then
		if self.name == player1.name then
			if player2:inAreal(self.x, self.z, self.arealX, self.arealY) then
	    		self:cast(player2)
	    	end
	    elseif player1:inAreal(self.x, self.z, self.arealX, self.arealY) then
			self:cast(player1)
		end
  	end 
	self:updateFireballs(dt)
end

function FireTotem:isCooledDown()
	if getTime() - self.timer >= FireTotem.fireInterval then
		self.timer = getTime() + FireTotem.fireInterval
		return true
	else
		return false
	end
end

function FireTotem:cast(destObj)
	table.insert(self.fireballs, 
		Fireball({x = self.x + self.ox, y = self.y + self.oy}, destObj))
end

function FireTotem:updateFireballs(dt)
	for k, v in pairs(self.fireballs) do
		v:update(dt)
		if v.targetHit then
			table.remove(self.fireballs, k)
		end
	end
end

function FireTotem:draw()
	FireTotem.super.draw(self)
	self:drawFireballs()
end

function FireTotem:drawFireballs()
	for k, v in pairs(self.fireballs) do
		v:draw()
	end
end
