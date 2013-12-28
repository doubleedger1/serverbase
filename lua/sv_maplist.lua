Maps = {}
util.AddNetworkString("sendmaps")
util.AddNetworkString("sentmaps")
util.AddNetworkString("requestmaps")

function AddMap(name, map, description)
	local maps = Maps
	local num = #maps + 1
	
	maps[num] = {
		name = name,
		map = map,
		description = description or "No description available."
	}
end

AddMap("Garry's Mod Construct", "gm_construct", "A default Garry's Mod map.")
AddMap("Garry's Mod Flatgrass", "gm_flatgrass", "A default Garry's Mod map.")

net.Receive("sendmaps", function(len)
	local tbl = {}
	table.insert(tbl, Maps)
	net.Start("sentmaps")
		net.WriteTable(tbl)
	net.Broadcast()
end)