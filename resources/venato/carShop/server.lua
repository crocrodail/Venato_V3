RegisterServerEvent('CarShop:ShowCategory')
AddEventHandler('CarShop:ShowCategory', function(carShopType)
  local source = source
  local Category = {}
  MySQL.Async.fetchAll("SELECT DISTINCT type FROM cars WHERE carShopType = @CarType ORDER BY type", { ['@CarType'] = carShopType }, function(result)
		if result[1] ~= nil then
			for i,v in ipairs(result) do
        car = {["type"] = v.type}
				Category[v.type] = car
      end
      TriggerClientEvent("CarShop:ShowCategory:response", source, Category)
		end
	end)
end)

RegisterServerEvent('CarShop:ShowVehicles')
AddEventHandler('CarShop:ShowVehicles', function(vehicleType)
  local source = source
  local Cars = {}
  MySQL.Async.fetchAll("SELECT * FROM cars WHERE type = @CarType ORDER BY price", { ['@CarType'] = vehicleType }, function(result)
		if result[1] ~= nil then
			for i,v in ipairs(result) do
        car = {["id"] = v.id, ["name"] = v.name, ["model"] = v.model, ["type"] = v.type, ["carShopType"] = v.carShopType, ["price"] = v.price, ["price_vp"] = v.price_vp, ["vp_enabled"] = v.vp_enabled, ["vp_only"] = v.vp_only, ["speed"] = v.speed, ["acceleration"] = v.acceleration, ["braking"] = v.braking, ["handling"] = v.handling}
				Cars[v.id] = car
      end
      TriggerClientEvent("CarShop:ShowVehicles:response", source, Cars)
		end
	end)
end)

RegisterServerEvent("CarShop:BuyVP")
AddEventHandler("CarShop:BuyVP", function(vehicle)  
  local source = source  
  local car = getVehicleById(vehicle.id)
  if Venato.paymentVP(source, car.price_vp) then
    vehicle["price"] = car.price_vp * 100
    AddVehicleToUser(source, vehicle)
    TriggerClientEvent("CarShop:PaiementOk:response", source)
  else
    TriggerClientEvent("CarShop:PaiementKo:response", source)
  end
end)

RegisterServerEvent("CarShop:Buy")
AddEventHandler("CarShop:Buy", function(vehicle)
  print(vehicle.plate)
  local source = source  
  local car = getVehicleById(vehicle.id)
  if Venato.paymentCB(source, car.price) then
    vehicle["price"] = car.price
    AddVehicleToUser(source,vehicle)
    TriggerClientEvent("CarShop:PaiementOk:response", source)
  else
    TriggerClientEvent("CarShop:PaiementKo:response", source)
  end
end)

function AddVehicleToUser(source, vehicle)
  MySQL.Async.execute("INSERT INTO user_vehicle (owner, name, model, price, plate, customs, type) VALUES (@identifier, @name, @model, @price, @plate, @customs, 1)", {["identifier"]=DataPlayers[source].SteamId, ["name"]=vehicle.name, ["model"]=vehicle.model, ["price"]=vehicle.price, ["plate"]=vehicle.plate, ["customs"]=vehicle.customs})
end

function getVehicleById(vehicleId)
  local car = MySQL.Sync.fetchAll("SELECT * FROM cars WHERE id = @CarId", { ['@CarId'] = vehicleId })  
  return car[1]
end

