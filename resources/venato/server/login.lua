local ingame = 0
local whitelistUp = true
MysqlAsyncLoad = false

MySQL.ready(function()
	MysqlAsyncLoad = true
  startScript()
  print("^2MySQL Connector is properly Connected^7")
end)


AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
  local source = source
  local SteamPseudo = playerName
  local SteamId = getSteamID(source)
  deferrals.defer()
  deferrals.update("Checking avant la connexion ...")
  if not MysqlAsyncLoad or SteamId == nil then deferrals.done("Un problème s'est produit, réessayer.") CancelEvent() end
  if whitelistUp then
    local whitelist = MySQL.Sync.fetchScalar("SELECT listed FROM whitelist WHERE identifier=@id", {['@id'] = SteamId})
    if whitelist == nil or tonumber(whitelist) == 0 then
      deferrals.done("Vous n'êtes pas whitelist avec le compte : "..SteamPseudo.." ("..SteamId..")")
      --TriggerEvent('DiscordBot:ToDiscord', logwebwook, 'Père noël', "```fix\nPas whitelist : '"..SteamId.."' ("..SteamPseudo..") \n```", 'http://www.icone-png.com/png/8/8168.png', false)
      CancelEvent()
    end
  end
  local banid = MySQL.Sync.fetchScalar("SELECT reason FROM bans WHERE banned=@id", {['@id'] = SteamId})
  if banid ~= nil then
    deferrals.done("Vous avez été bannis ! Raison : "..banid)
    CancelEvent()
  end
	deferrals.update("Accès validé, bon jeu !")
	Citizen.Wait(2000)
	deferrals.done()
	ingame = ingame + 1
	print('^3Connecting '..playerName.."^7")
end)



AddEventHandler('playerDropped', function(reason)
	local source = source
	local player = getSteamID(source)
	if DataPlayers[source] ~= nil then
		player = DataPlayers[source].SteamId
  	print('^3playerDropped('..reason..'): ' .. player.."^7^7")
  	MySQL.Async.execute("UPDATE user_vehicle SET foufou=1 WHERE owner=@owner AND type =1", {['@owner'] = player})
  	MySQL.Async.execute("UPDATE users SET source=@source WHERE identifier=@identifier", {['@identifier'] =  player, ['@source'] = "disconnect"})
	else
		print('^3Deconnection ('..reason.."): Non Enregistre : "..player.." ^7^7")
	end
	DataPlayers[source] = nil
	ingame = ingame - 1
end)
