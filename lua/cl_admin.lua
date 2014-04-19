surface.CreateFont("AFont", {
	font 		= "Verdana",
	size 		= 14,
	weight		= 800
})   
	
surface.CreateFont("AFontSmall", {
	font 		= "Verdana",
	size		= 10,
	weight		= 800
})
	
surface.CreateFont("Section", {
	font 		= "Verdana",
	size 		= 22,
	weight      = 800
})

hook.Add("OnPlayerChat", "PlayerChattingggg", function(ply, text, teamonly, dead)
	local tab = {}
	if ( dead ) then
		table.insert( tab, Color(255, 2, 2) ) 
		table.insert( tab, "(DEAD)" )
	end
	
	if ( teamonly ) then
		table.insert( tab, Color(2, 255, 2) )
		table.insert( tab, "(TEAM)" )
	end
	
	
	if 	( IsValid(ply) ) then
		if ( ply:IsSuperAdmin() ) then
			table.insert( tab, COLOR_SUPER )
			table.insert( tab, "(Super Admin) ")
		elseif ( ply:IsAdmin() ) then
			table.insert( tab, COLOR_ADMIN )
			table.insert( tab, "(Admin) ")
		end
		table.insert( tab, team.GetColor(ply:Team()) )
		table.insert( tab, ply:GetName() )
	else
		table.insert( tab, "Console" )
	end
	
	table.insert(tab, Color(255, 255, 255))
	table.insert(tab, ": " ..text)
	
	chat.AddText(unpack(tab))
	
	return true
end)
	
concommand.Add("sb_admin", function(ply, cmd, args)
	if ( !ply:IsAdmin() ) then return end
	setdata = setdata or 1
	local frame = vgui.Create("DFrame")
	frame:SetSkin("ServerBase")
	frame:SetSize(810, 500)
	frame:SetPos(ScrW() / 4, ScrH() / 4)
	frame:SetVisible(true)
	frame:MakePopup(true)
	frame:ShowCloseButton(false)	
	
	local titleicon = vgui.Create("DImage", frame)
	titleicon:SetImage("icon16/server.png")
	titleicon:SetSize(16, 16)
	titleicon:SetPos(5, 5)
	
	local title = vgui.Create("DLabel", frame)
	title:SetFont("AFont")
	title:SetTextColor(Color(255, 255, 255, 255))
	title:SetText("Admin Panel - A simple administration panel")
	title:SetSize(400, 20)
	title:SetPos(25, 3)
	
	local close = vgui.Create("DButton", frame)
	close:SetFont("AFont")
	close:SetText("X")
	close:SetSize(30,25)
	close:SetPos(780, 0)
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
	
	local suspensions = vgui.Create("DButton", frame)
	suspensions:SetFont("AFont")
	suspensions:SetSize(100, 25)
	suspensions:SetPos(680, 0)
	suspensions:SetText("Suspensions")
	suspensions:SetTooltip("Click here to go to the suspensions list")
	suspensions:SetTextColor(Color(255, 255, 255, 255))
	suspensions.Paint = function()
		function SKIN:PaintTooltip(panel)
			local w, h = panel:GetSize()
		
			draw.RoundedBox(-1, 0, 0, w, h, Color(255, 255, 255, 255))
			surface.SetDrawColor(Color(0, 0, 0, 255))
			surface.DrawOutlinedRect(0, 0, w, h)
		end
		
		local w, h = suspensions:GetSize()
		
		if ( suspensions.Depressed ) then
			return draw.RoundedBox(-1, 0, 0, w, h, Color(200, 200, 200, 255))
		end
		
		if ( suspensions.Hovered ) then
			return draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0, 255, 255))
		end
		
		if ( suspensions:GetDisabled() ) then
			return draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0, 0, 255))
		end
		draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0, 150, 255))
	end
	suspensions.DoClick = function()
		frame:Close()
		LocalPlayer():ConCommand("sb_suspensions")
	end
	
	local playerlist = vgui.Create("DListView", frame)
	playerlist:SetSize(200, 445)
	playerlist:SetPos(10, 40)
	playerlist:AddColumn("Player")
	for k, v in pairs (player.GetAll()) do
		playerlist:AddLine(v:Nick(), v:UserID())
	end
	playerlist.OnClickLine = function(panel, line, selected)
		setdata = line:GetValue(2)
	end
	
	local banpanel = vgui.Create("DPanel", frame)
	banpanel:SetSize(380, 105)
	banpanel:SetPos(320, 45)
	
	local banreasonentry = vgui.Create("DTextEntry", banpanel)
	banreasonentry:SetSize(100, 20)
	banreasonentry:SetPos(20, 45)
	banreasonentry:SetText("No Reason Specified")
	
	local banreason = vgui.Create("DLabel", banpanel)
	banreason:SetSize(100, 20)
	banreason:SetPos(45, 20)
	banreason:SetFont("AFont")
	banreason:SetTextColor(Color(0, 0, 0, 255))
	banreason:SetText("Reason")
	
	local bandurationentry = vgui.Create("DTextEntry", banpanel)
	bandurationentry:SetSize(100, 20)
	bandurationentry:SetPos(145, 45)
	bandurationentry:SetText(200)
	
	local banduration = vgui.Create("DLabel", banpanel)
	banduration:SetSize(100, 20)
	banduration:SetPos(165, 20)
	banduration:SetFont("AFont")
	banduration:SetTextColor(Color(0, 0, 0, 255))
	banduration:SetText("Duration")
	
	local banbutton = vgui.Create("DButton", banpanel)
	banbutton:SetSize(100, 20)
	banbutton:SetPos(265, 45)
	banbutton:SetText("Ban Player")
	banbutton.DoClick = function()
		RunConsoleCommand("sb_ban", setdata, bandurationentry:GetValue(), banreasonentry:GetValue())
		frame:Close()
		timer.Simple(0.6, function() 
			LocalPlayer():ConCommand("admin")
		end)
	end
	
	local mutepanel = vgui.Create("DPanel", frame)
	mutepanel:SetSize(380, 105)	
	mutepanel:SetPos(320, 155)
	
	local mutereasonentry = vgui.Create("DTextEntry", mutepanel)
	mutereasonentry:SetSize(100, 20)
	mutereasonentry:SetPos(20, 45)
	mutereasonentry:SetText("No Reason Specified")
	
	local mutereason = vgui.Create("DLabel", mutepanel)
	mutereason:SetSize(100, 20)
	mutereason:SetPos(45, 20)
	mutereason:SetFont("AFont")
	mutereason:SetTextColor(Color(0, 0, 0, 255))
	mutereason:SetText("Reason")
	
	local mutedurationentry = vgui.Create("DTextEntry", mutepanel)
	mutedurationentry:SetSize(100, 20)
	mutedurationentry:SetPos(145, 45)
	mutedurationentry:SetText(200)
	
	local muteduration = vgui.Create("DLabel", mutepanel)
	muteduration:SetSize(100, 20)
	muteduration:SetPos(165, 20)
	muteduration:SetFont("AFont")
	muteduration:SetTextColor(Color(0, 0, 0, 255))
	muteduration:SetText("Duration")
	
	local mutebutton = vgui.Create("DButton", mutepanel)
	mutebutton:SetSize(100, 20)
	mutebutton:SetPos(265, 45)
	mutebutton:SetText("Mute Player")
	mutebutton.DoClick = function()
		RunConsoleCommand("sb_mute", setdata, mutedurationentry:GetValue(), mutereasonentry:GetValue())
	end
	
	local voicemutepanel = vgui.Create("DPanel", frame)
	voicemutepanel:SetSize(380, 105)
	voicemutepanel:SetPos(320, 265)	

	local voicemutereasonentry = vgui.Create("DTextEntry", voicemutepanel)
	voicemutereasonentry:SetSize(100, 20)
	voicemutereasonentry:SetPos(20, 45)
	voicemutereasonentry:SetText("No Reason Specified")
	
	local voicemutereason = vgui.Create("DLabel", voicemutepanel)
	voicemutereason:SetSize(100, 20)
	voicemutereason:SetPos(45, 20)
	voicemutereason:SetFont("AFont")
	voicemutereason:SetTextColor(Color(0, 0, 0, 255))
	voicemutereason:SetText("Reason")
	
	local voicemutedurationentry = vgui.Create("DTextEntry", voicemutepanel)
	voicemutedurationentry:SetSize(100, 20)
	voicemutedurationentry:SetPos(145, 45)
	voicemutedurationentry:SetText(200)
	
	local voicemuteduration = vgui.Create("DLabel", voicemutepanel)
	voicemuteduration:SetSize(100, 20)
	voicemuteduration:SetPos(165, 20)
	voicemuteduration:SetFont("AFont")
	voicemuteduration:SetTextColor(Color(0, 0, 0, 255))
	voicemuteduration:SetText("Duration")
	
	local voicemutebutton = vgui.Create("DButton", voicemutepanel)
	voicemutebutton:SetSize(100, 20)
	voicemutebutton:SetPos(265, 45)
	voicemutebutton:SetText("Voicemute Player")
	voicemutebutton.DoClick = function()
		RunConsoleCommand("sb_voicemute", setdata, voicemutedurationentry:GetValue(), voicemutereasonentry:GetValue())
	end
	
	local miscbuttons = vgui.Create("DPanel", frame)
	miscbuttons:SetSize(380, 105)
	miscbuttons:SetPos(320, 375)
	
	local kickentry = vgui.Create("DTextEntry", miscbuttons)
	kickentry:SetSize(100, 20)
	kickentry:SetText("Reason")
	kickentry:SetPos(20, 25)
	
	local kickbutton = vgui.Create("DButton", miscbuttons)
	kickbutton:SetSize(100, 20)
	kickbutton:SetText("Kick Player")
	kickbutton:SetPos(20, 55)
	kickbutton.DoClick = function()
		RunConsoleCommand("sb_kick", "" ..setdata.. "", kickentry:GetValue())
		frame:Close()
		timer.Simple(0.3, function()
			LocalPlayer():ConCommand("admin")
		end)
	end
	
	local slaybutton = vgui.Create("DButton", miscbuttons)
	slaybutton:SetSize(100, 20)
	slaybutton:SetText("Slay Player")
	slaybutton:SetPos(140, 55)
	slaybutton.DoClick = function()
		RunConsoleCommand("sb_slay", "" ..setdata.. "")
	end
	
	local teleporttome = vgui.Create("DButton", miscbuttons)
	teleporttome:SetSize(100, 20)
	teleporttome:SetText("Teleport To Me")
	teleporttome:SetPos(140, 25)
	teleporttome.DoClick = function()
		RunConsoleCommand("sb_teleporttome", setdata)
	end
	
	local teleporttothem = vgui.Create("DButton", miscbuttons)
	teleporttothem:SetSize(100, 20)
	teleporttothem:SetText("Teleport To Them")
	teleporttothem:SetPos(260, 25)
	teleporttothem.DoClick = function()
		RunConsoleCommand("sb_teleporttothem", setdata)
	end

	
end)

