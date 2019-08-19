--====================================================================================
-- #Author: Jonathan D @ Gannon
--
-- Développée pour la communauté n3mtv
--      https://www.twitch.tv/n3mtv
--      https://twitter.com/n3m_tv
--      https://www.facebook.com/lan3mtv
--====================================================================================

local Menu = {}
local itemMenuGeneral = {}
local itemMenuChoixCar = {}
local itemMenuChoixHelico = {}

local UrgenceMenu = { ['Title'] = 'Missions en cours',  ['SubMenu'] = {
    ['Title'] = 'Missions en cours', ['Items'] = {
        {['Title'] = 'Retour', ['ReturnBtn'] = true },
        {['Title'] = 'Fermer'},
}}}

function updateMenu(newUrgenceMenu)
    itemMenuGeneral.Items[1] = newUrgenceMenu
end

function openMenuGeneralAmbulancier()
    Menu.item = itemMenuGeneral
    Menu.isOpen = true
    Menu.initMenu()
end

function openMenuChoixVehicleAmbulancier()
Citizen.Trace('open choix ceh')
    Menu.item = itemMenuChoixCar
    Menu.isOpen = true
     Menu.initMenu()
end
function openMenuChoixHelicoAmbulancier()
Citizen.Trace('open choix ceh')
    Menu.item = itemMenuChoixHelico
    Menu.isOpen = true
     Menu.initMenu()
end

function openCustomMenu()

end



itemMenuGeneral = {
    ['Title'] = 'Ambulancier',
    ['Items'] = {
        UrgenceMenu,
        { ['Title'] = 'Soins', ['Event'] = 'ambulancier:Heal'},
        { ['Title'] = 'Réanimer', ['Event'] = 'ambulancier:Heal2'},
        { ['Title'] = 'Inspecter le type de bléssure', ['Event'] = 'ambulancier:getBlassure'},
        { ['Title'] = 'Mettre une facture', ['Event'] = 'facture:amb'},
		{['Title'] = 'Placer un objet', ['SubMenu'] = {
					['Title'] = 'Choix de l\'objet :',
					['Items'] = {
								{['Title'] = 'Placer/retirer un cône', ['Function'] = Ambu_removeOrPlaceCone, Close = false},
								{['Title'] = 'Placer/retirer une barrière', ['Function'] = Ambu_removeOrPlaceBarrier, Close = false},
                                }
							}
						},
        { ['Title'] = 'Liste des factures impayées', ['Event'] = 'fact:entreprise'},
       }
}

itemMenuChoixCar = {
    ['Title'] = 'Ambulancier - Choix du véhicule',
    ['Items'] = {
        {['Title'] = 'Ambulance', ['Function'] = invokeVehicle, type = 1},
    		{['Title'] = 'Vehicule de médecin', ['Function'] = invokeVehicle, type = 3},
    		{['Title'] = 'Quad Emergency', ['Function'] = invokeVehicle, type = 4},
        {['Title'] = 'Corbillard', ['Function'] = invokeVehicle, type = 5},
        --{['Title'] = 'Midlands Air Ambulance', ['Function'] = invokeVehicle, type = 6},
        {['Title'] = ' Mercedes-Benz Sprinter', ['Function'] = invokeVehicle, type = 7},
    		{['Title'] = 'Ranger le vehicule', ['Function'] = invokeVehicle, type = -1},
    }
}
itemMenuChoixHelico = {
    ['Title'] = 'Mecano - Choix du véhicule',
    ['Items'] = {
        {['Title'] = 'Helico', ['Function'] = invokeVehicle, type = 2},
        {['Title'] = 'Ranger le vehicule', ['Function'] = invokeVehicle, type = -1},
    }
}
