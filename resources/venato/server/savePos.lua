RegisterNetEvent("Coords:UpdatePos")
AddEventHandler("Coords:UpdatePos", function(update)
	local source = source
	if update ~= nil and DataPlayers[source] ~= nil then
		DataPlayers[source].Position = update
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(20000)
		local Query = GetQueryPos()
		if Query ~= false then
			MySQL.Async.execute(Query)
		end
	end
end)

function GetQueryPos()
	local notSolo = false
	local query = "UPDATE users SET lastPosition = CASE identifier"
	local where = "WHERE identifier IN ("
	for k,v in pairs(DataPlayers) do
		if v.Position ~= nil then
			query =	query.." WHEN '"..v.SteamId.."' THEN '"..json.encode(v.Position).."'"
			if notSolo then
				where = where..","
			end
			where = where.."'"..v.SteamId.."'"
			notSolo = true
		end
	end
	query = query..' ELSE lastPosition END '..where..");"
	if notSolo == true then
		return query
	else
		return false
	end
end
