local open = false
local shopName = nil

AddEventHandler('playerSpawned', function()
  LoadShops()
end)


RegisterNetEvent("Shops:Load")
AddEventHandler("Shops:Load", function()
	LoadShops()
end)

function LoadShops()
  if ConfigShop.EnableShops then
    TriggerServerEvent("Shops:LoadShops", item.name)
  end
end)


RegisterNetEvent('Shops:LoadShops:cb')
AddEventHandler('Shops:LoadShops:cb', function(Data)
	Citizen.CreateThread(function()
    print(json.stringify(Data))
    RequestModel(GetHashKey("a_m_y_business_03"))

    while not HasModelLoaded(GetHashKey("a_m_y_business_03")) do
        Wait(1)
    end
    for _, item in pairs(Data) do
      if not item.Supervised then
        print("NPC added ".. item.Name .. ' x:' .. item.PositionX .. ' y:' .. item.PositionY .. ' z:' .. item.PositionZ)
        local npc = CreatePed(4, 0xA1435105, item.PositionX, item.PositionY, item.PositionZ, item.NpcHeading, false, true)
        
        SetEntityHeading(npc, item.NpcHeading)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
      end
    end

    while true do
      Wait(0)
      isNPC = true

      playerPos = GetEntityCoords(GetPlayerPed(-1))
      heading = GetEntityHeading(GetPlayerPed(-1))
      for _, item in pairs(Data) do
        distance = GetDistanceBetweenCoords(playerPos, item.PositionX, item.PositionY, item.PositionZ, true)
        if distance < 20 then
          x = item.x + 2.0*Sin(item.NpcHeading*3.14/180.0)
          y = item.y + 2.0*Cos(item.NpcHeading*3.14/180.0)
          z = item.z + 1.0
          DrawMarker( 29,               --type
                       x,  y,  z,       -- pos
                       0,  0,  0,       -- dir
                       0,  0,  0,       -- rot
                     1.0,1.0,1.0,       -- scale
                       0,150,  0,250,   -- RGB+alpha
                     1,1,2,0)           -- other
        end
        if distance < 3  then
          isNPC = not item.Supervised
          shopName = item.Name
					Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour être servi')
        end
      end
    end

	end)
end

-- 
CreateThread(function ()
  while true do
    Wait(0)
    if IsControlJustPressed(1, Keys['BACKSPACE']) or IsControlJustPressed(1, Keys['RIGHTMOUSE']) and GetLastInputMethod(2) then
      SetNuiFocus(false, false)
      open = false
    end
    if IsControlJustReleased(0, 38) and GetLastInputMethod(2) then
      TriggerServerEvent("Shops:ShowInventory", shopName)
      shopName = nil
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
AddEventHandler('Shops:ShowInventory:cb', function(Data)
	ClearMenu()
	local color = "~s~"
	MenuTitle = color..Data.Name
	MenuDescription = "Stocks"
end)