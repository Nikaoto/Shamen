package.path = package.path .. ";../?.lua"
require "lib/deep"
screen = require "lib/shack"

screenWidth = 1366
screenHeight = 768
isFullscreen = true

objectPool = {}

world = {
	limitTop = screenHeight*2/9,
	limitBottom = screenHeight,
	limitLeft = 0,
	limitRight = screenWidth,
	shake = 20,
}
world.maxZ = world.limitBottom
world.minZ = world.limitTop
world.zRange = world.maxZ - world.minZ

world.skyColor = {0, 172, 230}
world.groundColor = {39, 159, 39}

function world:draw()
	deep:rectangleC(world.skyColor, "fill", 0, 0, 1, screenWidth, world.limitTop)
	deep:rectangleC(world.groundColor, "fill", 0, world.limitTop, 1, screenWidth, screenHeight)
	for k, v in pairs(objectPool) do
		if not v.shouldDestroy and v.draw ~= nil then
			v:draw()
		end
	end
end

function world:update(dt)
	for k, v in pairs(objectPool) do
		if v.shouldDestroy then
			table.remove(objectPool, k)
		elseif v.update ~= nil then
			v:update(dt)
		end
	end
end

function sq(a)
	return a*a
end

function dist(x1, y1, x2, y2)
	return math.sqrt(sq(x2-x1) + sq(y2-y1)) 
end

function getTime()
	return math.floor(love.timer.getTime() * 1000)
end
