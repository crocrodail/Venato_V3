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

function GetDataPlayers()
  return DataPlayers
end

RegisterNetEvent("Venato:SyncData")
AddEventHandler("Venato:SyncData", function(steam, newSource)
  local source = newSource or source
  local steam = steam or getSteamID(source)
  accessGranded(steam, source)
end)

DataPlayers = {}

function accessGranded(SteamId, source , balek)
  MySQL.Async.fetchAll("SELECT * FROM users "..
   "LEFT JOIN jobs ON `users`.`job` = `jobs`.`job_id` "..
   "LEFT JOIN skin ON `users`.`identifier` = `skin`.`identifier` "..
   "WHERE users.identifier = @SteamId", {['@SteamId'] = getSteamID(source)}, function(DataUser)
    if DataUser[1] == nil then
      TriggerEvent("Register:AddPlayer", source, false)
      print("^3Create identity : "..SteamId.." ("..GetPlayerName(source)..")^7")
    elseif DataUser[1].nom == nil or DataUser[1].nom == "" then
      TriggerEvent("Register:AddPlayer", source, true)
      print("^3Create identity : "..SteamId.." ("..GetPlayerName(source)..")^7")
    elseif DataUser[1].model == nil or DataUser[1].model == "" then
      print("^3Create Skin : "..DataUser[1].prenom.." "..DataUser[1].nom.." ("..GetPlayerName(source)..")^7")
      TriggerClientEvent("Skin:Create", source)
    elseif SteamId == nil or SteamId == "" then
      DropPlayer(source, "Une erreur s'est produite, si cette dernière persiste contactez un membre du staff.")
    else
      local sexe = "homme"
      if DataUser[1].sexe == "f" then
        sexe = "femme"
      end
      DataPlayers[source] = {
        Ip = GetPlayerEP(source),
        SteamId = SteamId,
        Source = source,
        PlayerIdClient = nil,
        Group = DataUser[1].group,
        Nom = DataUser[1].nom,
        Prenom = DataUser[1].prenom,
        IdJob = DataUser[1].job,
        NameJob = DataUser[1].job_name,
        IsInService = {"none", false},
        Bank = DataUser[1].bank,
        Money = DataUser[1].money,
        VenatoPoint = DataUser[1].venato_point,
        Account = DataUser[1].account,
        Code = DataUser[1].code,
        Position = json.decode(DataUser[1].lastPosition),
        Sexe = sexe,
        Taille = DataUser[1].taille,
        Age = os.date("%x", DataUser[1].dateNaissance / 1000),
        Health = DataUser[1].health,
        Food = DataUser[1].food,
        Water = DataUser[1].water,
        Need = DataUser[1].needs,
        Sool = DataUser[1].sool,
        PhoneNumber = DataUser[1].phone_number,
        Pseudo = GetPlayerName(source),
        Poid = Venato.MoneyToPoid(DataUser[1].money),
        Inventaire = { nil },
        Weapon = { nil },
        Documents = { nil },
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
        Speedometer = DataUser[1].speedometer,
        Clothes = json.decode(DataUser[1].clothes),
        Skin = {
          model = DataUser[1].model,
          face = json.decode(DataUser[1].face),
          head = DataUser[1].head,
          body_color = DataUser[1].body_color,
          hair = DataUser[1].hair,
          hair_color = DataUser[1].hair_color,
          beard = DataUser[1].beard,
          beard_color = DataUser[1].beard_color,
          eyebrows = DataUser[1].eyebrows,
          eyebrows_color = DataUser[1].eyebrows_color,
          percing = DataUser[1].percing,
          percing_txt = DataUser[1].percing_txt,
          makeup = DataUser[1].makeup,
          makeup_opacity = DataUser[1].makeup_opacity,
          lipstick = DataUser[1].lipstick,
          lipstick_color = DataUser[1].lipstick_color
        }
      }
      MySQL.Async.execute("UPDATE users SET source = @source, pseudo = @pseudo WHERE identifier = @identifier",{["@source"] = source, ["@identifier"] = getSteamID(source),  ["@pseudo"] = GetPlayerName(source)}, function()
        TriggerClientEvent("gcphone:updateBank", source, DataUser[1].bank)
        TriggerClientEvent("CarMenu:InitSpeedmeter", source, DataUser[1].speedometer)
        TriggerEvent("Inventory:UpdateInventory", source)
        TriggerClientEvent("Venato:Connection", source)
        TriggerClientEvent("Job:start"..DataPlayers[source].NameJob, source, true)
        ControlVisa(SteamId, source)
        print("^3SyncData for : "..DataPlayers[source].Prenom.." "..DataPlayers[source].Nom.." ("..DataPlayers[source].Pseudo..")^7")
      end)
    end
  end)
end

function startScript()
  reloadDataCoffre()
end

function ControlVisa(SteamId, source)
  local source = source
  MySQL.Async.fetchAll("SELECT * FROM whitelist WHERE identifier = @identifier", { ["@identifier"] = SteamId },
    function(result)
      if not result[1] then
        return
      end
      local num = result[1].listed
      local start = result[1].visadebut
      local endv = result[1].visafin
      if tonumber(num) == 2 then
        DataPlayers[source].CanBeACitoyen = true
      elseif (tonumber(num) == 1 or tonumber(num) == 2) and tonumber(start) == 0 then
        local ts = os.time()
        local tsEnd = ts + 14 * 24 * 60 * 60
        DataPlayers[source].VisaStart = os.date('%d-%m-%Y', ts)
        DataPlayers[source].VisaEnd = os.date('%d-%m-%Y', tsEnd)
        MySQL.Async.execute("UPDATE whitelist SET visadebut=@ts, visafin=@tsEnd WHERE identifier=@identifier",
          { ["@ts"] = DataPlayers[source].VisaStart, ["@tsEnd"] = DataPlayers[source].VisaEnd, ["identifier"] = SteamId })
      elseif (tonumber(num) == 1 or tonumber(num) == 2) and tonumber(start) ~= 0 then
        local ts = os.time()
        local d, m, y = endv:match '(%d+)-(%d+)-(%d+)'
        local tsStart = os.time { year = y, month = m, day = d, }
        local testTS = tsStart
        DataPlayers[source].VisaStart = start
        DataPlayers[source].VisaEnd = endv
        if ts > testTS then
          MySQL.Async.execute("UPDATE whitelist SET listed=0 WHERE identifier=@identifier",
            { ["identifier"] = SteamId })
          DropPlayer(source, "Il semblerait que votre visa à exepiré. Date d'expiration : (" .. os.date('%d-%m-%Y', testTS) .. ")")
        elseif ts > tsStart - 7 * 24 * 60 * 60 then
          DataPlayers[source].VisaCanBeReload = true
        end
      else
        DataPlayers[source].Citoyen = 1
        DataPlayers[source].VisaStart = start
        DataPlayers[source].VisaEnd = endv
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

function Venato.Round(num, numDecimalPlaces)
  local mult = 10 ^ (numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function Venato.paymentCB(source, amount)
  if DataPlayers[source].Bank <= amount then
    return false
  else
    DataPlayers[source].Bank = DataPlayers[source].Bank - amount
    MySQL.Async.execute("UPDATE users SET bank=@money WHERE identifier=@identifier",
      { ["identifier"] = DataPlayers[source].SteamId, ["money"] = DataPlayers[source].Bank })
    return true
  end
end

function ExportPaymentCB(source, amount)
  return Venato.paymentCB(source, amount)
end

function Venato.paymentVP(source, amount)
  print(DataPlayers[source].VenatoPoint)
  if DataPlayers[source].VenatoPoint <= amount then
    return false
  else
    DataPlayers[source].VenatoPoint = DataPlayers[source].VenatoPoint - amount
    MySQL.Async.execute("UPDATE users SET venato_point=@money WHERE identifier=@identifier",
      { ["identifier"] = DataPlayers[source].SteamId, ["money"] = DataPlayers[source].VenatoPoint })
    return true
  end
end

function Venato.MoneyToPoid(money)
  return Venato.Round(money * 0.000075, 1)
end

RegisterNetEvent("Venato:dump")
AddEventHandler("Venato:dump", function(arg)
  local str = ''
  for _, item in ipairs(arg) do
    str = str .. ' ' .. Venato.dump(item)
  end
  print(str)
end)

function Venato.dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. Venato.dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end


function Venato.notify(source, notif)
  if not notif.message then
    return
  end
  if not notif.type then
    notif.type = 'alert'
  end
  if not notif.timeout then
    notif.timeout = 3500
  end
  TriggerClientEvent("Hud:Update", source, {
    action = "notify",
    message = notif.message,
    type = notif.type,
    timeout = notif.timeout,
    logo = notif.logo,
    title = notif.title
  })
end