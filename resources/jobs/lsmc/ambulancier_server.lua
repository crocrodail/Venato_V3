
    local listMissionsAmbulancier = {}
    local listPersonnelAmbulancierActive = {}
    local CauseOfDeath = {}
    local acceptMultiAmbulancier = false
    local preFixEventNameAmbulancier = 'ambulancier'

    local CALL_INFO_WAIT = 2
    local CALL_INFO_OK = 1
    local CALL_INFO_NONE = 0

    -- Notifyle changement de status des missions
    function notifyMissionChangeAmbulancier(target)
        target = target or -1
        TriggerClientEvent(preFixEventNameAmbulancier .. ':MissionChange', target, listMissionsAmbulancier)
    end

    -- Notify le changement de status des missions
    function notifyPersonnelAmbulancierChange(target)
        target = target or -1
        TriggerClientEvent(preFixEventNameAmbulancier .. ':personnelChange', target,  getNbPersonnelActiveAmbulancier(), getNbPersonnelDispoAmbulancier())
     end

    -- Notify un message a tout les personnels
    function notifyAllPersonnelAmbulancier(MESS)
        TriggerClientEvent(preFixEventNameAmbulancier .. ':PersonnelMessage', -1, MESS)
    end

    -- Notify un message un personnel
    function notifyPersonnelAmbulancier(source, MESS)
        TriggerClientEvent(preFixEventNameAmbulancier .. ':PersonnelMessage', source, MESS)
    end

    -- Notify un message un client
    function notifyClientAmbulancier(source, MESS)
        TriggerClientEvent(preFixEventNameAmbulancier .. ':ClientMessage', source, MESS)
    end

    function respawnclient(source)
        TriggerClientEvent("respawnamb:callaccept", source)
    end

    -- Not use || Notify a message a tout le monde
    function notifyAllClientAmbulancier(MESS)
        TriggerClientEvent(preFixEventNameAmbulancier .. ':ClientMessage', -1 , MESS)
    end

    -- Notify call status change
    function notifyCallStatusAmbulancier(source, status)
        TriggerClientEvent(preFixEventNameAmbulancier .. ':callStatus', source, status)
    end

    function addMissionAmbulancier(source, type, positionBackUp)
        local sMission = listMissionsAmbulancier[source]
        if sMission == nil then
            local date=os.date(" %X")
            listMissionsAmbulancier[source] = {
                id = source,
                acceptBy = {},
                type = type,
                date = date,
                positionBackUp = positionBackUp,

            }

            notifyClientAmbulancier(source, 'CALL_RECU')
            notifyCallStatusAmbulancier(source, CALL_INFO_WAIT)
            notifyAllPersonnelAmbulancier('MISSION_NEW')
            notifyMissionChangeAmbulancier()
        else -- Missions deja en cours
            notifyClientAmbulancier(source, 'CALL_EN_COURS')
        end
    end

    function closeMissionAmbulancier(source, missionId)
        if listMissionsAmbulancier[missionId] ~= nil then
            for _, v in pairs(listMissionsAmbulancier[missionId].acceptBy) do
                if v ~= source then
                    notifyPersonnelAmbulancier(v, 'MISSION_ANNULE')
                end
                setInactivePersonnelAmbulancier(v)
            end
            listMissionsAmbulancier[missionId] = nil
            notifyClientAmbulancier(missionId, 'CALL_FINI')
            notifyCallStatusAmbulancier(missionId, CALL_INFO_NONE)
            notifyMissionChangeAmbulancier()
            notifyPersonnelAmbulancierChange()
        end
    end

    function personelAcceptMissionAmbulancier(source, missionId)
        local sMission = listMissionsAmbulancier[missionId]
        if sMission == nil then
            notifyPersonnelAmbulancier(source,'MISSION_INCONNU')
        elseif #sMission.acceptBy ~= 0  and not acceptMultiAmbulancier then
            notifyPersonnelAmbulancier(source, 'MISSION_EN_COURS')
        else
            removePersonnelAmbulancier(source)
            if #sMission.acceptBy >= 1 then
                if sMission.acceptBy[1] ~= source then
                    for _, m in pairs(sMission.acceptBy) do
                        notifyPersonnelAmbulancier(m, 'MISSION_CONCURENCE')
                    end
                    table.insert(sMission.acceptBy, source)
                end
            else
                table.insert(sMission.acceptBy, source)
                notifyClientAmbulancier(sMission.id, 'CALL_ACCEPT')
                respawnclient(sMission.id)
                notifyPersonnelAmbulancier(source, 'MISSION_ACCEPT')
            end
            TriggerClientEvent(preFixEventNameAmbulancier .. ':MissionAccept', source, sMission)
            notifyCallStatusAmbulancier(missionId, CALL_INFO_OK)
            setActivePersonnelAmbulancier(source)
            notifyMissionChangeAmbulancier()
            notifyPersonnelAmbulancierChange()
        end
    end

    function removePersonnelAmbulancier(personnelId)
        for _, mission in pairs(listMissionsAmbulancier) do
            for k, v in pairs(mission.acceptBy) do
                if v == personnelId then
                    table.remove(mission.acceptBy, k)
                    if #mission.acceptBy == 0 then
                        notifyClientAmbulancier(mission.id, 'CALL_CANCEL')
                        TriggerClientEvent(preFixEventNameAmbulancier .. ':callStatus', mission.id, 2)
                        notifyCallStatusAmbulancier(mission.id, CALL_INFO_WAIT)
                        notifyAllPersonnelAmbulancier('MISSION_NEW')
                    end
                    break
                end
            end
        end
        removePersonelServiceAmbulancier(personnelId)
        notifyPersonnelAmbulancierChange()
    end

    function removeClientAmbulancier(clientId)
        if listMissionsAmbulancier[clientId] ~= nil then
            for _, v in pairs(listMissionsAmbulancier[clientId].acceptBy) do
                notifyPersonnelAmbulancier(v, 'MISSION_ANNULE')
                setInactivePersonnelAmbulancier(v)
            end
            listMissionsAmbulancier[clientId] = nil
            notifyCallStatusAmbulancier(clientId, CALL_INFO_NONE)
            notifyMissionChangeAmbulancier()
            notifyPersonnelAmbulancierChange()
        end
    end


    --=========================================================================
    --  Gestion des personnels en service & activité
    --=========================================================================

    function addPersonelServiceAmbulancier(source)
        listPersonnelAmbulancierActive[source] = false
    end

    function removePersonelServiceAmbulancier(source)
        listPersonnelAmbulancierActive[source] = nil
    end

    function setActivePersonnelAmbulancier(source)
        listPersonnelAmbulancierActive[source] = true

    end

    function setInactivePersonnelAmbulancier(source)
        listPersonnelAmbulancierActive[source] = false
    end

    function getNbPersonnelActiveAmbulancier()
        local dispo = 0
        for _, v in pairs(listPersonnelAmbulancierActive) do
            if v ~= nil then
                dispo = dispo + 1
            end
        end
        return dispo
    end

    function getNbPersonnelDispoAmbulancier()
        local dispo = 0
        for _, v in pairs(listPersonnelAmbulancierActive) do
            if v == false then
                dispo = dispo + 1
            end
        end
        return dispo
    end

    function getNbPersonnelBusyAmbulancier()
        local dispo = 0
        for _, v in pairs(listPersonnelAmbulancierActive) do
            if v == true then
                dispo = dispo + 1
            end
        end
        return dispo
    end


    RegisterServerEvent(preFixEventNameAmbulancier .. ':takeService')
    AddEventHandler(preFixEventNameAmbulancier .. ':takeService', function ()
        addPersonelServiceAmbulancier(source)
        notifyPersonnelAmbulancierChange()
    end)

    RegisterServerEvent(preFixEventNameAmbulancier .. ':endService')
    AddEventHandler(preFixEventNameAmbulancier .. ':endService', function ()
        removePersonnelAmbulancier(source)
        removePersonelServiceAmbulancier(source)
    end)

    RegisterServerEvent(preFixEventNameAmbulancier .. ':requestMission')
    AddEventHandler(preFixEventNameAmbulancier .. ':requestMission', function ()
        notifyMissionChangeAmbulancier(source)
    end)

    RegisterServerEvent(preFixEventNameAmbulancier .. ':requestPersonnel')
    AddEventHandler(preFixEventNameAmbulancier .. ':requestPersonnel', function ()
        notifyPersonnelAmbulancierChange(source)
    end)

    RegisterServerEvent(preFixEventNameAmbulancier .. ':Call')
    AddEventHandler(preFixEventNameAmbulancier .. ':Call', function (type, positionBackUp)
        addMissionAmbulancier(source, type, positionBackUp)
    end)

    RegisterServerEvent(preFixEventNameAmbulancier .. ':CallCancel')
    AddEventHandler(preFixEventNameAmbulancier .. ':CallCancel', function ()
        removeClientAmbulancier(source)
    end)

    RegisterServerEvent(preFixEventNameAmbulancier .. ':AcceptMission')
    AddEventHandler(preFixEventNameAmbulancier .. ':AcceptMission', function (id)
        personelAcceptMissionAmbulancier(source, id)
    end)

    RegisterServerEvent(preFixEventNameAmbulancier .. ':FinishMission')
    AddEventHandler(preFixEventNameAmbulancier .. ':FinishMission', function (id)
        closeMissionAmbulancier(source, id)
    end)

    RegisterServerEvent(preFixEventNameAmbulancier .. ':cancelCall')
    AddEventHandler(preFixEventNameAmbulancier .. ':cancelCall', function ()
        removeClientAmbulancier(source)
    end)

    AddEventHandler('playerDropped', function()
        removePersonnelAmbulancier(source)
        removeClientAmbulancier(source)
    end)

    RegisterNetEvent("ambulance:infoDeath")
    AddEventHandler("ambulance:infoDeath", function(cause)
      local source = source
      local cause = cause
      CauseOfDeath[source] = cause
    end)

    RegisterNetEvent("ambulance:getInfoReanim")
    AddEventHandler("ambulance:getInfoReanim", function(vict)
      local source = source
      local vict = vict
      TriggerClientEvent("ambulance:ClientGetInfoRea", vict, source)
    end)

    RegisterNetEvent("ambulancier:Reanimation")
    AddEventHandler("ambulancier:Reanimation", function(ambu, coord, heading)
      local source = source
      local ambu = ambu
      TriggerClientEvent("Death:Reanimation", ambu, "medic", coord, heading)
      TriggerClientEvent("Death:Reanimation", source, "victim")
      removeClientAmbulancier(ambu)
    end)

    RegisterNetEvent("ambulancier:GetInTableTheBlassure")
    AddEventHandler("ambulancier:GetInTableTheBlassure", function(sourcePatien)
      local source = source
      local sourcePatien = sourcePatien
      local cause = exports.venato:GetCauseOfDeath()
      local notif = {
        title= "Blessure",
        type = "info", --  danger, error, alert, info, success, warning
        logo = "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Ic%C3%B4ne_de_blessure.svg/1024px-Ic%C3%B4ne_de_blessure.svg.png",
        message = cause,
      }
      TriggerClientEvent("Venato:notify", source, notif)
    end)

    RegisterServerEvent('ambulancier:healHim')
    AddEventHandler('ambulancier:healHim', function(idToHeal)
      TriggerClientEvent('ambulancier:HealMe',idToHeal)
      local notif = {
        title= "LSMC",
        type = "info", --  danger, error, alert, info, success, warning
        logo = "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Ic%C3%B4ne_de_blessure.svg/1024px-Ic%C3%B4ne_de_blessure.svg.png",
        message = "Vous venez d'être soigné.",
      }
      TriggerClientEvent("Venato:notify", idToHeal, notif)
    end)

    RegisterServerEvent('ambulancier:Makepayement')
    AddEventHandler('ambulancier:Makepayement', function(target, price)
      local price = price
      local source = source
      local target = target
      local notif = {
        title= "LSMC",
        logo = "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Ic%C3%B4ne_de_blessure.svg/1024px-Ic%C3%B4ne_de_blessure.svg.png",
        message = "Vous venez d'être facturé du montant de "..price.." au profit du LSMC",
      }      
      local paymentCB = exports.venato:ExportPaymentCB(target, price)
      if paymentCB.status then
        TriggerEvent("Coffre:AddMoney", price, 1178)
        TriggerClientEvent("Venato:notify", target, notif)
        notif.message = "Le client a bien payé sa facture !"
        TriggerClientEvent("Venato:notify", source, notif)
      else
        notif.type = "danger"
        notif.message = "Le client n'est pas en mesure de payer sa facture : ".. paymentCB.message
        TriggerClientEvent("Venato:notify", source, notif)
        notif.message = paymentCB.message
        TriggerClientEvent("Venato:notify", target, notif)
      end
    end)
