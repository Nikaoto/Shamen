package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
local tween = require "lib/tween"
require "lib/deep"

Totem = Object:extend()

Totem.WIDTH = 50
Totem.HEIGHT = 60
Totem.DEPTH = 60
Totem.AREAL_Z = 2
Totem.AREAL_SIZE_X = 150
Totem.AREAL_SIZE_Y = 100
Totem.DEFAULT_COLOR = {0, 255, 255}
Totem.FALL_TIME = 0.08
Totem.SHAKE_AMOUNT = 20

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
	self.tween = tween.new(Totem.FALL_TIME, self, { y = self.endY }, tween.easing.expoIn)

	local endZ = self.endY + self.height
	self:checkFall(endZ)
end

function Totem:checkFall(endZ)
	for playerNum, totem in pairs(Player.allTotems) do
		if (self.x + self.ox >= totem.x - totem.ox and self.x - self.ox <= totem.x + totem.ox) 
			and (endZ <= totem.z + totem.depth and endZ >= totem.z - totem.depth) then 
			if totem.name == self.name then
				print("STACK")
			else
				print("BREAK")
			end
		end
	end
end

function Totem:log()
	deep:print("x = " .. self.x .. ", y = ".. self.y .. ", z = " .. self.z, self.x, self.y, self.z)
end

function Totem:draw()
	deep:circle("fill", self.x + self.ox, self.y + self.oy, self.z + 1, 5)
	deep:rectangleC(self.color, "fill", self.x, self.y, self.z, self.width, self.height)
	if self.complete then
		deep:ellipseC(self.color, "line", self.x + self.ox, self.y + self.oy, Totem.AREAL_Z, self.arealX, self.arealY)
	end
	--self:log()
end

function Totem:getPosition()
	--TODO change after adding sprite and drawing with OX and OY in deep:queue
	return self.x + self.ox, self.y + self.oy, self.z
end

function Totem:getSize()
	return self.width, self.height, self.depth
end

function Totem:update(dt)
	self.complete = self.tween:update(dt)
	self.z = math.floor(self.y + self.height)
	if self.complete and not self.shook then
		screen:setShake(Totem.SHAKE_AMOUNT)
		self.shook = true
	end
end

function Totem:animate()
end

function Totem:cast()
end

-- setter / getters
function Totem:setAreal()
end
