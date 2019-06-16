local ItemsOnTheGround = {}
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
		end
		if ItemsOnTheGround ~= nil then
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			for k,v in pairs(ItemsOnTheGround) do
				local dis = Vdist(x, y, z, v.x, v.y, v.z)
				if dis < 1 then
					Venato.Text3D(v.x, v.y, v.z, "~b~"..v.qty.." "..v.libelle)
					Venato.InteractTxt("Appuyer sur ~INPUT_CONTEXT~ pour récupérer "..v.qty.." "..v.libelle)
					if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
						if v.qty*v.uPoid + v.poid <= PoidMax then
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
	end
end)
TriggerServerEvent("debuge")
function debuge(a)
 TriggerServerEvent("debuge")
end

function OpenInventory()
	MenuTitle = "00 / 20 Kg"
	MenuDescription = "Inventaire"
	Menu.addButton("~r~debug", "debuge", 1)
	TriggerServerEvent("Inventory:ShowMe")
end

RegisterNetEvent('Inventory:ShowMe:cb')
AddEventHandler('Inventory:ShowMe:cb', function(DataUser)
	ClearMenu()
	local color = "~s~"
	if DataUser.Poid > 18 then
		color = "~r~"
	elseif DataUser.Poid > 14 then
		color = "~o~"
	end
	MenuTitle = color..""..DataUser.Poid.." ~s~/ 20 Kg"
	MenuDescription = "Inventaire"
	Menu.addButton("~g~Argent : "..DataUser.Money.." €", "OptionMoney", {})
	for k,v in pairs(DataUser.Inventaire) do
		if v.quantity > 0 then
			Menu.addButton("~b~"..v.libelle.." ~s~: ~r~"..v.quantity.." ~o~( "..v.poid.." Kg )", "OptionItem", {v.quantity, v.id, v.libelle, v.uPoid, poid})
		end
	end
end)

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
	if ClosePlayer ~= 0 or ClosePlayer ~= nil and distance < 4 then
		local nb = Venato.OpenKeyboard('', '0', 2,"Nombre à donner")
		if tonumber(nb) ~= nil and tonumber(nb) ~= 0 then
			TriggerServerEvent("Inventory:CallInfo", ClosePlayer, nb, table)
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
			Venato.notify("La personne est trop lourd pour ces items.")
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
			TriggerServerEvent("Inventory:DropItem",table[3], tonumber(nb), table[2], table[4]*nb, x, table[5])
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
