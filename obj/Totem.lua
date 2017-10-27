package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
local tween = require "lib/tween"
require "lib/deep"
require "obj/StackParticleSystem"
require "obj/DestroyParticleSystem"

Totem = Object:extend()

Totem.WIDTH = 40
Totem.HEIGHT = 50
Totem.DEPTH = 45
Totem.AREAL_Z = 2
Totem.AREAL_SIZE_X = 150
Totem.AREAL_SIZE_Y = 100
Totem.DEFAULT_COLOR = {0, 255, 255}
Totem.FALL_TIME = 0.08
Totem.SHAKE_AMOUNT = 20
Totem.DAMAGE_AMOUNT = 15
Totem.MAX_STACKED_TOTEMS = 4

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
	self.destroyPartSys = DestroyParticleSystem({x = self.x, y = self.y})
	self.endZ = math.ceil(self.endY + self.height)
	self.tween = tween.new(Totem.FALL_TIME, self, { y = self.endY }, tween.easing.expoIn)
end

function Totem:hitShaman(shaman)
	shaman:takeDamage(Totem.DAMAGE_AMOUNT)
	self:destroy(true)
end

function Totem:destroy(shouldEmitParticles)
	if shouldEmitParticles then
		self.destroyPartSys:setPosition({x = self.x + self.ox, y = self.y - self.oy})
		self.destroyPartSys:emit(20)
	end
	print("Totem destroy")
	self.dead = true
end

function Totem:log()
	deep:print("x = " .. self.x .. ", y = ".. self.y .. ", z = " .. self.z, self.x, self.y, self.z)
end

function Totem:drawPartSys()
	if not self.dead then

		if self.partsys then
			self.partsys:draw()
		end

		if self.destroyPartSys then
			self.destroyPartSys:draw()
		end
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

	if not self.dead then
		if self.partsys then
			self.partsys:update(dt)
		end
		if self.destroyPartSys then
			self.destroyPartSys:update(dt)
		end
	end

	if not self.complete then
		-- Checking collisions with other totems
		for _, totem in pairs(Player.allTotems) do
			if tostring(totem) ~= tostring(self) then
				if (self.x + self.width >= totem.x and self.x <= totem.x + totem.width)
					and (self.y + self.height >= totem.y and self.y <= totem.y + totem.height)
					and (self.endZ <= totem.z + totem.depth and self.endZ >= totem.z - totem.depth) then
					print(totem); print(self)
					self:printPos()
					if self.y < totem.y then
						if totem.name == self.name then
							
							self:stackOnto(totem)
							print("STACK")
						else
							--self:destroy(true)
							print("BREAK")
						end
					end
					self.complete = true
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

function Totem:printPos()
	print("x = " .. self.x .. ", y = ".. self.y .. ", z = " .. self.z)
end

function Totem:stackOnto(totem)
	--print("x = " .. self.x .. ", y = ".. self.y .. ", z = " .. self.z)
	if totem.totemAbove then
		if totem.totemAbove.stackIndex < Totem.MAX_STACKED_TOTEMS then
			self:stackOnto(totem.totemAbove)
			return
		else
			if self.name == player1.name then
				player1:activateSuper()
			else
				player2:activateSuper()
			end 
		end
	end

	if not self.totemBelow then
		if totem.stackIndex == nil then totem.stackIndex = 1 end
		self.stackIndex = totem.stackIndex + 1
		self.partsys = StackParticleSystem({ x = totem.x + totem.ox , y = totem.y}) --TODO change here (rm totem.oy)
		self.y = totem.y - self.height
		totem.totemAbove = self
		self.totemBelow = totem
		self.partsys:emit(40)
	end

	if self.stackIndex == Totem.MAX_STACKED_TOTEMS then
		self.superMode = true
	end
	print(self.stackIndex)
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

