local sti = require "lib.sti"
local bump = require "lib.bump"

move = {}

function move.load()
  tx, ty, sx, sy = 0, 0, 1, 1

  local step = love.math.random(9, 15)
  print(step)

  local world = bump.newWorld(16)
  map = sti("assets/data/dungeon.lua", {"bump"}) -- Load map file
  map:bump_init(world)

  -- Get player spawn object
  --local player
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
    if not (player.x == actualX and player.y == actualY) then step = step - 1 end
    player.x, player.y = actualX, actualY

    if step == 0 then
      change_state(fight)
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


  -- define update function for all room layer
  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()

  for _, layer in pairs(map.layers) do
    if "Room" == string.sub(layer.name, 0, 4) and not (layer.name == "Rooms") then
      layer = Room.new(layer, map.objects[layer.name])
    end
  end

  move.resize(w, h)
end

function move.update(dt)
  map:update(dt)
end

function move.draw()
  map:draw(tx, ty, sx)
end

function move.keypressed(key) end

function move.resize(width, height)
  -- To determine the best scale to adopt
  for _, room in pairs(map.objects) do
    local scaleX = width / room.width
    if scaleX < sx or sx == 1 then
      sx = scaleX
    end

    local scaleY = height / room.height
    if scaleY < sy or sy == 1 then
      sy = scaleY
    end
  end
  sx = math.min(sx, sy)
end

function hit(x, y, box)
  if x >= box.x
  and x < box.x + box.width
  and y >= box.y
  and y < box.y + box.height then
    return true;
  else
    return false;
  end
end
