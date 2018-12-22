require "game.entities.player"
require "game.entities.mob"

require "game.states.move"
require "game.states.fight"

local state = nil

function change_state(s)
  state = s
  state.load()
end

function love.load()
  mainFont = love.graphics.newFont("assets/fonts/A Goblin Appears!.otf")
  love.graphics.setFont(mainFont)

  change_state(fight)
end

function love.draw() state.draw() end
function love.update(dt) state.update(dt) end

function love.keypressed(key) state.keypressed(key) end
function love.resize(w, h) state.resize(w, h) end
