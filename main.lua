require "game.entities.player"
require "game.entities.mob"

require "game.interfaces.textbox"
require "game.interfaces.room"

require "game.states.move"
require "game.states.fight"

local sti = require "lib.sti"
local bump = require "lib.bump"

local state = nil

function change_state(s)
  state = s
  state.load()
end

function love.load()
  local mainFont = love.graphics.newFont("assets/fonts/A Goblin Appears!.otf")
  love.graphics.setFont(mainFont)

  local world = bump.newWorld(16)
  map = sti("assets/data/dungeon.lua", {"bump"}) -- Load map file
  map:bump_init(world)

  -- Get player spawn object
  for _, object in pairs(map.objects) do
    if object.name == "Player" then
      player = Player.new(object.x, object.y)
      break
    end
  end

  map:addCustomLayer("Sprite Layer", 14) -- Create a Custom Layer
  -- Add data to Custom Layer
  local spriteLayer = map.layers["Sprite Layer"]
  spriteLayer.sprites = {
    player
  }

  world:add(player, player.x, player.y, player.w, player.h) -- Add player to world

  function spriteLayer:update(dt)
    local goalX, goalY = player:update()
    local actualX, actualY, cols, len = world:check(player, goalX, goalY)
    world:update(player, actualX, actualY)
    if not (player.x == actualX and player.y == actualY) then move.step = move.step - 1 end
    player.x, player.y = actualX, actualY
  end

  function spriteLayer:draw()
    for key, sprite in pairs(self.sprites) do
      local x = sprite.x
      local y = sprite.y
      local r = sprite.r
      local sx = sprite.sx
      love.graphics.draw(sprite.image, x, y, r, sx)
    end
  end

  map:removeLayer("Spawn Point") -- Remove unneeded object layer

  -- Define update function for all room layer
  for _, layer in pairs(map.layers) do
    if "Room" == string.sub(layer.name, 0, 4) and not (layer.name == "Rooms") then
      layer = Room.new(layer, map.objects[layer.name])
    end
  end

  change_state(move)
end

function love.draw() state.draw() end
function love.update(dt)
  if gameIsPaused then return end
  state.update(dt)
end

function love.keypressed(key) state.keypressed(key) end
function love.resize(w, h) state.resize(w, h) end

function love.focus(f) gameIsPaused = not f end
