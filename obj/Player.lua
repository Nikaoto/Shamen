package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
require "world"
require "obj/Totem"

Player = Object:extend()

Player.allTotems = {}

Player.AXIS_LX = 1
Player.AXIS_LY = 2
Player.AXIS_RX = 4
Player.AXIS_RY = 3
Player.Y_MOVE_MOD = 0.85
Player.DEFAULT_SPEED = 400

Player.controls = {
	TOTEM_1 = 6,
	TOTEM_2 = 5,
	TOTEM_3 = 8,
	TOTEM_4 = 7,
}

Player.HP_DEFAULT = 100
Player.MP_DEFAULT = 100
Player.AIM_LIMIT_OFFSET = 15
Player.AIM_SPEED = 800
Player.AIM_HIDE_INTERVAL = 3000

function Player:new(name, sprite, color, joystick, coords)
	self.name = name
	self.sprite = sprite
	self.joystick = joystick

	self.speed = Player.DEFAULT_SPEED
	self.hp = Player.HP_DEFAULT
	self.mp = Player.MP_DEFAULT

	self.totems = {}

	if #color == 3 then
		self.color = {color[1], color[2], color[3], 255}
	else
		self.color = color
	end

	self.width = self.sprite:getWidth()
	self.height = self.sprite:getHeight()

	self.x, self.y = coords.x, coords.y
	self.z = math.floor(coords.y + self.height)

	self.ox = self.width / 2
	self.oy = self.height / 2
	self.sx, self.sy = 1, 1
	self.r = 0
	

	self.anim = {
		walk = {
			timer = 0,
			interval = 100,
			isUp = false,
			dr = 7,
		},
	}

	self.aim = {
		x = self.x,
		y = self.y,
		z = world.maxZ,
		radius = 10,
		speed = Player.AIM_SPEED,
		hideTime = 0,
		hideInterval = Player.AIM_HIDE_INTERVAL,
		color = {255, 255, 255, 200},
		shouldShow = false,
	}
end

function Player:draw()
	if not self.dead then
		self:drawAim()
		for _, v in pairs(self.totems) do
			v:draw()
		end
		deep:circle("fill", self.x, self.y, self.z + 1, 5)
		deep:queue(self.sprite, self.x, self.y, self.z, math.rad(self.r), self.sx, self.sy,
			self.ox, self.oy)
		self:animate()
	else
		deep:printC(self.aim.color, "RIP", self.x, self.y, self.z)
	end
end

function Player:update(dt)
	if not self.dead then
		self:move(dt)
		self:handleAim(dt)
		for _, v in pairs(self.totems) do
			v:update(dt)
		end
	end
	self:clearDeadTotems()
end

function Player:move(dt)
	local nextX = self.x + self:getAxis(Player.AXIS_LX) * dt * self.speed
	local nextY = self.y + self:getAxis(Player.AXIS_LY) * dt * self.speed * Player.Y_MOVE_MOD
	
	if nextX > world.limitLeft and nextX < world.limitRight then
		self.x = nextX
	end

	if nextY > world.limitTop and nextY < world.limitBottom then
		self.y = nextY
		self.z = math.ceil(self.y + self.oy)
	end
end

-- Used to detect totem fall collision
function Player:willCollideWith(x, ox, z, depth)
	return (self.x + self.ox >= x - ox and self.x - self.ox <= x + ox) 
		and (self.z <= z + depth and self.z >= z - depth)
end

function Player:drawPartSys()
	for _, totem in pairs(self.totems) do
		totem:drawPartSys()
	end
end

function Player:clearDeadTotems()
	local temp1 = {}
	for k, v in pairs(self.totems) do
		if v.dead then
			print("totem dead, removing")
			table.remove(self.totems, k)
		end
	end

	for k, v in pairs(Player.allTotems) do
		if v.dead then
			table.remove(Player.allTotems, k)
		end
	end
end

function Player:activateSuper()
	print(self.name .. " activated super")
end

function Player:takeDamage(amount)
	self.hp = self.hp - amount
	self:checkDeath()
end

function Player:drainMana(amount)
	self.mp = self.mp - amount
	if self.mp <= 0 then
		self.mp = 0
	end
end

function Player:checkDeath()
	if self.hp <= 0 then
		self.dead = true 
	end
end

function Player:getStats()
	return {hp = self.hp, mp = self.mp}
end

function Player:log()
	love.graphics.print("\nx = "..self.x..", y = "..self.y..", z = "..self.z)
end

function Player:isMoving()
	return self:getAxis(Player.AXIS_LX) ~= 0 or self:getAxis(Player.AXIS_LY) ~= 0
end

function Player:handleAim(dt)
	if self:isPressingAnyButton() or self:isAiming() then
		-- update timer
		self.aim.hideTime = getTime() + self.aim.hideInterval

		self.aim.shouldShow = true
		local nextX = self.aim.x + self:getAxis(Player.AXIS_RX) * self.aim.speed * dt
		local nextY = self.aim.y + self:getAxis(Player.AXIS_RY) * self.aim.speed * dt * Player.Y_MOVE_MOD

		if nextX > world.limitLeft and nextX < world.limitRight then
			self.aim.x = nextX
		end

		if nextY > world.limitTop + Player.AIM_LIMIT_OFFSET 
			and nextY < world.limitBottom - Player.AIM_LIMIT_OFFSET then
			self.aim.y = nextY
		end
	end

	if getTime() > self.aim.hideTime then
		self.aim.shouldShow = false
		self:resetAim()
	end
end

function Player:drawAim()
	if self.aim.shouldShow then
		local l = 35
		local mod = 1/3
		deep:ellipseC(self.aim.color, "fill", self.aim.x, self.aim.y, self.aim.z,
			self.aim.radius*2, self.aim.radius)
		deep:setColor(self.color)
		deep:line(self.aim.x, self.aim.y - l, self.aim.x, self.aim.y, self.aim.z + 1)
		deep:line(self.aim.x - l*mod*0.75, self.aim.y - l*mod, self.aim.x, self.aim.y, self.aim.z + 1)
		deep:line(self.aim.x + l*mod*0.75, self.aim.y - l*mod, self.aim.x, self.aim.y, self.aim.z + 1)
		deep:setColor()
	end
end

function Player:resetAim()
	self.aim.x = self.x
	self.aim.y = self.y
end

function Player:isAiming(deadzone)
	deadzone = deadzone or 0
	if math.abs(self:getAxis(Player.AXIS_RX)) > deadzone
		or math.abs(self:getAxis(Player.AXIS_RY)) > deadzone then
		return true
	end
end

function Player:animate()
	if self:isMoving() then
		if getTime() - self.anim.walk.timer >= self.anim.walk.interval then
			if self.anim.walk.isUp then
				self:setRotation(-self.anim.walk.dr)
				self.anim.walk.isUp = false
			else
				self:setRotation(self.anim.walk.dr)
				self.anim.walk.isUp = true
			end
			self.anim.walk.timer = getTime()
		end
	elseif self.anim.walk.isUp then
		self.anim.walk.isUp = false
		self:setRotation()
	else
		self:setRotation()
	end

end

function Player:dropTotem(totemIndex)
	if self.mp >= Totem.MANA_COST then
		if totemIndex == 1 then
			local newTotem = Totem(self.name, { x = self.aim.x, y = self.aim.y, z = self.z }, 200, 
				self:totemColor(totemIndex), love.graphics.newImage("res/totem_fire.png"))
			table.insert(Player.allTotems, newTotem)
			table.insert(self.totems, newTotem)
		else
			local newTotem = Totem(self.name, { x = self.aim.x, y = self.aim.y, z = self.z }, 200, 
				self:totemColor(totemIndex))
			table.insert(Player.allTotems, newTotem)
			table.insert(self.totems, newTotem)
		end
		self:drainMana(Totem.MANA_COST)
	end
end

function Player:totemColor(totemIndex)
	if totemIndex == 1 then
		return {255, 42, 0}
	elseif totemIndex == 2 then
		return {30, 144, 255}
	elseif totemIndex == 3 then
		return {139, 69, 19}
	elseif totemIndex == 4 then
		return {124, 252, 0}
	end
end

-- Joystick inputs --
function Player:getAxis(axisNum, deadzone)
	if not self.joystick then	return 0 end
	deadzone = deadzone or 0
	local ret = self.joystick:getAxis(axisNum)
	if math.abs(ret) > deadzone then
		return ret
	else
		return 0
	end
end

function Player:joystickpressed(joystick, button)
	if self.joystick and tostring(joystick) == tostring(self.joystick) then
		if button == Player.controls.TOTEM_1 then
			self:dropTotem(1)
		elseif button == Player.controls.TOTEM_2 then
			self:dropTotem(2)
		elseif button == Player.controls.TOTEM_3 then
			self:dropTotem(3)
		elseif button == Player.controls.TOTEM_4 then
			self:dropTotem(4)
		end
	end
end

function Player:isPressingAnyButton() 
	for k, v in pairs(Player.controls) do 
		if self.joystick:isDown(v) then return true end
	end

	return false
end

-- Getters and setters --
function Player:getCoords()
	return self.aim.x, self.aim.y
end

function Player:setRotation(rot)
	rot = rot or 0
	self.r = rot
end
