--[[
  Client entry point for all job events

  @author Astymeus
  @date 2019-07-28
  @version 1.0
--]]

-- ==================== --
-- Callback from Server --
-- ==================== --

RegisterNetEvent("Jobs:checkPlayerJob:cb")

AddEventHandler("Jobs:checkPlayerJob:cb", function(jobId)
  ConfigJobs.jobId = jobId

  job = ConfigJobs.jobs[jobId]
  if job == nil then return end

  -- Step 2
  --  Call initialization of the job
  _G[job.Class].init()

  -- Step 3
  --  Call controls management of the job
  _G[job.Class].commands()
end)
