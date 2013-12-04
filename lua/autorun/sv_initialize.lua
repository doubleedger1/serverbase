if CLIENT then return end
AddCSLuaFile("cl_admin.lua")
AddCSLuaFile("cl_dermaskin.lua")
AddCSLuaFile("cl_portal.lua")
AddCSLuaFile("cl_suspensions.lua")
AddCSLuaFile("cl_shop.lua")
AddCSLuaFile("sh_funcs.lua")

include("sh_funcs.lua")
include("sv_admin.lua")
include("sv_commands.lua")
