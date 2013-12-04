concommand.Add("sb_shop", function(ply, cmd, args) 
	local shopframe = vgui.Create("DFrame")
	shopframe:SetSize(800, 600)
	shopframe:SetSkin("ServerBase")
	shopframe:SetPos(ScrW() / 4, ScrH() / 4)
	shopframe:MakePopup(true)
	shopframe:ShowCloseButton(false)
	
	local titleicon = vgui.Create("DImage", shopframe)
	titleicon:SetSize(16, 16)
	titleicon:SetPos(5, 5)
	titleicon:SetImage("icon16/basket.png")
	
	local title = vgui.Create("DLabel", shopframe)
	title:SetSize(300, 20)
	title:SetFont("AFont")
	title:SetPos(25, 4)
	title:SetTextColor(Color(255, 255, 255, 255))
	title:SetText("Shop - Make yourself different today")
	
	local closebutton = vgui.Create("DButton", shopframe)
	closebutton:SetSize(30, 25)
	closebutton:SetPos(770, 0)
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
		shopframe:Close()
	end
end)
