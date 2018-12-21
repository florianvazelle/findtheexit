local sti = require "lib.sti"
local bump = require "lib.bump"

move = {}

function move.load()
  local world = bump.newWorld(16)
  map = sti("assets/data/dungeon.lua", {"bump"}) -- Load map file
  map:bump_init(world)

  -- Get player spawn object
  local player
  for _, object in pairs(map.objects) do
    if object.name == "Player" then
      player = Player.new(object.x, object.y)
      break
    end
  end

  map:addCustomLayer("Sprite Layer", 3) -- Create a Custom Layer
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
    player.x, player.y = actualX, actualY

    if love.math.random() > 0.98 then
      --change_state(fight)
    end
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
end

function move.update(dt)
  map:update(dt)
end

function move.draw()
  map:draw()
end

function move.keypressed(key) end
function move.resize(width, height) end
