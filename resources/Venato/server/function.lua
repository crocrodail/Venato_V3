function getSteamID(source)
 	local identifiers = GetPlayerIdentifiers(source)
 	local player = getIdentifiant(identifiers)
 	return player
end

function getIdentifiant(id)
 	for _, v in ipairs(id) do
		return v
	end
end
