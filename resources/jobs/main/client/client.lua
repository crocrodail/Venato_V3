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
      if IsControlJustReleased(1, Keys["F3"]) then
        if JobsConfig.isMenuOpen then
          TriggerEvent('Menu:Close')
        else
          TriggerEvent('Menu:Clear')
          TriggerEvent('Menu:Open')
          TriggerEvent('Menu:Title', job.name)
          TriggerEvent('Menu:SubTitle', "¿ Vas y KesTuVeFaire ?")
        end
        JobsConfig.isMenuOpen = not JobsConfig.isMenuOpen
      end

      -- Step 3
      --  Call controls management of the job
      _G[job.Class].commands()
    end
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
  print(EventName)
end

Jobs.Start()
