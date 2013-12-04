hook.Add("PlayerSay", "Commands", function(ply, text, public)
	if ( string.sub(text, 1, 6) == "/admin" ) then
		if ( ply:IsAdmin() ) then
			ply:ConCommand("sb_admin")
			return ""
		end
	end
	
	if ( string.sub(text, 1, 5) == "/bans" ) then
		if ( ply:IsAdmin() ) then
			ply:ConCommand("sb_suspensions")
			return ""
		end
	end
	
	if ( string.sub(text, 1, 5) == "/shop" ) then
		ply:ConCommand("sb_shop")
		return ""
	end
	
	if ( string.sub(text, 1, 8) == "/servers" or string.sub(text, 1, 7) == "/portal" ) then
		ply:ConCommand("sb_portal")
		return ""
	end
end)
