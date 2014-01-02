surface.CreateFont("AFont", {
	font 		= "Verdana",
	size 		= 14,  
	weight		= 800
})
	 
surface.CreateFont("AFontSmall", {
	font 		= "Verdana",
	size		= 14,
	weight		= 800
})
	
surface.CreateFont("Section", {
	font 		= "Verdana",
	size 		= 22,
	weight      = 800
})

local BansReceived = {}
net.Receive("sendbans", function()
	BansReceived = net.ReadTable()
end)


	
local function EditSuspension(steamid, name, suspension)
	if ( !LocalPlayer():IsAdmin() ) then return end
	local ID = string.Replace(steamid, ":", "_")
	local Nick = name
	local bantypee = string.lower(suspension)
	if ( file.Exists("sbbans/"..bantypee.."s/"..ID..".txt", "DATA") ) then
		local fileopen = file.Read("sbbans/"..bantypee.."s/"..ID..".txt")
		local JSON = util.JSONToTable(fileopen)
		local frameedit = vgui.Create("DFrame")
		frameedit:SetSkin("ServerBase")
		frameedit:SetSize(500, 150)
		frameedit:Center()
		frameedit:SetVisible(true)
		frameedit:MakePopup(true)
		frameedit:ShowCloseButton(false)
		
		local titleicon = vgui.Create("DImage", frameedit)
		titleicon:SetImage("icon16/user_edit.png")
		titleicon:SetSize(16, 16)
		titleicon:SetPos(5, 5)
		
		local title = vgui.Create("DLabel", frameedit)
		title:SetFont("AFont")
		title:SetTextColor(Color(255, 255, 255, 255))
		title:SetText("Editing suspension for " ..name)
		title:SetSize(300, 20)
		title:SetPos(25, 3)
		
		local close = vgui.Create("DButton", frameedit)
		close:SetFont("AFont")
		close:SetSize(30, 25)
		close:SetPos(470, 0)
		close:SetText("X")
		close:SetTextColor(Color(255, 255, 255, 255))
		close.Paint = function()
			local w, h = close:GetSize()
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
			frameedit:Close()
		end
		
		local newlength = vgui.Create("DTextEntry", frameedit)
		newlength:SetSize(100, 20)
		newlength:SetPos(20, 70)
		
		local newtime = vgui.Create("DLabel", frameedit)
		newtime:SetFont("AFont")
		newtime:SetTextColor(Color(255, 255, 255, 255))
		newtime:SetText("Time in minutes")
		newtime:SetSize(270, 20)
		newtime:SetPos(20, 40)
		
		local newreason = vgui.Create("DTextEntry", frameedit)
		newreason:SetSize(100, 20)
		newreason:SetPos(200, 70)
		
		local reason = vgui.Create("DLabel", frameedit)
		reason:SetFont("AFont")
		reason:SetTextColor(Color(255, 255, 255, 255))
		reason:SetText("Reason")
		reason:SetSize(100, 20)
		reason:SetPos(225, 40)
		
		local bantype = vgui.Create("DComboBox", frameedit)
		bantype:SetSize(100, 20)
		bantype:SetPos(370, 70)
		bantype:AddChoice("BAN")
		bantype:AddChoice("MUTE")
		bantype:AddChoice("VOICEMUTE")
		
		local bantypes = vgui.Create("DLabel", frameedit)
		bantypes:SetFont("AFont")
		bantypes:SetTextColor(Color(255, 255, 255, 255))
		bantypes:SetText("Type")
		bantypes:SetPos(400, 40)
		bantypes:SetSize(50, 20)
		
		local banfile = file.Read("sbbans/"..ID..".txt")
		
		local changesus = vgui.Create("DButton", frameedit)
		changesus:SetSize(100, 20)
		changesus:SetText("GO")
		changesus:SetPos(200, 110)
		changesus.DoClick = function()
			JSON[3] = tostring(tonumber(newlength:GetValue() * 60 + os.time()))
			JSON[4] = tostring(newreason:GetValue())
			JSON[6] = tostring(bantype:GetValue())
			
			local finaltable = {JSON[1], JSON[2], JSON[3], JSON[4], JSON[5], JSON[6]}
			net.Start("modifysuspension")
				net.WriteTable(JSON)
				net.WriteString(suspension)
				net.WriteString(ID)
			net.SendToServer()
			frameedit:Close()	
			LocalPlayer():ConCommand("sb_suspensions")
		end
	end
end
	
concommand.Add("sb_suspensions", function(ply, cmd, args)
	if ( !ply:IsAdmin() ) then return end
	net.Start("requestthebans")
	net.SendToServer()
	
	timer.Simple(0.1, function() -- Since because need to receive the information from net messages
	local frame = vgui.Create("DFrame")
	frame:SetSkin("ServerBase")
	frame:SetSize(810, 500)
	frame:SetPos(ScrW() / 4, ScrH() / 4)
	frame:SetVisible(true)
	frame:MakePopup(true)
	frame:ShowCloseButton(false)	
	
	local titleicon = vgui.Create("DImage", frame)
	titleicon:SetImage("icon16/table_edit.png")
	titleicon:SetSize(16, 16)
	titleicon:SetPos(5, 5)
	
	local title = vgui.Create("DLabel", frame)
	title:SetFont("AFont")
	title:SetTextColor(Color(255, 255, 255, 255))
	title:SetText("Suspensions Management - Edit, Remove or Add suspensions!")
	title:SetSize(500, 20)
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
	
	local adminmenu = vgui.Create("DButton", frame)
	adminmenu:SetFont("AFont")
	adminmenu:SetSize(100, 25)
	adminmenu:SetPos(680, 0)
	adminmenu:SetText("Admin Panel")
	adminmenu:SetTooltip("Click here to go to the administration panel")
	adminmenu:SetTextColor(Color(255, 255, 255, 255))
	adminmenu.Paint = function()
		function SKIN:PaintTooltip(panel)
			local w, h = panel:GetSize()
		
			draw.RoundedBox(-1, 0, 0, w, h, Color(255, 255, 255, 255))
			surface.SetDrawColor(Color(0, 0, 0, 255))
			surface.DrawOutlinedRect(0, 0, w, h)
		end
		
		local w, h = adminmenu:GetSize()
		
		if ( adminmenu.Depressed ) then
			return draw.RoundedBox(-1, 0, 0, w, h, Color(200, 200, 200, 255))
		end
		
		if ( adminmenu.Hovered ) then
			return draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0, 255, 255))
		end
		
		if ( adminmenu:GetDisabled() ) then
			return draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0, 0, 255))
		end
		draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0, 150, 255))
	end
	adminmenu.DoClick = function()
		frame:Close()
		LocalPlayer():ConCommand("sb_admin")
	end
	
	local banpanel = vgui.Create("DListView", frame)
	banpanel:SetSize(780, 350)
	banpanel:SetPos(15,35)
	banpanel:AddColumn("Name")
	banpanel:AddColumn("SteamID")
	banpanel:AddColumn("Time")
	banpanel:AddColumn("Reason")
	banpanel:AddColumn("Admin")
	banpanel:AddColumn("Type") 
	banpanel:SortByColumn(6, true)
	banpanel.OnClickLine = function(panel, line, selected)
			local ModifyMenu = DermaMenu()
			ModifyMenu:SetPos(gui.MousePos())
			ModifyMenu:AddOption("Edit Suspension", function() EditSuspension(line:GetValue(2), line:GetValue(1), line:GetValue(6)) frame:Close() end):SetImage("icon16/user_edit.png")
			ModifyMenu:AddOption("Remove Suspension", function() line:Remove() 
				net.Start("removesuspension")
					net.WriteString(line:GetValue(2))
					net.WriteString(line:GetValue(6))
				net.SendToServer()
			end):SetImage("icon16/user_delete.png")
			ModifyMenu:Open()
		end
		
	local count = 1 --Because I'm a lazy fuck.
	for k, v in pairs (BansReceived) do
		local tbl = BansReceived
		if ( tonumber(tbl[count][3]) >= 2303477600 ) then
			banpanel:AddLine(tbl[count][1], tbl[count][2], "Permanent", tbl[count][4], tbl[count][5], tbl[count][6])
		else
			banpanel:AddLine(tbl[count][1], tbl[count][2], string.ConvertTimeStamp(tostring(tonumber(tbl[count][3] - os.time()))), tbl[count][4], tbl[count][5], tbl[count][6])
		end
		count = count + 1
	end
	
	local banicon = vgui.Create("DButton", frame)
	banicon:SetText("+")
	banicon:SetFont("AFont")
	banicon:SetDisabled(true)
	banicon:SetSize(16,16)
	banicon:SetPos(15, 390)
	
	local bantext = vgui.Create("DLabel", frame)
	bantext:SetFont("AFont")
	bantext:SetSize(200, 20)
	bantext:SetTextColor(Color(255, 255, 255, 255))
	bantext:SetText("Add a suspension below!")
	bantext:SetPos(35, 388)
	
	local banpanel = vgui.Create("DPanel", frame)
	banpanel:SetSize(780, 75)
	banpanel:SetPos(15, 410)
	
	local bannick = vgui.Create("DLabel", banpanel)
	bannick:SetFont("AFont")
	bannick:SetSize(100, 20)
	bannick:SetTextColor(Color(0, 0, 0, 255))
	bannick:SetText("Name")
	bannick:SetPos(35, 5)
	
	local addbantextname = vgui.Create("DTextEntry", banpanel)
	addbantextname:SetSize(100, 20)
	addbantextname:SetPos(10, 30)
	addbantextname:SetText("Player")
	
	local bansteamid = vgui.Create("DLabel", banpanel)
	bansteamid:SetFont("AFont")
	bansteamid:SetSize(100, 20)
	bansteamid:SetTextColor(Color(0, 0, 0, 255))
	bansteamid:SetText("SteamID")
	bansteamid:SetPos(140, 5)
	
	local bansteamidtext = vgui.Create("DTextEntry", banpanel)
	bansteamidtext:SetSize(100, 20)
	bansteamidtext:SetPos(120, 30)
	bansteamidtext:SetText("STEAM_X:X:XXXXXXX")
	
	local banduration = vgui.Create("DLabel", banpanel)
	banduration:SetFont("AFont")
	banduration:SetSize(100, 20)
	banduration:SetTextColor(Color(0, 0, 0, 255))
	banduration:SetText("Time(mins)")
	banduration:SetPos(240, 5)
	
	local bandurationtext = vgui.Create("DTextEntry", banpanel)
	bandurationtext:SetSize(100, 20)
	bandurationtext:SetPos(230, 30)
	bandurationtext:SetText("100")
	
	local banreason = vgui.Create("DLabel", banpanel)
	banreason:SetFont("AFont")
	banreason:SetSize(100, 20)
	banreason:SetTextColor(Color(0, 0, 0, 255))
	banreason:SetText("Reason")
	banreason:SetPos(365, 5)
	
	local banreasontext = vgui.Create("DTextEntry", banpanel)
	banreasontext:SetSize(100, 20)
	banreasontext:SetPos(340, 30)
	
	local bantype = vgui.Create("DLabel", banpanel)
	bantype:SetFont("AFont")
	bantype:SetSize(100, 20)
	bantype:SetTextColor(Color(0, 0, 0, 255))
	bantype:SetText("Type") 
	bantype:SetPos(490, 5)
	
	local bantypedrop = vgui.Create("DComboBox", banpanel)
	bantypedrop:SetSize(100, 20)
	bantypedrop:SetPos(460, 30)
	bantypedrop:AddChoice("BAN")
	bantypedrop:AddChoice("MUTE")
	bantypedrop:AddChoice("VOICEMUTE")
	bantypedrop:ChooseOption("MUTE")
	
	local banbutton = vgui.Create("DButton", banpanel)
	banbutton:SetSize(100, 20)
	banbutton:SetPos(620, 30)
	banbutton:SetText("Add Suspension")
	banbutton.DoClick = function()
		local bantable = {addbantextname:GetValue(), bansteamidtext:GetValue(), tostring(tonumber((os.time()) + (bandurationtext:GetValue() * 60))), banreasontext:GetValue(), LocalPlayer():Nick(), bantypedrop:GetValue()} 
		net.Start("addban")
			net.WriteTable(bantable)
			net.WriteString(bansteamidtext:GetValue())
			net.WriteString(bantypedrop:GetValue())
		net.SendToServer()
		frame:Close()	
		LocalPlayer():ConCommand("sb_suspensions")
	end
	
	end)
end)
