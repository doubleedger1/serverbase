------------------- 
-- Configuration --
-------------------
ChatAdTime = 180 --This will print a helpful message every number of seconds.
 
ChatAdEnabled = true --Set this to false if you don't want ChatMessages printed ever ChatAdTime seconds.

ChatMessages = {}
ChatMessages[1] = "Report a rulebreaking player on our website at www.mywebsite.com"
ChatMessages[2] = "This server is running ServerBase!"
ChatMessages[3] = "Press F1 for more information about the server or gamemode"
--Add messages by putting ChatMessages[#ascending#] = "message as a string"
--------------------------
-- End of Configuration --
--------------------------

util.AddNetworkString("sendbans")
util.AddNetworkString("addban") 
util.AddNetworkString("removesuspension")
util.AddNetworkString("modifysuspension")
util.AddNetworkString("requestthebans")

net.Receive("requestthebans", function()
	local tbl = {}
	local files = file.Find("seasbans/*.txt", "DATA")
	for _, v in pairs (files) do
		local bantbl = util.JSONToTable(file.Read("seasbans/" .. v, "DATA"))
		table.insert(tbl, bantbl)
	end
	
	net.Start("sendbans")
		net.WriteTable(tbl)
	net.Broadcast()
end)

hook.Add("PlayerInitialSpawn", "LoadThatStuff", function(ply)
	if (!file.IsDir("seasbans", "DATA")) then
		file.CreateDir("seasbans")
	end
	
	local files  = file.Find("seasbans/*.txt", "DATA")
	for k, v in pairs (files) do
		local fileopen = file.Read("seasbans/" ..v)
		local jasontable = util.JSONToTable(fileopen)
		if ( tonumber(jasontable[3]) <= os.time() ) then   
			file.Delete("seasbans/" ..v)  
		end
	end
	
	local tbl = {}
	local files = file.Find("seasbans/*.txt", "DATA")
	for _, v in pairs (files) do
		local bantbl = util.JSONToTable(file.Read("seasbans/" .. v, "DATA"))
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
	if ( file.Exists("seasbans/"..ID..".txt", "DATA") ) then
		local banfile = file.Read("seasbans/"..ID..".txt")
		local JSON = util.JSONToTable(banfile)
		if ( JSON[6] == "BAN" ) then
			if ( tonumber(JSON[3]) <= os.time() ) then
				file.Delete("seasbans/"..ID..".txt")
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
	end 
end)
	
hook.Add("PlayerSay", "CheckIfPlayerCanType", function(ply, text, public)
	
	local ID = string.Replace(ply:SteamID(), ":", "_")
	if ( file.Exists("seasbans/"..ID..".txt", "DATA") ) then
		local banfile = file.Read("seasbans/"..ID..".txt")
		local JSON = util.JSONToTable(banfile)
		if ( JSON[6] == "MUTE" ) then
			if ( tonumber(JSON[3]) <= os.time() ) then
				file.Delete("seasbans/"..ID..".txt")
				ply:ChatPrint("Your mute has recently expired.")
			else
				ply:ChatPrint("You are muted.")
				return ""
			end
		end
	end
end)

hook.Add("PlayerCanHearPlayersVoice", "PreventVoiceMute", function(listen, talk)
	local ID = string.Replace(talk:SteamID(), ":", "_")
	if ( file.Exists("seasbans/"..ID..".txt", "DATA") ) then
	local banfile = file.Read("seasbans/"..ID..".txt")
	local JSON = util.JSONToTable(banfile)
		if ( JSON[6] == "VOICEMUTE" ) then
			if ( tonumber(JSON[3]) <= os.time() ) then
				file.Delete("seasbans/"..ID..".txt")
				talk:ChatPrint("Your voicemute has recently expired")
				return true, true
			else
				talk.Cantalk = false
				return false, false
			end
		end
		return true, true
	end
end)
	
concommand.Add("seas_ban", function(ply, cmd, args)
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
			file.Write("seasbans/" ..steamid2..".txt", jstring)
			v:Kick("You have been banned: " ..reason)
			PrintMessage( HUD_PRINTTALK, "[SEAS] Admin " ..ply:Nick().. " has banned " ..v:Nick().. " with reason: " ..reason)
		end
	end
end)
	
concommand.Add("seas_kick", function(ply, cmd, args)
	if ( !ply:IsAdmin() ) then return end
	
	local ID = tonumber(args[1])
	local reason = tostring(args[2]) or "No reason specified"
		
	for k, v in pairs (player.GetAll()) do
		if ( v:UserID() == ID ) then
			v:Kick(reason)
			PrintMessage( HUD_PRINTTALK, "[SEAS] Admin " ..ply:Nick().. " has kicked " ..v:Nick().. " with reason: " ..reason)
		end
	end
end)
	
concommand.Add("seas_slay", function(ply, cmd ,args)
	if ( !ply:IsAdmin() ) then return end
	
	local ID = tonumber(args[1])
	
	for k, v in pairs (player.GetAll()) do
		if ( v:UserID() == ID ) then
			v:Kill()
			PrintMessage( HUD_PRINTTALK, "[SEAS] Admin " ..ply:Nick().. " has slain " ..v:Nick())
		end
	end
end)
	
concommand.Add("seas_mute", function(ply, cmd, args)
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
			file.Write("seasbans/" ..steamid2..".txt", jstring)
			v.CanType = false
			PrintMessage( HUD_PRINTTALK, "[SEAS] Admin " ..ply:Nick().. " has muted " ..v:Nick().. " with reason: " ..reason)
		end
	end
end)
	
concommand.Add("seas_voicemute", function(ply, cmd, args)
	if ( !ply:IsAdmin() ) then return end
	
	local ID = tonumber(args[1])
	local duration = tonumber(args[2] * 60)
	local reason = args[3] or "No reason specified"
		
	for k, v in pairs (player.GetAll()) do
		if ( v:UserID() == ID ) then
			local steamid2 = string.Replace(v:SteamID(), ":", "_")
			local bantable = {v:Nick(), v:SteamID(), tostring(os.time() + duration), reason, ply:Nick(), "VOICEMUTE"}
			local jstring = util.TableToJSON(bantable)
			file.Write("seasbans/" ..steamid2..".txt", jstring)
		v.CanTalk = false
		PrintMessage( HUD_PRINTTALK, "[SEAS] Admin " ..ply:Nick().. " has voicemuted " ..v:Nick().. " with reason: " ..reason)
		end
	end
end)

concommand.Add("seas_teleporttome", function(ply, cmd, args)
	if ( !ply:IsAdmin() ) then return end
	
	local ID = tonumber(args[1])
	
	for k ,v in pairs( player.GetAll()) do
		if ( v:UserID() == ID ) then
			v:SetPos(ply:GetPos() + Vector(0, 50, 10))
			PrintMessage( HUD_PRINTTALK, "[SEAS] Admin " ..ply:Nick().. " teleported " ..v:Nick().. " to his position")
		end
	end
end)
	
concommand.Add("seas_teleporttothem", function(ply, cmd, args)
	if ( !ply:IsAdmin() ) then return end
	
	local ID = tonumber(args[1])
	
	for k, v in pairs (player.GetAll()) do
		if ( v:UserID() == ID ) then
			ply:SetPos(v:GetPos() + Vector(0, 50, 10))
			PrintMessage( HUD_PRINTTALK, "[SEAS] Admin " ..ply:Nick().. " teleported to " ..v:Nick().."'s position")
		end
	end
end)

timer.Create("adsystem", ChatAdTime, 0, function()
	if ( ChatAdEnabled == true ) then
		PrintMessage( HUD_PRINTTALK, "[INFO] " ..table.Random(ChatMessages) )
	end
end)

-- This removes the suspensions.
net.Receive("removesuspension", function()
	local steamid2 = string.Replace(net.ReadString(), ":", "_")
	if ( file.Exists("seasbans/" ..steamid2..".txt", "DATA") ) then
		file.Delete("seasbans/" ..steamid2..".txt")
	end
end)

-- This modifies the suspensions.
net.Receive("modifysuspension", function()
	local value = net.ReadTable()
	local json = util.TableToJSON(value)
	local ply = net.ReadString()
	file.Write("seasbans/"..ply..".txt", json)
end)

-- This adds suspensions.
net.Receive("addban", function()
	local tbl = util.TableToJSON(net.ReadTable())
	local steamid = net.ReadString()
	local val = string.Replace(steamid, ":", "_")
	file.Write("seasbans/"..val..".txt", tbl)
end)

function DisableNoclip( objPl )
	if ( objPl:IsAdmin() ) then
		local noclip = objPl:GetMoveType() == MOVETYPE_NOCLIP
		if ( noclip ) then
			PrintMessage( HUD_PRINTTALK, "[SEAS] Admin " ..objPl:Nick().. " has disabled noclip")
		else 
			PrintMessage( HUD_PRINTTALK, "[SEAS] Admin " ..objPl:Nick().. " has enabled noclip")
		end
	end
	return objPl:IsAdmin()
end
hook.Add("PlayerNoClip", "DisableNoclip", DisableNoclip)