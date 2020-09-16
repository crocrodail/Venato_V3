function CoffreAddItem(index)
    Menu.clearMenu()
    TriggerEvent("Menu:Close")
    Menu.setTitle("Mon inventaire")
    TriggerEvent(
        "Menu:AddButton2",
        "<span class='red--text'>Retour</span>",
        "OpenCoffre",
        index,
        "",
        "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png"
    )
    for k, v in pairs(DataUser.Inventaire) do
        if v.quantity > 0 then
            TriggerEvent("Menu:AddShopButton", v.libelle, "CoffreDropItem", {index, k}, v.picture, v.quantity, "", true)
        end
    end
    TriggerEvent("Menu:CreateMenu")
    TriggerEvent("Menu:Open")
end

function CoffreDropItem(row)
    local qty = venato.OpenKeyboard("", "", 10, "Nombre à déposer")
    if tonumber(qty) ~= nil and tonumber(qty) ~= 0 then
        TriggerServerEvent("Coffre:DropItem", qty, row)
    else
        venato.notifyError("Une erreur est survenue.")
    end
    Menu.close()
    Citizen.Wait(500)
    OpenCoffre(row[1])
end


function CoffreTakeItem(row)
    local qty =  venato.OpenKeyboard('', '', 3,"Nombre à prendre")
    if tonumber(qty) ~= nil and tonumber(qty) > 0 and tonumber(qty) <= DataCoffre[row[1]].inventaire[row[2]].quantity and DataCoffre[row[1]].inventaire[row[2]].uPoid * qty <= DataUser.PoidMax then
      TriggerServerEvent("Coffre:TakeItems", qty , row)
    else
      venato.notifyError("Une erreur est survenue.")
    end
    Menu.close()
  end