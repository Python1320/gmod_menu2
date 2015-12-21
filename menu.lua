MsgN"Loading menu2..."
include( "menu2/util.lua" )

include( "menu/mount/mount.lua" ) -- workshop

--include( "menu/getmaps.lua" )
include( "menu2/sv_loadingurl.lua" )
include( "menu2/mainmenu.lua" )
include( "menu2/errors.lua" )

include( "menu/video.lua" )
include( "menu/demo_to_video.lua" )
include( "menu/motionsensor.lua" )

--include( "menu2/menu_save.lua" )
--include( "menu2/menu_demo.lua" )
--include( "menu2/menu_addon.lua" )
--include( "menu2/menu_dupe.lua" )

include( "serverquery.lua" )

print "...loaded Menu2!"
MENU2_LOADED = true
