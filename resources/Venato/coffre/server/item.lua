
RegisterServerEvent("Coffre:DropItem")
AddEventHandler("Coffre:DropItem", function(qty, row)
  if tonumber(qty) <= DataPlayers[tonumber(source)].Inventaire[row[2]].quantity and DataCoffre[row[1]].nbItems+qty <= DataCoffre[row[1]].itemcapacite then
    local source = source
    local indexCoffre = row[1]
    local indexItem = row[2]
    local qtyInCoffre = 0
    if DataCoffre[indexCoffre].inventaire[indexItem] ~= nil then
      qtyInCoffre = DataCoffre[indexCoffre].inventaire[indexItem].quantity
    end

    defaultNotification = {
      title = 'Coffre',
      type = "alert",
      logo = DataPlayers[tonumber(source)].Inventaire[row[2]].picture,
      message = "Vous avez déposé "..qty.." "..DataPlayers[tonumber(source)].Inventaire[row[2]].libelle.." dans le coffre."
    }
    TriggerClientEvent("venato:notify", source, defaultNotification)

    TriggerEvent("Inventory:SetItem", DataPlayers[tonumber(source)].Inventaire[indexItem].quantity - qty, indexItem, source)
    TriggerEvent("Coffre:SetItem", indexCoffre, indexItem, qtyInCoffre + qty, source)
  else
    TriggerClientEvent("venato:notify", source, "~r~Une erreur est survenue.")
  end
end)



RegisterServerEvent("Coffre:TakeItems")
AddEventHandler("Coffre:TakeItems", function(qty, row)
  if tonumber(qty) <= DataCoffre[row[1]].inventaire[row[2]].quantity and (DataCoffre[row[1]].inventaire[row[2]].uPoid * tonumber(qty)) + DataPlayers[tonumber(source)].Poid <= DataPlayers[tonumber(source)].PoidMax then
    local source = source
    local indexCoffre = row[1]
    local indexItem = row[2]
    local qtyInCoffre = DataCoffre[indexCoffre].inventaire[indexItem].quantity or 0
    -- Si l'objet n'existe pas le prendre
    local qtyOnPlayer = 0
    if DataPlayers[tonumber(source)].Inventaire[indexItem] then
      qtyOnPlayer = DataPlayers[tonumber(source)].Inventaire[indexItem].quantity
    end

    defaultNotification = {
      title = 'Coffre',
      type = "alert",
      logo = DataCoffre[indexCoffre].inventaire[indexItem].picture,
      message = "Vous avez récuperé "..qty.." "..DataCoffre[indexCoffre].inventaire[indexItem].libelle.." dans le coffre."
    }
    TriggerClientEvent("venato:notify", source, defaultNotification)
    TriggerEvent("Inventory:SetItem",math.floor(qtyOnPlayer + qty), indexItem, source)
    TriggerEvent("Coffre:SetItem", indexCoffre, indexItem, qtyInCoffre - qty, source)
  else
    TriggerClientEvent("venato:notifyError", source, "Une erreur est survenue.")
  end
end)

RegisterServerEvent("Coffre:SetItem")
AddEventHandler("Coffre:SetItem", function(idCoffre, idItem, qty, NewSource)
  local source = source
  local libelle = libelle or "nil"
  local uPoid = uPoid or 0
  local qty = math.floor(qty)
  if NewSource ~= nil then
    source = NewSource
  end
  if 0 < qty then
    if DataCoffre[idCoffre].inventaire[idItem] ~= nil then
      DataCoffre[idCoffre].nbItems = (DataCoffre[idCoffre].nbItems - DataCoffre[idCoffre].inventaire[idItem].quantity) + qty
      DataCoffre[idCoffre].inventaire[idItem].quantity = qty
      MySQL.Async.execute("UPDATE coffres_contenu SET Quantity = @qty WHERE CoffreId = @coffreId AND ItemId = @itemId", {["@qty"] = qty, ["@coffreId"] = idCoffre, ["@itemId"] = idItem})
    else
      MySQL.Async.fetchAll("SELECT * FROM items WHERE id = @itemId", {["@itemId"] = idItem}, function(result)
        if result[1] ~= nil then
          DataCoffre[idCoffre].nbItems = DataCoffre[idCoffre].nbItems + qty
          DataCoffre[idCoffre].inventaire[idItem] = {["coffreId"] = idCoffre, ["itemId"] = idItem, ["libelle"] = result[1].libelle, ["quantity"] = qty, ["uPoid"] = result[1].poid, ["picture"] = result[1].picture,result[1].picture, ['consomable'] = result[1].consomable, ['canBeSellToNPC'] = result[1].canBeSellToNPC  }
          MySQL.Async.execute("INSERT INTO coffres_contenu (`CoffreId`, `ItemId`, `Quantity`) VALUES (@coffreId, @itemId, @qty)", {["@coffreId"] = idCoffre, ["itemId"] = idItem, ["qty"] = qty}, function()
            TriggerClientEvent("Coffre:Open", source, idCoffre)
          end)
        end
      end)
    end
  else
    DataCoffre[idCoffre].nbItems = DataCoffre[idCoffre].nbItems - DataCoffre[idCoffre].inventaire[idItem].quantity
    MySQL.Async.execute("DELETE FROM coffres_contenu WHERE CoffreId = @coffreId AND ItemId = @itemId", {["@coffreId"] = idCoffre, ["@itemId"] = idItem}, function()
      TriggerClientEvent("Coffre:Open", source, idCoffre)
    end)
    DataCoffre[idCoffre].inventaire[idItem] = nil
  end
end)