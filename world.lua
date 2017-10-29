package.path = package.path .. ";../?.lua"
require "lib/deep"
screen = require "lib/shack"

screenWidth = 1366
screenHeight = 768
isFullscreen = true

objectPool = {}
magic = 40
world = {
	limitTop = screenHeight*2/9,
	limitBottom = screenHeight + magic,
	limitLeft = magic,
	limitRight = screenWidth - magic,
	shake = 20,
}
world.maxZ = world.limitBottom
world.minZ = world.limitTop
world.zRange = world.maxZ - world.minZ

world.skyColor = {0, 172, 230}
world.groundColor = {39, 159, 39}
grassSprite = love.graphics.newImage("res/grass.png")
function world:load()
	math.randomseed(os.time())
	world.grass = {}
	for i = 1, screenWidth, grassSprite:getWidth() do
		for j = world.limitTop, screenHeight, grassSprite:getHeight() do
			if (math.random(1,10) == 9) then
				table.insert(world.grass, {x = i, y = j, scale = math.random(1, 10)/10})
			end
		end
	end
end

function world:draw()
	deep:rectangleC(world.skyColor, "fill", 0, 0, 1, screenWidth, world.limitTop)
	deep:rectangleC(world.groundColor, "fill", 0, world.limitTop, 1, screenWidth, screenHeight)
	for k, v in pairs(objectPool) do
		if not v.shouldDestroy and v.draw ~= nil then
			v:draw()
		end
	end
	for k, v in pairs(world.grass) do
		deep:queue(grassSprite, v.x, v.y, 1, _, v.scale, v.scale)
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

function putThroughScreenCollisions(nextX, nextY)
	local retX, retY, retZ = nextX, nextY, 0

	if nextX < world.limitLeft then 
		retX = world.limitLeft
	elseif nextX > world.limitRight then
		retX = world.limitRight
	end

	if nextY < world.limitTop then
		retY = world.limitTop
	elseif nextY > world.limitBottom then
		retY = world.limitBottom
	end

	return retX, retY, retZ
end

function inAreal(x1, z1, x2, z2, rx, ry)
	if not ry then
		return dist(x1, z1, x2, z2) <= rx
	else
		local c = rx/2
		local left = dist(x1, z1, x2 - c, z2) <= c
		local mid = dist(x1, z1 + 20, x2, z2) <= ry
		local right = dist(x1 - 25, z1, x2 + c, z2) <= c
		return (left or mid or right)
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
