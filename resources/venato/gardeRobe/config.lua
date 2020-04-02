local clothesGirlNude = {--girl
  ComponentVariation = {
    Mask = {id = 0, color = 0},
    torso = {id = 15, color = 0},
    leg = {id = 56, color = 5},
    parachute = {id = 0, color = 0},
    shoes = {id = 35, color = 0},
    accessory = {id = 0, color = 0},
    undershirt = {id = 34, color = 0},
    kevlar = {id = 0, color = 0},
    badge = {id = 0, color = 0},
    torso2 = {id = 260, color = 1},
  },
  prop = {
    hat = {id = -1, color = 0},
    glass = {id = -1, color = 0},
    ear = {id = -1, color = 0},
    watch = {id = -1, color = 0},
    bracelet = {id = -1, color = 0},
  }
}
local clothesBoyNude = {--male
  ComponentVariation = {
    Mask = {id = 0, color = 0},
    torso = {id = 15, color = 0},
    leg = {id = 61, color = 5},
    parachute = {id = 0, color = 0},
    shoes = {id = 34, color = 0},
    accessory = {id = 0, color = 0},
    undershirt = {id = 15, color = 0},
    kevlar = {id = 0, color = 0},
    badge = {id = 0, color = 0},
    torso2 = {id = 91, color = 0},
  },
  prop = {
    hat = {id = -1, color = 0},
    glass = {id = -1, color = 0},
    ear = {id = -1, color = 0},
    watch = {id = -1, color = 0},
    bracelet = {id = -1, color = 0},
  }
}

function configGardeRobe()
  if(GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01")) then
    return clothesBoyNude
  else
    return clothesGirlNude
  end
end
