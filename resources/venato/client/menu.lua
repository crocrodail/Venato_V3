
Menu = {}
Menu.hidden = true

function Menu.open()
  TriggerEvent('Menu:Open')
  Menu.hidden = false
end

function Menu.close()
  TriggerEvent('Menu:Close')
  Menu.hidden = true
end

function Menu.toggle()
  if Menu.hidden then
    Menu.open()
  else
    Menu.close()
  end
end

function Menu.setTitle(title)
  TriggerEvent('Menu:Title', title)
end

function Menu.setSubtitle(subtitle)
  TriggerEvent('Menu:SubTitle', subtitle)
end

function Menu.addButton(name, func, args, hover)
  TriggerEvent('Menu:AddButton', name, func, args, hover)
end

function Menu.addItemButton(name, picture, func, args, hover)
  TriggerEvent('Menu:AddItemButton', name, picture, func, args, hover)
end

function Menu.addButton2(name, func, args, hover, picture)
  TriggerEvent('Menu:AddButton2', name, func, args, hover, picture)
end

function Menu.CreateMenu()
  TriggerEvent('Menu:CreateMenu')
end

function Menu.clearMenu()
  TriggerEvent('Menu:Clear')
end

function MenuCallFunction(fnc, arg)
  _G[fnc](arg)
end

RegisterNetEvent("Menu:Execute")
AddEventHandler("Menu:Execute", function(params)
  _ = _G[params.fn] and _G[params.fn](params.args)
end)
