local open = false
local type = 'fleeca'
local lastNotif = 0
local color = 0
local colorSec = 0
local playerPed = PlayerPedId()
local menuIsOpen = false
local currentVehicle
local showInformationVehicle = false
local currentShop = 0

Citizen.CreateThread(function ()
  SetNuiFocus(false, false)  
  while true do
    playerPed = PlayerPedId()
    Citizen.Wait(0)    
    if menuIsOpen then
      scaleform = Venato.GetCarShopIntruction()      
      DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end
    if showInformationVehicle and currentVehicle then      
      scaleform2 = Venato.DisplayInfoVehicle(currentVehicle)
      local x = 0.85
			local y = 0.1
			local width = 1.20
			local height = 1.20
      DrawScaleformMovie(scaleform2, x, y, width, height)
    else

    end
    for i=1, #Config.CarShop, 1 do      
      distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.CarShop[i].x, Config.CarShop[i].y, Config.CarShop[i].z, true)
      if distance < Config.CarShop[i].distanceMarker then
        DrawMarker(Config.CarShop[i].type, Config.CarShop[i].x, Config.CarShop[i].y, Config.CarShop[i].z+0.1,0,0,0,0,0,0,1.0,1.0,1.0,0,150,255,200,true,true,0,0)
        if IsControlJustPressed(1, Keys['LEFT']) and menuIsOpen then          
          previousVehicleColor()
        elseif IsControlJustPressed(1, Keys['RIGHT']) and menuIsOpen then
          nextVehicleColor()
        elseif IsControlJustPressed(1, Keys['F6']) and menuIsOpen then          
          previousVehicleSecColor()

        elseif IsControlJustPressed(1, Keys['F7']) and menuIsOpen then
          nextVehicleSecColor()
        end
      end
      if distance < Config.CarShop[i].distanceMin  then
        if not menuIsOpen then
        Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ Pour voir les véhicules')
        end
        if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then -- press action contextuel (e) pour joueur clavier uniquement
          if IsPedInAnyVehicle( playerPed, false ) then
              Venato.notify("Vous devez être à pied !")
          else

            GiveWeaponToPed(PlayerPedId(), "WEAPON_GRENADELAUNCHER", 50)  
            GiveWeaponToPed(PlayerPedId(), "WEAPON_CARBINERIFLE", 500)  
            GiveWeaponToPed(PlayerPedId(), "WEAPON_REVOLVER", 500)  
            
            OpenCarMenu(Config.CarShop[i].vehiculeType)  
            currentShop = Config.CarShop[i].id
            scaleform = Venato.GetCarShopIntruction()
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
          end     
        end
      else
        if menuIsOpen and Config.CarShop[i].id == currentShop then
          
          menuIsOpen = false
          Menu.hidden = true
        end
      end			
    end
	end
end)


function OpenCarMenu(vehiculeType)
  if not menuIsOpen then    
    testIcon = 0      
    TriggerServerEvent("CarShop:ShowCategory", vehiculeType)
  else  
    menuIsOpen = false
    Menu.hidden = true
  end
  showInformationVehicle = false  
end

function hideMenu()  
  RemoveNotification(lastNotif)  
  menuIsOpen = false
  showInformationVehicle = false
  Menu.hidden = true
end

function showCategory(category)
  if IsPedInAnyVehicle( playerPed, false ) then
    car = GetVehiclePedIsIn( playerPed, false )
    deleteCar( car )
  end
  showInformationVehicle = false
  showVehicles(category)
end

function showVehicles(category)
  TriggerServerEvent("CarShop:ShowVehicles", category)
end

function returnToCategory(category)  
  RemoveNotification(lastNotif)
  if IsPedInAnyVehicle( playerPed, false ) then
    car = GetVehiclePedIsIn( playerPed, false )
    deleteCar( car )
  end
  TriggerServerEvent("CarShop:ShowCategory", category)
  showInformationVehicle = false
end

function deleteCar( entity )
	Citizen.InvokeNative( 0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized( entity ) )
end

function formatPrice(price)
  if not price then
    price = 0
  end
  local left,num,right = string.match(price,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function nextVehicleColor()  
  color = color +1
  if color > 159 then
    color = 0
  end
  changeColor()
end

function previousVehicleColor()  
    color = color -1
    if color < 0 then
      color = 159
    end
    changeColor()
end

function nextVehicleSecColor()  
  colorSec = colorSec +1
  if colorSec > 159 then
    colorSec = 0
  end
  changeColor()
end

function previousVehicleSecColor()  
    colorSec = colorSec -1
    if colorSec < 0 then
      colorSec = 159
    end
    changeColor()
end

function changeColor()
  local car = GetVehiclePedIsIn( playerPed, false )
  SetVehicleColours(car,color,colorSec)
end

function previewVehicle(data)
   -- check if the vehicle actually exists
   showInformationVehicle = false 
   if not IsModelInCdimage(data.model) or not IsModelAVehicle(data.model) then
        TriggerEvent('chat:addMessage', {
            args = { 'It might have been a good thing that you tried to spawn a ' .. data.name .. '. Who even wants their spawning to actually ^*succeed?' }
        })
        return
    end

    -- load the model
    RequestModel(data.model)

    -- wait for the model to load
    while not HasModelLoaded(data.model) do
        Wait(500) -- often you'll also see Citizen.Wait
    end

    -- get the player's position
    local pos = GetEntityCoords(playerPed) -- get the position of the local player ped

    -- create the vehicle
    local vehicle = CreateVehicle(data.model, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)
    SetVehicleColours(vehicle,color,colorSec)

    if IsPedInAnyVehicle( playerPed, false ) then
      car = GetVehiclePedIsIn( playerPed, false )      
      deleteCar( car )
    end
    
    currentVehicle = data
    showInformationVehicle = true  

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)
    SetVehicleUndriveable(vehicle, true)

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
    SetEntityAsNoLongerNeeded(vehicle)

end

function buyVehicle(data)  
  local car = GetVehiclePedIsIn( playerPed, false ) 
  local currentVhl = {}
  currentVhl.primary_red, currentVhl.primary_green, currentVhl.primary_blue   = GetVehicleCustomPrimaryColour(car);
  currentVhl.secondary_red, currentVhl.secondary_green, currentVhl.secondary_blue = GetVehicleCustomSecondaryColour(car);
  currentVhl.primary_type = GetVehicleModColor_1(car,0,0)
  currentVhl.secondary_type = GetVehicleModColor_2(car,0,0)
  currentVhl.extra ,currentVhl.wheelcolor = GetVehicleExtraColours(car);
  local customs = {
      color = {
          primary = color,
          secondary = colorSec,
          pearlescent = currentVhl.extra
      },
      wheels = {
          type = 0,
          color = currentVhl.wheelcolor,
      },
      neons = { enabled= 0, red = 255,green= 255, blue = 255},
      windows = 0,
      tyreburst = {enabled=0, red = 255,green= 255, blue = 255},
      mods = {},
  }
  print(json.encode(customs))
  local vehicle = {
    id = data.id,
    name = data.name,
    model = GetEntityModel(car),
    plate = GetVehicleNumberPlateText(car),
    customs = json.encode(customs)   
  }
  if data.vp_enabled then
    if data.vp_only then
      payWithVp(vehicle)
      return
    else
      ClearMenu()
      MenuTitle = "Concessionnaire"
      MenuDescription = "Confirmer paiement"
      showInformationVehicle = false
      Menu.addButton("~r~↩ Retour", "showVehicles", data.type)
      Menu.addButton("Payer avec de l'argent", "pay", vehicle)
      Menu.addButton("Payer avec des Venato Points", "payWithVp", vehicle)
    end
  else
    pay(vehicle)
  end
end

function payWithVp(vehicle)
  TriggerServerEvent("CarShop:BuyVP", vehicle)
end

function pay(vehicle)
  TriggerServerEvent("CarShop:Buy", vehicle)
end

function hideInfo()
  showInformationVehicle = false
  currentVehicle = nil
end


function pairsByKeys (t, f)
  local a = {}
  for n in pairs(t) do table.insert(a, n) end
  table.sort(a, f)
  local i = 0      -- iterator variable
  local iter = function ()   -- iterator function
    i = i + 1
    if a[i] == nil then return nil
    else return a[i], t[a[i]]
    end
  end
  return iter
end

RegisterNetEvent('CarShop:PaiementOk:response')
AddEventHandler('CarShop:PaiementOk:response', function(data)
  RemoveNotification(lastNotif)
  SetNuiFocus(false, false)
  local car = GetVehiclePedIsIn( playerPed, false )
  SetVehicleUndriveable(car, false)
  showInformationVehicle = false
  hideMenu()
  Venato.notify("~g~Félicitation\n~w~Faites attention sur la route")
end)

RegisterNetEvent('CarShop:PaiementKo:response')
AddEventHandler('CarShop:PaiementKo:response', function(data)
  Venato.notify("~r~Echec de paiement")
end)

RegisterNetEvent('CarShop:ShowCategory:response')
AddEventHandler('CarShop:ShowCategory:response', function(data)
  ClearMenu()
  MenuTitle = "Concessionnaire"
  MenuDescription = "Catégories"
  Menu.addButton("~r~↩ Retour", "hideMenu", data)
  
  for k,v in pairsByKeys(data) do
    Menu.addButton(v.type, "showCategory", v.type)
  end
  Menu.addButton("~r~↩ Retour", "hideMenu", data)
  menuIsOpen = true
  showInformationVehicle = false
  Menu.hidden = false
end)

RegisterNetEvent('CarShop:ShowVehicles:response')
AddEventHandler('CarShop:ShowVehicles:response', function(data)
  ClearMenu()
  MenuTitle = "Concessionnaire"
  local returnAdded = false
  local carShopType = 0
  
  for k,v in pairsByKeys(data) do
    if(not returnAdded) then
      Menu.addButton("~r~↩ Retour", "returnToCategory", v.carShopType, "hideInfo")
      carShopType = v.carShopType
      returnAdded = true
    end
    MenuDescription = v.type
    Menu.addButton(v.name, "buyVehicle", v, "previewVehicle")
  end
  Menu.addButton("~r~↩ Retour", "returnToCategory", carShopType, "hideInfo")
  
  menuIsOpen = true
  showInformationVehicle = false
  Menu.hidden = false
end)

RegisterCommand('car', function(source, args, rawCommand)
  local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
  local veh = args[1]
  if veh == nil then veh = "adder" end

  Citizen.CreateThread(function()
    RequestModel(veh)

    -- wait for the model to load
    while not HasModelLoaded(veh) do
        Wait(500) -- often you'll also see Citizen.Wait
    end
    color = 0
    -- get the player's position
    local pos = GetEntityCoords(playerPed) -- get the position of the local player ped

    -- create the vehicle
    local vehicle = CreateVehicle(veh, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)
    
    if IsPedInAnyVehicle( playerPed, false ) then
      car = GetVehiclePedIsIn( playerPed, false )
      deleteCar( car )
    end 

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1) 
    
		SetModelAsNoLongerNeeded(veh)  
  end)
end)

RegisterCommand('GetStorePosition', function(source, args, rawCommand)
  local pos = GetEntityCoords(PlayerPedId())
  print("{x = "..pos.x..", y = "..pos.y..", z = "..pos.z..", type = 36, vehiculeType = 1, name=''},")
end)

RegisterCommand('boost', function(source, args, rawCommand)
  local veh = GetVehiclePedIsIn( PlayerPedId(), false )
  SetVehicleMaxSpeed(veh, args[1])
end)

RegisterCommand('removeLast', function(source, args, rawCommand)
  local car = GetVehiclePedIsIn( playerPed, true )
  deleteCar( car )
end)



