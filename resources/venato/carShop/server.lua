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
  MySQL.Async.fetchAll("SELECT * FROM cars WHERE type = @CarType", { ['@CarType'] = vehicleType }, function(result)
		if result[1] ~= nil then
			for i,v in ipairs(result) do
        car = {["id"] = v.id, ["name"] = v.name, ["model"] = v.model, ["type"] = v.type, ["carShopType"] = v.carShopType, ["price"] = v.price, ["price_vc"] = v.price_vc, ["vc_enabled"] = v.vc_enabled, ["vc_only"] = v.vc_only}
				Cars[v.id] = car
      end
      TriggerClientEvent("CarShop:ShowVehicles:response", source, Cars)
		end
	end)
end)