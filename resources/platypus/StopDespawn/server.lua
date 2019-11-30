-- Debug printer
function dprint(msg)
	if debugMode then
		print(msg)
	end
end

local vehicles = {} -- Table where all the vehicle data will be saved.

RegisterServerEvent('sd:removeId')
AddEventHandler('sd:removeId', function(vehiclePlate)
	print('remove Id : '.. vehiclePlate)
	for i=1,#vehicles,1 do
		if vehicles[i].plate == vehiclePLate then
			table.remove(vehicles, i)
		end
	end
end)

-- Completes the saving by inserting all the info in the table.
function insert(index, id, model, x, y, z, heading, plate, health)
	vehicles[index] = {
		['id'] = id,
		['model'] = model,
		['position'] = {
			['x'] = x,
			['y'] = y,
			['z'] = z
		},
		['heading'] = heading,
		['plate'] = plate,
		['health'] = health
	}

	MySQL.Async.fetchAll("SELECT * FROM user_vehicle WHERE plate = @plate", { ['@plate'] = plate }, function(result)
        if (result) then
		  if(result[1]) then
			vehicles[index]['customs'] = result[1].customs
		  end    
        end
    end)
end

-- Event to evaluate where should every vehicle be saved in the table.
RegisterServerEvent('sd:save')
AddEventHandler('sd:save', function(id, model, x, y, z, heading, plate, health)
	if vehicles[1] then
		for i=1,#vehicles,1 do
			if vehicles[i].plate == plate then
				insert(i, id, model, x, y, z, heading, plate, health)
				dprint(model .. '(' .. plate ..' - ' .. id ..')' .. 'updated!')
				break
			elseif i == #vehicles then
				insert(#vehicles+1, id, model, x, y, z, heading, plate, health)
				dprint(model .. '(' .. plate ..' - ' .. id ..')' .. 'added!')
			end
		end
	else
		insert(#vehicles+1, id, model, x, y, z, heading, plate, health)
		dprint(model .. '(' .. plate ..' - ' .. id ..')' .. 'added!')
	end
end)

RegisterServerEvent('sd:retrieveTable')
AddEventHandler('sd:retrieveTable', function()
	dprint('Checking vehicles...' .. #vehicles)
	TriggerClientEvent('sd:checkVehs', GetPlayers()[1], vehicles)
end)

AddEventHandler('EnteredVehicle')