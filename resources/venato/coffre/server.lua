DataCoffre = {}

function startScript()
  reloadDataCoffre()
end

function reloadDataCoffre()
  Citizen.CreateThread(function()
    local Cof = {}
    local inCof = {}
    MySQL.Async.fetchAll("SELECT * FROM coffres JOIN coffre_pack ON coffres.Pack = coffre_pack.Id", {}, function(result)
      if result[1] ~= nil then
        for k,v in pairs(result) do
          Cof = {
            ["nom"] = v.Nom,
            ["description"] = v.Description,
            ["x"] = v.PositionX,
            ["y"] = v.PositionY,
            ["z"] = v.PositionZ,
            ["pack"] = v.Pack,
            ["argent"] = v.Argent,
            ["red"] = v.CouleurRouge,
            ["green"] = v.CouleurVert,
            ["blue"] = v.CouleurBleu,
            ["showname"] = v.showname,
            ["nbItems"] = 0,
            ["nbWeapon"] = 0,
            ["itemcapacite"] = v.Capacite,
            ["argentcapacite"] = v.ArgentMax,
            ["maxWeapon"] = v.QtyWeapon,
            ["inventaire"] = {nil},
            ["weapon"] = {nil},
            ["whitelist"] = {nil}
          }
          DataCoffre[v.id] = Cof
          Citizen.Wait(100)
          MySQL.Async.fetchAll("SELECT * FROM coffres_contenu JOIN items ON coffres_contenu.ItemId = items.id WHERE CoffreId = @CoffreId", {["@CoffreId"] = v.id}, function(resultContenu)
            if resultContenu[1] ~= nil then
              for k2,v2 in pairs(resultContenu) do
                inCof = {
                  ["coffreId"] = v2.CoffreId,
                  ["itemsId"] = v2.ItemId,
                  ["libelle"] = v2.libelle,
                  ["quantity"] = v2.Quantity,
                  ["uPoid"] = v2.poid,
                }
                DataCoffre[v.id].nbItems =  DataCoffre[v.id].nbItems + v2.Quantity
                DataCoffre[v.id].inventaire[v2.ItemId] = inCof
              end
            end
          end)
          Citizen.Wait(500)
          MySQL.Async.fetchAll("SELECT * FROM coffres_weapons JOIN weapon_model ON coffres_weapons.Weapon = weapon_model.weapond WHERE CoffreId = @CoffreId", {["@CoffreId"] = v.id}, function(resultweapon)
            if resultweapon[1] ~= nil then
              local qtyWp = 0
              for k3,v3 in pairs(resultweapon) do
                CofWp = {
                  ["weaponId"] = v3.Weapon,
                  ["libelle"] = v3.libelle,
                  ["balles"] = v3.balles,
                  ["poid"] = v3.poid
                }
                qtyWp = qtyWp + 1
                DataCoffre[v.id].weapon[v3.Id] = CofWp
              end
              DataCoffre[v.id].nbWeapon = qtyWp
            end
          end)
          Citizen.Wait(500)
          MySQL.Async.fetchAll("SELECT * FROM coffres_whitelist JOIN users ON coffres_whitelist.UserId = users.identifier WHERE CoffreId = @coffreId", {["@coffreId"] = v.id}, function(resultwhhtelist)
            if resultwhhtelist[1] ~= nil then
              for k4,v4 in pairs(resultwhhtelist) do
                CofWl = {
                  ["nom"] = v4.nom,
                  ["prenom"] = v4.prenom,
                  ["identifier"] = v4.identifier
                }
                DataCoffre[v.id].whitelist[v4.identifier] = CofWl
              end
            end
          end)
          Citizen.Wait(500)
        end
      end
    end)
  end)
end

RegisterServerEvent("Coffre:CallData")
AddEventHandler("Coffre:CallData", function()
  source = source
  TriggerClientEvent("Coffre:CallData:cb", DataCoffre, DataPlayers[source])
end)
