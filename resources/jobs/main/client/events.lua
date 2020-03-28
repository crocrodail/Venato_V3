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
RegisterNetEvent("Jobs:askSalary:cb")

AddEventHandler("Jobs:checkPlayerJob:cb", function(jobId)
  local jobId = 14
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

AddEventHandler("Jobs:salary:cb", function()
  local notification = {}
  notification.title = "Salaire"
  notification.logo = JobsConfig.jobsNotification.logo
  notification.message = "<span class='green--text'>Votre nouveau chèque vous attend</span>"
  TriggerEvent("platypus:notify", notification)
end)

AddEventHandler("Jobs:askSalary:cb", function(primeCo, salary, primeJob, salaryCheck, bonus)
  local notification = {}
  notification.title = "Salaire"
  if (primeCo + salary + primeJob + salaryCheck) > 0 then
    notification.title = notification.title .. " (<span class='green--text'>" ..
      (primeCo + salary + primeJob) * bonus + salaryCheck .. " €</span>)"
    notification.message = "Jour de paie !"
  else
    notification.message = "Attends un peu voyons !"
  end
  notification.logo = JobsConfig.jobsNotification.logo

  if (primeCo + salary + primeJob) > 0 and bonus > 0 then
    notification.message = notification.message .. "<br /><br />Bonus multiplicateur <span class='green--text'>x" .. bonus .. "</span>"
  end
  if primeCo > 0 then
    notification.message = notification.message .. "<br />Prime de temps de service : <span class='green--text'>" .. primeCo .. " €</span>"
  end
  if salary > 0 then
    notification.message = notification.message .. "<br />Salaire reçu : <span class='green--text'>" .. salary .. " €</span>"
    if primeJob > 0 then
      notification.message = notification.message .. " (+ Prime : <span class='green--text'>" .. primeJob .. " €</span>)"
    end
  else
    notification.message = notification.message .. "<br /><span class='orange--text'>Pas de salaire</span>"
  end
  if salaryCheck > 0 then
    notification.message = notification.message .. "<br />Gain des missions : <span class='green--text'>" .. salaryCheck .. " €</span>"
  end
  TriggerEvent("platypus:notify", notification)
end)
