require "ExpandedHelicopter00a_Util"

twitchKeys = {["KP_1"]="Numpad1",["KP_2"]="Numpad2",["KP_3"]="Numpad3",
			  ["KP_4"]="Numpad4",["KP_5"]="Numpad5",["KP_6"]="Numpad6",
			  ["KP_7"]="Numpad7",["KP_8"]="Numpad8",["KP_9"]="Numpad9",}

function twitchIntegration_OnKeyPressed(key)

	if isClient() then
		if (not isAdmin()) and (not isCoopHost()) then
			return
		end
	end

	local twitchKey = twitchKeys[Keyboard.getKeyName(key)]
	if twitchKey then

		local players = getActualPlayers()
		local playerChar = players[ZombRand(#players)+1]

		if eHelicopterSandbox.config.twitchStreamerTargeted == true then
			playerChar = getPlayer()
		end
		
		if playerChar then
			local numpadKey = eHelicopterSandbox.config[twitchKey]
			local integration = twitchIntegrationPresets[numpadKey]

			if integration=="RANDOM" then
				integration = twitchIntegrationPresets[ZombRand(2,#twitchIntegrationPresets)]
			end

			if integration=="NONE" then
				return
			end

			local heli = getFreeHelicopter(integration)
			print("EHE-TI: launch: "..tostring(integration).." target:"..playerChar:getDisplayName())
			heli:launch(playerChar, true)

			local min, max = eheBounds.threshold/2, eheBounds.threshold-1
			
			local offsetX = ZombRand(min, max)
			if ZombRand(101) <= 50 then
				offsetX = 0-offsetX
			end

			local offsetY = ZombRand(min, max)
			if ZombRand(101) <= 50 then
				offsetY = 0-offsetY
			end

			heli.currentPosition:set(playerChar:getX()+offsetX, playerChar:getY()+offsetY, heli.height)
		end
	end
end

Events.OnKeyPressed.Add(twitchIntegration_OnKeyPressed)