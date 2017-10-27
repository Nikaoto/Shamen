package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
local tween = require "lib/tween"
require "lib/deep"
require "obj/StackParticleSystem"

Totem = Object:extend()

Totem.WIDTH = 45
Totem.HEIGHT = 50
Totem.DEPTH = 50
Totem.AREAL_Z = 2
Totem.AREAL_SIZE_X = 150
Totem.AREAL_SIZE_Y = 100
Totem.DEFAULT_COLOR = {0, 255, 255}
Totem.FALL_TIME = 0.08
Totem.SHAKE_AMOUNT = 20
Totem.DAMAGE_AMOUNT = 15

function Totem:new(name, coords, areal, color)
	self.name = name
	self.arealX = Totem.AREAL_SIZE_X
	self.arealY = Totem.AREAL_SIZE_Y
	self.color = color or Totem.DEFAULT_COLOR
	self.arealColor = {color[1], color[2], color[3], 100}
	self.width = Totem.WIDTH
	self.height = Totem.HEIGHT
	self.depth = Totem.DEPTH

	self.ox = self.width / 2
	self.oy = self.height / 2
	self.startY = coords.y - screenHeight
	self.endY = coords.y - self.height
	self.x , self.y , self.z = coords.x - self.ox , self.startY , math.floor(coords.z)
	--self.destroyPartSys = 
	self.endZ = math.ceil(self.endY + self.height)
	self.tween = tween.new(Totem.FALL_TIME, self, { y = self.endY }, tween.easing.expoIn)
end

function Totem:stack(totem)
	if not self.stacked then
		self.stacked = true
		self.partsys = StackParticleSystem({ x = totem.x + totem.ox , y = totem.y}) --TODO change here (rm totem.oy)
		self.y = totem.y - self.height
		self.totemBelow = totem
		self.partsys:emit(40)
	elseif not totem.stacked then
		totem.stacked = true
		totem.partsys = StackParticleSystem({ x = self.x + self.ox , y = self.y}) --TODO change here (rm totem.oy)
		totem.y = self.y - self.height
		totem.totemBelow = self
		totem.partsys:emit(40)
	end
end

function Totem:hitShaman(shaman)
	shaman:takeDamage(Totem.DAMAGE_AMOUNT)
	self:destroy(true)
end

function Totem:destroy(shouldEmitParticles)
	if shouldEmitParticles then
		print("PARTEMIT")
		--emit destroy particles
	end
	print("Totem destroy")
	self.dead = true
end

function Totem:log()
	deep:print("x = " .. self.x .. ", y = ".. self.y .. ", z = " .. self.z, self.x, self.y, self.z)
end

function Totem:drawPartSys()
	if self.partsys and not self.dead then
		self.partsys:draw()
	end
end

function Totem:draw()
	deep:circle("fill", self.x, self.y, self.z + 1, 5)
	deep:rectangleC(self.color, "fill", self.x, self.y, self.z, self.width, self.height)
	if self.complete then
		deep:ellipseC(self.color, "line", self.x + self.ox, self.y + self.oy, Totem.AREAL_Z, self.arealX, self.arealY)
	end
	--self:log()
end

Totem.__tostringx = function (p)
    Totem.__tostring = nil    
    local s = "Totem " .. tostring(p)                                                                                                                                                                                                    
    Totem.__tostring = Totem.__tostringx
    return s
end
Totem.__tostring = Totem.__tostringx

function Totem:update(dt)
	if not self.complete then
		self.complete = self.tween:update(dt)
	end
	self.z = math.ceil(self.y + self.height)

	if self.partsys and not self.dead then
		self.partsys:update(dt)
	end

	if not self.complete then
		-- Checking collisions with other totems
		for _, totem in pairs(Player.allTotems) do
			if (self.x + self.ox >= totem.x - totem.ox and self.x - self.ox <= totem.x + totem.ox)
				and (self.y + self.height >= totem.y and self.y <= totem.y + totem.height)
				and (self.endZ <= totem.z + totem.depth and self.endZ >= totem.z - totem.depth) then
				if tostring(totem) ~= tostring(self) then
					if totem.name == self.name then
						self.complete = true
						self:stack(totem)
						print("STACK")
					else
						print("BREAK")
					end
				end
			end
		end
	end

	if self.complete and not self.shook then --redundant first part, leave for readability
		if player1:willCollideWith(self.x, self.ox, self.z, self.depth) then
			self:hitShaman(player1)
		elseif player2:willCollideWith(self.x, self.ox, self.z, self.depth) then
			self:hitShaman(player2)
		end
--[[
		if self.totemBelow then
			self.y = self.totemBelow.y - self.height
			self.z = math.floor(self.totemBelow.z - self.height)
		end--]]

		self.shook = true
		screen:setShake(Totem.SHAKE_AMOUNT)
	end
end

function Totem:animate()
end

function Totem:cast()
end

-- setter / getters
function Totem:setAreal()
end

function Totem:getPosition()
	--TODO change after adding sprite and drawing with OX and OY in deep:queue
	return self.x + self.ox, self.y + self.oy, self.z
end

function Totem:getSize()
	return self.width, self.height, self.depth
end

