local SKIN = {}
 
function SKIN:PaintFrame(panel)
		local w, h = panel:GetSize()
		
		draw.RoundedBox(-1, 0, 0, w, h, Color(0, 0, 0, 200))
		panel:SetTitle("")
		surface.SetDrawColor(Color(0, 0, 0, 200))
		draw.RoundedBox(-1, 0, 0, w, 25, Color(0, 75, 75, 255 ))
		surface.DrawOutlinedRect(0, 0, w, h)
end
	
function SKIN:PaintPanel(panel)
	local w, h = panel:GetSize()
	
	draw.RoundedBox(-1, 0, 0, w, h, Color(220, 220, 220 , 255))
	surface.SetDrawColor(Color(0, 0, 0, 200))
	surface.DrawOutlinedRect(0, 0, w, h)
end

function SKIN:PaintListView(panel)
	local w, h = panel:GetSize()
		
	draw.RoundedBox(-1, 0, 0, w, h, Color(200, 200, 200, 250))
	surface.SetDrawColor(Color(0, 0, 0, 200))
	surface.DrawOutlinedRect(0, 0, w, h)
end
	
function SKIN:PaintListViewLine(panel)
	local w, h = panel:GetSize()
	
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
end

function SKIN:PaintButton(panel)
	local w, h = panel:GetSize()
	
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
	draw.RoundedBox(-1, 0, 0, w, h, Color(0, 75, 75, 255))
end

function SKIN:PaintWindowMinimizeButton(panel)
	return false
end

function SKIN:PaintWindowMaximizeButton(panel)
	return false
end
	
derma.DefineSkin("ServerBase", "Admin derma by Doubleedge.", SKIN, "Default")
