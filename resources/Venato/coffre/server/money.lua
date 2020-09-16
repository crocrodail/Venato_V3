
RegisterServerEvent("Coffre:DropMoney")
AddEventHandler("Coffre:DropMoney", function(qty, index)
  if tonumber(qty) + DataCoffre[index].argent <= DataCoffre[index].argentcapacite then
    local source = source
    TriggerEvent("Inventory:RemoveMoney", qty, source)
    TriggerEvent("Coffre:SetMoney", DataCoffre[index].argent + qty , index, source)
    TriggerClientEvent("venato:notify", source, "~g~Vous avez déposé "..qty.." € dans le coffre.")    
  else
    TriggerClientEvent("venato:notify", source, "~r~Une erreur est survenue.")
  end
end)

RegisterServerEvent("Coffre:AddMoney")
AddEventHandler("Coffre:AddMoney", function(qty, index)
  if tonumber(qty) + DataCoffre[index].argent <= DataCoffre[index].argentcapacite then
    TriggerEvent("Coffre:SetMoney", DataCoffre[index].argent + qty , index)
  else
    TriggerClientEvent("venato:notifyError", source, "Le coffre est plein.")
  end
end)

RegisterServerEvent("Coffre:TakeMoney")
AddEventHandler("Coffre:TakeMoney", function(qty, index)
  if tonumber(qty) <= DataCoffre[index].argent and venato.MoneyToPoid(qty) + DataPlayers[tonumber(source)].Poid <= DataPlayers[tonumber(source)].PoidMax then
    local source = source
    TriggerEvent("Inventory:AddMoney", qty, source)
    TriggerEvent("Coffre:SetMoney", DataCoffre[index].argent - qty , index, source)
    TriggerClientEvent("venato:notify", source, "~g~Vous avez récuperé "..qty.." € du coffre.")
  else
    TriggerClientEvent("venato:notify", source, "~r~Une erreur est survenue.")
  end
end)

RegisterServerEvent("Coffre:SetMoney")
AddEventHandler("Coffre:SetMoney", function(qty, index)
  local source = source
  if 0 < qty then
    DataCoffre[index].argent = qty
    MySQL.Async.execute("UPDATE coffres SET Argent = @qty WHERE Id = @coffreId", {["@qty"] = qty, ["@coffreId"] = index}, function()
      TriggerClientEvent("Coffre:Open", source, index)
    end)
  else
    DataCoffre[index].argent = 0
    MySQL.Async.execute("UPDATE coffres SET Argent = @qty WHERE Id = @coffreId", {["@qty"] = 0, ["@coffreId"] = index}, function()
      TriggerClientEvent("Coffre:Open", source, index)
    end)
  end
end)