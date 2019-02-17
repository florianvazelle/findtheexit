move = {}

function move.load()
  tx, ty, sx, sy = 0, 0, 1, 1

  move.step = love.math.random(9, 15)

  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()

  move.resize(w, h)
end

function move.update(dt)
  map:update(dt)

  if move.step == 0 then
    change_state(fight)
  end
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
