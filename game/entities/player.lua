Player = {}
Player.new = function(x, y)
  local self = {}

  local spritePlayer = love.graphics.newImage("assets/images/pikeman.png")
  self.image = spritePlayer
  self.x = x
  self.y = y
  self.w = 16
  self.h = 16
  self.r = 0
  self.sx = 0.5
  self.lastMoveTime = 0

  self.update = function(self)
    local speed = 16
    local goalX, goalY = self.x, self.y

    local time = love.timer.getTime()
    local repeatMoveDelay = 0.1

    if time > self.lastMoveTime + repeatMoveDelay then

      if love.keyboard.isDown("z") or love.keyboard.isDown("up") then
        goalY = goalY - speed
        self.lastMoveTime = time;
      elseif love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        goalY = goalY + speed
        self.lastMoveTime = time;
      end

      if love.keyboard.isDown("q") or love.keyboard.isDown("left") then
        goalX = goalX - speed
        self.lastMoveTime = time;
      elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        goalX = goalX + speed
        self.lastMoveTime = time;
      end
    end

    return math.floor(goalX), math.floor(goalY)
  end

  return self
end
