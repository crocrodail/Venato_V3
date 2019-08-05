--[[
  Client entry point for all job events

  @author Astymeus
  @date 2019-07-28
  @version 1.0
--]]

RegisterServerEvent("Jobs:checkPlayerJob")
RegisterServerEvent("Jobs:salary")

function getSource(source, newSource)
  return newSource or source
end

AddEventHandler("Jobs:checkPlayerJob", function(newSource)
  local source = getSource(source, newSource)
  TriggerClientEvent("Jobs:checkPlayerJob:cb", source, JobsDbFunctions.getPlayerJob(source))
end)

AddEventHandler("Jobs:salary", function(newSource)
  local source = getSource(source, newSource)
  local primeConn = JobsConfig.PrimeConnection
  local jobName = JobsDbFunctions.getPlayerJobName(source)
  local salary, primeJob = JobsDbFunctions.getPlayerSalary(source)
  TriggerEvent("Inventory:AddMoney", primeConn + salary + primeJob, source)
  TriggerClientEvent("Jobs:salary:cb", source, jobName, primeConn, salary, primeJob)
end)
