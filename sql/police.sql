-- Add police

SET @SteamId = 'steam:110000136b376ec';

INSERT INTO police(`identifier`, `rank`) VALUES (@SteamId, 'Cadet');
INSERT INTO coffres_whitelist(`CoffreId`, `UserId`) VALUES (20, @SteamId);
INSERT INTO coffres_whitelist(`CoffreId`, `UserId`) VALUES (21, @SteamId);
UPDATE users SET job = 2 WHERE identifier = @SteamId