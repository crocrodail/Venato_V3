--[[
  Client entry point for manage shops

  @author Astymeus
  @date 2019-07-11
  @version 1.0
--]]

function LoadShops()
  if ConfigShop.EnableShops then
    TriggerServerEvent("Shops:LoadShops")
  end
end

RegisterNetEvent('Shops:LoadShops:cb')
AddEventHandler('Shops:LoadShops:cb', function(shops)
  CreateThread(function()
    RequestModel(GetHashKey("a_m_y_business_03"))

    while not HasModelLoaded(GetHashKey("a_m_y_business_03")) do
        Wait(1)
    end

    for _, item in ipairs(shops) do
      if item.Supervised ~= 1 then
        local npc = CreatePed(4, 0xA1435105, item.PositionX, item.PositionY, item.PositionZ, item.NpcHeading, false, true)
        
        SetEntityHeading(npc, item.NpcHeading)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
      end
      
      local blip = AddBlipForCoord(item.PositionX, item.PositionY, item.PositionZ)
      SetBlipSprite(blip, item.BlipIcon)
      SetBlipColour(blip, item.BlipColor)
      SetBlipScale(blip, 1.0)
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
          local x = item.PositionX - 2.0*Sin(item.NpcHeading)
          local y = item.PositionY + 2.0*Cos(item.NpcHeading)
          local z = item.PositionZ + 1.0
          DrawMarker( 29,               --type
                       x,  y,  z,       -- pos
                       0,  0,  0,       -- dir
                       0,  0,  0,       -- rot
                     1.0,1.0,1.0,       -- scale
                       0,150,  0,250,   -- RGB+alpha
                     1,1,2,0)           -- other
        end
        if distance < item.ActivationDist then
          ConfigShop.inShopMarker = true
          ConfigShop.currentShopId = item.Id
          Venato.InteractTxt('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir/fermer le shop')
        elseif ConfigShop.menuOpen and ConfigShop.currentShopId == item.Id and distance > (2*item.ActivationDist) then
          ConfigShop.inShopMarker = false
          ConfigShop.menuOpen = false
          Menu.close()
          ConfigShop.page="client"
        end
      end
    end

  end)
end)

-- 
CreateThread(function ()
  LoadShops()
  while true do
    Wait(0)
    if (IsControlJustReleased(1, Keys['BACKSPACE']) or IsControlJustReleased(1, Keys['RIGHTMOUSE'])) then
      SetNuiFocus(false, false)
      ConfigShop.menuOpen = false
      Menu.close()
      ConfigShop.page="client"
    end
    if IsControlJustReleased(1, Keys['INPUT_CONTEXT']) and ConfigShop.inShopMarker then
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

-- ==================== --
-- Callback from Server --
-- ==================== --

RegisterNetEvent('Shops:UpdateMenu:cb')
AddEventHandler('Shops:UpdateMenu:cb', function(content)
  ShopPages.drawPage(content)
end)

RegisterNetEvent('Shops:getMoney:cb')
AddEventHandler('Shops:getMoney:cb', function(Price)
  ConfigShop.shopsNotification.message = ConfigShop.textInGreenColor("Vous avez bien récupéré "..Price.."€.")
  Venato.notify(ConfigShop.shopsNotification)
  TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentShopId)
end)

RegisterNetEvent('Shops:TestBuy:cb')
AddEventHandler('Shops:TestBuy:cb', function(Name)
  ConfigShop.shopsNotification.message = ConfigShop.textInGreenColor("Vous avez bien acheté "..Name..".")
  Venato.notify(ConfigShop.shopsNotification)
  TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentShopId)
end)

RegisterNetEvent('Shops:NotEnoughMoney')
AddEventHandler('Shops:NotEnoughMoney', function(Name)
  ConfigShop.shopsNotification.message = ConfigShop.textInRedColor("Vous n'avez pas assez d'argent pour acheter "..Name..".")
  Venato.notify(ConfigShop.shopsNotification)
  TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentShopId)
end)

RegisterNetEvent('Shops:NotEnoughShopMoney')
AddEventHandler('Shops:NotEnoughShopMoney', function(Price)
  ConfigShop.shopsNotification.message = ConfigShop.textInRedColor("Le magasin n'a pas assez d'argent pour récupérer "..Price.."€.")
  Venato.notify(ConfigShop.shopsNotification)
  TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentShopId)
end)

RegisterNetEvent('Shops:NotEnoughQuantity')
AddEventHandler('Shops:NotEnoughQuantity', function(Name)
  ConfigShop.shopsNotification.message = ConfigShop.textInRedColor("Il n'y a plus assez de "..Name.." en stock.")
  Venato.notify(ConfigShop.shopsNotification)
  TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentShopId)
end)

RegisterNetEvent('Shops:TooHeavy')
AddEventHandler('Shops:TooHeavy', function(Name)
  ConfigShop.shopsNotification.message = ConfigShop.textInRedColor("Vous etes trop lourd pour acheter "..Name..".")
  Venato.notify(ConfigShop.shopsNotification)
  TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentShopId)
end)

RegisterNetEvent('Shops:OrderItem:cb')
AddEventHandler('Shops:OrderItem:cb', function(Quantity, Name)
  ConfigShop.shopsNotification.message = ConfigShop.textInGreenColor("Vous avez bien commandé pour "..Quantity..": "..Name..".")
  Venato.notify(ConfigShop.shopsNotification)
  TriggerServerEvent("Shops:showOrder", ConfigShop.currentOrderId)
end)