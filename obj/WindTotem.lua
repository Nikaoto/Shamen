package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
require "obj/Totem"

WindTotem = Totem:extend()

WindTotem.PLAYER_KNOCKBACK = 200
WindTotem.TOTEM_KNOCKBACK = 300


function WindTotem:new(name, coords, areal, color, sprite)
  local currentSprite = love.graphics.newImage("res/totem_wind.png")
  WindTotem.super.new(self, name, coords, areal, color, currentSprite)
end

function WindTotem:update(dt)
	WindTotem.super.update(self, dt)
	--
	self:cast()
end

function WindTotem:updatePartSys(dt)
	if not self.dead then
		if self.partsys then
			self.partsys:update(dt)
		end
	end
end

function WindTotem:getKnockback(k, x, z)
	local d = dist(self.x, self.z, x, z)
	if d == 0 then d = 1 end

	return k / d
end

function WindTotem:cast()
	if self.shook and not self.dead then
		--Check players
		--if self.name ~= player1.name then
		if player1:inAreal(self.x, self.z, self.arealX, self.arealY) 
			 and not player1:isImpaired() then
			 	local p = self:getKnockback(WindTotem.PLAYER_KNOCKBACK, player1.x, player1.z)
				player1:push((player1.x - self.x)*p, (player1.z - self.z)*p)
		end

		if player2:inAreal(self.x, self.z, self.arealX, self.arealY) --elseif here
		 and not player2:isImpaired() then
		 	local p = self:getKnockback(WindTotem.PLAYER_KNOCKBACK, player2.x, player2.z)
			player2:push((player2.x - self.x) * p, (player2.z - self.z) * p)
		end

		--Check other totems
		for _, totem in pairs(Player.allTotems) do
			if totem ~= self and not totem.dead and not totem:is(RootTotem) then
				if totem:inAreal(self.x, self.z, self.arealX, self.arealY)
				 and not totem:isRooted() then
				 	local t = self:getKnockback(WindTotem.TOTEM_KNOCKBACK, totem.x, totem.z)
					totem:push((totem.x - self.x) * t, (totem.z - self.z) * t)
				end
			end
		end
	end
end