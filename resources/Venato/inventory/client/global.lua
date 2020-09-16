RegisterNetEvent("Inventory:AnimGive")
AddEventHandler(
  "Inventory:AnimGive",
  function()
    venato.playAnim(
      {
        useLib = true,
        flag = 48,
        lib = "mp_common",
        anim = "givetake2_a",
        timeout = 3333
      }
    )
  end
)

RegisterNetEvent("Inventory:AnimReceive")
AddEventHandler(
  "Inventory:AnimReceive",
  function()
    venato.playAnim(
      {
        useLib = true,
        flag = 48,
        lib = "mp_common",
        anim = "givetake2_b",
        timeout = 3333
      }
    )
  end
)

function SyncData()
  TriggerServerEvent("SyncData")
end

function OpenInventory(wait)
  if wait ~= nil then
    Citizen.Wait(wait)
  end
  TriggerEvent(
    "Menu:Init",
    "00 / " .. PoidMax .. " Kg",
    "Inventaire",
    "#01579B99",
    "https://www.expertpublic.fr/wp-content/uploads/2019/01/se-faire-argent-de-poche.jpg"
  )
  TriggerServerEvent("Inventory:ShowMe")
end

function extOpenInventory()
  Menu.open()
  OpenInventory()
end

Citizen.CreateThread(
  function()
    while true do
      Citizen.Wait(0)

      if IsControlJustPressed(1, Keys["K"]) and GetLastInputMethod(2) then
        Menu.clearMenu()
        if Menu.hidden == true then
          Menu.open()
          OpenInventory()
        else
          Menu.close()
        end
      end
      if
        IsControlJustPressed(1, Keys["BACKSPACE"]) or
          IsControlJustPressed(1, Keys["RIGHTMOUSE"]) and GetLastInputMethod(2)
       then
        if Menu.hidden then
          CloseDoc()
        end
        TriggerEvent("VehicleCoffre:Close")
        Menu.close()
      end

      if ItemsOnTheGround ~= nil then
        local x, y, z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))

        for k, v in pairs(ItemsOnTheGround) do
          local dis = Vdist(x, y, z, v.x, v.y, v.z)
          if dis <= 1 then
            venato.Text3D(v.x, v.y, v.z, "<span class='blue--text'>" .. v.qty .. " " .. v.libelle)
            if not isCommandAdded and oldCommandAdded ~= v.dropId then
              commandHelp.text = "Récupérer " .. v.qty .. " " .. v.libelle
              TriggerEvent("Commands:Add", commandHelp)
              isCommandAdded = v.dropId
            end
            if IsControlJustPressed(1, Keys["E"]) and GetLastInputMethod(2) then
              if (v.qty * v.uPoid + DataUser.Poid) <= PoidMax then
                TriggerServerEvent("Inventory:AddItem", v.qty, v.id)
                TriggerServerEvent("Inventory:DelItemsOnTheGround", k)
                local notif = defaultNotification
                TriggerEvent("Commands:Remove", commandHelp.id)
                oldCommandAdded = v.dropId
                isCommandAdded = nil
                notif.message = "Vous avez ramassé " .. v.qty .. " " .. v.libelle .. " ."
                notif.logo = v.picture
                notif.title = "Inventaire"
                venato.notify(defaultNotification)
                local pedCoords = GetEntityCoords(PlayerPedId())
                local objet = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 10.0, GetHashKey(dropItem))
                if objet ~= 0 and objet ~= nil then
                  ForceDeleteObject(objet)
                end
              else
                venato.notifyError("Vous n'avez pas assez de place pour " .. v.qty .. " " .. v.libelle .. " .")
              end
            end
          elseif isCommandAdded == v.dropId and dis > 1 then
            TriggerEvent("Commands:Remove", commandHelp.id)
            isCommandAdded = nil
          elseif dis < 10 then
            venato.Text3D(v.x, v.y, v.z, "~b~" .. v.qty .. " " .. v.libelle)
          end
        end
      end

      if MoneyOnTheGround ~= nil then
        local x, y, z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
        for k, v in pairs(MoneyOnTheGround) do
          local dis = Vdist(x, y, z, v.x, v.y, v.z)
          if dis < 1 then
            venato.Text3D(v.x, v.y, v.z, "~b~" .. venato.FormatMoney(v.qty, 2) .. " €")
            if isCommandAdded == nil and oldCommandAdded ~= v.dropId then
              commandHelp.text = "Récupérer " .. venato.FormatMoney(v.qty, 2) .. " €"
              TriggerEvent("Commands:Add", commandHelp)
              isCommandAdded = v.dropId
            end
            if IsControlJustPressed(1, Keys["E"]) and GetLastInputMethod(2) then
              if (venato.MoneyToPoid(v.qty) + DataUser.Poid) <= PoidMax then
                TriggerServerEvent("Inventory:AddMoney", v.qty)
                TriggerServerEvent("Inventory:DelMoneyOnTheGround", k)
                defaultNotification.logo = "https://i.ibb.co/VgYnKHc/icons8-grab-48px-1.png"
                defaultNotification.message = "Vous avez ramassez " .. venato.FormatMoney(v.qty, 2) .. " € ."
                TriggerEvent("Commands:Remove", commandHelp.id)
                isCommandAdded = nil
                oldCommandAdded = v.dropId
                venato.notify(defaultNotification)
                local pedCoords = GetEntityCoords(PlayerPedId())
                local objet = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 10.0, GetHashKey(dropMoney))
                if objet ~= 0 and objet ~= nil then
                  ForceDeleteObject(objet)
                end
              else
                venato.notifyError("Vous n'avez pas assez de place pour " .. v.qty .. " € .")
              end
            end
          elseif isCommandAdded ~= nil and isCommandAdded == v.dropId and dis > 1 then
            TriggerEvent("Commands:Remove", commandHelp.id)
            isCommandAdded = nil
          elseif dis < 10 then
            venato.Text3D(v.x, v.y, v.z, "~b~" .. v.qty .. " €")
          end
        end
      end

      if WeaponOnTheGround ~= nil then
        local x, y, z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
        for k, v in pairs(WeaponOnTheGround) do
          local dis = Vdist(x, y, z, v.x, v.y, v.z)
          if dis < 1 then
            venato.Text3D(v.x, v.y, v.z, "~b~" .. v.libelle)
            if isCommandAdded == nil and oldCommandAdded ~= v.dropId then
              commandHelp.text = "Récupérer " .. v.libelle
              TriggerEvent("Commands:Add", commandHelp)
              isCommandAdded = v.dropId
            end
            if IsControlJustPressed(1, Keys["E"]) and GetLastInputMethod(2) then
              if v.uPoid + DataUser.Poid <= PoidMax then
                TriggerServerEvent("Inventory:AddWeapon", v.id, v.ammo, v.uPoid, v.libelle)
                TriggerServerEvent("Inventory:DelWeaponOnTheGround", k)
                defaultNotification.logo = "https://i.ibb.co/VgYnKHc/icons8-grab-48px-1.png"
                defaultNotification.message = "Vous avez ramassé " .. v.libelle .. " ."
                venato.notify(defaultNotification)
                TriggerEvent("Commands:Remove", commandHelp.id)
                isCommandAdded = nil
                oldCommandAdded = v.dropId
                local pedCoords = GetEntityCoords(PlayerPedId())
                local objet =
                  GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 10.0, GetHashKey(dropWeapon))
                if objet ~= 0 and objet ~= nil then
                  ForceDeleteObject(objet)
                end
              else
                venato.notifyError("Vous n'avez pas assez de place pour " .. v.libelle .. " .")
              end
            end
          elseif isCommandAdded ~= nil and isCommandAdded == v.dropId and dis > 1 then
            TriggerEvent("Commands:Remove", commandHelp.id)
            isCommandAdded = nil
          elseif dis < 10 then
            venato.Text3D(v.x, v.y, v.z, "~b~" .. v.libelle .. "")
          end
        end
      end
    end
  end
)

function ForceDeleteObject(objet)
  local id = NetworkGetNetworkIdFromEntity(objet)
  TriggerServerEvent("Inventaire:ForceDeleteObject", id)
end

RegisterNetEvent("Inventaire:ForceDeleteObject:cb")
AddEventHandler(
  "Inventaire:ForceDeleteObject:cb",
  function(netId)
    if NetworkHasControlOfNetworkId(netId) then
      DeleteObject(NetToObj(netId))
    end
  end
)

RegisterNetEvent("Inventory:ShowMe:cb")
AddEventHandler(
  "Inventory:ShowMe:cb",
  function(Data)
    Menu.clearMenu()

    local color = "</span>"
    if Data.Poid > 18 then
      color = "<span class='red--text'>"
    elseif Data.Poid > 14 then
      color = "<span class='orange--text'>"
    end
    Menu.setTitle(color .. "" .. Data.Poid .. "</span>/ " .. PoidMax .. " Kg")
    Menu.setSubtitle("Inventaire")

    DataUser = Data
    local WeaponPoid = 0
    for k, v in pairs(Data.Weapon) do
      if v.libelle ~= nil then
        WeaponPoid = WeaponPoid + v.poid
      end
    end

    local MoneyPoid = venato.MoneyToPoid(Data.Money)
    Menu.addItemButton(
      "Argent : <span class='green--text'>" ..
        venato.FormatMoney(Data.Money, 2) .. " €</span> <span class='orange--text'>(" .. MoneyPoid .. " kg)</span>",
      "https://i.ibb.co/rZfQxnn/icons8-banknotes-96px.png",
      "OptionMoney",
      {Data.Money, MoneyPoid, Data.Poid, Data}
    )
    for k, v in pairs(Data.Inventaire) do
      if v.quantity > 0 then
        Menu.addItemButton(
          v.libelle .. " : " .. v.quantity .. " <span class='orange--text'>(" .. v.poid .. " kg)</span>",
          v.picture,
          "OptionItem",
          {v.quantity, v.id, v.libelle, v.uPoid, Data.Poid, v.picture, v.consomable}
        )
      end
    end
    Menu.addItemButton("Clés", "https://i.ibb.co/VwgB5xz/icons8-key-2-96px.png", "MyKeys", Data)
    Menu.addItemButton(
      "Armes <span class='orange--text'>(" .. WeaponPoid .. " kg)</span>",
      "https://i.ibb.co/xfFb7R6/icons8-gun-96px.png",
      "MyWeapon",
      Data
    )
    Menu.addItemButton("Documents", "https://i.ibb.co/c2HDBMf/icons8-documents-96px-2.png", "MyDoc", Data)
    Menu.addItemButton(
      "<span class='red--text'>Syncdata</span>",
      "https://i.ibb.co/Y2QYFcX/icons8-synchronize-96px.png",
      "SyncData",
      {}
    )
  end
)
