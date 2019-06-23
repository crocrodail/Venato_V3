local ItemsOnTheGround = {}
local MoneyOnTheGround = {}
local WeaponOnTheGround = {}
local dropMoney = "prop_cash_case_01"
local dropWeapon = "prop_hockey_bag_01"
local dropItem = "prop_cs_box_clothes"
local PapierOpen = 0
DataUser = {}
-- ######## COFIG ##############
	local PoidMax = 20 -- Kg
--##############################

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		Menu.renderGUI()
		if IsControlJustPressed(1, Keys['K']) and GetLastInputMethod(2) then
			ClearMenu()
			Menu.hidden = not Menu.hidden
			showPageInfo = not showPageInfo
			if not Menu.hidden then
				OpenInventory()
			end
		end
		if IsControlJustPressed(1, Keys['F3']) and GetLastInputMethod(2) then
			ClearMenu()
			Menu.hidden = not Menu.hidden
			OpenMenuPerso()
		end
		if IsControlJustPressed(1, Keys['BACKSPACE']) or IsControlJustPressed(1, Keys['RIGHTMOUSE']) and GetLastInputMethod(2) then
			if Menu.hidden then
				CloseDoc()
			end
			Menu.hidden = true
			showPageInfo = false
		end

		if ItemsOnTheGround ~= nil then
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			for k,v in pairs(ItemsOnTheGround) do
				local dis = Vdist(x, y, z, v.x, v.y, v.z)
				if dis < 1 then
					Venato.Text3D(v.x, v.y, v.z, "~b~"..v.qty.." "..v.libelle)
					Venato.InteractTxt("Appuyer sur ~INPUT_CONTEXT~ pour récupérer "..v.qty.." "..v.libelle)
					if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
						if (v.qty*v.uPoid + DataUser.Poid) <= PoidMax then
							TriggerServerEvent("Inventory:AddItem", v.qty , v.id)
							TriggerServerEvent("Inventory:DelItemsOnTheGround", k)
							Venato.notify("Vous avez ramassez "..v.qty.." "..v.libelle.." .")
							local pedCoords = GetEntityCoords(PlayerPedId())
							local objet = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 10.0, GetHashKey(dropItem))
							if objet ~= 0 and objet ~= nil then
								DeleteEntity(objet)
							end
						else
							Venato.notify("Vous etes trop lourd pour ramasser "..v.qty.." "..v.libelle.." .")
						end
					end
				elseif dis < 10 then
					Venato.Text3D(v.x, v.y, v.z, "~b~"..v.qty.." "..v.libelle)
				end
			end
		end

		if MoneyOnTheGround ~= nil then
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			for k,v in pairs(MoneyOnTheGround) do
				local dis = Vdist(x, y, z, v.x, v.y, v.z)
				if dis < 1 then
					Venato.Text3D(v.x, v.y, v.z, "~b~"..v.qty.." €")
					Venato.InteractTxt("Appuyer sur ~INPUT_CONTEXT~ pour récupérer "..v.qty.." €")
					if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
						if (Venato.Round(v.qty*0.000075,1) + DataUser.Poid) <= PoidMax then
							TriggerServerEvent("Inventory:AddMoney", v.qty)
							TriggerServerEvent("Inventory:DelMoneyOnTheGround", k)
							Venato.notify("Vous avez ramassez "..v.qty.." € .")
							local pedCoords = GetEntityCoords(PlayerPedId())
							local objet = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 10.0, GetHashKey(dropMoney))
							if objet ~= 0 and objet ~= nil then
								DeleteEntity(objet)
							end
						else
							Venato.notify("Vous etes trop lourd pour ramasser "..v.qty.." € .")
						end
					end
				elseif dis < 10 then
					Venato.Text3D(v.x, v.y, v.z, "~b~"..v.qty.." €")
				end
			end
		end

		if WeaponOnTheGround ~= nil then
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			for k,v in pairs(WeaponOnTheGround) do
				local dis = Vdist(x, y, z, v.x, v.y, v.z)
				if dis < 1 then
					Venato.Text3D(v.x, v.y, v.z, "~b~"..v.libelle)
					Venato.InteractTxt("Appuyer sur ~INPUT_CONTEXT~ pour récupérer "..v.libelle..".")
					if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
						if v.uPoid + DataUser.Poid <= PoidMax then
							TriggerServerEvent("Inventory:AddWeapon", v.id, v.ammo, v.uPoid, v.libelle)
							TriggerServerEvent("Inventory:DelWeaponOnTheGround", k)
							Venato.notify("Vous avez ramassez "..v.libelle.." .")
							local pedCoords = GetEntityCoords(PlayerPedId())
							local objet = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 10.0, GetHashKey(dropWeapon))
							if objet ~= 0 and objet ~= nil then
								DeleteEntity(objet)
							end
						else
							Venato.notify("Vous etes trop lourd pour ramasser "..v.libelle.." .")
						end
					end
				elseif dis < 10 then
					Venato.Text3D(v.x, v.y, v.z, "~b~"..v.libelle.." .")
				end
			end
		end
	end
end)
TriggerServerEvent("debuge")
function debuge()
 TriggerServerEvent("debuge")
end


function OpenInventory()
	MenuTitle = "00 / 20 Kg"
	MenuDescription = "Inventaire"
	TriggerServerEvent("Inventory:ShowMe")
end

RegisterNetEvent('Inventory:ShowMe:cb')
AddEventHandler('Inventory:ShowMe:cb', function(Data)
	ClearMenu()
	DataUser = Data
	local WeaponPoid = 0
	Menu.addButton("~r~Syncdata", "debuge", {})
	for k,v in pairs(Data.Weapon) do
		if v.libelle ~= nil then
			WeaponPoid = WeaponPoid + v.poid
		end
	end
	Menu.addButton("~r~🔫 Mes Armes ~o~("..WeaponPoid.." Kg )", "MyWeapon", Data)
	Menu.addButton("~y~Mes Documents", "MyDoc", Data)
	local color = "~s~"
	if Data.Poid > 18 then
		color = "~r~"
	elseif Data.Poid > 14 then
		color = "~o~"
	end
	MenuTitle = color..""..Data.Poid.." ~s~/ 20 Kg"
	MenuDescription = "Inventaire"
	local MoneyPoid = Venato.Round(Data.Money*0.000075,1)
	Menu.addButton("~g~Argent : "..Data.Money.." € ~o~( "..MoneyPoid.." Kg )", "OptionMoney", {Data.Money, MoneyPoid, Data.Poid,Data})
	for k,v in pairs(Data.Inventaire) do
		if v.quantity > 0 then
			Menu.addButton("~b~"..v.libelle.." ~s~: ~r~"..v.quantity.." ~o~( "..v.poid.." Kg )", "OptionItem", {v.quantity, v.id, v.libelle, v.uPoid, Data.Poid})
		end
	end
end)

function MyWeapon(Data)
	ClearMenu()
	Menu.addButton("~r~↩ Retour", "OpenInventory", nil)
	MenuDescription = "Mes armes"
	for k,v in pairs(Data.Weapon) do
		if v.libelle ~= nil then
			if tonumber(v.ammo) > 0 then
				Menu.addButton("~b~"..v.libelle.." ~s~munition : ~r~"..v.ammo.." ~o~( "..v.poid.." Kg )", "OptionWeapon", {k, v.libelle, v.id, v.poid, v.ammo, Data.Poid, Data})
			else
				Menu.addButton("~b~"..v.libelle.." ~o~( "..v.poid.." Kg )", "OptionWeapon", {k, v.libelle, v.id, v.poid, v.ammo, Data.Poid, Data})
			end
		end
	end
end

--############# Doc ##################

function MyDoc(data)
	ClearMenu()
	MenuDescription = "Mes Documents"
	Menu.addButton("~r~↩ Retour", "OpenInventory", nil)
	if data.Citoyen == 1 then
		Menu.addButton("Carte d'identité", "optionIdCard", data)
	else
		Menu.addButton("Carte de séjour", "optionVisa", data)
	end
	if data.PermisVoiture ~= "non aquis" or data.PermisVoiture ~= "non aquis" then
		Menu.addButton("Permis de conduire", "optionPermis", data)
	end
	for k,v in pairs(data.Documents) do
		if v.type == "chequier" then
			Menu.addButton("Chèquier ~o~("..v.montant.." restant)", "showCheque", {data,k})
		end
		if v.type == "cheque" then
			Menu.addButton("Cheque de ~g~"..v.montant.." €", "showCheque", {data,k})
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
	ClearMenu()
	MenuDescription = "Permis de conduire"
	Menu.addButton("~r~↩ Retour", "MyDoc", data)
	Menu.addButton("Regarder", "ShowPermis", data)
	Menu.addButton("Montrer", "ShowToOtherPermis", data)
end

function optionIdCard(data)
	ClearMenu()
	MenuDescription = "Carte d'identité"
	Menu.addButton("~r~↩ Retour", "MyDoc", data)
	Menu.addButton("Regarder", "ShowIdCard", data)
	Menu.addButton("Montrer", "ShowToOtherIdCard", data)
end

function optionVisa(data)
	ClearMenu()
	MenuDescription = "Permis de séjour"
	Menu.addButton("~r~↩ Retour", "MyDoc", data)
	Menu.addButton("Regarder", "ShowVisa", data)
	Menu.addButton("Montrer", "ShowToOtherVisa", data)
end

function ShowToOtherPermis(data)
	local ClosePlayer, distance = Venato.ClosePlayer()
	if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
		TriggerServerEvent("Inventory:ShowToOtherPermis", data, ClosePlayer)
	else
		Venato.notify("Il n'y a personne à proximité.")
	end
end

function ShowToOtherIdCard(data)
	local ClosePlayer, distance = Venato.ClosePlayer()
	if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
		TriggerServerEvent("Inventory:ShowToOtherIdCard", data, ClosePlayer)
	else
		Venato.notify("Il n'y a personne à proximité.")
	end
end

function ShowToOtherVisa(data)
	local ClosePlayer, distance = Venato.ClosePlayer()
	if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
		TriggerServerEvent("Inventory:ShowToOtherVisa", data, ClosePlayer)
	else
		Venato.notify("Il n'y a personne à proximité.")
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

function showCheque(data)
	if PapierOpen == 0 then
		PapierOpen = 1
		SendNUIMessage({
			action = 'showCheque',
			string = "&type=show&date="..data[1].Documents[data[2]].date..
						 	 "&nomprenom="..data[1].Documents[data[2]].nom1.." "..data[1].Documents[data[2]].prenom1..
					   	 "&nomprenomd="..data[1].Documents[data[2]].nom2.." "..data[1].Documents[data[2]].prenom2..
						   "&montant="..data[1].Documents[data[2]].montant.."&num="..data[1].Documents[data[2]].numeroDeCompte
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
			string = "type=permis&nom="..data.Nom.."&prenom="..data.Prenom..
						 	 "&age="..data.Age.."&sex="..data.Sexe.."&job="..data.NameJob..
						   "&id="..data.Source.."&steam="..data.SteamId.."&datevoiture="..data.PermisVoiture..
					  	 "&datecamion="..data.PermisCamion.."&point="..data.Point..
					  	 "&startvisa="..data.VisaStart.."&endvisa="..data.VisaEnd..
						   "&url="..Venato.ConvertUrl(data.Url)
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
			string = "type=identity&nom="..data.Nom.."&prenom="..data.Prenom..
					  	 "&age="..data.Age.."&sex="..data.Sexe.."&job="..data.NameJob..
					  	 "&id="..data.Source.."&steam="..data.SteamId.."&datevoiture="..data.PermisVoiture..
					  	 "&datecamion="..data.PermisCamion.."&point="..data.Point..
					  	 "&startvisa="..data.VisaStart.."&endvisa="..data.VisaEnd..
					  	 "&url="..Venato.ConvertUrl(data.Url)
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
			string = "type=visa&nom="..data.Nom.."&prenom="..data.Prenom..
				  		 "&age="..data.Age.."&sex="..data.Sexe.."&job="..data.NameJob..
				  		 "&id="..data.Source.."&steam="..data.SteamId.."&datevoiture="..data.PermisVoiture..
					  	 "&datecamion="..data.PermisCamion.."&point="..data.Point..
					  	 "&startvisa="..data.VisaStart.."&endvisa="..data.VisaEnd..
					  	 "&url="..Venato.ConvertUrl(data.Url)
					 })
	else
		PapierOpen = 0
		CloseDoc()
	end
end

--############# Doc ##################

--############# Weapon ##################

function OptionWeapon(table)
	ClearMenu()
	Menu.addButton("~r~↩ Retour", "MyWeapon", table[7])
	Menu.addButton("Donner", "GiveWeapon", table)
	Menu.addButton("Jeter", "DropWeapon", table)
end

function GiveWeapon(table)
	local ClosePlayer, distance = Venato.ClosePlayer()
	if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
		TriggerServerEvent("Inventory:CallInfoWeapon", ClosePlayer, table)
		OpenInventory()
	else
		Venato.notify("Il n'y a personne à proximité.")
	end
end

function DropWeapon(tableau)
		local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
		TriggerServerEvent("Inventory:DropWeapon", tableau, x,y,z-0.5)
		TriggerServerEvent("Inventory:RemoveWeapon",tableau[3], tableau[1], tableau[4])
		local objet = Venato.CreateObject(dropWeapon, x, y, z-1)
		FreezeEntityPosition(objet, true)
		OpenInventory()
end

RegisterNetEvent('Inventory:AddWeaponClient')
AddEventHandler('Inventory:AddWeaponClient', function(weapon, ammo)
	local weaponHash = GetHashKey(weapon)
	local ammo = tonumber(ammo)
	if ammo == 0 then
		GiveWeaponToPed(GetPlayerPed(-1), weaponHash, false, false)
	else
		GiveWeaponToPed(GetPlayerPed(-1), weaponHash, ammo , false, false)
	end
end)

RegisterNetEvent('Inventory:RemoveWeaponAmmoClient')
AddEventHandler('Inventory:RemoveWeaponAmmoClient', function(weapon, ammo)
	local weaponHash = GetHashKey(weapon)
	local ammo = tonumber(ammo)
	SetPedAmmo(GetPlayerPed(-1), weapon, ammo)
end)

RegisterNetEvent('Inventory:RemoveWeaponClient')
AddEventHandler('Inventory:RemoveWeaponClient', function(weapon)
	local weaponHash = GetHashKey(weapon)
	SetPedAmmo(GetPlayerPed(-1), weaponHash, 0)
  RemoveWeaponFromPed(GetPlayerPed(-1), weaponHash)
end)

RegisterNetEvent('Inventory:SendWeaponOnTheGround')
AddEventHandler('Inventory:SendWeaponOnTheGround', function(ParWeaponOnTheGround)
	WeaponOnTheGround = ParWeaponOnTheGround
end)

--############# Weapon ##################

--############# Money ##################

function OptionMoney(table)
	ClearMenu()
	Menu.addButton("~r~↩ Retour", "OpenInventory", nil)
	Menu.addButton("Donner", "GiveMoney", table)
	Menu.addButton("Jeter", "DropMoney", table)
end

function GiveMoney(table)
	local ClosePlayer, distance = Venato.ClosePlayer()
	if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
		local nb = Venato.OpenKeyboard('', '0', 10,"Nombre à donner")
		if tonumber(nb) ~= nil and tonumber(nb) ~= 0 and tonumber(nb) > 0 and table[1] - tonumber(nb) >= 0 then
			TriggerServerEvent("Inventory:CallInfoMoney", ClosePlayer, tonumber(nb), table)
			OpenInventory()
		else
			Venato.notify("Une erreur dans le nombre choisi.")
		end
	else
		Venato.notify("Il n'y a personne à proximité.")
	end
end

function DropMoney(tableau)
	local nb = Venato.OpenKeyboard('', '0', 10,"Nombre à jeter")
	if tonumber(nb) ~= nil and tonumber(nb) ~= 0 then
		if tableau[1] - tonumber(nb) >= 0 then
			local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			TriggerServerEvent("Inventory:DropMoney", tonumber(nb), tableau, x,y,z-0.5)
			TriggerServerEvent("Inventory:RemoveMoney", tonumber(nb))
			local objet = Venato.CreateObject(dropMoney, x, y, z-1)
			FreezeEntityPosition(objet, true)
			OpenInventory()
		else
			Venato.notify("Vous ne pouvez pas jeter plus que ce que vous avez.")
		end
	else
		Venato.notify("Erreur dans le nombre désiré.")
	end
end

RegisterNetEvent('Inventory:SendMoneyOnTheGround')
AddEventHandler('Inventory:SendMoneyOnTheGround', function(ParMoneyOnTheGround)
	MoneyOnTheGround = ParMoneyOnTheGround
end)

--############# Money ##################


--############# ITEM ##################
function OptionItem(table)
	ClearMenu()
	MenuDescription = table[3]
	Menu.addButton("~r~↩ Retour", "OpenInventory", nil)
	Menu.addButton("Utiliser", "UseItem", {table[1],table[2]})
	Menu.addButton("Donner", "GiveItem", {table[1],table[2],table[4]})
	Menu.addButton("Jeter", "DropItem", {table[1],table[2],table[3],table[4],table[5]})
end

function UseItem(table)
	if table[1] - 1 >= 0 then
		TriggerServerEvent("Inventory:DataItem", table[2],table[1])
	else
		Venato.notify("Error !")
	end
end

function GiveItem(table)
	local ClosePlayer, distance = Venato.ClosePlayer()
	if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
		local nb = Venato.OpenKeyboard('', '0', 2,"Nombre à donner")
		if tonumber(nb) ~= nil and tonumber(nb) ~= 0 then
			TriggerServerEvent("Inventory:CallInfo", ClosePlayer, tonumber(nb), table)
			OpenInventory()
		end
	else
		Venato.notify("Il n'y a personne à proximité.")
	end
end

RegisterNetEvent('Inventory:CallInfo:cb')
AddEventHandler('Inventory:CallInfo:cb', function(ClosePlayer, nb, table, poid, qty)
	if table[1] - nb >= 0 then
		if table[3]*nb + poid <= PoidMax then
			TriggerServerEvent("Inventory:SetItem", table[1] - nb , id)
			TriggerServerEvent("Inventory:SetItem", qty + nb , id, ClosePlayer)
		else
			Venato.notify("La personne est trop lourde pour ces items.")
		end
	else
		Venato.notify("Vous ne pouvez pas donner plus que ce que vous avez.")
	end
end)

function DropItem(tableau)
	local nb = Venato.OpenKeyboard('', '0', 2,"Nombre à jeter")
	if tonumber(nb) ~= nil and tonumber(nb) ~= 0 then
		if tableau[1] - tonumber(nb) >= 0 then
			local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			TriggerServerEvent("Inventory:DropItem",tableau[3], tonumber(nb), tableau[2], tableau[4], x,y,z-0.5, tableau[5])
			TriggerServerEvent("Inventory:SetItem", tableau[1] - tonumber(nb) , tableau[2])
			local objet = Venato.CreateObject(dropItem, x, y, z-1)
			FreezeEntityPosition(objet, true)
			Venato.notify("Vous avez jeté "..nb.." "..tableau[3].." .")
			OpenInventory()
		else
			Venato.notify("Vous ne pouvez pas jeter plus que ce que vous avez.")
		end
	else
		Venato.notify("Erreur dans le nombre désiré.")
	end
end

RegisterNetEvent('Inventory:SendItemsOnTheGround')
AddEventHandler('Inventory:SendItemsOnTheGround', function(ParItemsOnTheGround)
	ItemsOnTheGround = ParItemsOnTheGround
end)

RegisterNetEvent('Inventory:AnimGive')
AddEventHandler('Inventory:AnimGive', function()
	Citizen.CreateThread(function()
		local ped = GetPlayerPed(-1)
		TaskStartScenarioInPlace(ped, "PROP_HUMAN_PARKING_METER", 0, false)
		Citizen.Wait(1500)
		ClearPedTasks(ped)
	end)
end)
--############# ITEM ##################
