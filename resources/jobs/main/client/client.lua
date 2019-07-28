--[[
  Client entry point for all jobs

  @author Astymeus
  @date 2019-07-28
  @version 1.0
--]]

CreateThread(function()
  -- Step 1
  --  Check the job of the player
  TriggerServerEvent("Jobs:checkPlayerJob")
end)

-- Step 4
--  Appeler La boucle principale du métier

-- Step 5
--  Appeler la boucle des salaires
