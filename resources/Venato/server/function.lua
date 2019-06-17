Venato = {}

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

DataPlayers = {}

function accessGranded(SteamId, source)
  MySQL.Async.fetchAll("SELECT * FROM users where identifier = @SteamId", {['@SteamId'] = SteamId}, function(DataUser)
    if DataUser[1] == nil then
      DropPlayer(source, "Une erreur s'est produite, si cette dernière persiste contactez un membre du staff.")
    else
      DataPlayers[source] = {
        SteamId = SteamId,
        Source = source,
        Group = DataUser[1].group,
        Nom = DataUser[1].nom,
        Prenom = DataUser[1].prenom,
        Job = DataUser[1].job,
        Bank = DataUser[1].bank,
        Money = DataUser[1].money,
        Position = DataUser[1].lastPosition,
        Sexe = DataUser[1].sexe,
        Taille = DataUser[1].taille,
        Health = DataUser[1].health,
        Food = DataUser[1].food,
        Water = DataUser[1].water,
        Need = DataUser[1].needs,
        Sool = DataUser[1].sool,
        PhoneNumber = DataUser[1].phone_number,
        Pseudo = DataUser[1].pseudo,
        Poid = Venato.Round(DataUser[1].money*0.000075,1),
        Inventaire = {nil},
        PoidMax = 20,
      }
      print("^3SyncData for : "..DataPlayers[source].Prenom.." "..DataPlayers[source].Nom.." ("..DataPlayers[source].Pseudo..")^7")
    end
    TriggerEvent("Inventory:UpdateInventory", source)
  end)
end

function PlayerLeaving(SteamID)
  if DataPlayers ~= nil then
    if DataPlayers[source] ~= nil then
      DataPlayers[source] = nil
    end
  end
end

RegisterNetEvent("Venato:displaytext")
AddEventHandler("Venato:displaytext", function(text, time)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(text)
  DrawSubtitleTimed(time, 1)
end)

RegisterNetEvent("Venato:notify")
AddEventHandler("Venato:notify", function(icon, type, sender, title, text)
  SetNotificationTextEntry("STRING");
  AddTextComponentString(text);
  SetNotificationMessage(icon, icon, true, type, sender, title, text);
  DrawNotification(false, true);
end)

function Venato.Round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
