RegisterServerEvent("Inventory:RefreshTattoo")
AddEventHandler(
    "Inventory:RefreshTattoo",
    function()
        local source = source
        LoadTattoo(source)
    end
)

function LoadTattoo(source)
    local Tattoo = {}
    MySQL.Async.fetchAll(
        "SELECT ut.id, t.collection, t.hash, t.image  FROM user_tattoos ut  INNER JOIN tattoo t ON t.id = ut.tattoos  WHERE identifier = @SteamId",
        {["@SteamId"] = DataPlayers[tonumber(source)].SteamId},
        function(result)
            if result[1] ~= nil then
                for i, v in ipairs(result) do
                    tattoo = {["collection"] = v.collection, ["hash"] = v.hash, ["image"] = v.image}
                    Tattoo[v.id] = tattoo
                end
            end
            DataPlayers[tonumber(source)].Tattoos = Tattoo
            TriggerClientEvent("Inventory:RefreshTattoo:cb", source, DataPlayers[tonumber(source)].Tattoos)
        end
    )
end
