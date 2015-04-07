-- fallback
if not file.Exists("menu2/menu.lua",'LuaMenu') then include( "menu/menu.lua" ) return end

-- include menu2
include( "menu2/menu.lua" )
