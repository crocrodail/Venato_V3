RegisterServerEvent('skin:saveOutfitForNewPlayer')
AddEventHandler('skin:saveOutfitForNewPlayer', function(current_skin)
	local source = source
		MySQL.Async.execute("INSERT INTO skin (identifier, model, head, body_color, hair, hair_color, beard, beard_color, eyebrows, eyebrows_color) VALUES (@id, @a, @b, @c, @d, @e, @f, @g, @h, @i)",
			{
				['@id'] = getSteamID(source),
				['@a']  = current_skin.model,
				['@b']  = tonumber(current_skin.head) or 0,
				['@c']  = tonumber(current_skin.body_color) or 0,
				['@d']  = tonumber(current_skin.hair) or 0,
				['@e']  = tonumber(current_skin.hair_color) or 0,
				['@f']  = tonumber(current_skin.beard) or 0,
				['@g']  = tonumber(current_skin.beard_color) or 0,
				['@h']  = tonumber(current_skin.eyebrows) or 0,
				['@i']  = tonumber(current_skin.eyebrows_color) or 0,
			})
end)
