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
  print("here")
  MySQL.Async.fetchAll("SELECT * FROM users INNER JOIN jobs ON `users`.`job` = `jobs`.`job_id` WHERE identifier = @SteamId", {['@SteamId'] = SteamId}, function(DataUser)--JOIN whitelist ON `users`.`identifier` = `whitelist`.`identifier`
    if DataUser[1] == nil then
      DropPlayer(source, "Une erreur s'est produite, si cette dernière persiste contactez un membre du staff.")
    else
      local sexe = "homme"
      if DataUser[1].sexe == "f" then
        sexe = "femme"
      end
      DataPlayers[source] = {
        SteamId = SteamId,
        Source = source,
        Group = DataUser[1].group,
        Nom = DataUser[1].nom,
        Prenom = DataUser[1].prenom,
        IdJob = DataUser[1].job,
        NameJob = DataUser[1].job_name,
        Bank = DataUser[1].bank,
        Money = DataUser[1].money,
        Account = DataUser[1].account,
        Code = DataUser[1].code,
        Position = DataUser[1].lastPosition,
        Sexe = sexe,
        Taille = DataUser[1].taille,
        Age = os.date("%x",DataUser[1].dateNaissance/1000),
        Health = DataUser[1].health,
        Food = DataUser[1].food,
        Water = DataUser[1].water,
        Need = DataUser[1].needs,
        Sool = DataUser[1].sool,
        PhoneNumber = DataUser[1].phone_number,
        Pseudo = DataUser[1].pseudo,
        Poid = Venato.Round(DataUser[1].money*0.000075,1),
        Inventaire = {nil},
        Weapon = {nil},
        Documents = {nil},
        PoidMax = 20,
        Index = 0,
        VisaStart = nil,
        VisaEnd = nil,
        VisaCanBeReload = false,
        CanBeACitoyen = false,
        PermisVoiture = DataUser[1].permisVoiture,
        PermisCamion = DataUser[1].permisCamion,
        Point = DataUser[1].point,
        Citoyen = 0,
        Url = DataUser[1].url,
      }
      TriggerClientEvent("gcphone:updateBank", source, DataUser[1].bank)
      print("^3SyncData for : "..DataPlayers[source].Prenom.." "..DataPlayers[source].Nom.." ("..DataPlayers[source].Pseudo..")^7")
    end
    TriggerEvent("Inventory:UpdateInventory", source)
    TriggerClientEvent("Blips:Load", source)
    ControlVisa(SteamId, source)
  end)
end

function ControlVisa(SteamId, source)
  local source = source
  MySQL.Async.fetchAll("SELECT * FROM whitelist WHERE identifier = @identifier",{["@identifier"]=SteamId},function(result)
    local num = result[1].listed
    local start = result[1].visadebut
    if  tonumber(num) == 2 then
      DataPlayers[source].CanBeACitoyen = true
    end
    if tonumber(num) == 1 or tonumber(num) == 2 and tonumber(start) == 0 then
      local ts = os.time()
      local tsEnd = ts + 14*24*60*60
      DataPlayers[source].VisaStart = os.date('%d-%m-%Y', ts)
      DataPlayers[source].VisaEnd =  os.date('%d-%m-%Y', tsEnd)
      MySQL.Async.execute("UPDATE whitelist SET visadebut=@ts, visafin=@tsEnd WHERE identifier=@identifier", {["@ts"]=DataPlayers[source].VisaStart,["@tsEnd"]=DataPlayers[source].VisaEnd,["identifier"]=SteamId})
    elseif  tonumber(num) == 1 or tonumber(num) == 2 and tonumber(start) ~= 0 then
      local ts = os.time()
      local d, m, y = start:match '(%d+)-(%d+)-(%d+)'
      local tsStart =os.time{ year = y, month = m, day = d,}
      local testTS = tsStart + 14*24*60*60
      if ts > testTS then
        MySQL.Async.execute("UPDATE whitelist SET listed=0 WHERE identifier=@identifier", {["identifier"]=SteamId})
        DropPlayer(source, "Il semblerait que votre visa à exepiré. Date d'expiration : ("..testTS..")")
      elseif ts > tsStart + 7*24*60*60 then
        DataPlayers[source].VisaCanBeReload = true
      end
    else
      DataPlayers[source].Citoyen = 1
    end
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

RegisterNetEvent("gcphone:callData")
AddEventHandler("gcphone:callData", function()
  TriggerClientEvent("gcphone:callData:cb", source, DataPlayers[source])
end)

function Venato.Round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
