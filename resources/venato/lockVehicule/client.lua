local VehicleList = { ["0"] =  {["plate"]  = "LAMA    ",  ["name"]  = "inconnu"} }  -- clef or not
local VehicleListadd = {}
local VehicleListLock = {} -- open or close
local plaque = {}
local id = 0
local defaultNotification = {
  type = "alert",
  title ="Véhicule",
  logo = "https://i.ibb.co/zhF8r06/icons8-key-2-96px.png"
}

RegisterNetEvent("lock:refresh")
AddEventHandler("lock:refresh", function(listrefresh)

  VehicleListLock = listrefresh

end)

RegisterNetEvent("vnt:unloclplate")
AddEventHandler("vnt:unloclplate", function(plaques)

  VehicleList = plaques

end)

RegisterNetEvent("getInv:clef")
AddEventHandler("getInv:clef", function()

TriggerEvent('getInv:back', VehicleListadd)

end)

RegisterNetEvent("lock:deleteVeh")
AddEventHandler("lock:deleteVeh", function(plate)

  for i = 1, id do
    if VehicleListadd[i] ~= nil and VehicleListadd[i].plate == plate  then
      VehicleListadd[i] = nil
    end
  end

end)

RegisterNetEvent("lock:addVeh")
AddEventHandler("lock:addVeh", function(plaques, names) -- pour donner les clef TriggerEvent('lock:addVeh', plaque)
  local plate = plaques
  local name = names
  local plateunlocka = {}
  local dontgo = true
  id = id + 1
  for i = 1, id do
		if VehicleListadd[i] ~= nil and VehicleListadd[i].plate == plate  then
			dontgo = false
		end
	end
  if dontgo then
    plateunlocka = { ["plate"] = plate, ["name"] = name }
    VehicleListadd[id] = plateunlocka
    plateunlocka = {}
  end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
    if IsControlJustReleased(0, 246) then
      lockVeh()
		end
	end
end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(2000)
      vnt()
			local player = Venato.GetPlayerPed()
			if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId(player))) then
				local veh = GetVehiclePedIsTryingToEnter(PlayerPedId(player))
				local lock = GetVehicleDoorLockStatus(veh)
				if lock == 7 then
					SetVehicleDoorsLocked(veh, 2)
				end
				local pedd = GetPedInVehicleSeat(veh, -1)
				if pedd then
					SetPedCanBeDraggedOut(pedd, false)
				end
			end
		end
	end)


function lockVeh()
  local isvehiclefoundlock = false
  local x,y,z = table.unpack(GetEntityCoords(Venato.GetPlayerPed(),true))
  local clostestvehicle = GetClosestVehicle(x, y, z, 7.000, 0, 127)
  local vehName = ''

  if clostestvehicle == 0 then
    local pos = GetEntityCoords(Venato.GetPlayerPed())
    local entityWorld = GetOffsetFromEntityInWorldCoords(Venato.GetPlayerPed(), 0.0, 3.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, Venato.GetPlayerPed(), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    clostestvehicle = result
  end
  if clostestvehicle ~= 0 then
    local plateVehic = GetVehicleNumberPlateText(clostestvehicle)
    if plateVehic ~= nil then
      for ind, value in pairs(VehicleList) do
        if (value.plate == plateVehic) then
          isvehiclefoundlock = true
          vehName = value.name
          break
        end
      end
      if isvehiclefoundlock == false then
        for ind, value in pairs(VehicleListadd) do
          if (value.plate == plateVehic) then
            isvehiclefoundlock = true
            vehName = value.name
            break
          end
        end
      end
    end
    if isvehiclefoundlock then
      local lock = GetVehicleDoorLockStatus(clostestvehicle)
      Venato.playAnim({
        useLib = true,
        flag = 48,
        lib = "anim@mp_player_intmenu@key_fob@",
        anim = "fob_click_fp",
        timeout = 500
      })
      if lock == 1 then
        SetVehicleDoorsLocked(clostestvehicle, 2)
        TriggerServerEvent("lock:lockveh", plateVehic)
        Notify("Le véhicule <span class='yellow--text'>" .. vehName .. "</span> est <span class='red--text'>verrouillé</span>.")
        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "lock", 1.0)
      else
        SetVehicleDoorsLocked(clostestvehicle, 1)
        TriggerServerEvent("lock:unlockveh", plateVehic)
        Notify("Le véhicule <span class='yellow--text'>" .. vehName .. "</span> est <span class='green--text'>déverrouillé</span>.")
        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "unlock", 1.0)
      end
    else
      Notify("Vous n'avez pas <span class='red--text'>la clé</span> pour ce véhicule.")
    end
  else
    Notify("<span class='red--text'>Pas de véhicule à vérouiller.</span>")
  end
end

function unlockveh()
  local x,y,z = table.unpack(GetEntityCoords(Venato.GetPlayerPed(),true))
  local clostestvehicle = GetClosestVehicle(x, y, z, 7.000, 0, 127)
  local plateVehic = GetVehicleNumberPlateText(clostestvehicle)
  SetVehicleDoorsLocked(clostestvehicle, 1)
  TriggerServerEvent("lock:unlockveh", plateVehic)
  Notify("Le véhicule <span class='yellow--text'>" .. plateVehic .. "</span> est <span class='green--text'>déverrouillé</span>.")
  TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "unlock", 1.0)
end


function vnt()
  local isvehiclefound = nil
  local x,y,z = table.unpack(GetEntityCoords(Venato.GetPlayerPed(),true))
	local clostestvehicle = GetClosestVehicle(x, y, z, 7.000, 0, 127)
  if clostestvehicle == 0 then
    local pos = GetEntityCoords(Venato.GetPlayerPed())
    local entityWorld = GetOffsetFromEntityInWorldCoords(Venato.GetPlayerPed(), 0.0, 3.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, Venato.GetPlayerPed(), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    clostestvehicle = result
  end
  if clostestvehicle ~= 0 then
    local plateid = nil
    local plateVehic = GetVehicleNumberPlateText(clostestvehicle)
    for ind, value in pairs(VehicleListLock) do
      if (value.plate == plateVehic) then
        isvehiclefound = value.locked
        break
      end
    end
    if isvehiclefound == 2 or isvehiclefound == nil then
      SetVehicleDoorsLocked(clostestvehicle, 2)
    elseif isvehiclefound == 1 then
      SetVehicleDoorsLocked(clostestvehicle, 1)
    end
  end
end


function Notify(text)
    defaultNotification.message = text;
    Venato.notify(defaultNotification)
end
