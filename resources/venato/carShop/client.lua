local open = false
local type = 'fleeca'
local lastNotif = 0
local color = 0
local colorSec = 0
local playerPed = PlayerPedId()
local menuIsOpen = false
local currentVehicle
local currentShop = 0
local defaultNotification = {
  type = "alert",
  title ="Venato CarShop",
  logo = "https://i.ibb.co/Gthd3WK/icons8-car-96px-1.png"
}

RegisterNetEvent("CarShop:HideMenu")
AddEventHandler('CarShop:HideMenu', function()  
  menuIsOpen = false
  TriggerEvent('Menu:HideVehicleInformation')
  TriggerEvent('Menu:Close')
end)

Citizen.CreateThread(function ()
  SetNuiFocus(false, false)  
  while true do
    playerPed = PlayerPedId()
    Citizen.Wait(0) 

    if menuIsOpen then
      scaleform = Venato.GetCarShopIntruction()      
      DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end

    for i=1, #Config.CarShop, 1 do  
      setCarShopMapMarker(Config.CarShop[i])   
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
              defaultNotification.message = "Vous devez être à pied !"
              defaultNotification.type = 'error'
              Venato.notify(defaultNotification)
          else
            GiveWeaponToPed(PlayerPedId(), "WEAPON_GRENADELAUNCHER", 500)  
            GiveWeaponToPed(PlayerPedId(), "WEAPON_CARBINERIFLE", 5000)  
            GiveWeaponToPed(PlayerPedId(), "WEAPON_REVOLVER", 5000)  
            
            OpenCarMenu(Config.CarShop[i].vehiculeType)  
            currentShop = Config.CarShop[i].id
            scaleform = Venato.GetCarShopIntruction()
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
          end     
        end
        if IsControlJustPressed(1, Keys["F3"]) or IsControlJustPressed(1, Keys["BACKSPACE"]) or IsControlJustPressed(1, Keys["K"]) or IsControlJustPressed(1, Keys["F5"])  or IsControlJustPressed(1, Keys["F2"]) then          
          TriggerEvent("CarShop:HideMenu")
          RemoveCurrentCar()
        end
      else
        if menuIsOpen and Config.CarShop[i].id == currentShop then          
          TriggerEvent("CarShop:HideMenu") 
          RemoveCurrentCar()
        end
      end			
    end
	end
end)

function RemoveCurrentCar()
  if IsPedInAnyVehicle( playerPed, false ) then
    car = GetVehiclePedIsIn( playerPed, false )      
    deleteCar( car )
  end
end

function setCarShopMapMarker(carshop)
    if not carshop.hidden then
      local blip = AddBlipForCoord(carshop.x, carshop.y, carshop.z)
      SetBlipSprite(blip, carshop.blip)
      SetBlipColour(blip, 11)
      SetBlipScale(blip, 0.8)
      SetBlipAsShortRange(blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString("CarShop")
      EndTextCommandSetBlipName(blip)
    end
end

function OpenCarMenu(vehiculeType)
  if not menuIsOpen then   
    TriggerEvent("Menu:Clear")
    TriggerServerEvent("CarShop:ShowCategory", vehiculeType)
    menuIsOpen = true
  else      
    menuIsOpen = false
    TriggerEvent('Menu:Close')
  end
  TriggerEvent('Menu:HideVehicleInformation')  
end

RegisterNetEvent("CarShop:ShowCategory")
AddEventHandler('CarShop:ShowCategory',
function (category)
  if IsPedInAnyVehicle( playerPed, false ) then
    car = GetVehiclePedIsIn( playerPed, false )
    deleteCar( car )
  end
  TriggerEvent('Menu:HideVehicleInformation')
  TriggerEvent("CarShop:ShowVehicles",category)
end)

RegisterNetEvent("CarShop:ShowVehicles")
AddEventHandler('CarShop:ShowVehicles', function(category)
  TriggerServerEvent("CarShop:ShowVehicles", category)
end)

RegisterNetEvent("CarShop:ReturnToCategory")
AddEventHandler('CarShop:ReturnToCategory',function(category)  
  RemoveNotification(lastNotif)
  if IsPedInAnyVehicle( playerPed, false ) then
    car = GetVehiclePedIsIn( playerPed, false )
    deleteCar( car )
  end
  TriggerServerEvent("CarShop:ShowCategory", category)
  TriggerEvent('Menu:HideVehicleInformation')
end)

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

RegisterNetEvent("CarShop:PreviewVehicle")
AddEventHandler('CarShop:PreviewVehicle', function(data)
   -- check if the vehicle actually exists
   TriggerEvent('Menu:HideVehicleInformation') 
   if not IsModelInCdimage(data.model) or not IsModelAVehicle(data.model) then
        defaultNotification.message = "Ce modèle n'est pas disponible."
        defaultNotification.type = "error"
        Venato.notify(defaultNotification)
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
    SetVehicleFuelLevel(vehicle, GetVehicleFuelLevel(vehicle) + 50)
    SetVehicleDirtLevel(vehicle,0)
    

    if IsPedInAnyVehicle( playerPed, false ) then
      car = GetVehiclePedIsIn( playerPed, false )      
      deleteCar( car )
    end
    currentVehicle = data
    TriggerEvent('Menu:ShowVehicleInformation', data)

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)
    SetVehicleUndriveable(vehicle, true)

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
    SetEntityAsNoLongerNeeded(vehicle)

end)

RegisterNetEvent("CarShop:BuyVehicle")
AddEventHandler('CarShop:BuyVehicle', function(data)  
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
  local vehicle = {
    id = data.id,
    name = data.name,
    model = GetEntityModel(car),
    plate = GetVehicleNumberPlateText(car),
    customs = json.encode(customs)   
  }
  if data.vp_enabled then
    if data.vp_only then
      TriggerEvent("CarShop:PayWithVp", vehicle)
    else
      print('Coucou')
      TriggerEvent('Menu:Title', "Concessionnaire", "Confirmer paiement")
      TriggerEvent('Menu:Close')
      TriggerEvent('Menu:Clear')
      TriggerEvent('Menu:AddButton',"<span class='red--text'>Retour</span>", "CarShop:ShowVehicles", data.type)    
      TriggerEvent('Menu:AddButton',"Payer avec de l'argent", "CarShop:Pay", vehicle)    
      TriggerEvent('Menu:AddButton',"Payer avec des Venato Points", "CarShop:PayWithVp", vehicle)    
      TriggerEvent('Menu:Open')
    end
  else
    TriggerEvent("CarShop:Pay", vehicle)
  end
end)

RegisterNetEvent("CarShop:PayWithVp")
AddEventHandler('CarShop:PayWithVp', function(vehicle)
  TriggerServerEvent("CarShop:BuyVP", vehicle)
end)

RegisterNetEvent("CarShop:Pay")
AddEventHandler('CarShop:Pay', function(vehicle)
  TriggerServerEvent("CarShop:Buy", vehicle)
end)

RegisterNetEvent("CarShop:HideInfo")
AddEventHandler('CarShop:HideInfo', function()
  currentVehicle = nil
  TriggerEvent("Menu:HideVehicleInformation")
end
)


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
  TriggerEvent('Menu:HideVehicleInformation')
  TriggerEvent("CarShop:HideMenu")
  defaultNotification.type = "alert"
  defaultNotification.message = "<span class='green--text'>Félicitation !</span><br/> Faites attention sur la route.";
  Venato.notify(defaultNotification)
  TriggerEvent('lock:addVeh', data.plate, data.name)  
end)

RegisterNetEvent('CarShop:PaiementKo:response')
AddEventHandler('CarShop:PaiementKo:response', function(data)
  defaultNotification.message = "Erreur de paiement. Verifiez votre solde.";
  defaultNotification.type = "error"
  Venato.notify(defaultNotification)
  TriggerEvent("Menu:Open")
end)

RegisterNetEvent('CarShop:ShowCategory:response')
AddEventHandler('CarShop:ShowCategory:response', function(data)
  TriggerEvent('Menu:Clear')
  TriggerEvent('Menu:Init', "Concessionnaire", "Catégories", '#1A237E99', "https://images.caradisiac.com/logos/0/3/1/6/240316/S0-parc-automobile-il-n-y-a-jamais-eu-autant-de-vehicules-sur-nos-routes-161246.jpg")
  TriggerEvent('Menu:AddButton', "<span class='red--text'>Retour</span>", "CarShop:HideMenu", data)
  
  for k,v in pairsByKeys(data) do
    TriggerEvent('Menu:AddButton',v.type, "CarShop:ShowCategory", v.type)
  end
  TriggerEvent('Menu:AddButton', "<span class='red--text'>Retour</span>", "CarShop:HideMenu", data)
  menuIsOpen = true
  TriggerEvent('Menu:HideVehicleInformation')
  TriggerEvent('Menu:Open')hidden = false
end)

RegisterNetEvent('CarShop:ShowVehicles:response')
AddEventHandler('CarShop:ShowVehicles:response', function(data)
  TriggerEvent('Menu:Clear')
  TriggerEvent('Menu:Title', "Concessionnaire", "Choissez votre prochain véhicule")
  local returnAdded = false
  local carShopType = 0
  
  for k,v in pairsByKeys(data) do
    if(not returnAdded) then
      TriggerEvent('Menu:AddButton',"<span class='red--text'>Retour</span>", "CarShop:ReturnToCategory", v.carShopType, "CarShop:HideInfo")
      carShopType = v.carShopType
      returnAdded = true
    end
    TriggerEvent('Menu:Title', "Concessionnaire", v.type)
    TriggerEvent('Menu:AddButton',v.name, "CarShop:BuyVehicle", v, "CarShop:PreviewVehicle")
  end
  TriggerEvent('Menu:AddButton',"<span class='red--text'>Retour</span>", "CarShop:ReturnToCategory", carShopType, "CarShop:HideInfo")
  
  menuIsOpen = true
  TriggerEvent('Menu:HideVehicleInformation')
  TriggerEvent('Menu:Open')hidden = false
end)



