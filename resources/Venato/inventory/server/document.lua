RegisterServerEvent("Inventory:ShowToOtherPermis")
AddEventHandler(
  "Inventory:ShowToOtherPermis",
  function(data, target)
    TriggerClientEvent("Inventory:ShowToOtherPermis:cb", target, data)
  end
)

RegisterServerEvent("Inventory:ShowToOtherIdCard")
AddEventHandler(
  "Inventory:ShowToOtherIdCard",
  function(data, target)
    TriggerClientEvent("Inventory:ShowToOtherIdCard:cb", target, data)
  end
)


RegisterServerEvent("Inventory:ShowToOtherVisa")
AddEventHandler(
  "Inventory:ShowToOtherVisa",
  function(data, target)
    TriggerClientEvent("Inventory:ShowToOtherVisa:cb", target, data)
  end
)


function LoadDocument(source)
  local Document = {}
  MySQL.Async.fetchAll(
    "SELECT * FROM user_document WHERE identifier = @SteamId",
    {["@SteamId"] = DataPlayers[tonumber(source)].SteamId},
    function(result)
      if result[1] ~= nil then
        for i, v in ipairs(result) do
          doc = {
            ["type"] = v.type,
            ["nom1"] = v.nom,
            ["prenom1"] = v.prenom,
            ["montant"] = tonumber(v.montant),
            ["numeroDeCompte"] = v.numero_de_compte,
            ["date"] = v.date,
            ["nom2"] = v.nom_du_factureur,
            ["prenom2"] = v.prenom_du_factureur
          }
          Document[v.id] = doc
        end
        DataPlayers[tonumber(source)].Documents = Document
      end
    end
  )
end
