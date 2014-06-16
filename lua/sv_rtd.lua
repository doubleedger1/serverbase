------------------------------------------------------
-- To add an outcome simply follow the layout below --
------------------------------------------------------

RTD_OUTCOME = {}

RTD_OUTCOME[1] = {
	name = "healthpos",
	func = function(ply)
		local givehealth = math.random(10, 50)
		ply:SetHealth(ply:Health() + givehealth)
		for k ,v in pairs(player.GetAll()) do
			chat.AddText(v, COLOR_TAG, "[RTD] ", COLOR_TEXT, ply:Nick().. " had their health set to " ..ply:Health().. " by the dice!")
		end
	end
}

RTD_OUTCOME[2] = {
	name = "healthneg",
	func = function(ply)
		local takehealth = math.random(10, 50)
		if takehealth > ply:Health() then
			ply:SetHealth(1)
			for k, v in pairs (player.GetAll()) do
				chat.AddText(v, COLOR_TAG, "[RTD] ", COLOR_TEXT, ply:Nick().. " had theirhealth set to " ..ply:Health().. " by the dice!")
			end
		else
			ply:SetHealth(ply:Health() - takehealth)
			for k, v in pairs (player.GetAll()) do
				chat.AddText(v, COLOR_TAG, "[RTD] ", COLOR_TEXT, ply:Nick().. " had their health set to " ..ply:Health().. " by the dice!")
			end
		end
	end
}

RTD_OUTCOME[3] = {
	name = "slay",
	func = function(ply)
		for k, v in pairs (player.GetAll()) do
			chat.AddText(v, COLOR_TAG, "[RTD] ", COLOR_TEXT, ply:Nick().. " has been killed by the dice!")
		end
		ply:Kill()
	end
}

RTD_OUTCOME[4] = {
	name = "god",
	func = function(ply)
		ply:GodEnable()
		for k, v in pairs (player.GetAll()) do
			chat.AddText(v, COLOR_TAG, "[RTD] ", COLOR_TEXT, ply:Nick().. " has been given temporary godmode!")
		end
		timer.Simple(10, function()
			ply:GodDisable()
		end)
	end
}

RTD_OUTCOME[5] = {
	name = "nothing",
	func = function(ply)
		for k, v in pairs (player.GetAll()) do
			chat.AddText(v, COLOR_TAG, "[RTD] ", ply:Nick().. " has received nothing from the dice.")
		end
	end
}

RTD_OUTCOME[6] = {
	name = "jumppos",
	func = function(ply)
		local before = ply:GetJumpPower()
		for k, v in pairs (player.GetAll()) do
			chat.AddText(v, COLOR_TAG, "[RTD] ", COLOR_TEXT, ply:Nick().. " received a temporary jump power boost!")
		end
		ply:SetJumpPower(250)
		timer.Simple(10, function()
			ply:SetJumpPower(before)
		end)
	end
}

RTD_OUTCOME[7] = {
	name = "jumpneg",
	func = function(ply)
		local before = ply:GetJumpPower()
		for k, v in pairs (player.GetAll()) do
			chat.AddText(v, COLOR_TAG, "[RTD] ", COLOR_TEXT, ply:Nick().. " received a temporary jump power reduction!")
		end
		ply:SetJumpPower(150)
		timer.Simple(10, function()
			ply:SetJumpPower(before)
		end)
	end
}

RTD_OUTCOME[8] = {
	name = "ignition",
	func = function(ply)
	local duration = math.random(1, 10)
		for k, v in pairs (player.GetAll()) do
			chat.AddText(v, COLOR_TAG, "[RTD] ", COLOR_TEXT, ply:Nick().. " has been set on fire for " ..duration.. " seconds!")
		end
		local duration = math.random(1, 10)
		ply:Ignite(duration, 0)
	end
}

RTD_OUTCOME[9] = {	
	name = "heavyboots",
	func = function(ply)
		for k ,v in pairs (player.GetAll()) do
			chat.AddText(v, COLOR_TAG, "[RTD] ", COLOR_TEXT, ply:Nick().. " has been given heavy boots by the dice!")
		end
		ply.HeavyBoots = true
		ply.PreviousJumpPower = ply:GetJumpPower()
		ply:SetJumpPower(0)
		chat.AddText(ply, COLOR_TAG, "[RTD] ", COLOR_TEXT, "You'll be able to jump after you have died!")
	end
}

RTD_OUTCOME[10] = {
	name = "regeneration",
	func = function(ply)
		for k, v in pairs (player.GetAll()) do
			chat.AddText(v, COLOR_TAG, "[RTD] ", COLOR_TEXT, ply:Nick().. " has been given temporary health regeration by the dice!")
		end
		timer.Create(ply:Nick(), 1, math.random(5,20), function()
			if ( ply:Health() + 1 > 100 ) then
				ply:SetHealth(100)
			else
				ply:SetHealth(ply:Health() + 1)
			end
		end)
	end
}

RTD_OUTCOME[11] = {
	name = "coinspos",
	func = function(ply)
		local coins = math.Random(100, 5000)
		for k, v in pairs (player.GetAll()) do
			chat.AddText(v, COLOR_TAG, "[RTD] ", COLOR_TEXT, ply:Nick().. " has been given ", COLOR_ADMIN, coins.. " coins.")
		end
		ply:AddMoney(coins)
	end
}

RTD_OUTCOME[12] = {
	name = "coinsneg",
	func = function(ply)
		local coins = math.Random(100, 5000)
		if ( ply:GetMoney() < coins ) then
			coins = ply:GetMoney()
		end
		for k, v in pairs (player.GetAll()) do
			chat.AddText(v, COLOR_TAG, "[RTD] ", COLOR_TEXT, ply:Nick().. " has lost ", COLOR_TARGET, coins.. " coins.")
		end
		ply:TakeMoney(coins)
	end
}

hook.Add("PlayerSpawn", "SpawnCheck", function(ply)
	if ( ply.HeavyBoots == true ) then
		ply.HeavyBoots = false
		ply:SetJumpPower(ply.PreviousJumpPower)
		ply:ChatPrint("You can now jump again!")
	end
end)

function RollTheDice(ply)
	if ( !ply:Alive() ) then
		ply:ChatPrint("You can't roll the dice when you're dead!")
		return
	end
	
	local outcome = RTD_OUTCOME[math.random(1, #RTD_OUTCOME)]
	
	ply.rtdcooldown = ply.rtdcooldown or 0
	
	if ( ply.rtdcooldown > CurTime() ) then
		chat.AddText(ply, COLOR_TAG, "[RTD] ", COLOR_TEXT, "You have to wait " ..math.Round(ply.rtdcooldown - CurTime()).. " seconds to roll again.")
		return
	end
	
	if outcome and outcome.func then
		outcome.func(ply)
	end
	
	chat.AddText(ply, COLOR_TAG, "[RTD] ", COLOR_TEXT, "You have rolled the dice.")
	
	ply.rtdcooldown = CurTime() + 120
end

hook.Add("PlayerSay", "PlayerRollTheDice", function(ply, text, args)
	newtext = string.lower(text)
	if table.HasValue( RTDChatCommands, string.sub(newtext, 1, string.len(newtext))  ) then
		if ( RTD_ENABLED ) then
			RollTheDice(ply)
			return ""
		else
			chat.AddText(ply, COLOR_TAG, "[ServerBase]", COLOR_TEXT, "The RTD feature has been disabled!")
			return ""
		end
	end
end)
