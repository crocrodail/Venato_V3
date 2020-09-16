WeaponOnTheGround = {}
WeaponOnTheGroundIndex = 0

RegisterServerEvent("Inventory:DropWeapon")
AddEventHandler(
    "Inventory:DropWeapon",
    function(table, x, y, z)
        WeaponOnTheGroundIndex = WeaponOnTheGroundIndex + 1
        WeaponOnTheGround[WeaponOnTheGroundIndex] = {
            id = table[3],
            dropId = uuid(),
            libelle = table[2],
            ammo = table[5],
            uPoid = table[4],
            x = x,
            y = y,
            z = z,
            poid = table[6]
        }
        ActualiseTableOfWeaponOnTheGround()
    end
)

RegisterServerEvent("Inventory:DelWeaponOnTheGround")
AddEventHandler(
    "Inventory:DelWeaponOnTheGround",
    function(index)
        WeaponOnTheGround[index] = nil
        ActualiseTableOfWeaponOnTheGround()
    end
)

RegisterServerEvent("Inventory:ForceLoadWeapon")
AddEventHandler(
    "Inventory:ForceLoadWeapon",
    function()
        LoadWeapon(source)
    end
)

function ActualiseTableOfWeaponOnTheGround()
    TriggerClientEvent("Inventory:SendWeaponOnTheGround", -1, WeaponOnTheGround)
end

function LoadWeapon(source)
    local Weapon = {}
    local poids = 0
    MySQL.Async.fetchAll(
        "SELECT * FROM weapon_model",
        {},
        function(results)
            if results[1] ~= nil then
                for i, v in ipairs(results) do
                    TriggerClientEvent("Inventory:RemoveWeaponClient", source, v.weapond)
                end
            end
            MySQL.Async.fetchAll(
                "SELECT uw.id as weaponId, uw.balles, w.* FROM user_weapons uw INNER JOIN weapon w ON uw.weapon = w.id WHERE identifier = @SteamId",
                {["@SteamId"] = DataPlayers[tonumber(source)].SteamId},
                function(result)
                    if result[1] ~= nil then
                        for i, v in ipairs(result) do
                            Wp = {
                                ["id"] = v.weapon_id,
                                ["idWeapon"] = v.id,
                                ["weaponId"] = v.weaponId,
                                ["libelle"] = v.libelle,
                                ["weapon_pickup_id"] = v.weapon_pickup_id,
                                ["weapon_hash"] = v.weapon_hash,
                                ["poid"] = tonumber(v.poids),
                                ["ammo"] = tonumber(v.balles),
                                ["round"] = tonumber(v.clip_size)
                            }
                            Weapon[v.weaponId] = Wp
                            poids = poids + tonumber(v.poids)
                            TriggerClientEvent("Inventory:AddWeaponClient", source, v.weapon_id, tonumber(v.balles))
                        end
                        DataPlayers[tonumber(source)].Poid = poids
                        DataPlayers[tonumber(source)].Weapon = Weapon
                    end
                end
            )
        end
    )
end

RegisterServerEvent("Inventory:AddWeapon")
AddEventHandler(
    "Inventory:AddWeapon",
    function(weapon, ammo, poid, libelle, NewSource)
        local source = source
        local libelle = libelle
        local qty = qty
        if NewSource ~= nil then
            source = NewSource
        end
        if poid ~= nil then
            DataPlayers[tonumber(source)].Poid = DataPlayers[tonumber(source)].Poid + poid
        end
        if libelle == nil then
            libelle = "inconue"
        end
        TriggerClientEvent("Inventory:AddWeaponClient", source, weapon, ammo)
        MySQL.Async.fetchScalar(
            "SELECT id FROM weapon WHERE weapon_id = @weapon ORDER BY id DESC",
            {["@weapon"] = weapon},
            function(weapon_id)
                MySQL.Async.execute(
                    "INSERT INTO user_weapons (`identifier`, `weapon`, `balles`) VALUES (@identifier, @weapon_model, @balles)",
                    {
                        ["@identifier"] = DataPlayers[tonumber(source)].SteamId,
                        ["@weapon_model"] = weapon_id,
                        ["@balles"] = ammo
                    },
                    function()
                        LoadWeapon(source)
                    end
                )
            end
        )
    end
)

RegisterServerEvent("Inventory:AddWeaponAmmo")
AddEventHandler(
    "Inventory:AddWeaponAmmo",
    function(index, ammo, NewSource)
        local source = source
        if NewSource ~= nil then
            source = NewSource
        end
        DataPlayers[tonumber(source)].Weapon[tonumber(index)].ammo = ammo
        MySQL.Async.execute(
            "UPDATE user_weapons SET balles = @ammo WHERE id = @index",
            {["@ammo"] = ammo, ["@index"] = index}
        )
    end
)

RegisterServerEvent("Inventory:RemoveWeapon")
AddEventHandler(
    "Inventory:RemoveWeapon",
    function(weapon, id, poid, NewSource)
        local source = source
        local qty = qty
        if NewSource ~= nil then
            source = NewSource
        end
        if poid ~= nil then
            DataPlayers[tonumber(source)].Poid = DataPlayers[tonumber(source)].Poid - poid
        end
        TriggerClientEvent("Inventory:RemoveWeaponClient", source, weapon)
        DataPlayers[tonumber(source)].Weapon[tonumber(id)] = nil
        MySQL.Async.execute("DELETE FROM user_weapons WHERE id = @id", {["@id"] = tonumber(id)})
    end
)

RegisterServerEvent("Inventory:CallInfoWeapon")
AddEventHandler(
    "Inventory:CallInfoWeapon",
    function(ClosePlayer, table)
        local source = source
        if DataPlayers[ClosePlayer].Poid + table[4] <= DataPlayers[ClosePlayer].PoidMax then
            TriggerEvent("Inventory:AddWeapon", table[3], table[5], table[4], table[2], ClosePlayer)
            defaultNotification.message = "Vous avez donné " .. table[2]
            TriggerClientEvent("venato:notify", source, defaultNotification)
            TriggerEvent("Inventory:RemoveWeapon", table[3], table[1], table[4], source)
            TriggerClientEvent("Inventory:AnimReceive", ClosePlayer)
            TriggerClientEvent("Inventory:AnimGive", source)
            defaultNotification.message = "Vous avez reçu " .. table[2]
            TriggerClientEvent("venato:notify", ClosePlayer, defaultNotification)
        else
            TriggerClientEvent("venato:notify", source, "La personne n'a pas la place pour reçevoir une arme.")
            TriggerClientEvent("venato:notify", ClosePlayer, "Vous n'avez pas la place pour reçevoir une arme.")
        end
    end
)
