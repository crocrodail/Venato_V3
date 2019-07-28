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
