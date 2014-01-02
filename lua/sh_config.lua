--------------------------------------------------------
-- Configuration options below for your customization --
--------------------------------------------------------

RTD_ENABLED = true -- Set this to false if you don't wish to use the RTD feature.

PORTAL_ENABLED = true -- Set this to false if you don't wish to use the server portal feature.

ADMIN_ENABLED = true -- Set this to false if you don't wish to use the admin system feature. -- Recommend true.

RULES_ENABLED = true -- Set this to false if you don't wish to use the rules feature.

ChatAdTime = 180 --This will print a helpful message every number of seconds.
 
ChatAdEnabled = true --Set this to false if you don't want ChatMessages printed every ChatAdTime seconds.

ChatMessages = {}
ChatMessages[1] = "Report a rulebreaking player on our website at www.mywebsite.com"
ChatMessages[2] = "This server is running ServerBase!"
ChatMessages[3] = "Press F1 for more information about the server or gamemode"
ChatMessages[4] = "To access the server portal, type /servers or /portal"
ChatMessages[5] = "To get the log for administration or reporting purposes, type /log"

--Add messages by putting ChatMessages[#ascending#] = "message as a string"

-- Please replace and add your own IPs, Server names and descriptions in place of my communities' servers.
Servers = { 
	{"test", "37.187.77.51:27015", "This is the Minigames server"}, 
	{"PlaceHolder2", "37.187.77.51:27016", "This is the Zombie Survival server"},
	{"PlaceHolder3", "37.187.77.51:27017", "This is the Retro Team Play server"}
}

Rules = {}
Rules[1] = "1) Don't spam the chatbox or the voicechat."
Rules[2] = "2) Don't speedhack, wallhack, aimbot or hack in any way, shape or form."
Rules[3] = "3) Put your server rules here as I can't think of any other basic ones."