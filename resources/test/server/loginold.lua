UserTable = {}
MysqlAsyncLoad = false
OnlinePlayer = 0
MaxPlayerOnline = 0 -- 32
Rocade = false
InRocade = {}
InServer = {}
idPlayerRocade = 0
MySQL.ready(function ()	MysqlAsyncLoad = true end)

local function PlayerDrop()
OnlinePlayer = OnlinePlayer - 1
end

local function PlayerConnecting(name, setKickReason, deferrals)
	local source = source
	local SteamPseudo = name
	local SteamId = getSteamID(source)
	deferrals.defer()
	deferrals.update("Checking avant la connexion ...")
	if SteamId == nil then deferrals.done("Un problème s'est produit, réessayer.") CancelEvent()end
	if not MysqlAsyncLoad then deferrals.done("Un problème s'est produit, réessayer.") CancelEvent()end
	local whitelist = MySQL.Sync.fetchScalar("SELECT listed FROM whitelist WHERE identifier = @identifier", {['@identifier'] = SteamId})
	if tonumber(whitelist) ~= 1 then deferrals.done("Vous n'êtes pas whitelist avec le compte : "..SteamPseudo.." ("..SteamId..")") CancelEvent()end
	if OnlinePlayer ~= MaxPlayerOnline then
		OnlinePlayer = OnlinePlayer + 1
		if OnlinePlayer == MaxPlayerOnline then
			Rocade = true
		end
		deferrals.update(" Connection autorisé, bon jeu !")
		SetTimeout(2500, function()
			deferrals.done()
			StartConnection(SteamId)
			CancelEvent()
		end)
	elseif Rocade then
		if InRocade[SteamId] then
			if InRocade[SteamId].canEnter or InServer[SteamId] ~= nil then
				deferrals.done()
				StartConnection(SteamId)
				CancelEvent()
			end
		end
		local alredyInRocade = false
		local placeRocade
		for _, v in ipairs(InRocade) do
			if v.id == SteamId then
				alredyInRocade = true
				placeRocade = v.place
			end
		end
		if alredyInRocade then
			deferrals.update(" Vous êtes positionné à la place numéro "..placeRocade)
			SetTimeout(5000, function()
				Citizen.CreateThread(function()
					while not InRocade[SteamId].canEnter do
						deferrals.update(" Vous êtes positionné à la place numéro "..InRocade[SteamId].place.." o O O O O")
						Citizen.Wait(500)
						deferrals.update(" Vous êtes positionné à la place numéro "..InRocade[SteamId].place.." O o O O O")
						Citizen.Wait(500)
						deferrals.update(" Vous êtes positionné à la place numéro "..InRocade[SteamId].place.." O O o O O")
						Citizen.Wait(500)
						deferrals.update(" Vous êtes positionné à la place numéro "..InRocade[SteamId].place.." O O O o O")
						Citizen.Wait(500)
						deferrals.update(" Vous êtes positionné à la place numéro "..InRocade[SteamId].place.." O O O O o")
						Citizen.Wait(500)
					end
					deferrals.update("Une place vient de se libérer. Connexion en cour...")
					SetTimeout(2500, function()
						deferrals.done()
						OnlinePlayer = OnlinePlayer + 1
						StartConnection(SteamId)
						CancelEvent()
					end)
				end)
			end)
		else
			print("ok 1")
			if InRocade then
				placeRocade = #InRocade + 1
			else
				placeRocade = 1
			end
			idPlayerRocade = idPlayerRocade + 1
			InRocade[SteamId] = { id = SteamId, place = placeRocade, canEnter = false, idRocade = idPlayerRocade }
			deferrals.update(" Vous êtes positionné à la place numéro "..placeRocade)
			SetTimeout(5000, function()
				Citizen.CreateThread(function()
					while not InRocade[SteamId].canEnter do
						deferrals.update(" Vous êtes positionné à la place numéro "..InRocade[SteamId].place.." o O O O O")
						Citizen.Wait(500)
						deferrals.update(" Vous êtes positionné à la place numéro "..InRocade[SteamId].place.." O o O O O")
						Citizen.Wait(500)
						deferrals.update(" Vous êtes positionné à la place numéro "..InRocade[SteamId].place.." O O o O O")
						Citizen.Wait(500)
						deferrals.update(" Vous êtes positionné à la place numéro "..InRocade[SteamId].place.." O O O o O")
						Citizen.Wait(500)
						deferrals.update(" Vous êtes positionné à la place numéro "..InRocade[SteamId].place.." O O O O o")
						Citizen.Wait(500)
					end
					deferrals.update("Une place vient de se libérer. Connexion en cour...")
					SetTimeout(2500, function()
						deferrals.done()
						OnlinePlayer = OnlinePlayer + 1
						StartConnection(SteamId)
						CancelEvent()
					end)
				end)
			end)
		end
	else
		Rocade = true
	end
end


local function StartConnection(steamId)
	InServer[SteamId] = { id = SteamId, levelLeave = 0 }
	InRocade[SteamId] = nil
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		for _, v in ipairs(InServer) do
			local SteamId = v.id
			if v.levelLeave == 3 then
				InServer[SteamId] = nil
				OnlinePlayer = OnlinePlayer - 1
				for _, f in ipairs(InRocade) do
					f.place = f.place - 1
					if f.place < 1 and OnlinePlayer ~= MaxPlayerOnline then
						f.canEnter = true
					end
				end
			elseif v.levelLeave ~= 0 then
				local newLevel = v.levelLeave + 1
				InServer[SteamId].levelLeave = newLevel
			end
		end
	end
end)

AddEventHandler('playerDropped', PlayerDrop)
AddEventHandler("playerConnecting", PlayerConnecting)
