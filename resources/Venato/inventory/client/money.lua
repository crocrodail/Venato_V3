function OptionMoney(table)
    Menu.clearMenu()
    Menu.addItemButton(
        "<span class='red--text'>Retour</span>",
        "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png",
        "OpenInventory",
        nil
    )
    Menu.addButton("Donner", "GiveMoney", table)
    Menu.addButton("Jeter", "DropMoney", table)
end

function GiveMoney(table)
    local ClosePlayer, distance = venato.ClosePlayer()
    if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
        local nb = venato.OpenKeyboard("", "", 10, "Nombre à donner")
        if tonumber(nb) ~= nil and tonumber(nb) ~= 0 and tonumber(nb) > 0 and table[1] - tonumber(nb) >= 0 then
            TriggerServerEvent("Inventory:CallInfoMoney", ClosePlayer, tonumber(nb), table)
            OpenInventory()
        else
            venato.notifyError("Une erreur dans le nombre choisi.")
        end
    else
        venato.notifyError("Il n'y a personne à proximité.")
    end
end

function DropMoney(tableau)
    local nb = venato.OpenKeyboard("", "", 10, "Nombre à jeter")
    if tonumber(nb) ~= nil and tonumber(nb) ~= 0 then
        if tableau[1] - tonumber(nb) >= 0 then
            local x, y, z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
            TriggerServerEvent("Inventory:DropMoney", tonumber(nb), tableau, x, y, z - 0.5)
            TriggerServerEvent("Inventory:RemoveMoney", tonumber(nb))
            local objet = venato.CreateObject(dropMoney, x, y, z - 1)
            PlaceObjectOnGroundProperly(objet)
            FreezeEntityPosition(objet, true)
            OpenInventory()
        else
            venato.notifyError("Vous ne pouvez pas jeter plus que ce que vous avez.")
        end
    else
        venato.notifyError("Erreur dans le nombre désiré.")
    end
end

RegisterNetEvent("Inventory:SendMoneyOnTheGround")
AddEventHandler(
    "Inventory:SendMoneyOnTheGround",
    function(ParMoneyOnTheGround)
        MoneyOnTheGround = ParMoneyOnTheGround
    end
)

function MyWeapon(Data)
    Menu.clearMenu()
    Menu.addItemButton(
        "<span class='red--text'>Retour</span>",
        "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png",
        "OpenInventory",
        nil
    )
    Menu.setSubtitle("Mes armes")
    for k, v in pairs(Data.Weapon) do
        if v.libelle ~= nil then
            if v.round then
                Menu.addButton(
                    "<span class='blue--text'>" ..
                        v.libelle ..
                            "</span> munitions : <span class='red--text'>" ..
                                v.ammo .. "</span> <span class='orange--text'>( " .. v.poid .. " Kg )</span>",
                    "OptionWeapon",
                    {k, v.libelle, v.id, v.poid, v.ammo, v.round, Data.Poid, v.idWeapon, Data}
                )
            else
                Menu.addButton(
                    "<span class='blue--text'>" ..
                        v.libelle .. "</span> <span class='orange--text'>( " .. v.poid .. " Kg )</span>",
                    "OptionWeapon",
                    {k, v.libelle, v.id, v.poid, v.ammo, v.round, Data.Poid, v.idWeapon, Data}
                )
            end
        end
    end
end
