if CLIENT then return end
AddCSLuaFile("cl_admin.lua")
AddCSLuaFile("cl_dermaskin.lua")
AddCSLuaFile("cl_portal.lua")
AddCSLuaFile("cl_rules.lua")
AddCSLuaFile("cl_suspensions.lua")
AddCSLuaFile("sh_config.lua")
AddCSLuaFile("sh_funcs.lua")

include("sh_config.lua")
include("sh_funcs.lua")
include("sv_admin.lua")
include("sv_commands.lua")
include("sv_logs.lua")
include("sv_rtd.lua")