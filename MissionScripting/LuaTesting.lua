_SETTINGS:SetPlayerMenuOff() -- will disable the player menus.

Birth_Event_Handler_MOOSE = EVENTHANDLER:New()
Birth_Event_Handler_MOOSE:HandleEvent(EVENTS.Birth)

function Birth_Event_Handler_MOOSE:OnEventBirth(EventData)   
	MESSAGE:New( EventData.IniUnitName.." is controlled by player "..EventData.IniPlayerName, 10 ):ToAll()
	AddRadioItems(EventData.IniGroup)
end

function blah()
	MESSAGE:New( "In Menu function." ):ToAll()
end

function AddRadioItems( group )
	if group then
		MENU_GROUP_COMMAND:New( group, "blah menu item", nil, blah )
	end
end


Client_SET = SET_CLIENT:New():FilterActive(Active):FilterOnce()

Client_SET:ForEachClient(
	function(Client)
		if Client:GetPlayerName() then
			MESSAGE:New( Client:GetName().." is controlled by player "..Client:GetPlayerName(), 10 ):ToAll()
			AddRadioItems( Client:GetGroup() )
		end 
	end 
)
