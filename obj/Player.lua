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

Player.BTN_4 = 5
Player.BTN_3 = 3
Player.BTN_2 = 2
Player.BTN_1 = 4

Player.HP_DEFAULT = 100
Player.MP_DEFAULT = 100
Player.AIM_LIMIT_OFFSET = 15
Player.AIM_SPEED = 1000
Player.AIM_HIDE_INTERVAL = 2500

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
		timer = 0,
		hideInterval = Player.AIM_HIDE_INTERVAL,
		color = {255, 255, 255},
		shouldShow = false,
	}
end

function Player:draw()
	for _, v in pairs(self.totems) do
		v:draw()
	end
	deep:circle("fill", self.x, self.y, self.z + 1, 5)
	deep:queue(self.sprite, self.x, self.y, self.z, math.rad(self.r), self.sx, self.sy,
		self.ox, self.oy)
	self:drawAim()
	self:animate()
end

function Player:update(dt)
	self:move(dt)
	self:actions()
	self:handleAim(dt)
	for _, v in pairs(self.totems) do
		v:update(dt)
	end
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
	if self:getButton(Player.BTN_4, Player.BTN_3, Player.BTN_2, Player.BTN_1) then
		self.aim.shouldShow = true
	else
		if not self.aim.shouldShow then
			self:resetAim()
		end

		if not self:isAiming() then
			if getTime() - self.aim.timer >= self.aim.hideInterval then
				self.aim.shouldShow = false
				self.aim.timer = getTime()
			end
		else
			self.aim.shouldShow = true
			self.aim.timer = getTime()

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
	end
end

function Player:drawAim()
	local l = 35
	local mod = 1/3
	if self.aim.shouldShow then
		deep:ellipseC(self.aim.color, "line", self.aim.x, self.aim.y, self.aim.z,
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

function Player:setRotation(rot)
	rot = rot or 0
	self.r = rot
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

function randColor()
	return {math.random(10, 255), math.random(10, 255), math.random(10, 255)}
end

function Player:actions()
	if self:getButton(Player.BTN_4) then
		local newTotem = Totem(self.name, { x = self.aim.x, y = self.aim.y, z = self.z }, 200, randColor())
		table.insert(Player.allTotems, newTotem)
		table.insert(self.totems, newTotem)
	end
end

function Player:getCoords()
	return self.aim.x, self.aim.y
end

-- Joystick inputs
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
	if self.joystick and joystick == self.joystick then
		self.pressedButton = button
	end
end

function Player:getButton(buttonNum, ...)
	if not self.joystick then return false end
	if not self.pressedButton then return false end

	local temp = self.pressedButton
	self.pressedButton = nil
	return temp == buttonNum
end

-- Meta
function getTime()
	return math.floor(love.timer.getTime() * 1000)
end
