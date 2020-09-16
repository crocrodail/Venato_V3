function CoffreWeapon(index)
    Menu.clearMenu()
    Menu.setTitle("Armes : " .. DataCoffre[index].nbWeapon .. " / " .. DataCoffre[index].maxWeapon)
    Menu.addItemButton(
        "<span class='red--text'>Retour</span>",
        "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png",
        "OpenCoffre",
        index
    )
    Menu.addButton("Déposer une arme", "CoffreDropWeapon", index)
    for k, v in pairs(DataCoffre[index].weapon) do
        Menu.addButton(v.libelle .. " avec " .. v.balles .. " balles", "CoffreWeaponOption", {index, k})
    end
end

function CoffreDropWeapon(index)
    Menu.clearMenu()
    Menu.setTitle("Mes armes")
    Menu.addItemButton(
        "<span class='red--text'>Retour</span>",
        "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png",
        "OpenCoffre",
        index
    )
    for k, v in pairs(DataUser.Weapon) do
        Menu.addButton(v.libelle .. " avec " .. v.ammo .. " balles", "CoffreConfirmDropWeapon", {index, k})
    end
end

function CoffreConfirmDropWeapon(row)
    if DataCoffre[row[1]].nbWeapon + 1 <= DataCoffre[row[1]].maxWeapon then
        Menu.clearMenu()
        Menu.setTitle("Confirmer")
        Menu.addButton("Non", "CoffreDropWeapon", row[1])
        Menu.addButton("Déposer l'arme dans le coffre", "CoffreDropWp", row)
    else
        venato.notifyError("Il n'y a pas de place pour cette arme.")
    end
end

function CoffreDropWp(row)
    Menu.close()
    TriggerServerEvent("Coffre:DropWeapon", row)
end

function CoffreWeaponOption(row)
    Menu.clearMenu()
    Menu.addItemButton(
        "<span class='red--text'>Retour</span>",
        "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png",
        "OpenCoffre",
        row[1]
    )
    Menu.addButton("Récuperer l'arme", "CoffreTakeWeapon", row)
end

function CoffreTakeWeapon(row)
    if DataCoffre[row[1]].weapon[row[2]].poids + DataUser.Poid <= DataUser.PoidMax then
        TriggerServerEvent("Coffre:TakeWeapon", row)
        Citizen.Wait(500)
        TriggerEvent("Coffre:Open", row[1])
    else
        venato.notifyError("Vous n'avez plus de place pour prendre l'arme.")
    end
    Menu.close()
end
