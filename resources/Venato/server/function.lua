venato = {}

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

RegisterNetEvent("venato:SyncData")
AddEventHandler("venato:SyncData", function(steam, newSource)
  local source = newSource or source
  local steam = steam or getSteamID(source)
  accessGranded(steam, source)
end)

RegisterNetEvent("venato:SwitchJob")
AddEventHandler("venato:SwitchJob", function(id)
  local id = id
  local source = source
  TriggerClientEvent("job:deleteBlips", source)
  MySQL.Async.fetchAll("SELECT * FROM user_job INNER JOIN jobs ON JobId = job_id WHERE UserId = @identifier AND isFarm", { ["@identifier"] = getSteamID(source) }, function(result)

    if result[1] then
      TriggerClientEvent("job:deleteBlips", source)
      TriggerClientEvent("Job:start"..result[1].job_name, source, false)
      DataPlayers[tonumber(source)].Jobs[result[1].JobId] = nil
      MySQL.Async.execute("DELETE user_job FROM user_job INNER JOIN jobs ON JobId = job_id WHERE UserId = @identifier AND isFarm = true", {['@identifier'] = getSteamID(source)}, function()
        newJob(source,id)
      end)
    else
      newJob(source,id)
    end
  end)
end)

RegisterNetEvent("venato:AddJob")
AddEventHandler("venato:AddJob", function(id, identifier)
  MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier",{["@identifier"]=identifier}, function(result)
    if result[1] ~= nil then
      if result[1].source ~= 'disconnect' then
        newJob(result[1].source, id)
      else
        newJobIdentifier(result[1].identifier, id)
      end
    end
  end)
end)

RegisterNetEvent("venato:RemoveJob")
AddEventHandler("venato:RemoveJob", function(data)
  MySQL.Async.execute("DELETE user_job FROM user_job INNER JOIN jobs ON JobId = job_id WHERE UserId = @identifier and JobId = @jobId", {['@identifier'] = data[2], ['@jobId'] = data[1]})
  MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier",{["@identifier"]=data[2]}, function(result)
    if result[1] ~= nil then
        if result[1].source ~= 'disconnect' then
          local sourceId = result[1].source
          local jobId = data[1]
          print(sourceId)
          print(jobId)
          print(venato.dump(DataPlayers[tonumber(sourceId)].Jobs[tonumber(jobId)]))
          DataPlayers[tonumber(sourceId)].Jobs[tonumber(jobId)] = nil
        end
    end
  end)
end)

RegisterNetEvent("venato:QuitJob")
AddEventHandler("venato:QuitJob", function(id)
  local id = id
  local source = source
  TriggerClientEvent("job:deleteBlips", source)
  MySQL.Async.fetchAll("SELECT * FROM user_job INNER JOIN jobs ON JobId = job_id WHERE UserId = @identifier AND isFarm", { ["@identifier"] = getSteamID(source) }, function(result)
    if result[1] then
      TriggerClientEvent("job:deleteBlips", source)
      TriggerClientEvent("Job:start"..result[1].job_name, source, false)
      DataPlayers[tonumber(source)].Jobs[result[1].JobId] = nil
      MySQL.Async.execute("DELETE user_job FROM user_job INNER JOIN jobs ON JobId = job_id WHERE UserId = @identifier AND isFarm = true", {['@identifier'] = getSteamID(source)})
    end
  end)
end)


function newJob(source, id)
  MySQL.Async.execute("INSERT INTO user_job(UserId, JobId) VALUES (@identifier, @jobId)", {['@identifier'] = getSteamID(source), ['@jobId'] = id })
  MySQL.Async.fetchAll("SELECT * FROM jobs WHERE job_id = @jobId", { ["@jobId"] = id }, function(result)
    if result[1] then
      DataPlayers[tonumber(source)].Jobs[tonumber(id)] = result[1].job_name
      TriggerClientEvent("Job:start"..result[1].job_name, source, true)
      local defaultNotification = {
        type = "alert",
        title ="PoleEmploi",
        logo = "https://i.ibb.co/CMFQmq2/icons8-briefcase-96px.png",
        message = "Vous etes maintenant "..result[1].job_name
      }
      venato.notify(source, defaultNotification)
    end
  end)
end

function newJobIdentifier(identifier, id)
  MySQL.Async.execute("INSERT INTO user_job(UserId, JobId) VALUES (@identifier, @jobId)", {['@identifier'] = identifier, ['@jobId'] = id })
end

DataPlayers = {}

function accessGranded(SteamId, source , balek)
  MySQL.Async.fetchAll("SELECT * FROM users "..
   "LEFT JOIN skin ON `users`.`identifier` = `skin`.`identifier` "..
   "WHERE users.identifier = @SteamId", {['@SteamId'] = getSteamID(source)}, function(DataUser)
    if DataUser[1] == nil then
      TriggerEvent("Register:AddPlayer", source, false)
      print("^3Create identity : "..SteamId.." ("..GetPlayerName(source)..")^7")
    elseif DataUser[1].nom == nil or DataUser[1].nom == "" then
      TriggerEvent("Register:AddPlayer", source, true)
      print("^3Create identity : "..SteamId.." ("..GetPlayerName(source)..")^7")
    elseif DataUser[1].face == nil or DataUser[1].face == "" or DataUser[1].face == "NOT" then
      print("^3Create Skin : "..DataUser[1].prenom.." "..DataUser[1].nom.." ("..GetPlayerName(source)..")^7")
      TriggerClientEvent("Skin:Create", source)
    elseif SteamId == nil or SteamId == "" then
      DropPlayer(source, "Une erreur s'est produite, si cette dernière persiste contactez un membre du staff.")
    else
      local sexe = "homme"
      if DataUser[1].sexe == "f" then
        sexe = "femme"
      end
      DataPlayers[tonumber(source)] = {
        Ip = GetPlayerEP(source),
        SteamId = SteamId,
        Source = source,
        PlayerIdClient = nil,
        Group = DataUser[1].group,
        Nom = DataUser[1].nom,
        Prenom = DataUser[1].prenom,
        Instance = nil,
        -- IdJob = DataUser[1].job,
        -- NameJob = DataUser[1].job_name,
        IsInService = {"none", false},
        Bank = DataUser[1].bank,
        Money = DataUser[1].money,
        venatoPoint = DataUser[1].venato_point,
        Account = DataUser[1].account,
        Code = DataUser[1].code,
        Position = json.decode(DataUser[1].lastPosition),
        Sexe = sexe,
        Taille = DataUser[1].taille,
        Age = os.date("%x", DataUser[1].dateNaissance / 1000),
        Health = DataUser[1].health or 200,
        Food = DataUser[1].food,
        Water = DataUser[1].water,
        Need = DataUser[1].needs,
        Sool = DataUser[1].sool,
        PhoneNumber = DataUser[1].phone_number,
        Pseudo = GetPlayerName(source),
        Poid = venato.MoneyToPoid(DataUser[1].money),
        Inventaire = { nil },
        Weapon = { nil },
        Documents = { nil },
        Jobs = { nil },
        PoidMax = 20,
        Index = 0,
        VisaStart = nil,
        VisaEnd = nil,
        VisaCanBeReload = false,
        CanBeACitoyen = false,
        PermisVoiture = DataUser[1].permisVoiture,
        PermisCamion = DataUser[1].permisCamion,
        Point = DataUser[1].point,
        Citoyen = 1,
        Url = DataUser[1].url,
        Speedometer = DataUser[1].speedometer,
        Clothes = json.decode(DataUser[1].clothes),
        GardeRobe = { nil },
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
        },
        IsBankAccountBlocked = DataUser[1].isBankAccountBlocked
      }
      TriggerClientEvent("Bank:AccountIsBlocked:Set", source, DataUser[1].isBankAccountBlocked)
      local steamIdl = getSteamID(source)
      if DataUser[1].PDGLVL > 50 then TriggerClientEvent("DeliveryJob:isPro", source, true) end --pdglvl > 50 peux avoir acces aux shop pro
      MySQL.Async.execute("UPDATE users SET source = @source, pseudo = @pseudo WHERE identifier = @identifier",{["@source"] = source, ["@identifier"] = steamIdl,  ["@pseudo"] = GetPlayerName(source)}, function()
        TriggerClientEvent("gcphone:updateBank", source, DataUser[1].bank)
        TriggerClientEvent("gcphone:updateUserId", source, DataUser[1].id)
        TriggerClientEvent("gcphone:updateAccount", source, DataUser[1].account)
        TriggerClientEvent("gcphone:updateFullname", source, DataUser[1].nom .. ' ' .. DataUser[1].prenom)
        TriggerClientEvent("CarMenu:InitSpeedmeter", source, DataUser[1].speedometer)
        TriggerEvent("Inventory:UpdateInventory", source)
        TriggerEvent("GardeRobe:UpdateGardeRobe", source)
        MySQL.Async.fetchAll("SELECT * FROM user_job INNER JOIN jobs ON JobId = jobs.job_id WHERE UserId = @identifier ", { ["@identifier"] = steamIdl }, function(result)
          if not result[1] then
            return
          end
          for k, v in pairs(result) do
            DataPlayers[tonumber(source)].Jobs[v.job_id] = v.job_name
            TriggerClientEvent("Job:start"..v.job_name, source, true)
          end
          TriggerClientEvent("venato:Connection", source)
        end)
        ControlVisa(SteamId, source)
        TriggerEvent("police:checkIsCop", source)
        MySQL.Async.execute("UPDATE user_vehicle SET prenom=@prenom, nom=@nom, foufou = 2 WHERE owner=@owner", {['@owner'] = steamIdl, ['@prenom'] = DataUser[1].prenom, ['@nom'] = DataUser[1].nom})
        print("^3SyncData for : "..DataPlayers[tonumber(source)].Prenom.." "..DataPlayers[tonumber(source)].Nom.." ("..DataPlayers[tonumber(source)].Pseudo..")^7")
      end)
    end
  end)
end

function startScript()
  reloadDataCoffre()
end

function venato.DisplayBool(value)
  return value and 'true' or 'false'
end

function ControlVisa(SteamId, source)
  local source = source
  MySQL.Async.fetchAll("SELECT * FROM whitelist WHERE identifier = @identifier", { ["@identifier"] = SteamId },
    function(result)
      if not result[1] then
        return-- nique :)
      else
        return-- nique :)
      end
      local num = result[1].listed
      local start = result[1].visadebut
      local endv = result[1].visafin
      if tonumber(num) == 2 then
        DataPlayers[tonumber(source)].CanBeACitoyen = true
        DataPlayers[tonumber(source)].VisaStart = start
        DataPlayers[tonumber(source)].VisaEnd = endv
      elseif (tonumber(num) == 1 or tonumber(num) == 2) and tonumber(start) == 0 then
        local ts = os.time()
        local tsEnd = ts + 14 * 24 * 60 * 60
        DataPlayers[tonumber(source)].VisaStart = os.date('%d-%m-%Y', ts)
        DataPlayers[tonumber(source)].VisaEnd = os.date('%d-%m-%Y', tsEnd)
        MySQL.Async.execute("UPDATE whitelist SET visadebut=@ts, visafin=@tsEnd WHERE identifier=@identifier",
          { ["@ts"] = DataPlayers[tonumber(source)].VisaStart, ["@tsEnd"] = DataPlayers[tonumber(source)].VisaEnd, ["identifier"] = SteamId })
      elseif (tonumber(num) == 1 or tonumber(num) == 2) and tonumber(start) ~= 0 then
        local ts = os.time()
        local d, m, y = endv:match '(%d+)-(%d+)-(%d+)'
        local tsStart = os.time { year = y, month = m, day = d, }
        local testTS = tsStart
        DataPlayers[tonumber(source)].VisaStart = start
        DataPlayers[tonumber(source)].VisaEnd = endv
        if ts > testTS then
          MySQL.Async.execute("UPDATE whitelist SET listed=0 WHERE identifier=@identifier",
            { ["identifier"] = SteamId })
          DropPlayer(source, "Il semblerait que votre visa à exepiré. Date d'expiration : (" .. os.date('%d-%m-%Y', testTS) .. ")")
        elseif ts > tsStart - 7 * 24 * 60 * 60 then
          DataPlayers[tonumber(source)].VisaCanBeReload = true
        end
      else
        DataPlayers[tonumber(source)].Citoyen = 1
        DataPlayers[tonumber(source)].VisaStart = start
        DataPlayers[tonumber(source)].VisaEnd = endv
      end
    end)
end

function PlayerLeaving(SteamID)
  if DataPlayers ~= nil then
    if DataPlayers[tonumber(source)] ~= nil then
      DataPlayers[tonumber(source)] = nil
    end
  end
end

function venato.Round(num, numDecimalPlaces)
  local mult = 10 ^ (numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

local defaultNotification = {
  title ="Venato Bank",
  type= "alert",
  logo = "https://i.ibb.co/0V3MVZn/venato-bank-icon-48.png"
}

function venato.paymentCB(source, amount, isPolice)
  local response = {}
  if isPolice == nil then
    isPolice = false
  end
  if DataPlayers[tonumber(source)].IsBankAccountBlocked == 1 then
    response = {status = false, message = "Votre compte est bloqué, rendez vous au LSPD pour régulariser votre situation."}
  end
  if not isPolice and DataPlayers[tonumber(source)].Bank <= tonumber(amount) then
    response = {status = false, message = "Votre solde est insuffisant."}
  else
    DataPlayers[tonumber(source)].Bank = DataPlayers[tonumber(source)].Bank - amount
    MySQL.Async.execute("UPDATE users SET bank=@money WHERE identifier=@identifier",
      { ["identifier"] = DataPlayers[tonumber(source)].SteamId, ["money"] = DataPlayers[tonumber(source)].Bank })
      TriggerClientEvent("gcphone:updateBank", source, DataPlayers[tonumber(source)].Bank)
    response = {status = true}
  end

  if(response.status) then
    defaultNotification.message = "Paiement accepté. Nouveau solde : " .. DataPlayers[tonumber(source)].Bank .. "$"
  else
    defaultNotification.message = "Paiement refusé. " .. response.message
  end

  venato.notify(source, defaultNotification)
  
  return response;
end

function ExportPaymentCB(source, amount)
  return venato.paymentCB(source, amount)
end

function venato.paymentVP(source, amount)
  print(DataPlayers[tonumber(source)].venatoPoint)
  if DataPlayers[tonumber(source)].venatoPoint <= tonumber(amount) then
    return false
  else
    DataPlayers[tonumber(source)].venatoPoint = DataPlayers[tonumber(source)].venatoPoint - amount
    MySQL.Async.execute("UPDATE users SET venato_point=@money WHERE identifier=@identifier",
      { ["identifier"] = DataPlayers[tonumber(source)].SteamId, ["money"] = DataPlayers[tonumber(source)].venatoPoint })
    return true
  end
end

function venato.MoneyToPoid(money)
  return venato.Round(money * 0.000075, 1)
end

function venato.GetSteamID(source)
  return getSteamID(source)
end

RegisterNetEvent("venato:dump")
AddEventHandler("venato:dump", function(arg)
  local str = ''
  for _, item in ipairs(arg) do
    str = str .. ' ' .. venato.dump(item)
  end
  print(str)
end)

function venato.dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. venato.dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end


function venato.notify(source, notif)
  if not notif.message then
    return
  end
  if not notif.type then
    notif.type = 'alert'
  end
  if not notif.timeout then
    notif.timeout = 3500
  end
  TriggerClientEvent("venato:notify:server", source, {
    action = "notify",
    message = notif.message,
    type = notif.type,
    timeout = notif.timeout,
    logo = notif.logo,
    title = notif.title
  })
end

RegisterServerEvent('venato:NotifyPlayer')
AddEventHandler('venato:NotifyPlayer', function (data)
  venato.notify(data[1], data[2])
end)

function venato.CheckItem(itemId, source)
  if not DataPlayers[tonumber(source)] or not DataPlayers[tonumber(source)].Inventaire[itemId] then
    return 0
  end
  return DataPlayers[tonumber(source)].Inventaire[itemId].quantity
end

RegisterServerEvent('vnt:chestaddmonney')
AddEventHandler('vnt:chestaddmonney', function (idChest, qty)
  local idChest = idChest
  local qty = qty
  local notif = "Le compte de votre entreprise est plein"
  MySQL.Async.fetchAll("SELECT * FROM coffres WHERE Id=@idChest", {['@idChest'] = idChest}, function(result)
    if (result[1]) then
      local money = result[1].Argent
      local pack = result[1].Pack
      MySQL.Async.fetchScalar("SELECT ArgentMax FROM coffre_pack WHERE Id=@Idpack", {['@Idpack'] = pack}, function(result1)
        if (result1) then
          local moneyMax = result1
          local update = qty + money
          if update < moneyMax then
            MySQL.Async.execute("UPDATE coffres SET Argent=@update WHERE Id=@idChest", {['@idChest'] = idChest, ['@update'] = update})
          else
            local defaultNotification = {
              type = "alert",
              title ="Coffre",
              logo = "https://i.ibb.co/fvtWrv3/icons8-spam-96px.png",
              message = notif
            }
            venato.notify(source, defaultNotification)
          end
        else
        end
      end)
    else
    end
  end)
end)

function venato.CheckChomage(identifier)
  local result =  MySQL.Sync.fetchAll("SELECT COUNT(*) as chomage FROM user_job WHERE UserId=@identifier AND JobId = 1", {['@identifier'] = identifier})
  return result[1].chomage == 1
end

function venato.NbJob(identifier)
  local result =  MySQL.Sync.fetchAll("SELECT COUNT(*) as nbJob FROM user_job WHERE UserId=@identifier", {['@identifier'] = identifier})
  return result[1].nbJob
end

function venato.AddChomage(identifier)
  TriggerEvent("venato:AddJob", 1, identifier)
end

function venato.RemoveChomage(identifier)
  TriggerEvent("venato:RemoveJob", {1, identifier})
end

venato.ServerCallbacks = {}

venato.RegisterServerCallback = function(name, cb)
	venato.ServerCallbacks[name] = cb
end

RegisterServerEvent('venato:triggerServerCallback')
AddEventHandler('venato:triggerServerCallback', function(name, requestId, ...)
	local _source = source

	venato.TriggerServerCallback(name, requestID, _source, function(...)
		TriggerClientEvent('venato:serverCallback', _source, requestId, ...)
	end, ...)
end)

venato.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if venato.ServerCallbacks[name] ~= nil then
	   venato.ServerCallbacks[name](source, cb, ...)
	else
		print('Venato: TriggerServerCallback => [' .. name .. '] does not exist')
	end
end