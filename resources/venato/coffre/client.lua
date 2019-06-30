local DataCoffre = {}

RegisterNetEvent("VenatoSpawn")
AddEventHandler("VenatoSpawn", function()
  TriggerServerEvent("Coffre:CallData")
end)

RegisterNetEvent("Coffre:CallData:cb")
AddEventHandler("Coffre:CallData:cb", function(Coffre, user)
  DataCoffre = Coffre
  DataUser = user
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    for k,v in pairs(DataCoffre) do
      if  Vdist(x, y, z, v.x, v.y, v.z) < 20 then
        DrawMarker(27,v.x,v.y,v.z+0.1,0,0,0,0,0,0,1.0,1.0,1.0,0,150,255,200,0,0,0,0)
      elseif  Vdist(x, y, z, v.x, v.y, v.z) < 1 then
        DrawMarker(27,v.x,v.y,v.z+0.1,0,0,0,0,0,0,1.0,1.0,1.0,0,150,255,200,0,0,0,0)
        Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ Pour ouvrir le coffre.')
        if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
          OpenCoffre(k)
          showPageInfo = not showPageInfo
          Menu.hidden = not Menu.hidden
        end
      end
    end
  end
end)

function OpenCoffre(index)
  ClearMenu()
  MenuTitle = DataCoffre[index].nom
  MenuDescription = "~b~Option"
  Menu.addButton("~p~Parametres", "CoffreParametre", index)
  Menu.addButton("~g~"..Venato.FormatMoney(DataCoffre[index].money,2).." / "..Venato.FormatMoney(DataCoffre[index].argentcapacite,2) "CoffreMenuMoney", index)
  Menu.addButton("~r~Armes", "CoffreWeapon", index)
  Menu.addButton("~r~--------------~g~items~r~-----------------", "none", nil)
  Menu.addButton("~y~Déposer des items", "CoffreAddItem", index) --#################################################################
  for k,v in pairs(DataCoffre[index].itemsContenu) do
    if v.quantity ~= 0 then
      Menu.addButton(v.libelle.." : ~r~"..v.quantity, "CoffreMenuItem", {index, k})
    end
  end
end

function CoffreAddItem(index)
  ClearMenu()
  MenuTitle = "Mes items"
  Menu.addButton("~r~↩ Retour", "OpenCoffre", index)
  for k,v in pairs(DataUser.Inventaire) do
    Menu.addButton(v.libelle.." : ~r~"..v.quantity, "CoffreDropItem", {index, k})
  end
end

function CoffreDropItem(row)
  local qty =  Venato.OpenKeyboard('', '0', 10,"Nombre à déposer")
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 and tonumber(qty) <= DataUser.Inventaire[row[2]].quantity and (nb item+qty ~= maxitem) then --#############################
    TriggerServerEvent("Coffre:TakeMoney", qty , row)
  else
    Venato.notify("~r~Une erreur est survenue.")
  end
end

function CoffreWeapon(index)
  ClearMenu()
  MenuTitle = "Armes"
  Menu.addButton("~r~↩ Retour", "OpenCoffre", index)
  Menu.addButton("~y~Déposer une armes", "CoffreDropWeapon", index)
  for k,v in pairs(DataCoffre[index].weapon) do
    Menu.addButton(v.libelle.." avec ~r~"..v.balles.." balles", "CoffreWeaponOption", {index, k})
  end
end

function CoffreDropWeapon(index)
  ClearMenu()
  MenuTitle = "Mes armes"
  Menu.addButton("~r~↩ Retour", "OpenCoffre", index)
  for k,v in pairs(DataUser.weapon) do
    Menu.addButton(v.libelle.." avec ~r~"..v.balles.." balles", "CoffreConfirmDropWeapon", {index, k})
  end
end

function CoffreConfirmDropWeapon(row)
  ClearMenu()
  MenuTitle = "Voulez vous vraiment déposer l'arme ?"
  Menu.addButton("~r~Non", "CoffreDropWeapon", row[1])
  Menu.addButton("~g~Déposer l'arme dans le coffre", "CoffreDropWp", row)
end

function CoffreDropWp(row)
  OpenCoffre(row[1])
  TriggerServerEvent("Coffre:DropWeapon", row)--#####################################
end


function CoffreWeaponOption(row)
  ClearMenu()
  Menu.addButton("~r~↩ Retour", "OpenCoffre", row[1])
  Menu.addButton("Recuperer l'arme", "CoffreTakeWeapon", row)
end

function CoffreTakeWeapon(row)
  OpenCoffre(row[1])
  TriggerServerEvent("Coffre:TakeWeapon", row) -- ###################################
end


function CoffreParametre(index)--###################################
  ClearMenu()
  MenuTitle = "~b~ Parametres"
  Menu.addButton("~r~↩ Retour", "OpenCoffre", index)
  Menu.addButton("Liste des perssones avec l'acces", "CoffreListWhitelist", index)
  Menu.addButton("Donner l'acces à une perssones", "CoffreAddWhitelist", index)
end

function CoffreMenuItem(row)
  ClearMenu()
  Menu.addButton("~r~↩ Retour", "OpenCoffre", row[1])
  Menu.addButton("Prendre des items", "CoffreTakeItem", row)
end

function MenuMoney(index)
  ClearMenu()
  Menu.addButton("~r~↩ Retour", "OpenCoffre", index)
  Menu.addButton("Prendre de l'argents", "CoffreTakeMoney", index)
  Menu.addButton("Déposer de l'argents", "CoffreDropMoney", index)
end

function CoffreTakeItem(row)
  local qty =  Venato.OpenKeyboard('', '0', 3,"Nombre à prendre")
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 and tonumber(qty) <= DataCoffre[row[1]].itemsContenu[row[2]].quantity then
    TriggerServerEvent("Coffre:TakeItems", qty , row)
  else
    Venato.notify("~r~Une erreur est survenue.")
  end
end

function CoffreTakeMoney(index)
  local qty =  Venato.OpenKeyboard('', '0', 10,"Nombre à prendre")
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 and tonumber(qty) <= DataCoffre[row[1]].money then
    TriggerServerEvent("Coffre:TakeMoney", qty , row)
  else
    Venato.notify("~r~Une erreur est survenue.")
  end
end

function CoffreDropMoney(index)
  local qty =  Venato.OpenKeyboard('', '0', 10,"Nombre à prendre")
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 and tonumber(qty) + DataCoffre[row[1]].money <= DataCoffre[row[1]].argentcapacite then
    TriggerServerEvent("Coffre:CoffreDropMoney", qty , row)
  else
    Venato.notify("~r~Une erreur est survenue.")
  end
end
