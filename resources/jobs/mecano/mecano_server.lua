    local listMissions = {}
    local listPersonnelActive = {}
    local acceptMulti = true
    local preFixEventName = 'mecano'

    local CALL_INFO_WAIT = 2
    local CALL_INFO_OK = 1
    local CALL_INFO_NONE = 0

    -- Notifyle changement de status des missions
    function notifyMissionChangeMECA(target)
        target = target or -1
        TriggerClientEvent('mecano:MissionChange', target, listMissions)
    end

    function notifyMissionCancel(source)
        TriggerClientEvent('mecano:MissionCancel', source)
    end

    -- Notify le changement de status des missions
    function notifyPersonnelChange(target)
        target = target or -1
        TriggerClientEvent('mecano:personnelChange', target,  getNbPerosnnelActive(), getNbPerosnnelDispo())
     end

    -- Notify un message a tout les personnels
    function notifyAllPersonnel(MESS)
        TriggerClientEvent('mecano:PersonnelMessage', -1, MESS)
    end

    -- Notify un message un personnel
    function notifyPersonnel(source, MESS)
        TriggerClientEvent('mecano:PersonnelMessage', source, MESS)
    end

    -- Notify un message un client
    function notifyClient(source, MESS)
        TriggerClientEvent('mecano:ClientMessage', source, MESS)
    end

    -- Not use || Notify a message a tout le monde
    function notifyAllClient(MESS)
        TriggerClientEvent('mecano:ClientMessage', -1 , MESS)
    end

    -- Notify call status change
    function notifyCallStatus(source, status)
        TriggerClientEvent('mecano:callStatus', source, status)
    end

	-- test tdlc garage
	function notifyGetPersonnelMeca(target)
        target = target or -1
        TriggerClientEvent('garages:GetPersonnelMeca', target,  getNbPerosnnelActive(), getNbPerosnnelDispo())
    end


    function addMissionmeca(source, position, type)
        local sMission = listMissions[source]
        if sMission == nil then
            listMissions[source] = {
                id = source,
                pos = position,
                acceptBy = {},
                type = type
            }

            notifyClient(source, 'CALL_RECU')
            notifyCallStatus(source, CALL_INFO_WAIT)
            notifyAllPersonnel('MISSION_NEW')
            notifyMissionChangeMECA()
        else -- Missions deja en cours
            notifyClient(source, 'CALL_EN_COURS')
        end
    end

    function closeMission(source, missionId)
        if listMissions[missionId] ~= nil then
            for _, v in pairs(listMissions[missionId].acceptBy) do
                if v ~= source then
                    notifyPersonnel(v, 'MISSION_ANNULE')
                    notifyMissionCancel(v)
                end
                setInactivePersonnel(v)
            end
            listMissions[missionId] = nil
            notifyClient(missionId, 'CALL_FINI')
            notifyCallStatus(missionId, CALL_INFO_NONE)
            notifyMissionChangeMECA()
            notifyPersonnelChange()
			notifyGetPersonnelMeca()
        end
    end

    function personelAcceptMission(source, missionId)
        local sMission = listMissions[missionId]
        if sMission == nil then
            notifyPersonnel(source,'MISSION_INCONNU')
        elseif #sMission.acceptBy ~= 0  and not acceptMulti then
            notifyPersonnel(source, 'MISSION_EN_COURS')
        else
            removeMeccano(source)
            if #sMission.acceptBy >= 1 then
                if sMission.acceptBy[1] ~= source then
                    for _, m in pairs(sMission.acceptBy) do
                        notifyPersonnel(m, 'MISSION_CONCURENCE')
                    end
                    table.insert(sMission.acceptBy, source)
                end
            else
                table.insert(sMission.acceptBy, source)
                notifyClient(sMission.id, 'CALL_ACCEPT')
                notifyPersonnel(source, 'MISSION_ACCEPT')
            end
            TriggerClientEvent('mecano:MissionAccept', source, sMission)
            notifyCallStatus(missionId, CALL_INFO_OK)
            setActivePersonnel(source)
            notifyMissionChangeMECA()
            notifyPersonnelChange()
			notifyGetPersonnelMeca()
        end
    end

    function removeMeccano(personnelId)
        for _, mission in pairs(listMissions) do
            for k, v in pairs(mission.acceptBy) do
                if v == personnelId then
                    table.remove(mission.acceptBy, k)
                    if #mission.acceptBy == 0 then
                        notifyClient(mission.id, 'CALL_CANCEL')
                        TriggerClientEvent('mecano:callStatus', mission.id, 2)
                        notifyCallStatus(mission.id, CALL_INFO_WAIT)
                        notifyAllPersonnel('MISSION_NEW')
                    end
                    break
                end
            end
        end
        removePersonelService(personnelId)
        notifyPersonnelChange()
		notifyGetPersonnelMeca()
    end

    function removeClient(clientId)
        if listMissions[clientId] ~= nil then
            for _, v in pairs(listMissions[clientId].acceptBy) do
                notifyPersonnel(v, 'MISSION_ANNULE')
                notifyMissionCancel(v)
                setInactivePersonnel(v)
            end
            listMissions[clientId] = nil
            notifyCallStatus(clientId, CALL_INFO_NONE)
            notifyMissionChangeMECA()
            notifyPersonnelChange()
			notifyGetPersonnelMeca()
        end
    end


    --=========================================================================
    --  Gestion des personnels en service & activité
    --=========================================================================

    function addPersonelService(source)
        listPersonnelActive[source] = false
    end

    function removePersonelService(source)
        listPersonnelActive[source] = nil
    end

    function setActivePersonnel(source)
        listPersonnelActive[source] = true

    end

    function setInactivePersonnel(source)
        listPersonnelActive[source] = false
    end

    function getNbPerosnnelActive()
        local dispo = 0
        for _, v in pairs(listPersonnelActive) do
            if v ~= nil then
                dispo = dispo + 1
            end
        end
        return dispo
    end

    function getNbPerosnnelDispo()
        local dispo = 0
        for _, v in pairs(listPersonnelActive) do
            if v == false then
                dispo = dispo + 1
            end
        end
        return dispo
    end

    function getNbPerosnnelBusy()
        local dispo = 0
        for _, v in pairs(listPersonnelActive) do
            if v == true then
                dispo = dispo + 1
            end
        end
        return dispo
    end

    RegisterServerEvent('mecano:takeService')
    AddEventHandler('mecano:takeService', function ()
        addPersonelService(source)
        notifyPersonnelChange()
    end)

    
    RegisterServerEvent('mecano:Makepayement')
    AddEventHandler('mecano:Makepayement', function(target, price)
      local price = price
      local source = source
      local target = target
      local notif = {
        title= "Mecano",
        logo = "https://i.ibb.co/dmfGBDv/icons8-car-service-96px.png",
        message = "Vous venez d'être facturé du montant de "..price.." au profit des mécano",
      }      
      local paymentCB = exports.venato:ExportPaymentCB(target, price)
      if paymentCB.status then
        TriggerEvent("Coffre:AddMoney", price, 1209)
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

    RegisterServerEvent('mecano:endService')
    AddEventHandler('mecano:endService', function ()
        removeMeccano(source)
        removePersonelService(source)
    end)

    RegisterServerEvent('mecano:requestMission')
    AddEventHandler('mecano:requestMission', function ()
        notifyMissionChangeMECA(source)
    end)

    RegisterServerEvent('mecano:requestPersonnel')
    AddEventHandler('mecano:requestPersonnel', function ()
        notifyPersonnelChange(source)
    end)

    RegisterServerEvent('mecano:Call')
    AddEventHandler('mecano:Call', function (posX,posY,posZ,type)
        addMissionmeca(source, {posX, posY, posZ}, type)
    end)

    RegisterServerEvent('mecano:CallCancel')
    AddEventHandler('mecano:CallCancel', function ()
        removeClient(source)
    end)

    RegisterServerEvent('mecano:AcceptMission')
    AddEventHandler('mecano:AcceptMission', function (id)
        personelAcceptMission(source, id)
    end)

    RegisterServerEvent('mecano:FinishMission')
    AddEventHandler('mecano:FinishMission', function (id)
        closeMission(source, id)
    end)

    RegisterServerEvent('mecano:cancelCall')
    AddEventHandler('mecano:cancelCall', function ()
        removeClient(source)
    end)

	RegisterServerEvent('mecano:GetPersonnelactive')
    AddEventHandler('mecano:GetPersonnelactive', function ()
		notifyGetPersonnelMeca(source)
    end)

    AddEventHandler('playerDropped', function()
        removeMeccano(source)
        removeClient(source)
    end)
