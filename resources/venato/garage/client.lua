local Vehicule = {}
local resend = false

local garage = {
    {name = "Garage Central", xpoint = 256.2339,  ypoint = -780.7506,  zpoint = 29.58, xspawn = 258.3808,  yspawn = -773.3583,  zspawn = 29.682, hspawn = 110.7102, hidden = false },
    {name= 'Paleto Bay', xpoint = 141.5353, ypoint= 6623.5771, zpoint= 30.7387, xspawn = 139.1196, yspawn= 6634.199, zspawn= 30.648, hspawn =  225.00, hidden = false}, -- Paleto Bay
    {name= 'Marina residentiel', xpoint = -932.6918, ypoint= -1286.6127, z= 4.0308,  xspawn = -927.4479, yspawn= -1283.5045, zspawn= 4.0311, hspawn = 116.6553, hidden = false}, -- Marina residentiel
    {name= 'Freeway west', xpoint = -2001.1632, ypoint= -324.7654, zpoint= 43.1060,  xspawn = -2006.4946, yspawn= -332.5044, zspawn=  43.1060, hspawn = 324.975, hidden = false}, -- Freeway west
    {name= 'Station 8/29 sandyshore', xpoint = 1680.2213, ypoint= 4925.0166 , zpoint= 41.0691,  xspawn = 1689.1406, yspawn= 4917.423, zspawn=  41.078, hspawn =  54.607, hidden = false}, -- Station 8/29 sandyshore
    {name= 'Hopital civil', xpoint = -510.7496, ypoint= -295.598, zpoint= 34.363,  xspawn = -515.542, yspawn= -295.366, zspawn= 34.232, hspawn =  25.170, hidden = false}, -- Hopital civil
	  {name= 'LSPD', xpoint = 452.5627, ypoint= -1003.1785, zpoint= 25.3385,  xspawn = 452.3333, yspawn= -997.8351, zspawn= 25.16, hspawn =  179.9459, hidden = false}, -- LSPD
    {name= 'Barrio', xpoint = 322.463, ypoint= -2088.338, zpoint= 16.784,  xspawn = 317.965, yspawn= -2085.858, zspawn= 16.698, hspawn =  91.505, hidden = true}, -- Barrio
    {name= 'Fouiny', xpoint = -620.147, ypoint= 50.450, zpoint= 43.736,  xspawn = -618.147, yspawn= 53.812, zspawn= 43.736, hspawn =  73.997, hidden = true}, -- Fouiny
    {name= 'Shadow', xpoint = -127.283, ypoint= 1006.848, zpoint= 234.732,  xspawn = -122.833, yspawn= 1004.402, zspawn= 234.732, hspawn =  197.644, hidden = true}, -- Shadow
    {name= 'Affranchis', xpoint = -1578.350, ypoint= -259.031, zpoint= 47.295,  xspawn = -1574.198, yspawn= -260.903, zspawn= 47.268, hspawn =  174.243, hidden = true}, -- Affranchis
    {name= 'Dodgers', xpoint = 1374.890, ypoint= -1520.119, zpoint= 57.376,  xspawn = 1373.639, yspawn= -1523.067, zspawn= 56.022, hspawn =  201.380, hidden = true}, -- Dodgers
    {name= 'Maître Johnson', xpoint = -2670.29, ypoint= 1309.7, zpoint= 147.11,  xspawn = -2670.29, yspawn= 1309.7, zspawn= 147.11, hspawn =  262.398, hidden = true}, -- villa
    {name= 'Hangar a avion perso', xpoint = 1705.92, ypoint= 3251.25, zpoint= 40.01,  xspawn = 1705.92, yspawn= 3251.25, zspawn= 40.01, hspawn =  105.1460, hidden = true}, -- ta
    {name= 'GarageDebug', xpoint = -63.96244430542, ypoint = -1088.9659423828, zpoint = 26.723899841309, xspawn = -63.96244430542, yspawn = -1088.9659423828, zspawn = 26.723899841309, hspawn =  105.1460, hidden = false}, -- ta
}


local defaultNotification = {
  name = "Garage",
  type = "alert",
  logo = "https://i.ibb.co/dpsQ3B9/icons8-parking-96px.png"
}


function setMapMarker()
    for k,v in ipairs(garage)do
      if v.hidden == false then
        local blip = AddBlipForCoord(v.xpoint, v.ypoint, v.zpoint)
        SetBlipSprite(blip, 50)
        SetBlipColour(blip, 3)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Garage")
        EndTextCommandSetBlipName(blip)
      end
    end
end

AddEventHandler('onClientMapStart', function()
    TriggerServerEvent('garages:storeallvehicles')
end)

Citizen.CreateThread(function()
setMapMarker()
  while true do
      Citizen.Wait(0)
      local ply = GetPlayerPed(-1)
      local plyCoords = GetEntityCoords(ply, 0)
      for _, item in pairs(garage) do
        local distance = GetDistanceBetweenCoords(item.xpoint, item.ypoint, item.zpoint,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
        if distance < 50 then
          DrawMarker(27,item.xpoint, item.ypoint, item.zpoint,0,0,0,0,0,0,1.9,1.9,1.9,0,150,255,200,0,0,0,0)
          if distance <= 2 then
            defaultNotification.title = item.name
            Venato.InteractTxt("Appuyez sur la touche ~INPUT_CONTEXT~ pour ouvrir le garage.")
            if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then -- press action contextuel (e) pour joueur clavier uniquement
              openGarage(item.name, item.xspawn, item.yspawn, item.zspawn, item.hspawn)
            end
            if resend then
              openGarage(item.name, item.xspawn, item.yspawn, item.zspawn, item.hspawn)
              resend = false
            end
          end
        end
      end
  end
end)


function backToOpenGarage()
  resend = true
end

function openGarage(name, x, y, z, h)
  local garage = {name= name, x= x, y= y, z= z, h= h}
  TriggerServerEvent("Garage:GetAllVehicle", garage)
end

function close()
  Menu.close()
end

function none()
  print("nothing")
end

function getCars(garage)
  TriggerServerEvent("Garage:CallAllCar", garage)
end


function MyCar(table)
  local ads = false
  Menu.setTitle( "Garage")
  Menu.setSubtitle( "~b~Mes Véhicules")
  Menu.clearMenu()
  if Vehicule ~= nil then
  for a, v in pairs(Vehicule) do
    if v.type == 1 then
      if v.state == 2 then
        ads = true
        Menu.addButton("~r~[Fourière] "..v.name.." ~s~| ~o~" ..v.plate , "none", nil)
      elseif v.state == 1 then
        ads = true
        Menu.addButton("~o~[Sortie] "..v.name.." ~s~| ~o~" ..v.plate , "none", nil)
      else
        ads = true
        Menu.addButton("~g~"..v.name.." ~s~| ~o~" ..v.plate , "SortirVoiture", {type=v.type,model=v.model,name=v.name,plate=v.plate,customs=v.customs,Health=v.Health, x=table.x, y=table.y, z=table.z, h=table.h})
      end
    end
  end
  end
  if not ads then
    Menu.addButton("~r~Aucun vehicule dans ce garage" , "none", nil)
  end
  Menu.addButton("~r~Fermer", "backToOpenGarage", nil)
end

function StoreMyCar(garage)
  local current = GetPlayersLastVehicle(GetPlayerPed(-1), true)
  if DoesEntityExist(current) then
    local distance = GetDistanceBetweenCoords(GetEntityCoords(current), garage.x,garage.y,garage.z, true)
    local engineHealth = GetVehicleEngineHealth(current)
  	local vehicleHealth = GetEntityHealth(current)
    local model = GetEntityModel(current)
    local plate = GetVehicleNumberPlateText(current)
    local mind = false
    if distance < 20 then
      for a, v in pairs(Vehicule) do
        if v.plate == plate then
          mind = true
        end
      end
      if mind and  model ~= nil then
        TriggerServerEvent("Garage:RangeVoiture", plate,model,engineHealth,vehicleHealth,garage.name,current)        
        return
      end
    end
  end
  defaultNotification.message = "Vous ne pouvez stocker que vos véhicules !"
  defaultNotification.type = "error"
  Venato.notify(defaultNotification)
end


function SortirVoiture(vhl)
  Menu.close()
  local customs = json.decode(tostring(vhl.customs))
  local health = json.decode(tostring(vhl.Health))
  Wait(300)
  local CarOnPoint = GetClosestVehicle(vhl.x,vhl.y,vhl.z, 5.000, 0, 70)
  if not DoesEntityExist(CarOnPoint) then
    local car = tonumber(vhl.model)
    RequestModel(car)
    while not HasModelLoaded(car) do
      Citizen.Wait(0)
    end
    local veh = CreateVehicle(car, vhl.x,vhl.y,vhl.z, 0.0, true, true)
    if health ~= nil then
      if (health[1] ~= nil and health[1] > 0 and health[1] < 1000) or health[2] ~= nil then
        --print(health[1]..' ezfzsfdvsd')
    		SetVehicleEngineHealth(veh, tonumber(health[1]))
    	end
    end
    SetVehicleExplodesOnHighExplosionDamage(veh, false)
  	SetEntityHeading(veh, vhl.h)
    SetVehicleNumberPlateText(veh, vhl.plate)
    TriggerEvent('lock:addVeh', vhl.plate, vhl.name)
    TriggerServerEvent("Garage:SortiVehicule", vhl.plate, vhl.model)
    SetVehicleOnGroundProperly(veh)
    SetVehicleHasBeenOwnedByPlayer(veh,true)
    SetEntityAsMissionEntity(veh, true, true)
    local id = NetworkGetNetworkIdFromEntity(veh)
    SetNetworkIdCanMigrate(id, true) -- Si un autre joueur est autorisé ou non à prendre le contrôle de l'entité (?)
    SetPedIntoVehicle(GetPlayerPed(-1), veh, -1)
    SetVehicleModKit(veh, 0 )
    SetVehicleColours(veh,customs.color.primary,customs.color.secondary)
    ToggleVehicleMod(veh, 18, false)
    for i = 0, 49 do
      if i ~= 11 and i ~= 12 and i ~= 13 and i ~= 15 and i ~= 18 then
        SetVehicleMod(veh, i, -1, false)
      else
        SetVehicleMod(veh, i, 0, false)
      end
      if customs.mods[""..i..""] ~= nil then
        SetVehicleMod(veh, i, customs.mods[""..i..""], false)
        if i == 11 then
          --SetVehicleEnginePowerMultiplier(veh, GetVehicleModModifierValue(veh, i, customs.mods[""..i..""])/5 + 0.1)
        end
      end
      if i == 18 and customs.mods[""..i..""] == false then
  	    ToggleVehicleMod(veh, 18, false)
      elseif i == 18 and customs.mods[""..i..""] == 1 then
  	    ToggleVehicleMod(veh, 18, true)
      end
    end
    SetVehicleMod(veh, 15, customs.mods["15"], false)
    if vhl.type == 1 then
      if customs.neons.enabled then
        SetVehicleNeonLightEnabled(veh, 0, customs.neons.enabled)
        SetVehicleNeonLightEnabled(veh, 1, customs.neons.enabled)
        SetVehicleNeonLightEnabled(veh, 2, customs.neons.enabled)
        SetVehicleNeonLightEnabled(veh, 3, customs.neons.enabled)
        SetVehicleNeonLightsColour(veh, customs.neons.red, customs.neons.green, customs.neons.blue)
      end
      SetVehicleWindowTint(veh, customs.windows)
      SetVehicleWheelType(veh, tonumber(customs.wheels.type))
      SetVehicleMod(veh, 23, tonumber(customs.wheels.choice), false)
      SetVehicleMod(veh, 24, tonumber(customs.wheels.choice), false)
      if  customs.tyreburst.enabled then
        ToggleVehicleMod(veh, 20, true)
        SetVehicleTyreSmokeColor(veh, customs.tyreburst.red, customs.tyreburst.green, customs.tyreburst.blue)
      end
  	  if customs.xenons == 1 then
  		  ToggleVehicleMod(veh, 22, true)
  	  else
  	    ToggleVehicleMod(veh, 22, false)
      end
  	  if customs.horn ~= nil then
  	    SetVehicleMod(veh, 14, customs.horn)
  	  end
    end
    SetVehicleDirtLevel(veh)
    Citizen.Wait(100)
    local debugvar = false
    local var87 = 10000
    local VehClassModel = GetVehicleClass(veh)
    local entitymdl = GetEntityModel(veh)
    local Model = GetDisplayNameFromVehicleModel(entitymdl)

    if debugvar == true then msginf("NEW CATEGORIE : " .. VehClassModel .. " " .. Model .. " Entity mdl : " .. entitymdl,10000) end
    for k, v in pairs(listedcar) do
      if not IsVehicleModel(veh, v) then
        table.insert(listedcar, entitymdl)
      end
    end

    for k, v in pairs(listedcar) do
      if IsVehicleModel(veh, v) then
        for j, l in pairs(classmdl) do
          local GetClassModel = GetVehicleClass(veh)
          local Model = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
          ResultatClassmodel = j
          if GetVehicleClass(veh) == j then
            resultatcalcul = GetVehicleModModifierValue(veh, 11, GetVehicleMod(veh,11))/l.Multiplicateur + 0.1
            SetVehicleEnginePowerMultiplier(veh, resultatcalcul)
            globalclassmodelforblacklist = l.classmodel
            blacklistedmultip = l.BlacklistedMultiplicateur
            if debugvar == true then msginf("CATEGORIE : " .. l.classmodel .. " " .. Model .. " V : " .. l.Multiplicateur .. " result : " .. resultatcalcul .. " Vehicule n°: " .. k ,10000) end
            if k == 1080 and debugvar == true then msginf("Voiture non CATEGORISÉ : " .. l.classmodel .. " " .. Model .. " V : " .. l.Multiplicateur .. " Multipl : " .. resultatcalcul .. " Vehicule n°: " .. k ,10000) end -- end  debugvar == true
            break
          else
            if debugvar == true then msginf("BUG: " .. GetClassModel .. " V : " .. v .. " J : " .. ResultatClassmodel .. " l : " .. l.classmodel ,10000) end
          end
        end
      end
    end

    for k2, v2 in pairs(blacklistedmodel) do
      if IsVehicleModel(veh, v2) then
        --Voiture buggé reelement au cas par cas:
        if IsVehicleModel(veh, blacklistedmodel[6]) then -- PFISTER811
          resultatcalcul = GetVehicleModModifierValue(veh, 11, GetVehicleMod(veh,11))/8.5 + 0.1
          SetVehicleEnginePowerMultiplier(veh, resultatcalcul)
        elseif IsVehicleModel(veh, blacklistedmodel[2]) then -- SCHAFTERV12
          resultatcalcul = GetVehicleModModifierValue(veh, 11, GetVehicleMod(veh,11))/13.5 + 0.1
          SetVehicleEnginePowerMultiplier(veh, resultatcalcul)
        elseif IsVehicleModel(veh, blacklistedmodel[10]) then -- SLAMVAN3
          resultatcalcul = GetVehicleModModifierValue(veh, 11, GetVehicleMod(veh,11))/23.5 + 0.1 -- 22.5 = 250 km/h |  23.5 = 180 km/h ...
          SetVehicleEnginePowerMultiplier(veh, resultatcalcul)
        elseif IsVehicleModel(veh, blacklistedmodel[11]) then -- BANSHEE2
          resultatcalcul = GetVehicleModModifierValue(veh, 11, GetVehicleMod(veh,11))/2.5 + 0.01
          SetVehicleEnginePowerMultiplier(veh, resultatcalcul)
        else
          SetVehicleEnginePowerMultiplier(veh, GetVehicleModModifierValue(veh, 11, GetVehicleMod(veh,11))/blacklistedmultip + 0.1)
          resultatcalcul = math.ceil((GetVehicleMod(veh,11)/blacklistedmultip + 0.1)*var87)/var87
        end
        if debugvar == true then msginf("~r~NERF CATEGORIE : ~w~" .. globalclassmodelforblacklist .. " ~r~Diviser : " .. blacklistedmultip .. " Multiplicateur : " .. resultatcalcul,10000) end
        break
      end
    end
  else
    defaultNotification.message = "Véhicule dans la zone"
    defaultNotification.type = "error"
    Venato.notify(defaultNotification)
  end
end

RegisterNetEvent("Garage:AllVehicleBack")
AddEventHandler("Garage:AllVehicleBack", function(garage)
  Vehicule = garage.vehicles
  MyCar(garage)
end)

RegisterNetEvent("Garage:AllVehicle")
AddEventHandler("Garage:AllVehicle", function(garage)
  Vehicule = garage.vehicles
  Menu.setTitle( "Garage")
  Menu.setSubtitle( "~b~Option")
  Menu.clearMenu()
  Menu.addButton("~g~Mes vehicules", "getCars", garage)
  Menu.addButton("~o~Rentrer son véhicule", "StoreMyCar", garage)
  Menu.addButton("~r~Fermer", "close", nil)
  Menu.open()
end)

RegisterNetEvent("Garage:deleteVoiture")
AddEventHandler("Garage:deleteVoiture", function(vehicle, plate)
  if IsPedInAnyVehicle( GetPlayerPed(-1), false ) then
    TaskLeaveVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 262144)  
    Citizen.Wait(2500)  
  end
  if GetEntityModel(vehicle) ~= nil then
    TriggerServerEvent("ivt:deleteVeh",GetVehicleNumberPlateText(vehicle))
    
    SetEntityAsMissionEntity( vehicle, true, true )
    DeleteVehicle(vehicle)
    DeleteEntity(vehicle)
  else
    local current = GetPlayersLastVehicle(GetPlayerPed(-1), true)
    TriggerServerEvent("ivt:deleteVeh",GetVehicleNumberPlateText(current))
    
    SetEntityAsMissionEntity( current, true, true )
    DeleteVehicle(current)
    DeleteEntity(current)
  end
  Menu.close()
  defaultNotification.message = "Véhicule rangé"
  defaultNotification.type = "alert"
  Venato.notify(defaultNotification)
end)

function GetBlacklistedList()
	return blacklistedmodel
end

function GetBalancedList()
	return listedcar
end

function GetBalancedCatList()
	return classmdl
end

RegisterNetEvent("maskshop:notifs")
AddEventHandler("maskshop:notifs", function(msg)    
  defaultNotification.message = msg
  defaultNotification.type = "alert"
  Venato.notify(defaultNotification)
end)

TriggerServerEvent('VnT:ActuLibrarie')
