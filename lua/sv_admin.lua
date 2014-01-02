util.AddNetworkString("sendbans")
util.AddNetworkString("addban") 
util.AddNetworkString("removesuspension")
util.AddNetworkString("modifysuspension")
util.AddNetworkString("requestthebans")

net.Receive("requestthebans", function()
	local tbl = {}
	local bans = file.Find("sbbans/bans/*.txt", "DATA")
	for _, v in pairs (bans) do
		local bantbl = util.JSONToTable(file.Read("sbbans/bans/" .. v, "DATA"))
		table.insert(tbl, bantbl)
	end
	
	local mutes = file.Find("sbbans/mutes/*.txt", "DATA")
	for _, v in pairs (mutes) do
		local mutetbl = util.JSONToTable(file.Read("sbbans/mutes/" .. v, "DATA"))
		table.insert(tbl, mutetbl)
	end
	
	local voicemutes = file.Find("sbbans/voicemutes/*.txt", "DATA")
	for _, v in pairs (voicemutes) do
		local voicemutetbl = util.JSONToTable(file.Read("sbbans/voicemutes/" .. v, "DATA"))
		table.insert(tbl, voicemutetbl)
	end
	
	net.Start("sendbans")
		net.WriteTable(tbl)
	net.Broadcast()
end)

hook.Add("PlayerInitialSpawn", "LoadThatStuff", function(ply)
	if (!file.IsDir("sbbans", "DATA")) then
		file.CreateDir("sbbans")
	end
	
	if (!file.IsDir("sbbans/bans", "DATA")) then
		file.CreateDir("sbbans/bans")
	end
	
	if (!file.IsDir("sbbans/mutes", "DATA")) then
		file.CreateDir("sbbans/mutes")
	end
	
	if (!file.IsDir("sbbans/voicemutes", "DATA")) then
		file.CreateDir("sbbans/voicemutes")
	end
	
	local files  = file.Find("sbbans/*.txt", "DATA")
	for k, v in pairs (files) do
		local fileopen = file.Read("sbbans/" ..v)
		local jasontable = util.JSONToTable(fileopen)
		if ( tonumber(jasontable[3]) <= os.time() ) then   
			file.Delete("sbbans/" ..v)  
		end
	end
	
	local tbl = {}
	local files = file.Find("sbbans/*.txt", "DATA")
	for _, v in pairs (files) do
		local bantbl = util.JSONToTable(file.Read("sbbans/" .. v, "DATA"))
		table.insert(tbl, bantbl)
	end

	net.Start("sendbans")
		net.WriteTable(tbl)
	net.Send(ply)

end)

hook.Add("PlayerInitialSpawn", "CheckSuspension", function(ply)
	ply.CanTalk = ply.CanTalk or true
	ply.CanType = ply.CanType or true
	local ID = string.Replace(ply:SteamID(), ":", "_")
	if ( file.Exists("sbbans/bans/"..ID..".txt", "DATA") ) then
		local banfile = file.Read("sbbans/bans/"..ID..".txt")
		local JSON = util.JSONToTable(banfile)
		if ( tonumber(JSON[3]) <= os.time() ) then
			file.Delete("sbbans/bans/"..ID..".txt")
			ply:ChatPrint("Your ban has recently expired.")
			return
		end
		if ( tonumber(JSON[3]) > os.time() ) then
			if ( tonumber(JSON[3]) >= 2303477600 ) then
				ply:Kick("You are banned: " ..tostring(JSON[4]).. " (Expires: Never.)")
				return
			end
		ply:Kick("You are banned: " ..JSON[4].. " (It expires: In " ..string.ConvertTimeStamp(JSON[3] - os.time()).. ")")
		end
	end
	
	if ( file.Exists("sbbans/voicemutes/"..ID..".txt", "DATA") ) then
		local voicemutefile = file.Read("sbbans/voicemutes/"..ID..".txt")
		local JSONVM = util.JSONToTable(banfile)
		if ( tonumber(JSONVM[3]) <= os.time() ) then
			file.Delete("sbbans/voicemutes/"..ID..".txt")
			ply:ChatPrint("Your voicemute has recently expired")
		else
			ply.Cantalk = false
			ply:ChatPrint("You are voicemuted. Reason: " ..JSONVM[4])
		end
	end
	
	if ( file.Exists("sbbans/mutes/"..ID..".txt", "DATA") ) then
		local mutefile = file.Read("sbbans/mutes/"..ID..".txt")
		local JSONM = util.JSONToTable(mutefile)
		if ( tonumber(JSONM[3]) <= os.time() ) then
			file.Delete("ssbans/mutes/"..ID..".txt")
			ply:ChatPrint("Your mute has recently expired")
		else
			ply.CanType = false
			ply:ChatPrint("You are muted. Reason: " ..JSONM[4])
		end
	end
end)
	
hook.Add("PlayerSay", "CheckIfPlayerCanTypePlusLog", function(ply, text, public)
	if ( ply.CanType == false ) then
		ply:ChatPrint("You cannot talk, you are muted.")
		return ""
	end
end)

hook.Add("PlayerCanHearPlayersVoice", "PreventVoiceMute", function(listen, talk)
	if ( talk.CanTalk == false ) then
		return false, false
	end
end)
	
concommand.Add("sb_ban", function(ply, cmd, args)
	if ( !ply:IsAdmin() ) then return end
	
	local ID = tonumber(args[1])
	local duration = tonumber(args[2] * 60)
	local reason = tostring(args[3]) or "No reason specified"
	
	if ( duration == 0 ) then
		duration = 2303477600
	end
		
	for k, v in pairs (player.GetAll()) do
		if ( v:UserID() == ID ) then
			local steamid2 = string.Replace(v:SteamID(), ":", "_")
			local bantable = {v:Nick(), v:SteamID(), tostring(os.time() + duration), reason, ply:Nick(), "BAN"}
			local jstring = util.TableToJSON(bantable)
			file.Write("sbbans/bans/" ..steamid2..".txt", jstring)
			v:Kick("You have been banned: " ..reason)
			PrintMessage( HUD_PRINTTALK, "[ServerBase] Admin " ..ply:Nick().. " has banned " ..v:Nick().. " with reason: " ..reason)
			SBLOG("[ADMIN CMD] - Admin " ..ply:Nick() .. " has BANNED " ..v:Nick().. " with reason: " ..reason)
		end
	end
end)
	
concommand.Add("sb_kick", function(ply, cmd, args)
	if ( !ply:IsAdmin() ) then return end
	
	local ID = tonumber(args[1])
	local reason = tostring(args[2]) or "No reason specified"
		
	for k, v in pairs (player.GetAll()) do
		if ( v:UserID() == ID ) then
			v:Kick(reason)
			PrintMessage( HUD_PRINTTALK, "[ServerBase] Admin " ..ply:Nick().. " has kicked " ..v:Nick().. " with reason: " ..reason)
			SBLOG("[ADMIN CMD] - Admin " ..ply:Nick() .. " has KICKED " ..v:Nick().. " with reason: " ..reason)
		end
	end
end)
	
concommand.Add("sb_slay", function(ply, cmd ,args)
	if ( !ply:IsAdmin() ) then return end
	
	local ID = tonumber(args[1])
	
	for k, v in pairs (player.GetAll()) do
		if ( v:UserID() == ID ) then
			v:Kill()
			PrintMessage( HUD_PRINTTALK, "[ServerBase] Admin " ..ply:Nick().. " has slain " ..v:Nick())
			SBLOG("[ADMIN CMD] - Admin " ..ply:Nick() .. " has SLAIN " ..v:Nick())
		end
	end
end)
	
concommand.Add("sb_mute", function(ply, cmd, args)
	if ( !ply:IsAdmin() ) then return end
	
	local ID = tonumber(args[1])
	local duration = tonumber(args[2] * 60)
	local reason = tostring(args[3]) or "No reason specified"
	if ( duration == 0 ) then
		duration = 2303477600
	end
		
	for k, v in pairs (player.GetAll()) do
		if ( v:UserID() == ID ) then
			local steamid2 = string.Replace(v:SteamID(), ":", "_")
			local bantable = {v:Nick(), v:SteamID(), tostring(os.time() + duration), reason, ply:Nick(), "MUTE"}
			local jstring = util.TableToJSON(bantable)
			file.Write("sbbans/mutes/" ..steamid2..".txt", jstring)
			v.CanType = false
			PrintMessage( HUD_PRINTTALK, "[ServerBase] Admin " ..ply:Nick().. " has muted " ..v:Nick().. " with reason: " ..reason)
			SBLOG("[ADMIN CMD] - Admin " ..ply:Nick() .. " has MUTED " ..v:Nick().. " with reason: " ..reason)
		end
	end
end)
	
concommand.Add("sb_voicemute", function(ply, cmd, args)
	if ( !ply:IsAdmin() ) then return end
	
	local ID = tonumber(args[1])
	local duration = tonumber(args[2] * 60)
	local reason = args[3] or "No reason specified"
		
	for k, v in pairs (player.GetAll()) do
		if ( v:UserID() == ID ) then
			local steamid2 = string.Replace(v:SteamID(), ":", "_")
			local bantable = {v:Nick(), v:SteamID(), tostring(os.time() + duration), reason, ply:Nick(), "VOICEMUTE"}
			local jstring = util.TableToJSON(bantable)
			file.Write("sbbans/voicemutes/" ..steamid2..".txt", jstring)
		v.CanTalk = false
		PrintMessage( HUD_PRINTTALK, "[ServerBase] Admin " ..ply:Nick().. " has voicemuted " ..v:Nick().. " with reason: " ..reason)
		SBLOG("[ADMIN CMD] - Admin " ..ply:Nick() .. " has VOICE MUTED " ..v:Nick().. " with reason: " ..reason)
		end
	end
end)

concommand.Add("sb_teleporttome", function(ply, cmd, args)
	if ( !ply:IsAdmin() ) then return end
	
	local ID = tonumber(args[1])
	
	for k ,v in pairs( player.GetAll()) do
		if ( v:UserID() == ID ) then
			v:SetPos(ply:GetPos() + Vector(0, 50, 10))
			PrintMessage( HUD_PRINTTALK, "[ServerBase] Admin " ..ply:Nick().. " teleported " ..v:Nick().. " to their position")
			SBLOG("[ADMIN CMD] - Admin " ..ply:Nick() .. " has TELEPORTED " ..v:Nick().. " TO HIS POSITION")
		end
	end
end)
	
concommand.Add("sb_teleporttothem", function(ply, cmd, args)
	if ( !ply:IsAdmin() ) then return end
	
	local ID = tonumber(args[1])
	
	for k, v in pairs (player.GetAll()) do
		if ( v:UserID() == ID ) then
			ply:SetPos(v:GetPos() + Vector(0, 50, 10))
			PrintMessage( HUD_PRINTTALK, "[ServerBase] Admin " ..ply:Nick().. " teleported to " ..v:Nick().."'s position")
			SBLOG("[ADMIN CMD] - Admin " ..ply:Nick() .. " has TELEPORTED " ..v:Nick().."'s POSITION")
		end
	end
end)

timer.Create("adsystem", ChatAdTime, 0, function()
	if ( ChatAdEnabled == true ) then
		local chatmsg = table.Random(ChatMessages)
		PrintMessage( HUD_PRINTTALK, "[INFO] " ..chatmsg )
		SBLOG("[SERVER AD] " ..chatmsg)
	end
end)

-- This removes the suspensions.
net.Receive("removesuspension", function()
	local steamid2 = string.Replace(net.ReadString(), ":", "_")
	local typee = net.ReadString()
	if ( typee == "BAN" ) then
		if ( file.Exists("sbbans/bans/" ..steamid2..".txt", "DATA") ) then
			file.Delete("sbbans/bans/" ..steamid2..".txt")
		end
	elseif ( typee == "MUTE" ) then
		if ( file.Exists("sbbans/mutes/" ..steamid2..".txt", "DATA") ) then
			file.Delete("sbbans/mutes/" ..steamid2..".txt")
		end
	elseif ( typee == "VOICEMUTE" ) then
		if ( file.Exists("sbbans/voicemutes/" ..steamid2..".txt", "DATA") ) then
			file.Delete("sbbans/voicemutes/" ..steamid2..".txt")
		end
	else
		print("something went wrong")
	end
end)

-- This modifies the suspensions.
net.Receive("modifysuspension", function()
	local value = net.ReadTable()
	local typecheck = net.ReadString()
	local json = util.TableToJSON(value)
	local ply = net.ReadString()
	file.Write("sbbans/"..string.lower(typecheck).."s/"..ply..".txt", json)
end)

-- This adds suspensions.
net.Receive("addban", function()
	local tbl = util.TableToJSON(net.ReadTable())
	local steamid = net.ReadString()
	local typecheck = net.ReadString()
	local val = string.Replace(steamid, ":", "_")
	
	if ( typecheck == "BAN" ) then
		file.Write("sbbans/bans/"..val..".txt", tbl)
	elseif ( typecheck == "MUTE" ) then
		file.Write("sbbans/mutes/"..val..".txt", tbl)
	elseif ( typecheck == "VOICEMUTE" ) then
		file.Write("sbbans/voicemutes/"..val..".txt", tbl)
	end
end)

function DisableNoclip( objPl )
	if ( objPl:IsAdmin() ) then
		local noclip = objPl:GetMoveType() == MOVETYPE_NOCLIP
		if ( noclip ) then
			PrintMessage( HUD_PRINTTALK, "[ServerBase] Admin " ..objPl:Nick().. " has disabled noclip")
			SBLOG("[ADMIN CMD - LOG] - Admin " ..objPl:Nick().. " has disabled noclip ")
		else 
			PrintMessage( HUD_PRINTTALK, "[ServerBase] Admin " ..objPl:Nick().. " has enabled noclip")
			SBLOG("[ADMIN CMD - LOG] - Admin " ..objPl:Nick().. " has enabled noclip ")
		end
	end
	return objPl:IsAdmin()
end
hook.Add("PlayerNoClip", "DisableNoclip", DisableNoclip)
