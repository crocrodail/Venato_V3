local CloseVehicle = nil
local open = false
local VehicleData = {}
local DataUser = {}

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsControlJustPressed(1, Keys['K']) and GetLastInputMethod(2) then
      CloseVehicle = Venato.CloseVehicle()
      if CloseVehicle ~= nil then
        if not open then
          if (GetVehicleDoorLockStatus(CloseVehicle) < 2) then
            if Menu.hidden then
              OpenVehicleCoffre()
            else
              CloseVehicleCoffre()
            end
          else
            Venato.Notify("~r~Vous devez ouvrir le véhicule pour ouvrir le coffre.")
          end
        else
          CloseVehicleCoffre()
        end
      else
        Venato.Notify("~r~Aucun véhicule à proximité.")
      end
    end
  end
end)

function OpenVehicleCoffre()
  open = true
  showPageInfo = true
  SetVehicleDoorOpen(CloseVehicle, 5, false, false)
  local plate = GetVehicleNumberPlateText(CloseVehicle)
  local class = GetVehicleClass(CloseVehicle)
  if plate or class ~= nil then
    TriggerServerEvent("VehicleCoffre:CallData", plate, class)
  else
    Venato.Notify('~r~ERROR ?')
  end
end

function CloseVehicleCoffre()
  open = false
  showPageInfo = false
  SetVehicleDoorShut(CloseVehicle, 5, false)
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
  ClearMenu()
  MenuTitle = "Coffre"
  MenuDescription = "option"
  Menu.addButton("~r~Fermer le coffre", "CloseVehicleCoffre", nil)
  Menu.addButton("~o~Armes", "WeaponCoffreVehicle", nil)
  Menu.addButton("~y~Déposer des items dans le coffre", "DropItemCv", nil)
  Menu.addButton("~r~--------------~g~items~r~-----------------", "none", nil)
  for k,v in pairs(VehicleData) do
    Menu.addButton(v.libelle.." : ~r~"..v.quantity, "OptionItemsCv", k)
  end
end

function WeaponCoffreVehicle()
  ClearMenu()
  MenuTitle = "Armes dans le véhicule"
  Menu.addButton("~r~↩ Retour", "OpenMenuCv", nil)
  Menu.addButton("~o~Déposer une arme", "DropWeaponCv", nil)
  for k,v in pairs(VehicleData.weapon) do
    Menu.addButton(v.libelle.." avec ~r~"..v.balles.."~s~ balles", "OptionWeaponCv", k)
  end
end

function DropItemCv()
  ClearMenu()
  MenuTitle = "mon inventaire"
  for k,v in pairs(DataUser.Inventaire) do
    Menu.addButton(v.libelle.." : ~r~"..v.quantity, "ConfDropItemCv", k)
  end
end

function ConfDropItemCv(index)
  local qty =  Venato.OpenKeyboard('', '0', 10,"Nombre à déposer")
  local plate = GetVehicleNumberPlateText(CloseVehicle)
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 then
    TriggerServerEvent("VehicleCoffre:DropItem", qty , plate, index)
  else
    Venato.notify("~r~Une erreur est survenue.")
  end
end

function OptionItemsCv(index)
  ClearMenu()
  Menu.addButton("~r~↩ Retour", "WeaponCoffreVehicle", nil)
  Menu.addButton("Prendre", "GetItemCv", index)
end

function GetItemCv(index)
  local qty =  Venato.OpenKeyboard('', '0', 10,"Nombre à prendre")
  local plate = GetVehicleNumberPlateText(CloseVehicle)
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 then
    TriggerServerEvent("VehicleCoffre:TakeItems",index, qty, plate)
  else
    Venato.notify("~r~Une erreur est survenue.")
  end
end

function OptionWeaponCv(index)
  ClearMenu()
  Menu.addButton("~r~↩ Retour", "WeaponCoffreVehicle", nil)
  Menu.addButton("Récupérer l'arme", "GetWpCv", index)
end

function GetWpCv(index)
  TriggerServerEvent("VehicleCoffre:TakeWpCv", index, GetVehicleNumberPlateText(CloseVehicle))
end

function DropWeaponCv()
  ClearMenu()
  MenuTitle = "Mes armes"
  Menu.addButton("~r~↩ Retour", "OpenCoffre", index)
  for k,v in pairs(DataUser.weapon) do
    Menu.addButton(v.libelle.." avec ~r~"..v.balles.." balles", "DropConfirmWeaponCv", k)
  end
end

function DropConfirmWeaponCv(index)
  local plate = GetVehicleNumberPlateText(CloseVehicle)
  if VehicleData[plate].nbWeapon + 1 <= VehicleData[plate].maxWeapon then
    ClearMenu()
    MenuTitle = "Voulez vous vraiment déposer l'arme ?"
    Menu.addButton("~r~Non", "DropWeaponCv", nil)
    Menu.addButton("~g~Déposer l'arme dans le coffre", "CoffreVehicleDropWp", index)
  else
    Venato.notify("~r~Il n'y a pas de place pour cette arme.")
    DropWeaponCv()
  end
end

function CoffreVehicleDropWp(index)
  TriggerServerEvent("VehicleCoffre:DropWpCv", index,  GetVehicleNumberPlateText(CloseVehicle))
end
