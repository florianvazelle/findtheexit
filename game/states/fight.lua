fight = {}

function fight.load()
  mob = Mob.new(1)

  actions = {
    { x = nil, y = nil, label = "Attack", skills = { { x = nil, y = nil, label = "Punch", effect = { 1, 2 } } } },
    { x = nil, y = nil, label = "Defense", skills = { { x = nil, y = nil, label = "Shield", effect = { 1, 2 } } } },
    { x = nil, y = nil, label = "Flee", skills = {} }
  }
  focus = 1
  infocus = false

  textbox = Textbox.new()
  textbox:set_text("A " .. firstToUpper(mob.name) .. " appears !")

  local width, height = love.window.getMode() -- On récupère la taille de l'écran
  fight.resize(width, height)
end

function fight.update(dt)
  if infocus and actions[focus].label == "Flee" then
    change_state(move)
  end
end

function fight.draw()
  if not infocus then
    -- Show actions
    for i, action in ipairs(actions) do
      if i == focus and not textbox.show then
        love.graphics.print("> " .. action.label, action.x, action.y)
      else
        love.graphics.print(action.label, action.x, action.y)
      end
    end
  else
    -- Show skills
    for i, skill in ipairs(actions[focus].skills) do
      if i == skill_focus and not textbox.show then
        love.graphics.print("> " .. skill.label, skill.x, skill.y)
      else
        love.graphics.print(skill.label, skill.x, skill.y)
      end
    end
  end
  -- Show dialogs
  textbox:draw()
  drawMob()
end

function fight.keypressed(key)
  if textbox.show then
    textbox:keypressed(key)
  else
    if focus > 0 then
      if key == "up" then
        if not infocus and focus > 1 then
          focus = focus - 1
        elseif infocus and skill_focus > 1 then
          skill_focus = skill_focus - 1
        end
      elseif key == "down" then
        if not infocus and focus < table.getn(actions) then
          focus = focus + 1
        elseif infocus and skill_focus < table.getn(actions[focus].skills) then
          skill_focus = skill_focus + 1
        end
      elseif key == "return" then
        if not infocus then
          skill_focus = 1
          infocus = true
        elseif infocus then
          battle(actions[focus].skills[skill_focus])
          infocus = false
          --focus = 0
          skill_focus = 1
        end
      elseif key == "escape" then
        infocus = false
      end
    end
  end
end

function fight.resize(width, height)
  local action_box = { x = width / 5, y = height / 8 }
  local mob_box = { x = (width / 5) * 3, y = (height / 8) * 2 }

  for i, action in ipairs(actions) do
    action.x = action_box.x
    action.y = action_box.y + 35 * i
    for j, skill in ipairs(action.skills) do
      skill.x = action_box.x
      skill.y = action_box.y + 35 * j
    end
  end

  textbox:resize(width, height)

  mob.x = mob_box.x
  mob.y = mob_box.y

  -- Data to show info of mob
  dataDrawMob = {}
  local offset = 4
  dataDrawMob.namey = mob.y + mob.h * mob.sx * 2 + offset
  dataDrawMob.healthbary = dataDrawMob.namey + 14 + offset
  dataDrawMob.healthbarw = mob.w * mob.sx * 2
  dataDrawMob.healthbarh = 20
  dataDrawMob.d = dataDrawMob.healthbarw / mob.health

  local margin = 25
  dataBackground = {
    x = width / 5 - margin, y = 0, w = (width / 5) * 3 + margin, h = height
  }
end

function drawMob()
  love.graphics.draw(mob.image, mob.x, mob.y, mob.r, mob.sx)
  love.graphics.print(firstToUpper(mob.name), mob.x, dataDrawMob.namey)
  love.graphics.setColor(0, 255, 0)
  love.graphics.rectangle('fill', mob.x, dataDrawMob.healthbary, dataDrawMob.d * mob.health, dataDrawMob.healthbarh)
  love.graphics.setColor(255, 255, 255)
  love.graphics.setLineWidth(2.5)
  love.graphics.rectangle('line', mob.x, dataDrawMob.healthbary, dataDrawMob.healthbarw, dataDrawMob.healthbarh)
end

function battle(action)
  local text = "You use " .. action.label .. ".\n"

  local mob_player, isCritical = nil, nil
  local player_effect = love.math.random(action.effect[1], action.effect[2])

  if focus == 1 then -- Attack
    mob.hit(player_effect)
    text = text .. "\nYou inflict " .. player_effect .. " damage.\n"
    mob_player, isCritical = mob.attack()
  elseif focus == 2 then -- Defense
    mob_player, isCritical = mob.attack(player_effect)
  end

  text = text .. "\nYou take " .. mob_player .. " damage.\n"
  if isCritical then
    text = text .. "\n\nCritical hit !"
  end

  if mob.health <= 0 then
    text = text .. "\n" .. firstToUpper(mob.name) .. " dies !\n"
    change_state(move)
  end

  textbox:set_text(text)
end

function firstToUpper(str)
  return (str:gsub("^%l", string.upper))
end
