RegisterNetEvent("Coords:UpdatePos")
AddEventHandler("Coords:UpdatePos", function(update)
	local source = source
	DataPlayers[source].Position = update
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
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
		query =	query.." WHEN '"..v.SteamId.."' THEN '"..json.encode(v.Position).."'"
		if notSolo then
			where = where..","
		end
		where = where.."'"..v.SteamId.."'"
		notSolo = true
	end
	query = query..' ELSE lastPosition END '..where..");"
	if notSolo == true then
		return query
	else
		return false
	end
end
