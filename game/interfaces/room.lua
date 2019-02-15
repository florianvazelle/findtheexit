Room = {}
Room.new = function(room, object)
  local self = room

  self.update = function(self)
    if hit(player.x, player.y, object) then
      self.properties["visited"] = true
      self.opacity = 1

      local w = love.graphics.getWidth()
      local h = love.graphics.getHeight()

      tx = -object.x + (w / (2 * sx)) - object.width / 2
      ty = -object.y + (h / (2 * sx)) - object.height / 2
    else
      if self.properties["visited"] then
        self.opacity = 0.5
      else
        self.opacity = 0
      end
    end
  end

  return self
end
