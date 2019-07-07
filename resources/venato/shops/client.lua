local open = false
local shopName = nil
local isNPC = true
local inShopMarker = false

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
      if item.Supervised ~= "1" then
        local npc = CreatePed(4, 0xA1435105, item.PositionX, item.PositionY, item.PositionZ, item.NpcHeading, false, true)
        
        SetEntityHeading(npc, item.NpcHeading)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
      end
    end

    while true do
      Wait(0)
      inShopMarker = false

      local playerPos = GetEntityCoords(GetPlayerPed(-1))
      for _, item in ipairs(shops) do
        local distance = GetDistanceBetweenCoords(playerPos, item.PositionX, item.PositionY, item.PositionZ, true)
        if distance < 20 then
          local x = item.PositionX + 2.0*Sin(item.NpcHeading*3.14/180.0)
          local y = item.PositionY + 2.0*Cos(item.NpcHeading*3.14/180.0)
          local z = item.PositionZ + 1.0
          DrawMarker( 29,               --type
                       x,  y,  z,       -- pos
                       0,  0,  0,       -- dir
                       0,  0,  0,       -- rot
                     1.0,1.0,1.0,       -- scale
                       0,150,  0,250,   -- RGB+alpha
                     1,1,2,0)           -- other
        end
        if distance < 2  then
          isNPC = item.Supervised ~= 1
          inShopMarker = true
          shopName = item.Name
          Venato.InteractTxt('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir/fermer le shop')
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
      open = false
    end
    if IsControlJustReleased(1, Keys['INPUT_CONTEXT']) and inShopMarker then
      TriggerServerEvent("Shops:ShowInventory", shopName)
      open = true
    end
    if open then
      DisableControlAction(0, 1, true) -- LookLeftRight
      DisableControlAction(0, 2, true) -- LookUpDown
      DisableControlAction(0, 24, true) -- Attack
      DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
    end
	end
end)


RegisterNetEvent('Shops:ShowInventory:cb')
AddEventHandler('Shops:ShowInventory:cb', function(shop)
	open = true

  ClearMenu()
  Menu.hidden = false

  local color = "~s~"
  local shopName_ = shop.Renamed or shop.Name or "Shop"
	MenuTitle = color..""..shopName_
	MenuDescription = "Stocks"

  for _, item in ipairs(shop.Items) do
    local textButton = "~s~"..item.Name.." ~o~"..item.Price.."€~s~"
    if item.Quantity == 0 then
      textButton = textButton.." ~r~Rupture"
    elseif item.Quantity > 0 then
      textButton = "~s~"..textButton.." ~g~"..item.Quantity.." en stock"
    else
      textButton = "~s~"..textButton.."~g~ stock illimité"
    end
    Menu.addButton(
      textButton, 
      "buyItem",
      {["item"]=item, ["shopId"]=shop.Id}
    )
  end
end)

function buyItem(args)
  TriggerServerEvent("Shops:TestBuy", args.item, args.shopId)
end


RegisterNetEvent('Shops:TestBuy:cb')
AddEventHandler('Shops:TestBuy:cb', function(Name)
  Venato.notify("~g~Vous avez bien acheté "..Name..".")
  TriggerServerEvent("Shops:ShowInventory", shopName)
end)


RegisterNetEvent('Shops:NotEnoughMoney')
AddEventHandler('Shops:NotEnoughMoney', function(Name)
  Venato.notify("~r~Vous n'avez pas assez d'argent pour acheter "..Name..".")
  TriggerServerEvent("Shops:ShowInventory", shopName)
end)


RegisterNetEvent('Shops:NotEnoughQuantity')
AddEventHandler('Shops:NotEnoughQuantity', function(Name)
  Venato.notify("~r~Il n'y a plus assez de "..Name.." en stock.")
  TriggerServerEvent("Shops:ShowInventory", shopName)
end)


RegisterNetEvent('Shops:TooHeavy')
AddEventHandler('Shops:TooHeavy', function(Name)
  Venato.notify("~r~Vous etes trop lourd pour acheter "..Name..".")
  TriggerServerEvent("Shops:ShowInventory", shopName)
end)