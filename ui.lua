package.path = package.path .. ";../?.lua"

ui = {}

-- circles position
ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_X = 20
ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_Y = 20
ui.DEFAULT_PLAYER_TWO_AVATAR_POSITION_X = screenWidth - 20
ui.DEFAULT_PLAYER_TWO_AVATAR_POSITION_Y = 20

-- mana and health bar positions
ui.HEALTH_BAR_HEIGHT = 10
ui.MANA_BAR_HEIGHT = 5
-- height , width
ui.PLAYER_HEALTH_BAR_WIDTH = 150
ui.PLAYER_MANA_BAR_WIDTH = 70
ui.PLAYER_TWO_HEALTH_BAR_WIDTH = 150
ui.PLAYER_TWO_MANA_BAR_WIDTH = 70
-- Player 1 health
ui.HEALTH_BAR_PLAYER_X = ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_X + 20
ui.HEALTH_BAR_PLAYER_Y = 10
-- Player 2 health
ui.HEALTH_BAR_PLAYER_TWO_X = ui.DEFAULT_PLAYER_TWO_AVATAR_POSITION_X - ui.PLAYER_TWO_HEALTH_BAR_WIDTH
ui.HEALTH_BAR_PLAYER_TWO_Y = 10

ui.MANA_BAR_PLAYER_X = ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_X + 20
ui.MANA_BAR_PLAYER_Y = 19
ui.MANA_BAR_PLAYER_TWO_X = screenWidth - 110
ui.MANA_BAR_PLAYER_TWO_Y = 19

--colors
ui.AVATAR_CIRCLE_COLOR = {}
ui.HEALTH_BAR_COLOR = {255, 5, 5}
ui.MANA_BAR_COLOR = {47, 135, 224}

function ui:draw()
  --drawing hp bar
  love.graphics.setColor(ui.HEALTH_BAR_COLOR)
  love.graphics.rectangle("fill", ui.HEALTH_BAR_PLAYER_X, ui.HEALTH_BAR_PLAYER_Y, ui.PLAYER_HEALTH_BAR_WIDTH, ui.HEALTH_BAR_HEIGHT)
  love.graphics.rectangle("fill", ui.HEALTH_BAR_PLAYER_TWO_X, ui.HEALTH_BAR_PLAYER_TWO_Y, ui.PLAYER_TWO_HEALTH_BAR_WIDTH,
                      ui.HEALTH_BAR_HEIGHT)

  --drawing mana bar
  love.graphics.setColor(ui.MANA_BAR_COLOR)
  love.graphics.rectangle("fill", ui.MANA_BAR_PLAYER_X, ui.MANA_BAR_PLAYER_Y, ui.PLAYER_MANA_BAR_WIDTH, ui.MANA_BAR_HEIGHT)
  love.graphics.rectangle("fill", ui.MANA_BAR_PLAYER_TWO_X, ui.MANA_BAR_PLAYER_TWO_Y, ui.PLAYER_TWO_MANA_BAR_WIDTH, ui.MANA_BAR_HEIGHT)

  --drawing circles
  love.graphics.circle("fill", ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_X, ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_Y, 30)
  love.graphics.circle("fill", ui.DEFAULT_PLAYER_TWO_AVATAR_POSITION_X, ui.DEFAULT_PLAYER_TWO_AVATAR_POSITION_Y, 30)
  -- back to DEFAULT
  love.graphics.setColor(255, 255, 255, 255)
end

function ui:update(player, player2)
  setPlayerOneHpMp(player.hp, player.mp)
  setPlayerTwoHpMp(player2.hp, player2.mp)
end

function setPlayerOneHpMp(hp, mp)
  --
  --ui.HEALTH_BAR_PLAYER_X = ui.HEALTH_BAR_PLAYER_X - (ui.PLAYER_HEALTH_BAR_WIDTH - hp * 1.5)
  ui.PLAYER_HEALTH_BAR_WIDTH = hp * 1.5
  --
  --ui.MANA_BAR_PLAYER_X = ui.MANA_BAR_PLAYER_X - (ui.PLAYER_MANA_BAR_WIDTH - mp * 0.7)
  ui.PLAYER_MANA_BAR_WIDTH = mp * 0.7
end

function setPlayerTwoHpMp(hp, mp)
  --
  ui.HEALTH_BAR_PLAYER_TWO_X = ui.HEALTH_BAR_PLAYER_TWO_X + (ui.PLAYER_TWO_HEALTH_BAR_WIDTH - hp * 1.5)
  ui.PLAYER_TWO_HEALTH_BAR_WIDTH = hp * 1.5
  --
  ui.MANA_BAR_PLAYER_TWO_X = ui.MANA_BAR_PLAYER_TWO_X + (ui.PLAYER_TWO_MANA_BAR_WIDTH - mp * 0.7)
  ui.PLAYER_TWO_MANA_BAR_WIDTH = mp * 0.7
end

-- function ui:setMana(player, mana)
-- end
