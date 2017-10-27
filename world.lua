package.path = package.path .. ";../?.lua"
require "lib/deep"
screen = require "lib/shack"

screenWidth = 1000
screenHeight = 500
isFullscreen = false

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

function world:draw()
	deep:rectangleC({20, 80, 20}, "fill", 0, world.limitTop, 1, screenWidth, screenHeight)
end
