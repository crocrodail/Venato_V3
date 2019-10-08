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

function checkInventory(source, target)
	local strResult = "Possede : <br/>"
  	local result = MySQL.Sync.fetchAll("SELECT * FROM `user_inventory` JOIN items ON items.id = user_inventory.item_id WHERE identifier = @username", {['@username'] = target})
	  if (result) then
		  for _, v in ipairs(result) do
			  if(v.quantity ~= 0) then
			  	strResult = strResult .. v.quantity .. " de " .. v.libelle .. ", <br/>"
		  	end
		end
	end
	strResult = strResult .. "Armes : <br/>"
	local result = MySQL.Sync.fetchAll("SELECT * FROM `user_weapons` WHERE identifier = @username", { ['@username'] = target})
	if (result) then
		for _, v in ipairs(result) do
			strResult = strResult .. v.weapon_model .. ", <br/>"
		end
	end
	return strResult
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
	local identifier = Venato.GetSteamID(source)
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
					Venato.notify(mysource, defaultNotification)					
				end
			else				
				defaultNotification.message = "Modèle : <span class='yellow--text'>".. model .."</span><br/> Plaque: <span class='yellow--text'>"..plate.."</span> Propriétaire : <span class='green--text'>Moldu</span>"
				Venato.notify(mysource, defaultNotification)				
			end
		end)
end)

RegisterServerEvent('police:confirmUnseat')
AddEventHandler('police:confirmUnseat', function(t)
	local source = source
	defaultNotification.message = GetPlayerName(t).. " est sorti !"
	Venato.notify(source, defaultNotification)
	TriggerClientEvent('police:unseatme', t)
end)

RegisterServerEvent('police:targetCheckInventory')
AddEventHandler('police:targetCheckInventory', function(t)
	local source = source
	local targetSI = Venato.GetSteamID(t)
	
	local info = checkInventory(source, targetSI)

	defaultNotification.message = info
	Venato.notify(source, defaultNotification)		
end)

RegisterServerEvent('police:finesGranted')
AddEventHandler('police:finesGranted', function(t, amount, reason)
	local source = source

	defaultNotification.message = GetPlayerName(t).. " a payé "..amount.."€ d'amende pour " .. reason
	defaultNotification.timeout = 5000
	local paymentCB = Venato.paymentCB(t, amount)
	if paymentCB.status then
		TriggerClientEvent('police:payFines', t, amount, reason)
		TriggerEvent('vnt:chestaddmonney', 20, math.floor(amount/2))		
		Venato.notify(source, defaultNotification)
	else
		defaultNotification.message = paymentCB.message
		Venato.notify(t, defaultNotification)
		defaultNotification.message = "Une erreur est survenue lors du paiement : "..paymentCB.message
		Venato.notify(source, defaultNotification)
	end
end)

RegisterServerEvent('police:cuffGranted')
AddEventHandler('police:cuffGranted', function(t)	
	local source = source
	defaultNotification.message = GetPlayerName(t).. " menotes enlevées !"
	Venato.notify(source, defaultNotification)

	TriggerClientEvent('police:getArrested', t)
end)

RegisterServerEvent('police:cuffGrantedHRP')
AddEventHandler('police:cuffGrantedHRP', function(t)	
	local source = source
	defaultNotification.message = GetPlayerName(t).. " menotes enlevées !"
	Venato.notify(source, defaultNotification)

	TriggerClientEvent('police:getArrestedHRP', t)
end)

RegisterServerEvent('police:forceEnterAsk')
AddEventHandler('police:forceEnterAsk', function(t, v)
	local source = source
	defaultNotification.message = GetPlayerName(t).. "  entre dans la voiture"
	Venato.notify(source, defaultNotification)
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
