function CoffreMenuMoney(index)
    Menu.clearMenu()
    Menu.addItemButton(
        "<span class='red--text'>Retour</span>",
        "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png",
        "OpenCoffre",
        index
    )
    Menu.addButton("Prendre de l'argents", "CoffreTakeMoney", index)
    Menu.addButton("Déposer de l'argents", "CoffreDropMoney", index)
end

function CoffreTakeMoney(index)
    local qty = venato.OpenKeyboard("", "", 10, "Nombre à prendre")
    if
        tonumber(qty) ~= nil and tonumber(qty) > 0 and tonumber(qty) <= DataCoffre[index].argent and
            venato.MoneyToPoid(qty) + DataUser.Poid <= DataUser.PoidMax
     then
        TriggerServerEvent("Coffre:TakeMoney", qty, index)
    else
        venato.notifyError("Une erreur est survenue.")
    end
    Menu.close()
end

function CoffreDropMoney(index)
    local qty = venato.OpenKeyboard("", "", 10, "Nombre à poser")
    if
        tonumber(qty) ~= nil and tonumber(qty) > 0 and
            tonumber(qty) + DataCoffre[index].argent <= DataCoffre[index].argentcapacite and
            DataUser.Money >= tonumber(qty)
     then
        TriggerServerEvent("Coffre:DropMoney", qty, index)
    else
        venato.notifyError("Une erreur est survenue.")
    end
    Menu.close()
end
