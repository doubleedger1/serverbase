local meta = FindMetaTable("Player")

util.AddNetworkString("sendinfo")
util.AddNetworkString("updateinfo")
hook.Add("PlayerInitialSpawn", "CheckAccountsExist", function(ply) 
	if ( !file.IsDir("sbaccounts", "DATA") ) then 
		file.CreateDir("sbaccounts")
		print("Accounts directory successfully created!")
	else
		print("Accounts have been successfully loaded!")
	end
	local files = {}
	for k, v in pairs (file.Find("sbaccounts/*.txt", "DATA")) do
		table.insert(files, v)
	end
	local truncatedid = string.gsub(ply:SteamID(), ":", "_")
	print(truncatedid)
	if ( table.HasValue(files, truncatedid..".txt") ) then
		local fileread = file.Read("sbaccounts/"..truncatedid..".txt")
		local tbl = util.JSONToTable(fileread)
		local member = "Normal Member"
		if ( tbl.memberlevel == 1 ) then
			member = "VIP Member"
		end
		net.Start("sendinfo")
			net.WriteUInt(tbl.coins, 16)
			net.WriteString(member)
		net.Send(ply)
		ply.coins = tbl.coins
		ply.memberlevel = tbl.memberlevel
		chat.AddText(ply, COLOR_TAG, "[SB] ", COLOR_TEXT, "Your ", COLOR_TARGET, "account ", COLOR_TEXT, "has been loaded!")
	else
		local tbl = {}
		local member = "Normal Member"
		tbl.coins = 5000
		tbl.memberlevel = 1
		if ( tbl.memberlevel == 1 ) then
			member = "VIP Member"
		end
		net.Start("sendinfo")
			net.WriteUInt(tbl.coins, 16)
			net.WriteString(member)
		net.Send(ply)
		ply.coins = 5000
		ply.memberlevel = 1
		local json = util.TableToJSON(tbl)
		file.Write("sbaccounts/"..truncatedid..".txt", json)
		chat.AddText(ply, COLOR_TAG, "[SB] ", COLOR_TEXT, "A ServerBase account has been created for you!")
		for k, v in pairs (player.GetAll()) do
			chat.AddText(v, COLOR_TAG, "[SB] ", COLOR_ADMIN, ply:Nick(), COLOR_TEXT, " has joined for the first time!")
		end
	end

end)

function meta:GetMoney()
	return self.coins
end

if ( !timer.Exists("accountsaveinterval") ) then
	timer.Create("accountsaveinterval", 60, 0, function() 
		for k, v in pairs (player.GetAll()) do
			v:SaveAccount()
		end
	end)
end

function meta:AddMoney(i)
	self.coins = self.coins + i
	net.Start("updateinfo")
		net.WriteUInt(self.coins, 16)
	net.Send(self)
end

function meta:TakeMoney(i)
	self.coins = self.coins - i
	chat.AddText(self, COLOR_TAG, "[SB] ", COLOR_TEXT, i.. " coins have been subtracted from your account!")
	net.Start("updateinfo")
		net.WriteUInt(self.coins, 16)
	net.Send(self)
	self:SaveAccount()
end

function meta:SaveAccount()
	local truncatedid = string.gsub(self:SteamID(), ":", "_")
	local tbl = {}
	tbl.coins = self.coins
	tbl.memberlevel = self.memberlevel
	local json = util.TableToJSON(tbl)
	file.Write("sbaccounts/"..truncatedid..".txt", json)
	chat.AddText(self, COLOR_TAG, "[SB] ", COLOR_TEXT, "Your ", COLOR_TARGET, "account ", COLOR_TEXT, "has been saved!")
end
