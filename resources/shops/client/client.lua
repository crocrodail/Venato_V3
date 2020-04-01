--[[
  Client entry point for manage shops

  @author Astymeus
  @date 2019-07-11
  @version 1.0
--]]
RegisterNetEvent("Shops:LoadShops:cb")
AddEventHandler("Shops:LoadShops:cb", function(shops)
  CreateThread(function()
    RequestModel(GetHashKey("a_m_y_business_03"))

    while not HasModelLoaded(GetHashKey("a_m_y_business_03")) do
      Wait(1)
    end

    for _, item in ipairs(shops) do
      if item.Supervised ~= 1 then
        local npc = CreatePed(4, 0xA1435105,
          item.PositionX, item.PositionY, item.PositionZ, item.NpcHeading,
          false, true
        )

        SetEntityHeading(npc, item.NpcHeading)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
      end

      local blip = AddBlipForCoord(item.PositionX, item.PositionY, item.PositionZ)
      SetBlipSprite(blip, item.BlipIcon)
      SetBlipColour(blip, item.BlipColor)
      SetBlipScale(blip, 1.0)
      SetBlipCategory(blip, 10)
      SetBlipAsShortRange(blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.Renamed or item.Name)
      EndTextCommandSetBlipName(blip)

      if item.IsSupervisor then
        blip = AddBlipForCoord(item.GarageX, item.GarageY, item.GarageZ)
        SetBlipSprite(blip, 50)
        SetBlipColour(blip, item.BlipColor)
        SetBlipScale(blip, 1.0)
        SetBlipCategory(blip, 10)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(item.Renamed or item.Name)
        EndTextCommandSetBlipName(blip)
      end
    end

    while true do
      Wait(0)
      ConfigShop.inShopMarker = false

      local playerPos = GetEntityCoords(GetPlayerPed(-1))
      for _, item in ipairs(shops) do
        local distance = GetDistanceBetweenCoords(playerPos, item.PositionX, item.PositionY, item.PositionZ, true)
        if distance < 20 then
          local x = item.PositionX - 2.0 * Sin(item.NpcHeading)
          local y = item.PositionY + 2.0 * Cos(item.NpcHeading)
          local z = item.PositionZ + 1.0
          DrawMarker(29, x, y, z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 150, 0, 250, 1, 1, 2, 0)
        end
        if distance < item.ActivationDist then
          ConfigShop.inShopMarker = true
          ConfigShop.currentShopId = item.Id
          TriggerEvent("venato:InteractTxt", "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir/fermer le shop")
        elseif ConfigShop.menuOpen and ConfigShop.currentShopId == item.Id and distance > (2 * item.ActivationDist) then
          ConfigShop.inShopMarker = false
          ConfigShop.menuOpen = false
          TriggerEvent('Menu:Close')
          ConfigShop.page = "client"
        end
        distance = GetDistanceBetweenCoords(playerPos, item.GarageX, item.GarageY, item.GarageZ, true)
        if distance < 20 and item.IsSupervisor then
          DrawMarker(27, item.GarageX, item.GarageY, item.GarageZ, 0, 0, 0, 0, 0, 0, 1.9, 1.9, 1.9, 0, 150, 255, 200, 0,
            0, 0, 0)
        end
        if distance < 1 and item.IsSupervisor then
          ConfigShop.inGarageMarker = true
          ConfigShop.spawnConfig = { item.GarageX, item.GarageY, item.GarageZ, item.GarageHeading }
          ConfigShop.currentShopId = item.Id
          if IsPedInVehicle(GetPlayerPed(-1), ConfigShop.forklift) then
            TriggerEvent("venato:InteractTxt", "Appuyez sur ~INPUT_CONTEXT~ pour sortir le transpalette")
          else
            TriggerEvent("venato:InteractTxt", "Appuyez sur ~INPUT_CONTEXT~ pour ranger le transpalette")
          end
        elseif ConfigShop.currentShopId == item.Id and distance > 1.5 then
          ConfigShop.inGarageMarker = false
          ConfigShop.spawnConfig = false
        end
      end
    end
  end)
end)

--
CreateThread(function()
  TriggerServerEvent("Shops:LoadShops")
  while ConfigShop.EnableShops do
    Wait(0)
    if (IsControlJustReleased(1, Keys["BACKSPACE"]) or IsControlJustReleased(1, Keys["RIGHTMOUSE"])) then
      SetNuiFocus(false, false)
      ConfigShop.menuOpen = false
      TriggerEvent('Menu:Close')
      ConfigShop.page = "client"
    end
    if IsControlJustReleased(1, Keys["INPUT_CONTEXT"]) and ConfigShop.inShopMarker then
      TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentShopId)
      ConfigShop.menuOpen = true
    elseif IsControlJustReleased(1, Keys["INPUT_CONTEXT"]) and ConfigShop.inGarageMarker then
      if IsPedInVehicle(GetPlayerPed(-1), ConfigShop.forklift) then
        despawnForklift()
      else
        spawnForklift()
      end
    end
    if ConfigShop.menuOpen then
      DisableControlAction(0, 1, true) -- LookLeftRight
      DisableControlAction(0, 2, true) -- LookUpDown
      DisableControlAction(0, 24, true) -- Attack
      DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
    end
  end
end)

function spawnForklift()
  local name = "forklift"
  if name ~= nil and name ~= '' and name ~= ' ' and IsModelValid(GetHashKey(string.upper(name))) ~= false then
    despawnForklift()
    JobTools._CreateVehicle(
      string.upper(name),
      ConfigShop.spawnConfig[1], ConfigShop.spawnConfig[2], ConfigShop.spawnConfig[3],
      ConfigShop.spawnConfig[4],
      function(vehicle)
        ConfigShop.forklift = vehicle
        SetVehicleNumberPlateText(vehicle, "SHOP_" .. math.random(100, 999))
        SetPedIntoVehicle(GetPlayerPed(GetPlayerFromServerId(ClientSource)), vehicle, -1)
        TriggerEvent('lock:addVeh', GetVehicleNumberPlateText(vehicle),
          GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
      end)
  end
end

function despawnForklift()
  if ConfigShop.forklift ~= nil then
    Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(ConfigShop.forklift))
  end
end

function _CreateVehicle(modelName, coordX, coordY, coordZ, heading, cb)
  local model = modelName
  if tonumber(modelName) == nil then
    model = GetHashKey(modelName)
  end
  CreateThread(function()
    if not HasModelLoaded(model) then
      RequestModel(model)
      while not HasModelLoaded(model) do
        Wait(1)
      end
    end
    local vehicle = CreateVehicle(model, coordX, coordY, coordZ, heading, true, false)
    local id = NetworkGetNetworkIdFromEntity(vehicle)
    SetNetworkIdCanMigrate(id, true)
    SetEntityAsMissionEntity(vehicle, true, false)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetModelAsNoLongerNeeded(model)
    RequestCollisionAtCoord(coordX, coordY, coordZ)
    while not HasCollisionLoadedAroundEntity(vehicle) do
      RequestCollisionAtCoord(coordX, coordY, coordZ)
      Wait(0)
    end
    SetVehRadioStation(vehicle, 'OFF')
    if cb ~= nil then
      cb(vehicle)
    end
  end)
end
