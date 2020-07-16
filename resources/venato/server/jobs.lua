RegisterServerEvent('vigneron:serverRequest')
AddEventHandler('vigneron:serverRequest', function (typeRequest)
	local mysource = source
	local player = DataPlayers[mysource].SteamId

		if typeRequest == "GetRaisin" then
			MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id=26 AND identifier=@identifier", {['@identifier'] = player},
				function(qte)
					TriggerClientEvent('vigneron:drawGetRaisin', mysource, qte)
				end)

		elseif typeRequest == "GetVin" then
			MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id=26 AND identifier=@identifier", {['@identifier'] = player},
				function(qteVign)

					MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id=27 AND identifier=@identifier", {['@identifier'] = player},
						function(qteTraite)
							TriggerClientEvent('vigneron:drawGetVin',mysource, qteVign, qteTraite)
						end)
				end)

		elseif typeRequest == "SellVin" then
			MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id=27 AND identifier=@identifier", {['@identifier'] = player},
				function(qte)
					TriggerClientEvent('vigneron:drawSellVin', mysource, qte)
				end)
		else
			print('DEBUG : Une erreur de type de requête à été détectée')
		end

end)

RegisterServerEvent('pompiste:serverRequest')
AddEventHandler('pompiste:serverRequest', function (typeRequest)
	local mysource=source
	local player = DataPlayers[mysource].SteamId
		if typeRequest == "GetPetrol" then

			MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id=201 AND identifier=@identifier", {['@identifier'] = player},
			function(qte)
				TriggerClientEvent('pompiste:drawGetPetrol', mysource, qte)
			end)

		elseif typeRequest == "GetEssence" then

			MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id=201 AND identifier=@identifier", {['@identifier'] = player},
				function(qtePetrol)
					MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id=39 AND identifier=@identifier", {['@identifier'] = player},
						function(qteEssence)
							TriggerClientEvent('pompiste:drawGetEssence', mysource, qtePetrol, qteEssence)
						end)
				end)

		elseif typeRequest == "SellEssence" then

			MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id=202 AND identifier=@identifier", {['@identifier'] = player},
				function(qte)
					TriggerClientEvent('pompiste:drawSellEssence', mysource, qte)
				end)

		else
			print('DEBUG : Une erreur de type de requête à été détectée')
		end
end)

RegisterServerEvent('brasseur:serverRequest')
AddEventHandler('brasseur:serverRequest', function (typeRequest)
	local mysource= source
	local player = DataPlayers[mysource].SteamId

	if typeRequest == "GetOrge" then
		MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id=24 AND identifier=@identifier", {['@identifier'] = player},
			function(qte)
				TriggerClientEvent('brasseur:drawGetOrge', mysource, qte)
			end)

	elseif typeRequest == "GetBiere" then
		MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id=24 AND identifier=@identifier", {['@identifier'] = player},
			function(resultOrge)
				MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id=25 AND identifier=@identifier", {['@identifier'] = player},
					function(resultBiere)
						TriggerClientEvent('brasseur:drawGetBiere',mysource, resultOrge, resultBiere)
					end)
			end)

	elseif typeRequest == "SellBiere" then
		MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id=25 AND identifier=@identifier", {['@identifier'] = player},
			function(resultOrge)
				TriggerClientEvent('brasseur:drawSellBiere', mysource, resultOrge)
			end)
	else
		print('DEBUG : Une erreur de type de requête à été détectée')
	end

end)
