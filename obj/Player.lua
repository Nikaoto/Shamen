package.path = package.path .. ";../?.lua"
Object = require "lib/classic"
require "lib/deep"

Player = Object:extend()

Player.AXIS_LX = 1
Player.AXIS_LY = 2
Player.AXIS_RX = 4
Player.AXIS_RY = 3
Player.Y_MOVE_MOD = 0.85

Player.BTN_4 = 4
Player.BTN_3 = 3
Player.BTN_2 = 2
Player.BTN_1 = 1

Player.AIM_SPEED = 1000
Player.AIM_HIDE_INTERVAL = 2500

function Player:new(sprite, color, joystick, x, y, z)
	self.sprite = sprite
	self.joystick = joystick
	
	if #color == 3 then
		self.color = {color[1], color[2], color[3], 255}
	else
		self.color = color
	end

	self.x, self.y, self.z = x, y, z
	
	self.w = self.sprite:getWidth()
	self.h = self.sprite:getHeight()
	self.ox = self.w / 2
	self.oy = self.h * 0.75
	self.sx, self.sy = 1, 1
	self.r = 0
	self.speed = 400

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
		z = 100,
		radius = 10,
		speed = Player.AIM_SPEED,
		timer = 0,
		hideInterval = Player.AIM_HIDE_INTERVAL,
		color = {255, 255, 255},
		shouldShow = false,
	}

	self.shader = love.graphics.newShader[[
    extern vec4 mainColor; //Color to set
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
      //Getting current pixel color
      vec4 pixel = Texel(texture, texture_coords );
      pixel.r = mainColor.r;
      pixel.g = mainColor.g;
      pixel.b = mainColor.b;
      return pixel * color;
    }]]
end

function Player:updateShader()
	self.shader:sendColor("mainColor", self.color)
end

function Player:draw()
	self:updateShader()

	deep:queueS(self.shader, self.sprite, self.x, self.y, self.z, math.rad(self.r), self.sx, self.sy, 
		self.ox, self.oy)
	self:drawAim()
	self:animate()
end

function Player:update(dt)
	self:move(dt)
	self:actions()
	self:handleAim(dt)
end

function Player:move(dt)
	self.x = self.x + self:getAxis(Player.AXIS_LX) * dt * self.speed
	self.y = self.y + self:getAxis(Player.AXIS_LY) * dt * self.speed * Player.Y_MOVE_MOD
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

			-- TODO check collisions here

			self.aim.x = nextX
			self.aim.y = nextY
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

function Player:actions()
	if self:getButton(4) then
		screen:setShake(world.shake)
	end
end

-- Joystick inputs
function Player:getAxis(axisNum, deadzone)
	deadzone = deadzone or 0
	local ret = self.joystick:getAxis(axisNum)
	if math.abs(ret) > deadzone then
		return ret
	else
		return 0
	end
end

function Player:getButton(buttonNum, ...)
	return self.joystick:isDown(buttonNum, ...)
end

-- Meta
function getTime()
	return math.floor(love.timer.getTime() * 1000)
end
