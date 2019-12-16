--[[
  Client entry point for all jobs

  @author Astymeus
  @date 2019-07-28
  @version 1.0
--]]
Jobs = {}
BlipsJobs = {}

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
    JobTools.addBlip(serviceLocation, "PostOP", 408, 2, false)

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
        Menu.close()
        JobsConfig.isMenuOpen = false
      end
      if IsControlJustReleased(1, Keys["F5"]) and JobsConfig.inService then
        JobsConfig.isMenuOpen = not JobsConfig.isMenuOpen
        if not JobsConfig.isMenuOpen then
          Menu.close()
        else
          Menu.clearMenu()
          Menu.open()
          Menu.setTitle(job.name)
          Menu.setSubtitle("Metier")
          _G[job.Class].showMenu()
        end
      end

      -- Enter/Leave Service management
      if JobsConfig.isOnServiceLocation and IsControlJustReleased(1, Keys["E"]) then
        JobsConfig.isMenuOpen = not JobsConfig.isMenuOpen
        if not JobsConfig.isMenuOpen then
          Menu.close()
        else
          Menu.clearMenu()
          Menu.open()
          TriggerEvent('Menu:Init', "ob.name", "Que puis-je pour vous ?", "#B4823A99", "https://www.gvmp.de/images/proxy/29/29c09d16a4908fb10b4c9a0bbe4b9ed104395fdd.jpg")
          Menu.setTitle(job.name)
          Menu.setSubtitle("Que puis-je pour vous ?")
          Menu.addButton(JobsConfig.inService and "Quitter le service" or "Prendre le service", "toggleService", job)
          Menu.addButton("Récupérer sa paie", "takeSalary")
        end
      end

      -- Step 3
      --  Call controls management of the job
      _G[job.Class].commands()
    end
  end)
end

function toggleService(job)
  JobsConfig.inService = not JobsConfig.inService
  CreateThread(function()
    local time = 1
    while time < 200 do
      Wait(1)
      JobTools.showServiceMessage(job.name, JobsConfig.inService)
      time = time + 1
    end
    JobTools.hideServiceMessage()
  end)
  Menu.close()
  JobsConfig.isMenuOpen = false
end

function takeSalary()
  TriggerServerEvent("Jobs:askSalary")
  Menu.close()
  JobsConfig.isMenuOpen = false
end

function Jobs.mainLoop(job)
  CreateThread(function()

    serviceLocation = _G[job.Class].getServiceLocation()

    while true do
      Wait(0)
      local playerPos = GetEntityCoords(PlayerPedId())

      -- Service marker
      if serviceLocation ~= nil then
        distance = GetDistanceBetweenCoords(playerPos, serviceLocation.x, serviceLocation.y, serviceLocation.z,
          true)
        if distance < 20 then
          DrawMarker(27, serviceLocation.x, serviceLocation.y, serviceLocation.z, 0, 0, 0, 0, 0, 0, 1.9, 1.9,
            1.9, 0,
            112, 168, 174, 0, 0, 0, 0)
        end
        if distance < 2 then
          JobsConfig.isOnServiceLocation = true
          TriggerEvent("platypus:InteractTxt", "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu")
        elseif JobsConfig.isOnServiceLocation and distance > 2 then
          JobsConfig.isOnServiceLocation = false
        end
      end

      if JobsConfig.isMenuOpen then
        DisableControlAction(0, 1, true) -- LookLeftRight
        DisableControlAction(0, 2, true) -- LookUpDown
        DisableControlAction(0, 24, true) -- Attack
        DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
        DisableControlAction(0, 142, true) -- MeleeAttackAlternate
        DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
      end

    end
  end)
  CreateThread(function()
    _G[job.Class].mainLoop()
  end)
  CreateThread(function()
    _G[job.Class].checkLoop()
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

function MenuSendEvent(EventName)
  TriggerEvent(EventName)
end

Jobs.Start()
