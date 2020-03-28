local DataCoffre = {}
local DataUser = {}
local isInit = false

local coffre_index = -1

local defaultNotification = {
  title = 'Coffre',
  type = "alert",
  logo = "https://i.ibb.co/Sn8gqHX/icons8-safe-96px.png"
}

RegisterNetEvent("platypusSpawn")
AddEventHandler("platypusSpawn", function()
  TriggerServerEvent("Coffre:CallData")
end)

RegisterNetEvent("Coffre:CallData:cb")
AddEventHandler("Coffre:CallData:cb", function(Coffre, user)
  DataCoffre = Coffre
  DataUser = user or {}
  if coffre_index > 0 then
    TriggerEvent('Menu:Clear')
    TriggerEvent('Menu:Init', DataCoffre[coffre_index].nom, "Coffre", 'rgba('..DataCoffre[coffre_index].red..','..DataCoffre[coffre_index].green..','..DataCoffre[coffre_index].blue..', 0.75)', "https://cap.img.pmdstatic.net/fit/http.3A.2F.2Fprd2-bone-image.2Es3-website-eu-west-1.2Eamazonaws.2Ecom.2Fcap.2F2017.2F05.2F09.2F1c21c36a-b809-4662-bf09-1068218410b9.2Ejpeg/750x375/background-color/ffffff/quality/70/fichet-bauche-la-success-story-du-roi-du-coffre-fort-1123519.jpg" )
    Menu.setTitle( DataCoffre[coffre_index].nom)
    Menu.setSubtitle( "Coffre :")
    TriggerEvent('Menu:AddButton2', "Parametres","CoffreParametre", coffre_index, '', "https://i.ibb.co/cQmJ84r/icons8-administrative-tools-96px.png")

    if DataCoffre[coffre_index].argentcapacite ~= 0 then
    TriggerEvent('Menu:AddButton2', platypus.FormatMoney(DataCoffre[coffre_index].argent,2).."€ / "..platypus.FormatMoney(DataCoffre[coffre_index].argentcapacite,2).."€", "CoffreMenuMoney", coffre_index, '', "https://i.ibb.co/rZfQxnn/icons8-banknotes-96px.png")
    end

    if DataCoffre[coffre_index].maxWeapon ~= 0 then
    TriggerEvent('Menu:AddButton2', "Armes", "CoffreWeapon", coffre_index, '', "https://i.ibb.co/xfFb7R6/icons8-gun-96px.png")
    end

    if DataCoffre[coffre_index].itemcapacite ~= 0 then
      TriggerEvent('Menu:AddButton2', "Déposer des objets", "CoffreAddItem", coffre_index, '', "https://i.ibb.co/CQjDCTX/icons8-safe-in-96px-1.png")
      for k,v in pairs(DataCoffre[coffre_index].inventaire) do
        if v.quantity ~= 0 then
          TriggerEvent('Menu:AddShopButton', v.libelle, "CoffreTakeItem", {coffre_index, k}, v.picture, v.quantity, '', true)
        end
      end
    end
    TriggerEvent('Menu:CreateMenu')
    TriggerEvent('Menu:Open')
  end
end)

RegisterNetEvent("Coffre:CallData:init")
AddEventHandler("Coffre:CallData:init", function(Coffre)
  DataCoffre = Coffre
  for k,v in pairs(DataCoffre) do
    if v.props ~= nil then
      RequestModel(v.props)
      while not HasModelLoaded(v.props) do
        Wait(1)
      end

      local coffre = CreateObject(GetHashKey(v.props), v.x, v.y, v.z, false, false, false)
      SetEntityHeading(coffre, v.h)
      PlaceObjectOnGroundProperly(coffre)
      SetEntityAsMissionEntity(coffre, true, true)
      FreezeEntityPosition(coffre, true)
      SetModelAsNoLongerNeeded(v.props)
    end
  end
end)

local indexLoop = nil
Citizen.CreateThread(function()
  TriggerServerEvent("Coffre:CallData")
  TriggerServerEvent("Coffre:ReloadCoffre")
  while true do
    Citizen.Wait(0)
    local x,y,z = table.unpack(GetEntityCoords(Venato.GetPlayerPed(), true))
    for k,v in pairs(DataCoffre) do
      if Vdist(x, y, z, v.x, v.y, v.z) < (v.props ~= nil and 2 or 0.5) then
        indexLoop = k
      elseif k == indexLoop then
        indexLoop = nil
      end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if indexLoop ~= nil then
      Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour ouvrir '..DataCoffre[indexLoop].nom..'.')
      if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
        TriggerServerEvent("Coffre:CheckWhitelist", indexLoop)
        coffre_index = indexLoop
      end
    end
  end
end)

RegisterNetEvent("Coffre:CheckWhitelist:cb")
AddEventHandler("Coffre:CheckWhitelist:cb", function(result)
  if result.status then
    platypus.playAnim({
      useLib = true,
      flag = 48,
      lib = "missheistfbisetup1",
      anim = "unlock_enter_janitor",
      timeout = 3333
    })
    OpenCoffre(coffre_index)
    Menu.toggle()
  else
    defaultNotification.message = "Vous ne connaissez pas le code de "..DataCoffre[coffre_index].nom
    platypus.notify(defaultNotification)
  end
end)


RegisterNetEvent("Coffre:Open")
AddEventHandler("Coffre:Open", function(id)
  OpenCoffre(id)
end)

function OpenCoffre(index)
  TriggerEvent('Menu:Close')
  Menu.clearMenu()
  coffre_index = index
  TriggerServerEvent("Coffre:CallData")
  Citizen.Wait(0)
end

function CoffreAddItem(index)
  Menu.clearMenu()
  TriggerEvent('Menu:Close')
  Menu.setTitle( "Mon inventaire")
  TriggerEvent('Menu:AddButton2',"<span class='red--text'>Retour</span>", "OpenCoffre", index, '', "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
  for k,v in pairs(DataUser.Inventaire) do
    if v.quantity > 0 then
      TriggerEvent('Menu:AddShopButton', v.libelle, "CoffreDropItem", {index, k}, v.picture, v.quantity, '', true)
    end
  end
  TriggerEvent('Menu:CreateMenu')
  TriggerEvent('Menu:Open')
end

function CoffreDropItem(row)
  local qty =  platypus.OpenKeyboard('', '', 10,"Nombre à déposer")
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 then
    TriggerServerEvent("Coffre:DropItem", qty , row)
  else
    Venato.notifyError("Une erreur est survenue.")
  end
  Menu.close()
  Citizen.Wait(500)
  OpenCoffre(row[1])
end

function CoffreWeapon(index)
  Menu.clearMenu()
  Menu.setTitle( "Armes : "..DataCoffre[index].nbWeapon.." / "..DataCoffre[index].maxWeapon)
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenCoffre", index)
  Menu.addButton("Déposer une arme", "CoffreDropWeapon", index)
  for k,v in pairs(DataCoffre[index].weapon) do
    Menu.addButton(v.libelle.." avec "..v.balles.." balles", "CoffreWeaponOption", {index, k})
  end
end

function CoffreDropWeapon(index)
  Menu.clearMenu()
  Menu.setTitle( "Mes armes")
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenCoffre", index)
  for k,v in pairs(DataUser.Weapon) do
    Menu.addButton(v.libelle.." avec "..v.ammo.." balles", "CoffreConfirmDropWeapon", {index, k})
  end
end

function CoffreConfirmDropWeapon(row)
  if DataCoffre[row[1]].nbWeapon + 1 <= DataCoffre[row[1]].maxWeapon then
    Menu.clearMenu()
    Menu.setTitle( "Voulez vous vraiment déposer l'arme ?")
    Menu.addButton("Non", "CoffreDropWeapon", row[1])
    Menu.addButton("Déposer l'arme dans le coffre", "CoffreDropWp", row)
  else
    platypus.notifyError("Il n'y a pas de place pour cette arme.")
  end
end

function CoffreDropWp(row)
  Menu.close()
  TriggerServerEvent("Coffre:DropWeapon", row)
end


function CoffreWeaponOption(row)
  Menu.clearMenu()
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenCoffre", row[1])
  Menu.addButton("Récuperer l'arme", "CoffreTakeWeapon", row)
end

function CoffreTakeWeapon(row)
  if DataCoffre[row[1]].weapon[row[2]].poid + DataUser.Poid <= DataUser.PoidMax then
    TriggerServerEvent("Coffre:TakeWeapon", row)
  else
    Venato.notifyError("Vous n'avez plus de place pour prendre l'arme.")
  end
  Menu.close()
end

function CoffreParametre(index)
  Menu.clearMenu()
  Menu.setTitle( "Parametres")
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenCoffre", index)
  Menu.addButton("Liste des personnes avec l'accès", "CoffreListWhitelist", index)
  Menu.addButton("Donner l'accès à une personne", "CoffreAddWhitelist", index)
end

function CoffreAddWhitelist(index)
  Menu.clearMenu()
  local name =  platypus.OpenKeyboard('', '', 250,"Nom de la personne à whitelist")
  if name ~= '' then
    TriggerServerEvent("Coffre:CallWhitelistPlayer", index , name)
  else
    platypus.notifyError("Une erreur est survenue.")
  end
end

RegisterNetEvent("Coffre:CallWhitelistPlayer:cb")
AddEventHandler("Coffre:CallWhitelistPlayer:cb", function(data)
  if data.users ~= nil then
    for k,v in pairs(data.users) do
      Menu.addButton("Donner accès à "..v.prenom.." "..v.nom, "CoffreWhitelistPlayer", {data.index, v.identifier})
    end
  end
end)



function CoffreWhitelistPlayer(row)
  TriggerServerEvent("Coffre:CoffreWhitelistPlayer", row)
  Menu.close()
end

function CoffreListWhitelist(index)
  Menu.clearMenu()
  Menu.setTitle( "Accès")
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "CoffreParametre", index)
  TriggerServerEvent("Coffre:GetCoffreWhitelistPlayer", index)
end

RegisterNetEvent("Coffre:GetCoffreWhitelistPlayer:cb")
AddEventHandler("Coffre:GetCoffreWhitelistPlayer:cb", function(data)
  for k,v in pairs(data.whitelist) do
    Menu.addButton(v.prenom.." "..v.nom, "unwhitelist", {v.coffreId, v.id, v.nom, v.prenom})
  end
end)

function unwhitelist(row)
  Menu.clearMenu()
  Menu.setTitle( "Confirmer")
  Menu.addButton("Non", "CoffreListWhitelist", row[1])
  Menu.addButton("Confirmer suppression accès de "..row[4].." "..row[3], "confirmUnWhitelist", row)
end

function confirmUnWhitelist(row)
  TriggerServerEvent("Coffre:UnWhitelist", row)
  Menu.close()
end

function CoffreMenuMoney(index)
  Menu.clearMenu()
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenCoffre", index)
  Menu.addButton("Prendre de l'argents", "CoffreTakeMoney", index)
  Menu.addButton("Déposer de l'argents", "CoffreDropMoney", index)
end

function CoffreTakeItem(row)
  local qty =  platypus.OpenKeyboard('', '', 3,"Nombre à prendre")
  if tonumber(qty) ~= nil and tonumber(qty) > 0 and tonumber(qty) <= DataCoffre[row[1]].inventaire[row[2]].quantity and DataCoffre[row[1]].inventaire[row[2]].uPoid * qty <= DataUser.PoidMax then
    TriggerServerEvent("Coffre:TakeItems", qty , row)
  else
    platypus.notifyError("Une erreur est survenue.")
  end
  Menu.close()
end

function CoffreTakeMoney(index)
  local qty =  Venato.OpenKeyboard('', '', 10,"Nombre à prendre")
  if tonumber(qty) ~= nil and tonumber(qty) > 0 and tonumber(qty) <= DataCoffre[index].argent and Venato.MoneyToPoid(qty) + DataUser.Poid <= DataUser.PoidMax then
    TriggerServerEvent("Coffre:TakeMoney", qty , index)
  else
    platypus.notifyError("Une erreur est survenue.")
  end
  Menu.close()
end

function CoffreDropMoney(index)
  local qty =  platypus.OpenKeyboard('', '', 10,"Nombre à poser")
  if tonumber(qty) ~= nil and tonumber(qty) > 0 and tonumber(qty) + DataCoffre[index].argent <= DataCoffre[index].argentcapacite and DataUser.Money >= tonumber(qty) then
    TriggerServerEvent("Coffre:DropMoney", qty , index)
  else
    platypus.notifyError("Une erreur est survenue.")
  end
  Menu.close()
end
