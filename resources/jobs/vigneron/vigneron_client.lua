	local Vigneron_blipsTemp
	local Vigneron_markerBool = false
	local existingVeh = nil
	local isInServiceVigneron = false
	local recolt = false
	local transform = false
	local sell = false

	local defaultNotification = {
		title = "Vigneron",
		type = "alert",
		logo = "https://i.ibb.co/0JVF4cJ/icons8-grapes-96px.png",
		timeout = 800
	}

	Citizen.CreateThread(function()
		while true do			
			Wait(0)
			if Vigneron_markerBool == true then
				if isInServiceVigneron and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Vigne"].x,vigneron_blips["Vigne"].y,vigneron_blips["Vigne"].z, true) <= vigneron_blips["Vigne"].distanceBetweenCoords then
					if(not recolt) then
						platypus.InteractTxt("Appuyez sur ~g~E~s~ pour commencer à récolter du ~b~raisin~s~.")						
					else
						platypus.InteractTxt("Appuyez sur ~g~E~s~ pour arrêter de récolter du ~b~raisin~s~.")
					end

					if IsControlJustPressed(1, Keys["E"]) then
						recolt = not recolt
					end				
				else
					recolt = false
				end
				if isInServiceVigneron and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Cave"].x,vigneron_blips["Cave"].y,vigneron_blips["Cave"].z, true) <= vigneron_blips["Cave"].distanceBetweenCoords then
					if(not transform) then
						platypus.InteractTxt("Appuyez sur ~g~E~s~ pour commencer à transformer le ~b~raisin~s~.")						
					else
						platypus.InteractTxt("Appuyez sur ~g~E~s~ pour arrêter de transformer le ~b~raisin~s~.")
					end

					if IsControlJustPressed(1, Keys["E"]) then
						transform = not transform
					end
				else
					transform = false
				end
				if isInServiceVigneron and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Point de vente"].x,vigneron_blips["Point de vente"].y,vigneron_blips["Point de vente"].z, true) <= vigneron_blips["Point de vente"].distanceBetweenCoords then
					if(not sell) then
						platypus.InteractTxt("Appuyez sur ~g~E~s~ pour commencer à vendre de les ~b~bouteilles de vin~s~.")						
					else
						platypus.InteractTxt("Appuyez sur ~g~E~s~ pour arrêter de vendre de les ~b~bouteilles de vin~s~.")
					end

					if IsControlJustPressed(1, Keys["E"]) then
						sell = not sell
					end
				else
					sell = false
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

	Citizen.CreateThread(function ()
		while true do
			Citizen.Wait(1)
			if recolt then
				TriggerServerEvent('vigneron:serverRequest', "GetRaisin")
				Citizen.Wait(vigneron_blips["Vigne"].defaultTime)
			end
			if transform then					
				TriggerServerEvent('vigneron:serverRequest', "GetVin")
				Citizen.Wait(vigneron_blips["Cave"].defaultTime)
			end
			if sell then					
				TriggerServerEvent('vigneron:serverRequest', "SellVin")
				Citizen.Wait(vigneron_blips["Point de vente"].defaultTime)
			end
		end
	end)

	function Vigneron_callSE(evt)
		TriggerServerEvent(evt)
	end

	function Vigneron_InitMenuVehicules()
		TriggerEvent('Menu:Init', "Vigneron - Véhicule", "Options", "#BA68C899", "https://www.studyrama.com/IMG/arton103428.png")
	  	Menu.clearMenu()
		Menu.addButton("Vehicule", "Vigneron_callSE", 'vigneron:Car')
		Menu.open()
	end

	RegisterNetEvent('vigneron:drawBlips')
	AddEventHandler('vigneron:drawBlips', function ()
		for key, item in pairs(vigneron_blips) do
			item.blip = AddBlipForCoord(item.x, item.y, item.z)
			SetBlipSprite(item.blip, item.id)
			SetBlipAsShortRange(item.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(key)
			EndTextCommandSetBlipName(item.blip)
			BlipsJobs[item.blip] = item.blip
		end
		Vigneron_blipsTemp = vigneron_blips
	end)

	RegisterNetEvent('job:deleteBlips')
	AddEventHandler('job:deleteBlips', function ()
		Vigneron_markerBool = false
		for k, item in pairs(BlipsJobs) do
			RemoveBlip(k)
		end
	end)

	RegisterNetEvent('Job:startVigneron')
	AddEventHandler('Job:startVigneron', function (boolean)
		Vigneron_markerBool = boolean
		if boolean then
			TriggerEvent("vigneron:drawBlips")
		end
	end)

	
	Citizen.CreateThread(function ()
		while true do
			Citizen.Wait(1)
			if Vigneron_markerBool == true then
				local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Entreprise"].x, vigneron_blips["Entreprise"].y, vigneron_blips["Entreprise"].z, true)
				if distance <= vigneron_blips["Entreprise"].distanceMarker then
					DrawMarker(1, vigneron_blips["Entreprise"].x, vigneron_blips["Entreprise"].y, vigneron_blips["Entreprise"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					if distance <= 5 then
						if isInServiceVigneron then
							platypus.InteractTxt("Appuyez sur ~g~E~s~ pour quitter le ~b~service actif")
						else
							platypus.InteractTxt("Appuyez sur ~g~E~s~ pour rentrer en ~b~service actif")
						end						
						if IsControlJustPressed(1, Keys["E"]) then
							GetServiceVigneron()
						end
					end
				end
				if isInServiceVigneron then
					local distance2 = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Garage"].x, vigneron_blips["Garage"].y, vigneron_blips["Garage"].z, true)
					if distance2 <= vigneron_blips["Garage"].distanceMarker then
						DrawMarker(1, vigneron_blips["Garage"].x, vigneron_blips["Garage"].y, vigneron_blips["Garage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
						if distance2 <= 5 then
							platypus.InteractTxt("Appuyez sur ~g~E~s~ pour faire apparaitre/ranger votre ~b~vehicule")						
							if IsControlJustPressed(1, Keys["E"]) then
								if(existingVeh ~= nil) then
									SetEntityAsMissionEntity(existingVeh, true, true)
									Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
									existingVeh = nil
								else
									Vigneron_InitMenuVehicules()
									Menu.hidden = not Menu.hidden
								end
							end
						end
					end
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Vigne"].x,vigneron_blips["Vigne"].y,vigneron_blips["Vigne"].z, true) <= vigneron_blips["Vigne"].distanceMarker + 30then
						DrawMarker(1,vigneron_blips["Vigne"].x,vigneron_blips["Vigne"].y,vigneron_blips["Vigne"].z, 0, 0, 0, 0, 0, 0, 5.001, 5.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Cave"].x,vigneron_blips["Cave"].y,vigneron_blips["Cave"].z, true) <= vigneron_blips["Cave"].distanceMarker + 30 then
						DrawMarker(1,vigneron_blips["Cave"].x,vigneron_blips["Cave"].y,vigneron_blips["Cave"].z, 0, 0, 0, 0, 0, 0, 10.001, 10.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Point de vente"].x,vigneron_blips["Point de vente"].y,vigneron_blips["Point de vente"].z, true) <= vigneron_blips["Point de vente"].distanceMarker + 30 then
						DrawMarker(1,vigneron_blips["Point de vente"].x,vigneron_blips["Point de vente"].y,vigneron_blips["Point de vente"].z, 0, 0, 0, 0, 0, 0, 10.001, 10.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end
				end
			end
		end
	end)

function GetServiceVigneron()
	local playerPed = GetPlayerPed(-1)
	if isInServiceVigneron then
		defaultNotification.message = "Vous n'êtes plus en service."
		platypus.notify(defaultNotification)
		TriggerEvent("platypus:LoadClothes")
	else
		defaultNotification.message = "Début de service."
		platypus.notify(defaultNotification)
		TriggerEvent("vigneron:getSkin")
	end
	isInServiceVigneron = not isInServiceVigneron
end

RegisterNetEvent('vigneron:getSkin')
AddEventHandler('vigneron:getSkin', function (source)
local hashSkin = GetHashKey("mp_m_freemode_01")
Citizen.CreateThread(function()
	if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
		SetPedComponentVariation(GetPlayerPed(-1), 11, 41, 1, 2)  -- Top
		SetPedComponentVariation(GetPlayerPed(-1), 8, 59, 0, 2)   -- under coat 73 ?
		SetPedComponentVariation(GetPlayerPed(-1), 4, 9, 6, 2)   -- Pantalon
		SetPedComponentVariation(GetPlayerPed(-1), 6, 12, 6, 2)   -- chaussures
		--SetPedComponentVariation(GetPlayerPed(-1), 3, 67, 0, 2)   -- mains/gants/bras etc. ... (shirt)
		SetPedComponentVariation(GetPlayerPed(-1), 3, 64, 0, 2)
	else
		SetPedComponentVariation(GetPlayerPed(-1), 11, 86, 0, 2)  -- Top
		SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2)   -- under coat 73 ?
		SetPedComponentVariation(GetPlayerPed(-1), 4, 25, 1, 2)   -- Pantalon
		SetPedComponentVariation(GetPlayerPed(-1), 6, 10, 3, 2)   -- chaussures
		SetPedComponentVariation(GetPlayerPed(-1), 3, 114, 0, 2)   -- mains/gants/bras etc. ... (shirt)
	end
end)
end)

RegisterNetEvent('vigneron:getCar')
AddEventHandler('vigneron:getCar', function (source)
	local vehiculeDetected = GetClosestVehicle(vigneron_car.x, vigneron_car.y, vigneron_car.z, 6.0, 0, 70)
	if not DoesEntityExist(vehiculeDetected) then
		local myPed = GetPlayerPed(-1)
		local player = PlayerId()
		local vehicle = GetHashKey('sadler')
		local plate = math.random(1000, 9999)
		platypus.CreateVehicle('SADLER',{x=vigneron_car.x, y=vigneron_car.y, z=vigneron_car.z},90.0, function(veh)
			existingVeh = veh
			SetVehicleNumberPlateText(existingVeh, vigneron_platesuffix.." "..plate.." ")
			plate = GetVehicleNumberPlateText(existingVeh)
			TriggerEvent('lock:addVeh', plate, GetDisplayNameFromVehicleModel(GetEntityModel(existingVeh)))
			Menu.close()
		end)

	else
		platypus.notifyError("Zone encombrée.")
	end
end)

	RegisterNetEvent('vigneron:drawGetRaisin')
	AddEventHandler('vigneron:drawGetRaisin', function (qteVign)
		if(qteVign == nil) then
			qteVign = 0
		end

		if qteVign < 100 then
			TriggerServerEvent('Inventory:AddItem',1, tonumber(vigneron_ressourceBase))
			defaultNotification.message = "Chargement de raisin en cours."
			platypus.notify(defaultNotification)
		else
			recolt = false
			defaultNotification.message = "Vous ne pouvez plus charger."
			platypus.notify(defaultNotification)
		end
	end)

	RegisterNetEvent('vigneron:drawGetVin')
	AddEventHandler('vigneron:drawGetVin', function(qteVign, qteTraite)
		if(qteVign == nil) then
			qteVign = 0
		end

		if(qteTraite == nil) then
			qteTraite = 0
		end

		if qteTraite < 100 and qteVign > 0 then
			TriggerServerEvent("Inventory:RemoveItem",1, tonumber(vigneron_ressourceBase))
			TriggerServerEvent('Inventory:AddItem',1, tonumber(vigneron_ressourceTraite))
			defaultNotification.message = "Récupération des bouteilles de vins."
			platypus.notify(defaultNotification)
		else
			transform = false
			defaultNotification.message = "Vous ne possédez plus de raisin."
			platypus.notify(defaultNotification)
		end
	end)

	RegisterNetEvent('vigneron:drawSellVin')
	AddEventHandler('vigneron:drawSellVin', function (qte)
		if(qte == nil) then
			qte = 0
		end

		if qte > 0 then
			TriggerServerEvent("Inventory:RemoveItem",1, tonumber(vigneron_ressourceTraite))
			local salaire = math.random(vigneron_pay.minimum, vigneron_pay.maximum)
			TriggerServerEvent("Bank:Salaire", salaire, "vigneron")
			defaultNotification.message = "Bouteilles de vin vendues. <br/> <span class='green--text'>"..salaire.."€</span> sont sur votre compte en banque."
			platypus.notify(defaultNotification)
		else
			sell = false
			defaultNotification.message = "Vous n'avez plus de vin à vendre."
			platypus.notify(defaultNotification)
		end
	end)
