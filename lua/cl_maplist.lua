scale = scale or math.Clamp((ScrH() / 1080), 1, 0.6)

net.Receive("requestmaps", function(len)
	net.Start("sendmaps")
	net.SendToServer()
end)

net.Receive("sentmaps", function(len)
	local maps = net.ReadTable()
end)

concommand.Add("sb_votemap", function(ply, cmd, args)
	if ( !VOTEMAP_ENABLED ) then
		ply:ChatPrint("[SERVERBASE] The votemap system feature has been disabled!")
		return 
	end
	local frame = vgui.Create("DFrame")
	frame:SetSize(1000 * scale, 500 * scale)
	frame:Center()
	frame:SetSkin("ServerBase")
	frame:ShowCloseButton(false)
	frame:MakePopup(true)
	
	local icon = vgui.Create("DImage", frame)
	icon:SetImage("icon16/building.png")
	icon:SetSize(16, 16)
	icon:SetPos(5 * scale, 5 * scale)
	
	local label = vgui.Create("DLabel", frame)
	label:SetFont("AFont")
	label:SetTextColor(Color(255, 255, 255, 255))
	label:SetText("Votemap - Vote for the next map!")
	label:SetSize(350, 20)
	label:SetPos(25 * scale, 3 * scale)
	
	local close = vgui.Create("DButton", frame)
	close:SetFont("AFont")
	close:SetText("X")
	close:SetSize(30 * scale, 25 * scale)
	close:SetPos(970 * scale, 0)
	close.Paint = function()
		local w, h = close:GetSize()
		
		close:SetTextColor(Color(255, 255, 255, 255))
		if ( close.Depressed ) then
			return draw.RoundedBox(-1, 0, 0, w, h, Color(200, 200, 200, 255))
		end
		
		if ( close.Hovered ) then
			return draw.RoundedBox(-1, 0, 0, w, h, Color(255, 0, 0, 255))
		end
		
		if ( close:GetDisabled() ) then
			return draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0, 0, 200))
		end
		draw.RoundedBox(-1, 0, 0, w, h, Color(150, 0, 0, 255))
	end
	close.DoClick = function()
		frame:Close()
	end
end)
	