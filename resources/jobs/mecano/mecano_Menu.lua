local mission = {}
local alreadyTakeMission = false

function updateMenuMeca(newUrgenceMenu, bool)
    mission = newUrgenceMenu
    alreadyTakeMission = bool
end

function MECANO_deleteVehicle()
  local vehicle = GetVehiclePedIsUsing(Venato.GetPlayerPed())
  if tonumber(vehicle) == 0 then
    vehicle = Venato.CloseVehicle()
    Venato.DeleteCar(vehicle)
  else
    Venato.DeleteCar(vehicle)
  end
end

function deleteCar( entity )
    Venato.DeleteCar(entity)
end

function openMenuGeneralMecano()
  Menu.open()
  Menu.setTitle("Mecano")
  Menu.setSubtitle("option")
  Menu.clearMenu()
  Menu.addButton("Missions en cours", "MecanoGetMissionMenu", nil)
  Menu.addButton("Analyse le véhicule", "getStatusVehicle", nil)
  Menu.addButton("Réparation rapide", "repareVehicle", nil)
  Menu.addButton("Réparation complete", "fullRepareVehcile", nil)
  Menu.addButton("Dévérouiller les porte", "unlockVehiculeForAll", nil)
  Menu.addButton("Nettoyer le Vehicule", "MECANO_wash", nil)
  Menu.addButton("Supprimer le Vehicule", "MECANO_deleteVehicle", nil)
  Menu.addButton("Afficher / Cacher aide", "toogleHelperLine", nil)
end

function MecanoGetMissionMenu()
  Menu.clearMenu()
  TriggerEvent('Menu:AddButton2',"<span class='red--text'>Retour</span>", "openMenuGeneralMecano", '', '', "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
  for k,v in pairs(mission) do
    TriggerEvent('Menu:AddButton2',v.Title, v.Function, {mission = v.mission}, '', "")
  end
  if alreadyTakeMission then
    TriggerEvent('Menu:AddButton2',"<span class='red--text'>Terminer la mission</span>", "finishCurrentMission", nil, '', "")
  end
  Menu.CreateMenu()
end
