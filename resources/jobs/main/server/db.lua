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
JobsRequests.getPlayerSalary = "SELECT salary FROM users INNER JOIN jobs ON users.job = jobs.job_id WHERE identifier = @identifier"
JobsRequests.getPlayerPoliceRank = "SELECT rank FROM police WHERE identifier = @username"

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

function JobsDbFunctions.getPlayerSalary(source)
  local salary = MySQL.Sync.fetchScalar(JobsRequests.getPlayerSalary, { ['@identifier'] = getSteamID(source) })
  salary = tonumber(salary)
  primeJob = 0
  if salary then
    local jobId = JobsDbFunctions.getPlayerJob(source)
    jobId = tonumber(jobId)
    if jobId == 2 then
      local rank = JobsDbFunctions.getPlayerPoliceRank(source)
      primeJob = getPrime(rank)
    end
  end
  return salary, primeJob
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
  end
  return prime
end
