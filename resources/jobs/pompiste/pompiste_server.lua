	RegisterServerEvent('pompiste:Car1')
	AddEventHandler('pompiste:Car1', function()
		local source = source
		TriggerClientEvent('pompiste:getCamion',source)
	end)

	RegisterServerEvent('pompiste:Car2')
	AddEventHandler('pompiste:Car2', function()
		local source = source
		TriggerClientEvent('pompiste:getRemorque',source)
	end)

	-- RegisterServerEvent('pompiste:Car2')
	-- AddEventHandler('pompiste:Car2', function()
		-- TriggerClientEvent('pompiste:getCar2',source)
	-- end)

	-- RegisterServerEvent('pompiste:serverRequest')
	-- AddEventHandler('pompiste:serverRequest', function (typeRequest)
	-- 	local mysource=source
	-- 	local UserData = exports.venato:GetDataPlayers()
	-- 	local player = UserData[source].SteamId
	-- 		if typeRequest == "GetPetrol" then
	--
	-- 			MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id=201 AND identifier=@identifier", {['@identifier'] = player},
	-- 				function(qte)
	-- 					TriggerClientEvent('pompiste:drawGetPetrol', mysource, qte)
	-- 				end)
	--
	-- 		elseif typeRequest == "GetEssence" then
	--
	-- 			MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id=201 AND identifier=@identifier", {['@identifier'] = player},
	-- 				function(qtePetrol)
	-- 					MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id=39 AND identifier=@identifier", {['@identifier'] = player},
	-- 						function(qteEssence)
	-- 							TriggerClientEvent('pompiste:drawGetEssence', mysource, qtePetrol, qteEssence)
	-- 						end)
	-- 				end)
	--
	-- 		elseif typeRequest == "SellEssence" then
	--
	-- 			MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id=202 AND identifier=@identifier", {['@identifier'] = player},
	-- 				function(qte)
	-- 					TriggerClientEvent('pompiste:drawSellEssence', mysource, qte)
	-- 				end)
	--
	-- 		else
	-- 			print('DEBUG : Une erreur de type de requête à été détectée')
	-- 		end
	-- end)
