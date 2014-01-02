--------------------------------------
-- Log functions for logging events --
--------------------------------------
NUM_OF_FILES = NUM_OF_FILES or 0
hook.Add("Initialize", "CreateDirs", function()
	if ( !file.IsDir("sblogs", "DATA") ) then
		file.CreateDir("sblogs")
	end
	
	if ( !file.IsDir("sblogs/"..os.date("%m_%d_%y").."_"..GetConVarString("ip"):Replace(".","_"), "DATA" ) ) then
		file.CreateDir("sblogs/"..os.date("%m_%d_%y").."_"..GetConVarString("ip"):Replace(".","_"))
	end
	
	local numfiles = file.Find("sblogs/"..os.date("%m_%d_%y").."_"..GetConVarString("ip"):Replace(".", "_").."/*.txt", "DATA")
	NUM_OF_FILES = #numfiles + 1
end)

hook.Add("PlayerSay", "PlayerChatLog", function(ply, text, public)
	SBLOG("[Player Chat] - " ..ply:Nick()..": " ..text)
end)

hook.Add("PlayerInitialSpawn", "LogPlayerSpawning", function(ply)
	SBLOG("[PLAYER SPAWNED] - " ..ply:Nick().. "(" ..ply:SteamID()..")")
end)

hook.Add("PlayerDeath", "LogDeath", function(v, w, k)
	if ( v == k ) then
		SBLOG("[DEATH LOG] - " ..v:Nick().. " KILLED THEMSELVES")
		return
	end
	
	SBLOG("[DEATH LOG] - " ..v:Nick().. "was KILLED by " ..k.. " using " ..w)
end)

function SBLOG(information)
	local information = information or "[LOG] Function called unexpectedly"
	local date = os.date("%m_%d_%y")
	local numfiles = NUM_OF_FILES
	if ( file.Exists("sblogs/"..date.."_"..GetConVarString("ip"):Replace(".","_").."/log"..numfiles..".txt", "DATA") ) then
		file.Append("sblogs/"..date.."_"..GetConVarString("ip"):Replace(".","_").."/log"..numfiles..".txt", "\n" ..os.date("[%H:%M:%S]").. " " ..information)
	else
		file.Write("sblogs/"..date.."_"..GetConVarString("ip"):Replace(".","_").."/log"..numfiles..".txt", "[LOG STARTED]\n" ..os.date("[%H:%M:%S]").. " " .. information)
	end
end