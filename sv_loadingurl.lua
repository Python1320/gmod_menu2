g_ServerName	= ""
g_MapName		= ""
g_ServerURL		= ""
g_MaxPlayers	= ""
g_SteamID		= ""

local PANEL = {}

function PANEL:Init()

	self:SetSize( 1,1 )
	self:SetPopupStayAtBack(true)
	self:MoveToBack()

end



function PANEL:PerformLayout()

	self:SetSize( 1,1 )
	self:SetPopupStayAtBack(true)
	self:MoveToBack()
	
end


function PANEL:Paint()
end

local lurl

function PANEL:OnActivate()

	g_ServerName	= ""
	g_MapName		= ""
	g_ServerURL		= ""
	g_MaxPlayers	= ""
	g_SteamID		= ""

	print("LoadingURL",GetConVarString"hostip")
	RawConsoleCommand "showconsole"
	RawConsoleCommand "gameui_hide"
	gui.HideGameUI()
	timer.Simple(0,function()
		gui.HideGameUI()
		self:SetPopupStayAtBack(true)
		self:MoveToBack()
	RawConsoleCommand "showconsole"
	RawConsoleCommand "gameui_hide"
	timer.Simple(1,function()
		gui.HideGameUI()
		self:SetPopupStayAtBack(true)
		self:MoveToBack()
	end)
	end)
	
end

hook.Add("DrawOverlay","eek",function()
	if lurl then
		lurl:SetPaintedManually(false)
			lurl:SetAlpha(200)
			lurl:PaintManual()
		lurl:SetPaintedManually(true)
	end
end)

function PANEL:OnDeactivate()
	if lurl then
		lurl:Remove()
		lurl=nil
	end
	print("Unloading",GetDefaultLoadingHTML())
	
end

function PANEL:Think()

end

function PANEL:StatusChanged( strStatus )
	print("> ",strStatus)
end

local factor = vgui.RegisterTable( PANEL, "EditablePanel" )


local pnl = nil

function GetLoadPanel()
	print"GetLoadPanel"
	
	if ( !IsValid( pnl ) ) then
		pnl = vgui.CreateFromTable( factor )
	end

	return pnl
	
end

--engine
function UpdateLoadPanel( strJavascript )
	
	print("UpdateLoadPanel",strJavascript)
end


function GameDetails( servername, serverurl, mapname, maxplayers, steamid, gamemode )

	if ( engine.IsPlayingDemo() ) then return end

	g_ServerName	= servername
	g_MapName		= mapname
	g_ServerURL		= serverurl
	g_MaxPlayers	= maxplayers
	g_SteamID		= steamid
	g_GameMode		= gamemode

	MsgN( "servername ",servername )
	MsgN( "serverurl ",serverurl )
	
	if not lurl then
		lurl = vgui.Create('DHTML',self)
		lurl.Paint=function() end
		lurl:SetPaintedManually(true)
		lurl:SetSize(ScrW(),ScrH())
		lurl:MoveToBack()
		lurl:OpenURL(g_ServerURL)
	end
	
	MsgN( "gamemode ",gamemode )
	MsgN( "mapname ",mapname )
	MsgN( "maxplayers ",maxplayers )
	MsgN( "steamid ",steamid )
	
	serverurl = serverurl:Replace( "%s", steamid )
	serverurl = serverurl:Replace( "%m", mapname )

end