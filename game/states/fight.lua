fight = {}

function fight.load()
  actions = {
    { x = nil, y = nil, label = "Attack", skills = { { x = nil, y = nil, label = "Punch" } } },
    { x = nil, y = nil, label = "Defense", skills = { { x = nil, y = nil, label = "Shield" } } },
    { x = nil, y = nil, label = "Flee", skills = {} }
  }
  focus = 1
  infocus = false

  dialogs = {
    x = nil,
    y = nil,
    text = "A " .. "<mob.name>" .. " appears !"
  }

  local width, height = love.window.getMode() -- On récupère la taille de l'écran
  local dialog_box = { x = width / 5, y = (height / 8) * 5 }
  local action_box = { x = width / 5, y = height / 8 }

  for i, action in ipairs(actions) do
    action.x = action_box.x
    action.y = action_box.y + 35 * i
    for j, skill in ipairs(action.skills) do
      skill.x = action_box.x
      skill.y = action_box.y + 35 * i
    end
  end

  dialogs.x = dialog_box.x
  dialogs.y = dialog_box.y
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
      if i == focus then
        love.graphics.print("> " .. action.label, action.x, action.y)
      else
        love.graphics.print(action.label, action.x, action.y)
      end
    end
  else
    -- Show skills
    for i, skill in ipairs(actions[focus].skills) do
      if i == skill_focus then
        love.graphics.print("> " .. skill.label, skill.x, skill.y)
      else
        love.graphics.print(skill.label, skill.x, skill.y)
      end
    end
  end
  -- Show dialogs
  love.graphics.print(dialogs.text, dialogs.x, dialogs.y)
end

function fight.keypressed(key)
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
      dialogs.text = "You use " .. actions[focus].skills[skill_focus].label
    end
  elseif key == "escape" then
    infocus = false
  end
end

function fight.resize(width, height)
  local dialog_box = { x = width / 5, y = (height / 8) * 7 }
  local action_box = { x = width / 5, y = height / 8 }

  for i, action in ipairs(actions) do
    action.x = action_box.x
    action.y = action_box.y + 35 * i
  end
end
