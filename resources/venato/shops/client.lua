
-- Some Shops
CreateThread(function()
  SetNuiFocus(false, false)
  local time = 500
  RequestModel(GetHashKey("a_m_y_business_03"))

  while not HasModelLoaded(GetHashKey("a_m_y_business_03")) do
      Wait(1)
  end

  if ConfigShop.EnableShops then
    print("Shop NPCs enabled")
    for _, item in pairs(ConfigShop.NPCs) do
      print("NPC found ".. item.name)
      if item.enable then
        print("NPC added ".. item.name .. ' x:' .. item.x .. ' y:' .. item.y .. ' z:' .. item.z)
        local npc = CreatePed(4, 0xA1435105, item.x, item.y, item.z, item.heading, false, true)
        
        SetEntityHeading(npc, item.heading)
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
      for _, item in pairs(ConfigShop.NPCs) do
        distance = GetDistanceBetweenCoords(playerPos, item.x, item.y, item.z, true)
        if distance < 20 and item.enable then
          x = item.x + 2.0*Sin(item.heading*3.14/180.0)
          y = item.y + 2.0*Cos(item.heading*3.14/180.0)
          z = item.z + 1.0
          DrawMarker(29,                --type
                       x,  y,  z,       -- pos
                       0,  0,  0,       -- dir
                       0,  0,  0,       -- rot
                     1.0,1.0,1.0,       -- scale
                       0,150,  0,250,   -- RGB+alpha
                     1,1,2,0)           -- other
        end
        if distance < 3  then
          time = 0
          isNPC = item.enable
					Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour être servi')
        elseif distance > 4 then
          time = 500
        end
      end
    end
  end
end)