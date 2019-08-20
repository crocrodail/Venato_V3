--====================================================================================
-- #Author: Jonathan D @ Gannon
--
-- Développée pour la communauté n3mtv
--      https://www.twitch.tv/n3mtv
--      https://twitter.com/n3m_tv
--      https://www.facebook.com/lan3mtv
--====================================================================================

local Menu = {}
local itemMenuGeneralPolice = {}
local itemMenuChoixPoliceService = {}
local itemMenuChoixPoliceVehicle = {}

local UrgencePoliceMenu = {['Title'] = 'Missions en cours',  ['SubMenu'] = {
    ['Title'] = 'Missions en cours', ['Items'] = {
        {['Title'] = 'Retour', ['ReturnBtn'] = true },
        {['Title'] = 'Fermer'},
}}}

function updateMenuPolice(newUrgenceMenu)
    itemMenuGeneralPolice.Items[1] = newUrgenceMenu
end

function openMenuPoliceGeneral()
    Menu.item = itemMenuGeneralPolice
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceVehicleCar()
    Menu.item = itemMenuChoixPoliceVehicleCar
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceVehicleCarCadet()
    Menu.item = itemMenuChoixPoliceVehicleCarCadet
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceVehicleCarAgent()
    Menu.item = itemMenuChoixPoliceVehicleCarAgent
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceVehicleCarSergent()
    Menu.item = itemMenuChoixPoliceVehicleCarSergent
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceVehicleCarSergentChef()
    Menu.item = itemMenuChoixPoliceVehicleCarSergentChef
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceVehicleCarLieutenant()
    Menu.item = itemMenuChoixPoliceVehicleCarLieutenant
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceVehicleCarCapitaine()
    Menu.item = itemMenuChoixPoliceVehicleCarCapitaine
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixSecretVehicleCar()
    Menu.item = itemMenuChoixSecretVehicleCar
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceVehicleHeli()
    Menu.item = itemMenuChoixPoliceVehicleHeli
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceServiceCadet()
    Menu.item = itemMenuChoixPoliceServiceCadet
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceServiceAgent()
    Menu.item = itemMenuChoixPoliceServiceAgent
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceServiceSergent()
    Menu.item = itemMenuChoixPoliceServiceSergent
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceServiceSergentChef()
    Menu.item = itemMenuChoixPoliceServiceSergentChef
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceServiceLieutenant()
    Menu.item = itemMenuChoixPoliceServiceLieutenant
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceServiceCapitaine()
    Menu.item = itemMenuChoixPoliceServiceCapitaine
    Menu.isOpen = true
    Menu.initMenu()
end

function POLICE_coderouge()
TriggerServerEvent("POLICE:coderouge")
end

function POLICE_fincoderouge()
TriggerServerEvent("POLICE:fincoderouge")
end

-- The distance to check in front of the player for a vehicle
-- Distance is in GTA units, which are quite big
local distanceToCheck = 5.0

-- Add an event handler for the deleteVehicle event.
-- Gets called when a user types in /dv in chat (see server.lua)
function POLICE_deleteVehicle()
    local ped = GetPlayerPed( -1 )

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
        local pos = GetEntityCoords( ped )
        -- log( "Player is at:\nX: " .. pos.x .. " Y: " .. pos.y .. " Z: " .. pos.z )
        -- log( "Found vehicle?: " .. tostring( DoesEntityExist( vehicle ) ) )

        if ( IsPedSittingInAnyVehicle( ped ) ) then
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then
                ShowNotification( "Vehicule supprime." )
                SetEntityAsMissionEntity( vehicle, true, true )
                deleteCar( vehicle )
            else
                ShowNotification( "Mettez-vous a la place conducteur" )
            end
        else
            local playerPos = GetEntityCoords( ped, 1 )
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
            local vehicle = GetVehicleInDirection( playerPos, inFrontOfPlayer )

            if ( DoesEntityExist( vehicle ) ) then
                -- log( "Distance between ped and vehicle: " .. tostring( GetDistanceBetween( ped, vehicle ) ) )
                ShowNotification( "Vehicle deleted." )
                SetEntityAsMissionEntity( vehicle, true, true )
                deleteCar( vehicle )
            else
                ShowNotification( "Rapprochez-vous d'un vehicule" )
            end
        end
    end
end

-- Delete car function borrowed frtom Mr.Scammer's model blacklist, thanks to him!
function deleteCar(entity)
    TriggerServerEvent('ivt:deleteVeh', GetVehicleNumberPlateText(entity))
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))
    DeleteEntity(entity)
end

-- Gets a vehicle in a certain direction
-- Credit to Konijima
function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end

-- Shows a notification on the player's screen
function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end


itemMenuGeneralPolice = {
    ['Title'] = 'Police',
    ['Items'] = {
        UrgencePoliceMenu,
        {['Title'] = 'Fouiller', ['Function'] = POLICE_Check, Close = false},
        {['Title'] = 'Menoter', ['Function'] = POLICE_Cuffed, Close = false},
	    	{['Title'] = 'Menoter HRP', ['Function'] = POLICE_CuffedHRP, Close = false},
        {['Title'] = 'Placer dans le véhicle', ['Function'] = POLICE_PutInVehicle},
        {['Title'] = 'Sortir du véhicule', ['Function'] = POLICE_UnseatVehicle},
        {['Title'] = 'Amendes',  ['SubMenu'] = {
            ['Title'] = 'Amendes',
            ['Items'] = {
                {['Title'] = 'Code de la Route',  ['SubMenu'] = {
                    ['Title'] = 'Amendes - Code de la route',
                    ['Items'] = {
                        {['Title'] = 'Non respect du code de la route (-1 points)', ['Function'] = POLICE_FINE_DATA, tarif = 800, points = 1, Close = false},
                        {['Title'] = 'Petit Excès vitesse -50km/h', ['Function'] = POLICE_FINE_DATA, tarif = 1500, points = 0,  Close = false},
						            {['Title'] = 'Défaut de permis', ['Function'] = POLICE_FINE_DATA, tarif = 5000, points = 0,  Close = false},
						            {['Title'] = 'Stationnement genant', ['Function'] = POLICE_FINE_DATA, tarif = 1200, points = 0,  Close = false},
                        {['Title'] = 'Grand Excès vitesse +50km/h (-3 points)', ['Function'] = POLICE_FINE_DATA, tarif = 3000, points = 3, Close = false },
                        {['Title'] = 'Conduite dangereuse (-2 points)', ['Function'] = POLICE_FINE_DATA, tarif = 1500, points = 2, Close = false },
                        {['Title'] = 'Véhicule trop endommagé', ['Function'] = POLICE_FINE_DATA, tarif = 1000, points = 0, Close = false },
                        {['Title'] = 'Conduite état ivresse / drogue (-6 points)', ['Function'] = POLICE_FINE_DATA, tarif = 4000, points = 6, Close = false },
                        {['Title'] = 'Délit de fuite (retirer permis)', ['Function'] = POLICE_FINE_DATA, tarif = 20000, points = -1, Close = false },
                        {['Title'] = 'Retirer permis', ['Function'] = POLICE_FINE_DATA, points = -1, Close = false},
                    }
                }},
                {['Title'] = 'Délits et Crimes Pénal',  ['SubMenu'] = {
                    ['Title'] = 'Amendes - Délits et Crimes Pénal',
                    ['Items'] = {
                        {['Title'] = 'Activités illicites', ['Function'] = POLICE_FINE_DATA, tarif = 30000, points = 0, Close = false},
						            {['Title'] = 'Possession d arme blanche', ['Function'] = POLICE_FINE_DATA, tarif = 10000, points = 0, Close = false},
                        {['Title'] = 'Possession d arme a feu', ['Function'] = POLICE_FINE_DATA, tarif = 30000, points = 0, Close = false},
                        {['Title'] = 'Violences', ['Function'] = POLICE_FINE_DATA, tarif = 5000, points = 0, Close = false}, --
                        {['Title'] = 'Vol de véhicule', ['Function'] = POLICE_FINE_DATA, tarif = 50000, points = 0, Close = false}, --
                        --{['Title'] = 'Braquage', ['Function'] = POLICE_FINE_DATA, tarif = 30000, points = 0, Close = false},
                        {['Title'] = 'Dégradations', ['Function'] = POLICE_FINE_DATA, tarif = 5000, points = 0, Close = false},
                        {['Title'] = 'Outrage contre LSPD', ['Function'] = POLICE_FINE_DATA, tarif = 5000, points = 0, Close = false},
                        {['Title'] = 'Violence contre LSPD', ['Function'] = POLICE_FINE_DATA, tarif = 30000, points = 0, Close = false},
                        --{['Title'] = 'Crimes', ['Function'] = POLICE_FINE_DATA, tarif = 70000, points = 0, Close = false},
                    }
                }},
                { ['Title'] = 'Autre', ['Function'] = POLICE_FINE_CUSTOM }, -- policier/chasseur
            }
        }},
	{['Title'] = 'Prendre la carte d\'identité de force', ['Event'] = 'gcl:showItentityOther'},
        {['Title'] = 'Crocheter', ['Function'] = POLICE_Crocheter, Close = false},
        {['Title'] = 'Verifier la plaque', ['Function'] = POLICE_CheckPlate, Close = false},
		{ ['Title'] = 'Placer un objet', ['SubMenu'] = {
					['Title'] = 'Choix de l\'objet :',
					['Items'] = {
								{['Title'] = 'Placer/retirer un Radar', ['Function'] = POLICE_radar, Close = false},
								{['Title'] = 'Placer/retirer un cône', ['Function'] = POLICE_removeOrPlaceCone, Close = false},
								{['Title'] = 'Placer/retirer une barrière', ['Function'] = POLICE_removeOrPlaceBarrier, Close = false},
								--{['Title'] = 'Placer/retirer une herse', ['Function'] = POLICE_removeOrPlaceHerse, Close = false},
                                }
							}
						},
		{ ['Title'] = 'Supprimer le Vehicule', ['SubMenu'] = {
					['Title'] = 'Validation supression:',
					['Items'] = {
								{ ['Title'] = 'Quitter' },
								{ ['Title'] = 'Supprimer le Vehicule',['Function'] = POLICE_deleteVehicle},
                                }
                }
        },
        { ['Title'] = 'CODE ROUGE - Commissariat', ['SubMenu'] = {
              ['Title'] = 'Validation CODE ROUGE:',
              ['Items'] = {
              { ['Title'] = 'Quitter' },
              { ['Title'] = 'CODE ROUGE',['Function'] = POLICE_coderouge},
                          }
                    }
            },
            { ['Title'] = 'Fin du CODE ROUGE - Commissariat', ['SubMenu'] = {
                  ['Title'] = 'Validation fin du CODE ROUGE:',
                  ['Items'] = {
                  { ['Title'] = 'Quitter' },
                  { ['Title'] = 'FIN CODE ROUGE',['Function'] = POLICE_fincoderouge},
                              }
                        }
                },
      {['Title'] = 'Avis de recherche', ['Function'] = POLICE_sendmsg, Close = false},
    }
}

itemMenuChoixPoliceVehicleCarCadet = {
    ['Title'] = 'Police - Choix du véhicule',
    ['Items'] = {
    {['Title'] = 'Ranger véhicule', ['Function'] = POLICE_deletevehicle},
		{['Title'] = 'Cadet - Buffalo', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police2'},
    --{['Title'] = 'Velo', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'policebike'},
    {['Title'] = 'Moto', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'policeb'},
    {['Title'] = 'Transporter', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'policet'},
    {['Title'] = 'Bus', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'pbus'},
    {['Title'] = 'Blinde', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'riot'},

    }
}

itemMenuChoixPoliceVehicleCarAgent = {
    ['Title'] = 'Police - Choix du véhicule',
    ['Items'] = {
    {['Title'] = 'Ranger véhicule', ['Function'] = POLICE_deletevehicle},
    {['Title'] = 'Cadet - Buffalo', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police2'},
		{['Title'] = 'Agent - Cruiser', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police3'},
    {['Title'] = '4x4 - Chevrolet K905', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police6'},
		--{['Title'] = '4x4 - Interceptor 1', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police15'},
		{['Title'] = '4x4 - Interceptor 2', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police13'},
    --{['Title'] = 'Velo', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'policebike'},
    {['Title'] = 'Moto', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'policeb'},
    {['Title'] = 'Transporter', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'policet'},
    {['Title'] = 'Bus', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'pbus'},
    {['Title'] = 'Blinde', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'riot'},
    {['Title'] = 'Banalisé Fourgon', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'speedo'},

    }
}

itemMenuChoixPoliceVehicleCarSergent = {
    ['Title'] = 'Police - Choix du véhicule',
    ['Items'] = {
      {['Title'] = 'Ranger véhicule', ['Function'] = POLICE_deletevehicle},
      {['Title'] = 'Cadet - Buffalo', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police2'},
      {['Title'] = 'Agent - Cruiser', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police3'},
      {['Title'] = '4x4 - Chevrolet K905', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police6'},
      --{['Title'] = '4x4 - Interceptor 1', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police15'},
      {['Title'] = '4x4 - Interceptor 2', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police13'},
      {['Title'] = 'Sergent - Ford', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'police14'},
      --{['Title'] = 'Velo', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'policebike'},
      {['Title'] = 'Moto', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'policeb'},
      {['Title'] = 'Transporter', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'policet'},
      {['Title'] = 'Bus', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'pbus'},
      {['Title'] = 'Blinde', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'riot'},
      {['Title'] = 'Banalisé Fourgon', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'speedo'},

    }
}

itemMenuChoixPoliceVehicleCarSergentChef = {
    ['Title'] = 'Police - Choix du véhicule',
    ['Items'] = {
      {['Title'] = 'Ranger véhicule', ['Function'] = POLICE_deletevehicle},
      {['Title'] = 'Cadet - Buffalo', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police2'},
      {['Title'] = 'Agent - Cruiser', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police3'},
      {['Title'] = '4x4 - Chevrolet K905', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police6'},
      --{['Title'] = '4x4 - Interceptor 1', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police15'},
      {['Title'] = '4x4 - Interceptor 2', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police13'},
      {['Title'] = 'Sergent - Ford', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'police14'},
      {['Title'] = 'Sergent - Dodge', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police12'},
      --{['Title'] = 'Velo', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'policebike'},
      {['Title'] = 'Moto', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'policeb'},
      {['Title'] = 'Transporter', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'policet'},
      {['Title'] = 'Bus', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'pbus'},
      {['Title'] = 'Blinde', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'riot'},
      {['Title'] = 'Banalisé Fourgon', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'speedo'},

    }
}

itemMenuChoixPoliceVehicleCarLieutenant = {
    ['Title'] = 'Police - Choix du véhicule',
    ['Items'] = {
      {['Title'] = 'Ranger véhicule', ['Function'] = POLICE_deletevehicle},
      {['Title'] = 'Cadet - Buffalo', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police2'},
      {['Title'] = 'Agent - Cruiser', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police3'},
      {['Title'] = '4x4 - Chevrolet K905', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police6'},
      --{['Title'] = '4x4 - Interceptor 1', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police15'},
      {['Title'] = '4x4 - Interceptor 2', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police13'},
      {['Title'] = 'Sergent - Ford', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'police14'},
      {['Title'] = 'Sergent - Dodge', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police12'},
      {['Title'] = 'Banalisé', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'police4'},
      {['Title'] = 'Banalisé Felon', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'policefelon'},
      --{['Title'] = 'Secret 4x4', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'xls2'},
      {['Title'] = 'Granger', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'fbi2'},
      {['Title'] = 'Mclaren', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'polmp4'},
      {['Title'] = 'Porsche', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'pol718'},
      {['Title'] = 'Moto', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'policeb'},
      --{['Title'] = 'Velo', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'policebike'},
      {['Title'] = 'Transporter', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'policet'},
      {['Title'] = 'Bus', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'pbus'},
      {['Title'] = 'Blinde', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'riot'},
      {['Title'] = 'Banalisé Fourgon', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'speedo'},
      {['Title'] = 'Oracle2', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'oracle2'},

    }
}

itemMenuChoixPoliceVehicleCarCapitaine = {
    ['Title'] = 'Police - Choix du véhicule',
    ['Items'] = {
      {['Title'] = 'Ranger véhicule', ['Function'] = POLICE_deletevehicle},
      {['Title'] = 'Cadet - Buffalo', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police2'},
      {['Title'] = 'Agent - Cruiser', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police3'},
      {['Title'] = '4x4 - Chevrolet K905', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police6'},
      --{['Title'] = '4x4 - Interceptor 1', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police15'},
      {['Title'] = '4x4 - Interceptor 2', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police13'},
      {['Title'] = 'Sergent - Ford', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'police14'},
      {['Title'] = 'Sergent - Dodge', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police12'},
      {['Title'] = 'Banalisé', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'police4'},
      {['Title'] = 'Banalisé Felon', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'policefelon'},
      --{['Title'] = 'Secret 4x4', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'xls2'},
      {['Title'] = 'Granger', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'fbi2'},
      {['Title'] = 'Ferrari', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'polf430'},
      {['Title'] = 'Aventador', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'polaventa'},
      {['Title'] = 'Moto', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'policeb'},
      --{['Title'] = 'Velo', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'policebike'},
      {['Title'] = 'Transporter', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'policet'},
      {['Title'] = 'Bus', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'pbus'},
      {['Title'] = 'Blinde', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'riot'},
      {['Title'] = 'Banalisé Fourgon', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'speedo'},
      {['Title'] = 'Oracle2', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'oracle2'},

    }
}

itemMenuChoixPoliceVehicleCar = {
    ['Title'] = 'Police - Choix du véhicule',
    ['Items'] = {
		{['Title'] = 'Cadet', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police'},
		{['Title'] = 'Cadet - Ford', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police7'},
    --{['Title'] = 'Sergent - Dodge', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police11'},
    }
}

itemMenuChoixSecretVehicleCar = {
    ['Title'] = 'Secret - Choix du véhicule',
    ['Items'] = {
      {['Title'] = 'Secret 4x4', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'xls2'},
  		{['Title'] = 'Oracle', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'oracle'},
  		{['Title'] = 'Buzzard', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'buzzard2'},
  		{['Title'] = 'Equiper PWD', ['Function'] = POLICE_GiveSpecialWeapon},
  		{['Title'] = 'Tenue Agent', ['Function'] = EquipProcureur},
    }
}

itemMenuChoixPoliceVehicleHeli = {
    ['Title'] = 'Police - Choix du véhicule',
    ['Items'] = {
        {['Title'] = 'Helicopter', ['Function'] = POLICE_invokeVehicle, type = 'Chopper', model = 'polmav'},
    }
}

itemMenuChoixPoliceServiceCadet = {
    ['Title'] = 'Police',
    ['Items'] = {
        {['Title'] = 'Prise de service (10-8)',  ['SubMenu'] = {
            ['Title'] = 'Prise de service (10-8)',
                ['Items'] = {
                    {['Title'] = 'Cadet ', ['Function'] = takeServiceCadet},
                    --{['Title'] = 'Agent ', ['Function'] = takeServiceAgent},
                    --{['Title'] = 'Sergent ', ['Function'] = takeServiceSergent},
                    --{['Title'] = 'Sergent-Chef ', ['Function'] = takeServiceSergentChef},
                    --{['Title'] = 'Lieutenant ', ['Function'] = takeServiceLieutenant},
                    --{['Title'] = 'Capitaine ', ['Function'] = takeServiceCapitaine},
                    --{['Title'] = 'Investigation ', ['Function'] = takeServiceInvestigation},
                    {['Title'] = 'SWAT ', ['Function'] = takeServiceSwat},
                }
            }
        },
        {['Title'] = 'Divers',  ['SubMenu'] = {
            ['Title'] = 'Divers',
                ['Items'] = {
                    {['Title'] = 'Mettre le gilet pare-balles', ['Function'] = equipeVest, type = 'Bulletproof jacket'},
                    {['Title'] = 'Retirer le gilet pare-balles', ['Function'] = equipeVest, type = 'Take offbulletproof jacket'},
                }
            }
        },
        {['Title'] = 'Quitter le service (10-7)', ['Function'] = finishService}
    }
}

itemMenuChoixPoliceServiceAgent = {
    ['Title'] = 'Police',
    ['Items'] = {
        {['Title'] = 'Prise de service (10-8)',  ['SubMenu'] = {
            ['Title'] = 'Prise de service (10-8)',
                ['Items'] = {
                    {['Title'] = 'Cadet ', ['Function'] = takeServiceCadet},
                    {['Title'] = 'Agent ', ['Function'] = takeServiceAgent},
                    --{['Title'] = 'Sergent ', ['Function'] = takeServiceSergent},
                    --{['Title'] = 'Sergent-Chef ', ['Function'] = takeServiceSergentChef},
                    --{['Title'] = 'Lieutenant ', ['Function'] = takeServiceLieutenant},
                    --{['Title'] = 'Capitaine ', ['Function'] = takeServiceCapitaine},
                    {['Title'] = 'Investigation ', ['Function'] = takeServiceInvestigation},
                    {['Title'] = 'SWAT ', ['Function'] = takeServiceSwat},
                }
            }
        },
        {['Title'] = 'Divers',  ['SubMenu'] = {
            ['Title'] = 'Divers',
                ['Items'] = {
                    {['Title'] = 'Mettre le gilet pare-balles', ['Function'] = equipeVest, type = 'Bulletproof jacket'},
                    {['Title'] = 'Retirer le gilet pare-balles', ['Function'] = equipeVest, type = 'Take offbulletproof jacket'},
                }
            }
        },
        {['Title'] = 'Quitter le service (10-7)', ['Function'] = finishService}
    }
}

itemMenuChoixPoliceServiceSergent = {
    ['Title'] = 'Police',
    ['Items'] = {
        {['Title'] = 'Prise de service (10-8)',  ['SubMenu'] = {
            ['Title'] = 'Prise de service (10-8)',
                ['Items'] = {
                    {['Title'] = 'Cadet ', ['Function'] = takeServiceCadet},
                    {['Title'] = 'Agent ', ['Function'] = takeServiceAgent},
                    {['Title'] = 'Sergent ', ['Function'] = takeServiceSergent},
                    --{['Title'] = 'Sergent-Chef ', ['Function'] = takeServiceSergentChef},
                    --{['Title'] = 'Lieutenant ', ['Function'] = takeServiceLieutenant},
                    --{['Title'] = 'Capitaine ', ['Function'] = takeServiceCapitaine},
                    {['Title'] = 'Investigation ', ['Function'] = takeServiceInvestigation},
                    {['Title'] = 'SWAT ', ['Function'] = takeServiceSwat},
                }
            }
        },
        {['Title'] = 'Divers',  ['SubMenu'] = {
            ['Title'] = 'Divers',
                ['Items'] = {
                    {['Title'] = 'Mettre le gilet pare-balles', ['Function'] = equipeVest, type = 'Bulletproof jacket'},
                    {['Title'] = 'Retirer le gilet pare-balles', ['Function'] = equipeVest, type = 'Take offbulletproof jacket'},
                }
            }
        },
        {['Title'] = 'Quitter le service (10-7)', ['Function'] = finishService}
    }
}

itemMenuChoixPoliceServiceSergentChef = {
    ['Title'] = 'Police',
    ['Items'] = {
        {['Title'] = 'Prise de service (10-8)',  ['SubMenu'] = {
            ['Title'] = 'Prise de service (10-8)',
                ['Items'] = {
                    {['Title'] = 'Cadet ', ['Function'] = takeServiceCadet},
                    {['Title'] = 'Agent ', ['Function'] = takeServiceAgent},
                    {['Title'] = 'Sergent ', ['Function'] = takeServiceSergent},
                    {['Title'] = 'Sergent-Chef ', ['Function'] = takeServiceSergentChef},
                    --{['Title'] = 'Lieutenant ', ['Function'] = takeServiceLieutenant},
                    --{['Title'] = 'Capitaine ', ['Function'] = takeServiceCapitaine},
                    {['Title'] = 'Investigation ', ['Function'] = takeServiceInvestigation},
                    {['Title'] = 'SWAT ', ['Function'] = takeServiceSwat},
                }
            }
        },
        {['Title'] = 'Divers',  ['SubMenu'] = {
            ['Title'] = 'Divers',
                ['Items'] = {
                    {['Title'] = 'Mettre le gilet pare-balles', ['Function'] = equipeVest, type = 'Bulletproof jacket'},
                    {['Title'] = 'Retirer le gilet pare-balles', ['Function'] = equipeVest, type = 'Take offbulletproof jacket'},
                }
            }
        },
        {['Title'] = 'Quitter le service (10-7)', ['Function'] = finishService}
    }
}

itemMenuChoixPoliceServiceLieutenant = {
    ['Title'] = 'Police',
    ['Items'] = {
        {['Title'] = 'Prise de service (10-8)',  ['SubMenu'] = {
            ['Title'] = 'Prise de service (10-8)',
                ['Items'] = {
                    {['Title'] = 'Cadet ', ['Function'] = takeServiceCadet},
                    {['Title'] = 'Agent ', ['Function'] = takeServiceAgent},
                    {['Title'] = 'Sergent ', ['Function'] = takeServiceSergent},
                    --{['Title'] = 'Sergent-Chef ', ['Function'] = takeServiceSergentChef},
                    {['Title'] = 'Lieutenant ', ['Function'] = takeServiceLieutenant},
                    --{['Title'] = 'Capitaine ', ['Function'] = takeServiceCapitaine},
                    {['Title'] = 'Investigation ', ['Function'] = takeServiceInvestigation},
                    {['Title'] = 'SWAT ', ['Function'] = takeServiceSwat},
                }
            }
        },
        {['Title'] = 'Divers',  ['SubMenu'] = {
            ['Title'] = 'Divers',
                ['Items'] = {
                    {['Title'] = 'Mettre le gilet pare-balles', ['Function'] = equipeVest, type = 'Bulletproof jacket'},
                    {['Title'] = 'Retirer le gilet pare-balles', ['Function'] = equipeVest, type = 'Take offbulletproof jacket'},
                }
            }
        },
        {['Title'] = 'Quitter le service (10-7)', ['Function'] = finishService}
    }
}

itemMenuChoixPoliceServiceCapitaine = {
    ['Title'] = 'Police',
    ['Items'] = {
        {['Title'] = 'Prise de service (10-8)',  ['SubMenu'] = {
            ['Title'] = 'Prise de service (10-8)',
                ['Items'] = {
                    {['Title'] = 'Cadet ', ['Function'] = takeServiceCadet},
                    {['Title'] = 'Agent ', ['Function'] = takeServiceAgent},
                    {['Title'] = 'Sergent ', ['Function'] = takeServiceSergent},
                    --{['Title'] = 'Sergent-Chef ', ['Function'] = takeServiceSergentChef},
                    {['Title'] = 'Lieutenant ', ['Function'] = takeServiceLieutenant},
                    {['Title'] = 'Capitaine ', ['Function'] = takeServiceCapitaine},
                    {['Title'] = 'Investigation ', ['Function'] = takeServiceInvestigation},
                    {['Title'] = 'SWAT ', ['Function'] = takeServiceSwat},
                }
            }
        },
        {['Title'] = 'Divers',  ['SubMenu'] = {
            ['Title'] = 'Divers',
                ['Items'] = {
                    {['Title'] = 'Mettre le gilet pare-balles', ['Function'] = equipeVest, type = 'Bulletproof jacket'},
                    {['Title'] = 'Retirer le gilet pare-balles', ['Function'] = equipeVest, type = 'Take offbulletproof jacket'},
                }
            }
        },
        {['Title'] = 'Quitter le service (10-7)', ['Function'] = finishService}
    }
}
--====================================================================================
--  Option Menu
--====================================================================================
Menu.backgroundColor = { 52, 73, 94, 196 }
Menu.backgroundColorActive = {243, 156, 18, 255}
Menu.tileTextColor = {243, 156, 18, 255}
Menu.tileBackgroundColor = { 255,255,255, 255 }
Menu.textColor = { 255,255,255,255 }
Menu.textColorActive = { 255,255,255, 255 }

Menu.keyOpenMenu = 170 -- N+
Menu.keyUp = 172 -- PhoneUp
Menu.keyDown = 173 -- PhoneDown
Menu.keyLeft = 174 -- PhoneLeft || Not use next release Maybe
Menu.keyRight =	175 -- PhoneRigth || Not use next release Maybe
Menu.keySelect = 176 -- PhoneSelect
Menu.KeyCancel = 177 -- PhoneCancel
Menu.IgnoreNextKey = false
Menu.posX = 0.05
Menu.posY = 0.05

Menu.ItemWidth = 0.20
Menu.ItemHeight = 0.03

Menu.isOpen = false   -- /!\ Ne pas toucher
Menu.currentPos = {1} -- /!\ Ne pas toucher

--====================================================================================
--  Menu System
--====================================================================================

function Menu.drawRect(posX, posY, width, heigh, color)
    DrawRect(posX + width / 2, posY + heigh / 2, width, heigh, color[1], color[2], color[3], color[4])
end

function Menu.initText(textColor, font, scale)
    font = font or 0
    scale = scale or 0.35
    SetTextFont(font)
    SetTextScale(0.0,scale)
    SetTextCentre(true)
    SetTextDropShadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)
    SetTextColour(textColor[1], textColor[2], textColor[3], textColor[4])
    SetTextEntry("STRING")
end

function Menu.draw()
    -- Draw Rect
    local pos = 0
    local menu = Menu.getCurrentMenu()
    local selectValue = Menu.currentPos[#Menu.currentPos]
    local nbItem = #menu.Items
    -- draw background title & title
    Menu.drawRect(Menu.posX, Menu.posY , Menu.ItemWidth, Menu.ItemHeight * 2, Menu.tileBackgroundColor)
    Menu.initText(Menu.tileTextColor, 4, 0.7)
    AddTextComponentString(menu.Title)
    DrawText(Menu.posX + Menu.ItemWidth/2, Menu.posY)

    -- draw bakcground items
    Menu.drawRect(Menu.posX, Menu.posY + Menu.ItemHeight * 2, Menu.ItemWidth, Menu.ItemHeight + (nbItem-1)*Menu.ItemHeight, Menu.backgroundColor)
    -- draw all items
    for pos, value in pairs(menu.Items) do
        if pos == selectValue then
            Menu.drawRect(Menu.posX, Menu.posY + Menu.ItemHeight * (1+pos), Menu.ItemWidth, Menu.ItemHeight, Menu.backgroundColorActive)
            Menu.initText(Menu.textColorActive)
        else
            Menu.initText(value.TextColor or Menu.textColor)
        end
        AddTextComponentString(value.Title)
        DrawText(Menu.posX + Menu.ItemWidth/2, Menu.posY + Menu.ItemHeight * (pos+1))
    end

end

function Menu.getCurrentMenu()
    local currentMenu = Menu.item
    for i=1, #Menu.currentPos - 1 do
        local val = Menu.currentPos[i]
        currentMenu = currentMenu.Items[val].SubMenu
    end
    return currentMenu
end

function Menu.initMenu()
    Menu.currentPos = {1}
    Menu.IgnoreNextKey = true
end

function Menu.keyControl()
    if Menu.IgnoreNextKey == true then
        Menu.IgnoreNextKey = false
        return
    end
    if IsControlJustPressed(1, Menu.keyDown) then
        local cMenu = Menu.getCurrentMenu()
        local size = #cMenu.Items
        local slcp = #Menu.currentPos
        Menu.currentPos[slcp] = (Menu.currentPos[slcp] % size) + 1

    elseif IsControlJustPressed(1, Menu.keyUp) then
        local cMenu = Menu.getCurrentMenu()
        local size = #cMenu.Items
        local slcp = #Menu.currentPos
        Menu.currentPos[slcp] = ((Menu.currentPos[slcp] - 2 + size) % size) + 1

    elseif IsControlJustPressed(1, Menu.KeyCancel) then
        table.remove(Menu.currentPos)
        if #Menu.currentPos == 0 then
            Menu.isOpen = false
        end

    elseif IsControlJustPressed(1, Menu.keySelect)  then
        local cSelect = Menu.currentPos[#Menu.currentPos]
        local cMenu = Menu.getCurrentMenu()
        if cMenu.Items[cSelect].SubMenu ~= nil then
            Menu.currentPos[#Menu.currentPos + 1] = 1
        else
            if cMenu.Items[cSelect].ReturnBtn == true then
                table.remove(Menu.currentPos)
                if #Menu.currentPos == 0 then
                    Menu.isOpen = false
                end
            else
                if cMenu.Items[cSelect].Function ~= nil then
                    cMenu.Items[cSelect].Function(cMenu.Items[cSelect])
                end
                if cMenu.Items[cSelect].Event ~= nil then
                    TriggerEvent(cMenu.Items[cSelect].Event, cMenu.Items[cSelect])
                end
                if cMenu.Items[cSelect].Close == nil or cMenu.Items[cSelect].Close == true then
                    Menu.isOpen = false
                end
            end
        end
    end

end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
        if IsControlJustPressed(1, Menu.keyOpenMenu) and GetLastInputMethod(2) then
            Menu.isOpen = false
        end
        if Menu.isOpen then
            Menu.draw()
            Menu.keyControl()
        end
	end
end)
