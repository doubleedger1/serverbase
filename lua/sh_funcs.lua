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

local meta = FindMetaTable("Player")

-- For those who want mods can edit the code to their liking to include some mods for the system
function meta:IsMod()
	return self:IsUserGroup('moderator') or self:IsUserGroup('mod')
end