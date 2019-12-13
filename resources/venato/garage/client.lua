local Vehicule = {}
local resend = false

local garage = {
    {name = "Garage Central", xpoint = 266.035,  ypoint = -755.52,  zpoint = 30.821, xspawn = 268.772,  yspawn = -750.705,  zspawn = 30.421, hspawn = 70.818, hidden = false },
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
    {name= 'Garage Families', xpoint = -56.229, ypoint= -1492.541, zpoint= 31.753,  xspawn = -56.229, yspawn= -1492.541, zspawn= 31.753, hspawn =  142.52, hidden = true}, -- ta
    {name= 'Garage LOST', xpoint = 975.649, ypoint= -136.506, zpoint= 74.149,  xspawn = 985.135, yspawn= -137.91, zspawn= 73.091, hspawn =  44.362, hidden = true}, -- ta
    {name= 'Garage Fourriere', xpoint = 419.591, ypoint= -1637.319, zpoint= 28.292,  xspawn = 419.591, yspawn= -1637.319, zspawn= 29.292, hspawn =  40.905, hidden = true}, -- ta
    {name= 'Garage Vizards', xpoint = -562.725, ypoint= -979.856, zpoint= 22.178,  xspawn = -562.725, yspawn= -979.856, zspawn= 22.178, hspawn =  130.362, hidden = true}, -- ta
    {name= 'St Fiacre Hospital', xpoint = 1122.367, ypoint= -1521.092, zpoint= 34.838,  xspawn = 1117.395, yspawn= -1514.753, zspawn= 34.693, hspawn =  285.574, hidden = false}, -- ta
    {name= 'Palace intérieur', xpoint = -1626.859, ypoint= -3006.08, zpoint= -78.541,  xspawn = -1640.226, yspawn= -2998.951, zspawn= -78.54, hspawn =  178.259, hidden = true}, -- ta
    {name= 'Palace', xpoint = 777.44, ypoint= -1319.376, zpoint= 25.828,  xspawn = 771.832, yspawn= -1322.875, zspawn= 25.835, hspawn =  181.487, hidden = false}, -- ta
    {name= 'Unicorn', xpoint = 145.758, ypoint= -1330.2, zpoint= 28.526,  xspawn = 137.797, yspawn= -1322.597, zspawn= 28.527, hspawn =  51.565, hidden = false}, -- ta
    {name= 'Car dealer', xpoint = -47.84, ypoint= -1115.91, zpoint= 26.43,  xspawn = -41.46, yspawn= -1112.17, zspawn= 26.44, hspawn =  69.499, hidden = false}, -- ta
    {name= 'SkatePark', xpoint = -1736.347, ypoint= -732.935, zpoint= 10.019,  xspawn = -1742.893, yspawn= -724.596, zspawn= 10.039, hspawn = 229.932, hidden = true}, -- ta
    {name= 'Garage Vagos', xpoint = 218.023, ypoint= -1990.77, zpoint= 19.696,  xspawn = 226.109, yspawn= -1984.81, zspawn= 19.717, hspawn = 231.822, hidden = true}, -- ta
  --  {name= 'GarageDebug', xpoint = -63.96244430542, ypoint = -1088.9659423828, zpoint = 26.723899841309, xspawn = -63.96244430542, yspawn = -1088.9659423828, zspawn = 26.723899841309, hspawn =  105.1460, hidden = false}, -- ta
}


local defaultNotification = {
  title = "Garage",
  type = "alert",
  logo = "https://i.ibb.co/wpxH8B1/icons8-parking-96px.png"
}


function setMapMarker()
    for k,v in ipairs(garage)do
      if v.hidden == false then
        local blip = AddBlipForCoord(v.xpoint, v.ypoint, v.zpoint)
        SetBlipSprite(blip, 50)
        SetBlipColour(blip, 1)
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


local loopData = {}
Citizen.CreateThread(function()
  setMapMarker()
  while true do
    Citizen.Wait(0)
    local ply = Venato.GetPlayerPed()
    local plyCoords = GetEntityCoords(ply, 0)
    local testDistance = 999999
    local testLoopData = {}
    for _, item in pairs(garage) do
      Citizen.Wait(100)
      local distance = GetDistanceBetweenCoords(item.xpoint, item.ypoint, item.zpoint,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
      if loopData.item ~= nil then
        if item.name == loopData.item.name then
          testLoopData = { distance = distance, item = item }
        end
      end
      if distance < testDistance then
        testDistance = distance
        testLoopData = { distance = distance, item = item }
      end
    end
    loopData = testLoopData
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if loopData.distance ~= nil then
      if loopData.distance < 50 then
        DrawMarker(27,loopData.item.xpoint, loopData.item.ypoint, loopData.item.zpoint+0.1,0,0,0,0,1,0,1.9,1.9,1.9,0,150,255,200,0,true,0,0)
        if loopData.distance <= 2 then
          defaultNotification.title = loopData.item.name
          Venato.InteractTxt("Appuyez sur la touche ~INPUT_CONTEXT~ pour ouvrir le garage.")
          if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then -- press action contextuel (e) pour joueur clavier uniquement
            openGarage(loopData.item.name, loopData.item.xspawn, loopData.item.yspawn, loopData.item.zspawn, loopData.item.hspawn)
          end
          if resend then
            openGarage(loopData.item.name, loopData.item.xspawn, loopData.item.yspawn, loopData.item.zspawn, loopData.item.hspawn)
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

function getCars(garage)
  Menu.close()
  TriggerServerEvent("Garage:CallAllCar", garage)
end


function MyCar(table)
  local ads = false
  Menu.setTitle( "Garage")
  Menu.setSubtitle( "Mes Véhicules")
  Menu.clearMenu()
  TriggerEvent('Menu:AddButton2',"<span class='red--text'>Retour</span>", "backToOpenGarage", "", "", "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
  if Vehicule ~= nil then
  for a, v in pairs(Vehicule) do
    if v.type == 1 then
      if v.state == 2 then
        ads = true
        TriggerEvent('Menu:AddShopButton', v.name, "none", "", "https://i.ibb.co/fp5bXcK/icons8-garage-96px.png", v.plate..' <span class="red--text"><small>Fourrière</small></span>', nil)
        --Menu.addButton("<span class='red--text'>Fourière |</span> "..v.name.." | <span class='orange--text'>" ..v.plate.."</span>" , "none", nil)
      elseif v.state == 1 then
        ads = true
        TriggerEvent('Menu:AddShopButton', v.name, "none", "", "https://i.ibb.co/2j4253Z/icons8-garage-open-96px.png", v.plate..' <span class="orange--text"><small>Sortie</small></span>', nil)
        --Menu.addButton("<span class='orange--text'>Sortie |</span> "..v.name.."</span> | <span class='orange--text'>" ..v.plate.."</span>" , "none", nil)
      else
        ads = true
        TriggerEvent('Menu:AddShopButton', v.name, "SortirVoiture", {type=v.type,model=v.model,name=v.name,plate=v.plate,customs=v.customs,Health=v.Health, x=table.x, y=table.y, z=table.z, h=table.h}, "https://i.ibb.co/fx5r19K/icons8-sedan-96px.png", v.plate, nil)
        --Menu.addButton("<span class='green--text'>"..v.name.."</span> | <span class='orange--text'>" ..v.plate.."</span>" , "SortirVoiture", {type=v.type,model=v.model,name=v.name,plate=v.plate,customs=v.customs,Health=v.Health, x=table.x, y=table.y, z=table.z, h=table.h})
      end
    end
  end
  end
  if not ads then
    TriggerEvent('Menu:AddButton2',"<span class='red--text'>Aucun vehicule dans ce garage</span>", "" , "none", nil)
  end
  TriggerEvent('Menu:AddButton2',"<span class='red--text'>Retour</span>", "backToOpenGarage", "", "", "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
  TriggerEvent('Menu:CreateMenu')
  Menu.open()
end

function StoreMyCar(garage)
  local current = GetPlayersLastVehicle(Venato.GetPlayerPed(), true)
  if DoesEntityExist(current) then
    local distance = GetDistanceBetweenCoords(GetEntityCoords(current), garage.x,garage.y,garage.z, true)
    local model = GetEntityModel(current)
    local plate = GetVehicleNumberPlateText(current)

    local engineHealth = GetVehicleEngineHealth(current)
  	local vehicleHealth = GetEntityHealth(current)
    local dirtLevel = GetVehicleDirtLevel(current)
    local fuelLevel = GetVehicleFuelLevel(current)

    local tireBurst = {}
    for i=0, 6 do
      tireBurst[i] = IsVehicleTyreBurst(current, i, true)
    end

    local doorBroken = {}
    for i=0, 6 do
      doorBroken[i] = IsVehicleDoorDamaged(current, i)
    end

    local windowsIntact = {}
    for i=0, 7 do
      RollUpWindow(car,i)
      windowsIntact[i] = IsVehicleWindowIntact(current, i)
    end

    local wheelHealth = {}
    for i=0, 6 do
      wheelHealth[i] = GetVehicleWheelHealth(current, i)
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

    local mind = false
    if distance < 20 then
      for a, v in pairs(Vehicule) do
        if v.plate == plate then
          mind = true
        end
      end
      if mind and  model ~= nil then
        TriggerServerEvent("Garage:RangeVoiture", plate,model,garage.name,current, health)
        return
      end
    end
  end
  defaultNotification.message = "Vous ne pouvez stocker que vos véhicules !"
  defaultNotification.type = "error"
  Venato.notify(defaultNotification)
end


function SortirVoiture(vhll)
  Citizen.CreateThread(function()
    Menu.close()
    local customs = json.decode(tostring(vhll.customs))
    local health = json.decode(tostring(vhll.Health))
    Citizen.Wait(300)
    local CarOnPoint = GetClosestVehicle(vhll.x,vhll.y,vhll.z, 5.000, 0, 70)
    DeleteEntity(CarOnPoint)
      local car = tonumber(vhll.model)
      Venato.CreateVehicle(car, {x=vhll.x,y=vhll.y,z=vhll.z}, vhll.h, function(vhl)
        print(Venato.dump(health))
        if health ~= nil then
          SetVehicleEngineHealth(vhl, health[1])
          SetEntityHealth(vhl, health[2])
          GetVehicleDirtLevel(vhl, health[3])
          GetVehicleFuelLevel(vhl, health[4])

          local doors = health[5]
          for i=0, 9 do
            if(doors[i..""] == 1) then
              SetVehicleDoorBroken(vhl, i)
            end
          end

          local window = health[6]
          for i=0, 9 do
            if window[i..""] == false then
              SmashVehicleWindow(vhl, i)
            end
          end

          local tyre = health[7]
          for i=0, 9 do
            if tyre[i..""] == 1 then
              SetVehicleTyreBurst(vhl, i, true, 0.0)
            end
          end

          local wheel = health[8]
          print(Venato.dump(wheel))
          for i, p in pairs(wheel) do
            SetVehicleWheelHealth(vhl, i, wheel[i..""])
          end

        end
        SetPedIntoVehicle(Venato.GetPlayerPed(), vhl, -1)
        SetVehicleNumberPlateText(vhl, vhll.plate)
        TriggerEvent('lock:addVeh', vhll.plate, vhll.name)
        TriggerServerEvent("Garage:SortiVehicule", vhll.plate, vhll.model)
        SetVehicleOnGroundProperly(vhl)
        SetVehicleModKit(vhl, 0 )
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
    	local debugvar = false
    	local var87 = 10000
    	local VehClassModel = GetVehicleClass(vhl)
    	local entitymdl = GetEntityModel(vhl)
    	local Model = GetDisplayNameFromVehicleModel(entitymdl)

    	blacklistedmodel = GetBlacklistedList()
    	listedcar = GetBalancedList()
    	classmdl = GetBalancedCatList()

    	if debugvar == true then msginf("NEW CATEGORIE : " .. VehClassModel .. " " .. Model .. " Entity mdl : " .. entitymdl,10000) end
    	for k, v in pairs(listedcar) do
    		if not IsVehicleModel(vhl, v) then
    			table.insert(listedcar, entitymdl)
    		end
    	end

    	for k, v in pairs(listedcar) do
    		if IsVehicleModel(vhl, v) then
    			for j, l in pairs(classmdl) do
    				local GetClassModel = GetVehicleClass(vhl)
    				local Model = GetDisplayNameFromVehicleModel(GetEntityModel(vhl))
    				ResultatClassmodel = j
    				if GetVehicleClass(vhl) == j then
    					local resultatcalcul = GetVehicleModModifierValue(vhl, 11, GetVehicleMod(vhl,11))/l.Multiplicateur + 0.1
    					SetVehicleEnginePowerMultiplier(vhl, resultatcalcul)
    					globalclassmodelforblacklist = l.classmodel
    					blacklistedmultip = l.BlacklistedMultiplicateur
    					if debugvar == true then msginf("CATEGORIE : " .. l.classmodel .. " " .. Model .. " V : " .. l.Multiplicateur .. " result : " .. resultatcalcul .. " Vehicule n°: " .. k ,10000) end
    					if k == 1080 and debugvar == true then msginf("Voiture non CATEGORISÉ : " .. l.classmodel .. " " .. Model .. " V : " .. l.Multiplicateur .. " Multipl : " .. resultatcalcul .. " Vehicule n°: " .. k ,10000) end
    					break
    				else
    					if debugvar == true then msginf("BUG: " .. GetClassModel .. " V : " .. v .. " J : " .. ResultatClassmodel .. " l : " .. l.classmodel ,10000) end
    				end
    			end
    		end
    	end

    	for k2, v2 in pairs(blacklistedmodel) do
    		if IsVehicleModel(vhl, v2) then
    			--Voiture buggé reelement au cas par cas:
    			if IsVehicleModel(vhl, blacklistedmodel[6]) then -- PFISTER811
    				resultatcalcul = GetVehicleModModifierValue(vhl, 11, GetVehicleMod(vhl,11))/8.5 + 0.1
    				SetVehicleEnginePowerMultiplier(vhl, resultatcalcul)
    			elseif IsVehicleModel(vhl, blacklistedmodel[2]) then -- SCHAFTERV12
    				resultatcalcul = GetVehicleModModifierValue(vhl, 11, GetVehicleMod(vhl,11))/13.5 + 0.1
    				SetVehicleEnginePowerMultiplier(vhl, resultatcalcul)
    			elseif IsVehicleModel(vhl, blacklistedmodel[10]) then -- SLAMVAN3
    				resultatcalcul = GetVehicleModModifierValue(vhl, 11, GetVehicleMod(vhl,11))/23.5 + 0.1 -- 22.5 = 250 km/h |  23.5 = 180 km/h ...
    				SetVehicleEnginePowerMultiplier(vhl, resultatcalcul)
    			elseif IsVehicleModel(vhl, blacklistedmodel[11]) then -- BANSHEE2
    				resultatcalcul = GetVehicleModModifierValue(vhl, 11, GetVehicleMod(vhl,11))/2.5 + 0.1
    				SetVehicleEnginePowerMultiplier(vhl, resultatcalcul)
    			else
    				SetVehicleEnginePowerMultiplier(vhl, GetVehicleModModifierValue(vhl, 11, GetVehicleMod(vhl,11))/blacklistedmultip + 0.1)
    				resultatcalcul = math.ceil((GetVehicleMod(vhl,11)/blacklistedmultip + 0.1)*var87)/var87
    			end
    			if debugvar == true then msginf("~r~NERF CATEGORIE : ~w~" .. globalclassmodelforblacklist .. " ~r~Diviser : " .. blacklistedmultip .. " Multiplicateur : " .. resultatcalcul,10000) end
    			break
    		end
    	end
      end)
  end)
end

RegisterNetEvent("Garage:AllVehicleBack")
AddEventHandler("Garage:AllVehicleBack", function(garage)
  Vehicule = garage.vehicles
  MyCar(garage)
end)

RegisterNetEvent("Garage:AllVehicle")
AddEventHandler("Garage:AllVehicle", function(garage)
  Vehicule = garage.vehicles
  TriggerEvent('Menu:Init', "Garage", "Mes véhicules", '#1E88E599', "https://i.ibb.co/mBYMkLL/image.png")
  Menu.clearMenu()
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "close", nil)
  Menu.addItemButton("Mes vehicules","https://i.ibb.co/dfs9NCR/icons8-traffic-jam-96px.png", "getCars", garage)
  Menu.addItemButton("Rentrer son véhicule","https://i.ibb.co/872sDJ2/icons8-garage-closed-96px-1.png", "StoreMyCar", garage)
  Menu.open()
end)

RegisterNetEvent("Garage:deleteVoiture")
AddEventHandler("Garage:deleteVoiture", function(vehicle, plate)
  if IsPedInAnyVehicle( Venato.GetPlayerPed(), false ) then
    TaskLeaveVehicle(Venato.GetPlayerPed(), GetVehiclePedIsIn(Venato.GetPlayerPed(), false), 262144)
    Citizen.Wait(2500)
  end
  if GetEntityModel(vehicle) ~= nil then
    Venato.DeleteCar(vehicle)
  else
    local current = GetPlayersLastVehicle(Venato.GetPlayerPed(), true)
    Venato.DeleteCar(vehicle)
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
