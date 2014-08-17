local PANEL={}
function PANEL:Init()
	self:SetSize(1024,768)
end

vgui.Register("LoadingURLPanel",PANEL,'DPanel')	
local pnlLoading = nil
	
--[[	serverlist.PlayerList( serverip, function( tbl )

		local json = util.TableToJSON( tbl );
		pnlMainMenu:Call( "SetPlayerList( '"..serverip.."', "..json..")" );

	end )

--]]

function GetLoadPanel()

	if ( !IsValid( pnlLoading ) ) then
		pnlLoading = vgui.Create( "LoadingURLPanel",nil,'sv_loadingurl' )
	end

	return pnlLoading
	
end