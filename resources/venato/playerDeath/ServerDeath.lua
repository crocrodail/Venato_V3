local shooting = {}
local Cause = {}

function GetCauseOfDeath(source)
  return Cause[source]
end

RegisterServerEvent('Death:KillerAreShooting')
AddEventHandler('Death:KillerAreShooting', function(bool)
  local source = source
  shooting[source] = bool
end)

RegisterServerEvent('Death:ComaOrNot')
AddEventHandler('Death:ComaOrNot', function(killer, causeOfDeath)
  local source = source
  Cause[source] = causeOfDeath
  if killer ~= nil then
	  if shooting[killer] == false then
		  TriggerClientEvent("Death:ComaOrNot:cb", source, true)
	  else
		  TriggerClientEvent("Death:ComaOrNot:cb", source, false)
    end
  else
    TriggerClientEvent("Death:ComaOrNot:cb", source, false)
  end
end)

RegisterServerEvent('Death:health')
AddEventHandler('Death:health', function(bool, health)
  local source = source
  local health = health or 100
  if bool then
    health = 0
  end
  DataPlayers[source].Health = health
  MySQL.Async.execute("UPDATE users SET health = @health WHERE identifier = @steamId", {["health"] = health, ["steamId"] = DataPlayers[source].SteamId })
end)
