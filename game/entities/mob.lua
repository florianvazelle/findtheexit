Mob = {}
Mob.new = function(level)
  local self = {}

  local data_mobs = require("assets.data.level" .. level .. ".mobs")
  local mob = data_mobs[love.math.random(table.getn(data_mobs))]

  self.health = mob.health
  self.damage = mob.damage
  self.critical = mob.critical
  self.name = mob.name

  self.image = love.graphics.newImage("assets/images/" .. self.name .. ".png")
  self.x = 0
  self.y = 0
  self.r = 0
  self.sx = 3

  self.attack = function(less_damage)
    local less_damage = less_damage or 0
    local damage, isCritical = nil, nil
    if love.math.random() < (self.critical / 100) then
      damage, isCritical = self.damage[2] + 1, true
    else
      damage, isCritical = love.math.random(self.damage[1], self.damage[2]), false
    end

    return damage - less_damage, isCritical
  end

  self.hit = function(damage)
    self.health = self.health - damage
  end

  return self
end
