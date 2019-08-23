local StartMoney = 5000
local StartBank = 5000
local clothesMale = '{"prop":{"bracelet":{"id":-1,"color":-1},"watch":{"id":-1,"color":-1},"hat":{"id":-1,"color":-1},"glass":{"id":-1,"color":-1},"ear":{"id":-1,"color":-1}},"ComponentVariation":{"torso":{"id":0,"color":0},"kevlar":{"id":0,"color":0},"badge":{"id":0,"color":0},"Mask":{"id":0,"color":0},"shoes":{"id":22,"color":5},"torso2":{"id":22,"color":2},"parachute":{"id":0,"color":0},"undershirt":{"id":15,"color":0},"leg":{"id":0,"color":0},"accessory":{"id":0,"color":0}}}'
local clothesFemale = '{"prop":{"hat":{"id":-1,"color":-1},"bracelet":{"id":-1,"color":-1},"glass":{"id":-1,"color":-1},"ear":{"id":-1,"color":-1},"watch":{"id":-1,"color":-1}},"ComponentVariation":{"badge":{"id":-1,"color":-1},"leg":{"id":-1,"color":-1},"Mask":{"id":0,"color":0},"torso":{"id":-1,"color":-1},"accessory":{"id":-1,"color":-1},"parachute":{"id":-1,"color":-1},"torso2":{"id":-1,"color":-1},"shoes":{"id":-1,"color":-1},"kevlar":{"id":-1,"color":-1},"undershirt":{"id":-1,"color":-1}}}'

function setIdentity(identifier, data, source)
  local clotheToSet = clothesMale
  if data.sexe == "f" then
    clotheToSet = clothesFemale
  end
    MySQL.Async.execute("UPDATE users SET nom = @nom, prenom = @prenom, dateNaissance = @dateNaissance, sexe = @sexe, taille = @taille, clothes = @clothes WHERE identifier = @identifier", {
        ['@nom'] = data.nom,
        ['@prenom'] = data.prenom,
        ['@dateNaissance'] = data.dateNaissance,
        ['@sexe'] = data.sexe,
        ['@taille'] = data.taille,
        ['@clothes'] = clotheToSet,
        ['@identifier'] = identifier
    },function() TriggerEvent("Venato:SyncData", identifier, source) end)
end

RegisterNetEvent("Register:AddPlayer")
AddEventHandler("Register:AddPlayer", function(source, boolean)
  local source = source
  local SteamId = getSteamID(source)
  if not boolean then
    MySQL.Async.execute("INSERT INTO users (`identifier`,`money`,`bank`,`clothes`) VALUES (@identifier,@money,@bank,@clothes)", {
      ['@identifier'] = SteamId,
      ['@money'] = StartMoney,
      ['@bank'] = StartBank,
      ['@clothes'] = clothesMale,
    })
  end
  TriggerClientEvent("Register:showRegisterItentity", source)
end)

RegisterNetEvent("Register:setIdentity")
AddEventHandler("Register:setIdentity", function(data, id)
  local source = source
  local SteamId = getSteamID(source)
  setIdentity(SteamId, data, source)
end)


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
