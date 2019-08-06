--[[
  Client entry point for all jobs

  @author Astymeus
  @date 2019-07-28
  @version 1.0
--]]
Jobs = {}

function Jobs.Start()
  CreateThread(function()
    -- Step 1
    --  Check the job of the player
    TriggerServerEvent("Jobs:checkPlayerJob")
  end)
end

function Jobs.init(job)
  CreateThread(function()

    serviceLocation = _G[job.Class].getServiceLocation()
    JobTools.addBlip(serviceLocation, "Entreprise", 475, 17, true)

    _G[job.Class].init()
  end)
end

function Jobs.Commands(job)
  CreateThread(function()
    while true do
      Wait(10)
      if JobsConfig.isMenuOpen and (
        IsControlJustReleased(1, Keys["BACKSPACE"]) or
          IsControlJustReleased(1, Keys["RIGHTMOUSE"])
      ) then
        TriggerEvent('Menu:Close')
        JobsConfig.isMenuOpen = false
      end
      if IsControlJustReleased(1, Keys["F3"]) and JobsConfig.inService then
        if JobsConfig.isMenuOpen then
          TriggerEvent('Menu:Close')
        else
          TriggerEvent('Menu:Clear')
          TriggerEvent('Menu:Open')
          TriggerEvent('Menu:Title', job.name)
          TriggerEvent('Menu:SubTitle', "¿ Vas y KesTuVeFaire ?")
          _G[job.Class].showMenu()
        end
        JobsConfig.isMenuOpen = not JobsConfig.isMenuOpen
      end

      -- Enter/Leave Service management
      if JobsConfig.isOnServiceLocation and IsControlJustReleased(1, Keys["E"]) then
        JobsConfig.inService = not JobsConfig.inService
        CreateThread(function()
          local time = 1
          while time < 1000 do
            Wait(1)
            JobTools.showServiceMessage(job.name, JobsConfig.inService)
            time = time + 1
          end
          JobTools.hideServiceMessage()
        end)
      end

      -- Step 3
      --  Call controls management of the job
      _G[job.Class].commands()
    end
  end)
end

function Jobs.mainLoop(job)
  CreateThread(function()

    serviceLocation = _G[job.Class].getServiceLocation()

    while true do
      Wait(0)
      local playerPos = GetEntityCoords(GetPlayerPed(-1))

      -- Service marker
      if serviceLocation ~= nil then
        distance = GetDistanceBetweenCoords(playerPos, serviceLocation.posX, serviceLocation.posY, serviceLocation.posZ,
          true)
        if distance < 20 then
          DrawMarker(27, serviceLocation.posX, serviceLocation.posY, serviceLocation.posZ, 0, 0, 0, 0, 0, 0, 1.9, 1.9,
            1.9, 0,
            112, 168, 174, 0, 0, 0, 0)
        end
        if distance < 1.5 then
          JobsConfig.isOnServiceLocation = true
          if JobsConfig.inService then
            TriggerEvent("Venato:InteractTxt", "Appuyez sur ~INPUT_CONTEXT~ pour quitter le service")
          else
            TriggerEvent("Venato:InteractTxt", "Appuyez sur ~INPUT_CONTEXT~ pour prendre le service")
          end
        elseif JobsConfig.isOnServiceLocation and distance > 1.5 then
          JobsConfig.isOnServiceLocation = false
        end
      end

      if JobsConfig.isMenuOpen then
        DisableControlAction(0, 1, true) -- LookLeftRight
        DisableControlAction(0, 2, true) -- LookUpDown
        DisableControlAction(0, 24, true) -- Attack
        DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
        DisableControlAction(0, 142, true) -- MeleeAttackAlternate
        DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
      end

    end
  end)
  CreateThread(function()
    _G[job.Class].mainLoop()
  end)
end

function Jobs.SalaryLoop()
  CreateThread(function()
    while true do
      Wait(JobsConfig.SalaryInterval)
      TriggerServerEvent("Jobs:salary")
    end
  end)
end

Jobs.Start()
