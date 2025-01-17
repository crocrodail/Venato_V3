local mecano_nbMecanoInService = 0
local ismeca = false

RegisterNetEvent("four:getItemsVeh")
AddEventHandler("four:getItemsVeh", function(THEITEMS, my)
    ITEMS = {}
    ITEMS = THEITEMS
    local my = my
    TriggerEvent('Menu:Init', "Fourrière", "Mes véhicules", '#1E88E599', "https://i.ibb.co/mBYMkLL/image.png")
    if my == 1 then
      FourriereMenuMY()
    else
      FourriereMenu()
    end
end)

RegisterNetEvent('mecano:personnelChange')
AddEventHandler('mecano:personnelChange',function(nbPersonnel, nbDispo)
    mecano_nbMecanoInService = nbPersonnel
end)

function FourriereMenu()
    Menu.setTitle("Fourriere")
    Menu.clearMenu()
    Menu.setSubtitle("Liste des vehicules en fourrière")
    for key, value in pairs(ITEMS) do
        Menu.addButton2("Model : " .. tostring(value.name) .. " /  Plaque : " .. tostring(value.plate) .. "  / Propriétaire :" .. tostring(value.nom) .. " " .. tostring(value.prenom), "ItemMenu", key)
    end
    Menu.CreateMenu()
end

function FourriereMenuMY()
  Menu.setTitle("Fourriere")
  Menu.clearMenu()
  Menu.setSubtitle("Liste de mes vehicules en fourrière")
    for key, value in pairs(ITEMS) do
        Menu.addButton2("Model : " .. tostring(value.name) .. " /  Plaque : " .. tostring(value.plate) .. "", "ItemMenumy", key)
    end
    Menu.CreateMenu()
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
  local testok = false
    while true do
      local ped = PlayerPedId()
      local dis = GetDistanceBetweenCoords(GetEntityCoords(ped), 397.566, -1642.656, 29.291, true)
        Citizen.Wait(0)
        if dis < 15.0 then
          if not venato.HasJob(16) then  
            if mecano_nbMecanoInService == 0 then        
              DrawMarker(1,397.566, -1642.656, 29.291 -1.0001, 0, 0, 0, 0, 0, 0, 1.01, 1.01, 0.3, 212, 189, 0, 105, 0, 0, 2, 0, 0, 0, 0)
              if dis < 1.0 then
                  DisplayHelpText("Utilise ~INPUT_CONTEXT~ pour acceder à la fourrière.")
                if(IsControlJustReleased(1, 51))then
                  TriggerServerEvent("four:getmyVeh")
                      --  FourriereMenu()
                  Menu.toggle()
                end
              end
            elseif mecano_nbMecanoInService > 0 then
              DisplayHelpText("Au moins un mécano est en service, contactez-le pour sortir votre véhicule de la fourrière.")
            end
          end
        end
        
        if dis < 15.0 and venato.HasJob(16) then
            DrawMarker(1,397.566, -1642.656, 29.291 -1.0001, 0, 0, 0, 0, 0, 0, 1.01, 1.01, 0.3, 212, 189, 0, 105, 0, 0, 2, 0, 0, 0, 0)
            if GetDistanceBetweenCoords(GetEntityCoords(ped), 397.566, -1642.656, 29.291, true) < 1.0 then
                DisplayHelpText("Utilise ~INPUT_CONTEXT~ pour acceder à la fourrière.")
              if(IsControlJustReleased(1, 51))then
                TriggerServerEvent("four:getVeh")
                Menu.toggle()
              end
            end
        end
    end
end)

function ItemMenu(itemId)
  Menu.clearMenu()
  Menu.setTitle("Details")
	Menu.addButton("Sortir", "sortir", itemId)
  Menu.addButton("Non", "kill", nil)

end

function ItemMenumy(itemId)
  Menu.clearMenu()
  Menu.setTitle("Details")
	Menu.addButton("Payer 5000€", "sortirmy", itemId)
  Menu.addButton("Non", "kill", nil)
end

function sortir(item)
	TriggerServerEvent("garagesmeca:getvehicle",ITEMS[item])
  Menu.toggle()
end

function kill(item)
	Menu.toggle()
end

function sortirmy(item)
	TriggerServerEvent("garagesmeca:getvehiclemy",ITEMS[item])

	Menu.toggle()
end


--401.199, -1632.149, 28.291
RegisterNetEvent('garagesmeca:spawnvehicle')
AddEventHandler('garagesmeca:spawnvehicle', function(vhl)
  local vhl = vhl
  local vhle = {type=tonumber(vhl.type),model=vhl.idveh,name=vhl.name,plate=vhl.plate,customs=vhl.customs,Health=vhl.Health, x=401.199, y=-1632.149, z=28.291, h= 6.0}
  SortirVoiture(vhle)
end)
