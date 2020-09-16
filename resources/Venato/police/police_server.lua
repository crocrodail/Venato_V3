local inServiceCops = {}
local nbCops = 0
local defaultNotification = {
	type = "alert",
	title ="LSPD",
	logo = "https://i.ibb.co/K7Cv1Sx/icons8-police-badge-96px.png"
  }

function addCop(identifier)
	MySQL.Async.execute("INSERT INTO police (`identifier`) VALUES (@identifier)", { ['@identifier'] = identifier})
end

function remCop(identifier)
	MySQL.Async.execute("DELETE FROM police WHERE identifier = @identifier", { ['@identifier'] = identifier})
end

RegisterServerEvent('police:removeCop')
AddEventHandler('police:removeCop', function()
	local source = source
	TriggerEvent("es:getPlayerFromId", source, function(user)
		local identifier = user.getIdentifier()
		MySQL.Async.execute("DELETE FROM police WHERE identifier = @identifier", { ['@identifier'] = identifier})
	end)
end)

function checkIsCop(identifier,source)
	MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = @identifier", { ['@identifier'] = identifier},
		function(result)
			if(not result[1]) then
				TriggerClientEvent('police:receiveIsCop', source, "inconnu")
			else
				TriggerClientEvent('police:receiveIsCop', source, result[1].rank)
			end
		end)
end

function s_checkIsCop(identifier)
	MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = @identifier", { ['@identifier'] = identifier},
		function(result)
	if result[1] == nil then
		return "nil"
	else
		return result[1].rank
	end
end)
end

function getIdentifiant(id)

	for _, v in ipairs(id) do
	    return v
	end

end

function checkInventory(source, target, t)
	local inventory = {}
  	local result = MySQL.Sync.fetchAll("SELECT * FROM `user_inventory` JOIN items ON items.id = user_inventory.item_id WHERE identifier = @username", {['@username'] = target})
	  if (result) then
		  for _, v in ipairs(result) do
			  if(v.quantity ~= 0) then
				  inventory[v.id] = v
				  inventory[v.id].isItem = true
				  inventory[v.id].target = target
				  inventory[v.id].targetSource = t
		  	end
		end
	end
	local result = MySQL.Sync.fetchAll("SELECT * FROM `user_weapons` u INNER JOIN weapon wp ON wp.weapon = u.id WHERE u.identifier = @username", { ['@username'] = target})
	if (result) then
		for _, v in ipairs(result) do
			inventory[v.id] = v
			inventory[v.id].isWeapon = true
			inventory[v.id].target = target
			inventory[v.id].targetSource = t
		end
	end
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @username", {['@username'] = target})
	if (result) then
		inventory[-1] = {}
		inventory[-1].money = result[1].money
		inventory[-1].isMoney = true
		inventory[-1].target = t
		inventory[-1].targetSource = t
  	end
	return inventory
end

AddEventHandler('playerDropped', function()
	if(inServiceCops[source]) then
		inServiceCops[source] = nil

		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('police:checkIsCop')
AddEventHandler('police:checkIsCop', function(source)
	local source = source
	local identifier = venato.GetSteamID(source)
	checkIsCop(identifier, source)
end)

RegisterServerEvent('police:msgserv')
AddEventHandler('police:msgserv', function(msg)
		TriggerClientEvent("police:recepMsg", -1, msg)
end)

RegisterServerEvent('police:takeService')
AddEventHandler('police:takeService', function()
	nbCops = nbCops + 1
	if(not inServiceCops[source]) then
		inServiceCops[source] = GetPlayerName(source)

		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('police:breakService')
AddEventHandler('police:breakService', function()
	nbCops = nbCops -1
	if(inServiceCops[source]) then
		inServiceCops[source] = nil

		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('POLICE:coderouge')
AddEventHandler('POLICE:coderouge', function()
TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "CODE ROUGE - Commissariat en code rouge, toute personne approchant dangereusement sera abattu")
end)


RegisterServerEvent('POLICE:fincoderouge')
AddEventHandler('POLICE:fincoderouge', function()
TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "code rouge au commissariat lèvé")
end)


RegisterServerEvent('police:getAllCopsInService')
AddEventHandler('police:getAllCopsInService', function()
	TriggerClientEvent("police:resultAllCopsInService", source, inServiceCops)
end)

RegisterServerEvent('police:getAllCopsInServiceNb')
AddEventHandler('police:getAllCopsInServiceNb', function()
	local mysource = source
	TriggerClientEvent('illegal:setcop', mysource, nbCops)
end)

RegisterServerEvent('police:checkingPlate')
AddEventHandler('police:checkingPlate', function(plate, model)
	local mysource = source
	local plate = plate
	if plate == nil then
	  plate = string.gsub(plate, "^%s*(.-)%s*$", "%1")
	end
	MySQL.Async.fetchAll("SELECT users.nom, users.prenom, user_vehicle.name FROM user_vehicle JOIN users ON user_vehicle.owner = users.identifier WHERE model =@model AND plate like @plate", { ['@plate'] = plate, ['@model'] = model },
		function(result)
			if ( result[1]) then
				for _, v in ipairs(result) do
					defaultNotification.message = "Modèle : <span class='yellow--text'>"..v.name .."</span><br/> Plaque: <span class='yellow--text'>"..plate.."</span> Propriétaire : <span class='yellow--text'>" .. v.nom .. " ".. v.prenom .. "</span>"
					venato.notify(mysource, defaultNotification)					
				end
			else				
				defaultNotification.message = "Modèle : <span class='yellow--text'>".. model .."</span><br/> Plaque: <span class='yellow--text'>"..plate.."</span> Propriétaire : <span class='green--text'>Moldu</span>"
				venato.notify(mysource, defaultNotification)				
			end
		end)
end)

RegisterServerEvent('police:confirmUnseat')
AddEventHandler('police:confirmUnseat', function(t)
	local source = source
	defaultNotification.message = GetPlayerName(t).. " est sorti !"
	venato.notify(source, defaultNotification)
	TriggerClientEvent('police:unseatme', t)
end)

RegisterServerEvent('police:targetCheckInventory')
AddEventHandler('police:targetCheckInventory', function(t, newSource)
	local source = source
	
	if newSource ~= nil then
		source = newSource
	end
	local targetSI = venato.GetSteamID(t)	

	local info = checkInventory(source, targetSI, t)
	TriggerClientEvent('police:targetCheckInventory:cb', source, info)		
end)

RegisterServerEvent('police:finesGranted')
AddEventHandler('police:finesGranted', function(t, amount, reason)
	local source = source

	defaultNotification.message = GetPlayerName(t).. " a payé "..amount.."€ d'amende pour : " .. reason
	defaultNotification.timeout = 5000
	local paymentCB = venato.paymentCB(t, amount, true)
	if paymentCB.status then
		TriggerClientEvent('police:payFines', t, amount, reason)
		TriggerEvent('vnt:chestaddmonney', 20, math.floor(amount/2))		
		venato.notify(source, defaultNotification)
	else
		defaultNotification.message = paymentCB.message
		venato.notify(t, defaultNotification)
		defaultNotification.message = "Une erreur est survenue lors du paiement : "..paymentCB.message
		venato.notify(source, defaultNotification)
	end
end)

RegisterServerEvent('police:cuffGranted')
AddEventHandler('police:cuffGranted', function(t)	
	local source = source
	defaultNotification.message = GetPlayerName(t).. " menotes enlevées !"
	venato.notify(source, defaultNotification)

	TriggerClientEvent('police:getArrested', t)
end)

RegisterServerEvent('police:cuffGrantedHRP')
AddEventHandler('police:cuffGrantedHRP', function(t)	
	local source = source
	defaultNotification.message = GetPlayerName(t).. " menotes enlevées !"
	venato.notify(source, defaultNotification)

	TriggerClientEvent('police:getArrestedHRP', t)
end)

RegisterServerEvent('police:forceEnterAsk')
AddEventHandler('police:forceEnterAsk', function(t, v)
	local source = source
	defaultNotification.message = GetPlayerName(t).. "  entre dans la voiture"
	venato.notify(source, defaultNotification)
	TriggerClientEvent('police:forcedEnteringVeh', t, v)
end)

-----------------------------------------------------------------------
----------------------EVENT SPAWN POLICE VEH---------------------------
-----------------------------------------------------------------------
RegisterServerEvent('CheckPoliceVeh')
AddEventHandler('CheckPoliceVeh', function(vehicle)
	local source = source
	--TriggerEvent('es:getPlayerFromId', source, function(user)

		TriggerClientEvent('FinishPoliceCheckForVeh',source)
		-- Spawn police vehicle
		TriggerClientEvent('policeveh:spawnVehicle', source, vehicle)
	--end)
end)

RegisterServerEvent("police:shootfired")
AddEventHandler("police:shootfired", function(data)
	print("Server: Shootfired")
	for i, c in pairs(inServiceCops) do
		TriggerClientEvent("police:shootfired", i, data)
	end
end)

RegisterServerEvent("police:removeWeapon")
AddEventHandler("police:removeWeapon", function(data)
	local idWeapon = data.id
	local notif = defaultNotification
	notif.message = 'Fouille'
	notif.logo = "https://i.ibb.co/xfFb7R6/icons8-gun-96px.png"
	notif.message = 'Vous êtes fait saisir votre '..data.libelle
	venato.notify(data.targetSource, notif)
	TriggerEvent("Inventory:RemoveWeapon", data.wepond, data.id, data.poid, data.targetSource)
end)

RegisterServerEvent("police:addWeapon")
AddEventHandler("police:addWeapon", function(data)
	local idWeapon = data.id
	local source = source
	TriggerEvent("Inventory:AddWeapon", data.weapond,  data.balles, data.poid, data.libelle, source)
end)