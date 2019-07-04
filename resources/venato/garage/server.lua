

RegisterNetEvent("Garage:CallAllCar")
AddEventHandler("Garage:CallAllCar", function(garage)
  local source = source  
  garage.vehicles = GetAllCar(source, garage)
  TriggerClientEvent("Garage:AllVehicleBack", source, garage)  
end)

RegisterNetEvent("Garage:GetAllVehicle")
AddEventHandler("Garage:GetAllVehicle", function(garage)
  local source = source
  garage.vehicles = GetAllCar(source, garage)
  TriggerClientEvent("Garage:AllVehicle", source, garage)  
end)

function GetAllCar(source,garage)
  local source = source
  local identifier = DataPlayers[source].SteamId
  result = MySQL.Sync.fetchAll("SELECT * FROM user_vehicle WHERE owner=@username AND (namegarage IS NULL OR namegarage=@namegarage) ORDER BY name ASC ", { ['@username'] = identifier, ["@namegarage"]= garage.name})
  return result
end


RegisterNetEvent("Garage:SortiVehicule")
AddEventHandler("Garage:SortiVehicule", function(plate,model)
  MySQL.Async.execute("UPDATE user_vehicle SET state=1 WHERE model=@model AND plate=@plate", {['@model'] =  model, ['@plate'] = plate})
end)

RegisterNetEvent("Garage:RangeVoiture")
AddEventHandler("Garage:RangeVoiture", function(plate,model,engineHealth,vehicleHealth,garage,veh)
  local source = source
  local table = {}
  table[1] = engineHealth
  table[2] = vehicleHealth
  local health = json.encode(table)
  MySQL.Async.execute("UPDATE user_vehicle SET state=0 , Health=@health, namegarage=@garage WHERE model=@model AND plate=@plate",
  {['@model'] =  model, ['@plate'] = plate, ['@health'] = health, ['@garage'] = garage })
  TriggerClientEvent('Garage:deleteVoiture', source, veh, plate)
end)

RegisterNetEvent("Garage:PlacerEnFouriere")
AddEventHandler("Garage:PlacerEnFouriere", function(plate,model)
  MySQL.Async.execute("UPDATE user_vehicle SET state=2 WHERE model=@model AND plate=@plate", {['@model'] =  model, ['@plate'] = plate})
end)

RegisterServerEvent('garages:storeallvehicles')
AddEventHandler('garages:storeallvehicles', function()
    local identifiers = GetPlayerIdentifiers(source)
    local currentSource = source
    MySQL.Async.execute("UPDATE user_vehicle SET state=2 WHERE owner=@owner AND state=1", {['@owner'] = identifiers[1]})
end)
