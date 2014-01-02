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
	
	if ( string.sub(text, 1, 8) == "/servers" or string.sub(text, 1, 7) == "/portal" ) then
		ply:ConCommand("sb_portal")
		return ""
	end
	
	if ( string.sub(text, 1, 4) == "/log" ) then
		ply:ChatPrint("The current log is: " ..tostring(os.date("%m_%d_%y")).."_"..GetConVarString("ip"):Replace(".", "_").."/log"..NUM_OF_FILES..".txt")
		return ""
	end
	
	if ( string.sub(text, 1, 8) == "/votemap" ) then
		ply:ConCommand("sb_votemap")
		return ""
	end
	
	if ( string.sub(text, 1, 6) == "/rules" ) then
		ply:ConCommand("sb_rules")
		return ""
	end
end)

hook.Add("PlayerSay", "adminchat", function(ply, text, public)
	if ( string.sub(text, 1, 3) == "@@@" ) then
		PrintMessage(HUD_PRINTCENTER, "[MESSAGE] " ..string.sub(text, 4))
		return ""
	end
	if ( string.sub(text, 1, 2) == "@@" ) then
		PrintMessage(HUD_PRINTTALK, "[MESSAGE] " ..string.sub(text, 3))
		return ""
	end
	if ( string.sub(text, 1, 1) == "@" ) then
		for k, v in pairs (player.GetAll()) do
			if ( v:IsAdmin() ) then
				v:ChatPrint("[ADMIN] " ..ply:Nick()..": " ..string.sub(text, 2))
			end
		end
		return ""
	end
end)