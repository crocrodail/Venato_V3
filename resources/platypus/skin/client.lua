local BlackListHair = {23,24,61}
local PersonnalisationMenu = false
local Coords = nil
local Prop = nil
local loaded = false
local inEdit = false



if (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01")) then
  loaded = true
end
function firstcamspawn(Prop)
Citizen.CreateThread(function()
  local currentItem = 0
  local distanceCam = 2.0
  local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
  local boneIndex = 65068
  SetCamActive(cam, true)
  RenderScriptCams(true, false, 0, 1, 0)
  index = 0
  value = 0.0
  local h = GetEntityHeading(GetPlayerPed(-1))
  inEdit = true
    while inEdit == true do
      Citizen.Wait(0)
      local YawCam = Citizen.InvokeNative(0x837765A25378F0BB, 0, Citizen.ResultAsVector()).z + 75
      AttachCamToPedBone(cam, GetPlayerPed(-1), boneIndex, math.cos(YawCam * 0.01745329251) * distanceCam, math.sin(YawCam * 0.01745329251) * distanceCam , 0.05 , true)
      SetCamRot(cam, 0.0, 0.0, YawCam + h + 90, true)
    end
  end)
end

function camspawn()
Citizen.CreateThread(function()
  local currentItem = 0
  local distanceCam = 0.35
  local me = GetPlayerPed(-1)
  local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
  local boneIndex = 65068
  SetCamActive(cam, true)
  RenderScriptCams(true, false, 0, 1, 0)
  index = 0
  value = 0.0
  local h = GetEntityHeading(GetPlayerPed(-1))
  inEdit = true
    while inEdit == true do
      Citizen.Wait(0)
      local alt = 0.05
      if GetEntityModel(platypus.GetPlayerPed()) == GetHashKey('mp_f_freemode_01') then
        alt = 0.15
      end
      local YawCam = Citizen.InvokeNative(0x837765A25378F0BB, 0, Citizen.ResultAsVector()).z + 75
      AttachCamToPedBone(cam, GetPlayerPed(-1), boneIndex, math.cos(YawCam * 0.01745329251) * distanceCam, math.sin(YawCam * 0.01745329251) * distanceCam , alt , true)
      SetCamRot(cam, 0.0, 0.0, YawCam + h + 90, true)
    end
  end)
end

SkinChooser =  {}
SkinChooser.__index = SkinChooser
function SkinChooser:create()
    local self = {}
    setmetatable(self,SkinChooser)
    self.name           = nil
    self.model          = "mp_m_freemode_01"
    self.age            = nil
    self.head           = nil
    self.body_color     = nil
    self.hair           = nil
    self.hair_color     = nil
    self.beard          = nil
    self.beard_color    = nil
    self.eyebrows       = nil
    self.eyebrows_color = nil
    return self
end

local current_skin = SkinChooser:create()


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if PersonnalisationMenu then
      DisableControlAction(1, Keys["RIGHTMOUSE"], true)
      DisableControlAction(1, Keys["BACKSPACE"], true)
      DisableControlAction(1, Keys["K"], true)
      DisableControlAction(1, Keys["F2"], true)
      DisableControlAction(1, Keys["F1"], true)
      DisableControlAction(1, Keys["F3"], true)
      DisableControlAction(1, Keys["F4"], true)
      DisableControlAction(1, Keys["F5"], true)
      DisableControlAction(1, Keys["F6"], true)
      DisableControlAction(1, Keys["F7"], true)
      DisableControlAction(1, Keys["F8"], true)
      DisableControlAction(1, Keys["F9"], true)
      DisableControlAction(1, Keys["F10"], true)
      DisableControlAction(1, Keys["F11"], true)
      DisableControlAction(1, Keys["F12"], true)
      DisableControlAction(1, Keys["LEFTCTRL"], true)
      DisableControlAction(1, Keys["C"], true)
      DisableControlAction(1, Keys["H"], true)
      DisableControlAction(1, Keys["J"], true)
      DisableControlAction(1, Keys["G"], true)
      DisableControlAction(1, Keys["5"], true)
      DisableControlAction(inputGroup, control, disable)
    end
  end
end)

function OpenCreatMainMenu()
  ShutdownLoadingScreen()
  fCanCancelOrStartAnim(false)
  PersonnalisationMenu = true
  local ped = platypus.GetPlayerPed()
  SetEntityCoords(ped, -755.0, 768.0, 212.2, 0.0, 0.0, 0.0, true)
  Coords = GetEntityCoords(ped, true)
  Prop = platypus.CreateObject("prop_apple_box_01", Coords["x"], Coords["y"], Coords["z"]-0.1)
  firstcamspawn()
  SetEntityHeading(Prop, 27.0)
  SetEntityCollision(Prop, false, true)
  FreezeEntityPosition(Prop, true)
  AttachEntityToEntity(ped, Prop, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, false)
  SetEntityVisible(Prop, false, 0)
  SetEntityVisible(ped, true, 0)
  Menu.toggle()
  Menu.clearMenu()
  Menu.setTitle("Personnalisation")
  Menu.setSubtitle("Bienvenue")
  Menu.addButton2("Creez votre perso", "modelMenu", nil, nil)
  Menu.CreateMenu()
end

function modelMenu()
    Menu.setSubtitle("Choix du sexe")
    skinMenu("mp_m_freemode_01")
    Menu.clearMenu()
    Menu.addButton2("Homme", "shapeMenu", 'mp_m_freemode_01', 'skinMenu')
    Menu.addButton2("Femme", "shapeMenu", 'mp_f_freemode_01', 'skinMenu')
    Menu.CreateMenu()
end

function skinMenu(skin)
    RequestModel(skin)
    while not HasModelLoaded(skin) do
        RequestModel(skin)
        Wait(0)
    end
    SetPlayerModel(PlayerId(), skin)
    SetModelAsNoLongerNeeded(skin)
    -- SetPedHeadBlendData(playerPed, 0, 0, skin, 0, 0, skin, 1.0, 1.0, 1.0, true)
    SetPedDefaultComponentVariation(platypus.GetPlayerPed())
    SetPedComponentVariation(platypus.GetPlayerPed(), 2, 0, 0, 0)
    AttachEntityToEntity(platypus.GetPlayerPed(), Prop, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, false)
end

function shapeMenu(skin)
    current_skin.model = skin
    camspawn()

    Menu.setSubtitle("Forme du visage")
    Menu.clearMenu()
    Menu.addButton2("Retour", "modelMenu", nil, nil)
    if GetEntityModel(platypus.GetPlayerPed()) == GetHashKey('mp_f_freemode_01') then
        Menu.addButton2("Visage n°1", "setShapeEnter", 21, "setShape")
        Menu.addButton2("Visage n°2", "setShapeEnter", 22, "setShape")
        Menu.addButton2("Visage n°3", "setShapeEnter", 23, "setShape")
        Menu.addButton2("Visage n°4", "setShapeEnter", 24, "setShape")
        Menu.addButton2("Visage n°5", "setShapeEnter", 25, "setShape")
        Menu.addButton2("Visage n°6", "setShapeEnter", 26, "setShape")
        Menu.addButton2("Visage n°7", "setShapeEnter", 27, "setShape")
        Menu.addButton2("Visage n°8", "setShapeEnter", 28, "setShape")
        Menu.addButton2("Visage n°9", "setShapeEnter", 29, "setShape")
        Menu.addButton2("Visage n°11", "setShapeEnter", 31, "setShape")
        Menu.addButton2("Visage n°12", "setShapeEnter", 32, "setShape")
        Menu.addButton2("Visage n°13", "setShapeEnter", 33, "setShape")
        Menu.addButton2("Visage n°14", "setShapeEnter", 34, "setShape")
        Menu.addButton2("Visage n°15", "setShapeEnter", 35, "setShape")
        Menu.addButton2("Visage n°16", "setShapeEnter", 36, "setShape")
        Menu.addButton2("Visage n°17", "setShapeEnter", 37, "setShape")
        Menu.addButton2("Visage n°18", "setShapeEnter", 38, "setShape")
        Menu.addButton2("Visage n°19", "setShapeEnter", 39, "setShape")
        Menu.addButton2("Visage n°20", "setShapeEnter", 40, "setShape")
        Menu.addButton2("Visage n°21", "setShapeEnter", 41, "setShape")
        Menu.addButton2("Visage n°22", "setShapeEnter", 45, "setShape")
    else
        Menu.addButton2("Visage n°1", "setShapeEnter", 0, "setShape")
        Menu.addButton2("Visage n°2", "setShapeEnter", 1, "setShape")
        Menu.addButton2("Visage n°3", "setShapeEnter", 2, "setShape")
        Menu.addButton2("Visage n°4", "setShapeEnter", 3, "setShape")
        Menu.addButton2("Visage n°5", "setShapeEnter", 4, "setShape")
        Menu.addButton2("Visage n°6", "setShapeEnter", 5, "setShape")
        Menu.addButton2("Visage n°7", "setShapeEnter", 6, "setShape")
        Menu.addButton2("Visage n°8", "setShapeEnter", 7, "setShape")
        Menu.addButton2("Visage n°9", "setShapeEnter", 8, "setShape")
        Menu.addButton2("Visage n°10", "setShapeEnter", 9, "setShape")
        Menu.addButton2("Visage n°11", "setShapeEnter", 10, "setShape")
        Menu.addButton2("Visage n°12", "setShapeEnter", 11, "setShape")
        Menu.addButton2("Visage n°13", "setShapeEnter", 12, "setShape")
        Menu.addButton2("Visage n°14", "setShapeEnter", 13, "setShape")
        Menu.addButton2("Visage n°15", "setShapeEnter", 14, "setShape")
        Menu.addButton2("Visage n°16", "setShapeEnter", 15, "setShape")
        Menu.addButton2("Visage n°17", "setShapeEnter", 16, "setShape")
        Menu.addButton2("Visage n°18", "setShapeEnter", 17, "setShape")
        Menu.addButton2("Visage n°19", "setShapeEnter", 18, "setShape")
        Menu.addButton2("Visage n°20", "setShapeEnter", 19, "setShape")
        Menu.addButton2("Visage n°21", "setShapeEnter", 20, "setShape")
        Menu.addButton2("Visage n°22", "setShapeEnter", 42, "setShape")
        Menu.addButton2("Visage n°23", "setShapeEnter", 43, "setShape")
        Menu.addButton2("Visage n°24", "setShapeEnter", 44, "setShape")
    end
    Menu.addButton2("Retour", "modelMenu", nil, nil)
    Menu.CreateMenu()
end

function setShape(skin)
    SetPedHeadBlendData(platypus.GetPlayerPed(), skin, skin, skin, 0, 0, 0, 1.0, 1.0, 1.0, true)
    SetPedComponentVariation(platypus.GetPlayerPed(), 0, skin, 0, 0)

end

function setShapeEnter(skin)
    current_skin.head = skin
    current_step = 2
    bodyColor()
end

function bodyColor()
    Menu.setSubtitle("Couleur de la peau")
    Menu.clearMenu()
    Menu.addButton2("Retour", "shapeMenu", nil, nil)
    Menu.addButton2("Couleur n°1", "setBodyColorEnter", 21, "setBodyColor")
    Menu.addButton2("Couleur n°2", "setBodyColorEnter", 22, "setBodyColor")
    Menu.addButton2("Couleur n°3", "setBodyColorEnter", 23, "setBodyColor")
    Menu.addButton2("Couleur n°4", "setBodyColorEnter", 24, "setBodyColor")
    Menu.addButton2("Couleur n°5", "setBodyColorEnter", 25, "setBodyColor")
    Menu.addButton2("Couleur n°6", "setBodyColorEnter", 26, "setBodyColor")
    Menu.addButton2("Couleur n°7", "setBodyColorEnter", 27, "setBodyColor")
    Menu.addButton2("Couleur n°8", "setBodyColorEnter", 28, "setBodyColor")
    Menu.addButton2("Couleur n°9", "setBodyColorEnter", 29, "setBodyColor")
    Menu.addButton2("Couleur n°11", "setBodyColorEnter", 31, "setBodyColor")
    Menu.addButton2("Couleur n°12", "setBodyColorEnter", 32, "setBodyColor")
    Menu.addButton2("Couleur n°13", "setBodyColorEnter", 33, "setBodyColor")
    Menu.addButton2("Couleur n°14", "setBodyColorEnter", 34, "setBodyColor")
    Menu.addButton2("Couleur n°15", "setBodyColorEnter", 35, "setBodyColor")
    Menu.addButton2("Couleur n°16", "setBodyColorEnter", 36, "setBodyColor")
    Menu.addButton2("Couleur n°17", "setBodyColorEnter", 37, "setBodyColor")
    Menu.addButton2("Couleur n°18", "setBodyColorEnter", 38, "setBodyColor")
    Menu.addButton2("Couleur n°19", "setBodyColorEnter", 39, "setBodyColor")
    Menu.addButton2("Couleur n°20", "setBodyColorEnter", 40, "setBodyColor")
    Menu.addButton2("Couleur n°21", "setBodyColorEnter", 41, "setBodyColor")
    Menu.addButton2("Couleur n°22", "setBodyColorEnter", 45, "setBodyColor")
    Menu.addButton2("Retour", "shapeMenu", nil, nil)
    Menu.CreateMenu()
end
function setBodyColor(skin)
    SetPedHeadBlendData(platypus.GetPlayerPed(), current_skin.head, current_skin.head, current_skin.head, skin, skin, skin, 1.0, 1.0, 1.0, true)
    SetPedComponentVariation(platypus.GetPlayerPed(), 0, skin, 0, 0)
end
function setBodyColorEnter(skin)
    current_skin.body_color = skin
    current_step = 3
    eyebrowsMenu()
end

function eyebrowsMenu()
    Menu.setSubtitle("Formes des sourcils")
    Menu.clearMenu()
    Menu.addButton2("Retour", "bodyColor", nil, nil)
    for i = 0, GetNumHeadOverlayValues(1) do
        Menu.addButton2("Forme n°"..i, "eyebrowsSelectorMenuEnter", i, "eyebrowsSelectorMenu")
    end
    Menu.addButton2("Retour", "bodyColor", nil, nil)
    Menu.CreateMenu()
end

function eyebrowsSelectorMenu(id)
    SetPedHeadOverlay(platypus.GetPlayerPed(),  2,  id,  0.9)
    SetPedHeadOverlayColor(platypus.GetPlayerPed(),  2, 1, 1, 0)
end

function eyebrowsSelectorMenuEnter(id)
    current_skin.eyebrows = id
    current_step = 4
    eyebrowsColorMenu()
end

function eyebrowsColorMenu()
    Menu.setSubtitle("Couleur des sourcils")
    Menu.clearMenu()
    Menu.addButton2("Retour", "eyebrowsMenu", nil)
    for i = 0, GetNumHairColors() do
        Menu.addButton2("Couleur n°"..i, "eyebrowsColorSelectorMenuEnter", i, "eyebrowsColorSelectorMenu")
    end
    Menu.addButton2("Retour", "eyebrowsMenu", nil, nil)
    Menu.CreateMenu()
end

function eyebrowsColorSelectorMenu(id)
    SetPedHeadOverlay(platypus.GetPlayerPed(),  2,  current_skin.eyebrows,  0.9)        -- Beard Color
    SetPedHeadOverlayColor(platypus.GetPlayerPed(),  2, 1, id, 0)  -- Beard
end

function eyebrowsColorSelectorMenuEnter(id)
    current_skin.eyebrows_color = id
    hairSelectorMenu()
end

function hairSelectorMenu()
    Menu.setSubtitle("Coupe de cheveux")
    Menu.clearMenu()
    Menu.addButton2("Retour", "eyebrowsColorMenu", nil)
    local id = 0
    for i = 0, GetNumberOfPedDrawableVariations(platypus.GetPlayerPed(), 2) -1 do
      if i ~= 23 and i ~= 24 and i ~= 61 then
        id = id + 1
        Menu.addButton2("Coupe n°"..id, "hairSelectorSwitcherEnter", i, "hairSelectorSwitcher")
      end
    end
    Menu.addButton2("Retour", "eyebrowsColorMenu", nil)
    Menu.CreateMenu()
end

function hairSelectorSwitcher(id)
    SetPedComponentVariation(platypus.GetPlayerPed(), 2, id, 0, 0)
end

function hairSelectorSwitcherEnter(id)
    current_skin.hair = id
    current_step = 6
    hairColorVariationSelectorMenu()
end

function hairColorVariationSelectorMenu()
    Menu.setSubtitle("Couleur des cheveux")
    Menu.clearMenu()
    Menu.addButton2("Retour", "hairSelectorMenu", nil)
    for i = 0,  GetNumHairColors() do
        Menu.addButton2("Couleur n°"..i, "hairColorVariationSelectorSwitcherEnter", i, "hairColorVariationSelectorSwitcher")
    end
    Menu.addButton2("Retour", "hairSelectorMenu", nil)
    Menu.CreateMenu()
end

function hairColorVariationSelectorSwitcher(id)
    SetPedHairColor(platypus.GetPlayerPed(), id,4)
end

function hairColorVariationSelectorSwitcherEnter(id)
    current_skin.hair_color = id
    current_step = 7
    if GetEntityModel(platypus.GetPlayerPed()) == GetHashKey('mp_m_freemode_01') then
        beardCutMenu()
    else
        endGenSkin()
    end
end


function beardCutMenu()
    Menu.setSubtitle("Barbe")
    Menu.clearMenu()
    Menu.addButton2("Retour", "hairColorVariationSelectorMenu", nil)
    for i = 0, GetNumHeadOverlayValues(1) do
        Menu.addButton2("barbe n°"..i, "beardSelectorCutMenuEnter", i, "beardSelectorCutMenu")
    end
    Menu.addButton2("Retour", "hairColorVariationSelectorMenu", nil)
    Menu.CreateMenu()
end
function beardColorMenu()
    Menu.setSubtitle("Couleur de la barbe")
    Menu.clearMenu()
    Menu.addButton2("Retour", "beardCutMenu", nil)
    for i = 0, GetNumHairColors() do
        Menu.addButton2("Couleur n°"..i, "beardSelectorColorMenuEnter", i, "beardSelectorColorMenu")
    end
    Menu.addButton2("Retour", "beardCutMenu", nil)
    Menu.CreateMenu()
end

function beardSelectorCutMenu(id)
    SetPedHeadOverlay(platypus.GetPlayerPed(),  1,  id,  0.9)
    SetPedHeadOverlayColor(platypus.GetPlayerPed(),  1,  1,  1, 1)
end

function beardSelectorCutMenuEnter(id)
    current_skin.beard = id
    current_step = 8
    beardColorMenu()
end

function beardSelectorColorMenu(id)
    SetPedHeadOverlay(platypus.GetPlayerPed(),  1,  current_skin.beard ,  (current_skin.beard  / 10) + 0.0)  -- Beard
    SetPedHeadOverlayColor(platypus.GetPlayerPed(),  1,  1,  id, id)
end

function beardSelectorColorMenuEnter(id)
    current_skin.beard_color = id
    current_step = 9
    endGenSkin()
end

function endGenSkin()
  TriggerServerEvent("ClothingShop:CallData")
  DetachEntity(platypus.GetPlayerPed(), true, true)
  DeleteEntity(Prop)
  SetCamActive(cam,  false)
  RenderScriptCams(false,  false,  0,  true,  true)
  Prop = nil
  PersonnalisationMenu = false
  TriggerServerEvent('skin:saveOutfitForNewPlayer', current_skin)
  Menu.close()
  inEdit = false
  startEditFace()
end

RegisterNetEvent('Skin:Create')
AddEventHandler("Skin:Create", function()
  OpenCreatMainMenu()
end)


function platypus.LoadSkin(DataUser)
    local skin = DataUser.Skin
    if not loaded then
      loadPlayer(DataUser)
    end
    local model = skin.model
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
    if GetEntityModel(platypus.GetPlayerPed()) == GetHashKey('mp_f_freemode_01') or GetEntityModel(platypus.GetPlayerPed()) == GetHashKey('mp_m_freemode_01') then
      none()
    else
      SetPlayerModel(PlayerId(), model)
      SetModelAsNoLongerNeeded(model)
      SetPedDefaultComponentVariation(platypus.GetPlayerPed())
      SetPedComponentVariation(platypus.GetPlayerPed(), 2, 0, 0, 0)
    end
    if skin then
      local playerPed = platypus.GetPlayerPed()
        local Sexemodel = GetHashKey("mp_m_freemode_01")
        if(GetEntityModel(platypus.GetPlayerPed()) == Sexemodel) then
            SetPedHeadBlendData(playerPed, skin.head, skin.head, skin.head, skin.body_color, skin.body_color, skin.body_color, 1.0, 1.0, 1.0, true)
            SetPedComponentVariation(playerPed, 0, skin.head, 0, 0)
            SetPedComponentVariation(playerPed, 2, skin.hair, 0, 0)
            SetPedHairColor(playerPed, skin.hair_color,4)
            SetPedHeadOverlay(playerPed,  1,  skin.beard ,  1.0)
            SetPedHeadOverlayColor(playerPed,  1,  1,  skin.beard_color, 1.0)
            if skin.eyebrows ~= 0 then
                SetPedHeadOverlay(playerPed,  2,  skin.eyebrows, 1.0)
                SetPedHeadOverlayColor(playerPed,  2, 1, skin.eyebrows_color, 1.0)
            else
                SetPedHeadOverlay(playerPed,  2,  -1, 0)
            end
            if skin.makeup ~= 0 then
                SetPedHeadOverlay(playerPed,  4, skin.makeup , (skin.makeup_opacity / 10 +0.0))
            else
                SetPedHeadOverlay(playerPed,  4, -1 , 0)
            end
            if skin.lipstick ~= 0 then
                SetPedHeadOverlay(playerPed,  8,  skin.lipstick, 1.0)
                SetPedHeadOverlayColor(playerPed,  8,  1,  skin.lipstick_color, 1.0)
            else
                SetPedHeadOverlay(playerPed,  8,  -1, 0)
            end
            if skin.percing == 0 then
                ClearPedProp(platypus.GetPlayerPed(),2)
            else
                SetPedPropIndex(playerPed, 2, skin.percing,skin.percing_txt, 0)
            end
        else
            SetPedHeadBlendData(playerPed, skin.head, skin.head, skin.head, skin.body_color, skin.body_color, skin.body_color, 1.0, 1.0, 1.0, true)
            SetPedComponentVariation(playerPed, 0, skin.head, 0, 0)
            SetPedComponentVariation(playerPed, 2, skin.hair, 0, 0)
            SetPedHairColor(playerPed, skin.hair_color,4)
            if skin.eyebrows ~= 0 then
                SetPedHeadOverlay(playerPed,  2,  skin.eyebrows, 1.0)
                SetPedHeadOverlayColor(playerPed,  2, 1, skin.eyebrows_color, 1.0)
            else
                SetPedHeadOverlay(playerPed,  2,  -1, 0)
            end
            if skin.makeup ~= 0 then
                SetPedHeadOverlay(playerPed,  4, skin.makeup , (skin.makeup_opacity / 10 +0.0))
            else
                SetPedHeadOverlay(playerPed,  4, -1 , 0)
            end
            if skin.lipstick ~= 0 then
                SetPedHeadOverlay(playerPed,  8,  skin.lipstick, 1.0)
                SetPedHeadOverlayColor(playerPed,  8,  1,  skin.lipstick_color, 1.0)
            else
                SetPedHeadOverlay(playerPed,  8,  -1, 0)
            end
            if skin.percing == 0 then
                ClearPedProp(platypus.GetPlayerPed(),2)
            else
                SetPedPropIndex(playerPed, 2, skin.percing,skin.percing_txt, 0)
            end
        end

        local me = platypus.GetPlayerPed()
        for k, v in ipairs(skin.face) do
            local value = 1.0 * v
            SetPedFaceFeature(me, k - 1, value)
        end

    end
end


function loadPlayer(data)
  DoScreenFadeOut(500)
  while IsScreenFadingOut() do
      Citizen.Wait(0)
  end
  local PosX = data.Position[1]
	local PosY = data.Position[2]
	local PosZ = data.Position[3]
  local PosH = data.Position[4]
  freezePlayer(PlayerId(), true)
  if data.Skin.model then
    RequestModel(data.Skin.model)
    while not HasModelLoaded(data.Skin.model) do
      RequestModel(data.Skin.model)
      Wait(0)
    end
    SetPlayerModel(PlayerId(), data.Skin.model)
    SetModelAsNoLongerNeeded(data.Skin.model)
    SetPedDefaultComponentVariation(GetPlayerPed(-1))
    SetPedComponentVariation(GetPlayerPed(-1), 2, 0, 0, 0)
    platypus.LoadClothes()
  end
  RequestCollisionAtCoord(PosX, PosY, PosZ)
  local ped = GetPlayerPed(-1)
  SetEntityCoordsNoOffset(ped, PosX, PosY, PosZ, false, false, false, true)
  NetworkResurrectLocalPlayer(PosX, PosY, PosZ, PosH, true, true, false)
  ClearPedTasksImmediately(ped)
  ClearPlayerWantedLevel(PlayerId())
  while not HasCollisionLoadedAroundEntity(ped) do
      Citizen.Wait(0)
  end
  ShutdownLoadingScreen()
  DoScreenFadeIn(500)
  while IsScreenFadingIn() do
      Citizen.Wait(0)
  end
  freezePlayer(PlayerId(), false)
end

function freezePlayer(id, freeze)
  local player = id
  SetPlayerControl(player, not freeze, false)
  local ped = GetPlayerPed(player)
  if not freeze then
    if not IsEntityVisible(ped) then
      SetEntityVisible(ped, true)
    end
    if not IsPedInAnyVehicle(ped) then
      SetEntityCollision(ped, true)
    end
    FreezeEntityPosition(ped, false)
    SetPlayerInvincible(player, false)
  else
    if IsEntityVisible(ped) then
      SetEntityVisible(ped, false)
    end
    SetEntityCollision(ped, false)
    FreezeEntityPosition(ped, true)
    SetPlayerInvincible(player, true)
    if not IsPedFatallyInjured(ped) then
      ClearPedTasksImmediately(ped)
    end
  end
end
