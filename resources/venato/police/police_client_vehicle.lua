local policeveh = {
	opened = false,
	title = "Cop Garage",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 }, -- ???
	
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
	xls2 = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	oracle = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	buzzard2 ={ x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	polaventa = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	polf430 = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	polchiron = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
}


local stationGarage = {
	{x=452.115966796875, y=-1018.10681152344, z=28.4786586761475},
	{x=1867.1923, y=3691.2719, z=33.7599},
}

local fakecar = {model = '', car = nil}
local boughtcar = false
local vehicle_price = 0

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
    	
		local hash = GetHashKey(data.model)
		RequestModel(hash)		
        while not HasModelLoaded(hash) do
            Citizen.Wait(0)
		end
		
		local plyPolice = GetPlayerPed(-1)
		local plyCoordsPolice = GetEntityCoords(plyPolice, 0)
		local distance = GetDistanceBetweenCoords(stationGarage[1].x, stationGarage[1].y, stationGarage[1].z, plyCoordsPolice["x"], plyCoordsPolice["y"], plyCoordsPolice["z"], true)
		
		local pos = distance < 30 and policeveh[data.model] or plyCoordsPolice
		Venato.CreateVehicle(hash, {x=pos.x,y=pos.y,z=pos.z}, pos.h, function(veh)
		
		SetModelAsNoLongerNeeded(hash)
		
		SetVehicleDirtLevel(veh, 0.0)		
		SetVehicleLightsMode(veh, 0)	
		SetVehicleOnGroundProperly(veh)	

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

		fakecar = { model = data.model, car = veh}	
		
        SetPedIntoVehicle(Venato.GetPlayerPed(), veh, -1)
		TriggerEvent('Menu:Close')
	end)
end
