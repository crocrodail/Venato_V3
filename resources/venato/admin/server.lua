RegisterNetEvent("Admin:CallDataUsers")
AddEventHandler("Admin:CallDataUsers", function()
	local source = source
	TriggerClientEvent("Admin:CallDataUsers:cb", source, DataPlayers, source)
end)

RegisterNetEvent("AdminVnT:sendMsG")
AddEventHandler("AdminVnT:sendMsG", function(msg)
	TriggerClientEvent("Venato:notify", -1 , msg)
end)

RegisterNetEvent("Admin:ActionOnPlayer")
AddEventHandler("Admin:ActionOnPlayer", function(action, target, msg)
	local source = source
	if action == "kick" then
		DropPlayer(target, "Vous avez été kick : "..msg)
	else
		MySQL.Async.execute("INSERT INTO bans (`banned`, `banner`, `reason`, `ip`) VALUES (@banned, @banner, @reason, @ip)", {["@banned"] = DataPlayers[target].SteamId, ["@banner"] = DataPlayers[source].SteamId, ["@reason"] = msg, ["@ip"] = DataPlayers[target].Ip}, function()
			DropPlayer(target, "Vous avez été ban : "..msg)
		end)
	end
end)

RegisterNetEvent("vnt:heal")
AddEventHandler("vnt:heal", function(target)
	TriggerClientEvent("vnt:heal:cb", target)
end)

RegisterNetEvent("vnt:resurect")
AddEventHandler("vnt:resurect", function(target)
	TriggerClientEvent("vnt:resurect:cb", target)
end)

RegisterNetEvent('dev:CreateVehiculeInDB')
AddEventHandler('dev:CreateVehiculeInDB', function(model,plate,name,currentVhl)
  local source = source
  local player = getPlayerID(source)
  local customs = {
      color = {
          primary = { type= currentVhl.primary_type, red = currentVhl.primary_red,green= currentVhl.primary_green, blue = currentVhl.primary_blue},
          secondary = { type= currentVhl.secondary_type,  red = currentVhl.secondary_red,green= currentVhl.secondary_green, blue = currentVhl.secondary_blue},
          pearlescent = currentVhl.extra
      },
      wheels = {
          type = 0,
          color = currentVhl.wheelcolor,
      },
      neons = { enabled= 0, red = 255,green= 255, blue = 255},
      windows = 0,
      tyreburst = {enabled=0, red = 255,green= 255, blue = 255},
      mods = {},
  }
  MySQL.Async.execute("INSERT INTO user_vehicle (`owner`, `name`, `model`, `price`, `plate`, `state`, `type`, `customs`, `nom`, `prenom`) VALUES (@username, @name, @vehicle, @price, @plate, @state, @type, @customs, @nom, @prenom)",
      {['@username'] = player, ['@name'] = name, ['@vehicle'] = model, ['@price'] = 100000, ['@plate'] = plate, ['@state'] = 0, ['@type'] = 1, ['@customs'] = json.encode(customs), ['@nom'] = "", ['@prenom'] = "" })
end)

RegisterServerEvent('Admin:tptoelle')
AddEventHandler('Admin:tptoelle', function(id)
  local source = source
  local id = id
	local coord = DataPlayers[id].Position
  TriggerClientEvent('Admin:teleportUser', source, coord)
end)

RegisterServerEvent('Admin:tptome')
AddEventHandler('Admin:tptome', function(id)
  local source = source
  local id = id
  local coord = DataPlayers[id].Position
  TriggerClientEvent('Admin:teleportUser', id, coord)
end)

RegisterServerEvent('Admin:freeze')
AddEventHandler('Admin:freeze', function(id)
  TriggerClientEvent("Admin:freezePlayer", id)
end)
