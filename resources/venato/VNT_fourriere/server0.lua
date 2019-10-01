local items = {}

RegisterServerEvent("four:getVeh")
AddEventHandler("four:getVeh", function()
    local currentSource = source
    local itemss = {}
    local t = {}
    MySQL.Async.fetchAll("SELECT * FROM user_vehicle WHERE state = 2 AND foufou = 2", {}, function(result)
        if (result) then
            for _, v in ipairs(result) do
                t = { ["name"] = v.name, ["plate"] = v.plate, ["type"] = v.type, ["customs"] = v.customs, ["nom"] = v.nom, ["prenom"] = v.prenom, ["id"] = v.owner, ["idveh"] = v.model }
                -- table.insert(items, tonumber(v.item_id), t)
                itemss[v.plate] = t
            end
        end
        local my = 0
       TriggerClientEvent("four:getItemsVeh", currentSource, itemss, my)
    end)
  end)

  RegisterServerEvent("four:getmyVeh")
  AddEventHandler("four:getmyVeh", function()
      local currentSource = source
      local items = {}
      local bn = {}
      local player = DataPlayers[currentSource].SteamId
      MySQL.Async.fetchAll("SELECT * FROM user_vehicle WHERE state = 2 AND owner = @username ORDER BY nom ASC", { ['@username'] = player }, function(result)
          if (result) then
              for _, v in ipairs(result) do
                  bn = { ["name"] = v.name, ["plate"] = v.plate, ["type"] = v.type, ["customs"] = v.customs, ["nom"] = v.nom, ["prenom"] = v.prenom, ["id"] = v.owner, ["idveh"] = v.model }
                  -- table.insert(items, tonumber(v.item_id), t)
                  items[v.plate] = bn
              end
          end
          local my = 1
         TriggerClientEvent("four:getItemsVeh", currentSource, items, my)
         items = {}
         bn = {}
      end)
  end)


RegisterServerEvent('four:GetIsMeca')
AddEventHandler('four:GetIsMeca', function()
  local source = source
  local nb = 0
  for k,v in pairs(DataPlayers) do
    if v.IsInService[1] == "mecano" and v.IsInService[2] == true then
      nb = nb + 1
    end
  end
  TriggerClientEvent('four:GetIsMeca:cb', source, nb)
end)


RegisterServerEvent('garagesmeca:getvehicle')
AddEventHandler('garagesmeca:getvehicle', function(vhl)
	  local identifiers = id
    local currentSource = source
    local model = tostring(vhl.name)
	  local idveh = vhl.idveh
    local plate = vhl.plate
    TriggerClientEvent('garagesmeca:spawnvehicle', currentSource, vhl)
    MySQL.Async.execute("UPDATE user_vehicle SET state=1 WHERE owner=@owner AND name like @model AND plate like @plate", {['@owner'] = identifiers, ['@model'] =  model, ['@plate'] = plate})
end)

RegisterServerEvent('garagesmeca:getvehiclemy')
AddEventHandler('garagesmeca:getvehiclemy', function(vhl)
    local currentSource = source
	  local paymentCB = Venato.paymentCB(currentSource, 400)
    if paymentCB.status then
      local notif = {
        title= "Fourière",
        logo = "https://static.thenounproject.com/png/72-200.png",
        message = "Vous avez payé 400€.",
      }
      TriggerClientEvent("Venato:notify",currentSource, notif)
      TriggerClientEvent('garagesmeca:spawnvehicle',currentSource,vhl)
      MySQL.Async.execute("UPDATE user_vehicle SET state=1 WHERE owner=@owner AND name = @model AND plate = @plate", {['@owner'] = identifiers, ['@model'] =  vhl.model, ['@plate'] = vhl.plate})
    else
      local notif = {
        title= "Fourière",
        type = "error", --  danger, error, alert, info, success, warning
        logo = "https://static.thenounproject.com/png/72-200.png",
        message = paymentCB.message,
      }
      TriggerClientEvent("Venato:notify",currentSource, notif)
    end
end)
