package.path = package.path .. ";../?.lua"
local tween = require "lib/tween"
ui = {}

-- circles position
ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_X = 60
ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_Y = 60
ui.DEFAULT_PLAYER_TWO_AVATAR_POSITION_X = screenWidth - 60
ui.DEFAULT_PLAYER_TWO_AVATAR_POSITION_Y = 60
ui.avatarRadius = 50

-- mana and health bar positions
ui.HEALTH_BAR_HEIGHT = 20
ui.MANA_BAR_HEIGHT = 10

-- height , width
ui.ORIGIN_HEALTH_BAR_WIDTH = 300
ui.playerOneHealthBarWidth = 300
ui.playerTwoHealthBarWidth = 300

ui.ORIGIN_MANA_BAR_WIDTH = 200
ui.playerOneManaBarWidth = 200
ui.playerTwoManaBarWidth = 200

-- Player 1 health
ui.HEALTH_BAR_PLAYER_X = ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_X
ui.HEALTH_BAR_PLAYER_Y = 25

-- Player 2 health
ui.HEALTH_BAR_PLAYER_TWO_X = ui.DEFAULT_PLAYER_TWO_AVATAR_POSITION_X - ui.playerTwoHealthBarWidth
ui.HEALTH_BAR_PLAYER_TWO_Y = 25

ui.MANA_BAR_PLAYER_X = ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_X + ( ui.avatarRadius - 4 )
ui.MANA_BAR_PLAYER_Y = 50
ui.MANA_BAR_PLAYER_TWO_X = ui.DEFAULT_PLAYER_TWO_AVATAR_POSITION_X - ui.playerTwoManaBarWidth - (ui.avatarRadius - 4)
ui.MANA_BAR_PLAYER_TWO_Y = 50

-- Totem Cooldown Arc properties
ui.ARC_DEFAULT_RADIUS = 15
ui.ARC_DEFAULT_ALPHA = 100
ui.ARC_MARGIN = ui.ARC_DEFAULT_RADIUS + 30
ui.ARC_Y = ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_Y + 25

ui.TOTEM_COOLDOWN_TIME = 0.5
ui.TOTEM_BAR_WIDTH = ( ui.ARC_DEFAULT_RADIUS * 2 )*4 + ( 4 * ui.ARC_MARGIN )
-- Player 1 totem clock properties
ui.p1 = {}
ui.p1.FIRE_TOTEM_X = ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_X + ( ui.avatarRadius + 30 )
ui.p1.fireTotemStartAngle = math.rad(0)
ui.p1.fireTotemEndAngle = math.rad(360)

ui.p1.WIND_TOTEM_X = ui.p1.FIRE_TOTEM_X + ui.ARC_MARGIN
ui.p1.windTotemStartAngle = math.rad(0)
ui.p1.windTotemEndAngle = math.rad(360)

ui.p1.CREEP_TOTEM_X = ui.p1.WIND_TOTEM_X + ui.ARC_MARGIN
ui.p1.creepTotemStartAngle = math.rad(0)
ui.p1.creepTotemEndAngle = math.rad(360)

ui.p1.ROOT_TOTEM_X = ui.p1.CREEP_TOTEM_X + ui.ARC_MARGIN
ui.p1.rootTotemStartAngle = math.rad(0)
ui.p1.rootTotemEndAngle = math.rad(360)
ui.p1.tweenArray = {}
-- Player 2 totem clock properties
ui.p2 = {}
ui.p2.FIRE_TOTEM_X = ui.MANA_BAR_PLAYER_TWO_X + 30
ui.p2.fireTotemStartAngle = math.rad(0)
ui.p2.fireTotemEndAngle = math.rad(360)

ui.p2.WIND_TOTEM_X = ui.p2.FIRE_TOTEM_X + ui.ARC_MARGIN
ui.p2.windTotemStartAngle = math.rad(0)
ui.p2.windTotemEndAngle = math.rad(360)

ui.p2.CREEP_TOTEM_X = ui.p2.WIND_TOTEM_X + ui.ARC_MARGIN
ui.p2.creepTotemStartAngle = math.rad(0)
ui.p2.creepTotemEndAngle = math.rad(360)

ui.p2.ROOT_TOTEM_X = ui.p2.CREEP_TOTEM_X + ui.ARC_MARGIN
ui.p2.rootTotemStartAngle = math.rad(0)
ui.p2.rootTotemEndAngle = math.rad(360)
ui.p2.tweenArray = {}


ui.playerArray = { ui.p1, ui.p2 }

-- Totem sprite images
ui.fireTotemSprite = love.graphics.newImage("res/totem_fire.png")

--colors
ui.AVATAR_CIRCLE_COLOR = {}
ui.HEALTH_BAR_COLOR = {255, 5, 5}
ui.MANA_BAR_COLOR = {47, 135, 224}
ui.CHARACTER_CIRCLE_COLOR = {47, 135, 224}
ui.OUTLINE_COLOR = {0, 0, 0}
ui.OUTLINE_WIDTH = 5

function ui:draw()
  -- drawing outlines
  love.graphics.setColor(ui.OUTLINE_COLOR)
  local w = ui.OUTLINE_WIDTH
  --hp
  love.graphics.rectangle("fill", ui.HEALTH_BAR_PLAYER_X - w, ui.HEALTH_BAR_PLAYER_Y - w,
   ui.playerOneHealthBarWidth + 2*w, ui.HEALTH_BAR_HEIGHT + 2*w, 10 + w)
  love.graphics.rectangle("fill", ui.HEALTH_BAR_PLAYER_TWO_X - w, ui.HEALTH_BAR_PLAYER_TWO_Y - w,
    ui.playerTwoHealthBarWidth + 2*w, ui.HEALTH_BAR_HEIGHT + 2*w, 10 + w)
  --mana
  love.graphics.rectangle("fill", ui.MANA_BAR_PLAYER_X - w, ui.MANA_BAR_PLAYER_Y - w,
    ui.playerOneManaBarWidth + 2*w, ui.MANA_BAR_HEIGHT + 2*w, 5 + w)
  love.graphics.rectangle("fill", ui.MANA_BAR_PLAYER_TWO_X - w, ui.MANA_BAR_PLAYER_TWO_Y - w,
    ui.playerTwoManaBarWidth + 2*w, ui.MANA_BAR_HEIGHT + 2*w, 5 + w)
  --characters
  love.graphics.circle("fill", ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_X,
    ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_Y, ui.avatarRadius + w)
  love.graphics.circle("fill", ui.DEFAULT_PLAYER_TWO_AVATAR_POSITION_X,
    ui.DEFAULT_PLAYER_TWO_AVATAR_POSITION_Y, ui.avatarRadius + w)

  --drawing hp bar
  love.graphics.setColor(ui.HEALTH_BAR_COLOR)
  love.graphics.rectangle("fill", ui.HEALTH_BAR_PLAYER_X, ui.HEALTH_BAR_PLAYER_Y, ui.playerOneHealthBarWidth, ui.HEALTH_BAR_HEIGHT,10)
  love.graphics.rectangle("fill", ui.HEALTH_BAR_PLAYER_TWO_X, ui.HEALTH_BAR_PLAYER_TWO_Y, ui.playerTwoHealthBarWidth,
                      ui.HEALTH_BAR_HEIGHT, 10)

  --drawing mana bar
  love.graphics.setColor(ui.MANA_BAR_COLOR)
  love.graphics.rectangle("fill", ui.MANA_BAR_PLAYER_X, ui.MANA_BAR_PLAYER_Y, ui.playerOneManaBarWidth, ui.MANA_BAR_HEIGHT,5)
  love.graphics.rectangle("fill", ui.MANA_BAR_PLAYER_TWO_X, ui.MANA_BAR_PLAYER_TWO_Y, ui.playerTwoManaBarWidth, ui.MANA_BAR_HEIGHT,5)

  --drawing circles
  love.graphics.setColor(ui.CHARACTER_CIRCLE_COLOR)
  love.graphics.circle("fill", ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_X, ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_Y, ui.avatarRadius)
  love.graphics.circle("fill", ui.DEFAULT_PLAYER_TWO_AVATAR_POSITION_X, ui.DEFAULT_PLAYER_TWO_AVATAR_POSITION_Y, ui.avatarRadius)

  --drawing Arcs
  --Player 1
  --Background Arcs
  love.graphics.setColor({242,12,12})
  --p1
  love.graphics.circle( "fill", ui.p1.FIRE_TOTEM_X, ui.ARC_Y, ui.ARC_DEFAULT_RADIUS )
  love.graphics.circle( "fill", ui.p1.WIND_TOTEM_X, ui.ARC_Y, ui.ARC_DEFAULT_RADIUS )
  love.graphics.circle( "fill", ui.p1.CREEP_TOTEM_X, ui.ARC_Y, ui.ARC_DEFAULT_RADIUS )
  love.graphics.circle( "fill", ui.p1.ROOT_TOTEM_X, ui.ARC_Y, ui.ARC_DEFAULT_RADIUS )
  -- p2
  love.graphics.circle( "fill", ui.p2.FIRE_TOTEM_X, ui.ARC_Y, ui.ARC_DEFAULT_RADIUS )
  love.graphics.circle( "fill", ui.p2.WIND_TOTEM_X, ui.ARC_Y, ui.ARC_DEFAULT_RADIUS )
  love.graphics.circle( "fill", ui.p2.CREEP_TOTEM_X, ui.ARC_Y, ui.ARC_DEFAULT_RADIUS )
  love.graphics.circle( "fill", ui.p2.ROOT_TOTEM_X, ui.ARC_Y, ui.ARC_DEFAULT_RADIUS )

  --drawing sprites
  --p1
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(ui.fireTotemSprite, ui.p1.FIRE_TOTEM_X, ui.ARC_Y, _, 0.5, 0.5,
                     ui.fireTotemSprite:getWidth() / 2, ui.fireTotemSprite:getHeight() / 2)
  -- p2
  love.graphics.draw(ui.fireTotemSprite, ui.p2.FIRE_TOTEM_X, ui.ARC_Y, _, 0.5, 0.5,
                     ui.fireTotemSprite:getWidth() / 2, ui.fireTotemSprite:getHeight() / 2)
  -- arcs
  -- Player 1
  love.graphics.setColor( 255, 255, 0 , ui.ARC_DEFAULT_ALPHA)
  -- love.graphics.arc( "fill", ui.p1.FIRE_TOTEM_X, ui.ARC_Y, ui.ARC_DEFAULT_RADIUS, ui.p1.fireTotemStartAngle, ui.p1.fireTotemEndAngle )
  -- love.graphics.arc( "fill", ui.p1.WIND_TOTEM_X, ui.ARC_Y, ui.ARC_DEFAULT_RADIUS, ui.p1.windTotemStartAngle, ui.p1.windTotemEndAngle )
  -- love.graphics.arc( "fill", ui.p1.CREEP_TOTEM_X, ui.ARC_Y, ui.ARC_DEFAULT_RADIUS, ui.p1.creepTotemStartAngle, ui.p1.creepTotemEndAngle )
  -- love.graphics.arc( "fill", ui.p1.ROOT_TOTEM_X, ui.ARC_Y, ui.ARC_DEFAULT_RADIUS, ui.p1.rootTotemStartAngle, ui.p1.rootTotemEndAngle )

  for k, v in pairs(ui.p1.tweenArray) do
    if v and not v.complete then
      if k == 1 then
        drawCooldownArc({ x = ui.p1.FIRE_TOTEM_X}, ui.p1.fireTotemStartAngle, ui.p1.fireTotemEndAngle)
      elseif k == 2 then
        drawCooldownArc({ x = ui.p1.FIRE_TOTEM_X}, ui.p1.windTotemStartAngle, ui.p1.windTotemEndAngle)
      elseif k == 3 then
        drawCooldownArc({ x = ui.p1.FIRE_TOTEM_X}, ui.p1.creepTotemStartAngle, ui.p1.creepTotemEndAngle)
      elseif k == 4 then
        drawCooldownArc({ x = ui.p1.FIRE_TOTEM_X}, ui.p1.rootTotemStartAngle, ui.p1.rootTotemEndAngle)
      end
    end
  end

  for k,v in pairs(ui.p2.tweenArray) do
    if v and not v.complete then
      if k == 1 then
        drawCooldownArc({ x = ui.p2.FIRE_TOTEM_X}, ui.p2.fireTotemStartAngle, ui.p2.fireTotemEndAngle)
      elseif k == 2 then
        drawCooldownArc({ x = ui.p2.FIRE_TOTEM_X}, ui.p2.windTotemStartAngle, ui.p2.windTotemEndAngle)
      elseif k == 3 then
        drawCooldownArc({ x = ui.p2.FIRE_TOTEM_X}, ui.p2.creepTotemStartAngle, ui.p2.creepTotemEndAngle)
      elseif k == 4 then
        drawCooldownArc({ x = ui.p2.FIRE_TOTEM_X}, ui.p2.rootTotemStartAngle, ui.p2.rootTotemEndAngle)
      end
    end
  end

  -- back to DEFAULT
  love.graphics.setColor(255, 255, 255, 255)
end

function ui:update(player, player2,dt)
  updatePlayerOne(player)
  updatePlayerTwo(player2)

  for k, v in pairs(ui.p1.tweenArray) do
      if v then
        v.complete = v:update(dt)
        if v.complete then
          if k == 1 then
            ui.p1.fireTotemEndAngle = math.rad(360)
          elseif k == 2 then
            ui.p1.creepTotemEndAngle = math.rad(360)
          elseif k == 3 then
            ui.p1.windTotemEndAngle = math.rad(360)
          elseif k == 4 then
            ui.p1.rootTotemEndAngle = math.rad(360)
          end
        end
      end
  end

  for k, v in pairs(ui.p2.tweenArray) do
      if v then
        local complete = v:update(dt)
        if complete then
          if k == 1 then
            ui.p2.fireTotemStartAngle = 0
            ui.p2.fireTotemEndAngle = math.rad(360)
          elseif k == 2 then
            ui.p2.creepTotemStartAngle = 0
            ui.p2.creepTotemEndAngle = math.rad(360)
          elseif k == 3 then
            ui.p2.windTotemStartAngle = 0
            ui.p2.windTotemEndAngle = math.rad(360)
          elseif k == 4 then
            ui.p2.rootTotemStartAngle = 0
            ui.p2.rootTotemEndAngle = math.rad(360)
          end
        end
      end
  end
end

function ui:onTotemUse(playerIndex, totemIndex)
  local currentPlayer = ui.playerArray[playerIndex]
  local currentPlayerTweenArray = ui.playerArray[playerIndex].tweenArray

  if totemIndex == 1 then
    currentPlayerTweenArray[1] = tween.new(ui.TOTEM_COOLDOWN_TIME, currentPlayer, { fireTotemEndAngle = math.rad(1) })
  elseif totemIndex == 2 then
    currentPlayerTweenArray[2] = tween.new(ui.TOTEM_COOLDOWN_TIME, currentPlayer, { windTotemEndAngle = math.rad(1) })
  elseif totemIndex == 3 then
    currentPlayerTweenArray[3] = tween.new(ui.TOTEM_COOLDOWN_TIME, currentPlayer, { creepTotemEndAngle = math.rad(1) })
  elseif totemIndex == 4 then
    currentPlayerTweenArray[4] = tween.new(ui.TOTEM_COOLDOWN_TIME, currentPlayer, { rootTotemEndAngle = math.rad(1) })
  end
end

function updatePlayerOne(playerOne)
  if playerOne.hp < 0 then playerOne.hp = 0 end
  if playerOne.mp < 0 then playerOne.mp = 0 end

  ui.playerOneHealthBarWidth = playerOne.hp * (ui.ORIGIN_HEALTH_BAR_WIDTH / 100)
  ui.playerOneManaBarWidth = playerOne.mp * (ui.ORIGIN_MANA_BAR_WIDTH / 100)
end

-- TODO
function drawCooldownArc(coords, startAngle, endAngle)
  love.graphics.arc( "fill", coords.x, ui.ARC_Y, ui.ARC_DEFAULT_RADIUS, startAngle, endAngle)
end

function updatePlayerTwo(playerTwo)
  if playerTwo.hp < 0 then playerTwo.hp = 0 end
  if playerTwo.mp < 0 then playerTwo.mp = 0 end

  ui.HEALTH_BAR_PLAYER_TWO_X = ui.HEALTH_BAR_PLAYER_TWO_X + (ui.playerTwoHealthBarWidth - playerTwo.hp * (ui.ORIGIN_HEALTH_BAR_WIDTH/100))
  ui.playerTwoHealthBarWidth = playerTwo.hp * (ui.ORIGIN_HEALTH_BAR_WIDTH/100)
  ui.MANA_BAR_PLAYER_TWO_X = ui.MANA_BAR_PLAYER_TWO_X + (ui.playerTwoManaBarWidth - playerTwo.mp * (ui.ORIGIN_MANA_BAR_WIDTH/100))
  ui.playerTwoManaBarWidth = playerTwo.mp * (ui.ORIGIN_MANA_BAR_WIDTH/100)
end
