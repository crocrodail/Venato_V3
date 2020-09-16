MoneyOnTheGround = {}
MoneyOnTheGroundIndex = 0
RegisterServerEvent("Inventory:DropMoney")
AddEventHandler(
    "Inventory:DropMoney",
    function(qty, table, x, y, z, poid)
        MoneyOnTheGroundIndex = MoneyOnTheGroundIndex + 1
        MoneyOnTheGround[MoneyOnTheGroundIndex] = {
            qty = qty,
            dropId = uuid(),
            poid = table[3],
            PlayerMoney = table[1],
            x = x,
            y = y,
            z = z
        }
        ActualiseTableOfMoneyOnTheGround()
    end
)

RegisterServerEvent("Inventory:DelMoneyOnTheGround")
AddEventHandler(
    "Inventory:DelMoneyOnTheGround",
    function(index)
        MoneyOnTheGround[index] = nil
        ActualiseTableOfMoneyOnTheGround()
    end
)

function ActualiseTableOfMoneyOnTheGround()
    TriggerClientEvent("Inventory:SendMoneyOnTheGround", -1, MoneyOnTheGround)
end

RegisterServerEvent("Inventory:CreateCheque")
AddEventHandler(
    "Inventory:CreateCheque",
    function(player, montant)
        local source = source
        local target = player
        local date = os.date("%Y/%m/%d")
        local Notification = {
            title = "Inventaire",
            type = "success", --  danger, error, alert, info, success, warning
            logo = "https://img.icons8.com/dusk/64/000000/paycheque.png",
            message = "Vous avez bien donné un chèque."
        }
        MySQL.Async.execute(
            "INSERT INTO user_document (`identifier`, `type`, `nom`, `prenom`, `montant`, `numero_de_compte`, `nom_du_factureur`,`prenom_du_factureur`, `date`) VALUES (@identifier, @type, @nom, @prenom, @montant, @numero_de_compte, @nom_du_factureur, @prenom_du_factureur, @date)",
            {
                ["@identifier"] = DataPlayers[target].SteamId,
                ["@type"] = "cheque",
                ["@nom"] = DataPlayers[target].Nom,
                ["@prenom"] = DataPlayers[target].Prenom,
                ["@montant"] = montant,
                ["@numero_de_compte"] = DataPlayers[tonumber(source)].Account,
                ["@nom_du_factureur"] = DataPlayers[tonumber(source)].Nom,
                ["@prenom_du_factureur"] = DataPlayers[tonumber(source)].Prenom,
                ["@date"] = date
            },
            function()
                MySQL.Async.fetchScalar(
                    "SELECT id FROM user_document WHERE identifier = @identifier ORDER BY id DESC",
                    {["@identifier"] = DataPlayers[target].SteamId},
                    function(result)
                        DataPlayers[target].Documents[result] = {
                            ["type"] = "cheque",
                            ["nom1"] = DataPlayers[target].Nom,
                            ["prenom1"] = DataPlayers[target].Prenom,
                            ["montant"] = montant,
                            ["numeroDeCompte"] = DataPlayers[tonumber(source)].Account,
                            ["date"] = date,
                            ["nom2"] = DataPlayers[tonumber(source)].Nom,
                            ["prenom2"] = DataPlayers[tonumber(source)].Prenom
                        }
                        for k, v in pairs(DataPlayers[tonumber(source)].Documents) do
                            if type == "chequier" then
                                DataPlayers[tonumber(source)].Documents[k].montant =
                                    DataPlayers[tonumber(source)].Documents[k].montant - 1
                                if DataPlayers[tonumber(source)].Documents[k].montant == 0 then
                                    MySQL.Async.execute(
                                        "DELETE FROM user_document WHERE identifier = @identifier and id = @id",
                                        {["@identifier"] = DataPlayers[tonumber(source)].SteamId, ["@id"] = k}
                                    )
                                else
                                    MySQL.Async.execute(
                                        "UPDATE user_document SET montant = @montant WHERE identifier = @identifier and id = @id",
                                        {
                                            ["@montant"] = DataPlayers[tonumber(source)].Documents[k].montant,
                                            ["@identifier"] = DataPlayers[tonumber(source)].SteamId,
                                            ["@id"] = k
                                        }
                                    )
                                end
                                break
                            end
                        end
                        TriggerClientEvent("venato:notify", source, Notification)
                        Notification.message = "Vous avez reçu un chèque de " .. montant .. " € ."
                        TriggerClientEvent("venato:notify", target, Notification)
                    end
                )
            end
        )
    end
)

RegisterNetEvent("Inventory:SetMoney")
AddEventHandler(
    "Inventory:SetMoney",
    function(qty, NewSource)
        local source = source
        local qty = qty
        if NewSource ~= nil then
            source = NewSource
        end
        local newPoid = DataPlayers[tonumber(source)].Poid - venato.MoneyToPoid(DataPlayers[tonumber(source)].Money)
        local new = qty
        DataPlayers[tonumber(source)].Poid = DataPlayers[tonumber(source)].Poid + venato.MoneyToPoid(qty)
        DataPlayers[tonumber(source)].Money = new
        MySQL.Async.execute(
            "UPDATE users SET money = @Money WHERE identifier = @SteamId",
            {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@Money"] = new}
        )
    end
)

RegisterServerEvent("Inventory:CallInfoMoney")
AddEventHandler(
    "Inventory:CallInfoMoney",
    function(ClosePlayer, qty, table)
        local infoPlayer = DataPlayers[ClosePlayer]
        local source = source
        if infoPlayer ~= nil and infoPlayer.Poid + venato.MoneyToPoid(qty) <= infoPlayer.PoidMax then
            if (qty < 0) then
                TriggerEvent("Inventory:RemoveMoney", -qty, ClosePlayer)
                TriggerEvent("Inventory:AddMoney", -qty, source)
                defaultNotification.message = "Vous avez récupéré <span class='green--text'>" .. -qty .. " €</span>"
                TriggerClientEvent("venato:notify", source, defaultNotification)
                TriggerEvent("police:targetCheckInventory", ClosePlayer, source)
            else
                TriggerEvent("Inventory:AddMoney", qty, ClosePlayer)
                TriggerEvent("Inventory:RemoveMoney", qty, source)
                defaultNotification.message = "Vous avez donner <span class='red--text'>" .. qty .. " €</span>"
                TriggerClientEvent("venato:notify", source, defaultNotification)
                defaultNotification.message = "Vous avez reçu <span class='green--text'>" .. qty .. " €</span>"
                TriggerClientEvent("venato:notify", ClosePlayer, defaultNotification)
                TriggerClientEvent("Inventory:AnimReceive", ClosePlayer)
                TriggerClientEvent("Inventory:AnimGive", source)
            end
        else
            defaultNotification.message = "La personne n'a pas la place pour recevoir " .. qty .. " €"
            TriggerClientEvent("venato:notify", source, defaultNotification)
            defaultNotification.message = "Vous n'avez pas la place pour recevoir " .. qty .. " €"
            TriggerClientEvent("venato:notify", ClosePlayer, defaultNotification)
        end
    end
)

RegisterNetEvent("Inventory:AddMoney")
AddEventHandler(
    "Inventory:AddMoney",
    function(qty, NewSource)
        local source = source
        local qty = qty
        if NewSource ~= nil then
            source = NewSource
        end
        DataPlayers[tonumber(source)].Poid = DataPlayers[tonumber(source)].Poid + venato.MoneyToPoid(qty)
        local new = DataPlayers[tonumber(source)].Money + qty
        DataPlayers[tonumber(source)].Money = new
        MySQL.Async.execute(
            "UPDATE users SET money = @Money WHERE identifier = @SteamId",
            {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@Money"] = new}
        )
    end
)

RegisterNetEvent("Inventory:RemoveMoney")
AddEventHandler(
    "Inventory:RemoveMoney",
    function(qty, NewSource)
        local source = source
        local qty = qty
        if NewSource ~= nil then
            source = NewSource
        end
        local new = DataPlayers[tonumber(source)].Money - qty
        DataPlayers[tonumber(source)].Poid = DataPlayers[tonumber(source)].Poid - venato.MoneyToPoid(qty)
        DataPlayers[tonumber(source)].Money = new
        MySQL.Async.execute(
            "UPDATE users SET money = @Money WHERE identifier = @SteamId",
            {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@Money"] = new}
        )
    end
)

RegisterServerEvent("Inventory:CreateJobCheck")
AddEventHandler(
    "Inventory:CreateJobCheck",
    function(source, amount)
        local date = os.date("%Y/%m/%d")
        local notification = {
            title = "Inventaire",
            type = "success", --  danger, error, alert, info, success, warning
            logo = "https://img.icons8.com/dusk/64/000000/paycheque.png"
        }
        MySQL.Async.execute(
            "INSERT INTO user_document (`identifier`, `type`, `nom`, `prenom`, `montant`, `numero_de_compte`, `nom_du_factureur`,`prenom_du_factureur`, `date`) VALUES (@identifier, @type, @nom, @prenom, @montant, @numero_de_compte, @nom_du_factureur, @prenom_du_factureur, @date)",
            {
                ["@identifier"] = DataPlayers[tonumber(source)].SteamId,
                ["@type"] = "cheque",
                ["@nom"] = "Entreprise",
                ["@prenom"] = "",
                ["@montant"] = amount,
                ["@numero_de_compte"] = "Entreprise",
                ["@nom_du_factureur"] = "Entreprise",
                ["@prenom_du_factureur"] = "",
                ["@date"] = date
            },
            function()
                notification.message = "Vous avez reçu un chèque de " .. amount .. " € ."
                TriggerClientEvent("venato:notify", source, notification)
            end
        )
    end
)
