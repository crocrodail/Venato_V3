	local brasseur_blipsTemp
	local Brasseur_markerBool = false
	local existingVeh = nil
	local isInServiceBrasseur = false
	local recolt = false
	local transform = false
	local sell = false


	local defaultNotification = {
		title = "Brasseur",
		type = "alert",
		logo = "https://i.ibb.co/BKmPbdw/icons8-beer-96px.png",
		timeout = 900
	}

	Citizen.CreateThread(function()
		while true do			
			Wait(0)
			if Brasseur_markerBool == true then
				if isInServiceBrasseur and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Champ"].x,brasseur_blips["Champ"].y,brasseur_blips["Champ"].z, true) <= brasseur_blips["Champ"].distanceBetweenCoords then
					if(not recolt) then
						venato.InteractTxt("Appuyez sur ~g~E~s~ pour commencer à récolter de l'~b~orge~s~.")						
					else
						venato.InteractTxt("Appuyez sur ~g~E~s~ pour arrêter de récolter de l'~b~orge~s~.")
					end

					if IsControlJustPressed(1, Keys["E"]) then
						recolt = not recolt
					end
				else
					recolt = false
				end
				if isInServiceBrasseur and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Brasserie"].x,brasseur_blips["Brasserie"].y,brasseur_blips["Brasserie"].z, true) <= brasseur_blips["Brasserie"].distanceBetweenCoords then
					if(not transform) then
						venato.InteractTxt("Appuyez sur ~g~E~s~ pour commencer à transformer l'~b~orge~s~.")						
					else
						venato.InteractTxt("Appuyez sur ~g~E~s~ pour arrêter de transformer l'~b~orge~s~.")
					end

					if IsControlJustPressed(1, Keys["E"]) then
						transform = not transform
					end
				else
					transform = false
				end
				if isInServiceBrasseur and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Point de vente"].x,brasseur_blips["Point de vente"].y,brasseur_blips["Point de vente"].z, true) <= brasseur_blips["Point de vente"].distanceBetweenCoords then
					if(not sell) then
						venato.InteractTxt("Appuyez sur ~g~E~s~ pour commencer à vendre de la ~b~bière~s~.")						
					else
						venato.InteractTxt("Appuyez sur ~g~E~s~ pour arrêter de vendre de la ~b~bière~s~.")
					end

					if IsControlJustPressed(1, Keys["E"]) then
						sell = not sell
					end
				else
				end
			end
		end
	end)

	Citizen.CreateThread(function ()
		while true do
			Citizen.Wait(1)
			if recolt then
				TriggerServerEvent('brasseur:serverRequest', "GetOrge")
					Citizen.Wait(brasseur_blips["Champ"].defaultTime)
			end
			if transform then
				TriggerServerEvent('brasseur:serverRequest', "GetBiere")
					Citizen.Wait(brasseur_blips["Brasserie"].defaultTime)
			end
			if sell then
				TriggerServerEvent('brasseur:serverRequest', "SellBiere")
					Citizen.Wait(brasseur_blips["Point de vente"].defaultTime)
			end
		end
	end)

	function Brasseur_callSE(evt)
		TriggerServerEvent(evt)
	end

	function Brasseur_InitMenuVehicules()
		TriggerEvent('Menu:Init', "Brasserie - Véhicule", "Options", "#FF8F0099", "https://www.atabula.com/wp-content/uploads/2013/10/Biere-copie.jpg")
	  	Menu.clearMenu()
		Menu.addButton("Vehicule", "Brasseur_callSE", 'brasseur:Car')
		Menu.open()
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

	RegisterNetEvent('job:deleteBlips')
	AddEventHandler('job:deleteBlips', function ()
		Brasseur_markerBool = false
		for k, item in pairs(BlipsJobs) do
			RemoveBlip(k)
		end
	end)

	RegisterNetEvent('Job:startBrasseur')
	AddEventHandler('Job:startBrasseur', function (boolean)
		Brasseur_markerBool = boolean
		if boolean then
			TriggerEvent("brasseur:drawBlips")
		end
		
	end)


Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(1)
		if Brasseur_markerBool == true then
			local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Entreprise"].x, brasseur_blips["Entreprise"].y, brasseur_blips["Entreprise"].z, true)
			if distance <= brasseur_blips["Entreprise"].distanceMarker then
				DrawMarker(1, brasseur_blips["Entreprise"].x, brasseur_blips["Entreprise"].y, brasseur_blips["Entreprise"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
				if distance <= 5 then
					if isInServiceBrasseur then
						venato.InteractTxt("Appuyez sur ~g~E~s~ pour quitter le ~b~service actif")
					else
						venato.InteractTxt("Appuyez sur ~g~E~s~ pour rentrer en ~b~service actif")
					end
					if IsControlJustPressed(1, Keys["E"]) then
						GetServiceBrasseur()
					end
				end
			end

			if isInServiceBrasseur then
				local distance2 = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Garage"].x, brasseur_blips["Garage"].y, brasseur_blips["Garage"].z, true)
				if distance2 <= brasseur_blips["Garage"].distanceMarker+5 then
					DrawMarker(1, brasseur_blips["Garage"].x, brasseur_blips["Garage"].y, brasseur_blips["Garage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					if distance2 <= 5 then
						venato.InteractTxt("Appuyez sur ~g~E~s~ pour faire appairaitre/ranger votre ~b~vehicule")
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
				end
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Garage"].x,brasseur_blips["Garage"].y,brasseur_blips["Garage"].z, true) <= brasseur_blips["Garage"].distanceMarker then
					DrawMarker(1,brasseur_blips["Garage"].x,brasseur_blips["Garage"].y,brasseur_blips["Garage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
				end

				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Champ"].x,brasseur_blips["Champ"].y,brasseur_blips["Champ"].z, true) <= brasseur_blips["Champ"].distanceMarker + 30 then
					DrawMarker(1,brasseur_blips["Champ"].x,brasseur_blips["Champ"].y,brasseur_blips["Champ"].z, 0, 0, 0, 0, 0, 0, 30.001, 30.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
				end

				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Brasserie"].x,brasseur_blips["Brasserie"].y,brasseur_blips["Brasserie"].z, true) <= brasseur_blips["Brasserie"].distanceMarker + 30 then
					DrawMarker(1,brasseur_blips["Brasserie"].x,brasseur_blips["Brasserie"].y,brasseur_blips["Brasserie"].z, 0, 0, 0, 0, 0, 0, 30.001, 30.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
				end

				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Point de vente"].x,brasseur_blips["Point de vente"].y,brasseur_blips["Point de vente"].z, true) <= brasseur_blips["Point de vente"].distanceMarker + 30 then
					DrawMarker(1,brasseur_blips["Point de vente"].x,brasseur_blips["Point de vente"].y,brasseur_blips["Point de vente"].z, 0, 0, 0, 0, 0, 0, 30.001, 30.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
				end
			end
		end
	end
end)

RegisterNetEvent('inventory:full')
AddEventHandler('inventory:full', function ()
	recolt = false
	transform = false
	sell = false
end)

function GetServiceBrasseur()
	local playerPed = GetPlayerPed(-1)
	if isInServiceBrasseur then
		defaultNotification.message = "Vous n'êtes plus en service."
		venato.notify(defaultNotification)
		TriggerEvent("venato:LoadClothes")
	else
		defaultNotification.message = "Début de service."
		venato.notify(defaultNotification)
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
		venato.CreateVehicle('pounder',{x=brasseur_car.x, y=brasseur_car.y, z=brasseur_car.z},-50.0, function(vehicle)
			existingVeh = vehicle
			SetVehicleNumberPlateText(existingVeh, brasseur_platesuffix.." "..plate.." ")
			plate = GetVehicleNumberPlateText(existingVeh)
			TriggerEvent('lock:addVeh', plate, GetDisplayNameFromVehicleModel(GetEntityModel(existingVeh)))
			Menu.close()
		end)
	else
		venato.notifyError("Zone encombrée.")
	end
end)

RegisterNetEvent('brasseur:drawGetOrge')
AddEventHandler('brasseur:drawGetOrge', function (qteBase)
	if(qteBase == nil) then
		qteBase = 0
	end

	if qteBase < 30 then
		TriggerServerEvent('Inventory:AddItem',1,tonumber(brasseur_ressourceBase))
		defaultNotification.message = "Vous avez récolté de l'orge."
		venato.notify(defaultNotification)
	else
		recolt = false
		defaultNotification.message = "Vous ne pouvez plus récolter."
		venato.notify(defaultNotification)
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
		TriggerServerEvent("Inventory:RemoveItem", 1, tonumber(brasseur_ressourceBase))
		TriggerServerEvent('Inventory:AddItem',1,tonumber(brasseur_ressourceTraite))
		defaultNotification.message = "+1 bière brassée."
		venato.notify(defaultNotification)
	else
		transform = false
		defaultNotification.message = "Vous ne pouvez plus brasser."
		venato.notify(defaultNotification)
	end
end)

RegisterNetEvent('brasseur:drawSellBiere')
AddEventHandler('brasseur:drawSellBiere', function (qte)
	if(qte == nil) then
		qte = 0
	end

	if qte > 0 then
		TriggerServerEvent("Inventory:RemoveItem", 1, tonumber(brasseur_ressourceTraite))
		local salaire = math.random(brasseur_pay.minimum, brasseur_pay.maximum)
		TriggerServerEvent("Bank:Salaire", salaire, "brasseur")
		defaultNotification.message = "Bières vendues. <br/> <span class='green--text'>"..salaire.."€</span> sont sur votre compte en banque."
		venato.notify(defaultNotification)
	else
		sell = false
		defaultNotification.message = "Vous n'avez plus de bières à vendre."
		venato.notify(defaultNotification)
	end
end)
