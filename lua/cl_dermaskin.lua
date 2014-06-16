local SKIN = {}
function SKIN:PaintFrame(panel, w, h)
	draw.RoundedBox(-1, 0, 0, w, h, Color(35, 55, 70, 255))
	panel:SetTitle("")
	draw.RoundedBox(-1, 0, 0, w, 25, Color(0, 100, 150, 255 ))
	surface.SetDrawColor(Color(0, 0, 0, 200))
	surface.DrawOutlinedRect(0, 0, w, h)
		
		draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0, 0, 200))
		panel:SetTitle("")
		draw.RoundedBox(-1, 0, 0, w, 25, Color(0, 100, 150, 255 ))
		surface.SetDrawColor(Color(0, 0, 0, 200))
		surface.DrawOutlinedRect(0, 0, w, h)
end

	
function SKIN:PaintPanel(panel, w, h)
	draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0,0 , 200))
	surface.SetDrawColor(Color(0, 0, 0, 200))
	surface.DrawOutlinedRect(0, 0, w, h)
end

function SKIN:PaintListView(panel, w, h)
	draw.RoundedBox(-1, 0, 0, w, h, Color(2, 2, 2, 200))
	surface.SetDrawColor(Color(0, 0, 0, 200))
	surface.DrawOutlinedRect(0, 0, w, h)
end
	
function SKIN:PaintListViewLine(panel, w, h)
	
	if ( panel.Depressed || panel.m_bSelected ) then
		return draw.RoundedBox(-1, 0, 0, w, h, Color(250, 0, 0, 255))
	end
	
	if ( panel.Hovered ) then
		return draw.RoundedBox(-1, 0, 0, w, h, Color(150, 0, 0, 200))
	end
	
	if ( panel.m_bAlt ) then 
		return draw.RoundedBox(-1, 0, 0, w, h, Color(150, 150, 150, 200))
	end
	draw.RoundedBox(-1, 0, 0, w, h, Color(200, 200, 200, 200))
	surface.SetDrawColor(Color(0, 0, 0, 200))
	surface.DrawOutlinedRect(0, 0, w, h)
end

function SKIN:PaintPropertySheet(panel, w, h)
	draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0, 0, 200))
end

function SKIN:PaintToolTip(panel, w, h)
	panel:SetTextColor(Color(255, 255, 255, 255))
	return draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0, 0, 200))
end

function SKIN:PaintButton(panel, w, h)
	panel:SetTextColor(Color(255, 255, 255, 255))
	if ( panel.Depressed ) then
		return draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0, 0, 255))
	end
	
	if ( panel.Hovered ) then
		return draw.RoundedBox(-1, 0, 0, w, h, Color(50, 50, 50, 255))
	end
	
	
	if ( panel:GetDisabled() ) then
		return draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0, 0, 200))
	end
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawOutlinedRect(0, 0, w, h)
	draw.RoundedBox(-1, 0, 0, w, h, Color(0, 100, 150, 255))
end

function SKIN:PaintWindowMinimizeButton(panel)
	return false
end

function SKIN:PaintWindowMaximizeButton(panel)
	return false
end

derma.DefineSkin("ServerBase", "Admin derma by Doubleedge.", SKIN, "Default")

