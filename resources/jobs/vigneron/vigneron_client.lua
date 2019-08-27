	local Vigneron_blipsTemp
	local Vigneron_markerBool = false
	local existingVeh = nil
	local isInServiceVigneron = false

	local defaultNotification = {
		title = "Vigneron",
		type = "alert",
		logo = "https://i.ibb.co/0JVF4cJ/icons8-grapes-96px.png",
		timeout = 1800
	}

	Citizen.CreateThread(function()
		while true do			
			Wait(0)
			if Vigneron_markerBool == true then
				if isInServiceVigneron and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Vigne"].x,vigneron_blips["Vigne"].y,vigneron_blips["Vigne"].z, true) <= vigneron_blips["Vigne"].distanceBetweenCoords then
					TriggerServerEvent('vigneron:serverRequest', "GetRaisin")
					Citizen.Wait(vigneron_blips["Vigne"].defaultTime)
				end
				if isInServiceVigneron and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Cave"].x,vigneron_blips["Cave"].y,vigneron_blips["Cave"].z, true) <= vigneron_blips["Cave"].distanceBetweenCoords then
					TriggerServerEvent('vigneron:serverRequest', "GetVin")
					Citizen.Wait(vigneron_blips["Cave"].defaultTime)
				end
				if isInServiceVigneron and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Point de vente"].x,vigneron_blips["Point de vente"].y,vigneron_blips["Point de vente"].z, true) <= vigneron_blips["Point de vente"].distanceBetweenCoords then
					TriggerServerEvent('vigneron:serverRequest', "SellVin")
					Citizen.Wait(vigneron_blips["Point de vente"].defaultTime)
				end
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
			print("remove "..k)
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
							Venato.InteractTxt("Appuyez sur ~g~E~s~ pour quitter le ~b~service actif")
						else
							Venato.InteractTxt("Appuyez sur ~g~E~s~ pour rentrer en ~b~service actif")
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
							Venato.InteractTxt("Appuyez sur ~g~E~s~ pour faire apparaitre/ranger votre ~b~vehicule")						
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
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Vigne"].x,vigneron_blips["Vigne"].y,vigneron_blips["Vigne"].z, true) <= vigneron_blips["Vigne"].distanceMarker then
						DrawMarker(1,vigneron_blips["Vigne"].x,vigneron_blips["Vigne"].y,vigneron_blips["Vigne"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Cave"].x,vigneron_blips["Cave"].y,vigneron_blips["Cave"].z, true) <= vigneron_blips["Cave"].distanceMarker then
						DrawMarker(1,vigneron_blips["Cave"].x,vigneron_blips["Cave"].y,vigneron_blips["Cave"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Point de vente"].x,vigneron_blips["Point de vente"].y,vigneron_blips["Point de vente"].z, true) <= vigneron_blips["Point de vente"].distanceMarker then
						DrawMarker(1,vigneron_blips["Point de vente"].x,vigneron_blips["Point de vente"].y,vigneron_blips["Point de vente"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end
				end
			end
		end
	end)

function GetServiceVigneron()
	local playerPed = GetPlayerPed(-1)
	if isInServiceVigneron then
		defaultNotification.message = "Vous n'êtes plus en service."
		Venato.notify(defaultNotification)
		TriggerEvent("Venato:LoadClothes")
	else
		defaultNotification.message = "Début de service."
		Venato.notify(defaultNotification)
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
		Venato.CreateVehicle('SADLER',{x=vigneron_car.x, y=vigneron_car.y, z=vigneron_car.z},90.0, function(veh)
			existingVeh = veh
			print(existingVeh)
			SetVehicleNumberPlateText(existingVeh, vigneron_platesuffix.." "..plate.." ")
			plate = GetVehicleNumberPlateText(existingVeh)
			TriggerEvent('lock:addVeh', plate, GetDisplayNameFromVehicleModel(GetEntityModel(existingVeh)))
			Menu.close()
		end)

	else
		Venato.notifyError("Zone encombrée.")
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
			Venato.notify(defaultNotification)
		else
			defaultNotification.message = "Vous ne pouvez plus charger."
			Venato.notify(defaultNotification)
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
			Venato.notify(defaultNotification)
		else
			defaultNotification.message = "Vous ne possédez plus de raisin."
			Venato.notify(defaultNotification)
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
			TriggerServerEvent('Bank:AddBankMoney', salaire)
			defaultNotification.message = "Bouteilles de vin vendues. <br/> <span class='green--text'>"..salaire.."€</span> sont sur votre compte en banque."
			Venato.notify(defaultNotification)
		else
			defaultNotification.message = "Vous n'avez plus de vin à vendre."
			Venato.notify(defaultNotification)
		end
	end)
