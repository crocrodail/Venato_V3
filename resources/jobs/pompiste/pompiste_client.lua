	local pompiste_blipsTemp
	local Pompiste_markerBool = false
	local camion = nil
	local remorque = nil
	local isInServicePompiste = false

	function transporteur_callSE(evt)
		TriggerServerEvent(evt)
	end

	function pompiste_InitMenuVehicules()
		Menu.open()
	  Menu.setTitle("Spawn vehicule")
	  Menu.setSubtitle("Option")
	  Menu.clearMenu()
		Menu.addButton("Camion", "transporteur_callSE","pompiste:Car1")
		Menu.addButton("Remorque", "transporteur_callSE","pompiste:Car2")
	end


	RegisterNetEvent('pompiste:drawBlips')
	AddEventHandler('pompiste:drawBlips', function ()
		for key, item in pairs(pompiste_blips) do
			print(item.blip)
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

	RegisterNetEvent('Job:startPompiste')
	AddEventHandler('Job:startPompiste', function (boolean)
		pompiste_markerBool = boolean
		if boolean then
			TriggerEvent("pompiste:drawBlips")
			TriggerEvent("pompiste:marker")
		end
		Citizen.CreateThread(function()
			while pompiste_markerBool == true do
				Wait(0)
				if isInServicePompiste and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pompiste_blips["Station de pompage"].x,pompiste_blips["Station de pompage"].y,pompiste_blips["Station de pompage"].z, true) <= pompiste_blips["Station de pompage"].distanceBetweenCoords then
					TriggerServerEvent('pompiste:serverRequest', "GetPetrol")
					Citizen.Wait(pompiste_blips["Station de pompage"].defaultTime)
				end
				if isInServicePompiste and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pompiste_blips["Transformation"].x,pompiste_blips["Transformation"].y,pompiste_blips["Transformation"].z, true) <= pompiste_blips["Transformation"].distanceBetweenCoords then
					TriggerServerEvent('pompiste:serverRequest', "GetEssence")
					Citizen.Wait(pompiste_blips["Transformation"].defaultTime)
				end
				if isInServicePompiste and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pompiste_blips["Point de vente"].x,pompiste_blips["Point de vente"].y,pompiste_blips["Point de vente"].z, true) <= pompiste_blips["Point de vente"].distanceBetweenCoords then
					TriggerServerEvent('pompiste:serverRequest', "SellEssence")
					Citizen.Wait(pompiste_blips["Point de vente"].defaultTime)
				end
			end
		end)
	end)

	RegisterNetEvent('pompiste:marker')
	AddEventHandler('pompiste:marker', function ()
		Citizen.CreateThread(function ()
			while pompiste_markerBool == true do
				Citizen.Wait(1)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pompiste_blips["Entreprise"].x, pompiste_blips["Entreprise"].y, pompiste_blips["Entreprise"].z, true) <= pompiste_blips["Entreprise"].distanceMarker then
					DrawMarker(1, pompiste_blips["Entreprise"].x, pompiste_blips["Entreprise"].y, pompiste_blips["Entreprise"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					ClearPrints()
					SetTextEntry_2("STRING")
					if isInServicePompiste then
						AddTextComponentString("Appuyez sur ~g~E~s~ pour quitter le ~b~service actif")
					else
						AddTextComponentString("Appuyez sur ~g~E~s~ pour rentrer en ~b~service actif")
					end
					DrawSubtitleTimed(2000, 1)
					if IsControlJustPressed(1, Keys["E"]) then
						GetServicePompiste()
					end
				end
				if isInServicePompiste then
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pompiste_blips["Garage"].x, pompiste_blips["Garage"].y, pompiste_blips["Garage"].z, true) <= pompiste_blips["Garage"].distanceMarker+5 then
						DrawMarker(1, pompiste_blips["Garage"].x, pompiste_blips["Garage"].y, pompiste_blips["Garage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString("Appuyez sur ~g~E~s~ pour faire appairaitre/ranger votre ~b~vehicule")
						DrawSubtitleTimed(2000, 1)
						if IsControlJustPressed(1, Keys["E"]) then
								pompiste_InitMenuVehicules()
								Menu.hidden = not Menu.hidden
						end
					end

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pompiste_blips["Station de pompage"].x,pompiste_blips["Station de pompage"].y,pompiste_blips["Station de pompage"].z, true) <= pompiste_blips["Station de pompage"].distanceMarker then
						DrawMarker(1,pompiste_blips["Station de pompage"].x,pompiste_blips["Station de pompage"].y,pompiste_blips["Station de pompage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pompiste_blips["Transformation"].x,pompiste_blips["Transformation"].y,pompiste_blips["Transformation"].z, true) <= pompiste_blips["Transformation"].distanceMarker then
						DrawMarker(1,pompiste_blips["Transformation"].x,pompiste_blips["Transformation"].y,pompiste_blips["Transformation"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pompiste_blips["Point de vente"].x,pompiste_blips["Point de vente"].y,pompiste_blips["Point de vente"].z, true) <= pompiste_blips["Point de vente"].distanceMarker then
						DrawMarker(1,pompiste_blips["Point de vente"].x,pompiste_blips["Point de vente"].y,pompiste_blips["Point de vente"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end
				end
			end
		end)
	end)

function GetServicePompiste()
	local playerPed = GetPlayerPed(-1)
	if isInServicePompiste then
		notif("Vous n\'êtes plus en service")
		TriggerEvent("Venato:LoadClothes")
	else
		notif("Début du service")
		TriggerEvent("pompiste:getSkin")
	end
	isInServicePompiste = not isInServicePompiste
	TriggerServerEvent('pompiste:setService', isInServicePompiste)
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
				SetVehicleNumberPlateText(camion, "PONPISTE")
				SetEntityAsMissionEntity(camion, true, true)
				plate = GetVehicleNumberPlateText(camion)
				TriggerEvent('lock:addVeh', plate, GetDisplayNameFromVehicleModel(GetEntityModel(camion)))
			end)
		else
			TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "encombrée.")
			notif("Zone encombrée.")
			print('encombrée')
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
			TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "encombrée.")
			notif("Zone encombrée.")
			print('encombrée')
		end
		end
	end)


	RegisterNetEvent('pompiste:drawGetPetrol')
	AddEventHandler('pompiste:drawGetPetrol', function (qtePetrol)
		if(qtePetrol == nil) then
			qtePetrol = 0
		end

		if qtePetrol < 100 then
			TriggerServerEvent('Inventory:AddItem',1, 201)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~w~Pompage du~g~Pétrole ~w~en cours..")
			DrawSubtitleTimed(8500, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~Vous ne pouvez plus pomper")
			DrawSubtitleTimed(2000, 1)
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
			TriggerServerEvent('Inventory:RemoveItem',1, 201)
			TriggerServerEvent('Inventory:AddItem',1, 202)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~Pétrole~w~ déchargé et transformation en ~g~essence ~w~en cours..")
			DrawSubtitleTimed(8500, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~Vous ne pouvez plus transformer d'essence")
			DrawSubtitleTimed(2000, 1)
		end
	end)

	RegisterNetEvent('pompiste:drawSellEssence')
	AddEventHandler('pompiste:drawSellEssence', function (qte)
		if(qte == nil) then
			qte = 0
		end

		if qte > 0 then
		TriggerServerEvent('Inventory:RemoveItem',1, 202)
		local salaire = math.random(pompiste_pay.minimum, pompiste_pay.maximum)
		TriggerServerEvent('Bank:AddBankMoney', salaire)
		ClearPrints()
		SetTextEntry_2("STRING")
		AddTextComponentString("~w~Vente de l'~g~essence ~w~en cours...")
		DrawSubtitleTimed(8500, 1)
	else
		ClearPrints()
		SetTextEntry_2("STRING")
		AddTextComponentString("~r~plus d'essence, plus d'argent")
		DrawSubtitleTimed(2000, 1)
	end
end)
