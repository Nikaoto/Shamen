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
ui.playerOneHealthBarWidth = 300
ui.playerTwoHealthBarWidth = 300

ui.playerOneManaBarWidth = 200
ui.playerTwoManaBarWidth = 200

-- Player 1 health
ui.HEALTH_BAR_PLAYER_X = ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_X
ui.HEALTH_BAR_PLAYER_Y = 25

-- Player 2 health
ui.HEALTH_BAR_PLAYER_TWO_X = ui.DEFAULT_PLAYER_TWO_AVATAR_POSITION_X - ui.playerTwoHealthBarWidth
ui.HEALTH_BAR_PLAYER_TWO_Y = 25

ui.MANA_BAR_PLAYER_X = ui.DEFAULT_PLAYER_ONE_AVATAR_POSITION_X + ( ui.avatarRadius - 4 )
ui.MANA_BAR_PLAYER_Y = 45
ui.MANA_BAR_PLAYER_TWO_X = ui.DEFAULT_PLAYER_TWO_AVATAR_POSITION_X - ui.playerTwoManaBarWidth - (ui.avatarRadius - 4)
ui.MANA_BAR_PLAYER_TWO_Y = 45

--colors
ui.AVATAR_CIRCLE_COLOR = {}
ui.HEALTH_BAR_COLOR = {255, 5, 5}
ui.MANA_BAR_COLOR = {47, 135, 224}

function ui:draw()
  --drawing hp bar
  love.graphics.setColor(ui.HEALTH_BAR_COLOR)
  love.graphics.rectangle("fill", ui.HEALTH_BAR_PLAYER_X, ui.HEALTH_BAR_PLAYER_Y, ui.playerOneHealthBarWidth, ui.HEALTH_BAR_HEIGHT,10)
  love.graphics.rectangle("fill", ui.HEALTH_BAR_PLAYER_TWO_X, ui.HEALTH_BAR_PLAYER_TWO_Y, ui.playerTwoHealthBarWidth,
                      ui.HEALTH_BAR_HEIGHT,10)

  --drawing mana bar
  love.graphics.setColor(ui.MANA_BAR_COLOR)
  love.graphics.rectangle("fill", ui.MANA_BAR_PLAYER_X, ui.MANA_BAR_PLAYER_Y, ui.playerOneManaBarWidth, ui.MANA_BAR_HEIGHT,5)
  love.graphics.rectangle("fill", ui.MANA_BAR_PLAYER_TWO_X, ui.MANA_BAR_PLAYER_TWO_Y, ui.playerTwoManaBarWidth, ui.MANA_BAR_HEIGHT,5)

  --drawing circles
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

  ui.playerOneHealthBarWidth = playerOne.hp * 3
  ui.playerOneManaBarWidth = playerOne.mp * 2
end

function updatePlayerTwo(playerTwo)
  if playerTwo.hp < 0 then playerTwo.hp = 0 end
  if playerTwo.mp < 0 then playerTwo.mp = 0 end

  ui.HEALTH_BAR_PLAYER_TWO_X = ui.HEALTH_BAR_PLAYER_TWO_X + (ui.playerTwoHealthBarWidth - playerTwo.hp * 3)
  ui.playerTwoHealthBarWidth = playerTwo.hp * 3
  ui.MANA_BAR_PLAYER_TWO_X = ui.MANA_BAR_PLAYER_TWO_X + (ui.playerTwoManaBarWidth - playerTwo.mp * 2)
  ui.playerTwoManaBarWidth = playerTwo.mp * 2
end
