-- Add police

SET @SteamId = 'steam:11000013bd00007';

-- INSERT INTO police(`identifier`, `rank`) VALUES (@SteamId, 'Cadet');
INSERT INTO coffres_whitelist(`CoffreId`, `UserId`) VALUES (20, @SteamId);
INSERT INTO coffres_whitelist(`CoffreId`, `UserId`) VALUES (21, @SteamId);