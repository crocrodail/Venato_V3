DataCoffre = {}

function startScript()
  reloadDataCoffre()
end

function reloadDataCoffre()
  Citizen.CreateThread(function()
    local Cof = {}
    local inCof = {}
    MySQL.Async.fetchAll("SELECT * FROM coffre_pack JOIN coffres ON coffres.Pack = coffre_pack.Id ORDER BY coffres.Id", {}, function(result)
      if result[1] ~= nil then
        for k,v in pairs(result) do
          if v.Id == 1168 then
          Cof = {
            ["id"] = v.Id,
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
          DataCoffre[v.Id] = Cof
          Citizen.Wait(50)
          MySQL.Async.fetchAll("SELECT * FROM coffres_contenu JOIN items ON coffres_contenu.ItemId = items.id WHERE CoffreId = @CoffreId", {["@CoffreId"] = v.Id}, function(resultContenu)
            if resultContenu[1] ~= nil then
              for k2,v2 in pairs(resultContenu) do
                inCof = {
                  ["coffreId"] = v2.CoffreId,
                  ["itemsId"] = v2.ItemId,
                  ["libelle"] = v2.libelle,
                  ["quantity"] = math.floor(v2.Quantity),
                  ["uPoid"] = v2.poid,
                }
                DataCoffre[v.Id].nbItems =  DataCoffre[v.Id].nbItems + v2.Quantity
                DataCoffre[v.Id].inventaire[v2.ItemId] = inCof
              end
            end
          end)
          Citizen.Wait(100)
          MySQL.Async.fetchAll("SELECT * FROM coffres_weapons JOIN weapon_model ON coffres_weapons.Weapon = weapon_model.weapond WHERE CoffreId = @CoffreId", {["@CoffreId"] = v.Id}, function(resultweapon)
            if resultweapon[1] ~= nil then
              local qtyWp = 0
              for k3,v3 in pairs(resultweapon) do
                CofWp = {
                  ["weaponId"] = v3.Weapon,
                  ["libelle"] = v3.libelle,
                  ["balles"] = math.floor(v3.balles),
                  ["poid"] = v3.poid
                }
                qtyWp = qtyWp + 1
                DataCoffre[v.Id].weapon[v3.Id] = CofWp
              end
              DataCoffre[v.Id].nbWeapon = qtyWp
            end
          end)
          Citizen.Wait(100)
          MySQL.Async.fetchAll("SELECT * FROM coffres_whitelist JOIN users ON coffres_whitelist.UserId = users.identifier WHERE CoffreId = @coffreId", {["@coffreId"] = v.Id}, function(resultwhhtelist)
            if resultwhhtelist[1] ~= nil then
              for k4,v4 in pairs(resultwhhtelist) do
                CofWl = {
                  ["nom"] = v4.nom,
                  ["prenom"] = v4.prenom,
                  ["identifier"] = v4.identifier
                }
                DataCoffre[v.Id].whitelist[v4.identifier] = CofWl
              end
            end
          end)
          Citizen.Wait(50)
        end
      end
      TriggerClientEvent('Coffre:CallData:cb', -1, DataCoffre)
      print("^2Coffres Loaded !^7")
      end
    end)
  end)
end

RegisterServerEvent("Coffre:CallData")
AddEventHandler("Coffre:CallData", function()
  source = source
  TriggerClientEvent("Coffre:CallData:cb",source, DataCoffre, DataPlayers[source])
end)

RegisterServerEvent("Coffre:CallDataClosePlayer")
AddEventHandler("Coffre:CallDataClosePlayer", function(index, player)
  source = source
  TriggerClientEvent("Coffre:CallDataClosePlayer:cb",source, DataCoffre, index, DataPlayers[player])
end)

RegisterServerEvent("Coffre:TakeWeapon")
AddEventHandler("Coffre:TakeWeapon", function(row)
  local source = source
  if DataCoffre[row[1]].weapon[row[2]].poid + DataPlayers[source].Poid <= DataPlayers[source].PoidMax then
    local indexCoffre = row[1]
    local indexWeapon = row[2]
    MySQL.Async.execute("DELETE FROM coffres_weapons WHERE Id = @indexWeapon", {["@idCoffre"] = indexCoffre})
    TriggerEvent("Inventory:AddWeapon", DataCoffre[indexCoffre].weapon[indexWeapon].weaponId,  DataCoffre[indexCoffre].weapon[indexWeapon].balles, DataCoffre[indexCoffre].weapon[indexWeapon].poid, DataCoffre[indexCoffre].weapon[indexWeapon].libelle, source)
    DataCoffre[indexCoffre].weapon[indexWeapon] = nil
    DataCoffre[indexCoffre].nbWeapon =  DataCoffre[indexCoffre].nbWeapon - 1
  else
    TriggerClientEvent("Venato:notify", source, "~r~Vous etes trop lourd pour prendre l'arme.")
  end
end)

RegisterServerEvent("Coffre:DropWeapon")
AddEventHandler("Coffre:DropWeapon", function(row)
  if DataCoffre[row[1]].nbWeapon + 1 <= DataCoffre[row[1]].maxWeapon then
    local source = source
    local indexCoffre = row[1]
    local indexWeapon = row[2]
    MySQL.Async.execute("INSERT INTO coffres_weapons (`Weapon`, `CoffreId`, `balles`) VALUES (@weapon, @coffreId, @balles)", {["@weapon"] = DataPlayers[source].Weapon[indexWeapon].id, ["@coffreId"] = indexCoffre, ["@balles"] =  DataPlayers[source].Weapon[indexWeapon].ammo})
    MySQL.Async.fetchAll("SELECT * FROM coffres_weapons join weapon_model ON coffres_weapons.Weapon = weapon_model.weapond WHERE Weapon = @weapon AND CoffreId = @coffreId", {["@weapon"] = DataPlayers[source].Weapon[indexWeapon].id, ["@coffreId"] = indexCoffre}, function(result)
      DataCoffre[indexCoffre].weapon[result[1].Id] = {["weaponId"] = DataPlayers[source].Weapon[indexWeapon].id, ["libelle"] = result[1].libelle, ["balles"] = DataPlayers[source].Weapon[indexWeapon].ammo or 0, ["poid"] = result[1].poid}
      TriggerEvent("Inventory:RemoveWeapon", DataPlayers[source].Weapon[indexWeapon].id, indexWeapon, result[1].poid, source)
      DataCoffre[indexCoffre].nbWeapon = DataCoffre[indexCoffre].nbWeapon + 1
    end)
  else
    TriggerClientEvent("Venato:notify", source, "~r~Il n'y a pas de place pour cette arme.")
  end
end)

RegisterServerEvent("Coffre:DropItem")
AddEventHandler("Coffre:DropItem", function(qty, row)
  if tonumber(qty) <= DataPlayers[source].Inventaire[row[2]].quantity and DataCoffre[row[1]].nbItems+qty <= DataCoffre[row[1]].itemcapacite then
    local source = source
    local indexCoffre = row[1]
    local indexItem = row[2]
    local qtyInCoffre = 0
    if DataCoffre[indexCoffre].inventaire[indexItem] ~= nil then
      qtyInCoffre = DataCoffre[indexCoffre].inventaire[indexItem].quantity
    end
    TriggerClientEvent("Venato:notify", source, "~g~Vous avez déposé "..qty.." "..DataPlayers[source].Inventaire[indexItem].libelle.." dans le coffre.")
    TriggerEvent("Inventory:SetItem", DataPlayers[source].Inventaire[indexItem].quantity - qty, indexItem, source)
    TriggerEvent("Coffre:SetItem", indexCoffre, indexItem, qtyInCoffre + qty, source)
  else
    TriggerClientEvent("Venato:notify", source, "~r~Une erreur est survenue.")
  end
end)

RegisterServerEvent("Coffre:TakeItems")
AddEventHandler("Coffre:TakeItems", function(qty, row)
  if tonumber(qty) <= DataCoffre[row[1]].inventaire[row[2]].quantity and DataCoffre[row[1]].inventaire[row[2]].uPoid * qty <= DataPlayers[source].PoidMax then
    local source = source
    local indexCoffre = row[1]
    local indexItem = row[2]
    local qtyInCoffre = DataCoffre[indexCoffre].inventaire[indexItem].quantity or 0
    local qtyOnPlayer = DataPlayers[source].Inventaire[indexItem].quantity or 0
    TriggerClientEvent("Venato:notify", source, "~g~Vous avez récuperé "..qty.." "..DataCoffre[indexCoffre].inventaire[indexItem].libelle.." dans le coffre.")
    TriggerEvent("Inventory:SetItem",qtyOnPlayer + qty, indexItem, source)
    TriggerEvent("Coffre:SetItem", indexCoffre, indexItem, qtyInCoffre - qty, source)
  else
    TriggerClientEvent("Venato:notify", source, "~r~Une erreur est survenue.")
  end
end)

RegisterServerEvent("Coffre:SetItem")
AddEventHandler("Coffre:SetItem", function(idCoffre, idItem, qty, NewSource)
  local source = source
  local libelle = libelle or "nil"
  local uPoid = uPoid or 0
  local qty = math.floor(qty)
  if NewSource ~= nil then
    source = NewSource
  end
  if 0 < qty then
    if DataCoffre[idCoffre].inventaire[idItem] ~= nil then
      DataCoffre[idCoffre].nbItems = (DataCoffre[idCoffre].nbItems - DataCoffre[idCoffre].inventaire[idItem].quantity) + qty
      DataCoffre[idCoffre].inventaire[idItem].quantity = qty
      MySQL.Async.execute("UPDATE coffres_contenu SET Quantity = @qty WHERE CoffreId = @coffreId", {["@qty"] = qty, ["@coffreId"] = idCoffre})
    else
      MySQL.Async.fetchAll("SELECT * FROM items WHERE id = @itemId", {["@itemId"] = idItem}, function(result)
        if result[1] ~= nil then
          DataCoffre[idCoffre].nbItems = DataCoffre[idCoffre].nbItems + qty
          DataCoffre[idCoffre].inventaire[idItem] = {["coffreId"] = idCoffre, ["itemId"] = idItem, ["libelle"] = result[1].libelle, ["quantity"] = qty, ["uPoid"] = result[1].poid}
          MySQL.Async.execute("INSERT INTO coffres_contenu (`CoffreId`, `ItemId`, `Quantity`) VALUES (@coffreId, @itemId, @qty)", {["@coffreId"] = idCoffre, ["itemId"] = idItem, ["qty"] = qty})
        end
      end)
    end
  else
    DataCoffre[idCoffre].nbItems = DataCoffre[idCoffre].nbItems - DataCoffre[idCoffre].inventaire[idItem].quantity
    MySQL.Async.execute("DELETE FROM coffres_contenu WHERE CoffreId = @coffreId AND ItemId = @itemId", {["@coffreId"] = idCoffre, ["@itemId"] = idItem})
    DataCoffre[idCoffre].inventaire[idItem] = nil
  end
end)

RegisterServerEvent("Coffre:DropMoney")
AddEventHandler("Coffre:DropMoney", function(qty, index)
  if tonumber(qty) + DataCoffre[index].argent <= DataCoffre[index].argentcapacite then
    local source = source
    TriggerEvent("Inventory:RemoveMoney", qty, source)
    TriggerEvent("Coffre:SetMoney", DataCoffre[index].argent + qty , index, source)
    TriggerClientEvent("Venato:notify", source, "~g~Vous avez déposé "..qty.." € dans le coffre.")
  else
    TriggerClientEvent("Venato:notify", source, "~r~Une erreur est survenue.")
  end
end)

RegisterServerEvent("Coffre:TakeMoney")
AddEventHandler("Coffre:TakeMoney", function(qty, index)
  if tonumber(qty) <= DataCoffre[index].argent and Venato.MoneyToPoid(qty) + DataPlayers[source].Poid <= DataPlayers[source].PoidMax then
    local source = source
    TriggerEvent("Inventory:AddMoney", qty, source)
    TriggerEvent("Coffre:SetMoney", DataCoffre[index].argent - qty , index, source)
    TriggerClientEvent("Venato:notify", source, "~g~Vous avez récuperé "..qty.." € du coffre.")
  else
    TriggerClientEvent("Venato:notify", source, "~r~Une erreur est survenue.")
  end
end)

RegisterServerEvent("Coffre:SetMoney")
AddEventHandler("Coffre:SetMoney", function(qty, index)
  local source = source
  if 0 < qty then
    DataCoffre[index].argent = qty
    MySQL.Async.execute("UPDATE coffres SET Argent = @qty WHERE Id = @coffreId", {["@qty"] = qty, ["@coffreId"] = index})
  else
    DataCoffre[index].argent = 0
    MySQL.Async.execute("UPDATE coffres SET Argent = @qty WHERE Id = @coffreId", {["@qty"] = 0, ["@coffreId"] = index})
  end
end)

RegisterServerEvent("Coffre:CoffreWhitelistPlayer")
AddEventHandler("Coffre:CoffreWhitelistPlayer", function(row)
  local source = source
  local index = row[1]
  local user = row[2]
  DataCoffre[index].whitelist[DataPlayers[user].SteamId] = {["nom"] = DataPlayers[user].Nom, ["prenom"] = DataPlayers[user].Prenom, ["identifier"] = DataPlayers[user].SteamId}
end)

RegisterServerEvent("Coffre:UnWhitelist")
AddEventHandler("Coffre:UnWhitelist", function(row)
  local source = source
  local index = row[1]
  local userId = row[2]
  DataCoffre[index].whitelist[userId] = nil
end)
