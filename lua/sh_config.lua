----------------------------------------------------
-- Enable/disable different features
----------------------------------------------------
RTD_ENABLED = true -- Set this to false if you don't wish to use the RTD feature.

PORTAL_ENABLED = true -- Set this to false if you don't wish to use the server portal feature.

ADMIN_ENABLED = true -- Set this to false if you don't wish to use the admin system feature. -- Recommend true.

RULES_ENABLED = true -- Set this to false if you don't wish to use the rules feature.


----------------------------------------------------
-- Colors for colored messages (RGB format)
----------------------------------------------------
COLOR_TAG = Color(0, 74, 74) --Default: tale
COLOR_TEXT = Color(255, 255, 255) --Default: white
COLOR_ADMIN = Color(0, 255, 0) --Default: green
COLOR_SUPER = Color(0, 200, 200) --Default: cyan
COLOR_TARGET = Color(255, 0, 0) --Default: red
COLOR_REASON = Color(0, 0, 0) --Default: black


----------------------------------------------------
-- Chat ad config options
----------------------------------------------------
ChatAdTime = 180 --This will print a helpful message every number of seconds.
 
ChatAdEnabled = true --Set this to false if you don't want ChatMessages printed every ChatAdTime seconds.

// Add messages by putting ChatMessages[#ascending#] = "message as a string"
ChatMessages = {}
ChatMessages[1] = "Report a rulebreaking player on our website at www.mywebsite.com"
ChatMessages[2] = "This server is running ServerBase!"
ChatMessages[3] = "Press F1 for more information about the server or gamemode"
ChatMessages[4] = "To access the server portal, type /servers or /portal"
ChatMessages[5] = "To get the log for administration or reporting purposes, type /log"


----------------------------------------------------
-- Server information for the portal
----------------------------------------------------
// Please replace and add your own IPs, Server names and descriptions in place of my communities' servers.
Servers = { 
	{"test", "37.187.77.51:27015", "This is the Minigames server"}, 
	{"PlaceHolder2", "37.187.77.51:27016", "This is the Zombie Survival server"},
	{"PlaceHolder3", "37.187.77.51:27017", "This is the Retro Team Play server"}
}


----------------------------------------------------
-- Groups
-- Add admins by their SteamID number here. Ex. STEAM_0:0:12345
----------------------------------------------------
SuperAdmins = {
	"",
}
Admins = {
	"",
}


----------------------------------------------------
-- Add your own RTD chat commands
----------------------------------------------------
RTDChatCommands = {
	"/rtd",
	"!rtd",
	"rtd"
}


----------------------------------------------------
-- Adding your own rules for the MOTD feature
----------------------------------------------------
// Add rules by putting Rules[#ascending#] = "message as a string"
Rules = {}
Rules[1] = "Don't spam the chatbox or the voicechat."
Rules[2] = "Don't speedhack, wallhack, aimbot or hack in any way, shape or form."
Rules[3] = "Put your server rules here as I can't think of any other basic ones."
