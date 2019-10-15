local blips = {
   -- -- Airport and Airfield
   -- {name="Airport", id=90, x=-1032.690, y=-2728.141, z=13.757},
   -- {name="Airport", id=90, x=1743.6820, y=3286.2510, z=40.087},
   -- -- barbers
   -- {name="Barber", id=71, x=-827.333, y=-190.916, z=37.599},
   -- {name="Barber", id=71, x=130.512, y=-1715.535, z=29.226},
   -- {name="Barber", id=71, x=-1291.472, y=-1117.230, z=6.641},
   -- {name="Barber", id=71, x=1936.451, y=3720.533, z=32.638},
   -- {name="Barber", id=71, x=1200.214, y=-468.822, z=66.268},
   -- {name="Barber", id=71, x=-30.109, y=-141.693, z=57.041},
   -- {name="Barber", id=71, x=-285.238, y=6236.365, z=31.455},
   -- -- Stores
    -- {name="Store", id=52, x=28.463, y=-1353.033, z=29.340},
    -- {name="Store", id=52, x=-54.937, y=-1759.108, z=29.005},
    -- {name="Store", id=52, x=375.858, y=320.097, z=103.433},
    -- {name="Store", id=52, x=1143.813, y=-980.601, z=46.205},
    -- {name="Store", id=52, x=1695.284, y=4932.052, z=42.078},
    -- {name="Store", id=52, x=2686.051, y=3281.089, z=55.241},
    -- {name="Store", id=52, x=1967.648, y=3735.871, z=32.221},
    -- {name="Store", id=52, x=-2977.137, y=390.652, z=15.024},
    -- {name="Store", id=52, x=1160.269, y=-333.137, z=68.783},
    -- {name="Store", id=52, x=-1492.784, y=-386.306, z=39.798},
    -- {name="Store", id=52, x=-1229.355, y=-899.230, z=12.263},
    -- {name="Store", id=52, x=-712.091, y=-923.820, z=19.014},
    -- {name="Store", id=52, x=-1816.544, y=782.072, z=137.600},
    -- {name="Store", id=52, x=1729.689, y=6405.970, z=34.453},
    -- {name="Store", id=52, x=2565.705, y=385.228, z=108.463},
    -- -- Clothing
    -- {name="Clothing", id=73, x=88.291, y=-1391.929, z=29.200},
    -- {name="Clothing", id=73, x=-718.985, y=-158.059, z=36.996},
    -- {name="Clothing", id=73, x=-151.204, y=-306.837, z=38.724},
    -- {name="Clothing", id=73, x=414.646, y=-807.452, z=29.338},
    -- {name="Clothing", id=73, x=-815.193, y=-1083.333, z=11.022},
    -- {name="Clothing", id=73, x=-1208.098, y=-782.020, z=17.163},
    -- {name="Clothing", id=73, x=-1457.954, y=-229.426, z=49.185},
    -- {name="Clothing", id=73, x=-2.777, y=6518.491, z=31.533},
    -- {name="Clothing", id=73, x=1681.586, y=4820.133, z=42.046},
    -- {name="Clothing", id=73, x=130.216, y=-202.940, z=54.505},
    -- {name="Clothing", id=73, x=618.701, y=2740.564, z=41.905},
    -- {name="Clothing", id=73, x=1199.169, y=2694.895, z=37.866},
    -- {name="Clothing", id=73, x=-3164.172, y=1063.927, z=20.674},
    -- {name="Clothing", id=73, x=-1091.373, y=2702.356, z=19.422},
    -- -- ammunationblips
    -- {name="Weapon store", id=110, x=1701.292, y=3750.450, z=34.365},
    -- {name="Weapon store", id=110, x=237.428, y=-43.655, z=69.698},
    -- {name="Weapon store", id=110, x=843.604, y=-1017.784, z=27.546},
    -- {name="Weapon store", id=110, x=-321.524, y=6072.479, z=31.299},
    -- {name="Weapon store", id=110, x=-664.218, y=-950.097, z=21.509},
    -- {name="Weapon store", id=110, x=-1320.983, y=-389.260, z=36.483},
    -- {name="Weapon store", id=110, x=-1109.053, y=2686.300, z=18.775},
    -- {name="Weapon store", id=110, x=2568.379, y=309.629, z=108.461},
    -- {name="Weapon store", id=110, x=-3157.450, y=1079.633, z=20.692},
    -- -- Basic
    -- {name="Comedy Club", id=102, x=377.088, y=-991.869, z=-97.604},
    -- {name="Franklin", id=210, x=7.900, y=548.100, z=175.500},
    -- {name="Franklin", id=210, x=-14.128,	y=-1445.483,	z=30.648},
    -- {name="Michael", id=124, x=-852.400, y=160.000, z=65.600},
    -- {name="Trevor", id=208, x=1985.700, y=3812.200, z=32.200},
    -- {name="Trevor", id=208, x=-1159.034,	y=-1521.180, z=10.633},
    -- {name="FIB", id=106, x=105.455, y=-745.483, z=44.754},
    -- {name="Lifeinvader", id=77, x=-1047.900, y=-233.000, z=39.000},
    -- {name="Cluckin Bell", id=357, x=-72.68752, y=6253.72656, z=31.08991},
    -- {name="Tequil-La La", id=93, x=-565.171, y=276.625, z=83.286},
    -- {name="O'Neil Ranch", id=438, x=2441.200, y=4968.500, z=51.700},
     {name="Palace NightClub", id=279, x=757.997, y=-1332.661, z=27.275},
    -- {name="Hippy Camp", id=140, x=2476.712, y=3789.645, z=41.226},
    --{name="Chop shop", id=446, x=479.056, y=-1316.825, z=28.203},
	--{name="Chop shop", id=446, x=1008.35, y=-1316.825, z=28.203},
    -- {name="Rebel Radio", id=136, x=736.153, y=2583.143, z=79.634},
    -- {name="Morgue", id=310, x=243.351, y=-1376.014, z=39.534},
    -- {name="Golf", id=109, x=-1336.715, y=59.051, z=55.246 },
    -- {name="Jewelry Store", id=52,  x=-630.400, y=-236.700, z=40.00},
    -- -- Propperty
    -- {name="Casino", id=207, x=925.329, y=46.152, z=80.908 },
    -- {name="Maze Bank Arena", id=135, x=-250.604, y=-2030.000, z=30.000},
    -- {name="Stripbar", id=121, x=134.476, y=-1307.887, z=28.983},
    -- {name="Smoke on the Water", id=140, x=-1171.42, y=-1572.72, z=3.6636},
    -- {name="Weed Farm", id=140, x=2208.777, y=5578.235, z=53.735},
    -- {name="Downtown Cab Co", id=375, x=900.461, y=-181.466, z=73.89},
    -- {name="Theater", id=135, x=293.089, y=180.466, z=104.301},
    -- -- Gangs
    -- {name="Gang", id=437, x=298.68, y=-2010.10, z=20.07},
    -- {name="Gang", id=437, x=86.64, y=-1924.60, z=20.79},
    -- {name="Gang", id=437, x=-183.52, y=-1632.62, z=33.34},
    -- {name="Gang", id=437, x=989.37, y=-1777.56, z=31.32},
    -- {name="Gang", id=437, x=960.24, y=-140.31, z=74.50},
    -- {name="Gang", id=437, x=-1042.29, y=4910.17, z=94.92},
    -- Gas stations
  --  {name="Station Essence", id=361, x=49.4187,   y=2778.793,  z=58.043},
  --  {name="Station Essence", id=361, x=263.894,   y=2606.463,  z=44.983},
  --  {name="Station Essence", id=361, x=1039.958,  y=2671.134,  z=39.550},
  --  {name="Station Essence", id=361, x=1207.260,  y=2660.175,  z=37.899},
  --  {name="Station Essence", id=361, x=2539.685,  y=2594.192,  z=37.944},
  --  {name="Station Essence", id=361, x=2679.858,  y=3263.946,  z=55.240},
  --  {name="Station Essence", id=361, x=2005.055,  y=3773.887,  z=32.403},
  --  {name="Station Essence", id=361, x=1687.156,  y=4929.392,  z=42.078},
  --  {name="Station Essence", id=361, x=1701.314,  y=6416.028,  z=32.763},
  --  {name="Station Essence", id=361, x=179.857,   y=6602.839,  z=31.868},
  --  {name="Station Essence", id=361, x=-94.4619,  y=6419.594,  z=31.489},
  --  {name="Station Essence", id=361, x=-2554.996, y=2334.40,  z=33.078},
--{name="Station Essence", id=361, x=-1800.375, y=803.661,  z=138.651},
  --  {name="Station Essence", id=361, x=-1437.622, y=-276.747,  z=46.207},
  --  {name="Station Essence", id=361, x=-2096.243, y=-320.286,  z=13.168},
  --  {name="Station Essence", id=361, x=-724.619, y=-935.1631,  z=19.213},
  --  {name="Station Essence", id=361, x=-526.019, y=-1211.003,  z=18.184},
  --  {name="Station Essence", id=361, x=-70.2148, y=-1761.792,  z=29.534},
  --  {name="Station Essence", id=361, x=265.648,  y=-1261.309,  z=29.292},
  --  {name="Station Essence", id=361, x=819.653,  y=-1028.846,  z=26.403},
  --  {name="Station Essence", id=361, x=1208.951, y= -1402.567, z=35.224},
  --  {name="Station Essence", id=361, x=1181.381, y= -330.847,  z=69.316},
  --  {name="Station Essence", id=361, x=620.843,  y= 269.100,  z=103.089},
--    {name="Station Essence", id=361, x=2581.321, y=362.039, 108.468},
    -- Police Stations
     {name="Poste de Police", id=60, x=425.130, y=-979.558, z=30.711},
    --{name="Prison", id=285, x=1679.049, y=2513.711, z=45.565},
--	 {name="Mairie", id=419, x=-404.769, y=1195.437, z=325.380},
	 {name="Tequi-la-la", id=93, x=-560.155, y=286.698, z=82.1764},
	 {name="Vanilla Unicorn", id=121, x=99.155, y=-1307.698, z=30.1764},
--	 {name="Banque de Pret", id=500, x=-1570.911, y=-575.501, z=108.522},
	 {name="Bahama Mamas", id=136, x=-1393.155, y=-609.698, z=30.1764},
	--{name="The Lost", id=77, x=977.155, y=-117.698, z=75.1764},
	 {name="Fourrière", id=225, x=405.155, y=-1638.698, z=30.1764},
   {name="Entrepot Boisson", id=478, x=-1546.95, y=-560.99, z=33.72},
   {name="Entrepot Nourriture", id=478, x=496.17, y=-638.62, z=25.03},
   {name="Entrepot Divers", id=478, x=2703.99, y=3457.46, z=55.55},
	 --{name="Société de transport | PostOp", id=78, x=1197.204, y=-3253.551, z=6.095},
	 --{name="Société de pompiste", id=436, x=893.155, y=-1243.698, z=31.1764},
	 {name="Station de taxi", id=198, x=895.18, y=-179.198, z=74.70},
	 --{name="Société de journalistes | Ls News", id=135, x=-317.92, y=-610.21, z=33.558},
--	{name="H2BA | Ogarnisation d'évenement", id=89, x=-1013.18, y=-481.198, z=40.70},
  --   {name="Globale Corp & Co | Transporteur aérien", id=79, x=1715.18, y=3251.198, z=42.70},
    --{name="ForceGaz | Socièté de gaz", id=66, x=487.18, y=-2152.198, z=6.70},
    --{name="FightClub", id=311, x=105.18, y=-1938.198, z=21.70},
--  {name="Dirt Run", id=17, x=245.18, y=1685.198, z=21.70},
--     {name="Tribunal", id=16, x=269.837, y=-433.134, z=45.255},
    --{name="Gruppe 6", id=366, x=11.482, y=-661.305, z=33.448},
--	{name="O'Tabaco", id=308, x=-72.697372, y=1896.8579, z=196.5941},
--	{name="AlphaCorp", id=401, x=-1577.771240, y=-563.6310424, z=108.523002},
--	{name="MerryWeather", id=280, x=101.95953369, y=-744.2132568, z=45.754753},
--    {name="420Time", id=147, x=-1392.2396, y=-1004.0689, z=23.1565},
--    {name="Lipton", id=273, x=-754.2769, y=5579.2250, z=35.7096},
  {name="Pôle emploi", id=407, x=-1055.0, y=-242.371, z=44.021},


   --[[ {name="Départ GerminusRun #3", id=17, x=-1511.18, y=1493.198, z=169.70},
	{name="Point de passage GerminusRun", id=18, x=-2766.18, y=2710.198, z=53.70},
	{name="Point de passage GerminusRun", id=19, x=495.18, y=5591.198, z=339.70},
	{name="Point de passage GerminusRun", id=20, x=2250.18, y=5605.198, z=69.70},
	{name="Arrivé GerminusRun #3", id=21, x=1143.18, y=-3283.198, z=6.70},--]]

	--[[{name="départ étape 1", id=17, x=3346.18, y=5513.198, z=796.70},
	{name="arrivé étape 1", id=376, x=2702.18, y=5144.198, z=86.70},
	{name="départ étape 2", id=18, x=2411.18, y=4988.198, z=796.70},
	{name="arrivé étape 2", id=376, x=2259.18, y=5618.198, z=86.70},
	{name="départ étape 3", id=19, x=2247.18, y=5596.198, z=796.70},
	{name="arrivé étape 3", id=376, x=-1500.18, y=4944.198, z=86.70},
	{name="départ étape 4", id=20, x=-2251.18, y=4312.198, z=796.70},
	{name="arrivé étape 4", id=376, x=-480.18, y=2999.198, z=86.70},
	{name="départ étape 6", id=22, x=2276.18, y=1093.198, z=796.70},
	{name="arrivé étape 6", id=376, x=1562.18, y=895.198, z=86.70},--]]
    -- Hospitals
     {name="Hôpital", id=61, x= 1839.6, y= 3672.93, z= 34.28},
    --  {name="Hôpital", id=61, x= -247.76, y= 6331.23, z=32.43},
     {name="Hôpital", id=61, x= 1151.024, y= -1529.941, z= 35.373},
    --  {name="Hôpital", id=61, x= 357.43, y= -593.36, z= 28.79},
    --  {name="Hôpital", id=61, x= 295.83, y= -1446.94, z= 29.97},
    --  {name="Hôpital", id=61, x= -676.98, y= 310.68, z= 83.08},
    --  {name="Hôpital", id=61, x= 1151.21, y= -1529.62, z= 35.37},
    --  {name="Hôpital", id=61, x= -874.64, y= -307.71, z= 39.58},
    -- Vehicle Shop (Simeon)
    -- {name="Simeon", id=120, x=-33.803, y=-1102.322, z=25.422},
    -- -- LS Customs
    -- {name="LS Customs", id=72, x= -362.796, y= -132.400, z= 38.252},
    -- {name="LS Customs", id=72, x= -1140.19, y= -1985.478, z= 12.729},
    -- {name="LS Customs", id=72, x= 716.464, y= -1088.869, z= 21.929},
    -- {name="LS Customs", id=72, x= 1174.81, y= 2649.954, z= 37.371},
    -- {name="LS Customs", id=72, x= 118.485, y= 6619.560, z= 31.802},
    -- -- Lester
    -- {name="Lester", id=77, x=1248.183, y=-1728.104, z=56.000},
    -- {name="Lester", id=77, x=719.000, y=-975.000, y=25.000},
    -- -- Survivals
    -- {name="Survival", id=305, x=2351.331, y=3086.969, z=48.057},
    -- {name="Survival", id=305, x=-1695.803, y=-1139.190, z=13.152},
    -- {name="Survival", id=305, x=1532.52, y=-2138.682, z=77.120},
    -- {name="Survival", id=305, x=-593.724, y=5283.231, z=70.230},
    -- {name="Survival", id=305, x=1891.436, y=3737.409, z=32.513},
    -- {name="Survival", id=305, x=195.572, y=-942.493, z=30.692},
    -- {name="Survival", id=305, x=1488.579, y=3582.804, z=35.345},

    -- {name="Safehouse", id=357, x=-952.35943603516, y= -1077.5021972656, z=2.6772258281708},
    -- {name="Safehouse", id=357, x=-59.124889373779, y= -616.55456542969, z=37.356777191162},
    -- {name="Safehouse", id=357, x=-255.05390930176, y= -943.32885742188, z=31.219989776611},
    -- {name="Safehouse", id=357, x=-771.79888916016, y= 351.59423828125, z=87.998191833496},
    -- {name="Safehouse", id=357, x=-3086.428, y=339.252, z=6.371},
    -- {name="Safehouse", id=357, x=-917.289, y=-450.206, z=39.600},
	-- Safehouses
    -- {name="Logement", id=357, x=-63.292, y= -616.444, z=34.265},
    -- {name="Logement", id=357, x=-1446.868, y= -538.276, z=32.820},
    -- {name="Logement", id=357, x=-937.054382324219, y= -379.453918457031, z=36.9613342285156},
    -- {name="Logement", id=357, x=-614.111328125, y= 45.2735786437988, z=41.5914611816406},
    -- {name="Logement", id=357, x=-770.377319335938, y=317.040802001953, z=83.6626510620117},
    -- {name="Logement", id=357, x=-175.676788330078, y=502.43408203125, z=135.420684814453},
    -- {name="Logement", id=357, x=347.220794677734, y=441.418212890625, z=145.701843261719},
    -- {name="Logement", id=357, x=373.370208740234, y=428.043243408203, z=143.684555053711},
    -- {name="Logement", id=357, x=-686.790588378906, y=596.580810546875, z=141.642028808594},
    -- {name="Logement", id=357, x=-751.216918945313, y=621.410888671875, z=140.261199951172},
    -- {name="Logement", id=357, x=-853.353759765625, y=696.033020019531, z=146.784759521484},
	-- {name="Logement", id=357, x=119.131958007813, y=564.880004882813, z=181.959335327148},
	-- {name="Logement", id=357, x=-1294.97436523438, y=455.17041015625, z=95.4321670532227},

    -- {name="Race", id=316, x=-1277.629, y=-2030.913, z=1.2823},
    -- {name="Race", id=316, x=2384.969, y=4277.583, z=30.379},
    -- {name="Race", id=316, x=1577.881, y=3836.107, z=30.7717},
    -- Yacht
    --{name="Yacht", id=410, x=-2045.800, y=-1031.200, z=11.900},
    --{name="Cargo", id=410, x=-90.000, y=-2365.800, z=14.300},
    {name ="Skatepark", id=376, x=-1687.966, y=-758.84, z=10.236}
  }

	Citizen.CreateThread(function()

    for _, item in pairs(blips) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end
	end)


function LoadBlips()
	Citizen.CreateThread(function()
		for i,v in ipairs(Config.ATMS) do
			if v.b == true then
				local blip = AddBlipForCoord(v.x, v.y, v.z)
				SetBlipSprite(blip, 108)
				SetBlipColour(blip, 3)
				SetBlipScale(blip, 1.0)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Banque")
				EndTextCommandSetBlipName(blip)
			else
				local blip = AddBlipForCoord(v.x, v.y, v.z)
				SetBlipSprite(blip, 108)
				SetBlipColour(blip, 2)
				SetBlipScale(blip, 0.5)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Distributeur")
				EndTextCommandSetBlipName(blip)
			end
		end
		for i,v in ipairs(ClothingShop) do
			local blip = AddBlipForCoord(v.x, v.y, v.z)
			SetBlipSprite(blip, 73)
			SetBlipColour(blip, 47)
			SetBlipScale(blip, 1.0)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.name)
			EndTextCommandSetBlipName(blip)
		end
	end)
end
