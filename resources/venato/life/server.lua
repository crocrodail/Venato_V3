RegisterNetEvent("Life:Init")
AddEventHandler(
    "Life:Init",
    function()
        local needs = {
            food = DataPlayers[tonumber(source)].Food,
            water = DataPlayers[tonumber(source)].Water,
            alcool = DataPlayers[tonumber(source)].Sool
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
        if(DataPlayers[tonumber(source)] ~= nil) then
            DataPlayers[tonumber(source)].Food = needs.food
            DataPlayers[tonumber(source)].Water = needs.water
            DataPlayers[tonumber(source)].Sool = needs.alcool
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
        DataPlayers[tonumber(source)].Food = DataPlayers[tonumber(source)].Food + qte
        local source = source
        local needs = {
            water = DataPlayers[tonumber(source)].Water,
            food = DataPlayers[tonumber(source)].Food,
            alcool = DataPlayers[tonumber(source)].Sool
        }
        UpdateDb(source, needs)
        TriggerClientEvent("Life:UpdateState", source, needs)
    end
)

RegisterNetEvent("Life:Drink")
AddEventHandler(
    "Life:Drink",
    function(qte)
        DataPlayers[tonumber(source)].Water = DataPlayers[tonumber(source)].Water + qte
        local source = source
        local needs = {
            water = DataPlayers[tonumber(source)].Water,
            food = DataPlayers[tonumber(source)].Food,
            alcool = DataPlayers[tonumber(source)].Sool
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
                ["@identifier"] = DataPlayers[tonumber(source)].SteamId
            }
        )
    end
end
