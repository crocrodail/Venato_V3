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
            Venato.notifyError("~r~Vous devez ouvrir le véhicule pour ouvrir le coffre.")
          end
        else
          CloseVehicleCoffre()
        end
      else
        Venato.notifyError("~r~Aucun véhicule à proximité.")
      end
    end
  end
end)

function OpenVehicleCoffre()
  open = true
  Menu.open()
  SetVehicleDoorOpen(CloseVehicle, 5, false, false)
  local plate = GetVehicleNumberPlateText(CloseVehicle)
  local class = GetVehicleClass(CloseVehicle)
  if plate or class ~= nil then
    TriggerServerEvent("VehicleCoffre:CallData", plate, class)
  else
    Venato.notifyError('~r~ERROR ?')
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
  local color = ""
  if VehicleData.nbItems > VehicleData.itemcapacite - (VehicleData.itemcapacite*10/100) then
    color = "~r~"
  elseif VehicleData.nbItems > VehicleData.itemcapacite - (VehicleData.itemcapacite*25/100) then
    color = "~o~"
  end
  Menu.setTitle( color..""..VehicleData.nbItems.."~s~ / "..VehicleData.itemcapacite)
  Menu.setSubtitle( "Coffre")
  Menu.addButton("~r~Fermer le coffre", "CloseVehicleCoffre", nil)
  Menu.addButton("~o~Armes", "WeaponCoffreVehicle", nil)
  Menu.addButton("~r~-----------------------  ~g~items~r~  -----------------------", "none", nil)
  Menu.addButton("~y~Déposer des items dans le coffre", "DropItemCv", nil)
  for k,v in pairs(VehicleData.inventaire) do
    Menu.addButton("~b~"..v.libelle.." : ~r~"..v.quantity, "OptionItemsCv", k)
  end
end

function WeaponCoffreVehicle()
  Menu.clearMenu()
  Menu.setTitle( "Armes dans le véhicule")
  Menu.addButton("~r~↩ Retour", "OpenMenuCv", nil)
  Menu.addButton("~o~Déposer une arme", "DropWeaponCv", nil)
  for k,v in pairs(VehicleData.weapon) do
    Menu.addButton(v.libelle.." avec ~r~"..v.balles.."~s~ balles", "OptionWeaponCv", k)
  end
end

function DropItemCv()
  Menu.clearMenu()
  Menu.setTitle( "mon inventaire")
  Menu.addButton("~r~↩ Retour", "OpenMenuCv", nil)
  for k,v in pairs(DataUser.Inventaire) do
    if v.quantity ~= 0 then
      Menu.addButton(v.libelle.." : ~r~"..v.quantity, "ConfDropItemCv", k)
    end
  end
end

function ConfDropItemCv(index)
  local qty =  Venato.OpenKeyboard('', '0', 10,"Nombre à déposer")
  local plate = GetVehicleNumberPlateText(CloseVehicle)
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 then
    TriggerServerEvent("VehicleCoffre:DropItem", qty , plate, index)
  else
    Venato.notifyError("~r~Une erreur est survenue.")
  end
end

function OptionItemsCv(index)
  Menu.clearMenu()
  Menu.addButton("~r~↩ Retour", "WeaponCoffreVehicle", nil)
  Menu.addButton("Prendre", "GetItemCv", index)
end

function GetItemCv(index)
  local qty =  Venato.OpenKeyboard('', '0', 10,"Nombre à prendre")
  local plate = GetVehicleNumberPlateText(CloseVehicle)
  if tonumber(qty) ~= nil and tonumber(qty) ~= 0 then
    TriggerServerEvent("VehicleCoffre:TakeItems",index, qty, plate)
  else
    Venato.notifyError("~r~Une erreur est survenue.")
  end
end

function OptionWeaponCv(index)
  Menu.clearMenu()
  Menu.addButton("~r~↩ Retour", "WeaponCoffreVehicle", nil)
  Menu.addButton("Récupérer l'arme", "GetWpCv", index)
end

function GetWpCv(index)
  TriggerServerEvent("VehicleCoffre:TakeWpCv", index, GetVehicleNumberPlateText(CloseVehicle))
end

function DropWeaponCv()
  Menu.clearMenu()
  Menu.setTitle( "Mes armes")
  Menu.addButton("~r~↩ Retour", "OpenMenuCv", index)
  for k,v in pairs(DataUser.Weapon) do
    Menu.addButton(v.libelle.." avec ~r~"..v.ammo.." balles", "DropConfirmWeaponCv", k)
  end
end

function DropConfirmWeaponCv(index)
  if VehicleData.nbWeapon + 1 <= VehicleData.maxWeapon then
    Menu.clearMenu()
    Menu.setTitle( "Confirmation")
    Menu.setSubtitle( "Voulez vous vraiment déposer l'arme ?")
    Menu.addButton("~r~Non", "DropWeaponCv", nil)
    Menu.addButton("~g~Déposer l'arme dans le coffre", "CoffreVehicleDropWp", index)
  else
    Venato.notifyError("~r~Il n'y a pas de place pour cette arme.")
    DropWeaponCv()
  end
end

function CoffreVehicleDropWp(index)
  TriggerServerEvent("VehicleCoffre:DropWpCv", index,  GetVehicleNumberPlateText(CloseVehicle))
end
