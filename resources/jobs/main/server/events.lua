--[[
  Client entry point for all job events

  @author Astymeus
  @date 2019-07-28
  @version 1.0
--]]

RegisterServerEvent("Jobs:checkPlayerJob")
RegisterServerEvent("Jobs:salary")
RegisterServerEvent("Jobs:askSalary")

function getSource(source, newSource)
  return newSource or source
end

AddEventHandler("Jobs:checkPlayerJob", function(newSource)
  local source = getSource(source, newSource)
  TriggerClientEvent("Jobs:checkPlayerJob:cb", source, JobsDbFunctions.getPlayerJob(source))
end)

AddEventHandler("Jobs:salary", function(newSource)
  local source = getSource(source, newSource)
  local jobName = JobsDbFunctions.getPlayerJobName(source)
  JobsDbFunctions.newSalary(source)
  TriggerClientEvent("Jobs:salary:cb", source, jobName)
end)

AddEventHandler("Jobs:askSalary", function(newSource)
  local source = getSource(source, newSource)
  local primeConn = JobsConfig.PrimeConnection
  local jobName = JobsDbFunctions.getPlayerJobName(source)
  local salaryCount = tonumber(JobsDbFunctions.getSalaryCount(source))
  local salary, primeJob, salaryCheck = JobsDbFunctions.getPlayerSalary(source)
  JobsDbFunctions.resetSalaryCount(source)

  local factor = 10
  local bonus = ((factor + 1) * salaryCount - 1) / factor -- factor=10 ==> salaryCount=2 => 2,10, salaryCount=3 => 3.20

  if salaryCount == 0 then
    primeConn = 0
    salary = 0
    primeJob = 0
    salaryCheck = 0
    bonus = 1
  end
  if (primeConn + salary + primeJob) * bonus + salaryCheck > 0 then
    TriggerEvent("Inventory:CreateJobCheck", source, (primeConn + salary + primeJob) * bonus + salaryCheck)
  end
  TriggerClientEvent("Jobs:askSalary:cb", source, jobName, primeConn, salary, primeJob, salaryCheck, bonus)
end)
