local function lua_run_menu(_,_,_,code)
	local func = CompileString(code,"",true)
	if isstring(func) then
		Msg"CMD> "print(func)
	end
	xpcall(func,function(err)
		print(debug.traceback(err))
	end)
end
concommand.Add("lua_run_menu",lua_run_menu)


hook.Add( "MenuStart", "Menu2", function()

end )

hook.Add( "GameContentChanged", "Menu2", function()

end )


hook.Add( "GameContentChanged", "Menu2", function()

end )


function UpdateSteamName( id, time )

	if ( !id ) then return end

	if ( !time ) then time = 0.2 end

	local name = steamworks.GetPlayerName( id )
	if ( name != "" && name != "[unknown]" ) then

		
		return;

	end

	steamworks.RequestPlayerInfo( id )
	timer.Simple( time, function() UpdateSteamName( id, time + 0.2 ) end )

end



function UpdateLanguages()

	local f = file.Find( "resource/localization/*.png", "MOD" )
	
end

--
-- Called from the engine any time the language changes
--
function LanguageChanged( lang )
	print("LanguageChanged")
	
	
end



hook.Add( "GameContentChanged", "RefreshMainMenu", function()
	print("GameContentChanged")
end )


--pnlMainMenu = vgui.Create( "MainMenuPanel" )
--"UpdateVersion( '"..VERSIONSTR.."', '"..BRANCH.."' )" )

local language = GetConVarString( "gmod_language" )
--LanguageChanged( language )

--hook.Run( "GameContentChanged" )
