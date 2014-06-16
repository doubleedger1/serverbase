local coins = coins or 0
local memberlevel = memberlevel or "Normal Member"

net.Receive("sendinfo", function(len)
	local actualcoins = net.ReadUInt(16)
	local actualmember = net.ReadString()
	coins = actualcoins
	memberlevel = actualmember
end)

net.Receive("updateinfo", function(len)
	local actualcoins = net.ReadUInt(16)
	coins = actualcoins
end)

hook.Add("HUDPaint", "DrawAccountBox", function()   
	local scale = math.Clamp(ScrH() / 1080, 1, 0.6)
	local rank = rank
	local rankcol = rankcol
	if ( LocalPlayer():IsSuperAdmin() ) then
		rank = "Super Admin"
		rankcol = Color(0, 100, 150, 255)
	end
	if ( LocalPlayer():IsAdmin() ) then
		rank = "Admin"
		rankcol = Color(0, 255, 0, 255)
	end
	if ( !LocalPlayer():IsAdmin() and !LocalPlayer():IsSuperAdmin() ) then
		rank = "Player"
	end
	draw.RoundedBox(-1, 1, 200 * scale, 150 * scale, 100 * scale, Color(15, 35, 45, 255))
	draw.RoundedBox(-1, 1, 200 * scale, 150 * scale, 25 * scale, Color(0, 100, 150, 220))
	draw.SimpleTextOutlined("Coins: "..coins, "AFont", 10 * scale, 240 * scale, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, 1, 1, Color(0, 0, 0, 200))
	draw.SimpleTextOutlined(memberlevel, "AFont", 10 * scale, 260 * scale, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, 1, 1, Color(0, 0, 0, 200))      
	surface.SetDrawColor(Color(35,35,50,255))
	surface.DrawOutlinedRect(0, 200 * scale, 150 * scale + 2, 100 * scale)
	draw.DrawText("Account Info", "AFont", 75, 205 * scale, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
end)

concommand.Add("sb_shop", function(ply, cmd, args)
	local frame = vgui.Create("DFrame")
	frame:SetSize(810, 500)
	frame:SetPos(ScrW() / 4, ScrH() / 4)
	frame:SetSkin("ServerBase")
	frame:ShowCloseButton(false)
	frame:MakePopup(true)
	
	local titleicon = vgui.Create("DImage", frame)
	titleicon:SetImage("icon16/cart.png")
	titleicon:SetSize(16, 16)
	titleicon:SetPos(5, 5)
	
	local title = vgui.Create("DLabel", frame)
	title:SetFont("AFont")
	title:SetTextColor(Color(255, 255, 255, 255))
	title:SetText("Shop - Customize your player!")
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
	
end)
