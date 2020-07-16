local seatsTaken = {}

RegisterNetEvent('venato_sit:takePlace')
AddEventHandler('venato_sit:takePlace', function(objectCoords)
	seatsTaken[objectCoords] = true
end)

RegisterNetEvent('venato_sit:leavePlace')
AddEventHandler('venato_sit:leavePlace', function(objectCoords)
	if seatsTaken[objectCoords] then
		seatsTaken[objectCoords] = nil
	end
end)

venato.RegisterServerCallback('venato_sit:getPlace', function(source, cb, objectCoords)
	cb(seatsTaken[objectCoords])
end)
