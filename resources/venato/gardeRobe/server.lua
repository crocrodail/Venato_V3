RegisterNetEvent("gardeRobe:saveClothes")
AddEventHandler("gardeRobe:saveClothes", function(arg)

	dataPlayer[source].clothes = nil

	MySQL.Async.fetchAll("SELECT * FROM ", {["@id"] = plate}, function(result)
		if result[1] ~= nil then

		end
	end)

	TriggerClientEvent("gardeRobe:saveClothes:cb", source)
end)
