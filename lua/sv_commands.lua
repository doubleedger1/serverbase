// credit to Spacetech for the idea of how to do this.
ChatCommands = {
	admin = "sb_admin",
	bans = "sb_suspensions",
	servers = "sb_portal",
	portal = "sb_portal",
	rules = "sb_rules",
	
	votemap = "sb_votemap",
	maplist = "sv_votemap",
	ban = "sb_ban",
	kick = "sb_kick",
	slay = "sb_slay",
	mute = "sb_mute",
	voicemute = "sb_voicemute",
	bring = "sb_teleporttome",
	goto = "sb_teleporttothem",
	shop = "sb_shop",
	store = "sb_shop",
	buy = "sb_shop"
}

function AddChatCommand(chatCmd, consoleCmd)
	if not ChatCommands then return; end
	ChatCommands[chatCmd] = consoleCmd
end

hook.Add("PlayerSay", "ChatCommands", function(ply, text, public)
	local prefix = string.sub(text, 1, 1)
	local lowerText = string.lower(text)
	local trimText = string.Trim(lowerText)
	local afterPrefix = string.sub(trimText, 2)

	if prefix == "/" then
		local args = string.Explode(" ", afterPrefix)
		local command = args[1]
		table.remove(args, 1)

		if ChatCommands[command] then
			local cmdArgs = ""

			for k, v in pairs(args) do
				if k > 1 then
					cmdArgs = cmdArgs .. v .. " "
				else
					cmdArgs = cmdArgs .. " " .. v .. " "
				end
			end				
			
			if (!cmdArgs) then
				ply:ConCommand(ChatCommands[command])
				return ""
			end
			if (cmdArgs) then					
				ply:ConCommand(ChatCommands[command]..cmdArgs)
			return ""
			end
		end
	end
end)

hook.Add("PlayerSay", "ExtraCommands", function(ply, text, public)
	if ( string.sub(text, 1, 4) == "/log" ) then
		ply:ChatPrint("The current log is: " ..tostring(os.date("%m_%d_%y")).."_"..GetConVarString("ip"):Replace(".", "_").."/log"..NUM_OF_FILES..".txt")
		return ""
	end
	
	if ( string.sub(text, 1, 7) == "/userid" and ply:IsAdmin() ) then
		ReturnUserID(ply, string.sub(text, 9))
		return ""
	end
end)

hook.Add("PlayerSay", "adminchat", function(ply, text, public)
	if ( string.sub(text, 1, 3) == "@@@" and ply:IsAdmin() ) then
		PrintMessage(HUD_PRINTCENTER, "[MESSAGE] " ..string.sub(text, 4))
		return ""
	end
	if ( string.sub(text, 1, 2) == "@@" and ply:IsAdmin() ) then
		for k, v in pairs(player.GetAll()) do
			chat.AddText(v, COLOR_TARGET, "[MESSAGE] ", COLOR_TEXT, string.sub(text, 3))
		return ""
		end
	end
	if ( string.sub(text, 1, 1) == "@" ) then
		for k, v in pairs (player.GetAll()) do
			if ( v:IsAdmin() ) then
				chat.AddText(v, COLOR_TARGET, "[ADMIN] ", COLOR_ADMIN, ply:Nick()..": ", COLOR_TEXT, string.sub(text, 2))
			end
		end
		return ""
	end
end)
