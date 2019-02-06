Textbox = {}
Textbox.__index = Textbox

function Textbox.new()
  local textbox = {}
  setmetatable(textbox, Textbox)
  textbox.colors = {
    background = { 255, 255, 255, 255 },
    text = { 40, 40, 40, 255 }
  }
  return textbox
end

function Textbox:set_text(new_text)
  self.show = true
  self.text_shown = ""
  self.text = new_text
end

function Textbox:draw()
  love.graphics.setColor(unpack(self.colors.background))
  love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
  if self.show then
    self:renderer()
  else
    self:print(self.text)
  end
end

function Textbox:renderer()
  local len = string.len(self.text_shown) + 1
  self.text_shown = self.text_shown .. string.sub(self.text, len, len)
  love.timer.sleep(0.1)
  self:print(self.text_shown)
  if self.text == self.text_shown then
    self.text_shown = ""
    self.show = false
  end
end

function Textbox:print(text)
  love.graphics.setColor(unpack(self.colors.text))
  love.graphics.printf(text, self.x + 10, self.y + 10, self.w, 'left')
end

function Textbox:keypressed(key)
  if key == "return" then
    self.show = false
  end
end

function Textbox:resize(width, height)
  self.x = (width / 5)
  self.y = (height / 8) * 5
  self.w = (width / 5) * 3
  self.h = (height / 8) * 2
end
