UserTable = {}
MysqlAsyncLoad = false
OnlinePlayer = 0
MaxPlayerOnline = 64 -- 32
Rocade = false
InRocade = {}
InServer = {}
MySQL.ready(function ()
	MysqlAsyncLoad = true
end)

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
		deferrals.update(" Connection autorisé, bon jeu !")
		SetTimeout(2500, function()
			deferrals.done()
			CancelEvent()
		end)
	elseif OnlinePlayer == MaxPlayerOnline then
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
						InRocade[SteamId] = nil
						InServer[SteamId] = { id = SteamId, levelLeave = 0 }
						CancelEvent()
					end)
				end)
			end)
		else
			if InRocade then
				placeRocade = #InRocade + 1
			else
				placeRocade = 1
			end
			InRocade[SteamId] = { id = SteamId, place = placeRocade, canEnter = false }
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
						InRocade[SteamId] = nil
						InServer[SteamId] = { id = SteamId, levelLeave = 0 }
						CancelEvent()
					end)
				end)
			end)
		end
	else
		Rocade = true
	end
end

AddEventHandler('playerDropped', PlayerDrop)
AddEventHandler("playerConnecting", PlayerConnecting)
