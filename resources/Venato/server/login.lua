--##### CONFIG #######
local maxSlots = 50
local timeToWaitForReconnection = 120
--####################--

local saturation = 0
local ingame = 0
local infotraf = 0
local levier = 2
local ControleRocade = false
local waiter = 0
local reset = 0
local leaving = 0
local startConnection = 0
local timer = timeToWaitForReconnection / 3
local rlyTimer = math.ceil(timer)
local RocadeWebWook = "https://discordapp.com/api/webhooks/545040083854557209/a1K8VIBQAmyD7-3k38_PTNgHOJ5vDCA7HXyXaNitNPaf_7aEEdZuB-uu4A-txhZr7A2G"
local logwebwook = 'https://discordapp.com/api/webhooks/544557612528697354/igmzuvoOtCPS2QloCcLF2LhdZR4IOzOJNHKAQ3vJ-8si-CFoIF7YizebgWrh9ttONQm9'
local RocadeName = 'Jannine  controleuse routière'
local RocadeAvatar = "https://image.ibb.co/kU7u38/B9714742036_Z_1_20180213135520_000_GIBAL3_SH0_1_0.jpg"
local text1 = "~r~Le serveur reboot dans 30 minutes !"
local text2 = "~r~Le serveur reboot dans 15 minutes !"
local text3 = "~r~Le serveur reboot dans 5 minutes !"
local text4 = "~r~Le serveur reboot dans 4 minutes !"
local text5 = "~r~Le serveur reboot dans 3 minutes !"
local text6 = "~r~Le serveur reboot dans 2 minutes !"
local text7 = "~r~Le serveur reboot dans 1 minutes !"
local traf = 0
local whitelistUp = true
Players = {}
MysqlAsyncLoad = false
MySQL.ready(function ()	MysqlAsyncLoad = true print("^2MySQL Connector is properly Connected^7")end)


AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
  local source = source
  local SteamPseudo = playerName
  local SteamId = getSteamID(source)
  deferrals.defer()
  deferrals.update("Checking avant la connexion ...")
  if not MysqlAsyncLoad and SteamId == nil then deferrals.done("Un problème s'est produit, réessayer.") CancelEvent() end
  if whitelistUp then
    local whitelist = MySQL.Sync.fetchScalar("SELECT listed FROM whitelist WHERE identifier=@id", {['@id'] = SteamId})
    if whitelist ~= nil and tonumber(whitelist) ~= 1 then
      deferrals.done("Vous n'êtes pas whitelist avec le compte : "..SteamPseudo.." ("..SteamId..")")
      TriggerEvent('DiscordBot:ToDiscord', logwebwook, 'Père noël', "```fix\nPas whitelist : '"..SteamId.."' ("..SteamPseudo..") \n```", 'http://www.icone-png.com/png/8/8168.png', false)
      CancelEvent()
    end
  end
  local banid = MySQL.Sync.fetchScalar("SELECT reason FROM bans WHERE banned=@id", {['@id'] = SteamId})
  if banid ~= nil then
    deferrals.done("Vous avez été bannis ! Raison : "..banid)
    CancelEvent()
  end
  if ControleRocade == true then
    local wlrocade = MySQL.Sync.fetchScalar("SELECT identifier FROM Whitelist_Rocade WHERE identifier=@id", {['@id'] = SteamId})
    if wlrocade == nil then
      local inRocade = MySQL.Sync.fetchScalar("SELECT idDiscord FROM rocade WHERE identifier=@identifier", {['@identifier'] = SteamId})
      if inRocade == nil then
        local countid = MySQL.Sync.fetchScalar("SELECT COUNT(identifier) FROM rocade ORDER BY id asc", {})
        if countid ~= nil then
          local position = nil
          local placement = countid + 1
          math.randomseed(os.clock()*100000000000)
          local idDiscord = math.random(10000)
          inserWLrocade(SteamId, idDiscord)
          if placement  ==  1 then
            position = "1er"
          else
            position = placement.."eme"
          end
          TriggerEvent('DiscordBot:ToDiscord', RocadeWebWook, RocadeName, '```fix\nLe vehicule numero '..idDiscord..' a rejoint la rocade a la '..position..' place \n```', RocadeAvatar, false)
          deferrals.update("Vous etes positionné en "..position.." places dans la rocade. Vous pouvez suivre l'info trafic sur votre aplis Discord. L'id de votre véhicule dans la rocade est le : "..idDiscord)
        end
      else
        local idDiscord = inRocade[1].idDiscord
        local bonsoir = MySQL.Sync.fetchScalar("SELECT COUNT(id) FROM rocade WHERE id < @id ORDER BY id asc", {['@id'] = inRocade[1].id})
        if bonsoir ~= nil then
          local position = nil
          local placement = bonsoir + 1
          if placement  ==  1 then
            position = "1er"
          else
            position = placement.."eme"
          end
          deferrals.update("Vous etes positionné en "..position.." places dans la rocade. Vous pouvez suivre l'info trafic sur votre aplis Discord. Votre ID info est le : "..idDiscord)
        end
      end
    else
      deferrals.done()
      accessGranded(SteamId, source)
      MySQL.Async.execute("UPDATE Whitelist_Rocade SET wait=@wait WHERE identifier=@identifier", {['@wait'] =  "0", ['@identifier'] = SteamId})
    end
  else
    if (ingame + 1) == maxSlots then
      ControleRocade = true
      if traf == 0 then
        TriggerEvent('DiscordBot:ToDiscord', RocadeWebWook, RocadeName, '```css\nLe trafic se densifie !  \n```', RocadeAvatar, false)
        traf = 1
      end
    end
    local wlrocade = MySQL.Sync.fetchScalar("SELECT identifier FROM Whitelist_Rocade WHERE identifier=@id", {['@id'] = SteamId})
    if wlrocade == nil then
      MySQL.Async.execute("INSERT INTO whitelist_rocade (`identifier`, `wait`) VALUES (@identifier, @wait)",{ ['@identifier'] = SteamId, ['@wait'] = "0" })
      ingame = ingame + 1
    else
      deferrals.done()
      accessGranded(SteamId, source)
      MySQL.Async.execute("UPDATE Whitelist_Rocade SET wait=@wait WHERE identifier=@identifier", {['@identifier'] =  SteamId, ['@wait'] = "0"})
    end
  end
  TriggerClientEvent("discord:info", -1, ingame)
end)



AddEventHandler('playerDropped', function(reason)
  if startConnection == 1 then
    local player = getPlayerID(source)
    if player == nil then
      player = Venato.identifier(source)
    end
    if player == nil then
      player = tableau[source]
    end
    print('playerDropped('..reason..'): ' .. player)
    MySQL.Async.execute("UPDATE user_vehicle SET foufou=1 WHERE owner=@owner AND type =1", {['@owner'] = player})
    MySQL.Async.execute("UPDATE users SET source=@source WHERE identifier=@identifier", {['@identifier'] =  player, ['@source'] = "disconnect"})
    MySQL.Async.execute("UPDATE Whitelist_Rocade SET wait=@wait WHERE identifier=@identifier", {['@identifier'] =  player, ['@wait'] = "1"})
    PlayerLeaving(player)
  end
end)

RegisterServerEvent('ConfirmationConnection')
AddEventHandler('ConfirmationConnection', function()
  local source = source
  local player = getPlayerID(source)
  MySQL.Async.execute("UPDATE Whitelist_Rocade SET wait=@wait WHERE identifier=@identifier", {['@identifier'] =  player, ['@wait'] = "0"})
end)


function getPlayerID(source)
 	local identifiers = GetPlayerIdentifiers(source)
 	local player = getIdentifiant(identifiers)
 	return player
end

function getIdentifiant(id)
 	for _, v in ipairs(id) do
		return v
	end
end

function inserWLrocade(a, b)
    MySQL.Async.execute("INSERT INTO rocade (`identifier`,`idDiscord`) VALUES ( @identifier, @idDiscord)", {['@identifier'] = a, ['@idDiscord'] = b})
end


function boucle()


    local date_local = os.date('%H:%M:%S', os.time())
    if date_local == '04:30:00' then
      TriggerClientEvent("es_freeroam:notify", -1, "CHAR_LIFEINVADER", 1, "SERVEUR", false, text1)
    elseif date_local == '04:45:00' then
      TriggerClientEvent("es_freeroam:notify", -1, "CHAR_LIFEINVADER", 1, "SERVEUR", false, text2)
    elseif date_local == '04:55:00' then
      TriggerClientEvent("es_freeroam:notify", -1, "CHAR_LIFEINVADER", 1, "SERVEUR", false, text3)
    elseif date_local == '04:56:00' then
      TriggerClientEvent("es_freeroam:notify", -1, "CHAR_LIFEINVADER", 1, "SERVEUR", false, text4)
    elseif date_local == '04:57:00' then
      TriggerClientEvent("es_freeroam:notify", -1, "CHAR_LIFEINVADER", 1, "SERVEUR", false, text5)
    elseif date_local == '04:58:00' then
      TriggerClientEvent("es_freeroam:notify", -1, "CHAR_LIFEINVADER", 1, "SERVEUR", false, text6)
    elseif date_local == '04:59:00' then
      TriggerClientEvent("es_freeroam:notify", -1, "CHAR_LIFEINVADER", 1, "SERVEUR", false, text7)
    elseif date_local == '04:59:58' then
      TriggerEvent('DiscordBot:ToDiscord', RocadeWebWook, RocadeName, "**L'autoroute ferme momentanément !**", RocadeAvatar, false)
    elseif date_local == '19:30:00' then
      TriggerClientEvent("es_freeroam:notify", -1, "CHAR_LIFEINVADER", 1, "SERVEUR", false, text1)
    elseif date_local == '19:45:00' then
      TriggerClientEvent("es_freeroam:notify", -1, "CHAR_LIFEINVADER", 1, "SERVEUR", false, text2)
    elseif date_local == '19:55:00' then
      TriggerClientEvent("es_freeroam:notify", -1, "CHAR_LIFEINVADER", 1, "SERVEUR", false, text3)
    elseif date_local == '19:56:00' then
      TriggerClientEvent("es_freeroam:notify", -1, "CHAR_LIFEINVADER", 1, "SERVEUR", false, text4)
    elseif date_local == '19:57:00' then
      TriggerClientEvent("es_freeroam:notify", -1, "CHAR_LIFEINVADER", 1, "SERVEUR", false, text5)
    elseif date_local == '19:58:00' then
      TriggerClientEvent("es_freeroam:notify", -1, "CHAR_LIFEINVADER", 1, "SERVEUR", false, text6)
    elseif date_local == '19:59:00' then
      TriggerClientEvent("es_freeroam:notify", -1, "CHAR_LIFEINVADER", 1, "SERVEUR", false, text7)
    elseif date_local == '04:59:58' then
      TriggerEvent('DiscordBot:ToDiscord', RocadeWebWook, RocadeName, "**L'autoroute ferme momentanément !**", RocadeAvatar, false)
    end


  waiter = waiter + 1
  leaving = leaving + 1

  if leaving == rlyTimer then
    local count = MySQL.Sync.fetchScalar("SELECT COUNT(identifier) FROM Whitelist_Rocade WHERE wait=@wait", {['@wait'] = "3"})
    if count ~= nil and tonumber(count) ~= 0 then
      MySQL.Sync.execute("DELETE from Whitelist_Rocade WHERE wait = @wait", {['@wait'] = "3"})
      ingame = ingame - count
    end
  end

if  leaving == rlyTimer + 2 then
    MySQL.Async.fetchScalar("SELECT wait FROM Whitelist_Rocade WHERE wait=@wait", {['@wait'] = "2"}, function(resultwaito)
      if resultwaito ~= nil then
        MySQL.Async.execute("UPDATE Whitelist_Rocade SET wait=@setwait WHERE wait=@wait", {['@setwait'] =  "3", ['@wait'] = "2"})
      end
    end)
  end

if  leaving == rlyTimer + 4 then
  MySQL.Async.fetchScalar("SELECT wait FROM Whitelist_Rocade WHERE wait=@wait", {['@wait'] = "1"}, function(resultwaitone)
    if resultwaitone ~= nil then
      MySQL.Async.execute("UPDATE Whitelist_Rocade SET wait=@setwait WHERE wait=@wait", {['@setwait'] =  "2", ['@wait'] = "1"})
    end
  end)
  leaving = 0
end

 if ingame < 30 and traf == 1 then
   TriggerEvent('DiscordBot:ToDiscord', RocadeWebWook, RocadeName, '```\nLe trafic se fluidifie !  \n```', RocadeAvatar, false)
   traf = 0
 end

    if ControleRocade == true and waiter >= 20 then
      waiter = 0
      if ingame ~= maxSlots then
        MySQL.Async.fetchAll("SELECT * FROM rocade ORDER BY id asc", nil, function(result)
        if result[1] ~= nil then
          local vehId = result[1].idDiscord
          MySQL.Async.execute("INSERT INTO Whitelist_Rocade (`identifier`,`wait`) VALUES (@username,@wait)", {['@username'] = result[1].identifier, ['@wait'] = "1"})
        --  MySQL.Async.execute("UPDATE Whitelist_Rocade SET wait=@wait WHERE identifier=@identifier", {['@wait'] =  "1", ['@identifier'] = result[1].identifier})
          MySQL.Async.execute("DELETE from rocade WHERE identifier = @username", {['@username'] = result[1].identifier})
          ingame = ingame + 1
          TriggerEvent('DiscordBot:ToDiscord', RocadeWebWook, RocadeName, '```diff\nLe vehicule n° '..vehId.." est sorti des bouchons et il peut maintenant rejoindre la ville \n```", RocadeAvatar, false)
          waiter = 20
          TriggerClientEvent("discord:info", -1, ingame)
          listRocade()
        else
          ControleRocade = false
        end
        end)
      end
    end
TriggerClientEvent("discord:info", -1, ingame)
end


Citizen.CreateThread(function()
	while true do
		boucle()
		Citizen.Wait(1000)
	end
end)



function listRocade()
  if infotraf ~= 1 then
  infotraf = 1
  SetTimeout(60000, function()
  MySQL.Async.fetchAll("SELECT * FROM rocade ORDER BY id asc", nil, function(result)
    if result[1] ~= nil then
      local message = ""
      for i,vastendemonscript in pairs(result) do
				local a = "eme"
				if i == 1 then
					a = "er"
				end
			  message = message.." \n * "..i.. ""..a..' Véhicule numero : '..result[i].idDiscord
			end
      if message ~= "" then
        TriggerEvent('DiscordBot:ToDiscord', RocadeWebWook, RocadeName, '```fix\n # Info trafic\n'..message..'```', RocadeAvatar, false)
      end
    else
      print('pb mec')
    end
    infotraf = 0
  end)
end)
end
end


RegisterServerEvent('startConnection')
AddEventHandler('startConnection', function()
  MySQL.Async.execute("DELETE from rocade", nil)
  MySQL.Async.execute("DELETE from Whitelist_Rocade", nil)
  startConnection = 1
  TriggerEvent('DiscordBot:ToDiscord', RocadeWebWook, RocadeName, '**Autoroute ouverte ! :D**', RocadeAvatar, false)
end)

RegisterServerEvent('debugvnt')
AddEventHandler('debugvnt', function()
  print(ingame.." ingame")
  print(infotraf.." infostraf")
  print(traf.."  traf")
end)

RegisterServerEvent('dolevier')
AddEventHandler('dolevier', function(a)
  levier = tonumber(a)
end)

RegisterServerEvent('setMaxSlot')
AddEventHandler('setMaxSlot', function(a)
  maxSlots = tonumber(a)
end)
