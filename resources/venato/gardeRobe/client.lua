local coord = { x = -167.359, y = -300.007, z = 39.650 }
local menuIsOpen = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local dist = Vdist2(GetEntityCoords(GetPlayerPed(-1), true), coord.x, coord.y, coord.z)
    if dist < 1 then
      venato.InteractTxt("Appuyez sur la touche ~INPUT_CONTEXT~ pour ouvrir le garage.")
      venato.groundMarker(coord.x, coord.y, coord.z-1)
      if IsControlJustPressed(0, Keys["E"]) then
        openMenuGardeRobe()
      end
    elseif dist < 50 then
      venato.groundMarker(coord.x, coord.y, coord.z-1)
    elseif menuIsOpen == true then
      Menu.close()
      menuIsOpen = false
    end
  end
end)

function openMenuGardeRobe()
  local dataPlayer = venato.getDataPlayer()
  menuIsOpen = true
  TriggerEvent('Menu:Init', "Garde-Robe", "Stoquez vos plus belle tenues", "#00aa3a99", "https://milksymposium.org/wp-content/uploads/2017/08/spacer-garde-robe-walk-in-et-rangement-sur-mesure-quc3a3c2a9bec-porte-garde-robe-moderne-garde-robe-moderne.jpg")
  Menu.clearMenu()
  Menu.open()
  Menu.addButton2("Déposer sa tenue", "leaveClothe", nil, '', 'https://cdn0.iconfinder.com/data/icons/human-body-5/64/40-512.png')
  -- for i,v in ipairs(table_name) do
  --   Menu.addButton2(v.name, "", i, 'tryClothes', '')
  -- end
  Menu.CreateMenu()
end

function leaveClothe()
  local name = tostring(venato.OpenKeyboard("Nom de la tenue", '', 255, "Nom de la tenue"))
  local nude = configGardeRobe()
  if name ~= nil and name ~= "" then
    local response = venato.callServer("gardeRobe:saveClothes", name)
  end
  SetPedComponentVariation(venato.GetPlayerPed(), 3, nude.ComponentVariation.torso.id, nude.ComponentVariation.torso.color, 1)
  SetPedComponentVariation(venato.GetPlayerPed(), 4, nude.ComponentVariation.leg.id, nude.ComponentVariation.leg.color, 1)
  SetPedComponentVariation(venato.GetPlayerPed(), 5, nude.ComponentVariation.parachute.id, nude.ComponentVariation.parachute.color, 1)
  SetPedComponentVariation(venato.GetPlayerPed(), 6, nude.ComponentVariation.shoes.id, nude.ComponentVariation.shoes.color, 1)
  SetPedComponentVariation(venato.GetPlayerPed(), 7, nude.ComponentVariation.accessory.id, nude.ComponentVariation.accessory.color, 1)
  SetPedComponentVariation(venato.GetPlayerPed(), 8, nude.ComponentVariation.undershirt.id, nude.ComponentVariation.undershirt.color, 1)
  SetPedComponentVariation(venato.GetPlayerPed(), 9, nude.ComponentVariation.kevlar.id, nude.ComponentVariation.kevlar.color, 1)
  SetPedComponentVariation(venato.GetPlayerPed(), 10, nude.ComponentVariation.badge.id, nude.ComponentVariation.badge.color, 1)
  SetPedComponentVariation(venato.GetPlayerPed(), 11, nude.ComponentVariation.torso2.id, nude.ComponentVariation.torso2.color, 1)
end
