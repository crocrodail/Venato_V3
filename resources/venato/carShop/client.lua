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
local LastCar = nil
local defaultNotification = {
  type = "alert",
  title ="Venato CarShop",
  logo = "https://i.ibb.co/Gthd3WK/icons8-car-96px-1.png"
}

function HideMenu()
  menuIsOpen = false
  showInformationVehicle = false
  Menu.hidden = true
end

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

    if showInformationVehicle and currentVehicle then
      scaleform2 = Venato.DisplayInfoVehicle(currentVehicle)
      local x = 0.85
			local y = 0.1
			local width = 1.20
			local height = 1.20
      DrawScaleformMovie(scaleform2, x, y, width, height)
    end

    for i=1, #Config.CarShop, 1 do
      local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.CarShop[i].x, Config.CarShop[i].y, Config.CarShop[i].z, true)
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
    TriggerServerEvent("CarShop:ShowCategory", vehiculeType)
  else
    menuIsOpen = false
    Menu.hidden = true
  end
  showInformationVehicle = false
end

function showCategory(category)
  if IsPedInAnyVehicle( playerPed, false ) then
    car = GetVehiclePedIsIn( playerPed, false )
    Venato.DeleteCar( car )
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
    Venato.DeleteCar( car )
  end
  TriggerServerEvent("CarShop:ShowCategory", category)
  showInformationVehicle = false
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
  showInformationVehicle = false
  if not IsModelInCdimage(data.model) or not IsModelAVehicle(data.model) then
    defaultNotification.message = "Ce modèle n'est pas disponible."
    defaultNotification.type = "error"
    Venato.notify(defaultNotification)
    return
  end
  local pos = GetEntityCoords(playerPed)
  Venato.CreateVehicle(data.model, {x = pos.x, y = pos.y, z = pos.z}, GetEntityHeading(playerPed), function(vehicle)
    LastCar = vehicle
    SetVehicleColours(vehicle,color,colorSec)
    if IsPedInAnyVehicle( playerPed, false ) then
      car = GetVehiclePedIsIn( playerPed, false )
      Venato.DeleteCar( car )
    end
    currentVehicle = data
    showInformationVehicle = true
    SetPedIntoVehicle(playerPed, vehicle, -1)
    SetVehicleUndriveable(vehicle, true)
  end)
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
  HideMenu()
  defaultNotification.type = "alert"
  defaultNotification.message = "<span class='green--text'>Félicitation !</span><br/> Faites attention sur la route.";
  Venato.notify(defaultNotification)
  TriggerEvent('lock:addVeh', data.plate, data.name)
  LastCar = nil
end)

RegisterNetEvent('CarShop:PaiementKo:response')
AddEventHandler('CarShop:PaiementKo:response', function(data)
  defaultNotification.message = "Erreur de paiement. Verifiez votre solde.";
  defaultNotification.type = "error"
  Venato.notify(defaultNotification)
end)

RegisterNetEvent('CarShop:ShowCategory:response')
AddEventHandler('CarShop:ShowCategory:response', function(data)
  ClearMenu()
  MenuTitle = "Concessionnaire"
  MenuDescription = "Catégories"
  Menu.addButton("~r~↩ Retour", "HideMenu", data)

  for k,v in pairsByKeys(data) do
    Menu.addButton(v.type, "showCategory", v.type)
  end
  Menu.addButton("~r~↩ Retour", "HideMenu", data)
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
