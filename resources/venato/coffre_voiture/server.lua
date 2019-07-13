local DataVehicle = {}

RegisterServerEvent('VehicleCoffre:CallData')
AddEventHandler('VehicleCoffre:CallData', function(plate, class)
  local key = ""
  local Cof = {}
  local CofWp = {}
  local weapon = {}
  local nbItem = 0
  local Inventaire = {}
  local limitItem = maxCapacity[class].size
  local limiteWp = maxCapacity[class].MaxWeapon
  local customExeption = false
  for k,v in pairs(DataVehicle) do
    if v.plate == plate then
      key = k
      break
    end
  end
  if key == "" then
    MySQL.Async.fetchAll("SELECT * FROM coffres_voiture_contenu JOIN items ON coffres_voiture_contenu.ItemId = items.id WHERE CoffreId = @id", {["@id"] = plate}, function(result)
      if result[1] ~= nil then
        for k,v in pairs(result) do
          Cof = { ["libelle"] = v.libelle, ["quantity"] = v.Quantity, ["itemId"] = v.ItemId, ["poid"] = v.poid}
          Inventaire[v.ItemId] = Cof
          nbItem = nbItem + 1
        end
      end
      for k,v in pairs(PlateExeption) do
        if plate == v.plate then
          limitItem = v.size
          limiteWp = v.MaxWeapon
          break
        end
      end
      for index,v in ipairs(StingPlateExeption) do
        customExeption = true
        for i=1,#StingPlateExeption[index] - 2 do
          if string.sub(plate, i,i) ~= index[i+2] then
            customExeption = false
            break
          end
        end
        if customExeption == true then
          limitItem = index[1]
          limiteWp = index[2]
          break
        end
      end
      DataVehicle[plate] = {
        ["nbItems"] = nbItem,
        ["nbWeapon"] = 0,
        ["itemcapacite"] = limitItem,
        ["maxWeapon"] = limiteWp,
        ["inventaire"] = Inventaire,
        ["weapon"] = {},
      }
      TriggerClientEvent("VehicleCoffre:CallData:cb", DataVehicle[plate], DataPlayers[source])
      MySQL.Async.fetchAll("SELECT * FROM coffres_voiture_weapons JOIN weapon_model ON coffres_voiture_weapons.Weapon = weapon_model.weapond WHERE CoffreId = @id", {["@id"] = plate}, function(resultWp)
        if resultWp ~= nil then
          for k,v in pairs(resultWp) do
            CofWp = {["libelle"] = v.libelle, ["weapon"] = v.Weapon, ["balles"] = v.balles}
            weapon[v.Id] = CofWp
          end
           DataVehicle[plate].weapon = weapon
        end
        TriggerClientEvent("VehicleCoffre:CallData:cb2", DataVehicle[plate])
      end)
    end)
  else
    TriggerClientEvent("VehicleCoffre:CallData:cb", DataVehicle[plate], DataPlayers[source])
  end
end)

RegisterServerEvent('VehicleCoffre:DropItem')
AddEventHandler('VehicleCoffre:DropItem', function(qty, plate, index)
  local source = source
  if tonumber(qty) <= DataPlayers[source].Inventaire[index].quantity and VehicleData[plate].nbItems+qty <= VehicleData[plate].itemcapacite then
    TriggerEvent("TriggerEvent('Inventory:SetItem", DataPlayers[source].Inventaire[index].quantity - qty, index, source)
    if DataVehicle[plate].inventaire[id] ~= nil then
      TriggerEvent("VehicleCoffre:SetItems",  DataVehicle[plate].inventaire[id].quantity + qty, index, plate )
    else
      TriggerEvent("VehicleCoffre:SetItems", qty, index, plate)
    end
  else
    TriggerClientEvent("Venato:notify", source, "~r~Erreur dans la quantité.")
  end
end)

RegisterServerEvent('VehicleCoffre:TakeItems')
AddEventHandler('VehicleCoffre:TakeItems', function(index, qty, plate)
  if tonumber(qty) <= VehicleData[plate].inventaire[index].quantity and DataPlayers[source].Poid+VehicleData[plate].inventaire[index].poid*qty <= DataPlayers[source].PoidMax then
    TriggerEvent('Inventory:AddItem', qty, index, source)
    TriggerEvent("VehicleCoffre:SetItems",  DataVehicle[plate].inventaire[id].quantity - qty, index, plate )
  else
    TriggerClientEvent("Venato:notify", source, "~r~Erreur dans la quantité.")
  end
end)

RegisterServerEvent('VehicleCoffre:SetItems')
AddEventHandler('VehicleCoffre:SetItems', function(qty, id, plate)
  if qty < 1 then
    if DataVehicle[plate].inventaire[id] ~= nil then
      VehicleData[plate].nbItems = VehicleData[plate].nbItems-DataVehicle[plate].inventaire[id].quantity
    end
    DataVehicle[plate].inventaire[id] = nil
    MySQL.Async.execute("DELETE FROM coffres_voiture_contenu WHERE CoffreId = @Plate AND ItemId = @ItemId", {["@Plate"] = plate, ["@ItemId"] = id})
  else
    if DataVehicle[plate].inventaire[id] ~= nil then
      VehicleData[plate].nbItems = (VehicleData[plate].nbItems-DataVehicle[plate].inventaire[id].quantity) + qty
      DataVehicle[plate].inventaire[id].quantity = qty
      MySQL.Async.execute("UPDATE coffres_voiture_contenu SET Quantity = @qty WHERE CoffreId = @Plate AND ItemId = @ItemId", {["@Plate"] = plate, ["@ItemId"] = id, ["@qty"] = qty})
    else
      MySQL.Async.fetchAll("SELECT * items WHERE id = @id", {["@id"] = id}, function(result)
        VehicleData[plate].nbItems = VehicleData[plate].nbItems + qty
        DataVehicle[plate].inventory[id] = {["libelle"] = result[1].libelle, ["quantity"] = qty, ["itemId"] = id, ["poid"] = result[1].poid}
        MySQL.Async.execute("INSERT INTO coffres_voiture_contenu (`CoffreId`, `ItemId`, `Quantity`) VALUES (@plate, @id, @qty)", {["@plate"] = plate, ["@id"] = id, ["@qty"] = qty})
      end)
    end
  end
end)

RegisterServerEvent('VehicleCoffre:TakeWpCv')
AddEventHandler('VehicleCoffre:TakeWpCv', function(index, plate)
  if DataPlayers[source].Poid + DataCoffre[plate].weapon[index].poid <= DataPlayers[source].PoidMax then
    TriggerEvent("Inventory:AddWeapon", DataVehicle[plate].weapon[index].weapon, DataVehicle[plate].weapon[index].balles,  DataVehicle[plate].weapon[index].poid,  DataVehicle[plate].weapon[index].libelle, source)
    DataVehicle[plate].weapon[index] = nil
    MySQL.Async.execute("DELETE FROM coffres_voiture_weapons WHERE Id = @index", {["@index"] = index})
  else
    TriggerClientEvent("Venato:notify", source, "~r~Cette arme est trop lourd pour toi.")
  end
end)

RegisterServerEvent('VehicleCoffre:TakeWpCv')
AddEventHandler('VehicleCoffre:TakeWpCv', function(index, plate)
  if DataPlayers[source].Poid + DataCoffre[plate].weapon[index].poid <= DataPlayers[source].PoidMax then
    TriggerEvent("Inventory:AddWeapon", DataVehicle[plate].weapon[index].weapon, DataVehicle[plate].weapon[index].balles,  DataVehicle[plate].weapon[index].poid,  DataVehicle[plate].weapon[index].libelle, source)
    DataVehicle[plate].weapon[index] = nil
    MySQL.Async.execute("DELETE FROM coffres_voiture_weapons WHERE Id = @index", {["@index"] = index})
    DataVehicle[plate].nbWeapon = DataVehicle[plate].nbWeapon - 1
  else
    TriggerClientEvent("Venato:notify", source, "~r~Cette arme est trop lourd pour toi.")
  end
end)

RegisterServerEvent('VehicleCoffre:DropWpCv')
AddEventHandler('VehicleCoffre:DropWpCv', function(index, plate)
  if DataVehicle[plate].nbWeapon + 1  <= DataVehicle[plate].maxWeapon then
    MySQL.Async.execute("INSERT INTO coffres_voiture_weapons (`Weapon`, `CoffreId`, `balles`) VALUES (@weapon, @plate, @balles)", {["@weapon"] =  DataPlayers[source].Weapon[index].id, ["@plate"] = plate, ["@balles"] =  DataPlayers[source].Weapon[index].ammo}, function()
      MySQL.Async.fetchScalar("SELECT Id FROM coffres_voiture_weapons WHERE CoffreId = @plate AND Weapon = @weapon ORDER BY id DESC", {["@weapon"] =  DataPlayers[source].Weapon[index].id, ["@plate"] = plate}, function(resultId)
        DataVehicle[plate].weapon[resultId] = {["libelle"] = DataPlayers[source].Weapon[index].libelle, ["weapon"] = DataPlayers[source].Weapon[index].id, ["balles"] = DataPlayers[source].Weapon[index].ammo}
        TriggerEvent("Inventory:RemoveWeapon", DataPlayers[source].Weapon[index].id, index, DataPlayers[source].Weapon[index].poid, source)
        DataVehicle[plate].nbWeapon = DataVehicle[plate].nbWeapon + 1
      end)
    end)
  else
    TriggerClientEvent("Venato:notify", source, "~r~Cette arme est trop lourd pour toi.")
  end
end)
