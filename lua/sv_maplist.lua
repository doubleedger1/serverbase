util.AddNetworkString("sendmaps")
util.AddNetworkString("sentmaps")
util.AddNetworkString("receivevotes")

MapsList = {}
Votes = {}

function AddMap(mapname, map, desc)
	local tbl = MapsList
	local count = #tbl + 1
	
	tbl[count] = {
		mapname = mapname,
		map = map,
		desc = desc or "No description provided",
		votes = votes or 0
	}
end

AddMap("Garry's Mod Flatgrass", "gm_flatgrass", "A very grassy map")
AddMap("Garry's Mod Construct", "gm_construct", "A map.")

net.Receive("sendmaps", function(len)
	net.Start("sentmaps")
		net.WriteTable(MapsList)
		net.WriteTable(Votes)
	net.Broadcast()
end)

function GetWinningMap()
	local votes = {}
	for k, v in pairs (MapsList) do
		table.insert(votes, v["votes"])
	end
	return table.GetWinningKey(votes)
end

function ChangeToWinningMap()
	local map = GetWinningMap()
	PrintMessage(HUD_PRINTTALK, "Changing level to "..MapsList[map]["mapname"].." in 5 seconds.")
	timer.Simple(5, function()
		RunConsoleCommand("changelevel", MapsList[map]["map"] )
	end)
end


net.Receive("receivevotes", function(len)
	local newtablemap = net.ReadTable()
	local newtablevote = net.ReadTable()
	
	MapsList = newtablemap
	Votes = newtablevote
end)
