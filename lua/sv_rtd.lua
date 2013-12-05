------------------------------------------------------
-- To add an outcome simply follow the layout below --
------------------------------------------------------

RTD_OUTCOME = {}

RTD_OUTCOME[1] = {
	name = "healthpos",
	func = function(ply)
		local givehealth = math.random(10, 50)
		ply:SetHealth(ply:Health() + givehealth)
		PrintMessage(HUD_PRINTTALK, ply:Nick().. " had their health set to " ..ply:Health().. " by the dice!")
	end
}

RTD_OUTCOME[2] = {
	name = "healthneg",
	func = function(ply)
		local takehealth = math.random(10, 50)
		if takehealth > ply:Health() then
			ply:SetHealth(1)
			ply:ChatPrint("You have had your health set to 1 due to having less health than the remove health.")
			PrintMessage(HUD_PRINTTALK, ply:Nick().. " had their health set to " ..ply:Health().. " by the dice!")
		else
			ply:SetHealth(ply:Health() - takehealth)
			ply:ChatPrint("You have lost " ..takehealth.. "HP!")
			PrintMessage(HUD_PRINTTALK, ply:Nick().. " had their health set to " ..ply:Health().. " by the dice!")
		end
	end
}

RTD_OUTCOME[3] = {
	name = "slay",
	func = function(ply)
		ply:Kill()
		PrintMessage(HUD_PRINTTALK, ply:Nick().. " has been killed by the dice!")
	end
}

RTD_OUTCOME[4] = {
	name = "god",
	func = function(ply)
		ply:GodEnable()
		PrintMessage(HUD_PRINTTALK, ply:Nick().. " has been given temporary godmode!")
		timer.Simple(10, function()
			ply:GodDisable()
		end)
	end
}

RTD_OUTCOME[5] = {
	name = "nothing",
	func = function(ply)
		PrintMessage(HUD_PRINTTALK, ply:Nick().. " received nothing from the dice.")
	end
}

RTD_OUTCOME[6] = {
	name = "jumppos",
	func = function(ply)
		local before = ply:GetJumpPower()
		ply:SetJumpPower(250)
		PrintMessage(HUD_PRINTTALK, ply:Nick().. " received a temporary jump power boost!")
		timer.Simple(10, function()
			ply:SetJumpPower(before)
		end)
	end
}

RTD_OUTCOME[7] = {
	name = "jumppos",
	func = function(ply)
		local before = ply:GetJumpPower()
		ply:SetJumpPower(150)
		PrintMessage(HUD_PRINTTALK, ply:Nick().. " received a temporary jump power reduction!")
		timer.Simple(10, function()
			ply:SetJumpPower(before)
		end)
	end
}

RTD_OUTCOME[8] = {
	name = "ignition",
	func = function(ply)
		local duration = math.random(1, 10)
		ply:Ignite(duration, 0)
		PrintMessage(HUD_PRINTTALK, ply:Nick().. " has been set on fire for " ..duration.. " seconds!")
	end
}

function RollTheDice(ply)
	if ( !ply:Alive() ) then
		ply:ChatPrint("You can't roll the dice when you're dead!")
		return
	end
	
	local outcome = RTD_OUTCOME[math.random(1, #RTD_OUTCOME)]
	
	ply.rtdcooldown = ply.rtdcooldown or 0
	
	if ( ply.rtdcooldown > CurTime() ) then
		ply:ChatPrint("You have to wait " ..math.Round(ply.rtdcooldown - CurTime()).. " seconds to roll again.")
		return
	end
	
	if outcome and outcome.func then
		outcome.func(ply)
	end
	
	ply:ChatPrint("You have rolled the dice.")
	
	ply.rtdcooldown = CurTime() + 120
end
hook.Add("PlayerSay", "PlayerRollTheDice", function(ply, text, args)
	newtext = string.lower(text)
	if ( string.sub(newtext, 1, 4) == "/rtd" or string.sub(newtext, 1, 4) == "!rtd" ) then
		RollTheDice(ply)
		return ""
	end
end)