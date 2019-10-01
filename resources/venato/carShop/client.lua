local open = false
local type = 'fleeca'
local lastNotif = 0
local color = 0
local colorSec = 0
local playerPed = PlayerPedId()
local menuIsOpen = false
local currentVehicle
local currentShop = 0
local LastCar = nil
local init = false
local PosCarShop
local defaultNotification = {
  type = "alert",
  title ="Venato CarShop",
  logo = "https://i.ibb.co/DG6wbyY/icons8-traffic-jam-96px-1.png"
}

local colors = {}
local maxColorIndex = 11


function HideMenu()
  menuIsOpen = false
  TriggerEvent('Menu:HideVehicleInformation')
  TriggerEvent('Menu:Close')
end

Citizen.CreateThread(function()
  while true do
    PosCarShop = GetEntityCoords(Venato.GetPlayerPed())
    Citizen.Wait(1000)
  end
end)


Citizen.CreateThread(function ()
  SetNuiFocus(false, false)
  for i=1, #Config.CarShop, 1 do
    setCarShopMapMarker(Config.CarShop[i])
  end
  while true do
    playerPed = PlayerPedId()
    Citizen.Wait(0)

    if menuIsOpen then
      scaleform = Venato.GetCarShopIntruction()
      DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end

    for i=1, #Config.CarShop, 1 do
      Citizen.Wait(0)
      distance = GetDistanceBetweenCoords(PosCarShop, Config.CarShop[i].x, Config.CarShop[i].y, Config.CarShop[i].z, true)
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
            OpenCarMenu(Config.CarShop[i].vehiculeType)
            currentShop = Config.CarShop[i].id
            scaleform = Venato.GetCarShopIntruction()
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
          end
        end
        if IsControlJustPressed(1, Keys["F3"]) or IsControlJustPressed(1, Keys["BACKSPACE"]) or IsControlJustPressed(1, Keys["K"]) or IsControlJustPressed(1, Keys["F5"])  or IsControlJustPressed(1, Keys["F2"]) then
          HideMenu()
          RemoveCurrentCar()
        end
      else
        if menuIsOpen and Config.CarShop[i].id == currentShop then
          HideMenu()
          RemoveCurrentCar()
        end
      end
    end
  end
  init = true
end)

function RemoveCurrentCar()
  if IsPedInAnyVehicle( playerPed, false ) then
    Venato.DeleteCar( LastCar )
  end
end

function setCarShopMapMarker(carshop)
    if not carshop.hidden then
      local blip = AddBlipForCoord(carshop.x, carshop.y, carshop.z)
      SetBlipSprite(blip, carshop.blip)
      SetBlipColour(blip, 41)
      SetBlipScale(blip, 0.8)
      SetBlipAsShortRange(blip, true)
      BeginTextCommandSetBlipName("STRING")
      if carshop.name == "" then
        carshop.name = "CarShop"
      end
      AddTextComponentString(carshop.name)
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

function ShowCategory(category)
  if IsPedInAnyVehicle( playerPed, false ) then
    car = GetVehiclePedIsIn( playerPed, false )
    Venato.DeleteCar( car )
  end
  TriggerEvent('Menu:HideVehicleInformation')
  TriggerEvent("CarShop:ShowVehicles",category)
end

RegisterNetEvent("CarShop:ShowVehicles")
AddEventHandler('CarShop:ShowVehicles', function(category)
  TriggerServerEvent("CarShop:ShowVehicles", category)
end)

function ReturnToCategory(category)
  RemoveNotification(lastNotif)
  if IsPedInAnyVehicle( playerPed, false ) then
    car = GetVehiclePedIsIn( playerPed, false )
    Venato.DeleteCar( car )
  end
  TriggerServerEvent("CarShop:ShowCategory", category)
  TriggerEvent('Menu:HideVehicleInformation')
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
  if color > maxColorIndex then
    color = 0
  end
  changeColor()
end

function previousVehicleColor()
    color = color -1
    if color < 0 then
      color = maxColorIndex
    end
    changeColor()
end

function nextVehicleSecColor()
  colorSec = colorSec +1
  if colorSec > maxColorIndex then
    colorSec = 0
  end
  changeColor()
end

function previousVehicleSecColor()
    colorSec = colorSec -1
    if colorSec < 0 then
      colorSec = maxColorIndex
    end
    changeColor()
end

function changeColor()
  local car = GetVehiclePedIsIn( playerPed, false )
  SetVehicleColours(car,color,colorSec)
end

function PreviewVehicle(data)
   -- check if the vehicle actually exists
   TriggerEvent('Menu:HideVehicleInformation')
   if not IsModelInCdimage(data.model) or not IsModelAVehicle(data.model) then
        defaultNotification.message = "Ce modèle n'est pas disponible."
        defaultNotification.type = "error"
        Venato.notify(defaultNotification)
        return
    end
    Venato.CreateVehicle(data.model, GetEntityCoords(Venato.GetPlayerPed()), GetEntityHeading(playerPed), function(vehicle)
      LastCar = vehicle
      SetVehicleColours(vehicle,color,colorSec)
      SetVehicleFuelLevel(vehicle, GetVehicleFuelLevel(vehicle) + 50)
      SetVehicleDirtLevel(vehicle,0)
      if IsPedInAnyVehicle( playerPed, false ) then
        car = GetVehiclePedIsIn( playerPed, false )
        Venato.DeleteCar( car )
      end
      currentVehicle = data
      TriggerEvent('Menu:ShowVehicleInformation', data)
      SetPedIntoVehicle(playerPed, vehicle, -1)
      SetVehicleUndriveable(vehicle, true)
    end)
end

function BuyVehicle(data)
  local car = GetVehiclePedIsIn( playerPed, false )
  local currentVhl = {}
  currentVhl.primary_red, currentVhl.primary_green, currentVhl.primary_blue   = GetVehicleCustomPrimaryColour(car);
  currentVhl.secondary_red, currentVhl.secondary_green, currentVhl.secondary_blue = GetVehicleCustomSecondaryColour(car);
  currentVhl.primary_type = GetVehicleModColor_1(car,0,0)
  currentVhl.secondary_type = GetVehicleModColor_2(car,0,0)
  currentVhl.extra ,currentVhl.wheelcolor = GetVehicleExtraColours(car);
  local customs = {
      color = {
          primary = { type= currentVhl.primary_type, red = currentVhl.primary_red,green= currentVhl.primary_green, blue = currentVhl.primary_blue},
          secondary = { type= currentVhl.secondary_type,  red = currentVhl.secondary_red,green= currentVhl.secondary_green, blue = currentVhl.secondary_blue},
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
      PayWithVp(vehicle)
    else
      TriggerEvent('Menu:Title', "Concessionnaire", "Confirmer paiement")
      TriggerEvent('Menu:Close')
      TriggerEvent('Menu:Clear')
      TriggerEvent('Menu:AddButton',"<span class='red--text'>Retour</span>", "ShowVehicles", data.type)
      TriggerEvent('Menu:AddButton',"Payer avec de l'argent", "Pay", vehicle)
      TriggerEvent('Menu:AddButton',"Payer avec des Venato Points", "PayWithVp", vehicle)
      TriggerEvent('Menu:Open')
    end
  else
    Pay(vehicle)
  end
end

function PayWithVp(vehicle)
  TriggerServerEvent("CarShop:BuyVP", vehicle)
end

function Pay(vehicle)
  TriggerServerEvent("CarShop:Buy", vehicle)
end

function HideInfo()
  currentVehicle = nil
  TriggerEvent("Menu:HideVehicleInformation")
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

function Venato.GetCarShopIntruction()
  scaleform = Venato.ScaleForm("instructional_buttons")
  PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
  PopScaleformMovieFunctionVoid()

  PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
  PushScaleformMovieFunctionParameterInt(1)
  Button(GetControlInstructionalButton(2, 190, true))
  Button(GetControlInstructionalButton(2, 189, true))
  ButtonMessage("Changer la couleur principale")
  PopScaleformMovieFunctionVoid()

  PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
  PushScaleformMovieFunctionParameterInt(0)
  Button(GetControlInstructionalButton(2, 168, true))
  Button(GetControlInstructionalButton(2, 167, true))
  ButtonMessage("Changer la couleur secondaire")
  PopScaleformMovieFunctionVoid()

  PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
  PopScaleformMovieFunctionVoid()

  PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(80)
  EndScaleformMovieMethodReturn()

  return scaleform
end

function Venato.GetCarMenuIntruction()
  scaleform = Venato.ScaleForm("instructional_buttons")
  PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
  PopScaleformMovieFunctionVoid()
  PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
  PushScaleformMovieFunctionParameterInt(2)
  Button(GetControlInstructionalButton(2, Keys["Y"], true))
  ButtonMessage("Vérrouiler/Déverrouiller le véhicule (avec les clès)")
  PopScaleformMovieFunctionVoid()

  PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
  PushScaleformMovieFunctionParameterInt(1)
  Button(GetControlInstructionalButton(2, Keys["L"], true))
  ButtonMessage("Ouvrir l'inventaire du coffre")
  PopScaleformMovieFunctionVoid()
  PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
  PushScaleformMovieFunctionParameterInt(0)
  Button(GetControlInstructionalButton(2, Keys["H"], true))
  ButtonMessage("Régler les phares")
  PopScaleformMovieFunctionVoid()
  PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
  PopScaleformMovieFunctionVoid()
  PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(80)
  EndScaleformMovieMethodReturn()
  DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
end

RegisterNetEvent('CarShop:PaiementOk:response')
AddEventHandler('CarShop:PaiementOk:response', function(data)
  RemoveNotification(lastNotif)
  SetNuiFocus(false, false)
  local car = GetVehiclePedIsIn( playerPed, false )
  SetVehicleUndriveable(car, false)
  TriggerEvent('Menu:HideVehicleInformation')
  HideMenu()
  defaultNotification.type = "alert"
  defaultNotification.message = "<span class='green--text'>Félicitation !</span><br/> Faites attention sur la route.";
  Venato.notify(defaultNotification)
  TriggerEvent('lock:addVeh', data.plate, data.name)
  LastCar = nil
end)

RegisterNetEvent('CarShop:PaiementKo:response')
AddEventHandler('CarShop:PaiementKo:response', function(data)
  print(data)
  defaultNotification.message = data;
  defaultNotification.type = "error"
  Venato.notify(defaultNotification)
  TriggerEvent("Menu:Open")
end)

RegisterNetEvent('CarShop:ShowCategory:response')
AddEventHandler('CarShop:ShowCategory:response', function(data)
  TriggerEvent('Menu:Clear')
  TriggerEvent('Menu:Init', "Concessionnaire", "Catégories", '#2E7D3299', "https://images.caradisiac.com/logos/0/3/1/6/240316/S0-parc-automobile-il-n-y-a-jamais-eu-autant-de-vehicules-sur-nos-routes-161246.jpg")
  TriggerEvent('Menu:AddButton', "<span class='red--text'>Retour</span>", "HideMenu", data)

  for k,v in pairsByKeys(data) do
    TriggerEvent('Menu:AddButton',v.type, "ShowCategory", v.type)
  end
  TriggerEvent('Menu:AddButton', "<span class='red--text'>Retour</span>", "HideMenu", data)
  menuIsOpen = true
  TriggerEvent('Menu:HideVehicleInformation')
  TriggerEvent('Menu:Open')
end)

RegisterNetEvent('CarShop:ShowVehicles:response')
AddEventHandler('CarShop:ShowVehicles:response', function(data)
  TriggerEvent('Menu:Close')
  TriggerEvent('Menu:Clear')
  TriggerEvent('Menu:Title', "Concessionnaire", "Choissez votre prochain véhicule")
  local returnAdded = false
  local carShopType = 0

  for k,v in pairsByKeys(data) do
    if(not returnAdded) then
      TriggerEvent('Menu:AddButton',"<span class='red--text'>Retour</span>", "ReturnToCategory", v.carShopType, "HideInfo")
      carShopType = v.carShopType
      returnAdded = true
    end
    TriggerEvent('Menu:Title', "Concessionnaire", v.type)
    TriggerEvent('Menu:AddButton',v.name, "BuyVehicle", v, "PreviewVehicle")
  end
  TriggerEvent('Menu:AddButton',"<span class='red--text'>Retour</span>", "ReturnToCategory", carShopType, "HideInfo")

  menuIsOpen = true
  TriggerEvent('Menu:HideVehicleInformation')
  TriggerEvent('Menu:Open')
end)
