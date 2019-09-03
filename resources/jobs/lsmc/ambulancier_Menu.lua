local mission = {}
local alreadyTakeMission = false

function updateMenuAmbu(newUrgenceMenu, bool)
    mission = newUrgenceMenu
    alreadyTakeMission = bool
end

function toogleServiceAmbulancier()
  Menu.open()
  Menu.setTitle("LSMC")
  Menu.setSubtitle("Choix des tenues  ")
  Menu.clearMenu()
  if not ambulancierIsInService then
    Menu.addButton("Prendre son service", "AmbuOnService", nil)
  else
    Menu.addButton("Quitter son service", "leaveserv", nil)
  	Menu.addButton("Tenue Ambulancier", "Ambulancierf", nil)
    Menu.addButton("Tenue Docteur", "Docteur", nil)
    Menu.addButton("Equiper un stethoscope", "stethoscope", nil)
  	Menu.addButton("Equiper une casquet", "casquet", nil)
    TriggerServerEvent('ambulancier:takeService')
    TriggerServerEvent('ambulancier:requestMission')
  end
end

function openMenuGeneralAmbulancier()
  Menu.clearMenu()
  Menu.open()
  Menu.setTitle('Ambulancier')
  TriggerEvent('Menu:AddButton2',"Missions en cours", "AmbulancierGetMissionMenu", '', '')
  TriggerEvent('Menu:AddButton2',"Soins", "MenuSendEvent", 'ambulancier:Heal', '')
  TriggerEvent('Menu:AddButton2',"Réanimer", "MenuSendEvent", 'ambulancier:Heal2', '')
  TriggerEvent('Menu:AddButton2',"Inspecter le type de bléssure", "MenuSendEvent", 'ambulancier:getBlassure', '')
  TriggerEvent('Menu:AddButton2',"Faire payer", "MenuSendEvent", 'ambulancier:MakePay', '')
  TriggerEvent('Menu:AddButton2',"Placer un objet", "AmbulancierPlaceObjet", '', '')
  --TriggerEvent('Menu:AddButton2',"Déplacé la personne", "AmbulancierPlaceObjet", '', '')
  Menu.CreateMenu()
end

function AmbulancierGetMissionMenu()
  Menu.clearMenu()
  TriggerEvent('Menu:AddButton2',"<span class='red--text'>Retour</span>", "openMenuGeneralAmbulancier", '', '', "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
  for k,v in pairs(mission) do
    TriggerEvent('Menu:AddButton2',v.Title, v.Function, {mission = v.mission}, '', "")
  end
  if alreadyTakeMission then
    TriggerEvent('Menu:AddButton2',"<span class='red--text'>Terminer la mission</span>", "finishMissionAmbulancier", nil, '', "")
  end
  Menu.CreateMenu()
end

function AmbulancierPlaceObjet()
  Menu.clearMenu()
  TriggerEvent('Menu:AddButton2',"<span class='red--text'>Retour</span>", "openMenuGeneralAmbulancier", '', '', "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
  TriggerEvent('Menu:AddButton2',"Placer/retirer un cône", "Ambu_removeOrPlaceCone", '', '', "")
  TriggerEvent('Menu:AddButton2',"Placer/retirer une barrière", "Ambu_removeOrPlaceBarrier", '', '', "")
  Menu.CreateMenu()
end

function openMenuChoixVehicleAmbulancier()
  Menu.open()
  Menu.clearMenu()
  Menu.setTitle('Ambulancier - Choix du véhicule')
  TriggerEvent('Menu:AddButton2',"Ambulance", "invokeVehicle", {type = 1}, '', "")
--  TriggerEvent('Menu:AddButton2',"Vehicule de médecin", "invokeVehicle", {type = 3}, '', "")
  TriggerEvent('Menu:AddButton2',"Quad Emergency", "invokeVehicle", {type = 4}, '', "")
  TriggerEvent('Menu:AddButton2',"Corbillard", "invokeVehicle", {type = 5}, '', "")
  TriggerEvent('Menu:AddButton2',"Ranger le vehicule", "invokeVehicle", {type = -1}, '', "")
  Menu.CreateMenu()
end

function openMenuChoixHelicoAmbulancier()
  Menu.open()
  Menu.clearMenu()
  Menu.setTitle('Ambulancier - Choix du véhicule')
  TriggerEvent('Menu:AddButton2',"Helico", "invokeVehicle", {type = 2}, '', "")
  TriggerEvent('Menu:AddButton2',"Ranger le vehicule", "invokeVehicle", {type = -1}, '', "")
  Menu.CreateMenu()
end
