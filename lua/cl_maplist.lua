concommand.Add("sb_votemap", function(ply, cmd, args) 
	local scale = math.Clamp(ScrH() / 1080, 0.6, 1)
	local frame = vgui.Create("DFrame")
	frame:SetSize(1000 * scale, 600 * scale)
	frame:Center()
	frame:SetSkin("ServerBase")
	frame:MakePopup(true)
	frame:ShowCloseButton(false)
	
	local maplistpanel = vgui.Create("DPanelList", frame)
	maplistpanel:SetSize(1000 * scale, 600 * scale)
	maplistpanel:EnableVerticalScrollbar(true)
	maplistpanel:SetSpacing(5)
	maplistpanel:SetPos(1, 45)
	maplistpanel.Paint = function()
		local w, h = maplistpanel:GetSize()
		
		return draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0, 0, 100))
	end
	
	local icon = vgui.Create("DImage", frame)
	icon:SetImage("icon16/table.png")
	icon:SetSize(16, 16)
	icon:SetPos(5, 5)
	
	local label = vgui.Create("DLabel", frame)
	label:SetFont("AFont")
	label:SetTextColor(Color(255, 255, 255, 255))
	label:SetText("Votemap - Vote for the next map!")
	label:SetSize(400, 20)
	label:SetPos(25, 3)
	
	local closebutton = vgui.Create("DButton", frame)
	closebutton:SetSize(30, 25)
	closebutton:SetPos(970 * scale, 0)
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

	net.Start("sendmaps")
	net.SendToServer()
	
	net.Receive("sentmaps", function()
		local Maps = net.ReadTable()
		local plvotes = net.ReadTable()
		
	for k, maps in pairs (Maps) do
		local button = vgui.Create("DButton", maplistpanel)
		button:SetText(Maps[k]["mapname"].. " (" ..Maps[k]["votes"]..")")
		button:SetTooltip(Maps[k]["desc"])
		button:SetPos(20, 25 * k)
		button:SetSize(970 * scale, 20)
		button.DoClick = function()
		if ( table.HasValue(plvotes, LocalPlayer():SteamID()) ) then
			chat.AddText(LocalPlayer, COLOR_TAG, "[SB] ", COLOR_TEXT, "You've already casted your vote!")
			return
		end
		Maps[k]["votes"] = Maps[k]["votes"] + 1
		table.insert(plvotes, LocalPlayer():SteamID())
		chat.AddText(player.GetAll(), COLOR_TAG, "[SB] ", COLOR_ADMIN, LocalPlayer():Nick(), COLOR_TEXT, " has placed ", COLOR_ADMIN, "1 vote ", COLOR_TEXT, " for ", COLOR_TEXT, Maps[k]["mapname"])
			net.Start("receivevotes")
				net.WriteTable(Maps)
				net.WriteTable(plvotes)
			net.SendToServer()
			frame:Close()
			timer.Simple(0.2, function()
				LocalPlayer():ConCommand("sb_votemap")
			end)
		end
	end
	end)
end)
