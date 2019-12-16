-- Debug printer
function dprint(msg)
	if debugMode then
		print(msg)
	end
end

-- Spawn the vehicle with the given properties.
function spawnVehicle(model, xcoord, ycoord, zcoord, heading, plate, health, customsJson)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(0)
  end

  local vehicle = platypus.CreateVehicle(model, {x = xcoord, y = ycoord, z = zcoord}, heading, function(vhl)
    
    SetVehicleNumberPlateText(vhl, plate)  
    if health ~= nil then
      SetVehicleEngineHealth(vhl, health[1])
      SetEntityHealth(vhl, health[2])
      GetVehicleDirtLevel(vhl, health[3])
      GetVehicleFuelLevel(vhl, health[4])
      
      local doors = health[5]
      for i=0, 9 do  
        if(doors[i] == 1) then
          print('coucou')
          SetVehicleDoorBroken(vhl, i)   
        end   
      end 

      local window = health[6]
      for i=0, 9 do  
        if window[i] == false then
          SmashVehicleWindow(vhl, i) 
        end     
      end 

      local tyre = health[7]
      for i=0, 9 do    
        if tyre[i] == 1 then
          SetVehicleTyreBurst(vhl, i, true, 0.0)   
        end   
      end  

      local wheel = health[8]
      for i, p in pairs(wheel) do
        SetVehicleWheelHealth(vhl, i, wheel[i])
      end

    end
    SetVehicleOnGroundProperly(vhl)
    SetVehicleModKit(vhl, 0 )  
    print(customsJson) 
    if(customsJson) then
      local customs = json.decode(tostring(customsJson))
      
      SetVehicleModColor_1(vhl, customs.color.primary.type, 0,0)
      SetVehicleCustomPrimaryColour(vhl, customs.color.primary.red,  customs.color.primary.green,  customs.color.primary.blue)
      SetVehicleModColor_2(vhl, customs.color.secondary.type, 0,0)
      SetVehicleCustomSecondaryColour(vhl, customs.color.secondary.red,  customs.color.secondary.green,  customs.color.secondary.blue)
      SetVehicleExtraColours(vhl, customs.color.pearlescent, customs.wheels.color)
      for i = 0, 49 do
          if i ~= 11 and i ~= 12 and i ~= 13 and i ~= 15 and i ~= 18 then
              SetVehicleMod(vhl, i, -1, false)
          else
              SetVehicleMod(vhl, i, 0, false)
          end
      if i == 18 and customs.mods[""..i..""] == false then
        ToggleVehicleMod(vhl, 18, false)
      elseif i == 18 and customs.mods[""..i..""] == 1 then
        ToggleVehicleMod(vhl, 18, true)
      end
          if customs.mods[""..i..""] ~= nil then
              SetVehicleMod(vhl, i, customs.mods[""..i..""], false)
              if i == 11 then
                  --SetVehicleEnginePowerMultiplier(vhl, GetVehicleModModifierValue(vhl, i, customs.mods[""..i..""])/5 + 0.1)
              end
          end
      end
      SetVehicleMod(vhl, 15, customs.mods["15"], false)
      if customs ~= nil then
      --if vhl.type == 1 then
        -- Set neons
        if customs.neons.enabled then
            ToggleVehicleMod(vhl, 22, false)
            SetVehicleNeonLightEnabled(vhl, 0, customs.neons.enabled)
            SetVehicleNeonLightEnabled(vhl, 1, customs.neons.enabled)
            SetVehicleNeonLightEnabled(vhl, 2, customs.neons.enabled)
            SetVehicleNeonLightEnabled(vhl, 3, customs.neons.enabled)
            SetVehicleNeonLightsColour(vhl, customs.neons.red, customs.neons.green, customs.neons.blue)
        end
        -- Set windows
        SetVehicleWindowTint(vhl, customs.windows)
        -- Set Jantes
        SetVehicleWheelType(vhl, tonumber(customs.wheels.type))
        SetVehicleMod(vhl, 23, tonumber(customs.wheels.choice), false)
        SetVehicleMod(vhl, 24, tonumber(customs.wheels.choice), false)
        -- Set Tyreburst
        if customs.tyreburst.enabled then
            ToggleVehicleMod(vhl, 20, true)
            SetVehicleTyreSmokeColor(vhl, customs.tyreburst.red, customs.tyreburst.green, customs.tyreburst.blue)
        end
        if customs.xenons == 1 then
          ToggleVehicleMod(vhl, 22, true)
        else
          ToggleVehicleMod(vhl, 22, false)
        end
        if customs.horn ~= nil then
          SetVehicleMod(vhl, 14, customs.horn)
        end
      end
    end
  end) 

  return vehicle				
end

RegisterNetEvent('sd:save')
AddEventHandler('sd:save', function(vehicle)
	local model = GetEntityModel(vehicle)
	local x,y,z = table.unpack(GetEntityCoords(vehicle))
	local heading = GetEntityHeading(vehicle)
	local plate = GetVehicleNumberPlateText(vehicle);

	local engineHealth = GetVehicleEngineHealth(vehicle)
  	local vehicleHealth = GetEntityHealth(vehicle)
    local dirtLevel = GetVehicleDirtLevel(vehicle)
    local fuelLevel = GetVehicleFuelLevel(vehicle)

    local tireBurst = {}
    for i=0, 6 do
      tireBurst[i] = IsVehicleTyreBurst(vehicle, i, true)
    end

    local doorBroken = {}
    for i=0, 6 do
      doorBroken[i] = IsVehicleDoorDamaged(vehicle, i)
    end

    local windowsIntact = {}
    for i=0, 7 do
      RollUpWindow(car,i) 
      windowsIntact[i] = IsVehicleWindowIntact(vehicle, i)
    end

    local wheelHealth = {}    
    for i=0, 6 do
      wheelHealth[i] = GetVehicleWheelHealth(vehicle, i)
    end
    local health = {
      engineHealth,
      vehicleHealth,
      dirtLevel,
      fuelLevel,
      doorBroken,
      windowsIntact,
      tireBurst,
      wheelHealth
	}
	TriggerServerEvent('sd:save', NetworkGetNetworkIdFromEntity(vehicle), model, x, y, z, heading, plate, health)
end)

-- Trigger vehicle save (set interval in config)
Citizen.CreateThread(function()
	ped = PlayerPedId()
	local vehicle = 0
	local inVeh = false
	while true do
    if IsPedInAnyVehicle(ped) then    
      vehicle = GetVehiclePedIsUsing(ped)
			TriggerEvent('sd:save', vehicle)
      SetVehicleHasBeenOwnedByPlayer(vehicle, true)	
		end
    Citizen.Wait(intervals.save*1000)
	end
end)

-- Check which saved ids don't match with the corresponding models to detect despawned vehicles.
RegisterNetEvent('sd:checkVehs')
AddEventHandler('sd:checkVehs', function(table)  
	local results = {
		['restored'] = 0,
		['total'] = 0
	}
  for i=1,#table,1 do
    local CarOnPoint = GetClosestVehicle(table[i].position.x,table[i].position.y,table[i].position.z, 3.000, 0, 70)
    local plate = GetVehicleNumberPlateText(CarOnPoint)   
    local entity = NetworkGetEntityFromNetworkId(table[i].id)
    local entityPlate = GetVehicleNumberPlateText(entity)       
    if entity == nil or entityPlate ~= table[i].plate then
      if entity ~= nil then
        DeleteEntity(entity)
      end
      if CarOnPoint ~= nil then
        DeleteEntity(CarOnPoint)
      end
      local newVehicle = spawnVehicle(table[i].model, table[i].position.x, table[i].position.y, table[i].position.z, table[i].heading, table[i].plate, table[i].health, table[i].customs)
      TriggerServerEvent('sd:updateId', table[i].id, NetworkGetNetworkIdFromEntity(newVehicle))
			results.restored = results.restored + 1
			Citizen.Wait(100)
		end
		results.total = results.total + 1
	end
	dprint(results.restored .. '/' .. results.total .. ' vehicles have been restored!')
end)

if saveOnEnter then
	Citizen.CreateThread(function()
    local inVehicle = false
    local vehicleId = -1
		while true do
      if IsPedInAnyVehicle(ped) then
        vehicleId = GetVehiclePedIsUsing(ped)
				if not inVehicle then
					TriggerEvent('sd:save', vehicleId)
				end
				inVehicle = true
      else
        if inVehicle then
          TriggerEvent('sd:save', vehicleId)
        end
        vehicleId = -1
				inVehicle = false
			end
			Citizen.Wait(500)
		end
	end)
end

-- Trigger despawn check (set interval in config).
Citizen.CreateThread(function()
		TriggerServerEvent('sd:retrieveTable')
		Citizen.Wait(intervals.check*1000)
	end)