
local ok = pcall(include, "menu2/menu.lua" )

if not ok or not MENU2_LOADED then
	include( "menu/menu.lua" )
end