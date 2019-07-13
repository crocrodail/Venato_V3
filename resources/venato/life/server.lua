RegisterNetEvent("Life:Init")
AddEventHandler(
    "Life:Init",
    function()
        local needs = {
            food = DataPlayers[source].Food,
            water = DataPlayers[source].Water,
            alcool = DataPlayers[source].Sool
        }

        TriggerClientEvent("Life:InitStatus", source, needs)
    end
)

RegisterNetEvent("Life:Dead")
AddEventHandler(
    "Life:Dead",
    function()
    end
)

RegisterNetEvent("Life:Update")
AddEventHandler(
    "Life:Update",
    function(needs)
        local source = source
        if(DataPlayers[source] ~= nil) then
            DataPlayers[source].Food = needs.food
            DataPlayers[source].Water = needs.water
            DataPlayers[source].Sool = needs.alcool
        end
    end
)

RegisterNetEvent("Life:UpdateDB")
AddEventHandler(
    "Life:UpdateDB",
    function(needs)
        local source = source
        UpdateDb(source, needs)
    end
)

RegisterNetEvent("Life:Eat")
AddEventHandler(
    "Life:Eat",
    function(qte)
        DataPlayers[source].Food = DataPlayers[source].Food + qte
        local source = source
        local needs = {
            water = DataPlayers[source].Water,
            food = DataPlayers[source].Food,
            alcool = DataPlayers[source].Sool
        }
        UpdateDb(source, needs)
        TriggerClientEvent("Life:UpdateState", source, needs)
    end
)

RegisterNetEvent("Life:Drink")
AddEventHandler(
    "Life:Drink",
    function(qte)
        DataPlayers[source].Water = DataPlayers[source].Water + qte
        local source = source
        local needs = {
            water = DataPlayers[source].Water,
            food = DataPlayers[source].Food,
            alcool = DataPlayers[source].Sool
        }
        UpdateDb(source, needs)
        TriggerClientEvent("Life:UpdateState", source, needs)
    end
)

function UpdateDb(source, needs)
    if needs ~= nil then
        MySQL.Sync.execute(
            "UPDATE users SET food = @food, water = @water, sool = @alcool WHERE identifier = @identifier",
            {
                ["@food"] = needs.food,
                ["@water"] = needs.water,
                ["@alcool"] = needs.alcool,
                ["@identifier"] = DataPlayers[source].SteamId
            }
        )
    end
end
