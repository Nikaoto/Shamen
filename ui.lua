package.path = package.path .. ";../?.lua"

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

  -- back to DEFAULT
  love.graphics.setColor(255, 255, 255, 255)
end

function ui:update(player, player2)
  updatePlayerOne(player)
  updatePlayerTwo(player2)
end

function updatePlayerOne(playerOne)
  if playerOne.hp < 0 then playerOne.hp = 0 end
  if playerOne.mp < 0 then playerOne.mp = 0 end

  ui.playerOneHealthBarWidth = playerOne.hp * (ui.ORIGIN_HEALTH_BAR_WIDTH/100)
  ui.playerOneManaBarWidth = playerOne.mp * (ui.ORIGIN_MANA_BAR_WIDTH/100)
end

function updatePlayerTwo(playerTwo)
  if playerTwo.hp < 0 then playerTwo.hp = 0 end
  if playerTwo.mp < 0 then playerTwo.mp = 0 end

  ui.HEALTH_BAR_PLAYER_TWO_X = ui.HEALTH_BAR_PLAYER_TWO_X + (ui.playerTwoHealthBarWidth - playerTwo.hp * (ui.ORIGIN_HEALTH_BAR_WIDTH/100))
  ui.playerTwoHealthBarWidth = playerTwo.hp * (ui.ORIGIN_HEALTH_BAR_WIDTH/100)
  ui.MANA_BAR_PLAYER_TWO_X = ui.MANA_BAR_PLAYER_TWO_X + (ui.playerTwoManaBarWidth - playerTwo.mp * (ui.ORIGIN_MANA_BAR_WIDTH/100))
  ui.playerTwoManaBarWidth = playerTwo.mp * (ui.ORIGIN_MANA_BAR_WIDTH/100)
end
