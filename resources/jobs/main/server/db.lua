--[[
  Server entry point for all DB requests

  @author Astymeus
  @date 2019-07-28
  @version 1.0
--]]

-- ============= --
--  DB requests  --
-- ============= --
JobsRequests = {}

JobsRequests.getPlayerJob = "SELECT job FROM users WHERE identifier = @identifier"
JobsRequests.getPlayerJobName = "SELECT job_name FROM users INNER JOIN jobs ON users.job = jobs.job_id WHERE identifier = @identifier"
JobsRequests.getPlayerSalary = "SELECT SUM(salary) FROM user_job INNER JOIN jobs ON JobId = job_id WHERE UserId =  @identifier"
JobsRequests.getPlayerSalaryCheck = "SELECT salaryCheck FROM users WHERE identifier = @identifier"
JobsRequests.getPlayerPoliceRank = "SELECT `rank` FROM police WHERE identifier = @identifier"
JobsRequests.getSalaryCount = "SELECT salaryCount FROM users WHERE identifier = @identifier"

JobsRequests.newSalary = "UPDATE users SET salaryCount = salaryCount+1 WHERE identifier = @identifier"
JobsRequests.resetSalaryCount = "UPDATE users SET salaryCount = 0, salaryCheck = 0 WHERE identifier = @identifier"

-- ============= --
-- DB functions  --
-- ============= --
JobsDbFunctions = {}

function getIdentifiant(id)
  for _, v in ipairs(id) do
    return v
  end
end

function getSteamID(source)
  local identifiers = GetPlayerIdentifiers(source)
  return getIdentifiant(identifiers)
end

function JobsDbFunctions.getPlayerJob(source)
  return MySQL.Sync.fetchScalar(JobsRequests.getPlayerJob, { ['@identifier'] = getSteamID(source) })
end

function JobsDbFunctions.getPlayerJobName(source)
  return MySQL.Sync.fetchScalar(JobsRequests.getPlayerJobName, { ['@identifier'] = getSteamID(source) })
end

function JobsDbFunctions.getPlayerPoliceRank(source)
  return MySQL.Sync.fetchScalar(JobsRequests.getPlayerPoliceRank, { ['@identifier'] = getSteamID(source) })
end

function JobsDbFunctions.newSalary(source)
  return MySQL.Sync.fetchScalar(JobsRequests.newSalary, { ['@identifier'] = getSteamID(source) })
end

function JobsDbFunctions.getSalaryCount(source)
  return MySQL.Sync.fetchScalar(JobsRequests.getSalaryCount, { ['@identifier'] = getSteamID(source) })
end

function JobsDbFunctions.resetSalaryCount(source)
  return MySQL.Sync.fetchScalar(JobsRequests.resetSalaryCount, { ['@identifier'] = getSteamID(source) })
end

function JobsDbFunctions.getPlayersSalaryBase(source)
  local salary = MySQL.Sync.fetchScalar(JobsRequests.getPlayerSalary, { ['@identifier'] = getSteamID(source) })
  return tonumber(salary)
end

function JobsDbFunctions.getPlayerSalary(source)
  local salary = MySQL.Sync.fetchScalar(JobsRequests.getPlayerSalary, { ['@identifier'] = getSteamID(source) })
  salary = tonumber(salary)
  local salaryCheck = MySQL.Sync.fetchScalar(JobsRequests.getPlayerSalaryCheck,
    { ['@identifier'] = getSteamID(source) })
  salaryCheck = tonumber(salaryCheck)
  primeJob = 0
  if salary then
    local jobId = JobsDbFunctions.getPlayerJob(source)
    jobId = tonumber(jobId)
    if jobId == 2 then
      local rank = JobsDbFunctions.getPlayerPoliceRank(source)
      primeJob = getPrime(rank)
    end
  end
  return salary, primeJob, salaryCheck
end

function getPrime(rank)
  local prime = 0
  if rank == "Agent" then
    prime = 150
  elseif rank == "Sergent" then
    prime = 300
  elseif rank == "Sergent-Chef" then
    prime = 400
  elseif rank == "Lieutenant" then
    prime = 600
  elseif rank == "Capitaine" then
    prime = 800
  else
    prime = 0
  end
  return prime
end
