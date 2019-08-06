local DataCoffre = {}
local DataUser = {}

RegisterNetEvent("VenatoSpawn")
AddEventHandler("VenatoSpawn", function()
  TriggerServerEvent("Coffre:CallData")
end)

RegisterNetEvent("Coffre:CallData:cb")
AddEventHandler("Coffre:CallData:cb", function(Coffre, user)
  DataCoffre = Coffre
  DataUser = user or {}
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local x,y,z = table.unpack(GetEntityCoords(Venato.GetPlayerPed(), true))
    for k,v in pairs(DataCoffre) do
      if Vdist(x, y, z, v.x, v.y, v.z) < 1 then
        DrawMarker(27,v.x,v.y,v.z-0.9,0,0,0,0,0,0,1.0,1.0,1.0,0,150,255,200,0,0,0,0)
        Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ Pour ouvrir le coffre.')
        if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
          OpenCoffre(k)
          Menu.toggle()
        end
      elseif  Vdist(x, y, z, v.x, v.y, v.z) < 20 then
        DrawMarker(27,v.x,v.y,v.z-0.9,0,0,0,0,0,0,1.0,1.0,1.0,0,150,255,200,0,0,0,0)
      end
    end
  end
end)

function OpenCoffre(index)
  Menu.clearMenu()
  TriggerServerEvent("Coffre:CallData")
  Menu.setTitle( DataCoffre[index].nom)
  Menu.setSubtitle( "Coffre :")
  Menu.addButton("~p~Parametres", "CoffreParametre", index)
  Menu.addButton("~g~"..Venato.FormatMoney(DataCoffre[index].argent,2).." / "..Venato.FormatMoney(DataCoffre[index].argentcapacite,2), "CoffreMenuMoney", index)
  Menu.addButton("~r~Armes", "CoffreWeapon", index)
  Menu.addButton("~r~--------------~g~items~r~-----------------", "none", nil)
  Menu.addButton("~y~Déposer des items", "CoffreAddItem", index)
  for k,v in pairs(DataCoffre[index].inventaire) do
    if v.quantity ~= 0 then
      Menu.addButton(v.libelle.." : ~r~"..v.quantity, "CoffreTakeItem", {index, k})
    end
  end
end

function CoffreAddItem(index)
  Menu.clearMenu()
  Menu.setTitle( "Mes items")
  Menu.addButton("~r~↩ Retour", "OpenCoffre", index)
  for k,v in pairs(DataUser.Inventaire) do
		if v.quantity > 0 then
      Menu.addButton(v.libelle.." : ~r~"..v.quantity, "CoffreDropItem", {index, k})
    end
  end
end

function CoffreDropItem(row)
  local qty =  Venato.OpenKeyboard('', '0', 10,"Nombre à déposer")
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 then
    TriggerServerEvent("Coffre:DropItem", qty , row)
  else
    Venato.notify("~r~Une erreur est survenue.")
  end
end

function CoffreWeapon(index)
  Menu.clearMenu()
  Menu.setTitle( "Armes : "..DataCoffre[index].nbWeapon.." / "..DataCoffre[index].maxWeapon)
  Menu.addButton("~r~↩ Retour", "OpenCoffre", index)
  Menu.addButton("~y~Déposer une armes", "CoffreDropWeapon", index)
  for k,v in pairs(DataCoffre[index].weapon) do
    Menu.addButton(v.libelle.." avec ~r~"..v.balles.." balles", "CoffreWeaponOption", {index, k})
  end
end

function CoffreDropWeapon(index)
  Menu.clearMenu()
  Menu.setTitle( "Mes armes")
  Menu.addButton("~r~↩ Retour", "OpenCoffre", index)
  for k,v in pairs(DataUser.Weapon) do
    Menu.addButton(v.libelle.." avec ~r~"..v.ammo.." balles", "CoffreConfirmDropWeapon", {index, k})
  end
end

function CoffreConfirmDropWeapon(row)
  if DataCoffre[row[1]].nbWeapon + 1 <= DataCoffre[row[1]].maxWeapon then
    Menu.clearMenu()
    Menu.setTitle( "Voulez vous vraiment déposer l'arme ?")
    Menu.addButton("~r~Non", "CoffreDropWeapon", row[1])
    Menu.addButton("~g~Déposer l'arme dans le coffre", "CoffreDropWp", row)
  else
    Venato.notify("~r~Il n'y a pas de place pour cette arme.")
  end
end

function CoffreDropWp(row)
  Menu.close()
  TriggerServerEvent("Coffre:DropWeapon", row)
end


function CoffreWeaponOption(row)
  Menu.clearMenu()
  Menu.addButton("~r~↩ Retour", "OpenCoffre", row[1])
  Menu.addButton("Recuperer l'arme", "CoffreTakeWeapon", row)
end

function CoffreTakeWeapon(row)
  if DataCoffre[row[1]].weapon[row[2]].poid + DataUser.Poid <= DataUser.PoidMax then
    OpenCoffre(row[1])
    TriggerServerEvent("Coffre:TakeWeapon", row)
  else
    Venato.notify("~r~Vous etes trop lourd pour prendre l'arme.")
  end
end

function CoffreParametre(index)
  Menu.clearMenu()
  Menu.setTitle( "~b~ Parametres")
  Menu.addButton("~r~↩ Retour", "OpenCoffre", index)
  Menu.addButton("Liste des perssones avec l'acces", "CoffreListWhitelist", index)
  Menu.addButton("Donner l'acces à une perssones", "CoffreAddWhitelist", index)
end

function CoffreAddWhitelist(index)
  Menu.clearMenu()
  Menu.setTitle( "Personne à proximité")
  player, dist = Venato.ClosePlayer()
  if player ~= 0 and player ~= nil and dist < 10 then
    TriggerServerEvent("Coffre:CallDataClosePlayer", index, player)
  else
    Menu.addButton("~r~↩ Retour", "CoffreParametre", index)
    Menu.addButton("~r~Aucune personne à proximité", "CoffreParametre", index)
  end
end

RegisterNetEvent("Coffre:CallDataClosePlayer:cb")
AddEventHandler("Coffre:CallDataClosePlayer:cb", function(Coffre, index, user)
  DataCoffre = Coffre
  local DataUserClose = user
  Menu.addButton("~r~↩ Retour", "CoffreParametre", index)
  Menu.addButton("Whitelister "..DataUserClose.Prenom.." "..DataUserClose, "CoffreWhitelistPlayer", {index, user})
end)

function CoffreWhitelistPlayer(row)
  TriggerServerEvent("Coffre:CoffreWhitelistPlayer", row)
  Menu.close()
end

function CoffreListWhitelist(index)
  Menu.clearMenu()
  Menu.setTitle( "~b~Whitelist")
  Menu.addButton("~r~↩ Retour", "CoffreParametre", index)
  for k,v in pairs(DataCoffre[index].whitelist) do
    Menu.addButton(v.prenom.." "..v.nom, "unwhitelist", {index, v.identifier, v.nom, v.prenom})
  end
end

function unwhitelist(row)
  Menu.clearMenu()
  Menu.setTitle( "Voulez déwhitlister "..row[4].." "..row[3])
  Menu.addButton("~r~Non", "CoffreListWhitelist", row[1])
  Menu.addButton("Déwhitelist "..row[4].." "..row[3], "confirmUnWhitelist", row)
end

function confirmUnWhitelist(row)
  TriggerServerEvent("Coffre:UnWhitelist", row)
end

function CoffreMenuMoney(index)
  Menu.clearMenu()
  Menu.addButton("~r~↩ Retour", "OpenCoffre", index)
  Menu.addButton("Prendre de l'argents", "CoffreTakeMoney", index)
  Menu.addButton("Déposer de l'argents", "CoffreDropMoney", index)
end

function CoffreTakeItem(row)
  local qty =  Venato.OpenKeyboard('', '0', 3,"Nombre à prendre")
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 and tonumber(qty) <= DataCoffre[row[1]].inventaire[row[2]].quantity and DataCoffre[row[1]].inventaire[row[2]].uPoid * qty <= DataUser.PoidMax then
    TriggerServerEvent("Coffre:TakeItems", qty , row)
  else
    Venato.notify("~r~Une erreur est survenue.")
  end
end

function CoffreTakeMoney(index)
  local qty =  Venato.OpenKeyboard('', '0', 10,"Nombre à prendre")
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 and tonumber(qty) <= DataCoffre[index].argent and Venato.MoneyToPoid(qty) + DataUser.Poid <= DataUser.PoidMax then
    TriggerServerEvent("Coffre:TakeMoney", qty , index)
  else
    Venato.notify("~r~Une erreur est survenue.")
  end
end

function CoffreDropMoney(index)
  local qty =  Venato.OpenKeyboard('', '0', 10,"Nombre à prendre")
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 and tonumber(qty) + DataCoffre[index].argent <= DataCoffre[index].argentcapacite then
    TriggerServerEvent("Coffre:DropMoney", qty , index)
  else
    Venato.notify("~r~Une erreur est survenue.")
  end
end
