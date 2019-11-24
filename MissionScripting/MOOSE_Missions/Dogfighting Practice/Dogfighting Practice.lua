MESSAGE:New( "This training mission is intended to spawn air opponents for you to defeat.  They will start 3 miles out heading your way at co-altitude.", 25 ):ToAll()


ImperialSettings = _SETTINGS:SetImperial()

Red_AirplaneTemplate = { "RED_F-18", "RED_F-18", "RED_F-18", "RED_F-18" }
Red_AirplaneSpawner = SPAWN:New( "RED_F-18" )
:InitRandomizeTemplate(Red_AirplaneTemplate)
--:InitRandomizePosition( true , 75000, 37000 )

function EnemyAirplaneSpawnFunction ( playerGroup )
	-- Find the player's position.
	local playerPosition = POINT_VEC3:NewFromVec3(playerGroup:GetVec3())
	playerPosition:SetX(playerPosition.x + 4800)
	
	MESSAGE:New( string.format ("Heading: %i", playerGroup:GetHeading()), 25 ):ToAll()
	
	local EnemyAircraft
	EnemyAircraft = Red_AirplaneSpawner:SpawnFromVec3( playerPosition ) 
	
	--EnemyAircraft:InitHeading( 125 )
	
	-- Set spawned aircraft to attack and notify players.
	if (EnemyAircraft) then
		Task = EnemyAircraft:TaskAttackGroup( playerGroup )
		EnemyAircraft:PushTask(Task, 5)
		MESSAGE:New(playerGroup:GetPlayerName(), 25, "Spawning enemy aircraft for" ):ToAll()
	end
end

function AddRadioItems( groupName )
	local group = GROUP:FindByName( groupName )
	if group and group:IsAlive() then
		MENU_GROUP_COMMAND:New( group, "Spawn Enemy Aircraft to Engage", nil, EnemyAirplaneSpawnFunction, group )
	end
end

SCHEDULER:New( nil,
function()
	AddRadioItems( "Blue_A-10C_1_Client" )
	AddRadioItems( "Blue_A-10C_2_Client" )
	AddRadioItems( "Blue_AV-8B_Client" )
	AddRadioItems( "Blue_F-15C_Client" )
	AddRadioItems( "Blue_F-5E_Client" )
	AddRadioItems( "Blue_M-2000_Client" )
	AddRadioItems( "Blue_F/A-18C_1_Client" )
	AddRadioItems( "Blue_F/A-18C_2_Client" )
	AddRadioItems( "Blue_F/A-18C_3_Client" )
	AddRadioItems( "Blue_F/A-18C_4_Client" )
	AddRadioItems( "Blue_F-14B_1_Client" )
	AddRadioItems( "Blue_F-14B_2_Client" )
	AddRadioItems( "Blue_F-14B_3_Client" )
	AddRadioItems( "Blue_F-14B_4_Client" )
end, {}, 1, 10 )


