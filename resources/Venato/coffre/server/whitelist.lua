
RegisterServerEvent("Coffre:CallWhitelistPlayer")
AddEventHandler("Coffre:CallWhitelistPlayer", function(index, name)
  local source = source
  local users = {}
  MySQL.Async.fetchAll("SELECT * FROM users  WHERE CONCAT(nom,prenom) LIKE '%"..name.."%' AND identifier NOT IN (SELECT UserId FROM coffres_whitelist WHERE CoffreId = "..index..")", {}, function(result)
    if result ~= nil then
      for k,v in pairs(result) do
        users[v.identifier] = {
          ["identifier"] = v.identifier,
          ["nom"] = v.nom,
          ["prenom"] = v.prenom
        }
      end
      TriggerClientEvent("Coffre:CallWhitelistPlayer:cb", source, {index= index, users = users})
    end  
  end)  
end)

RegisterServerEvent("Coffre:CoffreWhitelistPlayer")
AddEventHandler("Coffre:CoffreWhitelistPlayer", function(row)
  local source = source
  local index = row[1]
  local user = row[2]
  
  MySQL.Async.execute("INSERT INTO coffres_whitelist(CoffreId, UserId) VALUES (@coffreId, @userId)", {["@coffreId"] = index, ["@userId"] = user }, function()
    TriggerClientEvent("Coffre:Open", source, index)
  end)
  
end)

RegisterServerEvent("Coffre:UnWhitelist")
AddEventHandler("Coffre:UnWhitelist", function(row)
  local source = source
  local coffreId = row[1]
  local userId = row[2]
  MySQL.Async.execute("DELETE FROM coffres_whitelist WHERE CoffreId = @coffreId AND UserId = @userId", {["@userId"] = userId, ["@coffreId"] = coffreId},function()
    TriggerClientEvent("Coffre:Open", source, coffreId)
  end)  
end)

RegisterServerEvent("Coffre:CheckWhitelist")
AddEventHandler("Coffre:CheckWhitelist", function(coffreId)
  local source = source
  MySQL.Async.fetchAll("SELECT * FROM coffres_whitelist WHERE UserId = @steamId AND CoffreId = @coffreId", {["@steamId"] = getSteamID(source), ["@coffreId"] = coffreId}, function(result)
    TriggerClientEvent("Coffre:CheckWhitelist:cb", source, {status = (result[1] ~= nil)})
  end)
end)

RegisterServerEvent("Coffre:GetCoffreWhitelistPlayer")
AddEventHandler("Coffre:GetCoffreWhitelistPlayer", function(coffreId)
  local source = source
  local whitelist = {}
  MySQL.Async.fetchAll("SELECT CW.*, U.nom, U.prenom FROM coffres_whitelist CW INNER JOIN users U ON CW.UserId = U.identifier  WHERE CW.CoffreId = @coffreId", {["@coffreId"] = coffreId}, function(result)
    if result[1] ~= nil then
      for k,v in pairs(result) do
        whitelist[v.Id] = {
          ["nom"] = v.nom,
          ["prenom"] = v.prenom,
          ["id"] = v.UserId,
          ["coffreId"] = v.CoffreId
        }
      end
    end
    TriggerClientEvent("Coffre:GetCoffreWhitelistPlayer:cb", source, {whitelist = whitelist})
  end)
end)
