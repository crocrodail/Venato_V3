local open = false
local type = 'fleeca'
local lastNotif = 0
local testIcon = 0
local color = 0
local colorSec = 0
local playerPed = PlayerPedId()
local menuIsOpen = false

Citizen.CreateThread(function ()
  SetNuiFocus(false, false)  
  while true do
    playerPed = PlayerPedId()
    Citizen.Wait(500)      
    for i=1, #Config.CarShop, 1 do      
      distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.CarShop[i].x, Config.CarShop[i].y, Config.CarShop[i].z, true)
      if distance < 20 then
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
      if distance < 5  then
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
            OpenCarMenu(Config.CarShop[i].vehiculeType);   
          end     
        end
      else
        if menuIsOpen then
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
end

function hideMenu()  
  RemoveNotification(lastNotif)  
  menuIsOpen = false
  Menu.hidden = true
end

function showCategory(category)
  if IsPedInAnyVehicle( playerPed, false ) then
    car = GetVehiclePedIsIn( playerPed, false )
    deleteCar( car )
  end
  TriggerServerEvent("CarShop:ShowVehicles", category)
end

function returnToCategory(category)  
  RemoveNotification(lastNotif)
  if IsPedInAnyVehicle( playerPed, false ) then
    car = GetVehiclePedIsIn( playerPed, false )
    deleteCar( car )
  end
  TriggerServerEvent("CarShop:ShowCategory", category)
end

function deleteCar( entity )
	Citizen.InvokeNative( 0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized( entity ) )
end

function formatPrice(price)
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
    color = 0
    -- get the player's position
    local pos = GetEntityCoords(playerPed) -- get the position of the local player ped

    -- create the vehicle
    local vehicle = CreateVehicle(data.model, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)

    if IsPedInAnyVehicle( playerPed, false ) then
      car = GetVehiclePedIsIn( playerPed, false )
      deleteCar( car )
    end

    local informationText = data.name

    if(not data.vc_only) then
      informationText = informationText .. "\n Prix : "..formatPrice(data.price).."$"      
    end
    if(data.vc_enabled) then
      informationText = informationText .. "\n Prix VC : "..formatPrice(data.price_vc).."VC"      
    end

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)
    SetVehicleUndriveable(vehicle, true)

    RemoveNotification(lastNotif)
    lastNotif = Venato.notify(informationText)
    testIcon = testIcon + 1

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
    SetEntityAsNoLongerNeeded(vehicle)

end

function buyVehicle(data)   
  RemoveNotification(lastNotif)
  SetNuiFocus(false, false)
  local car = GetVehiclePedIsIn( playerPed, false )
  SetVehicleUndriveable(car, false)
  hideMenu()
end

RegisterNetEvent('CarShop:ShowCategory:response')
AddEventHandler('CarShop:ShowCategory:response', function(data)
  ClearMenu()
  MenuTitle = "Concessionnaire"
  MenuDescription = "Catégories"
  for k,v in pairs(data) do
    Menu.addButton(v.type, "showCategory", v.type)
  end
  Menu.addButton("~r~↩ Retour", "hideMenu", data)
  menuIsOpen = true
  Menu.hidden = false
end)

RegisterNetEvent('CarShop:ShowVehicles:response')
AddEventHandler('CarShop:ShowVehicles:response', function(data)
  ClearMenu()
  MenuTitle = "Concessionnaire"
  local returnAdded = false
  local carShopType = 0
  
  for k,v in pairs(data) do
    if(not returnAdded) then
      Menu.addButton("~r~↩ Retour", "returnToCategory", v.carShopType)
      carShopType = v.carShopType
      returnAdded = true
    end
    MenuDescription = v.type
    Menu.addButton(v.name, "buyVehicle", v, "previewVehicle")
  end
  Menu.addButton("~r~↩ Retour", "returnToCategory", carShopType)
  
  menuIsOpen = true
  Menu.hidden = false
end)
