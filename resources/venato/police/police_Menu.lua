--====================================================================================
-- #Author: Jonathan D @ Gannon
--
-- Développée pour la communauté n3mtv
--      https://www.twitch.tv/n3mtv
--      https://twitter.com/n3m_tv
--      https://www.facebook.com/lan3mtv
--====================================================================================

local missionP = {}
local alreadyTakeMission = false

local defaultNotification = {
	type = "alert",
	title ="LSPD",
	logo = "https://i.ibb.co/K7Cv1Sx/icons8-police-badge-96px.png"
  }

	function updateMenuMissionPoliceeee(newUrgenceMenu, bool)
		missionP = newUrgenceMenu
    alreadyTakeMission = bool
end

function openMenuPoliceGeneral()
    TriggerEvent('Menu:Clear')
    TriggerEvent('Menu:Init', "Police", "<small>"..rank.."</small>", '#1565C099', "https://www.lunel.com/sites/default/files/styles/tetiere/public/tetiere/menu_icon_2939.jpg?itok=q2gesIzz")

  	TriggerEvent('Menu:AddButton2',"Missions en cours", "policeGetMissionMenu", rank, '')
    TriggerEvent('Menu:AddButton2', "Amendes", "POLICE_AmendeMenu", { rank = rank }, "", "https://i.ibb.co/TRSRb5n/icons8-agreement-96px-1.png")
    TriggerEvent('Menu:AddButton2', "Placer un objet", "POLICE_ObjectMenu", { rank = rank }, "", "https://i.ibb.co/9n9Y54M/icons8-roadblock-96px-1.png")
    TriggerEvent('Menu:AddButton2', "Verifier la plaque", "POLICE_CheckPlate", {}, "", "https://i.ibb.co/wg04W7Z/icons8-sedan-96px.png") --OK
    TriggerEvent('Menu:AddButton2', "Fouiller", "POLICE_Check", true, "", "https://i.ibb.co/GQJWMRt/icons8-customs-officer-96px.png")
    --TriggerEvent('Menu:AddButton2', "Prendre la carte d'identité de force", "gcl:showItentityOther", {}, "", "https://i.ibb.co/V2vy2Y6/icons8-id-card-96px.png")
    TriggerEvent('Menu:AddButton2', "Menoter", "POLICE_Cuffed", true , "", "https://i.ibb.co/6D2GVzD/icons8-handcuffs-96px.png")
    TriggerEvent('Menu:AddButton2', "Placer dans le véhicle", "POLICE_PutInVehicle", {}, "", "https://i.ibb.co/6YmCDNq/icons8-enter-2-96px.png")
    TriggerEvent('Menu:AddButton2', "Sortir du véhicule", "POLICE_UnseatVehicle", {}, "", "https://i.ibb.co/RvNBRyV/icons8-import-96px.png")
    TriggerEvent('Menu:AddButton2', "Crocheter", "POLICE_Crocheter", {}, "", "https://i.ibb.co/L1yKnXt/icons8-unlock-2-96px.png")
    TriggerEvent('Menu:AddButton2', "Supprimer le Vehicule", "POLICE_deleteVehicle", {}, "", "https://i.ibb.co/JsGXm4z/icons8-tow-truck-96px-1.png")
    TriggerEvent('Menu:AddButton2', "Avis de recherche", "POLICE_sendmsg", {}, "", "https://i.ibb.co/fvtWrv3/icons8-spam-96px.png")
    --Code rouge ?

    TriggerEvent('Menu:CreateMenu')
    TriggerEvent('Menu:Open')
end

function policeGetMissionMenu()
  Menu.clearMenu()
  TriggerEvent('Menu:AddButton2',"<span class='red--text'>Retour</span>", "openMenuPoliceGeneral", rank, '', "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
  for k,v in pairs(missionP) do
    TriggerEvent('Menu:AddButton2',v.Title, v.Function, {mission = v.mission}, '', "")
  end
  if alreadyTakeMission then
    TriggerEvent('Menu:AddButton2',"<span class='red--text'>Terminer la mission</span>", "finishCurrentMissionPolice", nil, '', "")
  end
  Menu.CreateMenu()
end


function POLICE_coderouge()
TriggerServerEvent("POLICE:coderouge")
end

function POLICE_ObjectMenu(data)
    TriggerEvent('Menu:Clear')
    TriggerEvent('Menu:Init', "Placer un objet", "<small>"..data.rank.."</small>", '#1565C099', "https://lejournaldugers.fr/uploads/main_imgs/201712171021488K3x-image(postpage).JPG")

    TriggerEvent('Menu:AddButton2',"<span class='red--text'>Retour</span>", "openMenuPoliceGeneral", data.rank, "", "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
    TriggerEvent('Menu:AddButton2', "Placer/Retirer un radar", "POLICE_radar", {}, "", "https://i.ibb.co/PCYgbCY/icons8-speed-96px.png")
    TriggerEvent('Menu:AddButton2', "Placer/Retirer un cône", "POLICE_removeOrPlaceCone", {}, "", "https://i.ibb.co/hDKjVCq/icons8-vlc-96px.png")
    TriggerEvent('Menu:AddButton2', "Placer/Retirer une barrière", "POLICE_removeOrPlaceBarrier", {}, "", "https://i.ibb.co/rGn6bYN/barrier.png")
    TriggerEvent('Menu:AddButton2', "Placer/Retirer une herse", "POLICE_removeOrPlaceHerse", {}, "", "https://i.ibb.co/4KGGKG5/icons8-flat-tire-96px.png")
    -- TODO Coder le systeme de herse
    TriggerEvent('Menu:AddButton2',"<span class='red--text'>Retour</span>", "openMenuPoliceGeneral", data.rank, "", "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")

    TriggerEvent('Menu:CreateMenu')
    TriggerEvent('Menu:Open')
end

function POLICE_AmendeMenu(data)
    TriggerEvent('Menu:Clear')
    TriggerEvent('Menu:Init', "Amende", "<small>"..data.rank.."</small>", '#1565C099', "https://lejournaldugers.fr/uploads/main_imgs/201712171021488K3x-image(postpage).JPG")
    TriggerEvent('Menu:AddButton2',"<span class='red--text'>Retour</span>", "openMenuPoliceGeneral", data.rank, "", "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
    -- TriggerEvent('Menu:AddShopButton', "Retirer le permis", "POLICE_FINE_DATA", { tarif = 0, points = -1, title = "Retirer le permis" }, "", "", 0)
    TriggerEvent('Menu:AddButton2',"Mettre une amende", "POLICE_FINE_CUSTOM", {}, "", "")
    TriggerEvent('Menu:AddButton2',"<span class='red--text'>Retour</span>", "openMenuPoliceGeneral", data.rank, "", "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")

    TriggerEvent('Menu:CreateMenu')
    TriggerEvent('Menu:Open')
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

        if ( IsPedSittingInAnyVehicle( ped ) ) then
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then
                defaultNotification.message = "Véhicule supprimé"
                venato.notify(defaultNotification)
                SetEntityAsMissionEntity( vehicle, true, true )
                deleteCar( vehicle )
            else
                defaultNotification.message = "Mettez vous à la place du conducteur"
                venato.notify(defaultNotification)
            end
        else
            local playerPos = GetEntityCoords( ped, 1 )
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
            local vehicle = GetVehicleInDirection( playerPos, inFrontOfPlayer )

            if ( DoesEntityExist( vehicle ) ) then
                defaultNotification.message = "Véhicule supprimé"
                venato.notify(defaultNotification)
                SetEntityAsMissionEntity( vehicle, true, true )
                deleteCar( vehicle )
            else
                defaultNotification.message = "Rapprocher vous d'un véhicule"
                venato.notify(defaultNotification)
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
