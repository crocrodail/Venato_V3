--====================================================================================
-- #Author: Jonathan D @ Gannon
--
-- Développée pour la communauté n3mtv
--      https://www.twitch.tv/n3mtv
--      https://twitter.com/n3m_tv
--      https://www.facebook.com/lan3mtv
--====================================================================================

local mission = {}
local alreadyTakeMission = false

function updateMenuTaxi(newUrgenceMenu, bool)
    mission = newUrgenceMenu
    alreadyTakeMission = bool
end

function openMenuGeneralAmbulancier()
  Menu.clearMenu()
  Menu.open()
  Menu.setTitle('Taxi')
  TriggerEvent('Menu:AddButton2',"Missions en cours", "AmbulancierGetMissionMenu", '', '')
  Menu.CreateMenu()
end
