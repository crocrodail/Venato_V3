	local brasseur_blipsTemp
	local Brasseur_markerBool = false
	local existingVeh = nil
	local isInServiceBrasseur = false


	function Brasseur_callSE(evt)
		TriggerServerEvent(evt)
	end

	function Brasseur_InitMenuVehicules()
		Menu.open()
	  Menu.setTitle("Spawn vehicule")
	  Menu.setSubtitle("Option")
	  Menu.clearMenu()
		Menu.addButton("Vehicule", "Brasseur_callSE", 'brasseur:Car')
	end

	RegisterNetEvent('brasseur:drawBlips')
	AddEventHandler('brasseur:drawBlips', function ()
		for key, item in pairs(brasseur_blips) do
			item.blip = AddBlipForCoord(item.x, item.y, item.z)
			SetBlipSprite(item.blip, item.id)
			SetBlipAsShortRange(item.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(key)
			EndTextCommandSetBlipName(item.blip)
			BlipsJobs[item.blip] = item.blip
		end
		brasseur_blipsTemp = brasseur_blips
	end)

	RegisterNetEvent('Job:startBrasseur')
	AddEventHandler('Job:startBrasseur', function (boolean)
		Brasseur_markerBool = boolean
		if boolean then
			TriggerEvent("brasseur:drawBlips")
			TriggerEvent("brasseur:marker")
		end
		Citizen.CreateThread(function()
			while Brasseur_markerBool == true do
				Wait(0)
				if isInServiceBrasseur and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Champ"].x,brasseur_blips["Champ"].y,brasseur_blips["Champ"].z, true) <= brasseur_blips["Champ"].distanceBetweenCoords then
					TriggerServerEvent('brasseur:serverRequest', "GetOrge")
					Citizen.Wait(brasseur_blips["Champ"].defaultTime)
				end
				if isInServiceBrasseur and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Brasserie"].x,brasseur_blips["Brasserie"].y,brasseur_blips["Brasserie"].z, true) <= brasseur_blips["Brasserie"].distanceBetweenCoords then
					TriggerServerEvent('brasseur:serverRequest', "GetBiere")
					Citizen.Wait(brasseur_blips["Brasserie"].defaultTime)
				end

				if isInServiceBrasseur and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Point de vente"].x,brasseur_blips["Point de vente"].y,brasseur_blips["Point de vente"].z, true) <= brasseur_blips["Point de vente"].distanceBetweenCoords then
					TriggerServerEvent('brasseur:serverRequest', "SellBiere")
					Citizen.Wait(brasseur_blips["Point de vente"].defaultTime)
				end
			end
		end)
	end)

	RegisterNetEvent('brasseur:marker')
	AddEventHandler('brasseur:marker', function ()
		Citizen.CreateThread(function ()
			while Brasseur_markerBool == true do
				Citizen.Wait(1)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Entreprise"].x, brasseur_blips["Entreprise"].y, brasseur_blips["Entreprise"].z, true) <= brasseur_blips["Entreprise"].distanceMarker then
					DrawMarker(1, brasseur_blips["Entreprise"].x, brasseur_blips["Entreprise"].y, brasseur_blips["Entreprise"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					ClearPrints()
					SetTextEntry_2("STRING")
					if isInServiceBrasseur then
						AddTextComponentString("Appuyez sur ~g~E~s~ pour quitter le ~b~service actif")
					else
						AddTextComponentString("Appuyez sur ~g~E~s~ pour rentrer en ~b~service actif")
					end
					DrawSubtitleTimed(2000, 1)
					if IsControlJustPressed(1, Keys["E"]) then
						GetServiceBrasseur()
					end
				end

				if isInServiceBrasseur then
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Garage"].x, brasseur_blips["Garage"].y, brasseur_blips["Garage"].z, true) <= brasseur_blips["Garage"].distanceMarker+5 then
						DrawMarker(1, brasseur_blips["Garage"].x, brasseur_blips["Garage"].y, brasseur_blips["Garage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString("Appuyez sur ~g~E~s~ pour faire appairaitre/ranger votre ~b~vehicule")
						DrawSubtitleTimed(2000, 1)
						if IsControlJustPressed(1, Keys["E"]) then
							if(existingVeh ~= nil) then
								SetEntityAsMissionEntity(existingVeh, true, true)
								Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
								existingVeh = nil
							else
								Brasseur_InitMenuVehicules()
							end
						end
					end
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Garage"].x,brasseur_blips["Garage"].y,brasseur_blips["Garage"].z, true) <= brasseur_blips["Garage"].distanceMarker then
						DrawMarker(1,brasseur_blips["Garage"].x,brasseur_blips["Garage"].y,brasseur_blips["Garage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Champ"].x,brasseur_blips["Champ"].y,brasseur_blips["Champ"].z, true) <= brasseur_blips["Champ"].distanceMarker then
						DrawMarker(1,brasseur_blips["Champ"].x,brasseur_blips["Champ"].y,brasseur_blips["Champ"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Brasserie"].x,brasseur_blips["Brasserie"].y,brasseur_blips["Brasserie"].z, true) <= brasseur_blips["Brasserie"].distanceMarker then
						DrawMarker(1,brasseur_blips["Brasserie"].x,brasseur_blips["Brasserie"].y,brasseur_blips["Brasserie"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Point de vente"].x,brasseur_blips["Point de vente"].y,brasseur_blips["Point de vente"].z, true) <= brasseur_blips["Point de vente"].distanceMarker then
						DrawMarker(1,brasseur_blips["Point de vente"].x,brasseur_blips["Point de vente"].y,brasseur_blips["Point de vente"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end
				end
			end
		end)
	end)

function GetServiceBrasseur()
	local playerPed = GetPlayerPed(-1)
	if isInServiceBrasseur then
		notif("Vous n\'êtes plus en service")
		TriggerEvent("Venato:LoadClothes")
	else
		notif("Début du service")
		TriggerEvent("brasseur:getSkin")
	end
	isInServiceBrasseur = not isInServiceBrasseur
end

RegisterNetEvent('brasseur:getSkin')
AddEventHandler('brasseur:getSkin', function (source)
	local hashSkin = GetHashKey("mp_m_freemode_01")
	Citizen.CreateThread(function()
	if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
		SetPedComponentVariation(GetPlayerPed(-1), 11, 41, 0, 2)  -- Top
		SetPedComponentVariation(GetPlayerPed(-1), 8, 59, 0, 2)   -- under coat
		SetPedComponentVariation(GetPlayerPed(-1), 4, 7, 0, 2)   -- Pants
		SetPedComponentVariation(GetPlayerPed(-1), 6, 25, 0, 2)   -- shoes
		SetPedComponentVariation(GetPlayerPed(-1), 3, 66, 0, 2)   -- under skin
	else
		SetPedComponentVariation(GetPlayerPed(-1), 11, 109, 2, 2)  -- Top/jacket
		SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2)   -- under coat
		SetPedComponentVariation(GetPlayerPed(-1), 4, 45, 1, 2)   -- Pants
		SetPedComponentVariation(GetPlayerPed(-1), 6, 4, 0, 2)   -- shoes
		SetPedComponentVariation(GetPlayerPed(-1), 3, 22, 0, 2)   -- under skin
	end
	end)
end)

RegisterNetEvent('brasseur:getCar')
AddEventHandler('brasseur:getCar', function (source)
	local vehiculeDetected = GetClosestVehicle(brasseur_car.x, brasseur_car.y, brasseur_car.z, 6.0, 0, 70)
	if not DoesEntityExist(vehiculeDetected) then
		local myPed = GetPlayerPed(-1)
		local player = PlayerId()
		local plate = math.random(1000, 9000)
		Venato.CreateVehicle('pounder',{x=brasseur_car.x, y=brasseur_car.y, z=brasseur_car.z},-50.0, function(vehicle)
			existingVeh = vehicle
			SetVehicleNumberPlateText(existingVeh, brasseur_platesuffix.." "..plate.." ")
			plate = GetVehicleNumberPlateText(existingVeh)
			TriggerEvent('lock:addVeh', plate, GetDisplayNameFromVehicleModel(GetEntityModel(existingVeh)))
		end)
	else
		notif("Zone encombrée.")
	end
end)

	RegisterNetEvent('brasseur:drawGetOrge')
	AddEventHandler('brasseur:drawGetOrge', function (qteBase)
		if(qteBase == nil) then
			qteBase = 0
		end

		if qteBase < 30 then
			TriggerServerEvent('Inventory:AddItem',1,brasseur_ressourceBase)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~Vous avez recolté de l'orge")
			DrawSubtitleTimed(4500, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~Vous ne pouvez plus recolté")
			DrawSubtitleTimed(2000, 1)
		end
	end)

	RegisterNetEvent('brasseur:drawGetBiere')
	AddEventHandler('brasseur:drawGetBiere', function(qteBase, qteTraite)
		if(qteBase == nil) then
			qteBase = 0
		end

		if(qteTraite == nil) then
			qteTraite = 0
		end

		if qteTraite < 100 and qteBase > 0 then
			TriggerServerEvent("Inventory:RemoveItem", 1, brasseur_ressourceBase)
			TriggerServerEvent('Inventory:AddItem',1,brasseur_ressourceTraite)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~+1 Bière brassée")
			DrawSubtitleTimed(8500, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~Vous ne pouvez plus brassée")
			DrawSubtitleTimed(2000, 1)
		end
	end)

	RegisterNetEvent('brasseur:drawSellBiere')
	AddEventHandler('brasseur:drawSellBiere', function (qte)
		if(qte == nil) then
			qte = 0
		end

		if qte > 0 then
			TriggerServerEvent("Inventory:RemoveItem", 1, brasseur_ressourceTraite)
			local salaire = math.random(brasseur_pay.minimum, brasseur_pay.maximum)
			TriggerServerEvent('Bank:AddBankMoney', salaire)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~Bières vendu")
			DrawSubtitleTimed(8500, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~Vous n'avez plus de Bière")
			DrawSubtitleTimed(2000, 1)
		end
	end)
