local ItemsOnTheGround = {}
local MoneyOnTheGround = {}
local WeaponOnTheGround = {}
local dropMoney = "prop_cash_case_01"
local dropWeapon = "prop_hockey_bag_01"
local dropItem = "prop_cs_box_clothes"
local PapierOpen = 0

local defaultNotification = {
  title = "Inventaire",
  type = "alert",
  logo = "https://i.ibb.co/qJ2yMXG/icons8-backpack-96px-1.png"
}

local commandHelp = {
  id = "inventoryDrop",
  command = "E",
  icon = "https://i.ibb.co/VgYnKHc/icons8-grab-48px-1.png",
  text = "Récupérer"
}

local isCommandAdded = nil;
local oldCommandAdded = nil;

-- ######## CONFIG ##############
local PoidMax = 20 -- Kg
--##############################
function extOpenInventory()
  Menu.open()
  OpenInventory()
end

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(0)
    
		if IsControlJustPressed(1, Keys['K']) and GetLastInputMethod(2) then
			Menu.clearMenu()
			if Menu.hidden == true then
				Menu.open()
				OpenInventory()
			else
				Menu.close()
			end
		end
		if IsControlJustPressed(1, Keys['BACKSPACE']) or IsControlJustPressed(1, Keys['RIGHTMOUSE']) and GetLastInputMethod(2) then
			if Menu.hidden then
				CloseDoc()
			end
			TriggerEvent("VehicleCoffre:Close")
			Menu.close()
		end

    if ItemsOnTheGround ~= nil then
      local x,y,z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
      
      for k,v in pairs(ItemsOnTheGround) do        
        local dis = Vdist(x, y, z, v.x, v.y, v.z)
        if dis <= 1 then
					venato.Text3D(v.x, v.y, v.z, "<span class='blue--text'>"..v.qty.." "..v.libelle)
          if not isCommandAdded and oldCommandAdded ~= v.dropId then
            commandHelp.text = "Récupérer "..v.qty.." "..v.libelle
            TriggerEvent('Commands:Add', commandHelp)
            isCommandAdded = v.dropId
          end
          if IsControlJustPressed(1, Keys['E']) and GetLastInputMethod(2) then
						if (v.qty*v.uPoid + DataUser.Poid) <= PoidMax then
							TriggerServerEvent("Inventory:AddItem", v.qty , v.id)
              TriggerServerEvent("Inventory:DelItemsOnTheGround", k)
              local notif = defaultNotification;
              TriggerEvent('Commands:Remove', commandHelp.id)
              oldCommandAdded = v.dropId    
              isCommandAdded = nil
              notif.message = "Vous avez ramassé "..v.qty.." "..v.libelle.." ."
              notif.logo = v.picture
              notif.title = "Inventaire"
							venato.notify(defaultNotification)
							local pedCoords = GetEntityCoords(PlayerPedId())
							local objet = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 10.0, GetHashKey(dropItem))
							if objet ~= 0 and objet ~= nil then
								ForceDeleteObject(objet)
							end
						else
							venato.notifyError("Vous n'avez pas assez de place pour "..v.qty.." "..v.libelle.." .")
						end
          end
        elseif isCommandAdded == v.dropId and dis > 1 then
          TriggerEvent('Commands:Remove', commandHelp.id)
          isCommandAdded = nil
				elseif dis < 10 then
					venato.Text3D(v.x, v.y, v.z, "~b~"..v.qty.." "..v.libelle)
				end
			end
		end

		if MoneyOnTheGround ~= nil then
			local x,y,z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
      for k,v in pairs(MoneyOnTheGround) do
				local dis = Vdist(x, y, z, v.x, v.y, v.z)
				if dis < 1 then
          venato.Text3D(v.x, v.y, v.z, "~b~"..venato.FormatMoney(v.qty,2).." €")
          if isCommandAdded == nil and oldCommandAdded ~= v.dropId then
            commandHelp.text = "Récupérer "..venato.FormatMoney(v.qty,2).." €"
            TriggerEvent('Commands:Add', commandHelp)
            isCommandAdded = v.dropId
          end					
					if IsControlJustPressed(1, Keys['E']) and GetLastInputMethod(2) then
						if (venato.MoneyToPoid(v.qty) + DataUser.Poid) <= PoidMax then
							TriggerServerEvent("Inventory:AddMoney", v.qty)
              TriggerServerEvent("Inventory:DelMoneyOnTheGround", k)
              defaultNotification.logo = "https://i.ibb.co/VgYnKHc/icons8-grab-48px-1.png"
              defaultNotification.message = "Vous avez ramassez "..venato.FormatMoney(v.qty,2).." € .";
              TriggerEvent('Commands:Remove', commandHelp.id)
              isCommandAdded = nil
              oldCommandAdded = v.dropId
              venato.notify(defaultNotification)
							local pedCoords = GetEntityCoords(PlayerPedId())
							local objet = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 10.0, GetHashKey(dropMoney))
							if objet ~= 0 and objet ~= nil then
								ForceDeleteObject(objet)
							end
						else
							venato.notifyError("Vous n'avez pas assez de place pour "..v.qty.." € .")
						end
					end
				elseif isCommandAdded ~= nil and isCommandAdded == v.dropId and dis > 1 then
          TriggerEvent('Commands:Remove', commandHelp.id)
          isCommandAdded = nil
				elseif dis < 10 then
					venato.Text3D(v.x, v.y, v.z, "~b~"..v.qty.." €")
				end
			end
		end

		if WeaponOnTheGround ~= nil then
			local x,y,z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
      for k,v in pairs(WeaponOnTheGround) do
				local dis = Vdist(x, y, z, v.x, v.y, v.z)
        if dis < 1 then          
          venato.Text3D(v.x, v.y, v.z, "~b~"..v.libelle)
          if isCommandAdded == nil and oldCommandAdded ~= v.dropId then
            commandHelp.text = "Récupérer "..v.libelle
            TriggerEvent('Commands:Add', commandHelp)
            isCommandAdded = v.dropId
          end		
					if IsControlJustPressed(1, Keys['E']) and GetLastInputMethod(2) then
						if v.uPoid + DataUser.Poid <= PoidMax then
							TriggerServerEvent("Inventory:AddWeapon", v.id, v.ammo, v.uPoid, v.libelle)
							TriggerServerEvent("Inventory:DelWeaponOnTheGround", k)
              defaultNotification.logo = "https://i.ibb.co/VgYnKHc/icons8-grab-48px-1.png"
              defaultNotification.message = "Vous avez ramassé "..v.libelle.." .";
							venato.notify(defaultNotification)
              TriggerEvent('Commands:Remove', commandHelp.id)
              isCommandAdded = nil
              oldCommandAdded = v.dropId
							local pedCoords = GetEntityCoords(PlayerPedId())
							local objet = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 10.0, GetHashKey(dropWeapon))
							if objet ~= 0 and objet ~= nil then
								ForceDeleteObject(objet)
							end
						else
							venato.notifyError("Vous n'avez pas assez de place pour "..v.libelle.." .")
						end
					end
				elseif isCommandAdded ~= nil and isCommandAdded == v.dropId and dis > 1 then
          TriggerEvent('Commands:Remove', commandHelp.id)
          isCommandAdded = nil
				elseif dis < 10 then
					venato.Text3D(v.x, v.y, v.z, "~b~"..v.libelle.." .")
				end
			end
		end
	end
end)

function ForceDeleteObject(objet)
  local id = NetworkGetNetworkIdFromEntity(objet)
  TriggerServerEvent("Inventaire:ForceDeleteObject", id)
end

RegisterNetEvent('Inventaire:ForceDeleteObject:cb')
AddEventHandler('Inventaire:ForceDeleteObject:cb', function(netId)
  if NetworkHasControlOfNetworkId(netId) then
    DeleteObject(NetToObj(netId))
  end
end)

function debuge()
  TriggerServerEvent("debuge")
end

function OpenInventory(wait)
  if wait ~= nil then
    Citizen.Wait(wait)
  end
  TriggerEvent('Menu:Init', "00 / 20 Kg", "Inventaire", '#01579B99',
    "https://www.expertpublic.fr/wp-content/uploads/2019/01/se-faire-argent-de-poche.jpg")
  TriggerServerEvent("Inventory:ShowMe")
end



RegisterNetEvent('Inventory:RefreshTattoo:cb')
AddEventHandler('Inventory:RefreshTattoo:cb', function(Data)
  DataUser.Tattoos = Data
end)

RegisterNetEvent('Inventory:ShowMe:cb')
AddEventHandler('Inventory:ShowMe:cb', function(Data)
  Menu.clearMenu()

  local color = "</span>"
  if Data.Poid > 18 then
    color = "<span class='red--text'>"
  elseif Data.Poid > 14 then
    color = "<span class='orange--text'>"
  end
  Menu.setTitle(color .. "" .. Data.Poid .. "</span>/ 20 Kg")
  Menu.setSubtitle("Inventaire")

  DataUser = Data
  local WeaponPoid = 0
  for k, v in pairs(Data.Weapon) do
    if v.libelle ~= nil then
      WeaponPoid = WeaponPoid + v.poid
    end
  end

  local MoneyPoid = venato.MoneyToPoid(Data.Money)
  Menu.addItemButton("Argent : <span class='green--text'>" .. venato.FormatMoney(Data.Money,
    2) .. " €</span> <span class='orange--text'>(" .. MoneyPoid .. " kg)</span>", "https://i.ibb.co/rZfQxnn/icons8-banknotes-96px.png", "OptionMoney",
    { Data.Money, MoneyPoid, Data.Poid, Data })
  for k, v in pairs(Data.Inventaire) do
    if v.quantity > 0 then
      Menu.addItemButton(v.libelle .. " : " .. v.quantity .. " <span class='orange--text'>(" .. v.poid .. " kg)</span>",
        v.picture,
        "OptionItem", { v.quantity, v.id, v.libelle, v.uPoid, Data.Poid, v.picture, v.consomable})
    end
  end
  Menu.addItemButton("Clefs", "https://i.ibb.co/VwgB5xz/icons8-key-2-96px.png", "Myclef", Data)
  Menu.addItemButton("Armes <span class='orange--text'>(" .. WeaponPoid .. " kg)</span>", "https://i.ibb.co/xfFb7R6/icons8-gun-96px.png","MyWeapon", Data)
  Menu.addItemButton("Documents", "https://i.ibb.co/c2HDBMf/icons8-documents-96px-2.png", "MyDoc", Data)
  Menu.addItemButton("<span class='red--text'>Syncdata</span>", "https://i.ibb.co/Y2QYFcX/icons8-synchronize-96px.png", "debuge", {})
end)

function Myclef(Data)
  TriggerEvent("getInv:clef")
end

RegisterNetEvent("getInv:back")
AddEventHandler("getInv:back", function(TableOfKey)
  Menu.clearMenu()
  Menu.setTitle("Mes clefs")
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenInventory", nil)
  if #TableOfKey > 0 then
    for i, v in pairs(TableOfKey) do
      if v.name ~= nil then
        Menu.addButton("<span class='blue--text'>" .. v.name .. "</span> : <span class='red--text'>" .. v.plate .. "</span>",
          "giveclef", { v.name, v.plate })
      else
        Menu.addButton("<span class='red--text'>Vous n'avez aucune clef</span>", "none", nil)
      end
    end
  end
end)

function giveclef(clef)
  Menu.clearMenu()
  Menu.setTitle("Details:")
  Menu.setSubtitle("<span class='blue--text'>" .. clef[1] .. " plaque : " .. clef[2] .. "</span>")
  Menu.addButton("Donner un double de la clef", "givecleff", { clef[1], clef[2] })
end

function givecleff(item)
  local ClosePlayer, distance = venato.ClosePlayer()
  if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
    TriggerServerEvent("inv:giveclef", GetPlayerServerId(ClosePlayer), item[1], item[2])
    TriggerEvent("Inventory:AnimGive")
    venato.notify("<span class='green--text'>Vous avez donné les clef du vehicule " .. item[1] .. "</span>")
  else
    venato.notifyError("Aucun joueurs à proximité")
  end
end

function MyWeapon(Data)
  Menu.clearMenu()
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenInventory", nil)
  Menu.setSubtitle("Mes armes")
  for k, v in pairs(Data.Weapon) do
    if v.libelle ~= nil then
      if tonumber(v.ammo) > 0 then
        Menu.addButton("<span class='blue--text'>" .. v.libelle .. " </span> munition : <span class='red--text'>" .. v.ammo .. "</span> <span class='orange--text'>( " .. v.poid .. " Kg )</span>",
          "OptionWeapon", { k, v.libelle, v.id, v.poid, v.ammo, Data.Poid, Data })
      else
        Menu.addButton("<span class='blue--text'>" .. v.libelle .. " "..v.id..""..k.."</span> <span class='orange--text'>( " .. v.poid .. " Kg )</span>",
          "OptionWeapon", { k, v.libelle, v.id, v.poid, v.ammo, Data.Poid, Data })
      end
    end
  end
end

--############# Doc ##################

function MyDoc(data)
	Menu.clearMenu()
	Menu.setSubtitle( "Mes Documents")
	Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenInventory", nil)
	if data.Citoyen == 1 then
		Menu.addItemButton("Carte d'identité","https://i.ibb.co/V2vy2Y6/icons8-id-card-96px.png", "optionIdCard", data)
	else
		Menu.addItemButton("Carte de séjour", "https://i.ibb.co/vm9WFHn/icons8-electronic-identity-card-96px.png", "optionVisa", data)
	end
	if data.PermisVoiture ~= "non aquis" or data.PermisVoiture ~= "non aquis" then
		Menu.addItemButton("Permis de conduire", "https://i.ibb.co/D8PPnXK/icons8-driver-license-card-96px-1.png", "optionPermis", data)
  end
	for k,v in pairs(data.Documents) do
		if v.type == "chequier" then
			Menu.addItemButton("Chéquier <span class='orange--text'>("..venato.FormatMoney(v.montant,2).." restant)</span>", "https://i.ibb.co/vs3ptjz/icons8-paycheque-96px-2.png", "CreateCheque", data)
		end
		if v.type == "cheque" then
			Menu.addItemButton("Cheque de <span class='green--text'>"..venato.FormatMoney(v.montant,2).."</span> €", "https://i.ibb.co/ZXZgqSF/icons8-paycheque-96px.png", "showCheque", {data,k})
		end
	end
end

function CloseDoc()
  SendNUIMessage({
    action = 'showIdentity',
    string = "type=close"
  })
  SendNUIMessage({
    action = 'showCheque',
    string = "type=close"
  })
end

function optionPermis(data)
  Menu.clearMenu()
  Menu.setSubtitle("Permis de conduire")
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "MyDoc", data)
  Menu.addButton("Regarder", "ShowPermis", data)
  Menu.addButton("Montrer", "ShowToOtherPermis", data)
end

function optionIdCard(data)
  Menu.clearMenu()
  Menu.setSubtitle("Carte d'identité")
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "MyDoc", data)
  Menu.addButton("Regarder", "ShowIdCard", data)
  Menu.addButton("Montrer", "ShowToOtherIdCard", data)
end

function optionVisa(data)
  Menu.clearMenu()
  Menu.setSubtitle("Permis de séjour")
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "MyDoc", data)
  Menu.addButton("Regarder", "ShowVisa", data)
  Menu.addButton("Montrer", "ShowToOtherVisa", data)
end

function ShowToOtherPermis(data)
  local ClosePlayer, distance = venato.ClosePlayer()
  if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
    TriggerServerEvent("Inventory:ShowToOtherPermis", data, ClosePlayer)
  else
    venato.notifyError("Il n'y a personne à proximité.")
  end
end

function ShowToOtherIdCard(data)
  local ClosePlayer, distance = venato.ClosePlayer()
  if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
    TriggerServerEvent("Inventory:ShowToOtherIdCard", data, ClosePlayer)
  else
    venato.notifyError("Il n'y a personne à proximité.")
  end
end

function ShowToOtherVisa(data)
  local ClosePlayer, distance = venato.ClosePlayer()
  if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
    TriggerServerEvent("Inventory:ShowToOtherVisa", data, ClosePlayer)
  else
    venato.notifyError("Il n'y a personne à proximité.")
  end
end

RegisterNetEvent('Inventory:ShowToOtherPermis:cb')
AddEventHandler('Inventory:ShowToOtherPermis:cb', function(data)
  ShowPermis(data)
end)

RegisterNetEvent('Inventory:ShowToOtherIdCard:cb')
AddEventHandler('Inventory:ShowToOtherIdCard:cb', function(data)
  ShowIdCard(data)
end)

RegisterNetEvent('Inventory:ShowToOtherVisa:cb')
AddEventHandler('Inventory:ShowToOtherVisa:cb', function(data)
  ShowVisa(data)
end)

function CreateCheque(data)
	Menu.clearMenu()
	Menu.setSubtitle("Chèque pour la persone à proximité")
	Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "MyDoc", data)
	Menu.addButton("Donner un chèque", "CreateChequeConf", data)
end

function CreateChequeConf(data)
	local ClosePlayer, distance = venato.ClosePlayer()
	if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
		local montant = venato.OpenKeyboard('', '', 10,"Montant du chèque")
		if montant ~= "" and tonumber(montant) ~= nil and tonumber(montant) ~= 0 then
			TriggerServerEvent("Inventory:CreateCheque", ClosePlayer, montant)
		else
			venato.notifyError("Le montant indiqué est erroné.")
		end
	else
		venato.notifyError("Il n'y a personne à proximité.")
	end
end

function showCheque(data)
  if PapierOpen == 0 then
    PapierOpen = 1
    SendNUIMessage({
      action = 'showCheque',
      string = "&type=show&date=" .. data[1].Documents[data[2]].date ..
        "&nomprenom=" .. data[1].Documents[data[2]].nom1 .. " " .. data[1].Documents[data[2]].prenom1 ..
        "&nomprenomd=" .. data[1].Documents[data[2]].nom2 .. " " .. data[1].Documents[data[2]].prenom2 ..
        "&montant=" .. data[1].Documents[data[2]].montant .. "&num=" .. data[1].Documents[data[2]].numeroDeCompte
    })
  else
    PapierOpen = 0
    CloseDoc()
  end
end

function ShowPermis(data)
  if PapierOpen == 0 then
    PapierOpen = 1
    SendNUIMessage({
      action = 'showIdentity',
      string = "type=permis&nom=" .. data.Nom .. "&prenom=" .. data.Prenom ..
        "&age=" .. data.Age .. "&sex=" .. data.Sexe .. --"&job=" .. data.NameJob ..
        "&id=" .. data.Source .. "&steam=" .. data.SteamId .. "&datevoiture=" .. data.PermisVoiture ..
        "&datecamion=" .. data.PermisCamion .. "&point=" .. data.Point ..
        "&startvisa=" .. data.VisaStart .. "&endvisa=" .. data.VisaEnd ..
        "&url=" .. venato.ConvertUrl(data.Url)
    })
  else
    PapierOpen = 0
    CloseDoc()
  end
end

function ShowIdCard(data)
  if PapierOpen == 0 then
    PapierOpen = 1
    SendNUIMessage({
      action = 'showIdentity',
      string = "type=identity&nom=" .. data.Nom .. "&prenom=" .. data.Prenom ..
        "&age=" .. data.Age .. "&sex=" .. data.Sexe ..-- "&job=" .. data.NameJob ..
        "&id=" .. data.Source .. "&steam=" .. data.SteamId .. "&datevoiture=" .. data.PermisVoiture ..
        "&datecamion=" .. data.PermisCamion .. "&point=" .. data.Point ..
        --"&startvisa=" .. data.VisaStart .. "&endvisa=" .. data.VisaEnd ..
        "&url=" .. venato.ConvertUrl(data.Url)
    })
  else
    PapierOpen = 0
    CloseDoc()
  end
end

function ShowVisa(data)
  if PapierOpen == 0 then
    PapierOpen = 1
    SendNUIMessage({
      action = 'showIdentity',
      string = "type=visa&nom=" .. data.Nom .. "&prenom=" .. data.Prenom ..
        "&age=" .. data.Age .. "&sex=" .. data.Sexe ..-- "&job=" .. data.NameJob ..
        "&id=" .. data.Source .. "&steam=" .. data.SteamId .. "&datevoiture=" .. data.PermisVoiture ..
        "&datecamion=" .. data.PermisCamion .. "&point=" .. data.Point ..
        "&startvisa=" .. data.VisaStart .. "&endvisa=" .. data.VisaEnd ..
        "&url=" .. venato.ConvertUrl(data.Url)
    })
  else
    PapierOpen = 0
    CloseDoc()
  end
end

--############# Doc ##################

--############# Weapon ##################

function OptionWeapon(table)
  Menu.clearMenu()
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "MyWeapon", table[7])
  Menu.addButton("Donner", "GiveWeapon", table)
  Menu.addButton("Jeter", "DropWeapon", table)
end

function GiveWeapon(table)
  local ClosePlayer, distance = venato.ClosePlayer()
  if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
    TriggerServerEvent("Inventory:CallInfoWeapon", ClosePlayer, table)
    OpenInventory()
  else
    venato.notifyError("Il n'y a personne à proximité.")
  end
end

function DropWeapon(tableau)
		local x, y, z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
		TriggerServerEvent("Inventory:DropWeapon", tableau, x,y,z-0.5)
		TriggerServerEvent("Inventory:RemoveWeapon",tableau[3], tableau[1], tableau[4])
		local objet = venato.CreateObject(dropWeapon, x, y+0.5, z-1) 
    PlaceObjectOnGroundProperly(objet) 
		FreezeEntityPosition(objet, true) 
		OpenInventory() 
end

RegisterNetEvent('Inventory:AddWeaponClient')
AddEventHandler('Inventory:AddWeaponClient', function(weapon, ammo)
  local weaponHash = GetHashKey(weapon) 
  local ammo = tonumber(ammo) 
  if ammo == 0 then 
    GiveWeaponToPed(PlayerPedId(), weaponHash, false, false) 
  else 
    GiveWeaponToPed(PlayerPedId(), weaponHash, ammo , false, false) 
	end 
end) 

RegisterNetEvent('Inventory:RemoveWeaponAmmoClient')
AddEventHandler('Inventory:RemoveWeaponAmmoClient', function(weapon, ammo)
	local weaponHash = GetHashKey(weapon)
	local ammo = tonumber(ammo)
	SetPedAmmo(venato.GetPlayerPed(), weapon, ammo)
end)

RegisterNetEvent('Inventory:RemoveWeaponClient')
AddEventHandler('Inventory:RemoveWeaponClient', function(weapon)
	local weaponHash = GetHashKey(weapon)
	SetPedAmmo(venato.GetPlayerPed(), weaponHash, 0)
  RemoveWeaponFromPed(venato.GetPlayerPed(), weaponHash)
end)

RegisterNetEvent('Inventory:SendWeaponOnTheGround')
AddEventHandler('Inventory:SendWeaponOnTheGround', function(ParWeaponOnTheGround)
  WeaponOnTheGround = ParWeaponOnTheGround
end)

--############# Weapon ##################

--############# Money ##################

function OptionMoney(table)
  Menu.clearMenu()
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenInventory", nil)
  Menu.addButton("Donner", "GiveMoney", table)
  Menu.addButton("Jeter", "DropMoney", table)
end

function GiveMoney(table)
  local ClosePlayer, distance = venato.ClosePlayer()
  if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
    local nb = venato.OpenKeyboard('', '', 10, "Nombre à donner")
    if tonumber(nb) ~= nil and tonumber(nb) ~= 0 and tonumber(nb) > 0 and table[1] - tonumber(nb) >= 0 then
      TriggerServerEvent("Inventory:CallInfoMoney", ClosePlayer, tonumber(nb), table)
      OpenInventory()
    else
      venato.notifyError("Une erreur dans le nombre choisi.")
    end
  else
    venato.notifyError("Il n'y a personne à proximité.")
  end
end

function DropMoney(tableau)
	local nb = venato.OpenKeyboard('', '', 10,"Nombre à jeter")
	if tonumber(nb) ~= nil and tonumber(nb) ~= 0 then
		if tableau[1] - tonumber(nb) >= 0 then
			local x, y, z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
			TriggerServerEvent("Inventory:DropMoney", tonumber(nb), tableau, x,y,z-0.5)
			TriggerServerEvent("Inventory:RemoveMoney", tonumber(nb))
			local objet = venato.CreateObject(dropMoney, x, y, z-1)
      PlaceObjectOnGroundProperly(objet)
			FreezeEntityPosition(objet, true)
			OpenInventory()
		else
			venato.notifyError("Vous ne pouvez pas jeter plus que ce que vous avez.")
		end
	else
		venato.notifyError("Erreur dans le nombre désiré.")
	end
end

RegisterNetEvent('Inventory:SendMoneyOnTheGround')
AddEventHandler('Inventory:SendMoneyOnTheGround', function(ParMoneyOnTheGround)
  MoneyOnTheGround = ParMoneyOnTheGround
end)

--############# Money ##################


--############# ITEM ##################
function OptionItem(table)
  Menu.clearMenu()
  Menu.setSubtitle(table[3])
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenInventory", nil)
  if(table[7] == 1) then
    Menu.addButton("Utiliser", "UseItem", { table[1], table[2] })
  end
  Menu.addButton("Donner", "GiveItem", { table[1], table[2], table[4] })
  Menu.addButton("Jeter", "DropItem", { table[1], table[2], table[3], table[4], table[5], table[6] })
end

function UseItem(table)
  if table[1] - 1 >= 0 then
    TriggerServerEvent("Inventory:DataItem", table[2], table[1])
    Menu.clearMenu()
    --Citizen.Wait(1000)
    OpenInventory()
  else
    venato.notifyError("Error !")
  end
end

function GiveItem(row)
  local row = row
  local ClosePlayer, distance = venato.ClosePlayer()
  if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
    local nb = venato.OpenKeyboard('', '', 2, "Nombre à donner")
    if tonumber(nb) ~= nil and tonumber(nb) ~= 0 then
      TriggerServerEvent("Inventory:CallInfo", ClosePlayer, tonumber(nb), row)
      Citizen.Wait(500)
      OpenInventory()
    end
  else
    venato.notifyError("Il n'y a personne à proximité.")
  end
end

RegisterNetEvent('Inventory:CallInfo:cb')
AddEventHandler('Inventory:CallInfo:cb', function(ClosePlayer, nb, table, poid, qty)
  print(venato.dump(table))
  if table[1] - nb >= 0 then
    print(table[3])
    print(nb)
    print(poid)
    print((table[3] * nb) + poid)
    print(PoidMax)
    if table[3] * nb + poid <= PoidMax then
      TriggerServerEvent("Inventory:NotifGive", ClosePlayer, nb, table[2])
      TriggerServerEvent("Inventory:SetItem", table[1] - nb, table[2])
      TriggerServerEvent("Inventory:SetItem", qty + nb, table[2], ClosePlayer)
    else
      venato.notifyError("L'inventaire de la personne est plein pour ces items.")
    end
  else
    venato.notifyError("Vous ne pouvez pas donner plus que ce que vous avez.")
  end
end)

function DropItem(tableau)
	local nb = venato.OpenKeyboard('', '', 2,"Nombre à jeter")
	if tonumber(nb) ~= nil and tonumber(nb) ~= 0 then
		if tableau[1] - tonumber(nb) >= 0 then
      local x, y, z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
			TriggerServerEvent("Inventory:DropItem",tableau[3], tonumber(nb), tableau[2], tableau[4], x,y,z-0.5, tableau[5], tableau[6])
			TriggerServerEvent("Inventory:SetItem", tableau[1] - tonumber(nb) , tableau[2])
			local objet = venato.CreateObject(dropItem, x, y, z-1)
      PlaceObjectOnGroundProperly(objet)
			FreezeEntityPosition(objet, true)
			venato.notify("Vous avez jeté "..nb.." "..tableau[3].." .")
			OpenInventory()
		else
			venato.notifyError("Vous ne pouvez pas jeter plus que ce que vous avez.")
		end
	else
		venato.notifyError("Erreur dans le nombre désiré.")
	end
end

RegisterNetEvent('Inventory:SendItemsOnTheGround')
AddEventHandler('Inventory:SendItemsOnTheGround', function(ParItemsOnTheGround)
  ItemsOnTheGround = ParItemsOnTheGround
end)

RegisterNetEvent('Inventory:AnimGive')
AddEventHandler('Inventory:AnimGive', function()
	venato.playAnim({
    useLib = true,
    flag = 48,
    lib = "mp_common",
    anim = "givetake2_a",
    timeout = 3333
  })
end)
RegisterNetEvent('Inventory:AnimReceive')
AddEventHandler('Inventory:AnimReceive', function()
	venato.playAnim({
    useLib = true,
    flag = 48,
    lib = "mp_common",
    anim = "givetake2_b",
    timeout = 3333
  })
end)
--############# ITEM ##################
