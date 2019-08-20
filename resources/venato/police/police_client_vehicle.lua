local policeveh = {
	opened = false,
	title = "Cop Garage",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 }, -- ???
	menu = {
		x = 0.11,
		y = 0.25,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				--{name = "Police Stanier", costs = 0, description = {}, model = "police"},
				--{name = "Police Buffalo", costs = 0, description = {}, model = "police2"},
				--{name = "Police Interceptor", costs = 0, description = {}, model = "police3"},
				{name = "Cop Car", costs = 0, description = {}, model = "police4"},
				{name = "Police Riot", costs = 0, description = {}, model = "riot"},
				--{name = "Police Esperanto", costs = 0, description = {}, model = "policeold2"},
				--{name = "Police Transport Van", costs = 0, description = {}, model = "policet"},
				--{name = "FBI", costs = 0, description = {}, model = "fbi"},
				--{name = "FBI2", costs = 0, description = {}, model = "fbi2"},
				{name = "Cop Motorcycle", costs = 0, description = {}, model = "policeb"},

			}
		},
	},
	police4 = { x = 431.47, y = -997.245, z = 25.36, h = 178.83},
	policefelon = { x = 431.47, y = -997.245, z = 25.36, h = 178.83},
	fbi2 = { x = 431.47, y = -997.245, z = 25.36, h = 178.83},
	oracle2 = { x = 431.47, y = -997.245, z = 25.36, h = 178.83},
	police = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},

	police15 = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	police14 = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	police13 = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	police12 = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	police11 = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},

	police6 = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	police7 = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	police8 = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	policebike = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},

	police2 = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	sheriff = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	policeb = { x = 463.5075, y = -1014.99, z = 27.5485, h = 90.23},
	policet = { x = 436.1801, y = -996.90, z = 25.74, h = 182,05},
	police3 = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	riot = { x = 451.155700683594, y = -1013.65216064453, z = 28.4793395996094, h = 93.2385025024414},
	pbus = { x = 449.45520019531, y = -1013.7339477539, z = 28.760444641113, h = 93.2385025024414},
	polmp4  = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	pol718  = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	speedo = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	xls2 = { x = 431.47, y = -997.245, z = 25.36, h = 178.83},
	oracle = { x = 124.466506958008, y = -720.756774902344, z = 42.0282363891602 , h = 340.438323974609},
	buzzard2 = { x = 169.905395507813, y = -671.843078613281, z = 43.140926361084 , h = 108.344207763672},
}

local policeveh2 = {
	opened = false,
	title = "Cop Garage",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 }, -- ???
	menu = {
		x = 0.11,
		y = 0.25,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				--{name = "Police Stanier", costs = 0, description = {}, model = "police"},
				--{name = "Police Buffalo", costs = 0, description = {}, model = "police2"},
				--{name = "Police Interceptor", costs = 0, description = {}, model = "police3"},
				{name = "Cop Car", costs = 0, description = {}, model = "police4"},
				{name = "Police Riot", costs = 0, description = {}, model = "riot"},
				--{name = "Police Esperanto", costs = 0, description = {}, model = "policeold2"},
				--{name = "Police Transport Van", costs = 0, description = {}, model = "policet"},
				--{name = "FBI", costs = 0, description = {}, model = "fbi"},
				--{name = "FBI2", costs = 0, description = {}, model = "fbi2"},
				{name = "Cop Motorcycle", costs = 0, description = {}, model = "policeb"},

			}
		},
	},
	police4 = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	policefelon = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	fbi2 = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	oracle2 = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	police = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},

	police15 = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	police14 = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	police13 = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	police12 = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	police11 = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},

	police6 = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	police7 = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	police8 = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	policebike = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},

	police2 = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	sheriff = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	policeb = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	policet = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	police3 = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	riot = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	pbus = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	polmp4  = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	pol718  = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	speedo = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	xls2 = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	oracle = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
	buzzard2 = { x=1866.9225, y=3698.6623, z=33.3699, h=206.22286},
}



local stationGarage = {
	{x=452.115966796875, y=-1018.10681152344, z=28.4786586761475},
	{x=1867.1923, y=3691.2719, z=33.7599},
}

local fakecar = {model = '', car = nil}
local boughtcar = false
local vehicle_price = 0

function LocalPed()
    return GetPlayerPed(-1)
end

function msginf(msg, duree)
    duree = duree or 500
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(msg)
    DrawSubtitleTimed(duree, 1)
end

function POLICE_deletevehicle()
	local plyPolice = GetPlayerPed(-1)
	local plyCoordsPolice = GetEntityCoords(plyPolice, 0)
	local distance = GetDistanceBetweenCoords(stationGarage[1].x, stationGarage[1].y, stationGarage[1].z, plyCoordsPolice["x"], plyCoordsPolice["y"], plyCoordsPolice["z"], true)
	if(distance < 30) then
		DrawMarker(1, stationGarage[1].x, stationGarage[1].y, stationGarage[1].z-1, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
	end
	if(distance < 10) then
		local current =  GetPlayersLastVehicle(GetPlayerPed(-1), true)
		SetEntityAsMissionEntity(current, true, true)
		Wait(300)
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(current))
	end
	local plyPolice = GetPlayerPed(-1)
	local plyCoordsPolice = GetEntityCoords(plyPolice, 0)
	local distance2 = GetDistanceBetweenCoords(stationGarage[2].x, stationGarage[2].y, stationGarage[2].z, plyCoordsPolice["x"], plyCoordsPolice["y"], plyCoordsPolice["z"], true)
	if(distance2 < 30) then
		DrawMarker(1, stationGarage[2].x, stationGarage[2].y, stationGarage[2].z-1, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
	end
	if(distance2 < 10) then
		local current =  GetPlayersLastVehicle(GetPlayerPed(-1), true)
		SetEntityAsMissionEntity(current, true, true)
		Wait(300)
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(current))
	end
end

function POLICE_SpanwVehicleCar(data)
    Citizen.Trace('POLICE_SpanwVehicleCar' .. data.model)
    --if fakecar.model ~= data.model then
        if DoesEntityExist(fakecar.car) then
					TriggerServerEvent('ivt:deleteVeh', GetVehicleNumberPlateText(fakecar.car))
            Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
        end
        local ped = LocalPed()
        local plyCoords = GetEntityCoords(ped, 0)
        local hash = GetHashKey(data.model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(0)
        end


		local plyPolice = GetPlayerPed(-1)
		local plyCoordsPolice = GetEntityCoords(plyPolice, 0)
		local distance = GetDistanceBetweenCoords(stationGarage[1].x, stationGarage[1].y, stationGarage[1].z, plyCoordsPolice["x"], plyCoordsPolice["y"], plyCoordsPolice["z"], true)
		if(distance < 30) then
			local pos = policeveh[data.model]
			Citizen.Trace('P' .. pos.x .. '  '.. pos.y .. '  '.. pos.z .. '  '.. pos.h)
	        local veh = CreateVehicle(hash,pos.x,pos.y,pos.z,pos.h,true,true)

					SetModelAsNoLongerNeeded(hash)
					SetEntityVisible(veh, false, 0)
			--		DetachVehicleWindscreen(veh)
					Citizen.Wait(250)
					AttachEntityToEntity(veh, GetVehiclePedIsIn(GetPlayerPed(-1), false), -1, AttachX, AttachY, AttachZ, 0.0, 0.0, 0.0, true, true, true, true, 1, true)
					SetVehicleExplodesOnHighExplosionDamage(veh, false)
					SetEntityVisible(veh, true, 0)
					SetPedIntoVehicle(GetPlayerPed(-1), veh, -1)
					SetVehicleFixed(veh)
					SetVehicleDirtLevel(veh, 0.0)
					SetVehicleLights(veh, 0)
					SetVehicleBurnout(veh, false)
					Citizen.InvokeNative(0x1FD09E7390A74D54, veh, 0)

			local plate = math.random(100, 900)
			if data.model == "xls2" then
				SetVehicleNumberPlateText(veh, "LSPD"..plate.." ")
			elseif data.model == "oracle2" then
				SetVehicleNumberPlateText(veh, "59TDS651")
			elseif data.model == "policefelon" then
				SetVehicleNumberPlateText(veh, "59TDS651")
			else
				SetVehicleNumberPlateText(veh, "LSPD "..plate)
			end

			SetEntityAsMissionEntity(veh, true, true)
			plate = GetVehicleNumberPlateText(veh)
			TriggerServerEvent("ls:refreshid",plate,veh)
			TriggerEvent('lock:addVeh', plate, GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
			TriggerServerEvent("vnt:saveVeh", veh)

			SetVehicleMod(veh,11,3)
			SetVehicleMod(veh,12,2)
			SetVehicleMod(veh,13,2)
			SetVehicleMod(veh,15,3)
			SetVehicleMod(veh,16,2)
			ToggleVehicleMod(veh, 18, true)

			if data.model == "police" or data.model == "police7" then
				SetVehicleEnginePowerMultiplier(veh, 26.01)

			elseif data.model == "police2" or data.model == "police3" then
				SetVehicleEnginePowerMultiplier(veh, 32.01)
			elseif data.model == "police12" or data.model == "oracle2" then
			    SetVehicleEnginePowerMultiplier(veh, 50.01)
			else
				SetVehicleEnginePowerMultiplier(veh, 36.01)
			end

			--if data.model ~= "police3" then
			--	SetVehicleEnginePowerMultiplier(veh, 26.0)
			--end

	        --FreezeEntityPosition(veh,true)
	        --SetEntityInvincible(veh,true)
	        --SetVehicleDoorsLocked(veh,4)
	        --SetEntityCollision(veh,false,false)
	        --TaskWarpPedIntoVehicle(LocalPed(),veh,-1)
	        -- for i = 0,24 do
	        --     SetVehicleModKit(veh,0)
	        --     RemoveVehicleMod(veh,i)
	        -- end
	        fakecar = { model = data.model, car = veh}

		else
			local pos = policeveh2[data.model]
				Citizen.Trace('P' .. pos.x .. '  '.. pos.y .. '  '.. pos.z .. '  '.. pos.h)
        local veh = CreateVehicle(hash,pos.x,pos.y,pos.z,pos.h,true,true)

				SetModelAsNoLongerNeeded(hash)
				SetEntityVisible(veh, false, 0)
			--	DetachVehicleWindscreen(veh)
				Citizen.Wait(250)
				AttachEntityToEntity(veh, GetVehiclePedIsIn(GetPlayerPed(-1), false), -1, AttachX, AttachY, AttachZ, 0.0, 0.0, 0.0, true, true, true, true, 1, true)
				SetVehicleExplodesOnHighExplosionDamage(veh, false)
				SetEntityVisible(veh, true, 0)
				SetPedIntoVehicle(GetPlayerPed(-1), veh, -1)

		local plate = math.random(100, 900)
		if data.model == "xls2" then
			SetVehicleNumberPlateText(veh, "LSPD"..plate.." ")
		elseif data.model == "oracle2" then
			SetVehicleNumberPlateText(veh, "59TDS651")
		elseif data.model == "policefelon" then
			SetVehicleNumberPlateText(veh, "59TDS651")
		else
			SetVehicleNumberPlateText(veh, "LSPD "..plate)
		end

		SetEntityAsMissionEntity(veh, true, true)
		plate = GetVehicleNumberPlateText(veh)
		TriggerServerEvent("ls:refreshid",plate,veh)
		TriggerEvent('lock:addVeh', plate, GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
		TriggerServerEvent("vnt:saveVeh", veh)

		SetVehicleMod(veh,11,3)
		SetVehicleMod(veh,12,2)
		SetVehicleMod(veh,13,2)
		SetVehicleMod(veh,15,3)
		SetVehicleMod(veh,16,2)
		ToggleVehicleMod(veh, 18, true)

		if data.model == "police" or data.model == "police7" then
			SetVehicleEnginePowerMultiplier(veh, 26.01)

		elseif data.model == "police2" or data.model == "police3" then
			SetVehicleEnginePowerMultiplier(veh, 32.01)
		elseif data.model == "police12" or data.model == "oracle2" then
		    SetVehicleEnginePowerMultiplier(veh, 50.01)
		else
			SetVehicleEnginePowerMultiplier(veh, 36.01)
		end

		--if data.model ~= "police3" then
		--	SetVehicleEnginePowerMultiplier(veh, 26.0)
		--end

        --FreezeEntityPosition(veh,true)
        --SetEntityInvincible(veh,true)
        --SetVehicleDoorsLocked(veh,4)
        --SetEntityCollision(veh,false,false)
        --TaskWarpPedIntoVehicle(LocalPed(),veh,-1)
        -- for i = 0,24 do
        --     SetVehicleModKit(veh,0)
        --     RemoveVehicleMod(veh,i)
        -- end
        fakecar = { model = data.model, car = veh}
--    -- end
end

end



RegisterNetEvent('policeveh:spawnVehicle')
AddEventHandler('policeveh:spawnVehicle', function(v)
	-- local car = GetHashKey(v)
	-- local playerPed = GetPlayerPed(-1)
	-- if playerPed and playerPed ~= -1 then
	-- 	RequestModel(car)
	-- 	while not HasModelLoaded(car) do
	-- 			Citizen.Wait(0)
	-- 	end
	-- 	local playerCoords = GetEntityCoords(playerPed)

	-- 	veh = CreateVehicle(car, playerCoords, 0.0, true, false)
	-- 	TaskWarpPedIntoVehicle(playerPed, veh, -1)
	-- 	SetEntityInvincible(veh, false)
	-- end
end)
