local defaultNotification = {
    title = "Inventaire",
    type = "alert",
    logo = "https://i.ibb.co/qJ2yMXG/icons8-backpack-96px-1.png"
}

random = math.random
function uuid()
    local template = "xxxxxxxx"
    return string.gsub(
        template,
        "[xy]",
        function(c)
            local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
            return string.format("%x", v)
        end
    )
end

RegisterServerEvent("SyncData")
AddEventHandler(
    "SyncData",
    function()
        local SteamId = getSteamID(source)
        accessGranded(SteamId, source, "")
    end
)

RegisterServerEvent("Inventory:UpdateInventory")
AddEventHandler(
    "Inventory:UpdateInventory",
    function(source)
        local source = source
        local Inv = {}
        local inventaire = {}
        local Wp = {}
        local Weapon = {}
        local doc = {}
        local Document = {}
        local Tattoo = {}
        local poid = 0

        LoadWeapon(source)
        LoadItem(source)
        LoadTattoo(source)
        LoadDocument(source)
    end
)

RegisterServerEvent("Inventory:ShowMe")
AddEventHandler(
    "Inventory:ShowMe",
    function()
        TriggerClientEvent("Inventory:ShowMe:cb", source, DataPlayers[tonumber(source)])
    end
)

RegisterServerEvent("Inventory:DataItem")
AddEventHandler(
    "Inventory:DataItem",
    function(id, qty)
        local source = source
        local table = {}
        TriggerEvent("Inventory:SetItem", qty - 1, id, source)
        MySQL.Async.fetchAll(
            "SELECT * FROM items WHERE id = @id",
            {["@id"] = id},
            function(result)
                if result[1] ~= nil then
                    if tonumber(result[1].consomable) == 1 then
                        table = {
                            water = result[1].water,
                            food = result[1].food,
                            sool = result[1].sool,
                            drug = result[1].drug
                        }
                        DataPlayers[tonumber(source)].Food = DataPlayers[tonumber(source)].Food - table.food
                        DataPlayers[tonumber(source)].Water = DataPlayers[tonumber(source)].Water - table.water
                        -- DataPlayers[tonumber(source)].Need = DataPlayers[tonumber(source)].Need + table.need
                        DataPlayers[tonumber(source)].Sool = DataPlayers[tonumber(source)].Sool + table.sool
                        local needs = {
                            water = DataPlayers[tonumber(source)].Water,
                            food = DataPlayers[tonumber(source)].Food,
                            alcool = DataPlayers[tonumber(source)].Sool
                        }
                        TriggerClientEvent("Life:UpdateState", source, needs) -- ###########################   non atribué-- ###########################   non atribué-- ###########################   non atribué-- ###########################   non atribué
                    else
                        TriggerClientEvent("venato:notify", source, "Cette item n'est pas utilisable.", "danger")
                    end
                end
            end
        )
    end
)

RegisterServerEvent("Inventory:SetItem")
AddEventHandler(
    "Inventory:SetItem",
    function(qty, id, NewSource)
        local source = source
        local AlreadyExist = false
        if NewSource ~= nil then
            source = NewSource
        end
        if DataPlayers[tonumber(source)].Inventaire ~= nil then
            for k, v in pairs(DataPlayers[tonumber(source)].Inventaire) do
                if v.id == id then
                    AlreadyExist = true
                end
            end
            if AlreadyExist then
                local poidBefore = DataPlayers[tonumber(source)].Inventaire[id].poid
                DataPlayers[tonumber(source)].Poid = DataPlayers[tonumber(source)].Poid - poidBefore
                if qty > 0 then
                    if
                        DataPlayers[tonumber(source)].Poid + (qty * DataPlayers[tonumber(source)].Inventaire[id].uPoid) >
                            DataPlayers[tonumber(source)].PoidMax
                     then
                        DataPlayers[tonumber(source)].Poid = DataPlayers[tonumber(source)].Poid + poidBefore
                        defaultNotification.message = "Vous avez trop d'objets en poche."
                        venato.notify(source, defaultNotification)
                        TriggerEvent("inventory:full")
                        return false
                    end
                    MySQL.Async.execute(
                        "UPDATE user_inventory SET quantity = @qty WHERE identifier = @SteamId AND item_id = @id",
                        {["@qty"] = qty, ["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@id"] = id}
                    )
                    DataPlayers[tonumber(source)].Inventaire[id].quantity = qty
                    DataPlayers[tonumber(source)].Inventaire[id].poid =
                        qty * DataPlayers[tonumber(source)].Inventaire[id].uPoid
                    DataPlayers[tonumber(source)].Poid =
                        DataPlayers[tonumber(source)].Poid + DataPlayers[tonumber(source)].Inventaire[id].poid
                else
                    DataPlayers[tonumber(source)].Inventaire[id] = nil
                    MySQL.Async.execute(
                        "DELETE FROM user_inventory WHERE identifier = @SteamId AND item_id = @id",
                        {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@id"] = id}
                    )
                end
            else
                MySQL.Async.fetchAll(
                    "SELECT * FROM items WHERE id = @id",
                    {["@id"] = id},
                    function(result)
                        if result[1] ~= nil then
                            DataPlayers[tonumber(source)].Inventaire[id] = {
                                ["id"] = id,
                                ["libelle"] = result[1].libelle,
                                ["quantity"] = qty,
                                ["poid"] = tonumber(result[1].poid) * qty,
                                ["uPoid"] = tonumber(result[1].poid),
                                ["picture"] = result[1].picture,
                                result[1].picture,
                                ["consomable"] = result[1].consomable,
                                ["canBeSellToNPC"] = result[1].canBeSellToNPC,
                                ["price"] = result[1].price
                            }
                            DataPlayers[tonumber(source)].Poid =
                                DataPlayers[tonumber(source)].Poid + DataPlayers[tonumber(source)].Inventaire[id].poid
                            if
                                DataPlayers[tonumber(source)].Poid + (qty * tonumber(result[1].poid)) >
                                    DataPlayers[tonumber(source)].PoidMax
                             then
                                --DataPlayers[tonumber(source)].Poid = DataPlayers[tonumber(source)].Poid + poidBefore
                                defaultNotification.message = "Vous avez trop d'objets en poche."
                                venato.notify(source, defaultNotification)
                                TriggerEvent("inventory:full")
                                return false
                            end
                            MySQL.Async.execute(
                                "INSERT INTO user_inventory (`identifier`, `item_id`, `quantity`) VALUES (@player, @item, @qty)",
                                {["@player"] = DataPlayers[tonumber(source)].SteamId, ["@item"] = id, ["@qty"] = qty}
                            )
                        else
                            print("GROS Probleme !!")
                        end
                    end
                )
            end
        end
        return false
    end
)

RegisterServerEvent("Inventory:CallInfo")
AddEventHandler(
    "Inventory:CallInfo",
    function(ClosePlayer, nb, row)
        local qtyTarget
        if DataPlayers[ClosePlayer].Inventaire[row[2]] == nil then
            qtyTarget = 0
        else
            qtyTarget = DataPlayers[ClosePlayer].Inventaire[row[2]].quantity
        end
        TriggerClientEvent(
            "Inventory:CallInfo:cb",
            source,
            ClosePlayer,
            nb,
            row,
            DataPlayers[ClosePlayer].Poid,
            qtyTarget
        )
    end
)

RegisterServerEvent("Inventory:NotifGive")
AddEventHandler(
    "Inventory:NotifGive",
    function(recever, qty, id)
        local source = source
        local Notification = {
            title = "Inventaire",
            type = "info", --  danger, error, alert, info, success, warning
            logo = DataPlayers[tonumber(source)].Inventaire[id].picture,
            message = "Vous avez reçu " .. qty .. " " .. DataPlayers[tonumber(source)].Inventaire[id].libelle .. "."
        }
        TriggerClientEvent("venato:notify", recever, Notification)
        Notification.message =
            "Vous avez donné " .. qty .. " " .. DataPlayers[tonumber(source)].Inventaire[id].libelle .. "."
        TriggerClientEvent("venato:notify", source, Notification)
    end
)
