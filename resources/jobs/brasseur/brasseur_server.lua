

RegisterServerEvent('brasseur:Car')
AddEventHandler('brasseur:Car', function()
	TriggerClientEvent('brasseur:getCar',source)
end)

-- RegisterServerEvent('brasseur:serverRequest')
-- AddEventHandler('brasseur:serverRequest', function (typeRequest)
-- 	local mysource= source
-- 	local UserData = exports.venato:GetDataPlayers()
-- 	local player = UserData[source].SteamId
--
-- 		if typeRequest == "GetOrge" then
-- 			MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id="..brasseur_ressourceBase.." AND identifier=@identifier", {['@identifier'] = player},
-- 				function(qte)
-- 					TriggerClientEvent('brasseur:drawGetOrge', mysource, qte)
-- 				end)
--
-- 		elseif typeRequest == "GetBiere" then
-- 			MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id="..brasseur_ressourceBase.." AND identifier=@identifier", {['@identifier'] = player},
-- 				function(resultBois)
-- 					MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id="..brasseur_ressourceTraite.." AND identifier=@identifier", {['@identifier'] = player},
-- 						function(resultPlanche)
-- 							TriggerClientEvent('brasseur:drawGetBiere',mysource, resultBois, resultPlanche)
-- 						end)
-- 				end)
--
-- 		elseif typeRequest == "SellBiere" then
-- 			MySQL.Async.fetchScalar("SELECT quantity FROM user_inventory WHERE item_id="..brasseur_ressourceTraite.." AND identifier=@identifier", {['@identifier'] = player},
-- 				function(resultBois)
-- 					TriggerClientEvent('brasseur:drawSellBiere', mysource, resultBois)
-- 				end)
-- 		else
-- 			print('DEBUG : Une erreur de type de requête à été détectée')
-- 		end
--
-- end)
