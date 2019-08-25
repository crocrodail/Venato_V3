local CloseVehicle = nil
local open = false
local VehicleData = {}
local DataUser = {}

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsControlJustPressed(1, Keys['L']) and GetLastInputMethod(2) then
      CloseVehicle = Venato.CloseVehicle()
      if CloseVehicle ~= 0 then
        if not open then
          if (GetVehicleDoorLockStatus(CloseVehicle) < 2) then
            if not Menu.Hidden then
              OpenVehicleCoffre()
            else
              CloseVehicleCoffre()
            end
          else
            Venato.notifyError("Vous devez ouvrir le véhicule pour ouvrir le coffre.")
          end
        else
          CloseVehicleCoffre()
        end
      else
        Venato.notifyError("Aucun véhicule à proximité.")
      end
    end
  end
end)

function extOpenCoffreVeh()
  CloseVehicle = Venato.CloseVehicle()
  if CloseVehicle ~= 0 then
    if not open then
      if (GetVehicleDoorLockStatus(CloseVehicle) < 2) then
        if not Menu.Hidden then
          OpenVehicleCoffre()
        else
          CloseVehicleCoffre()
        end
      else
        Venato.notifyError("Vous devez ouvrir le véhicule pour ouvrir le coffre.")
      end
    else
      CloseVehicleCoffre()
    end
  else
    Venato.notifyError("Aucun véhicule à proximité.")
  end
end

function OpenVehicleCoffre()
  open = true
  Menu.open()
  SetVehicleDoorOpen(CloseVehicle, 5, false, false)
  local plate = GetVehicleNumberPlateText(CloseVehicle)
  local class = GetVehicleClass(CloseVehicle)
  if plate or class ~= nil then
    TriggerServerEvent("VehicleCoffre:CallData", plate, class)
  else
    Venato.notifyError('ERROR ?')
  end
end

function CloseVehicleCoffre()
  open = false
  SetVehicleDoorShut(CloseVehicle, 5, false)
  Menu.close()
end

RegisterNetEvent("VehicleCoffre:Close")
AddEventHandler("VehicleCoffre:Close", function()
  CloseVehicleCoffre()
end)

RegisterNetEvent("VehicleCoffre:CallData:cb")
AddEventHandler("VehicleCoffre:CallData:cb", function(data, user)
  VehicleData = data
  DataUser = user
  OpenMenuCv()
end)

RegisterNetEvent("VehicleCoffre:CallData:cb2")
AddEventHandler("VehicleCoffre:CallData:cb2", function(data)
  VehicleData = data
end)

function OpenMenuCv()
  Menu.clearMenu()
  local color = "<span>"
  if VehicleData.nbItems > VehicleData.itemcapacite - (VehicleData.itemcapacite*10/100) then
    color = "<span class='red--text'>"
  elseif VehicleData.nbItems > VehicleData.itemcapacite - (VehicleData.itemcapacite*25/100) then
    color = "<span class='orange--text'>"
  end
  TriggerEvent('Menu:Init', color..""..VehicleData.nbItems.."</span> / "..VehicleData.itemcapacite, "Coffre", '#2E7D3299', "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYDjg60jfde2J-ii7xbyTuU8K8FC1vjK2ebUNTrchvqbTIGI68Xg")
  
  Menu.addButton("Fermer le coffre", "CloseVehicleCoffre", nil)
  Menu.addButton("Armes", "WeaponCoffreVehicle", nil)
  Menu.addButton("Déposer des items dans le coffre", "DropItemCv", nil)
  for k,v in pairs(VehicleData.inventaire) do
    Menu.addItemButton("<span>"..v.libelle.."</span> : <span class='red--text'>"..v.quantity.."</span>", v.picture, "OptionItemsCv", k)
  end
end

function WeaponCoffreVehicle()
  Menu.clearMenu()
  Menu.setTitle( "Armes dans le véhicule")
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenMenuCv", nil)
  Menu.addButton("Déposer une arme", "DropWeaponCv", nil)
  for k,v in pairs(VehicleData.weapon) do
    Menu.addButton(v.libelle.." avec <span class='red--text'>"..v.balles.."</span> balles", "OptionWeaponCv", k)
  end
end

function DropItemCv()
  Menu.clearMenu()
  Menu.setTitle( "Mon inventaire")
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenMenuCv", nil)
  for k,v in pairs(DataUser.Inventaire) do
    if v.quantity ~= 0 then
      Menu.addItemButton(v.libelle.." : <span class='red--text'>"..v.quantity.."</span>", v.picture, "ConfDropItemCv", k)
    end
  end
end

function ConfDropItemCv(index)
  local qty =  Venato.OpenKeyboard('', '', 10,"Nombre à déposer")
  local plate = GetVehicleNumberPlateText(CloseVehicle)
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 then
    TriggerServerEvent("VehicleCoffre:DropItem", qty , plate, index)
  else
    Venato.notifyError("Une erreur est survenue.")
  end
end

function OptionItemsCv(index)
  Menu.clearMenu()
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenMenuCv", nil)
  Menu.addButton("Prendre", "GetItemCv", index)
end

function GetItemCv(index)
  local qty =  Venato.OpenKeyboard('', '', 10,"Nombre à prendre")
  local plate = GetVehicleNumberPlateText(CloseVehicle)
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 then
    TriggerServerEvent("VehicleCoffre:TakeItems",index, qty, plate)
  else
    Venato.notifyError("Une erreur est survenue.")
  end
end

function OptionWeaponCv(index)
  Menu.clearMenu()
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "WeaponCoffreVehicle", nil)
  Menu.addButton("Récupérer l'arme", "GetWpCv", index)
end

function GetWpCv(index)
  TriggerServerEvent("VehicleCoffre:TakeWpCv", index, GetVehicleNumberPlateText(CloseVehicle))
end

function DropWeaponCv()
  Menu.clearMenu()
  Menu.setTitle( "Mes armes")
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenMenuCv", index)
  for k,v in pairs(DataUser.Weapon) do
    Menu.addButton(v.libelle.." avec ~r~"..v.ammo.." balles", "DropConfirmWeaponCv", k)
  end
end

function DropConfirmWeaponCv(index)
  if VehicleData.nbWeapon + 1 <= VehicleData.maxWeapon then
    Menu.clearMenu()
    Menu.setTitle("Confirmation")
    Menu.setSubtitle( "Voulez vous vraiment déposer l'arme ?")
    Menu.addButton("Non", "DropWeaponCv", nil)
    Menu.addButton("Déposer l'arme dans le coffre", "CoffreVehicleDropWp", index)
  else
    Venato.notifyError("Il n'y a pas de place pour cette arme.")
    DropWeaponCv()
  end
end

function CoffreVehicleDropWp(index)
  TriggerServerEvent("VehicleCoffre:DropWpCv", index,  GetVehicleNumberPlateText(CloseVehicle))
end
