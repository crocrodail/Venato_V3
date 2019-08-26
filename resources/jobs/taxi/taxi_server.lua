function closures_taxi_server()
    local listMissions = {}
    local listPersonnelActive = {}
    local acceptMulti = false
    local preFixEventName = 'taxi'

    local CALL_IA_DRIVER = 3
    local CALL_INFO_WAIT = 2
    local CALL_INFO_OK = 1
    local CALL_INFO_NONE = 0

    -- Notifyle changement de status des missions
    function notifyMissionChangeTAXI(target)
        target = target or -1
        TriggerClientEvent(preFixEventName .. ':MissionChange', target, listMissions)
    end

    function notifyMissionCancelTAXI(source)
        TriggerClientEvent(preFixEventName .. ':MissionCancel', source)
    end

    -- Notify le changement de status des missions
    function notifyPersonnelChangeTAXI(target)
        target = target or -1
        TriggerClientEvent(preFixEventName .. ':personnelChange', target,  getNbPerosnnelActiveTaxi(), getNbPerosnnelDispoTaxi())
     end

    -- Notify un message a tout les personnels
    function notifyAllPersonnelTAXI(MESS)
        TriggerClientEvent(preFixEventName .. ':PersonnelMessage', -1, MESS)
    end

    -- Notify un message un personnel
    function notifyPersonnelTaxi(source, MESS)
        TriggerClientEvent(preFixEventName .. ':PersonnelMessage', source, MESS)
    end

    -- Notify un message un client
    function notifyClientTAXI(source, MESS)
        TriggerClientEvent(preFixEventName .. ':ClientMessage', source, MESS)
    end

    -- Not use || Notify a message a tout le monde
    function notifyAllClientTaxi(MESS)
        TriggerClientEvent(preFixEventName .. ':ClientMessage', -1 , MESS)
    end

    -- Notify call status change
    function notifyCallStatusTaxi(source, status)
        TriggerClientEvent(preFixEventName .. ':callStatus', source, status)
    end


    function addMissionTaxi(source, position, type)
        local sMission = listMissions[source]
        if sMission == nil then
          if getNbPerosnnelDispoTaxi() == 0 and type == "1 personne" then
            TriggerClientEvent(preFixEventName .. ':callAutoTaxi', source, position, type)
            notifyCallStatusTaxi(source, CALL_IA_DRIVER)
          else
            listMissions[source] = {
                id = source,
                pos = position,
                acceptBy = {},
                type = type
            }

            notifyClientTAXI(source, 'CALL_RECU')
            notifyCallStatusTaxi(source, CALL_INFO_WAIT)

            notifyAllPersonnelTAXI('MISSION_NEW')
            notifyMissionChangeTAXI()
          end
        else -- Missions deja en cours
            notifyClientTAXI(source, 'CALL_EN_COURS')
        end
    end

    function closeMissionTaxi(source, missionId)
        if listMissions[missionId] ~= nil then
            for _, v in pairs(listMissions[missionId].acceptBy) do
                if v ~= source then
                    notifyPersonnelTaxi(v, 'MISSION_ANNULE')
                    notifyMissionCancelTAXI(v)
                end
                setInactivePersonnelTaxi(v)
            end
            listMissions[missionId] = nil
            notifyClientTAXI(missionId, 'CALL_FINI')
            notifyCallStatusTaxi(missionId, CALL_INFO_NONE)
            notifyMissionChangeTAXI()
            notifyPersonnelChangeTAXI()
        end
    end

    function personelAcceptMissionTaxi(source, missionId)
        local sMission = listMissions[missionId]
        if sMission == nil then
            notifyPersonnelTaxi(source,'MISSION_INCONNU')
        elseif #sMission.acceptBy ~= 0  and not acceptMulti then
            notifyPersonnelTaxi(source, 'MISSION_EN_COURS')
        else
            removeMeccanoTaxi(source)
            if #sMission.acceptBy >= 1 then
                if sMission.acceptBy[1] ~= source then
                    for _, m in pairs(sMission.acceptBy) do
                        notifyPersonnelTaxi(m, 'MISSION_CONCURENCE')
                    end
                    table.insert(sMission.acceptBy, source)
                end
            else
                table.insert(sMission.acceptBy, source)
                notifyClientTAXI(sMission.id, 'CALL_ACCEPT')
                notifyPersonnelTaxi(source, 'MISSION_ACCEPT')
            end
            TriggerClientEvent(preFixEventName .. ':MissionAccept', source, sMission)
            notifyCallStatusTaxi(missionId, CALL_INFO_OK)
            setActivePersonnelTaxi(source)
            notifyMissionChangeTAXI()
            notifyPersonnelChangeTAXI()
        end
    end

    function removeMeccanoTaxi(personnelId)
        for _, mission in pairs(listMissions) do
            for k, v in pairs(mission.acceptBy) do
                if v == personnelId then
                    table.remove(mission.acceptBy, k)
                    if #mission.acceptBy == 0 then
                        notifyClientTAXI(mission.id, 'CALL_CANCEL')
                        TriggerClientEvent(preFixEventName .. ':callStatus', mission.id, 2)
                        notifyCallStatusTaxi(mission.id, CALL_INFO_WAIT)
                        notifyAllPersonnelTAXI('MISSION_NEW')
                    end
                    break
                end
            end
        end
        removePersonelServiceTaxi(personnelId)
        notifyPersonnelChangeTAXI()
    end

    function removeClientTaxi(clientId)
        if listMissions[clientId] ~= nil then
            for _, v in pairs(listMissions[clientId].acceptBy) do
                notifyPersonnelTaxi(v, 'MISSION_ANNULE')
                notifyMissionCancelTAXI(v)
                setInactivePersonnelTaxi(v)
            end
            listMissions[clientId] = nil
            notifyCallStatusTaxi(clientId, CALL_INFO_NONE)
            notifyMissionChangeTAXI()
            notifyPersonnelChangeTAXI()
        end
    end


    --=========================================================================
    --  Gestion des personnels en service & activité
    --=========================================================================

    function addPersonelServiceTaxi(source)
        listPersonnelActive[source] = false
    end

    function removePersonelServiceTaxi(source)
        listPersonnelActive[source] = nil
    end

    function setActivePersonnelTaxi(source)
        listPersonnelActive[source] = true

    end

    function setInactivePersonnelTaxi(source)
        listPersonnelActive[source] = false
    end

    function getNbPerosnnelActiveTaxi()
        local dispo = 0
        for _, v in pairs(listPersonnelActive) do
            if v ~= nil then
                dispo = dispo + 1
            end
        end
        return dispo
    end

    function getNbPerosnnelDispoTaxi()
        local dispo = 0
        for _, v in pairs(listPersonnelActive) do
            if v == false then
                dispo = dispo + 1
            end
        end
        return dispo
    end

    function getNbPerosnnelBusyTaxi()
        local dispo = 0
        for _, v in pairs(listPersonnelActive) do
            if v == true then
                dispo = dispo + 1
            end
        end
        return dispo
    end

    RegisterServerEvent(preFixEventName .. ':PayAutomaticTaxi')
    AddEventHandler(preFixEventName .. ':PayAutomaticTaxi', function (price)
      TriggerEvent('es:getPlayerFromId', source, function(user)
        user.removeMoney(price)
      end)
    end)

    RegisterServerEvent(preFixEventName .. ':takeService')
    AddEventHandler(preFixEventName .. ':takeService', function ()
        addPersonelServiceTaxi(source)
        notifyPersonnelChangeTAXI()
    end)

    RegisterServerEvent(preFixEventName .. ':endService')
    AddEventHandler(preFixEventName .. ':endService', function ()
        removeMeccanoTaxi(source)
        removePersonelServiceTaxi(source)
    end)

    RegisterServerEvent(preFixEventName .. ':requestMission')
    AddEventHandler(preFixEventName .. ':requestMission', function ()
        notifyMissionChangeTAXI(source)
    end)

    RegisterServerEvent(preFixEventName .. ':requestPersonnel')
    AddEventHandler(preFixEventName .. ':requestPersonnel', function ()
        notifyPersonnelChangeTAXI(source)
    end)

    RegisterServerEvent(preFixEventName .. ':Call')
    AddEventHandler(preFixEventName .. ':Call', function (posX,posY,posZ,type)
        addMissionTaxi(source, {posX, posY, posZ}, type)
    end)

    RegisterServerEvent(preFixEventName .. ':CallCancel')
    AddEventHandler(preFixEventName .. ':CallCancel', function ()
        removeClientTaxi(source)
    end)

    RegisterServerEvent(preFixEventName .. ':AcceptMission')
    AddEventHandler(preFixEventName .. ':AcceptMission', function (id)
        personelAcceptMissionTaxi(source, id)
    end)

    RegisterServerEvent(preFixEventName .. ':FinishMission')
    AddEventHandler(preFixEventName .. ':FinishMission', function (id)
        closeMissionTaxi(source, id)
    end)

    RegisterServerEvent(preFixEventName .. ':cancelCall')
    AddEventHandler(preFixEventName .. ':cancelCall', function ()
        removeClientTaxi(source)
    end)

    AddEventHandler('playerDropped', function()
        removeMeccanoTaxi(source)
        removeClientTaxi(source)
    end)


end

closures_taxi_server()
