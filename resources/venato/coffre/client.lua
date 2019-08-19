local DataCoffre = {}
local DataUser = {}

local coffre_index = 0

local defaultNotification = {
  title = 'Coffre',
  type = "alert",
  logo = "https://i.ibb.co/Sn8gqHX/icons8-safe-96px.png"
}

RegisterNetEvent("VenatoSpawn")
AddEventHandler("VenatoSpawn", function()
  TriggerServerEvent("Coffre:CallData")
end)

RegisterNetEvent("Coffre:CallData:cb")
AddEventHandler("Coffre:CallData:cb", function(Coffre, user)
  DataCoffre = Coffre
  DataUser = user or {}  
  print(coffre_index)
  if coffre_index ~= 0 then
    TriggerEvent('Menu:Clear')
    TriggerEvent('Menu:Init', DataCoffre[coffre_index].nom, "Coffre", 'rgba('..DataCoffre[coffre_index].red..','..DataCoffre[coffre_index].green..','..DataCoffre[coffre_index].blue..', 0.75)', "https://cap.img.pmdstatic.net/fit/http.3A.2F.2Fprd2-bone-image.2Es3-website-eu-west-1.2Eamazonaws.2Ecom.2Fcap.2F2017.2F05.2F09.2F1c21c36a-b809-4662-bf09-1068218410b9.2Ejpeg/750x375/background-color/ffffff/quality/70/fichet-bauche-la-success-story-du-roi-du-coffre-fort-1123519.jpg" )
    Menu.setTitle( DataCoffre[coffre_index].nom)
    Menu.setSubtitle( "Coffre :")
    TriggerEvent('Menu:AddButton2', "Parametres","CoffreParametre", coffre_index, '', "https://i.ibb.co/cQmJ84r/icons8-administrative-tools-96px.png")
    TriggerEvent('Menu:AddButton2', Venato.FormatMoney(DataCoffre[coffre_index].argent,2).."€ / "..Venato.FormatMoney(DataCoffre[coffre_index].argentcapacite,2).."€", "CoffreMenuMoney", coffre_index, '', "https://i.ibb.co/rZfQxnn/icons8-banknotes-96px.png")
    TriggerEvent('Menu:AddButton2', "Armes", "CoffreWeapon", coffre_index, '', "https://i.ibb.co/xfFb7R6/icons8-gun-96px.png")
    TriggerEvent('Menu:AddButton2', "Déposer des objets", "CoffreAddItem", coffre_index, '', "https://i.ibb.co/CQjDCTX/icons8-safe-in-96px-1.png")
    for k,v in pairs(DataCoffre[coffre_index].inventaire) do
      if v.quantity ~= 0 then
        TriggerEvent('Menu:AddShopButton', v.libelle, "CoffreTakeItem", {coffre_index, k}, v.picture, v.quantity, '', true)
      end
    end
    TriggerEvent('Menu:CreateMenu')
    TriggerEvent('Menu:Open')
  end

end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local x,y,z = table.unpack(GetEntityCoords(Venato.GetPlayerPed(), true))
    for k,v in pairs(DataCoffre) do
      if Vdist(x, y, z, v.x, v.y, v.z) < 1 then
        Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ Pour ouvrir le coffre.')
        if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
          OpenCoffre(k)
          Menu.toggle()
        end
      end
      if  Vdist(x, y, z, v.x, v.y, v.z) < 20 then
        DrawMarker(27,v.x,v.y,v.z-0.9,0,0,0,0,0,0,1.0,1.0,1.0,v.red,v.green,v.blue,200,0,0,0,0)
      end
    end
  end
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
  local qty =  Venato.OpenKeyboard('', '', 10,"Nombre à déposer")
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
    Venato.notifyError("Il n'y a pas de place pour cette arme.")
  end
end

function CoffreDropWp(row)
  Menu.close()
  TriggerServerEvent("Coffre:DropWeapon", row)  
  OpenCoffre(row[1])
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
    Venato.notifyError("Vous etes trop lourd pour prendre l'arme.")
  end
  OpenCoffre(row[1])
end

function CoffreParametre(index)
  Menu.clearMenu()
  Menu.setTitle( "Parametres")
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenCoffre", index)
  Menu.addButton("Liste des personnes avec l'acces", "CoffreListWhitelist", index)
  Menu.addButton("Donner l'acces à une personne", "CoffreAddWhitelist", index)
end

function CoffreAddWhitelist(index)
  Menu.clearMenu()
  Menu.setTitle( "Personne à proximité")
  player, dist = Venato.ClosePlayer()
  if player ~= 0 and player ~= nil and dist < 10 then
    TriggerServerEvent("Coffre:CallDataClosePlayer", index, player)
  else
    Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "CoffreParametre", index)
    Menu.addButton("Aucune personne à proximité", "CoffreParametre", index)
  end
end

RegisterNetEvent("Coffre:CallDataClosePlayer:cb")
AddEventHandler("Coffre:CallDataClosePlayer:cb", function(Coffre, index, user)
  DataCoffre = Coffre
  local DataUserClose = user
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "CoffreParametre", index)
  Menu.addButton("Whitelister "..DataUserClose.Prenom.." "..DataUserClose, "CoffreWhitelistPlayer", {index, user})
end)

function CoffreWhitelistPlayer(row)
  TriggerServerEvent("Coffre:CoffreWhitelistPlayer", row)
  Menu.close()  
  OpenCoffre(row[1])
end

function CoffreListWhitelist(index)
  Menu.clearMenu()
  Menu.setTitle( "Whitelist")
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "CoffreParametre", index)
  for k,v in pairs(DataCoffre[index].whitelist) do
    Menu.addButton(v.prenom.." "..v.nom, "unwhitelist", {index, v.identifier, v.nom, v.prenom})
  end
end

function unwhitelist(row)
  Menu.clearMenu()
  Menu.setTitle( "Voulez déwhitlister "..row[4].." "..row[3])
  Menu.addButton("Non", "CoffreListWhitelist", row[1])
  Menu.addButton("Déwhitelist "..row[4].." "..row[3], "confirmUnWhitelist", row)
end

function confirmUnWhitelist(row)
  TriggerServerEvent("Coffre:UnWhitelist", row)  
  OpenCoffre(row[1])
end

function CoffreMenuMoney(index)
  Menu.clearMenu()
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenCoffre", index)
  Menu.addButton("Prendre de l'argents", "CoffreTakeMoney", index)
  Menu.addButton("Déposer de l'argents", "CoffreDropMoney", index)
end

function CoffreTakeItem(row)
  local qty =  Venato.OpenKeyboard('', '', 3,"Nombre à prendre")
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 and tonumber(qty) <= DataCoffre[row[1]].inventaire[row[2]].quantity and DataCoffre[row[1]].inventaire[row[2]].uPoid * qty <= DataUser.PoidMax then
    TriggerServerEvent("Coffre:TakeItems", qty , row)
  else
    Venato.notifyError("Une erreur est survenue.")
  end
  OpenCoffre(row[1])
end

function CoffreTakeMoney(index)
  local qty =  Venato.OpenKeyboard('', '', 10,"Nombre à prendre")
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 and tonumber(qty) <= DataCoffre[index].argent and Venato.MoneyToPoid(qty) + DataUser.Poid <= DataUser.PoidMax then
    TriggerServerEvent("Coffre:TakeMoney", qty , index)    
  else
    Venato.notifyError("Une erreur est survenue.")
  end
  OpenCoffre(row[1])
end

function CoffreDropMoney(index)
  local qty =  Venato.OpenKeyboard('', '', 10,"Nombre à prendre")
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 and tonumber(qty) + DataCoffre[index].argent <= DataCoffre[index].argentcapacite then
    TriggerServerEvent("Coffre:DropMoney", qty , index)
  else
    Venato.notifyError("Une erreur est survenue.")
  end
  OpenCoffre(row[1])
end
