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
      TriggerClientEvent("VehicleCoffre:CallData:cb", DataVehicle[plate], DataUser[source])
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
    TriggerClientEvent("VehicleCoffre:CallData:cb", DataVehicle[plate], DataUser[source])
  end
end)

RegisterServerEvent('VehicleCoffre:CallData')
AddEventHandler('VehicleCoffre:CallData', function()

end)

RegisterServerEvent('VehicleCoffre:CallData')
AddEventHandler('VehicleCoffre:CallData', function()

end)

RegisterServerEvent('VehicleCoffre:CallData')
AddEventHandler('VehicleCoffre:CallData', function()

end)
