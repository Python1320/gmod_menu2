hook.Add( "OnLuaError", "MenuErrorHandler", function( str, realm, addontitle, addonid )
	print("OnLuaError",str,realm,addontitle,addonid)
end)