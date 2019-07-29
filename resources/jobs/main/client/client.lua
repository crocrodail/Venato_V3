--[[
  Client entry point for all jobs

  @author Astymeus
  @date 2019-07-28
  @version 1.0
--]]
Jobs = {}

function Jobs.Start()
  CreateThread(function()
    print('Jobs Module started !')
    -- Step 1
    --  Check the job of the player
    TriggerServerEvent("Jobs:checkPlayerJob")
  end)
end

local SALARY_INTERVAL = 15 * 60 * 1000
function Jobs.SalaryLoop()
  print('Jobs: Salary Loop Module started !')
  CreateThread(function()
    while true do
      Wait(SALARY_INTERVAL)
      TriggerServerEvent("Jobs:salary")
    end
  end)
end

Jobs.Start()
