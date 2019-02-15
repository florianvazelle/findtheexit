require "game.entities.player"
require "game.entities.mob"

require "game.interfaces.textbox"
require "game.interfaces.room"

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

  change_state(move)
end

function love.draw() state.draw() end
function love.update(dt)
  if gameIsPaused then return end
  state.update(dt)
end

function love.keypressed(key) state.keypressed(key) end
function love.resize(w, h) state.resize(w, h) end

function love.focus(f)
  if not f then
    print("LOST FOCUS")
  else
    print("GAINED FOCUS")
  end
  gameIsPaused = not f
end
