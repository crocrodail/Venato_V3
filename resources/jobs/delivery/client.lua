--[[
  Client entry point for delivery job

  @author Astymeus
  @date 2019-07-24
  @version 1.0
--]]
--AddEventHandler('playerSpawned', function()
CreateThread(function()
  print('DeliveryJob: Start...')
  if DeliveryJobConfig.enabled then

    print('DeliveryJob: Enabled !')
    local defaultDestinations = DeliveryJobConfig.defaultDropLocations
    local defaultOrders = DeliveryJobConfig.defaultOrders

    local mission = DeliveryJobConfig.defaultMissions[1]

    if mission then
      print('DeliveryJob: Mission found !!')
      local destination = defaultDestinations[mission.targetId]
      local order = defaultOrders[mission.orderId]
      TriggerServerEvent("Venato:dump", { "DeliveryJob:", destination })

      local blip = AddBlipForCoord(destination.posX, destination.posY, destination.posZ)
      SetBlipSprite(blip, 119)
      SetBlipColour(blip, 17)
      SetBlipScale(blip, 1.0)
      SetBlipCategory(blip, 10)
      SetBlipAsShortRange(blip, true)
      SetBlipRoute(blip, true)
      SetBlipRouteColour(blip, 17)

      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(destination.name)
      EndTextCommandSetBlipName(blip)

    end

    while true do
      Wait(0)

      TriggerEvent("Venato:InteractTxt", "Livraison en cours, veuillez vous rendre à destination ~BLIP_119~")

    end

  end
end)
--end)
