package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
local tween = require "lib/tween"
require "lib/deep"
require "obj/StackParticleSystem"
require "obj/DestroyParticleSystem"

Totem = Object:extend()

Totem.WIDTH = 45
Totem.HEIGHT = 55
Totem.DEPTH = 55
Totem.AREAL_Z = 2
Totem.AREAL_SIZE_X = 180
Totem.AREAL_SIZE_Y = 90
Totem.DEFAULT_COLOR = {0, 255, 255}
Totem.FALL_TIME = 0.2
Totem.SHAKE_AMOUNT = 20
Totem.DAMAGE_AMOUNT = 15
Totem.MAX_STACKED_TOTEMS = 4
Totem.ENEMY_STACK_DESTROY_COUNT = 2 --num of totems destroyed when dropping on stack
Totem.colors = {{255, 42, 0}, {30, 144, 255}, {139, 69, 19}, {124, 252, 0}}
Totem.MANA_COST = 25

function Totem:new(name, coords, areal, color, sprite)
	self.name = name
	self.arealX = Totem.AREAL_SIZE_X
	self.arealY = Totem.AREAL_SIZE_Y
	self.color = color or Totem.DEFAULT_COLOR
	self.arealColor = {color[1], color[2], color[3], 100}
	if sprite then
		self.sprite = sprite
		self.width = self.sprite:getWidth()
		self.height = self.sprite:getHeight()
	else
		self.width = Totem.WIDTH
		self.height = Totem.HEIGHT
	end
	self.depth = Totem.DEPTH

	self.ox = self.width / 2
	self.oy = self.height / 2
	self.sx, self.sy = 1, 1
	self.startY = coords.y - self.height*8
	self.endY = coords.y - self.height
	self.x , self.y , self.z = coords.x - self.ox , self.startY , math.floor(coords.z)
	self.endZ = math.ceil(self.endY + self.height)
	self.tween = tween.new(Totem.FALL_TIME, self, { y = self.endY })
end

function Totem:hitShaman(shaman)
	shaman:takeDamage(Totem.DAMAGE_AMOUNT)
	self:destroy(true)
end

function Totem:hitEnemyTotem(enemyTotem)
	self:destroy(true)
	enemyTotem:destroy(true)
end

-- Destroys totem  [TODO: (and totems under it until the lastIndexCount)]
function Totem:destroy(shouldEmitParticles)
	self.dead = true
	if shouldEmitParticles then
		table.insert(objectPool, DestroyParticleSystem({x = self.x + self.ox, y = self.y - self.oy}))
	end
	self.totemBelow = nil
	self.totemAbove = nil
end

function Totem:log()
	deep:print("x = " .. self.x .. ", y = ".. self.y .. ", z = " .. self.z, self.x, self.y, self.z)
end

function Totem:drawPartSys()
	if not self.dead then
		if self.partsys then
			self.partsys:draw()
		end
	end
end

function Totem:draw()
	if self.sprite then
		deep:queue(self.sprite, self.x, self.y, self.z, _, self.sx, self.sy)
	else
		deep:rectangleC(self.color, "fill", self.x, self.y, self.z, self.width, self.height)
	end
	deep:circle("fill", self.x, self.y, self.z + 1, 5)
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

	if self.totemBelow then
		self.z = self.totemBelow.z
	else
		self.z = math.ceil(self.y + self.height)
	end

	if not self.dead then
		if self.partsys then
			self.partsys:update(dt)
		end
	end

	if not self.complete then
		-- Checking collisions with other totems
		for _, totem in pairs(Player.allTotems) do
			if tostring(totem) ~= tostring(self) and not totem.dead then
				if (self.x + self.width >= totem.x and self.x <= totem.x + totem.width)
					and (self.y + self.height >= totem.y and self.y <= totem.y + totem.height)
					and (self.endZ <= totem.z + totem.depth and self.endZ >= totem.z - totem.depth) then
					--print(totem); print(self)
					--self:printPos()
					if self.y < totem.y and not self.totemBelow then
						if totem.name == self.name then
							self:stackOnto(totem)
							print("STACK")
						else
							self:hitEnemyTotem(totem)
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
		self.shook = true
		screen:setShake(Totem.SHAKE_AMOUNT)
	end
end

function Totem:printPos()
	print("x = " .. self.x .. ", y = ".. self.y .. ", z = " .. self.z)
end

function Totem:stackOnto(totem)
	if totem.totemAbove then
		if totem.totemAbove.stackIndex < Totem.MAX_STACKED_TOTEMS then
			self:stackOnto(totem.totemAbove)
		else
			if self.name == player1.name then
				player1:activateSuper()
			else
				player2:activateSuper()
			end
		end
		return
	end

	if not self.totemBelow then
		print("stack "..tostring(self).." onto ".. tostring(totem))
		if totem.stackIndex == nil then totem.stackIndex = 1 end
		self.stackIndex = totem.stackIndex + 1
		self.partsys = StackParticleSystem({ x = totem.x + totem.ox , y = totem.y})
		self.y = totem.y - self.height
		self.z = totem.z
		self.x = totem.x
		totem.totemAbove = self
		self.totemBelow = totem
		self.partsys:emit(40)
	end

	print("stackindex = " .. self.stackIndex)
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
