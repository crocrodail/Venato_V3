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
          TriggerEvent("Venato:InteractTxt", "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir/fermer le shop")
        elseif ConfigShop.menuOpen and ConfigShop.currentShopId == item.Id and distance > (2 * item.ActivationDist) then
          ConfigShop.inShopMarker = false
          ConfigShop.menuOpen = false
          TriggerEvent('Menu:Close')
          ConfigShop.page = "client"
        end
      end
    end
  end
  )
end
)

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
