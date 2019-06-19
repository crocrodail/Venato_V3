local ItemsOnTheGround = {}
local MoneyOnTheGround = {}
local WeaponOnTheGround = {}
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
						print(v.qty.." * "..v.uPoid.." + "..DataUser.Poid.." <= "..PoidMax)
						if (v.qty*v.uPoid + DataUser.Poid) <= PoidMax then
							TriggerServerEvent("Inventory:AddItem", v.qty , v.id)
							TriggerServerEvent("Inventory:DelItemsOnTheGround", k)
							Venato.notify("Vous avez ramassez "..v.qty.." "..v.libelle.." .")
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
function debuge(a)
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
	Menu.addButton("~r~Mes Armes ~o~("..WeaponPoid.." Kg )", "MyWeapon", Data)
	local color = "~s~"
	if Data.Poid > 18 then
		color = "~r~"
	elseif Data.Poid > 14 then
		color = "~o~"
	end
	MenuTitle = color..""..Data.Poid.." ~s~/ 20 Kg"
	MenuDescription = "Inventaire"
	local MoneyPoid = Venato.Round(Data.Money*0.000075,1)
	Menu.addButton("~g~Argent : "..Data.Money.." € ~o~( "..MoneyPoid.." Kg )", "OptionMoney", {Data.Money, MoneyPoid, Data.Poid})
	for k,v in pairs(Data.Inventaire) do
		if v.quantity > 0 then
			Menu.addButton("~b~"..v.libelle.." ~s~: ~r~"..v.quantity.." ~o~( "..v.poid.." Kg )", "OptionItem", {v.quantity, v.id, v.libelle, v.uPoid, Data.Poid})
		end
	end
end)

function MyWeapon(Data)
	ClearMenu()
	Menu.addButton("~r~Retour", "OpenInventory", nil)
	MenuDescription = "Mes armes"
	for k,v in pairs(Data.Weapon) do
		if v.libelle ~= nil then
			if tonumber(v.ammo) > 0 then
				Menu.addButton("~b~"..v.libelle.." ~s~munition : ~r~"..v.ammo.." ~o~( "..v.poid.." Kg )", "OptionWeapon", {k, v.libelle, v.id, v.poid, v.ammo, Data.Poid})
			else
				Menu.addButton("~b~"..v.libelle.." ~o~( "..v.poid.." Kg )", "OptionWeapon", {k, v.libelle, v.id, v.poid, v.ammo, Data.Poid})
			end
		end
	end
end

--############# Weapon ##################

function OptionWeapon(table)
	ClearMenu()
	Menu.addButton("Donner", "GiveWeapon", table)
	Menu.addButton("Jeter", "DropWeapon", table)
end

function GiveWeapon(table)
	local ClosePlayer, distance = Venato.ClosePlayer()
	if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
		TriggerServerEvent("Inventory:CallInfoWeapon", ClosePlayer, table)
	else
		Venato.notify("Il n'y a personne à proximité.")
	end
end

function DropWeapon(table)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		TriggerServerEvent("Inventory:DropWeapon", table, pos)
		TriggerServerEvent("Inventory:RemoveWeapon", table[1], table[4])
		--Venato.CreateObject(GetHashKey("prop_big_bag_01"), x, y, z, true, true, true)-- ###########################   non atribué-- ###########################   non atribué-- ###########################
		OpenInventory()
end

RegisterNetEvent('Inventory:AddWeaponClient')
AddEventHandler('Inventory:AddWeaponClient', function(weapon, ammo)

end)

RegisterNetEvent('Inventory:RemoveWeaponClient')
AddEventHandler('Inventory:RemoveWeaponClient', function(weapon)

end)

RegisterNetEvent('Inventory:SendWeaponOnTheGround')
AddEventHandler('Inventory:SendWeaponOnTheGround', function(ParWeaponOnTheGround)
	WeaponOnTheGround = ParWeaponOnTheGround
end)

--############# Weapon ##################

--############# Money ##################

function OptionMoney(table)
	ClearMenu()
	Menu.addButton("Donner", "GiveMoney", table)
	Menu.addButton("Jeter", "DropMoney", table)
end

function GiveMoney(table)
	local ClosePlayer, distance = Venato.ClosePlayer()
	if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
		local nb = Venato.OpenKeyboard('', '0', 10,"Nombre à donner")
		if tonumber(nb) ~= nil and tonumber(nb) ~= 0 and tonumber(nb) > 0 and table[1] - tonumber(nb) >= 0 then
			TriggerServerEvent("Inventory:CallInfoMoney", ClosePlayer, tonumber(nb), table)
		else
			Venato.notify("Une erreur dans le nombre choisi.")
		end
	else
		Venato.notify("Il n'y a personne à proximité.")
	end
end

function DropMoney(table)
	local nb = Venato.OpenKeyboard('', '0', 10,"Nombre à jeter")
	if tonumber(nb) ~= nil and tonumber(nb) ~= 0 then
		if table[1] - tonumber(nb) >= 0 then
			local x = GetEntityCoords(GetPlayerPed(-1), true)
			TriggerServerEvent("Inventory:DropMoney", tonumber(nb), table, x)
			TriggerServerEvent("Inventory:RemoveMoney", tonumber(nb))
			--Venato.CreateObject(GetHashKey("prop_big_bag_01"), x, y, z, true, true, true)-- ###########################   non atribué-- ###########################   non atribué-- ###########################
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
	Menu.addButton("Utiliser", "UseItem", {table[1],table[2]})
	Menu.addButton("Donner", "GiveItem", {table[1],table[2],table[4]})
	Menu.addButton("Jeter", "DropItem", {table[1],table[2],table[3],table[4],table[5]})
end

function UseItem(table)
	if table[1] - 1 >= 0 then
		TriggerServerEvent("Inventory:DataItem", table[2])
		TriggerServerEvent("Inventory:SetItem", table[1]-1, table[2])
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

function DropItem(table)
	local nb = Venato.OpenKeyboard('', '0', 2,"Nombre à jeter")
	if tonumber(nb) ~= nil and tonumber(nb) ~= 0 then
		if table[1] - tonumber(nb) >= 0 then
			local x = GetEntityCoords(GetPlayerPed(-1), true)
			TriggerServerEvent("Inventory:DropItem",table[3], tonumber(nb), table[2], table[4], x, table[5])
			TriggerServerEvent("Inventory:SetItem", table[1] - tonumber(nb) , table[2])
			Citizen.Wait(500)
			OpenInventory()
			--Venato.CreateObject(GetHashKey("prop_big_bag_01"), x, y, z, true, true, true)-- ###########################   non atribué-- ###########################   non atribué-- ###########################
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

--############# ITEM ##################
