function OptionWeapon(table)
    Menu.clearMenu()
    Menu.addItemButton(
        "<span class='red--text'>Retour</span>",
        "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png",
        "MyWeapon",
        table[9]
    )
    if table[6] and venato.HasItem(2022) then
        Menu.addButton(
            "Affecter un chargeur <span class='orange--text'>(+ " .. table[6] .. " munitions)</span>",
            "ReloadWeapon",
            table
        )
    end
    Menu.addButton("Donner", "GiveWeapon", table)
    Menu.addButton("Jeter", "DropWeapon", table)
end

function ReloadWeapon(table)
    if (venato.HasItem(2022)) then
        SetCurrentPedWeapon(venato.GetPlayerPed(),table[3], true)
        TaskReloadWeapon(venato.GetPlayerPed())
        SetPedAmmo(venato.GetPlayerPed(), table[3], table[5] + table[6])
        TriggerServerEvent("Inventory:RemoveItem", 1, 2022)
        TriggerServerEvent("Inventory:AddWeaponAmmo", table[1], table[5] + table[6])
        OpenInventory()
    end
end

function GiveWeapon(table)
    local ClosePlayer, distance = venato.ClosePlayer()
    if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
        TriggerServerEvent("Inventory:CallInfoWeapon", ClosePlayer, table)
        OpenInventory()
    else
        venato.notifyError("Il n'y a personne à proximité.")
    end
end

function DropWeapon(weapon)
    local x, y, z = table.unpack(GetEntityCoords(venato.GetPlayerPed()))
    TriggerServerEvent("Inventory:DropWeapon", weapon, x, y, z - 0.5)
    TriggerServerEvent("Inventory:RemoveWeapon", weapon[3], weapon[1], weapon[4])
    local objet = venato.CreateObject(dropWeapon, x, y + 0.5, z - 1)
    PlaceObjectOnGroundProperly(objet)
    FreezeEntityPosition(objet, true)
    OpenInventory()
end

RegisterNetEvent("Inventory:AddWeaponClient")
AddEventHandler(
    "Inventory:AddWeaponClient",
    function(weapon, ammo)
        local weaponHash = GetHashKey(weapon)
        local ammo = tonumber(ammo)
        if ammo == 0 then
            GiveWeaponToPed(PlayerPedId(), weaponHash, false, false)
        else
            GiveWeaponToPed(PlayerPedId(), weaponHash, ammo, false, false)
        end
    end
)

RegisterNetEvent("Inventory:RemoveWeaponAmmoClient")
AddEventHandler(
    "Inventory:RemoveWeaponAmmoClient",
    function(weapon, ammo)
        local weaponHash = GetHashKey(weapon)
        local ammo = tonumber(ammo)
        SetPedAmmo(venato.GetPlayerPed(), weapon, ammo)
    end
)

RegisterNetEvent("Inventory:RemoveWeaponClient")
AddEventHandler(
    "Inventory:RemoveWeaponClient",
    function(weapon)
        local weaponHash = GetHashKey(weapon)
        SetPedAmmo(venato.GetPlayerPed(), weaponHash, 0)
        RemoveWeaponFromPed(venato.GetPlayerPed(), weaponHash)
    end
)

RegisterNetEvent("Inventory:SendWeaponOnTheGround")
AddEventHandler(
    "Inventory:SendWeaponOnTheGround",
    function(ParWeaponOnTheGround)
        WeaponOnTheGround = ParWeaponOnTheGround
    end
)
