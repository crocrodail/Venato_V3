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

  local job = JobsConfig.jobs[jobId]
  if job == nil then return end
  if not _G[job.Class].isEnabled() then return end

  -- Step 2
  --  Call initialization of the job
  Jobs.init(job)


  Jobs.Commands(job)

  -- Step 4
  --  Appeler La boucle principale du métier
  Jobs.mainLoop(job)

  -- Step 5
  --  Appeler la boucle des salaires
  Jobs.SalaryLoop()
end)

AddEventHandler("Jobs:salary:cb", function(jobName, primeCo, salary, primeJob)
  local notification = {}
  notification.title = jobName
  if salary > 0 then
    notification.title = notification.title .. " (<span class='green--text'>" .. primeCo + salary + primeJob .. " €</span>)"
  end
  notification.logo = JobsConfig.jobsNotification.logo
  notification.message = "Prime de temps de connexion : <span class='green--text'>" .. primeCo .. " €</span>"
  if salary > 0 then
    notification.message = notification.message .. "<br />Salaire reçu : <span class='green--text'>" .. salary .. " €</span>"
    if primeJob > 0 then
      notification.message = notification.message .. " (+ Prime : <span class='green--text'>" .. primeJob .. " €</span>)"
    end
  else
    notification.message = notification.message .. "<br /><span class='orange--text'>Pas de salaire</span>"
  end
  TriggerEvent("Venato:notify", notification)
  JobsConfig.message = "Toto ?"
  TriggerEvent("Venato:notify", JobsConfig.jobsNotification)
end)
