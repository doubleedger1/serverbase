concommand.Add("sb_rules", function(ply, cmd, args) 
	if ( !RULES_ENABLED ) then
		ply:ChatPrint("[SERVERBASE] The rules feature has been disabled!")
		return 
	end
	local frame = vgui.Create("DFrame")
	frame:SetSize(700, 500)
	frame:Center()
	frame:SetSkin("ServerBase")
	frame:ShowCloseButton(false)
	frame:MakePopup()
	
	local titleicon = vgui.Create("DImage", frame)
	titleicon:SetSize(16, 16)
	titleicon:SetPos(5, 5)
	titleicon:SetImage("icon16/script_edit.png")
	
	local title = vgui.Create("DLabel", frame)
	title:SetFont("AFont")
	title:SetSize(300, 20)
	title:SetTextColor(Color(255, 255, 255, 255))
	title:SetPos(25, 3)
	title:SetText("Rules - Follow them or be punished!")
	
	local closebutton = vgui.Create("DButton", frame)
	closebutton:SetSize(30, 25)
	closebutton:SetPos(670, 0)
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
		frame:Close()
	end

	for k, v in pairs (Rules) do
		local ruleslist = vgui.Create("DLabel", frame)
		ruleslist:SetPos(10, 26 * k)
		ruleslist:SetText(v)
		ruleslist:SetFont("AFont")
		ruleslist:SetSize(600, 20)
		ruleslist:SetColor(Color(255, 255, 255, 255))
	end
end)
