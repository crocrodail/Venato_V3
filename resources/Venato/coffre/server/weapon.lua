RegisterServerEvent("Coffre:TakeWeapon")
AddEventHandler(
    "Coffre:TakeWeapon",
    function(row)
        local source = source
        if
            DataCoffre[row[1]].weapon[row[2]].poids + DataPlayers[tonumber(source)].Poid <=
                DataPlayers[tonumber(source)].PoidMax
         then
            local indexCoffre = row[1]
            local indexWeapon = row[2]
            MySQL.Async.execute("DELETE FROM coffres_weapons WHERE Id = @indexWeapon", {["@indexWeapon"] = row[2]})
            
            TriggerEvent(
                "Inventory:AddWeapon",
                DataCoffre[indexCoffre].weapon[indexWeapon].weaponModel,
                DataCoffre[indexCoffre].weapon[indexWeapon].balles,
                DataCoffre[indexCoffre].weapon[indexWeapon].poids,
                DataCoffre[indexCoffre].weapon[indexWeapon].libelle,
                source
            )
            DataCoffre[indexCoffre].weapon[indexWeapon] = nil
            DataCoffre[indexCoffre].nbWeapon = DataCoffre[indexCoffre].nbWeapon - 1            
        else
            TriggerClientEvent("venato:notify", source, "Vous n'avez pas assez de place pour prendre l'arme.")
        end
    end
)

RegisterServerEvent("Coffre:DropWeapon")
AddEventHandler(
    "Coffre:DropWeapon",
    function(row)
        if DataCoffre[row[1]].nbWeapon + 1 <= DataCoffre[row[1]].maxWeapon then
            local source = source
            local indexCoffre = row[1]
            local indexWeapon = row[2]

            MySQL.Async.execute(
                "INSERT INTO coffres_weapons (`Weapon`, `CoffreId`, `balles`) VALUES (@weapon, @coffreId, @balles)",
                {
                    ["@weapon"] = DataPlayers[tonumber(source)].Weapon[indexWeapon].idWeapon,
                    ["@coffreId"] = indexCoffre,
                    ["@balles"] = DataPlayers[tonumber(source)].Weapon[indexWeapon].ammo
                },
                function()
                    MySQL.Async.fetchAll(
                        "SELECT CW.Id, W.libelle, W.poids, W.weapon_id  FROM coffres_weapons CW join weapon W ON CW.Weapon = W.id WHERE CW.Weapon = @weapon AND CW.CoffreId = @coffreId ORDER BY Id DESC",
                        {
                            ["@weapon"] = DataPlayers[tonumber(source)].Weapon[indexWeapon].idWeapon,
                            ["@coffreId"] = indexCoffre
                        },
                        function(result)
                            DataCoffre[indexCoffre].weapon[result[1].Id] = {
                                ["weaponId"] = DataPlayers[tonumber(source)].Weapon[indexWeapon].idWeapon,
                                ["weaponModel"] = DataPlayers[tonumber(source)].Weapon[indexWeapon].id,
                                ["libelle"] = result[1].libelle,
                                ["balles"] = DataPlayers[tonumber(source)].Weapon[indexWeapon].ammo or 0,
                                ["poids"] = result[1].poids
                            }
                            TriggerEvent(
                                "Inventory:RemoveWeapon",
                                DataPlayers[tonumber(source)].Weapon[indexWeapon].id,
                                indexWeapon,
                                result[1].poids,
                                source
                            )
                            DataCoffre[indexCoffre].nbWeapon = DataCoffre[indexCoffre].nbWeapon + 1
                            TriggerClientEvent("Coffre:Open", source, indexCoffre)
                        end
                    )
                end
            )
        else
            TriggerClientEvent("venato:notify", source, "Il n'y a pas de place pour cette arme.")
        end
    end
)
