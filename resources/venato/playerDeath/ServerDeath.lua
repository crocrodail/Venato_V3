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
  print(DataPlayers[tonumber(source)].SteamId .. ' mort : '..causeOfDeath.. '(Killer : '..killer..')')
  if killer == 0 then
    TriggerClientEvent("Death:ComaOrNot:cb", source, false)
  else
    if shooting[killer] == true then
		  TriggerClientEvent("Death:ComaOrNot:cb", source, false)
	  else  
	    TriggerClientEvent("Death:ComaOrNot:cb", source, true)
    end
  end
end)

RegisterServerEvent('Death:health')
AddEventHandler('Death:health', function(bool, health)
  local source = source
  local health = health or 200
  if bool == true then
    health = 0
  end
  print('Health : '..health)
  DataPlayers[tonumber(source)].Health = health --- eroor sometime
  MySQL.Async.execute("UPDATE users SET health = @health WHERE identifier = @steamId", {["health"] = health, ["steamId"] = DataPlayers[tonumber(source)].SteamId })
end)
