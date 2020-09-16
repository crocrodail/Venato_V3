ItemsOnTheGround = {}
ItemsOnTheGroundIndex = 0
RegisterServerEvent("Inventory:DropItem")
AddEventHandler(
    "Inventory:DropItem",
    function(libelle, qty, id, uPoid, x, y, z, poid, picture)
        ItemsOnTheGroundIndex = ItemsOnTheGroundIndex + 1
        ItemsOnTheGround[ItemsOnTheGroundIndex] = {
            id = id,
            dropId = uuid(),
            libelle = libelle,
            qty = qty,
            uPoid = uPoid,
            poid = poid,
            x = x,
            y = y,
            z = z,
            picture = picture
        }
        ActualiseTableOfItemOnTheGround()
    end
)

RegisterServerEvent("Inventory:DelItemsOnTheGround")
AddEventHandler(
    "Inventory:DelItemsOnTheGround",
    function(index)
        ItemsOnTheGround[index] = nil
        ActualiseTableOfItemOnTheGround()
    end
)

function ActualiseTableOfItemOnTheGround()
    TriggerClientEvent("Inventory:SendItemsOnTheGround", -1, ItemsOnTheGround)
end

RegisterServerEvent("Inventory:RemoveItem")
AddEventHandler(
    "Inventory:RemoveItem",
    function(qty, id, NewSource)
        local source = source
        local qty = qty
        local AlreadyExist = false
        if NewSource ~= nil then
            source = NewSource
        end
        if DataPlayers[tonumber(source)].Inventaire ~= nil then
            for k, v in pairs(DataPlayers[tonumber(source)].Inventaire) do
                if v.id == id then
                    AlreadyExist = true
                    qty = DataPlayers[tonumber(source)].Inventaire[k].quantity - qty
                end
            end
            if AlreadyExist then
                local poidBefore = DataPlayers[tonumber(source)].Inventaire[id].poid
                DataPlayers[tonumber(source)].Poid = DataPlayers[tonumber(source)].Poid - poidBefore
                if qty > 0 then
                    DataPlayers[tonumber(source)].Inventaire[id].quantity = qty
                    DataPlayers[tonumber(source)].Inventaire[id].poid =
                        qty * DataPlayers[tonumber(source)].Inventaire[id].uPoid
                    DataPlayers[tonumber(source)].Poid =
                        DataPlayers[tonumber(source)].Poid + DataPlayers[tonumber(source)].Inventaire[id].poid
                    MySQL.Async.execute(
                        "UPDATE user_inventory SET quantity = @qty WHERE identifier = @SteamId AND item_id = @id",
                        {["@qty"] = qty, ["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@id"] = id}
                    )
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
                        else
                            print("GROS Probleme 2!!")
                        end
                    end
                )
                MySQL.Async.execute(
                    "INSERT INTO user_inventory (`identifier`, `item_id`, `quantity`) VALUES (@player, @item, @qty)",
                    {["@player"] = DataPlayers[tonumber(source)].SteamId, ["@item"] = id, ["@qty"] = qty}
                )
            end
        end
    end
)

RegisterServerEvent("Inventory:AddItem")
AddEventHandler(
    "Inventory:AddItem",
    function(qty, id, NewSourcee)
        local source = source
        local qty = qty
        local qtyadd = qty
        local AlreadyExist = false
        if NewSourcee ~= nil then
            source = NewSourcee
        end
        if DataPlayers[tonumber(source)].Inventaire ~= nil then
            for k, v in pairs(DataPlayers[tonumber(source)].Inventaire) do
                if v.id == id then
                    AlreadyExist = true
                    qty = qty + DataPlayers[tonumber(source)].Inventaire[k].quantity
                end
            end
            if AlreadyExist then
                if
                    ((DataPlayers[tonumber(source)].Inventaire[id].uPoid * qtyadd) + DataPlayers[tonumber(source)].Poid) <=
                        DataPlayers[tonumber(source)].PoidMax
                 then
                    local poidBefore = DataPlayers[tonumber(source)].Inventaire[id].poid
                    DataPlayers[tonumber(source)].Poid = DataPlayers[tonumber(source)].Poid - poidBefore
                    if qty > 0 then
                        DataPlayers[tonumber(source)].Inventaire[id].quantity = qty
                        DataPlayers[tonumber(source)].Inventaire[id].poid =
                            qty * DataPlayers[tonumber(source)].Inventaire[id].uPoid
                        DataPlayers[tonumber(source)].Poid =
                            DataPlayers[tonumber(source)].Poid + DataPlayers[tonumber(source)].Inventaire[id].poid
                        MySQL.Async.execute(
                            "UPDATE user_inventory SET quantity = @qty WHERE identifier = @SteamId AND item_id = @id",
                            {["@qty"] = qty, ["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@id"] = id}
                        )
                    else
                        DataPlayers[tonumber(source)].Inventaire[id] = nil
                        MySQL.Async.execute(
                            "DELETE FROM user_inventory WHERE identifier = @SteamId AND item_id = @id",
                            {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@id"] = id}
                        )
                    end
                else
                    local Notification = {
                        title = "Inventaire",
                        type = "info", --  danger, error, alert, info, success, warning
                        logo = "https://i.ibb.co/qJ2yMXG/icons8-backpack-96px-1.png",
                        message = "Vous avez trop d'objet en poche pour ça."
                    }
                    TriggerClientEvent("venato:notify", source, Notification)
                    TriggerClientEvent("inventory:full", source)
                end
            else
                MySQL.Async.fetchAll(
                    "SELECT * FROM items WHERE id = @id",
                    {["@id"] = id},
                    function(result)
                        if result[1] ~= nil then
                            if
                                DataPlayers[tonumber(source)].Poid + (qty * tonumber(result[1].poid)) >
                                    DataPlayers[tonumber(source)].PoidMax
                             then
                                DataPlayers[tonumber(source)].Poid = DataPlayers[tonumber(source)].Poid + poidBefore
                                defaultNotification.message = "Vous avez trop d'objets en poche."
                                venato.notify(source, defaultNotification)
                                TriggerClientEvent("inventory:full", source)
                                return false
                            end
                            DataPlayers[tonumber(source)].Inventaire[id] = {
                                ["id"] = id,
                                ["libelle"] = result[1].libelle,
                                ["quantity"] = qty,
                                ["poid"] = tonumber(result[1].poid) * qty,
                                ["uPoid"] = tonumber(result[1].poid),
                                ["picture"] = result[1].picture,
                                ["consomable"] = result[1].consomable,
                                ["canBeSellToNPC"] = result[1].canBeSellToNPC,
                                ["price"] = result[1].price
                            }
                            DataPlayers[tonumber(source)].Poid =
                                DataPlayers[tonumber(source)].Poid + DataPlayers[tonumber(source)].Inventaire[id].poid
                            MySQL.Async.execute(
                                "INSERT INTO user_inventory (`identifier`, `item_id`, `quantity`) VALUES (@player, @item, @qty)",
                                {["@player"] = DataPlayers[tonumber(source)].SteamId, ["@item"] = id, ["@qty"] = qty}
                            )
                        else
                            print("GROS Probleme 1!!")
                        end
                    end
                )
            end
        end
        return false
    end
)

RegisterServerEvent("Inventaire:ForceDeleteObject")
AddEventHandler(
    "Inventaire:ForceDeleteObject",
    function(id)
        TriggerClientEvent("Inventaire:ForceDeleteObject:cb", -1, id)
    end
)

function LoadItem(source)
    local Inventaire = {}
    local Poids = 0
    MySQL.Async.fetchAll(
        "SELECT * FROM user_inventory JOIN items ON `user_inventory`.`item_id` = `items`.`id` WHERE identifier = @SteamId",
        {["@SteamId"] = DataPlayers[tonumber(source)].SteamId},
        function(result)
            if result[1] ~= nil then
                for i, v in ipairs(result) do
                    Inv = {
                        ["id"] = v.item_id,
                        ["libelle"] = v.libelle,
                        ["quantity"] = v.quantity,
                        ["poid"] = tonumber(v.poid) * v.quantity,
                        ["uPoid"] = tonumber(v.poid),
                        ["picture"] = v.picture,
                        ["consomable"] = v.consomable,
                        ["canBeSellToNPC"] = v.canBeSellToNPC,
                        ["price"] = v.price
                    }
                    Inventaire[v.item_id] = Inv
                    Poids = Poids + tonumber(v.poid) * v.quantity
                end
                DataPlayers[tonumber(source)].Poid = Poids
                DataPlayers[tonumber(source)].Inventaire = Inventaire
            end
        end
    )
end
