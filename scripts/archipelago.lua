-- this is an example/ default implementation for AP autotracking
-- it will use the mappings defined in item_mapping.lua and location_mapping.lua to track items and locations via thier ids
-- it will also load the AP slot data in the global SLOT_DATA, keep track of the current index of on_item messages in CUR_INDEX
-- addition it will keep track of what items are local items and which one are remote using the globals LOCAL_ITEMS and GLOBAL_ITEMS
-- this is useful since remote items will not reset but local items might
ScriptHost:LoadScript("scripts/ap_item_mapping.lua")
ScriptHost:LoadScript("scripts/ap_location_mapping.lua")

CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}
disabledDict = {}

lasers = {0,0,0,0,0,0,0,0,0,0,0}

function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

function setReply(key, val, old)
	if(key == "WitnessLaser" .. Archipelago.PlayerNumber .. "-628" and val) then
		lasers[8]=1
		local location = Tracker:FindObjectForCode("@Jungle Laser/Laser Activation")
		if location then
			location.AvailableChestCount = location.AvailableChestCount - 1
		end
	elseif(key == "WitnessLaser" .. Archipelago.PlayerNumber .. "-1289" and val) then
		lasers[1]=1
		local location = Tracker:FindObjectForCode("@Symmetry Island/Laser Activation")
		if location then
			location.AvailableChestCount = location.AvailableChestCount - 1
		end
	elseif(key == "WitnessLaser" .. Archipelago.PlayerNumber .. "-3062" and val) then
		lasers[10]=1
		local location = Tracker:FindObjectForCode("@Swamp Laser/Laser Activation")
		if location then
			location.AvailableChestCount = location.AvailableChestCount - 1
		end
	elseif(key == "WitnessLaser" .. Archipelago.PlayerNumber .. "-4859" and val) then
		lasers[2]=1
		local location = Tracker:FindObjectForCode("@Desert/Laser Activation")
		if location then
			location.AvailableChestCount = location.AvailableChestCount - 1
		end
	elseif(key == "WitnessLaser" .. Archipelago.PlayerNumber .. "-5307" and val) then
		lasers[5]=1
		local location = Tracker:FindObjectForCode("@Keep Tower/Laser Activation")
		if location then
			location.AvailableChestCount = location.AvailableChestCount - 1
		end
	elseif(key == "WitnessLaser" .. Archipelago.PlayerNumber .. "-5433" and val) then
		lasers[3]=1
		local location = Tracker:FindObjectForCode("@Quarry Laser/Laser Activation")
		if location then
			location.AvailableChestCount = location.AvailableChestCount - 1
		end
	elseif(key == "WitnessLaser" .. Archipelago.PlayerNumber .. "-10404" and val) then
		lasers[11]=1
		local location = Tracker:FindObjectForCode("@Treehouse Laser House/Laser Activation")
		if location then
			location.AvailableChestCount = location.AvailableChestCount - 1
		end
	elseif(key == "WitnessLaser" .. Archipelago.PlayerNumber .. "-13049" and val) then
		lasers[7]=1
		local location = Tracker:FindObjectForCode("@Town Tower/Laser Activation")
		if location then
			location.AvailableChestCount = location.AvailableChestCount - 1
		end
	elseif(key == "WitnessLaser" .. Archipelago.PlayerNumber .. "-49842" and val) then
		lasers[9]=1
		local location = Tracker:FindObjectForCode("@Color Bunker/Laser Activation")
		if location then
			location.AvailableChestCount = location.AvailableChestCount - 1
		end
		if unrandomizedDisabled() and Tracker:FindObjectForCode("Discarded").Active == false then
			local location = Tracker:FindObjectForCode("@Town Cargo Box Area/Discard")
			if location then
				location.AvailableChestCount = location.AvailableChestCount - 1
			end
			local location = Tracker:FindObjectForCode("@Mountainside Discard/Discard")
			if location then
				location.AvailableChestCount = location.AvailableChestCount - 1
			end
		end
	elseif(key == "WitnessLaser" .. Archipelago.PlayerNumber .. "-97381" and val) then
		lasers[6]=1
		local location = Tracker:FindObjectForCode("@Monastery/Laser Activation")
		if location then
			location.AvailableChestCount = location.AvailableChestCount - 1
		end
		if unrandomizedDisabled() and Tracker:FindObjectForCode("Discarded").Active == false then
			local location = Tracker:FindObjectForCode("@Desert Discard/Discard")
			if location then
				location.AvailableChestCount = location.AvailableChestCount - 1
			end
			local location = Tracker:FindObjectForCode("@Treehouse Right Side/Green Bridge Discard")
			if location then
				location.AvailableChestCount = location.AvailableChestCount - 1
			end
		end
	elseif(key == "WitnessLaser" .. Archipelago.PlayerNumber .. "-98739" and val) then
		lasers[4]=1
		local location = Tracker:FindObjectForCode("@Shadows Laser/Laser Activation")
		if location then
			location.AvailableChestCount = location.AvailableChestCount - 1
		end
		if unrandomizedDisabled() and Tracker:FindObjectForCode("Discarded").Active == false then
			local location = Tracker:FindObjectForCode("@Shipwreck Discard/Discard")
			if location then
				location.AvailableChestCount = location.AvailableChestCount - 1
			end
			local location = Tracker:FindObjectForCode("@Town Red Rooftop/Discard")
			if location then
				location.AvailableChestCount = location.AvailableChestCount - 1
			end
		end
	end
	
	laserCounting()

	if(key == "WitnessSetting" .. Archipelago.PlayerNumber .. "-Disabled" and val) then
		Tracker:FindObjectForCode("unrandomizedPanelsEnabled").Active = (val ~= "Prevent Solve")
	end

	if(key:sub(1, 15) == "WitnessAudioLog" and val) then
		local separatorIndex, _ = key:find("-")
		local audioLogID = tonumber(key:sub(separatorIndex + 1))
		local locationName = AUDIO_LOG_DATASTORAGE_IDS[audioLogID][1]
		if locationName then
			local location = Tracker:FindObjectForCode(locationName)
			if location then
				location.AvailableChestCount = location.AvailableChestCount - 1
			end
		end
	end

	if(key:sub(1, 9) == "WitnessEP" and val) then
		local separatorIndex, _ = key:find("-")
		local epId = tonumber(key:sub(separatorIndex + 1))
		local locationName = EP_DATASTORAGE_IDS[epId][1]
		if locationName then
			local location = Tracker:FindObjectForCode(locationName)
			if location then
				location.AvailableChestCount = location.AvailableChestCount - 1
			end
		end
	end
end

function onClear(slot_data)

	lasers = {0,0,0,0,0,0,0,0,0,0,0}

	Archipelago:Get({"WitnessLaser" .. Archipelago.PlayerNumber .. "-628"})
	Archipelago:Get({"WitnessLaser" .. Archipelago.PlayerNumber .. "-1289"})
	Archipelago:Get({"WitnessLaser" .. Archipelago.PlayerNumber .. "-3062"})
	Archipelago:Get({"WitnessLaser" .. Archipelago.PlayerNumber .. "-4859"})
	Archipelago:Get({"WitnessLaser" .. Archipelago.PlayerNumber .. "-5307"})
	Archipelago:Get({"WitnessLaser" .. Archipelago.PlayerNumber .. "-5433"})
	Archipelago:Get({"WitnessLaser" .. Archipelago.PlayerNumber .. "-10404"})
	Archipelago:Get({"WitnessLaser" .. Archipelago.PlayerNumber .. "-13049"})
	Archipelago:Get({"WitnessLaser" .. Archipelago.PlayerNumber .. "-49842"})
	Archipelago:Get({"WitnessLaser" .. Archipelago.PlayerNumber .. "-97381"})
	Archipelago:Get({"WitnessLaser" .. Archipelago.PlayerNumber .. "-98739"})

	Archipelago:Get({"WitnessSetting" .. Archipelago.PlayerNumber .. "-Disabled"})

	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246007"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246013"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-207360"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246014"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246016"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246004"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246018"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246029"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246030"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246027"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-1871"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-4807"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-207359"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246022"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211711"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-4601"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-1891"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-207368"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246017"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246015"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246019"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-2575"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211369"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-5568"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211766"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246028"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-207374"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-207358"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-207367"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-1889"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246025"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211767"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246023"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246003"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-5559"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246026"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-207370"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-5569"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246058"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246020"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246021"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211368"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-1290"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211133"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246069"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211145"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211159"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211137"})
	Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211146"})

	Archipelago:SetNotify({"WitnessLaser" .. Archipelago.PlayerNumber .. "-628"})
	Archipelago:SetNotify({"WitnessLaser" .. Archipelago.PlayerNumber .. "-1289"})
	Archipelago:SetNotify({"WitnessLaser" .. Archipelago.PlayerNumber .. "-3062"})
	Archipelago:SetNotify({"WitnessLaser" .. Archipelago.PlayerNumber .. "-4859"})
	Archipelago:SetNotify({"WitnessLaser" .. Archipelago.PlayerNumber .. "-5307"})
	Archipelago:SetNotify({"WitnessLaser" .. Archipelago.PlayerNumber .. "-5433"})
	Archipelago:SetNotify({"WitnessLaser" .. Archipelago.PlayerNumber .. "-10404"})
	Archipelago:SetNotify({"WitnessLaser" .. Archipelago.PlayerNumber .. "-13049"})
	Archipelago:SetNotify({"WitnessLaser" .. Archipelago.PlayerNumber .. "-49842"})
	Archipelago:SetNotify({"WitnessLaser" .. Archipelago.PlayerNumber .. "-97381"})
	Archipelago:SetNotify({"WitnessLaser" .. Archipelago.PlayerNumber .. "-98739"})

	Archipelago:SetNotify({"WitnessSetting" .. Archipelago.PlayerNumber .. "-Disabled"})

	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246007"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246013"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-207360"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246014"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246016"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246004"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246018"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246029"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246030"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246027"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-1871"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-4807"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-207359"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246022"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211711"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-4601"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-1891"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-207368"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246017"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246015"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246019"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-2575"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211369"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-5568"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211766"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246028"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-207374"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-207358"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-207367"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-1889"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246025"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211767"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246023"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246003"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-5559"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246026"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-207370"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-5569"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246058"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246020"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246021"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211368"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-1290"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211133"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-246069"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211145"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211159"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211137"})
	Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-211146"})

	for epId, _ in pairs(EP_DATASTORAGE_IDS) do
		local datastorageString = string.format("WitnessEP%d-%d", Archipelago.PlayerNumber, epId)
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: setting up tracking for EP: " .. datastorageString))
		end
		Archipelago:Get({datastorageString})
		Archipelago:SetNotify({datastorageString})
	end

    SLOT_DATA = slot_data
    CUR_INDEX = -1



	Tracker:FindObjectForCode("doorsSetting").CurrentStage = 0
	Tracker:FindObjectForCode("doorsGrouping").CurrentStage = 0
	Tracker:FindObjectForCode("epSetting").CurrentStage = 0
	Tracker:FindObjectForCode("epDiff").CurrentStage = 0
	Tracker:FindObjectForCode("Goal").Active = false
	Tracker:FindObjectForCode("boxShort").Active = false
	Tracker:FindObjectForCode("boxLong").Active = false
	Tracker:FindObjectForCode("Symbols").Active = false


    -- reset locations
    for _, v in pairs(LOCATION_MAPPING) do
        if v[1] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing location %s", v[1]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[1]:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.ChestCount
                else
                    obj.Active = false
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}

	Tracker:FindObjectForCode("Goal").CurrentStage = 0
	Tracker:FindObjectForCode("boxShort").AcquiredCount = 0
	Tracker:FindObjectForCode("boxLong").AcquiredCount = 0

	for k, v in pairs(SETTINGS_MAPPING) do
		obj = Tracker:FindObjectForCode(v)

		local value = SLOT_DATA[k]

		if k == "disable_non_randomized_puzzles" then
			value = not value
		end

		if k == "shuffle_symbols" and value == false then
			Tracker:FindObjectForCode("ProgressiveDots").CurrentStage = 2
			Tracker:FindObjectForCode("ColoredDots").Active = true
			Tracker:FindObjectForCode("SoundDots").Active = true
			Tracker:FindObjectForCode("Symmetry").Active = true
			Tracker:FindObjectForCode("Triangles").Active = true
			Tracker:FindObjectForCode("Eraser").Active = true
			Tracker:FindObjectForCode("Shapers").Active = true
			Tracker:FindObjectForCode("RotatedShapers").Active = true
			Tracker:FindObjectForCode("NegativeShapers").Active = true
			Tracker:FindObjectForCode("ProgressiveStars").CurrentStage = 2
			Tracker:FindObjectForCode("BWSquare").Active = true
			Tracker:FindObjectForCode("ColoredSquares").Active = true
			Tracker:FindObjectForCode("Arrows").Active = true
		elseif k == "shuffle_EPs" then
			Tracker:FindObjectForCode("epSetting").CurrentStage = value
		elseif k == "EP_difficulty" then
			Tracker:FindObjectForCode("epDiff").CurrentStage = value
		elseif k == "shuffle_doors" then
			Tracker:FindObjectForCode("doorsSetting").CurrentStage = value
			if value == 0 then
				Tracker:FindObjectForCode("doorsNo").Active = true
			elseif value == 1 then
				Tracker:FindObjectForCode("doorsPanel").Active = true
			elseif value == 2 then
				Tracker:FindObjectForCode("doorsDoor").Active = true
			elseif value == 3 then
				Tracker:FindObjectForCode("doorsMix").Active = true
			end
		elseif k == "door_groupings" then
			Tracker:FindObjectForCode("doorsGrouping").CurrentStage = value
			if value == 0 then
				Tracker:FindObjectForCode("doorsComplex").Active = true
			elseif value == 1 then
				Tracker:FindObjectForCode("doorsSimple").Active = true
			end
		elseif k == "mountain_lasers" or k == "challenge_lasers" then
			obj.AcquiredCount = value
		elseif k == "victory_condition" then
			obj.CurrentStage = value
		elseif k == "puzzle_randomization" then
			Tracker:FindObjectForCode("puzzleRandomization").CurrentStage = value
		elseif k == "shuffle_boat" then
			Tracker:FindObjectForCode("Boat").Active = not value
		elseif k == "early_caves" then
			Tracker:FindObjectForCode("cavesSetting").CurrentStage = value
			if value == 2 then
				Tracker:FindObjectForCode("Caves Swamp Shortcut").Active = true
				Tracker:FindObjectForCode("Caves Mountain Shortcut").Active = true
			end
		elseif k == "disabled_entities" then
			disabledDict = {}
			for num, id in pairs(value) do
				disabledDict[id] = true
			end
		elseif k == "expect_snipes" then
			Tracker:FindObjectForCode("snipesDifficulty").CurrentStage = value
		elseif k == "expect_non_randomized_snipes" then
			Tracker:FindObjectForCode("nonRandomizedSnipes").Active = value
		elseif k == "expect_prior_knowledge" then
			Tracker:FindObjectForCode("Foreknowledge").CurrentStage = value
		else
			obj.Active = value
		end
	end

	if (not Tracker:FindObjectForCode("hiddenGoal").Active) then showGoal() end

end

-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
    end
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    if not v then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end
        return
    end
	if item_id > 159499 and item_id < 159511 then
		lasers[item_id - 159499] = 1
		laserCounting()
	end
	if item_id > 159902 and item_id < 160171 then
		doorsRegional(v[1])
	end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: code: %s, type %s", v[1], v[2]))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[2] == "toggle" then
            obj.Active = true
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", v[2], v[1]))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: could not find object for code %s", v[1]))
    end
    -- track local items via snes interface
    if is_local then
        if LOCAL_ITEMS[v[1]] then
            LOCAL_ITEMS[v[1]] = LOCAL_ITEMS[v[1]] + 1
        else
            LOCAL_ITEMS[v[1]] = 1
        end
    else
        if GLOBAL_ITEMS[v[1]] then
            GLOBAL_ITEMS[v[1]] = GLOBAL_ITEMS[v[1]] + 1
        else
            GLOBAL_ITEMS[v[1]] = 1
        end
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("local items: %s", dump_table(LOCAL_ITEMS)))
        print(string.format("global items: %s", dump_table(GLOBAL_ITEMS)))
    end
    if PopVersion < "0.20.1" or AutoTracker:GetConnectionState("SNES") == 3 then
        -- add snes interface functions here for local item tracking
    end
end

--called when a location gets cleared
function onLocation(location_id, location_name)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onLocation: %s, %s", location_id, location_name))
    end
    local v = LOCATION_MAPPING[location_id]
    if not v and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[1]:sub(1, 1) == "@" then
            obj.AvailableChestCount = obj.AvailableChestCount - 1
        else
            obj.Active = true
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find object for code %s", v[1]))
    end
	if location_name == "Mountaintop River Shape" then
		showGoal()
	end
end


function doorsRegional(item_name)
	if item_name == "Outside Tutorial Outpost Doors" then
		Tracker:FindObjectForCode("Outside Tutorial Optional Door").Active = true
		Tracker:FindObjectForCode("Outside Tutorial Outpost Entry Door").Active = true
		Tracker:FindObjectForCode("Outside Tutorial Outpost Exit Door").Active = true
	elseif item_name == "Glass Factory Doors"  then
		Tracker:FindObjectForCode("Glass Factory Entry Door").Active = true
		Tracker:FindObjectForCode("Glass Factory Back Wall").Active = true
	elseif item_name == "Symmetry Island Doors"  then
		Tracker:FindObjectForCode("Symmetry Island Lower Door").Active = true
		Tracker:FindObjectForCode("Symmetry Island Upper Door").Active = true
	elseif item_name == "Orchard Gates"  then
		Tracker:FindObjectForCode("Orchard Middle Gate").Active = true
		Tracker:FindObjectForCode("Orchard Final Gate").Active = true
	elseif item_name == "Desert Doors"  then
		Tracker:FindObjectForCode("Desert Door to Light Room").Active = true
		Tracker:FindObjectForCode("Desert Door to Pond Room").Active = true
		Tracker:FindObjectForCode("Desert Door to Flood Room").Active = true
		Tracker:FindObjectForCode("Desert Door to Elevator Room").Active = true
		Tracker:FindObjectForCode("Desert Elevator Door").Active = true
	elseif item_name == "Quarry Entry Doors"  then
		Tracker:FindObjectForCode("Quarry Main Entry 1").Active = true
		Tracker:FindObjectForCode("Quarry Main Entry 2").Active = true
	elseif item_name == "Quarry Stoneworks Doors"  then
		Tracker:FindObjectForCode("Quarry Door to Stoneworks").Active = true
		Tracker:FindObjectForCode("Quarry Stoneworks Side Door").Active = true
		Tracker:FindObjectForCode("Quarry Stoneworks Rooftop Shortcut").Active = true
		Tracker:FindObjectForCode("Quarry Stoneworks Stairs").Active = true
	elseif item_name == "Quarry Boathouse Doors"  then
		Tracker:FindObjectForCode("Quarry Boathouse Boat Staircase").Active = true
		Tracker:FindObjectForCode("Quarry Boathouse First Barrier").Active = true
		Tracker:FindObjectForCode("Quarry Boathouse Shortcut").Active = true
	elseif item_name == "Shadows Laser Room Doors"  then
		Tracker:FindObjectForCode("Shadows Laser Room Right Door").Active = true
		Tracker:FindObjectForCode("Shadows Laser Room Left Door").Active = true
	elseif item_name == "Shadows Lower Doors"  then
		Tracker:FindObjectForCode("Shadows Timed Door").Active = true
		Tracker:FindObjectForCode("Shadows Barrier to Quarry").Active = true
		Tracker:FindObjectForCode("Shadows Barrier to Ledge").Active = true
	elseif item_name == "Keep Hedge Maze Doors"  then
		Tracker:FindObjectForCode("Keep Hedge Maze 1 Exit Door").Active = true
		Tracker:FindObjectForCode("Keep Hedge Maze 2 Shortcut").Active = true
		Tracker:FindObjectForCode("Keep Hedge Maze 2 Exit Door").Active = true
		Tracker:FindObjectForCode("Keep Hedge Maze 3 Shortcut").Active = true
		Tracker:FindObjectForCode("Keep Hedge Maze 3 Exit Door").Active = true
		Tracker:FindObjectForCode("Keep Hedge Maze 4 Shortcut").Active = true
		Tracker:FindObjectForCode("Keep Hedge Maze 4 Exit Door").Active = true
	elseif item_name == "Keep Pressure Plates Doors"  then
		Tracker:FindObjectForCode("Keep Pressure Plates 1 Exit Door").Active = true
		Tracker:FindObjectForCode("Keep Pressure Plates 2 Exit Door").Active = true
		Tracker:FindObjectForCode("Keep Pressure Plates 3 Exit Door").Active = true
		Tracker:FindObjectForCode("Keep Pressure Plates 4 Exit Door").Active = true
	elseif item_name == "Keep Shortcuts"  then
		Tracker:FindObjectForCode("Keep Shortcut to Shadows").Active = true
		Tracker:FindObjectForCode("Keep Tower Shortcut").Active = true
	elseif item_name == "Monastery Entry Doors"  then
		Tracker:FindObjectForCode("Monastery Inner Door").Active = true
		Tracker:FindObjectForCode("Monastery Outer Door").Active = true
	elseif item_name == "Monastery Shortcuts"  then
		Tracker:FindObjectForCode("Monastery Shortcut").Active = true
		Tracker:FindObjectForCode("Monastery Door to Garden").Active = true
		Tracker:FindObjectForCode("River Shortcut to Monastery Garden").Active = true
	elseif item_name == "Town Doors"  then
		Tracker:FindObjectForCode("Town Cargo Box Door").Active = true
		Tracker:FindObjectForCode("Town Wooden Roof Staircase").Active = true
		Tracker:FindObjectForCode("Town Tinted Door to RGB House").Active = true
		Tracker:FindObjectForCode("Town Door to Church").Active = true
		Tracker:FindObjectForCode("Town Maze Staircase").Active = true
		Tracker:FindObjectForCode("Town RGB House Staircase").Active = true
	elseif item_name == "Town Tower Doors" then
		Tracker:FindObjectForCode("Town Tower Red Roof Set Door").Active = true
		Tracker:FindObjectForCode("Town Tower Lattice Door").Active = true
		Tracker:FindObjectForCode("Town Tower Environmental Set Door").Active = true
		Tracker:FindObjectForCode("Town Tower Wooden Roof Set Door").Active = true
	elseif item_name == "Windmill & Theater Doors"  then
		Tracker:FindObjectForCode("Town Windmill Door").Active = true
		Tracker:FindObjectForCode("Theater Entry Door").Active = true
		Tracker:FindObjectForCode("Theater Exit Door Left").Active = true
		Tracker:FindObjectForCode("Theater Exit Door Right").Active = true
	elseif item_name == "Jungle Doors"  then
		Tracker:FindObjectForCode("Jungle Bamboo Shortcut to River").Active = true
		Tracker:FindObjectForCode("Jungle Popup Wall").Active = true
	elseif item_name == "Bunker Doors"  then
		Tracker:FindObjectForCode("Bunker Entry Door").Active = true
		Tracker:FindObjectForCode("Bunker Tinted Glass Door").Active = true
		Tracker:FindObjectForCode("Bunker Door to Ultraviolet Room").Active = true
		Tracker:FindObjectForCode("Bunker Door to Elevator").Active = true
	elseif item_name == "Swamp Doors"  then
		Tracker:FindObjectForCode("Swamp Entry Door").Active = true
		Tracker:FindObjectForCode("Swamp Door to Broken Shapers").Active = true
		Tracker:FindObjectForCode("Swamp Door to Rotated Shapers").Active = true
	elseif item_name == "Swamp Shortcuts"  then
		Tracker:FindObjectForCode("Swamp Platform Shortcut Door").Active = true
		Tracker:FindObjectForCode("Swamp Near Laser Shortcut").Active = true		
	elseif item_name == "Swamp Water Pumps"  then
		Tracker:FindObjectForCode("Swamp Red Underwater Exit").Active = true
		Tracker:FindObjectForCode("Swamp Cyan Water Pump").Active = true
		Tracker:FindObjectForCode("Swamp Red Water Pump").Active = true
		Tracker:FindObjectForCode("Swamp Blue Water Pump").Active = true
		Tracker:FindObjectForCode("Swamp Purple Water Pump").Active = true
	elseif item_name == "Treehouse Entry Doors"  then
		Tracker:FindObjectForCode("Treehouse First Door").Active = true
		Tracker:FindObjectForCode("Treehouse Second Door").Active = true
		Tracker:FindObjectForCode("Treehouse Beyond Yellow Bridge Door").Active = true
	elseif item_name == "Treehouse Upper Doors"  then
		Tracker:FindObjectForCode("Treehouse Timed Door to Laser House").Active = true
		Tracker:FindObjectForCode("Treehouse Drawbridge").Active = true
	elseif item_name == "Mountain Floor 1 & 2 Doors"  then
		Tracker:FindObjectForCode("Inside Mountain First Layer Exit Door").Active = true
		Tracker:FindObjectForCode("Inside Mountain Second Layer Staircase Near").Active = true
		Tracker:FindObjectForCode("Inside Mountain Second Layer Staircase Far").Active = true
		Tracker:FindObjectForCode("Inside Mountain Second Layer Exit Door").Active = true
	elseif item_name == "Mountain Bottom Floor Doors"  then
		Tracker:FindObjectForCode("Inside Mountain Bottom Layer Rock").Active = true
		Tracker:FindObjectForCode("Inside Mountain Giant Puzzle Exit Door").Active = true
		Tracker:FindObjectForCode("Inside Mountain Door to Final Room").Active = true
	elseif item_name == "Caves Doors"  then
		Tracker:FindObjectForCode("Inside Mountain Door to Secret Area").Active = true
		Tracker:FindObjectForCode("Caves Pillar Door").Active = true
		Tracker:FindObjectForCode("Challenge Entry Door").Active = true
	elseif item_name == "Caves Shortcuts"  then
		Tracker:FindObjectForCode("Caves Swamp Shortcut").Active = true
		Tracker:FindObjectForCode("Caves Mountain Shortcut").Active = true
	elseif item_name == "Tunnels Doors"  then
		Tracker:FindObjectForCode("Challenge Door to Theater Walkway").Active = true
		Tracker:FindObjectForCode("Theater Walkway Door to Back of Theater").Active = true
		Tracker:FindObjectForCode("Theater Walkway Door to Desert Elevator Room").Active = true
		Tracker:FindObjectForCode("Theater Walkway Door to Town").Active = true

	elseif item_name == "Desert Control Panels" then
		Tracker:FindObjectForCode("Desert Flood Room Flood Controls (Panel)").Active = true
		Tracker:FindObjectForCode("Desert Light Room Light Control (Panel)").Active = true
	elseif item_name == "Quarry Stoneworks Control Panels" then
		Tracker:FindObjectForCode("Quarry Stoneworks Ramp Controls (Panel)").Active = true
		Tracker:FindObjectForCode("Quarry Stoneworks Elevator Controls (Panel)").Active = true
	elseif item_name == "Quarry Boathouse Control Panels" then
		Tracker:FindObjectForCode("Quarry Boathouse Ramp Height Control (Panel)").Active = true
		Tracker:FindObjectForCode("Quarry Boathouse Ramp Horizontal Control (Panel)").Active = true
		Tracker:FindObjectForCode("Quarry Boathouse Hook Control (Panel)").Active = true
	elseif item_name == "Town Control Panels" then
		Tracker:FindObjectForCode("Town Maze Rooftop Bridge (Panel)").Active = true
		Tracker:FindObjectForCode("Town RGB Room RGB Control (Panel)").Active = true
	elseif item_name == "Windmill & Theater Control Panels" then
		Tracker:FindObjectForCode("Windmill Turn Control (Panel)").Active = true
		Tracker:FindObjectForCode("Theater Video Input (Panel)").Active = true
	elseif item_name == "Bunker Control Panels" then
		Tracker:FindObjectForCode("Bunker Elevator Control (Panel)").Active = true
		Tracker:FindObjectForCode("Bunker UV Room Drop-Down Door Control (Panel)").Active = true
	elseif item_name == "Swamp Control Panels" then
		Tracker:FindObjectForCode("Swamp Sliding Bridge (Panel)").Active = true
		Tracker:FindObjectForCode("Swamp Rotating Bridge (Panel)").Active = true
		Tracker:FindObjectForCode("Swamp Long Bridge (Panel)").Active = true
		Tracker:FindObjectForCode("Swamp Maze Control (Panel)").Active = true
	elseif item_name == "Mountain & Caves Control Panels" then
		Tracker:FindObjectForCode("Mountain Floor 1 Bridge (Panel)").Active = true
		Tracker:FindObjectForCode("Mountain Floor 2 Bridge Near (Panel)").Active = true
		Tracker:FindObjectForCode("Mountain Floor 2 Bridge Far (Panel)").Active = true
		Tracker:FindObjectForCode("Mountain Elevator (Panel)").Active = true
		Tracker:FindObjectForCode("Caves Elevator (Panel)").Active = true

	elseif item_name == "Symmetry Island Panels" then
		Tracker:FindObjectForCode("Door to Symmetry Island Lower (Panel)").Active = true
		Tracker:FindObjectForCode("Door to Symmetry Island Upper (Panel)").Active = true
	elseif item_name == "Tutorial Outpost Panels" then
		Tracker:FindObjectForCode("Tutorial Outpost Entry (Panel)").Active = true
		Tracker:FindObjectForCode("Tutorial Outpost Exit (Panel)").Active = true
	elseif item_name == "Desert Panels" then
		Tracker:FindObjectForCode("Desert Light Room Light Control (Panel)").Active = true
		Tracker:FindObjectForCode("Desert Flood Room Flood Controls (Panel)").Active = true
		Tracker:FindObjectForCode("Desert Light Room Entry (Panel)").Active = true
		Tracker:FindObjectForCode("Desert Flood Room Entry (Panel)").Active = true
	elseif item_name == "Quarry Outside Panels" then
		Tracker:FindObjectForCode("Quarry Entry 1 (Panel)").Active = true
		Tracker:FindObjectForCode("Quarry Entry 2 (Panel)").Active = true
		Tracker:FindObjectForCode("Quarry Elevator (Panel)").Active = true
	elseif item_name == "Quarry Stoneworks Panels" then
		Tracker:FindObjectForCode("Quarry Stoneworks Ramp Controls (Panel)").Active = true
		Tracker:FindObjectForCode("Quarry Stoneworks Elevator Controls (Panel)").Active = true
		Tracker:FindObjectForCode("Quarry Door to Stoneworks (Panel)").Active = true
	elseif item_name == "Quarry Boathouse Panels" then
		Tracker:FindObjectForCode("Quarry Boathouse Ramp Height Control (Panel)").Active = true
		Tracker:FindObjectForCode("Quarry Boathouse Ramp Horizontal Control (Panel)").Active = true
		Tracker:FindObjectForCode("Quarry Boathouse Hook Control (Panel)").Active = true
	elseif item_name == "Keep Hedge Maze Panels" then
		Tracker:FindObjectForCode("Keep Hedge Maze 1 (Panel)").Active = true
		Tracker:FindObjectForCode("Keep Hedge Maze 2 (Panel)").Active = true
		Tracker:FindObjectForCode("Keep Hedge Maze 3 (Panel)").Active = true
		Tracker:FindObjectForCode("Keep Hedge Maze 4 (Panel)").Active = true
	elseif item_name == "Monastery Panels" then
		Tracker:FindObjectForCode("Monastery Entry Door Left (Panel)").Active = true
		Tracker:FindObjectForCode("Monastery Entry Door Right (Panel)").Active = true
		Tracker:FindObjectForCode("Monastery Shutter Control (Panel)").Active = true
	elseif item_name == "Town Church & RGB House Panels" then
		Tracker:FindObjectForCode("Town Door to RGB House (Panel)").Active = true
		Tracker:FindObjectForCode("Town RGB Room RGB Control (Panel)").Active = true
		Tracker:FindObjectForCode("Town Door to Church (Panel)").Active = true
	elseif item_name == "Town Maze Panels" then
		Tracker:FindObjectForCode("Town Maze Panel (Drop-Down Staircase) (Panel)").Active = true
		Tracker:FindObjectForCode("Town Maze Rooftop Bridge (Panel)").Active = true
	elseif item_name == "Town Windmill & Theater Panels" then
		Tracker:FindObjectForCode("Windmill Entry (Panel)").Active = true
		Tracker:FindObjectForCode("Windmill Turn Control (Panel)").Active = true
		Tracker:FindObjectForCode("Theater Entry (Panel)").Active = true
		Tracker:FindObjectForCode("Theater Video Input (Panel)").Active = true
		Tracker:FindObjectForCode("Theater Exit (Panel)").Active = true
	elseif item_name == "Treehouse Panels" then
		Tracker:FindObjectForCode("Treehouse First & Second Doors (Panel)").Active = true
		Tracker:FindObjectForCode("Treehouse Third Door (Panel)").Active = true
		Tracker:FindObjectForCode("Treehouse Laser House Door Timer (Panel)").Active = true
		Tracker:FindObjectForCode("Treehouse Drawbridge (Panel)").Active = true
	elseif item_name == "Bunker Panels" then
		Tracker:FindObjectForCode("Bunker Entry (Panel)").Active = true
		Tracker:FindObjectForCode("Inside Bunker Door to Bunker Proper (Panel)").Active = true
		Tracker:FindObjectForCode("Bunker UV Room Drop-Down Door Control (Panel)").Active = true
		Tracker:FindObjectForCode("Bunker Elevator Control (Panel)").Active = true
	elseif item_name == "Swamp Panels" then
		Tracker:FindObjectForCode("Swamp Entry (Panel)").Active = true
		Tracker:FindObjectForCode("Swamp Platform Shortcut (Panel)").Active = true
		Tracker:FindObjectForCode("Swamp Sliding Bridge (Panel)").Active = true
		Tracker:FindObjectForCode("Swamp Rotating Bridge (Panel)").Active = true
		Tracker:FindObjectForCode("Swamp Long Bridge (Panel)").Active = true
		Tracker:FindObjectForCode("Swamp Maze Control (Panel)").Active = true
	elseif item_name == "Mountain Panels" then
		Tracker:FindObjectForCode("Mountain Floor 1 Bridge (Panel)").Active = true
		Tracker:FindObjectForCode("Mountain Floor 2 Bridge Near (Panel)").Active = true
		Tracker:FindObjectForCode("Mountain Floor 2 Bridge Far (Panel)").Active = true
		Tracker:FindObjectForCode("Mountain Elevator (Panel)").Active = true
	elseif item_name == "Caves Panels" then
		Tracker:FindObjectForCode("Caves Entry (Panel)").Active = true
		Tracker:FindObjectForCode("Challenge Entry (Panel)").Active = true
		Tracker:FindObjectForCode("Caves Elevator (Panel)").Active = true
	elseif item_name == "Tunnels Panels" then
		Tracker:FindObjectForCode("Tunnels Entry (Panel)").Active = true
		Tracker:FindObjectForCode("Tunnels Town Shortcut (Panel)").Active = true
	end
end

function laserCounting()
	laserCount = 0
	for k, v in pairs(lasers) do
		laserCount = laserCount + v
	end
	
	Tracker:FindObjectForCode("lasers").AcquiredCount = laserCount
end

function showGoal()
	Tracker:FindObjectForCode("Goal").CurrentStage = Tracker:FindObjectForCode("hiddenGoal").CurrentStage + 1
	Tracker:FindObjectForCode("boxShort").AcquiredCount = Tracker:FindObjectForCode("hiddenShort").AcquiredCount
	Tracker:FindObjectForCode("boxLong").AcquiredCount = Tracker:FindObjectForCode("hiddenLong").AcquiredCount
end

function laser(num)
	return (lasers[tonumber(num)] > 0)
end

function getDisabledDict()
	return disabledDict
end

-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("setReply", setReply)
Archipelago:AddRetrievedHandler("setReply", setReply)
