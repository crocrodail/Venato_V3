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
RegisterNetEvent("Jobs:salary:cb")

AddEventHandler("Jobs:checkPlayerJob:cb", function(jobId)
  JobsConfig.jobId = jobId

  job = JobsConfig.jobs[jobId]
  if job == nil then return end

  -- Step 2
  --  Call initialization of the job
  _G[job.Class].init()

  -- Step 3
  --  Call controls management of the job
  _G[job.Class].commands()

  -- Step 4
  --  Appeler La boucle principale du métier
  _G[job.Class].mainLoop()

  -- Step 5
  --  Appeler la boucle des salaires
  Jobs.SalaryLoop()
end)

AddEventHandler("Jobs:salary:cb", function(primeCo, salary)
  JobsConfig.jobsNotification.message = "Prime de temps de connexion : <span class='green--text'>" .. primeCo .. " €</span> Salaire métier reçu : <span class='green--text'>" .. salary .. " €</span>"
  TriggerEvent("Venato:notify", JobsConfig.jobsNotification)
end)
