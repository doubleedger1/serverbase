function string.ConvertTimeStamp(seconds)
	-- Thanks to ULX for the time conversion; has made my life so much easier.
	local years = math.floor( seconds / 31536000 )
	seconds = seconds - ( years * 31536000 )
	local weeks = math.floor( seconds / 604800 )
	seconds = seconds - ( weeks * 604800 )
	local days = math.floor( seconds / 86400 )
	seconds = seconds - ( days * 86400 )
	local hours = math.floor( seconds/3600 )
	seconds = seconds - ( hours * 3600 )
	local minutes = math.floor( seconds/60 )
	seconds = seconds - ( minutes * 60 )
	
	local curtime = ""
	if years ~= 0 then curtime = curtime .. years .. " year" .. ( ( years > 1 ) and "s, " or ", " ) end
	if weeks ~= 0 then curtime = curtime .. weeks .. " week" .. ( ( weeks > 1 ) and "s, " or ", " ) end
	if days ~= 0 then curtime = curtime .. days .. " day" .. ( ( days > 1 ) and "s, " or ", " ) end
	curtime = curtime .. ( ( hours < 10 ) and "0" or "" ) .. hours .. " Hr(s) "
	curtime = curtime .. ( ( minutes < 10 ) and "0" or "" ) .. minutes .. " M(s) "
	return tostring(curtime .. ( ( seconds < 10 and "0" or "" ) .. seconds .. " S(s)" ))
end

/*-------------------------------------------------------------------------------------------------------------------------
	chat.AddText([ Player ply,] Colour colour, string text, Colour colour, string text, ... )
	Returns: nil
	In Object: None
	Part of Library: chat
	Available On: Server
	Created By: Overv
-------------------------------------------------------------------------------------------------------------------------*/
if SERVER then
	chat = { }
	function chat.AddText( ... )
		local arg = {...}
		if ( type( arg[1] ) == "Player" ) then ply = arg[1] end
		
		umsg.Start( "AddText", ply )
			umsg.Short( #arg )
			for _, v in pairs( arg ) do
				if ( type( v ) == "string" ) then
					umsg.String( v )
				elseif ( type ( v ) == "table" ) then
					umsg.Short( v.r )
					umsg.Short( v.g )
					umsg.Short( v.b )
					umsg.Short( v.a )
				end
			end
		umsg.End( )
	end
else
	usermessage.Hook( "AddText", function( um )
		local argc = um:ReadShort( )
		local args = { }
		for i = 1, argc / 2, 1 do
			table.insert( args, Color( um:ReadShort( ), um:ReadShort( ), um:ReadShort( ), um:ReadShort( ) ) )
			table.insert( args, um:ReadString( ) )
		end
		
		chat.AddText( unpack( args ) )
	end )
end

-- Helper function to get the target from a UserID
function TargetUserID(id)
	local id = tonumber(id)

	for k,v in pairs(player.GetAll()) do
		if ( v:UserID() == id ) then
			return v
		else
			return false
		end
	end
end

-- Helper function to get the userID from chat command specification
function ReturnUserID(ply, user)
	local username = user
	for k, v in pairs (player.GetAll()) do
		if ( username == v:Nick() ) then
			chat.AddText(ply, COLOR_TAG, "[SB] ", COLOR_TEXT, "The UserID of " ..v:Nick().. " is ", COLOR_TARGET, tostring(v:UserID()))
			return
		end
	end
end

local meta = FindMetaTable("Player")

-- For those who want mods can edit the code to their liking to include some mods for the system
function meta:IsMod()
	return self:IsUserGroup('moderator') or self:IsUserGroup('mod')
end
