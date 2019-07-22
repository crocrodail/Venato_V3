RegisterServerEvent('customs:buy')
AddEventHandler('customs:buy', function(data)
    local UserData = exports.venato:GetDatePlayers()
    local datas = json.decode(data)
    local identifiers = UserData[source].SteamId
    local currentSource = source
    local model = tostring(datas.model)
    local plate = string.gsub(datas.plate, "^%s*(.-)%s*$", "%1")
    if Venato.paymentCB(source, datas.price) then
      MySQL.Async.fetchAll("SELECT * FROM user_vehicle WHERE owner=@owner AND model=@model AND plate=@plate ORDER BY name ASC LIMIT 1", {['@owner'] = identifiers[1], ['@model'] =  model, ['@plate'] = plate }, function(vehicle)
        if vehicle[1] then
          vehicle[1].customs = json.decode(vehicle[1].customs)
          if datas.mod == 'neons' or datas.mod == 'xenons' or datas.mod == 'windows' or datas.mod == 'tyreburst' then
            vehicle[1].customs[datas.mod] = datas.value
          elseif type(datas.mod) == 'number' then
            vehicle[1].customs['mods'][tostring(datas.mod)] = datas.value
          elseif datas.mod == 'wheels' then
            vehicle[1].customs['wheels']['type'] = datas.wheeltype
            vehicle[1].customs['wheels']['color'] = datas.wheelcolor
            vehicle[1].customs['wheels']['choice'] = datas.value
          elseif datas.mod == 'color' or datas.mod == 'performance' then
            vehicle[1].customs[datas.mod][datas.type] = datas.value
          elseif datas.mod == "horn" then
            vehicle[1].customs[datas.mod] = datas.value -- + 1
          end
          vehicle[1].customs = json.encode(vehicle[1].customs)
          MySQL.Async.execute("UPDATE user_vehicle SET customs=@mods WHERE owner=@owner AND model=@model AND plate=@plate ORDER BY name ASC LIMIT 1", {
            ['@owner']  = identifiers,
            ['@model']  = model,
            ['@plate']  = plate,
            ['@mods']   = vehicle[1].customs
          }, function(result)
              if result == 1 then
                TriggerClientEvent("Hud:Update", {
                  action = "notify",
                  message = "Ok merci pour tes "..datas.price.."€  t'as besoin d'autre chose ?",
                  type = "success", --  danger, error, alert, info, success, warning,
                  timeout = 3500,
                  logo = "https://img.icons8.com/nolan/96/000000/paint-brush.png",
                  title = "Custom"
                })
                TriggerClientEvent('customs:playsound', currentSource, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET')
              else
                TriggerClientEvent("Hud:Update", {
                  action = "notify",
                  message = "Vous possedez déjà cet addons",
                  timeout = 3500,
                  logo = "https://img.icons8.com/nolan/96/000000/paint-brush.png",
              		type = "error",
              		title = "Erreur",
                })
              end
            end)
        else
          TriggerClientEvent("Hud:Update", {
            action = "notify",
            message = "Véhicule non trouvé dans la base du gouvernement !",
            timeout = 3500,
            logo = "https://img.icons8.com/nolan/96/000000/paint-brush.png",
            type = "error",
            title = "Erreur",
          })
        end
      end)
    else
      TriggerClientEvent("Hud:Update", {
        action = "notify",
        message = "Une érreur s'est produite lors du payement !",
        timeout = 3500,
        logo = "https://img.icons8.com/nolan/96/000000/paint-brush.png",
        type = "error",
        title = "Erreur",
      })
    end
  end)

RegisterServerEvent('customs:checkifowner')
AddEventHandler('customs:checkifowner', function(vehicle)
    local UserData = exports.venato:GetDatePlayers()
    local identifiers = UserData[source].SteamId
    local currentSource = source
    if vehicle.plate ~= nil then
	    local model = tostring(vehicle.model)
	    local plate = string.gsub(vehicle.plate, "^%s*(.-)%s*$", "%1")
	    MySQL.Async.fetchAll("SELECT * FROM user_vehicle WHERE owner=@owner AND model=@model AND plate=@plate ORDER BY name ASC LIMIT 1", {['@owner'] = identifiers, ['@model'] =  model, ['@plate'] = plate }, function(vehicle)

	        if vehicle[1] then
	            TriggerClientEvent('customs:checkifowner_fromdb', currentSource, true)
	        else

	            TriggerClientEvent('customs:checkifowner_fromdb', currentSource, false)
	        end

	    end)
	end

end)

RegisterServerEvent('customs:resetvhl')
AddEventHandler('customs:resetvhl', function(vehicle)
    local UserData = exports.venato:GetDatePlayers()
    local identifiers = UserData[source].SteamId
    local currentSource = source
    if vehicle.plate ~= nil then
	    local model = tostring(vehicle.model)
	    local plate = string.gsub(vehicle.plate, "^%s*(.-)%s*$", "%1")
	    MySQL.Async.fetchAll("SELECT * FROM user_vehicle WHERE owner=@owner AND model=@model AND plate=@plate ORDER BY name ASC LIMIT 1", {['@owner'] = identifiers, ['@model'] =  model, ['@plate'] = plate }, function(vehicle)
	        TriggerClientEvent('customs:resetvhlfromdb', currentSource, vehicle[1])
	    end)
	end

end)
