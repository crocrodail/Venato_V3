	local pompiste_blipsTemp
	local Pompiste_markerBool = false
	local camion = nil
	local remorque = nil
	local isInServicePompiste = false
	local recolt = false
	local transform = false
	local sell = false

	local defaultNotification = {
		title = "Pompiste",
		type= "alert",
		logo = "https://i.ibb.co/61pT4gN/icons8-gas-station-96px.png",
		timeout = 800
	}

	Citizen.CreateThread(function()
		while true do
			Wait(0)
			if Pompiste_markerBool == true then
				if isInServicePompiste and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pompiste_blips["Station de pompage"].x,pompiste_blips["Station de pompage"].y,pompiste_blips["Station de pompage"].z, true) <= pompiste_blips["Station de pompage"].distanceBetweenCoords then
					if(not recolt) then
						Venato.InteractTxt("Appuyez sur ~g~E~s~ pour commencer à récolter du ~b~pétrole brut~s~.")						
					else
						Venato.InteractTxt("Appuyez sur ~g~E~s~ pour arrêter de récolter du ~b~pétrole brut~s~.")
					end

					if IsControlJustPressed(1, Keys["E"]) then
						recolt = not recolt
					end
				else
					recolt = false
				end
				if isInServicePompiste and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pompiste_blips["Transformation"].x,pompiste_blips["Transformation"].y,pompiste_blips["Transformation"].z, true) <= pompiste_blips["Transformation"].distanceBetweenCoords then
					if(not transform) then
						Venato.InteractTxt("Appuyez sur ~g~E~s~ pour commencer à transformer le ~b~pétrole brut~s~.")						
					else
						Venato.InteractTxt("Appuyez sur ~g~E~s~ pour arrêter de transformer du ~b~pétrole brut~s~.")
					end

					if IsControlJustPressed(1, Keys["E"]) then
						transform = not transform
					end
				else
					transform = false
				end
				if isInServicePompiste and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pompiste_blips["Point de vente"].x,pompiste_blips["Point de vente"].y,pompiste_blips["Point de vente"].z, true) <= pompiste_blips["Point de vente"].distanceBetweenCoords then
					if(not sell) then
						Venato.InteractTxt("Appuyez sur ~g~E~s~ pour commencer à vendre de l'~b~essence~s~.")						
					else
						Venato.InteractTxt("Appuyez sur ~g~E~s~ pour arrêter de vendre de l'~b~essence~s~.")
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

	function transporteur_callSE(evt)
		TriggerServerEvent(evt)
	end

	function pompiste_InitMenuVehicules()
		TriggerEvent('Menu:Init', "Pompiste - Véhicule", "Options", "#388E3C99", "http://www.scienceinfo.fr/wp-content/uploads/2018/10/inversion_diesel_essence.jpg")
	  	Menu.clearMenu()
		Menu.addButton("Camion", "transporteur_callSE","pompiste:Car1")
		Menu.addButton("Remorque", "transporteur_callSE","pompiste:Car2")
		Menu.open()
	end


	RegisterNetEvent('pompiste:drawBlips')
	AddEventHandler('pompiste:drawBlips', function ()
		for key, item in pairs(pompiste_blips) do
			item.blip = AddBlipForCoord(item.x, item.y, item.z)
			SetBlipSprite(item.blip, item.id)
			SetBlipAsShortRange(item.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(key)
			EndTextCommandSetBlipName(item.blip)
			BlipsJobs[item.blip] = item.blip
		end
		pompiste_blipsTemp = pompiste_blips
	end)

	RegisterNetEvent('job:deleteBlips')
	AddEventHandler('job:deleteBlips', function ()
		Pompiste_markerBool = false
		for k, item in pairs(BlipsJobs) do
			RemoveBlip(k)
		end
	end)

	RegisterNetEvent('Job:startPompiste')
	AddEventHandler('Job:startPompiste', function (boolean)
		Pompiste_markerBool = boolean
		if boolean then
			TriggerEvent("pompiste:drawBlips")
		end		
	end)

	Citizen.CreateThread(function ()
		while true do
			Citizen.Wait(1)
			if Pompiste_markerBool == true then
				local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pompiste_blips["Entreprise"].x, pompiste_blips["Entreprise"].y, pompiste_blips["Entreprise"].z, true)
				if distance <= pompiste_blips["Entreprise"].distanceMarker then
					DrawMarker(1, pompiste_blips["Entreprise"].x, pompiste_blips["Entreprise"].y, pompiste_blips["Entreprise"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					if distance <= 5 then						
						if isInServicePompiste then
							Venato.InteractTxt("Appuyez sur ~g~E~s~ pour quitter le ~b~service actif")
						else
							Venato.InteractTxt("Appuyez sur ~g~E~s~ pour rentrer en ~b~service actif")
						end
						if IsControlJustPressed(1, Keys["E"]) then
							GetServicePompiste()
						end
					end
				end

				if isInServicePompiste then
					local distance2 = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pompiste_blips["Garage"].x, pompiste_blips["Garage"].y, pompiste_blips["Garage"].z, true)
					if distance2 <= pompiste_blips["Garage"].distanceMarker+5 then
						DrawMarker(1, pompiste_blips["Garage"].x, pompiste_blips["Garage"].y, pompiste_blips["Garage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
						if distance2 <= 5 then							
							Venato.InteractTxt("Appuyez sur ~g~E~s~ pour faire apparaitre/ranger votre ~b~vehicule")
							if IsControlJustPressed(1, Keys["E"]) then
								pompiste_InitMenuVehicules()
							end
						end
					end

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), brasseur_blips["Garage"].x,brasseur_blips["Garage"].y,brasseur_blips["Garage"].z, true) <= brasseur_blips["Garage"].distanceMarker then
						DrawMarker(1,brasseur_blips["Garage"].x,brasseur_blips["Garage"].y,brasseur_blips["Garage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pompiste_blips["Station de pompage"].x,pompiste_blips["Station de pompage"].y,pompiste_blips["Station de pompage"].z, true) <= pompiste_blips["Station de pompage"].distanceMarker + 30 then
						DrawMarker(1,pompiste_blips["Station de pompage"].x,pompiste_blips["Station de pompage"].y,pompiste_blips["Station de pompage"].z, 0, 0, 0, 0, 0, 0, 30.001, 30.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pompiste_blips["Transformation"].x,pompiste_blips["Transformation"].y,pompiste_blips["Transformation"].z, true) <= pompiste_blips["Transformation"].distanceMarker + 30 then
						DrawMarker(1,pompiste_blips["Transformation"].x,pompiste_blips["Transformation"].y,pompiste_blips["Transformation"].z, 0, 0, 0, 0, 0, 0, 30.001, 30.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pompiste_blips["Point de vente"].x,pompiste_blips["Point de vente"].y,pompiste_blips["Point de vente"].z, true) <= pompiste_blips["Point de vente"].distanceMarker + 30 then
						DrawMarker(1,pompiste_blips["Point de vente"].x,pompiste_blips["Point de vente"].y,pompiste_blips["Point de vente"].z, 0, 0, 0, 0, 0, 0, 30.001, 30.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end
				end
			end
		end
	end)

	
	Citizen.CreateThread(function ()
		while true do
			Citizen.Wait(1)
			if recolt then
				TriggerServerEvent('pompiste:serverRequest', "GetPetrol")
				Citizen.Wait(pompiste_blips["Station de pompage"].defaultTime)
			end
			if transform then
				TriggerServerEvent('pompiste:serverRequest', "GetEssence")
				Citizen.Wait(pompiste_blips["Transformation"].defaultTime)
			end
			if sell then
				TriggerServerEvent('pompiste:serverRequest', "SellEssence")
				Citizen.Wait(pompiste_blips["Point de vente"].defaultTime)
			end
		end
	end)

function GetServicePompiste()
	local playerPed = GetPlayerPed(-1)
	if isInServicePompiste then
		defaultNotification.message = "Vous n'êtes plus en service."
		Venato.notify(defaultNotification)
		TriggerEvent("Venato:LoadClothes")
	else
		defaultNotification.message = "Début de service."
		Venato.notify(defaultNotification)
		TriggerEvent("pompiste:getSkin")
	end
	isInServicePompiste = not isInServicePompiste
end

RegisterNetEvent('pompiste:getSkin')
AddEventHandler('pompiste:getSkin', function (source)
	local hashSkin = GetHashKey("mp_m_freemode_01")
	Citizen.CreateThread(function()
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
			SetPedComponentVariation(GetPlayerPed(-1), 11, 111, 3, 2)  -- Top
			SetPedComponentVariation(GetPlayerPed(-1), 8, 59, 1, 2)   -- under coat
			SetPedComponentVariation(GetPlayerPed(-1), 4, 49, 1, 2)   -- Pants
			SetPedComponentVariation(GetPlayerPed(-1), 6, 55, 0, 2)   -- shoes
			SetPedComponentVariation(GetPlayerPed(-1), 3, 42, 0, 2)   -- under skin
		else
			SetPedComponentVariation(GetPlayerPed(-1), 11, 11, 2, 2)  -- Top
			SetPedComponentVariation(GetPlayerPed(-1), 8, 36, 0, 2)   -- under coat
			SetPedComponentVariation(GetPlayerPed(-1), 4, 35, 0, 2)   -- Pants
			SetPedComponentVariation(GetPlayerPed(-1), 6, 26, 0, 2)   -- shoes
			SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2)   -- under skin
		end
	end)
end)

RegisterNetEvent('pompiste:getCamion')
AddEventHandler('pompiste:getCamion', function ()
	if(camion ~= nil) then
		SetEntityAsMissionEntity(camion, true, true)
		TriggerServerEvent('ivt:deleteVeh', GetVehicleNumberPlateText(camion))
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(camion))
		camion = nil
	else
	local vehiculeDetected = GetClosestVehicle(pompiste_car2.x, pompiste_car2.y, pompiste_car2.z, 6.0, 0, 70)
	if not DoesEntityExist(vehiculeDetected) then
		local myPed = GetPlayerPed(-1)
		local player = PlayerId()
		local plate = math.random(1000, 9999)
		Venato.CreateVehicle('packer', {x=pompiste_car2.x, y=pompiste_car2.y, z=pompiste_car2.z},34.0, function(cam)
			camion = cam
			SetVehicleNumberPlateText(camion, "POMPISTE")
			SetEntityAsMissionEntity(camion, true, true)
			plate = GetVehicleNumberPlateText(camion)
			TriggerEvent('lock:addVeh', plate, GetDisplayNameFromVehicleModel(GetEntityModel(camion)))
			Menu.close()
		end)
	else
		Venato.notifyError("Zone encombrée.")
	end
	end
end)

RegisterNetEvent('pompiste:getRemorque')
AddEventHandler('pompiste:getRemorque', function ()
	if(remorque ~= nil) then
		SetEntityAsMissionEntity(remorque, true, true)
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(remorque))
		remorque = nil
	else
	local vehiculeDetected = GetClosestVehicle(pompiste_car.x, pompiste_car.y, pompiste_car.z, 6.0, 0, 70)
	if not DoesEntityExist(vehiculeDetected) then
		local myPed = GetPlayerPed(-1)
		local player = PlayerId()
		local vehicle = GetHashKey('tanker')
		local plate = math.random(1000, 9999)
		Venato.CreateVehicle('tanker', {x=pompiste_car.x, y=pompiste_car.y, z=pompiste_car.z},34.0,function(rem)
			remorque = rem
			SetVehicleNumberPlateText(remorque, pompiste_platesuffix.." "..plate.." ")
			plate = GetVehicleNumberPlateText(remorque)
			TriggerEvent('lock:addVeh', plate, GetDisplayNameFromVehicleModel(GetEntityModel(remorque)))
		end)
	else
		Venato.notifyError("Zone encombrée.")
	end
	end
end)

RegisterNetEvent('inventory:full')
AddEventHandler('inventory:full', function ()
	recolt = false
	transform = false
	sell = false
end)


RegisterNetEvent('pompiste:drawGetPetrol')
AddEventHandler('pompiste:drawGetPetrol', function (qtePetrol)
	if(qtePetrol == nil) then
		qtePetrol = 0
	end

	if qtePetrol < 100 then
		TriggerServerEvent('Inventory:AddItem', 1, tonumber(pompiste_ressourceBase))
		defaultNotification.message = "Pompage du pétrole."
		Venato.notify(defaultNotification)
	else
		recolt = false
		defaultNotification.message = "Vous ne pouvez plus pomper."
		Venato.notify(defaultNotification)
	end
end)

RegisterNetEvent('pompiste:drawGetEssence')
AddEventHandler('pompiste:drawGetEssence', function(qtePetrol, qteEssence)
	if(qtePetrol == nil) then
		qtePetrol = 0
	end

	if(qteEssence == nil) then
		qteEssence = 0
	end

	if qteEssence < 100 and qtePetrol > 0 then
		TriggerServerEvent('Inventory:RemoveItem',1, tonumber(pompiste_ressourceBase))
		TriggerServerEvent('Inventory:AddItem',1, tonumber(pompiste_ressourceTraite))
		defaultNotification.message = "Pétrole déchargé et transformé en essence."
		Venato.notify(defaultNotification)
	else
		transform = false
		defaultNotification.message = "Vous ne pouvez plus transformer de pétrole."
		Venato.notify(defaultNotification)
	end
end)

	RegisterNetEvent('pompiste:drawSellEssence')
	AddEventHandler('pompiste:drawSellEssence', function (qte)
		if(qte == nil) then
			qte = 0
		end

		if qte > 0 then
		TriggerServerEvent('Inventory:RemoveItem',1, tonumber(pompiste_ressourceTraite))
		
		local salaire = math.random(pompiste_pay.minimum, pompiste_pay.maximum)
		TriggerServerEvent("Bank:Salaire", salaire, 'pompiste')
		defaultNotification.message = "Essence vendue. <br/> <span class='green--text'>"..salaire.."€</span> sont sur votre compte en banque."
		Venato.notify(defaultNotification)
	else
		sell = false
		defaultNotification.message = "Vous n'avez plus d'essence à vendre."
		Venato.notify(defaultNotification)
	end
end)
