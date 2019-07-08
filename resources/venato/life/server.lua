
RegisterNetEvent("Life:Init")
AddEventHandler("Life:Init", function()  
  local needs = {
      food = DataPlayers[source].Food,
      water = DataPlayers[source].Water,
      alcool = DataPlayers[source].Sool
  }
  print(DataPlayers[source].Food)
  print(DataPlayers[source].Water)

  TriggerClientEvent("Life:InitStatus", source, needs)  
end)

RegisterNetEvent("Life:Dead")
AddEventHandler("Life:Dead", function()  
    print("You're dead")
end)

RegisterNetEvent("Life:Update")
AddEventHandler("Life:Update", function(needs)  
    print("Update")
    DataPlayers[source].Food = needs.food
    DataPlayers[source].Water = needs.water
    DataPlayers[source].Sool = needs.alcool
end)