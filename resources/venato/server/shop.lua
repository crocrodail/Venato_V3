local RequetgetContentItem = "SELECT c.Quantity, c.Price, c.ItemId, it.poid, it.libelle " ..
  "FROM shop_content c " ..
  "INNER JOIN items it on c.ItemId = it.id " ..
  "WHERE c.Id=@Id"

RegisterServerEvent("Shops:TestBuy")
AddEventHandler("Shops:TestBuy", function(ContentId, shopId, quantity, newSource)
  local source = source or newSource
  local _quantity = quantity or 1
	local currentPlayerMoney = DataPlayers[source].Money
  local steamId = DataPlayers[source].SteamId
  local DataUsers = DataPlayers
  MySQL.Async.fetchAll(RequetgetContentItem, { ["@Id"] = ContentId }, function(content)
		local totalPrice = _quantity * content[1].Price
	  local totalPoid = _quantity * content[1].poid
  	if totalPrice > currentPlayerMoney then
    	TriggerClientEvent("Shops:NotEnoughMoney", source, content[1].libelle)
  	elseif content[1].Quantity >= 0 and content[1].Quantity < _quantity then
    	TriggerClientEvent("Shops:NotEnoughQuantity", source, content[1].libelle)
  	elseif DataUsers[source].PoidMax < (DataUsers[source].Poid + totalPoid) then
    	TriggerClientEvent("Shops:TooHeavy", source, content[1].libelle)
  	else
    	TriggerEvent("Inventory:AddItem", _quantity, content[1].ItemId, source)
    	if content[1].Quantity > 0 then
      	TriggerEvent("Shops:RemoveItem", _quantity, ContentId)
    	end
    	TriggerEvent("Inventory:RemoveMoney", totalPrice, source)
    	TriggerEvent("Shops:AddMoney", totalPrice, shopId)
    	TriggerClientEvent("Shops:TestBuy:cb", source, content[1].libelle)
		end
  end)
end)
