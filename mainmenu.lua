local R=function(a,b,c,d,e) return function() return RunConsoleCommand(a,b,c,d,e) end end
local M=function(x) return function() return RunGameUICommand(x) end end
local NOT=function(f) return function(...) return not f(...) end end

local mainmenu = {
	{""},
	{"resume_game",					gui.HideGameUI,                      "icon16/joystick.png"				,show=IsInGame},
	{"disconnect",					M"disconnect",                      "icon16/disconnect.png"				,show=IsInGame},
	{"reconnect",					R"retry",                      		"icon16/connect.png"				,show=WasInGame},
	{"server_players",	M"openplayerlistdialog",        	"icon16/group_delete.png"			,show=IsInGame},
	
	{"",show=WasInGame},
	--{"new_game",					M"opencreatemultiplayergamedialog", "icon16/server.png"					},
	{"legacy_browser",					M"openserverbrowser",               "icon16/world.png"					},
	{"server_list",					R"lua_openserverbrowser",               "icon16/world.png"					},
	
	{""},
	{"options",						M"openoptionsdialog",               "icon16/wrench.png"					},
	{"GameUI_Console",				R"showconsole",                   	"icon16/application_xp_terminal.png",
		show=function() return IsDeveloper() and not gui.IsConsoleVisible() end},
	
	{""},
	{"GameUI_Quit",					M"quitnoconfirm",                   "icon16/door.png"					},
	{""},
}
-- addons
-- games
-- language
-- settings
-- lua cache?
-- workshop search
-- con filter out
-- console open
-- devmode quicktoggle
-- favorites and their status on main menu?
-- browser? / overlay?
-- client.vdf browser/editor
-- 

local menulist_wrapper = vgui.Create('DPanelList',nil,'menulist_wrapper')
local isours
if pnlMainMenu and pnlMainMenu:IsValid() then pnlMainMenu:Remove() end
	
_G.pnlMainMenu = menulist_wrapper
menulist_wrapper:EnableVerticalScrollbar(true)
menulist_wrapper:SetWide(350)
menulist_wrapper:Dock(LEFT)
menulist_wrapper:DockMargin(32,32,32,32)


local div_hack = vgui.Create'EditablePanel'
div_hack:SetTall(52)
div_hack:SetZPos(-20000)
menulist_wrapper:AddItem(div_hack)

local lastscroll = menulist_wrapper.VBar:GetScroll()



local addonslist
function CreateAddons()
	
	if addonslist and addonslist:IsValid() then addonslist:Remove() addonslist=nil end
	
	addonslist = vgui.Create('DForm',menulist_wrapper,'addonslist')
	addonslist:Dock(TOP)
	addonslist:SetName"#manage_addons"
	addonslist:SetExpanded(false)
	
	addonslist:SetCookieName"addonslist"
	addonslist:LoadCookies()
	
	menulist_wrapper:AddItem(addonslist)
	menulist_wrapper:InvalidateLayout(true)
	addonslist:InvalidateLayout(true)
	addonslist.Header:SetIcon 'icon16/plugin.png'
	

	local btn = vgui.Create("DButton",addonslist,'addonslist_button')
		addonslist:AddItem(btn)
		btn:SetText("#addons.enableall")
		btn:SetIcon 'icon16/add.png'
		
		function btn.DoClick(btn)
			for k,v in next,engine.GetAddons() do
				steamworks.SetShouldMountAddon(v.wsid or v.file,true)
			end
			isours = true
			steamworks.ApplyAddons()
			isours = true
			
			CreateMenu()

		end
	local btn = vgui.Create("DButton",addonslist,'addonslist_button')
		addonslist:AddItem(btn)
		btn:SetText("#addons.disableall")
		btn:SetIcon 'icon16/delete.png'
		
		function btn.DoClick(btn)
			for k,v in next,engine.GetAddons() do
				steamworks.SetShouldMountAddon(v.wsid or v.file,false)
			end
			isours = true
			steamworks.ApplyAddons()
			isours = true
			CreateMenu()
		end
	local btn = vgui.Create("DButton",addonslist,'addonslist_button')
		addonslist:AddItem(btn)
		btn:SetText("#addons.uninstallall")
		btn:SetIcon 'icon16/stop.png'
		function btn.DoClick(btn)
			for k,v in next,engine.GetAddons() do
				if v.wsid then
					print("Unsubscribe",v.wsid)
					steamworks.Unsubscribe(v.wsid)
				end
			end
			isours = true steamworks.ApplyAddons() isours = true
			CreateMenu()
		end

	local function AddButton(data,title,mounted,downloaded,wsid,filepath)
		
		local btn = vgui.Create("DCheckBoxLabel",addonslist,'addonslist_button')
			addonslist:AddItem(btn)
			btn:SetText(title or filepath)
			btn:SetChecked(mounted)
			btn:SetBright(true)
			btn:SetDisabled(not downloaded)
			btn:SizeToContents()
			function btn:OnChange(val)
				print("mount",filepath,val)
				local old = steamworks.ShouldMountAddon(wsid)
				steamworks.SetShouldMountAddon(wsid,val)
				isours = true steamworks.ApplyAddons() isours = true
				local new = steamworks.ShouldMountAddon(wsid)
				btn:SetChecked(new)
				if old==new then
					print("Warning: ","could not toggle",filepath)
				end
			end
			btn.Label.DoRightClick=function()
				local m =DermaMenu()
					m:AddOption("#addon.unsubscribe",function()
						print("Unsubscribe",wsid)
						steamworks.Unsubscribe(wsid)
					end)
					m:AddOption("#copy",function()
						SetClipboardText('http://steamcommunity.com/sharedfiles/filedetails/?id='..wsid)
					end)
				m:Open()
			end
	
		btn:InvalidateLayout(true)
		--btn:Dock(TOP)
	end

	local t=engine.GetAddons()
	table.sort(t,function(a,b)
		if a.mounted==b.mounted then
			if a.wsid and b.wsid then
				return a.wsid<b.wsid
			elseif a.title and b.title then
				return a.title<b.title
			else
				return a.file<b.file
			end
		else
			return  (a.mounted and 0 or 1)<(b.mounted and 0 or 1)
		end
	end)
	for _,data in next,t do
		AddButton(data,data.title,data.mounted,data.downloaded,data.wsid,data.file)
	end
	
	
	
	menulist_wrapper.VBar:SetScroll(lastscroll)
	
end



local settingslist
function CreateExtraSettings()
	
	if settingslist and settingslist:IsValid() then settingslist:Remove() settingslist=nil end
	
	settingslist = vgui.Create('DForm',menulist_wrapper,'settingslist')
	settingslist:Dock(TOP)
	settingslist:SetName"Extra Settings"
	settingslist:SetExpanded(false)
	settingslist.Header:SetIcon 'icon16/cog.png'
	settingslist:SetCookieName"settingslist"
	settingslist:LoadCookies()
	
	menulist_wrapper:AddItem(settingslist)
	menulist_wrapper:InvalidateLayout(true)
	settingslist:InvalidateLayout(true)
	
	local function AddCheck(txt,cvar)
		
		local 
			c = vgui.Create( 'DCheckBoxLabel',settingslist,'settingslist_check')
				settingslist:AddItem(c)
			c:SetText( txt )
			c:SetConVar(cvar)
			c:SetBright(true)
			c:SizeToContents()
			c:InvalidateLayout(true)
		return c
	end

	local x = vgui.Create( 'DLabel',settingslist)
	x:SetText"Loading Screen"
	settingslist:AddItem(x)
	AddCheck( "Enable","lua_loading_screen")
	AddCheck( "Transparency","lua_loading_screen_transp")
	AddCheck( "Try hiding","lua_loading_screen_hide")
	local x = vgui.Create( 'DLabel',settingslist)
	x:SetText"Download / Upload"
	settingslist:AddItem(x)
	AddCheck( "Allow DL","cl_allowdownload")
	AddCheck( "Allow UL","cl_allowupload")
	AddCheck( "FastDL debug","download_debug")
	local x = vgui.Create( 'DLabel',settingslist)
	x:SetText" "
	settingslist:AddItem(x)
	
end




local gameslist
function CreateGames()
	
	if gameslist and gameslist:IsValid() then gameslist:Remove() gameslist=nil end
	
	gameslist = vgui.Create('DForm',menulist_wrapper,'gameslist')
	gameslist:Dock(TOP)
	gameslist:SetName"#mounted_games"
	gameslist:SetExpanded(false)
	gameslist.Header:SetIcon 'icon16/joystick.png'
	gameslist:SetCookieName"gameslist"
	gameslist:LoadCookies()
	
	menulist_wrapper:AddItem(gameslist)
	menulist_wrapper:InvalidateLayout(true)
	gameslist:InvalidateLayout(true)
	
	local function AddButton(data,title,mounted,owned,installed,depot)
		
		local btn = vgui.Create("DCheckBoxLabel",gameslist,'gameslist_button')
			gameslist:AddItem(btn)
			btn:SetText(title)
			btn:SetChecked(mounted)
			btn:SetBright(true)
			btn:SetDisabled(not owned or not installed)
			btn:SizeToContents()
			function btn:OnChange(val)
				engine.SetMounted(depot,val)
				btn:SetChecked(IsMounted(depot))
			end
	
		btn:InvalidateLayout(true)
		--btn:Dock(TOP)
	end

	local t=engine.GetGames()
	table.sort(t,function(a,b)
		if a.mounted==b.mounted then
			if a.mounted then
				return a.depot<b.depot
			else
				return ((a.installed and a.owned) and 0 or 1)<((b.installed and b.owned) and 0 or 1)
			end
		else
			return  (a.mounted and 0 or 1)<(b.mounted and 0 or 1)
		end
	end)
	for _,data in next,t do
		AddButton(data,data.title,data.mounted,data.owned,data.installed,data.depot)
	end
	
	CreateAddons()
	
end



local menulist
local creating
local function _CreateMenu()
	creating = false
	
	lastscroll = menulist_wrapper.VBar:GetScroll()
	
	if menulist and menulist:IsValid() then menulist:Remove() menulist=nil end
	
	menulist = vgui.Create('DForm',menulist_wrapper,'menulist')
	menulist:Dock(TOP)
	menulist:SetName""
	menulist.Header:SetIcon 'icon16/house.png'
	menulist:SetCookieName"menulist"
	menulist:LoadCookies()
	
	
	menulist_wrapper:AddItem(menulist)
	menulist_wrapper:InvalidateLayout(true)
	menulist:InvalidateLayout(true)
	
	local function AddButton(data,text,menucmd,icon)
		
		if data.show and not data:show() then return end
		
		if text=="" and not menucmd then
			local div = vgui.Create'EditablePanel'
			div:SetTall(1)
			menulist:AddItem(div)
			return
		end
		
		local btn = vgui.Create("DButton",menulist,'menulist_button')
			menulist:AddItem(btn)
			btn:SetText("#"..text)
			btn:SetFont"closecaption_normal"
			btn:SizeToContents()
		btn.DoClick=function()
			menucmd()
			btn:SetSelected(false)
		end
		if icon and #icon>0 then
			btn:SetImage(icon)
		end
		btn:InvalidateLayout(true)
		
		btn:SetTextInset( 16+ 16, 0 )
		btn:SetContentAlignment(4)
		
		local tall = btn:GetTall()+4
		tall=tall<32 and 32 or tall
		btn:SetTall(tall)
		--btn:Dock(TOP)
	end

	for _,data in next,mainmenu do
		AddButton(data,data[1],data[2],data[3])
	end
	
	CreateExtraSettings()
	CreateGames()
	
	menulist:InvalidateLayout(true)
	
end

function CreateMenu()
	if creating then return end
	creating = true
	timer.Simple(0.2,function()
		_CreateMenu()
	end)
end

--CreateMenu()

hook.Add( "GameContentsChanged", "CreateMenu", function(mount,addon)
	if mount then return end
	
	-- EEK
	if not mount and not addon then return end
	
	if isours then isours = false return end

	CreateMenu()
	
end )

hook.Add( "InGame", "CreateMenu", function(is)
	CreateMenu()
end )

hook.Add( "ConsoleVisible", "CreateMenu", function(is)
	
	if IsDeveloper() then 
		CreateMenu()
	end
	
end )

hook.Add( "LoadingStatus", "CreateMenu", function(status)
	--CreateMenu()
end )