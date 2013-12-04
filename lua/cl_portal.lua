Servers = { 
	{"PlaceHolder", "37.187.77.51:27015", "This is the Minigames server"},
	{"PlaceHolder2", "37.187.77.51:27016", "This is the Zombie Survival server"},
	{"PlaceHolder3", "37.187.77.51:27017", "This is the Retro Team Play server"},
}

concommand.Add("portal", function(ply, cmd, args)
	local portalframe = vgui.Create("DFrame")
	portalframe:SetSize(500, 500)
	portalframe:SetPos(ScrW() / 4, ScrH() / 4)
	portalframe:SetSkin("ServerBase")
	portalframe:MakePopup(true)
	portalframe:ShowCloseButton(false)
	
	local titleicon = vgui.Create("DImage", portalframe)
	titleicon:SetSize(16, 16)
	titleicon:SetPos(5, 5)
	titleicon:SetImage("icon16/server_connect.png")
	
	local title = vgui.Create("DLabel", portalframe)
	title:SetFont("AFont")
	title:SetSize(300, 20)
	title:SetTextColor(Color(255, 255, 255, 255))
	title:SetPos(25, 3)
	title:SetText("Portal - Connect to other servers!")
	
	local closebutton = vgui.Create("DButton", portalframe)
	closebutton:SetSize(30, 25)
	closebutton:SetPos(470, 0)
	closebutton:SetText("X")
	closebutton.Paint = function()
		local w, h = closebutton:GetSize()
		
		closebutton:SetTextColor(Color(255, 255, 255, 255))
		if ( closebutton.Depressed ) then
			return draw.RoundedBox(-1, 0, 0, w, h, Color(200, 200, 200, 255))
		end
		
		if ( closebutton.Hovered ) then
			return draw.RoundedBox(-1, 0, 0, w, h, Color(255, 0, 0, 255))
		end
		
		if ( closebutton:GetDisabled() ) then
			return draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0, 0, 200))
		end
		draw.RoundedBox(-1, 0, 0, w, h, Color(150, 0, 0, 255))
	end
	closebutton.DoClick = function()
		portalframe:Close()
	end
	
	local serverpanel = vgui.Create("DPanelList", portalframe)
	serverpanel:SetSize(500, 485)
	serverpanel:EnableVerticalScrollbar(true)
	serverpanel:SetPos(0, 45)
	serverpanel.Paint = function()
		local w, h = serverpanel:GetSize()
		
		return draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0, 0, 100))
	end
	
	for k, v in pairs (Servers) do
		local button = vgui.Create("DButton")
		button:SetText(v[1])
		if ( !v[3] ) then
			button:SetTooltip("No description provided")
		else
			button:SetTooltip(v[3])
		end
		button.DoClick = function()
			timer.Simple(1, function()
				LocalPlayer():ConCommand("connect " .. v[2])
			end)
		end
		serverpanel:AddItem(button)
	end
	
end)