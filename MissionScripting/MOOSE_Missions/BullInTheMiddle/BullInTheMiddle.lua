
MESSAGE:New( "This training mission is intended to spawn random enemy air or ground units in random directions via the radio menu for you to defeat.", 25 ):ToAll()

Scoring = SCORING:New( "ScoringObject" )
ImperialSettings = _SETTINGS:SetImperial()

Red_AirplaneTemplate = { "AI_Su-27", "AI_Su-33", "AI_Mig-23", "AI_Mig-29" }
Red_AirplaneSpawner = SPAWN:New( "Red_Aircraft" )
:InitLimit( 20, 10 )
:InitRandomizeTemplate(Red_AirplaneTemplate)
:InitRandomizePosition( true , 75000, 37000 )

Blue_AirplaneTemplate = { "AI_AV-8B", "AI_F-14A", "AI_F-15C", "AI_F-16C" }
Blue_AirplaneSpawner = SPAWN:New( "Blue_Aircraft" )
:InitLimit( 20, 10 )
:InitRandomizeTemplate(Blue_AirplaneTemplate)
:InitRandomizePosition( true , 74000, 37000 )

Red_GroundTemplate = { "AI_SA-19", "AI_ZU-23", "AI_SA-13", "AI_SA-15", "AI_SA-8", "AI_SA-9" }
Red_GroundSpawner = SPAWN:New( "Red_Ground" )
:InitLimit( 20, 10 )
:InitRandomizeTemplate(Red_GroundTemplate)

Blue_GroundTemplate = { "AI_M48", "AI_M6", "AI_LN M901" }
Blue_GroundSpawner = SPAWN:New( "Blue_Ground" )
:InitLimit( 20, 10 )
:InitRandomizeTemplate(Blue_GroundTemplate)

function EnemyAirplaneSpawnFunction ( playerGroup )
	-- Let everyone know we are spawning enemy aircraft
	MESSAGE:New(playerGroup:GetPlayerName(), 25, "Spawning enemy aircraft for" ):ToAll()
	
	-- Find the player's position.
	-- NOTE: Since spawned aircraft uses player's altitude, randomizing the altitude.
	local playerPosition = POINT_VEC3:NewFromVec3(playerGroup:GetVec3())
	local y = math.random(500, 7000)
	playerPosition:SetY(y)
	
	local EnemyAircraft
	-- Depending on client coalition, spawn enemy aircraft.
	if (playerGroup:GetCoalition() == 1) then --Client is from the Red Coalition
		EnemyAircraft = Blue_AirplaneSpawner:SpawnFromVec3( playerPosition )
	elseif (playerGroup:GetCoalition() == 2) then -- Client is from the Blue Coalition
		EnemyAircraft = Red_AirplaneSpawner:SpawnFromVec3( playerPosition ) 
	end
	
	-- Set spawned aircraft to attack player.
	if (EnemyAircraft) then
		Task = EnemyAircraft:TaskAttackGroup( playerGroup )
		EnemyAircraft:PushTask(Task, 5)
	end
end

function DeleteEnemyAircraftFunction( playerGroup )
	-- Depending on client coalition, grab the correct spawner.
	local spawner
	if (playerGroup:GetCoalition() == 1) then --Client is from the Red Coalition
		spawner = Blue_AirplaneSpawner
	elseif (playerGroup:GetCoalition() == 2) then -- Client is from the Blue Coalition
		spawner = Red_AirplaneSpawner
	end

	-- Loop through all enemy aircraft and destroy them.
	local group = spawner:GetFirstAliveGroup()
	while group ~= nil do
		MESSAGE:New (group:GetName(), 25, "Destroying Group" ):ToAll()
		group:Destroy()
		group = spawner:GetFirstAliveGroup()
	end
end

function EnemyAircraftReportFunction( playerGroup )
	-- Depending on client coalition, grab the correct spawner.
	local spawner
	if (playerGroup:GetCoalition() == 1) then --Client is from the Red Coalition
		spawner = Blue_AirplaneSpawner
	elseif (playerGroup:GetCoalition() == 2) then -- Client is from the Blue Coalition
		spawner = Red_AirplaneSpawner
	end

	local group, index = spawner:GetFirstAliveGroup()
	if (group) then
		local targets = group:GetDetectedTargets()
		for k in pairs(targets) do
			MESSAGE:New ("blah", 25, "Target" ):ToAll()
--			print(k, v[1], v[2], v[3])
		end
	end
--	while group ~= nil do
--		local detectedTargets = group:GetDetectedTargets()
--		local fuelQty = group:GetFuel()
--		MESSAGE:New( "Fuel Quantity: " .. tostring(fuelQty), 25, group:GetName()):ToAll()
--		group, index = spawner:GetNextAliveGroup( index )
--	end
end

function EnemyGroundSpawnFunction ( playerGroup )
	-- Find a random location to spawn enemy unit.
	local counter = 0
	repeat
		randomLocation = playerGroup:GetCoordinate():GetRandomVec2InRadius( 75000, 37000 )
		counter = counter + 1

		if (counter == 1000) then -- If haven't found a good location in 10 tries notify and exit.
			MESSAGE:New("Unable to find a suitable location to spawn enemy unit.", 25, "Spawn Failed" ):ToAll()
			return
		end	
	until (land.getSurfaceType(randomLocation) == land.SurfaceType.ROAD) --LAND

	-- Depending on client coalition, spawn enemy ground unit.
	local enemyGround
	if (playerGroup:GetCoalition() == 1) then --Client is from the Red Coalition
		enemyGround = Blue_GroundSpawner:SpawnFromVec2( randomLocation )
	elseif (playerGroup:GetCoalition() == 2) then -- Client is from the Blue Coalition
		enemyGround = Red_GroundSpawner:SpawnFromVec2( randomLocation ) 
	end
	
	-- Set spawned ground unit to attack player and notify players.
	if (enemyGround) then
--		local task = enemyGround:TaskAttackGroup( playerGroup )
--		enemyGround:PushTask(task, 5)

		--enemyGround:RouteGroundOnRoad(enemyGround:GetCoordinate(), 75, 5)
		MESSAGE:New(playerGroup:GetPlayerName(), 25, "Spawning enemy ground unit for" ):ToAll()
	end
end

function EnemyBearingFunction(playerGroup)
	-- Depending on client coalition, grab the correct spawners.
	local airSpawner
	local groundSpawner
	if (playerGroup:GetCoalition() == 1) then --Client is from the Red Coalition
		airSpawner = Blue_AirplaneSpawner
		groundSpawner = Blue_GroundSpawner
	elseif (playerGroup:GetCoalition() == 2) then -- Client is from the Blue Coalition
		airSpawner = Red_AirplaneSpawner
		groundSpawner = Red_GroundSpawner
	end

	-- Provide BRA for first Enemy Air Unit or BR for first Enemy Ground Unit.
	local enemyAirGroup = airSpawner:GetFirstAliveGroup()
	local enemyGroundGroup = groundSpawner:GetFirstAliveGroup()
	
	if (enemyAirGroup) then
		local enemyCoordinate = enemyAirGroup:GetCoordinate()
		local playerCoordinate = playerGroup:GetCoordinate()
		local braString = enemyCoordinate:ToStringBRA(playerCoordinate, ImperialSettings)
		MESSAGE:New (enemyAirGroup:GetTypeName() .. ": " .. braString, 25):ToAll() -- .. 
	elseif (enemyGroundGroup) then
		local enemyCoordinate = enemyGroundGroup:GetCoordinate()
		local playerCoordinate = playerGroup:GetCoordinate()
		local brString = enemyCoordinate:ToStringBR(playerCoordinate, ImperialSettings)
		MESSAGE:New (enemyGroundGroup:GetTypeName() .. ": " .. brString, 25):ToAll()
	end
end

function ReportScore(playerGroup)
	Scoring:ReportScoreGroupDetailed(playerGroup)
end

function AddRadioItems( groupName )
	local group = GROUP:FindByName( groupName )
	if group and group:IsAlive() then
		MENU_GROUP_COMMAND:New( group, "Spawn Enemy Aircraft to Engage", nil, EnemyAirplaneSpawnFunction, group )
--		MENU_GROUP_COMMAND:New( group, "Delete Enemy Aircraft", nil, DeleteEnemyAircraftFunction, group )
--		MENU_GROUP_COMMAND:New( group, "Enemy Aircraft Report", nil, EnemyAircraftReportFunction, group )
		MENU_GROUP_COMMAND:New( group, "Spawn Enemy Ground Unit to Engage", nil, EnemyGroundSpawnFunction, group )
		MENU_GROUP_COMMAND:New( group, "Bearing to Enemy", nil, EnemyBearingFunction, group )
		MENU_GROUP_COMMAND:New( group, "Report Score", nil, ReportScore, group )
	end
end

SCHEDULER:New( nil,
function()
	AddRadioItems( "Blue_A-10C_1_Client" )
	AddRadioItems( "Blue_A-10C_2_Client" )
	AddRadioItems( "Blue_AV-8B_Client" )
	AddRadioItems( "Blue_F-15C_Client" )
	AddRadioItems( "Blue_F-5E_Client" )
	AddRadioItems( "Red_Su-27_Client" )
end, {}, 1, 10 )

