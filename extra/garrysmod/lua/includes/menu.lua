
if file.Exists("lua/menu2/menu.lua",'LuaMenu') then
	include( "menu2/menu.lua" )
	return
end

include( "menu/menu.lua" )
