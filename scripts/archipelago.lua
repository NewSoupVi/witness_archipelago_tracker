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
EGG_TOTAL = 120
EGG_STEP = 4
RECEIVED_EGGS = false

lasers = {0,0,0,0,0,0,0,0,0,0,0}

doors = {
	["Outside Tutorial Outpost Doors"] = {
		"Outside Tutorial Outpost Path (Door)",
		"Outside Tutorial Outpost Entry (Door)",
		"Outside Tutorial Outpost Exit (Door)"
	},
	["Glass Factory Doors"] = {
		"Glass Factory Entry (Door)",
		"Glass Factory Back Wall (Door)"
	},
	["Symmetry Island Doors"] = {
		"Symmetry Island Lower (Door)",
		"Symmetry Island Upper (Door)"
	},
	["Orchard Gates"] = {
		"Orchard First Gate (Door)",
		"Orchard Second Gate (Door)"
	},
	["Desert Doors & Elevator"] = {
		"Desert Light Room Entry (Door)",
		"Desert Pond Room Entry (Door)",
		"Desert Flood Room Entry (Door)",
		"Desert Elevator Room Entry (Door)",
		"Desert Elevator (Door)"
	},
	["Quarry Entry Doors"] = {
		"Quarry Entry 1 (Door)",
		"Quarry Entry 2 (Door)"
	},
	["Quarry Stoneworks Doors"] = {
		"Quarry Stoneworks Entry (Door)",
		"Quarry Stoneworks Side Exit (Door)",
		"Quarry Stoneworks Roof Exit (Door)",
		"Quarry Stoneworks Stairs (Door)"
	},
	["Quarry Boathouse Doors"] = {
		"Quarry Boathouse Dock (Door)",
		"Quarry Boathouse First Barrier (Door)",
		"Quarry Boathouse Second Barrier (Door)"
	},
	["Shadows Laser Room Doors"] = {
		"Shadows Laser Entry Right (Door)",
		"Shadows Laser Entry Left (Door)"
	},
	["Shadows Lower Doors"] = {
		"Shadows Timed Door",
		"Shadows Quarry Barrier (Door)",
		"Shadows Ledge Barrier (Door)"
	},
	["Keep Hedge Maze Doors"] = {
		"Keep Hedge Maze 1 Exit (Door)",
		"Keep Hedge Maze 2 Shortcut (Door)",
		"Keep Hedge Maze 2 Exit (Door)",
		"Keep Hedge Maze 3 Shortcut (Door)",
		"Keep Hedge Maze 3 Exit (Door)",
		"Keep Hedge Maze 4 Shortcut (Door)",
		"Keep Hedge Maze 4 Exit (Door)"
	},
	["Keep Pressure Plates Doors"] = {
		"Keep Pressure Plates 1 Exit (Door)",
		"Keep Pressure Plates 2 Exit (Door)",
		"Keep Pressure Plates 3 Exit (Door)",
		"Keep Pressure Plates 4 Exit (Door)"
	},
	["Keep Shortcuts"] = {
		"Keep Shadows Shortcut (Door)",
		"Keep Tower Shortcut (Door)"
	},
	["Monastery Entry Doors"] = {
		"Monastery Entry Inner (Door)",
		"Monastery Entry Outer (Door)"
	},
	["Monastery Shortcuts"] = {
		"Monastery Laser Shortcut (Door)",
		"Monastery Garden Entry (Door)",
		"Jungle Monastery Garden Shortcut (Door)"
	},
	["Town Doors"] = {
		"Town Cargo Box Entry (Door)",
		"Town Wooden Roof Stairs (Door)",
		"Town RGB House Entry (Door)",
		"Town Church Entry (Door)",
		"Town Maze Stairs (Door)",
		"Town RGB House Stairs (Door)"
	},
	["Town Tower Doors"] = {
		"Town Tower Second (Door)",
		"Town Tower First (Door)",
		"Town Tower Fourth (Door)",
		"Town Tower Third (Door)"
	},
	["Windmill & Theater Doors"] = {
		"Windmill Entry (Door)",
		"Theater Entry (Door)",
		"Theater Exit Left (Door)",
		"Theater Exit Right (Door)"
	},
	["Jungle Doors"] = {
		"Jungle Laser Shortcut (Door)",
		"Jungle Popup Wall (Door)"
	},
	["Bunker Doors"] = {
		"Bunker Entry (Door)",
		"Bunker Tinted Glass Door",
		"Bunker UV Room Entry (Door)",
		"Bunker Elevator Room Entry (Door)"
	},
	["Swamp Doors"] = {
		"Swamp Entry (Door)",
		"Swamp Between Bridges First Door",
		"Swamp Between Bridges Second Door"
	},
	["Swamp Shortcuts"] = {
		"Swamp Platform Shortcut (Door)",
		"Swamp Laser Shortcut (Door)"
	},
	["Swamp Water Pumps"] = {
		"Swamp Red Underwater Exit (Door)",
		"Swamp Cyan Water Pump (Door)",
		"Swamp Red Water Pump (Door)",
		"Swamp Blue Water Pump (Door)",
		"Swamp Purple Water Pump (Door)"
	},
	["Treehouse Entry Doors"] = {
		"Treehouse First (Door)",
		"Treehouse Second (Door)",
		"Treehouse Third (Door)"
	},
	["Treehouse Upper Doors"] = {
		"Treehouse Laser House Entry (Door)",
		"Treehouse Drawbridge (Door)"
	},
	["Mountain Floor 1 & 2 Doors"] = {
		"Mountain Floor 1 Exit (Door)",
		"Mountain Floor 2 Staircase Near (Door)",
		"Mountain Floor 2 Staircase Far (Door)",
		"Mountain Floor 2 Exit (Door)"
	},
	["Mountain Bottom Floor Doors"] = {
		"Mountain Bottom Floor Rock (Door)",
		"Mountain Bottom Floor Giant Puzzle Exit (Door)",
		"Mountain Bottom Floor Pillars Room Entry (Door)"
	},
	["Caves Doors"] = {
		"Caves Entry (Door)",
		"Caves Pillar Door",
		"Challenge Entry (Door)"
	},
	["Caves Shortcuts"] = {
		"Caves Swamp Shortcut (Door)",
		"Caves Mountain Shortcut (Door)"
	},
	["Tunnels Doors"] = {
		"Tunnels Entry (Door)",
		"Tunnels Theater Shortcut (Door)",
		"Tunnels Desert Shortcut (Door)",
		"Tunnels Town Shortcut (Door)"
	},
	["Desert Control Panels"] = {
		"Desert Surface 3 Control (Panel)",
		"Desert Surface 8 Control (Panel)",
		"Desert Flood Controls (Panel)",
		"Desert Light Control (Panel)",
		"Desert Elevator Room Hexagonal Control (Panel)"
	},
	["Quarry Stoneworks Control Panels"] = {
		"Quarry Stoneworks Ramp Controls (Panel)",
		"Quarry Stoneworks Lift Controls (Panel)"
	},
	["Quarry Boathouse Control Panels"] = {
		"Quarry Boathouse Ramp Height Control (Panel)",
		"Quarry Boathouse Ramp Horizontal Control (Panel)",
		"Quarry Boathouse Hook Control (Panel)"
	},
	["Town Control Panels"] = {
		"Town Maze Rooftop Bridge (Panel)",
		"Town RGB Control (Panel)",
		"Town Desert Laser Redirect Control (Panel)"
	},
	["Windmill & Theater Control Panels"] = {
		"Windmill Turn Control (Panel)",
		"Theater Video Input (Panel)"
	},
	["Bunker Control Panels"] = {
		"Bunker Elevator Control (Panel)",
		"Bunker Drop-Down Door Controls (Panel)"
	},
	["Swamp Control Panels"] = {
		"Swamp Sliding Bridge (Panel)",
		"Swamp Rotating Bridge (Panel)",
		"Swamp Long Bridge (Panel)",
		"Swamp Maze Controls (Panel)"
	},
	["Mountain & Caves Control Panels"] = {
		"Mountain Floor 1 Light Bridge (Panel)",
		"Mountain Floor 2 Light Bridge Near (Panel)",
		"Mountain Floor 2 Light Bridge Far (Panel)",
		"Mountain Floor 2 Elevator Control (Panel)",
		"Caves Elevator Controls (Panel)"
	},
	["Symmetry Island Panels"] = {
		"Symmetry Island Lower (Panel)",
		"Symmetry Island Upper (Panel)"
	},
	["Outside Tutorial Outpost Panels"] = {
		"Outside Tutorial Outpost Entry (Panel)",
		"Outside Tutorial Outpost Exit (Panel)"
	},
	["Desert Panels"] = {
		"Desert Surface 3 Control (Panel)",
		"Desert Surface 8 Control (Panel)",
		"Desert Light Control (Panel)",
		"Desert Flood Controls (Panel)",
		"Desert Light Room Entry (Panel)",
		"Desert Flood Room Entry (Panel)",
		"Desert Elevator Room Hexagonal Control (Panel)"
	},
	["Quarry Outside Panels"] = {
		"Quarry Entry 1 (Panel)",
		"Quarry Entry 2 (Panel)",
		"Quarry Elevator Control (Panel)"
	},
	["Quarry Stoneworks Panels"] = {
		"Quarry Stoneworks Ramp Controls (Panel)",
		"Quarry Stoneworks Lift Controls (Panel)",
		"Quarry Stoneworks Entry (Panel)",
		"Quarry Stoneworks Stairs (Panel)"
	},
	["Quarry Boathouse Panels"] = {
		"Quarry Boathouse Ramp Height Control (Panel)",
		"Quarry Boathouse Ramp Horizontal Control (Panel)",
		"Quarry Boathouse Hook Control (Panel)"
	},
	["Keep Hedge Maze Panels"] = {
		"Keep Hedge Maze 1 (Panel)",
		"Keep Hedge Maze 2 (Panel)",
		"Keep Hedge Maze 3 (Panel)",
		"Keep Hedge Maze 4 (Panel)"
	},
	["Monastery Panels"] = {
		"Monastery Entry Left (Panel)",
		"Monastery Entry Right (Panel)",
		"Monastery Shutters Control (Panel)"
	},
	["Jungle Panels"] = {
		"Jungle Monastery Garden Shortcut (Panel)",
		"Jungle Popup Wall (Panel)"
	},
	["Town Church & RGB House Panels"] = {
		"Town RGB House Entry (Panel)",
		"Town RGB Control (Panel)",
		"Town Church Entry (Panel)"
	},
	["Town Maze Panels"] = {
		"Town Maze Stairs (Panel)",
		"Town Maze Rooftop Bridge (Panel)"
	},
	["Town Dockside House Panels"] = {
		"Town Cargo Box Entry (Panel)",
		"Town Desert Laser Redirect Control (Panel)"
	},
	["Windmill & Theater Panels"] = {
		"Windmill Entry (Panel)",
		"Windmill Turn Control (Panel)",
		"Theater Entry (Panel)",
		"Theater Video Input (Panel)",
		"Theater Exit (Panel)"
	},
	["Treehouse Panels"] = {
		"Treehouse First & Second Doors (Panel)",
		"Treehouse Third Door (Panel)",
		"Treehouse Laser House Door Timer (Panel)",
		"Treehouse Drawbridge (Panel)"
	},
	["Bunker Panels"] = {
		"Bunker Entry (Panel)",
		"Bunker Tinted Glass Door (Panel)",
		"Bunker Drop-Down Door Controls (Panel)",
		"Bunker Elevator Control (Panel)"
	},
	["Swamp Panels"] = {
		"Swamp Entry (Panel)",
		"Swamp Platform Shortcut (Panel)",
		"Swamp Sliding Bridge (Panel)",
		"Swamp Rotating Bridge (Panel)",
		"Swamp Long Bridge (Panel)",
		"Swamp Maze Controls (Panel)",
		"Swamp Laser Shortcut (Panel)"
	},
	["Mountain Panels"] = {
		"Mountain Floor 1 Light Bridge (Panel)",
		"Mountain Floor 2 Light Bridge Near (Panel)",
		"Mountain Floor 2 Light Bridge Far (Panel)",
		"Mountain Floor 2 Elevator Control (Panel)"
	},
	["Caves Panels"] = {
		"Caves Entry (Panel)",
		"Challenge Entry (Panel)",
		"Caves Elevator Controls (Panel)",
		"Caves Mountain Shortcut (Panel)",
		"Caves Swamp Shortcut (Panel)"
	},
	["Tunnels Panels"] = {
		"Tunnels Entry (Panel)",
		"Tunnels Town Shortcut (Panel)"
	}
}

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
	if(key == "WitnessActivatedLasers" .. Archipelago.PlayerNumber and val) then
		for laserID, _ in pairs(val) do
			locationName = LASER_DATASTORAGE_IDS[tonumber(laserID)][1]
			locationTable = LASER_DATASTORAGE_IDS[tonumber(laserID)][2]

			lasers[locationTable[1]] = 1

			local location = Tracker:FindObjectForCode(locationName)
			location.AvailableChestCount = location.AvailableChestCount - 1
			if locationTable[2] ~= nil then
				if unrandomizedDisabled() and Tracker:FindObjectForCode("Discarded").Active == false then
					local location = Tracker:FindObjectForCode(locationTable[2])
					location.AvailableChestCount = location.AvailableChestCount - 1
					local location = Tracker:FindObjectForCode(locationTable[3])
					location.AvailableChestCount = location.AvailableChestCount - 1
				end
			end
			if locationTable[4] ~= nil then
				local location = Tracker:FindObjectForCode(locationTable[4])
				location.AvailableChestCount = location.AvailableChestCount - 1
			end
		end
		laserCounting()

	elseif(key == "WitnessSetting" .. Archipelago.PlayerNumber .. "-Disabled" and val) then
		Tracker:FindObjectForCode("disabledPanelsEnabled").Active = (val ~= "Prevent Solve")

	elseif(key == "WitnessActivatedAudioLogs" .. Archipelago.PlayerNumber and val) then
		for logID, _ in pairs(val) do
			local location = Tracker:FindObjectForCode(AUDIO_LOG_DATASTORAGE_IDS[tonumber(logID)][1])
			location.AvailableChestCount = location.AvailableChestCount - 1
		end

	elseif(key == "WitnessSolvedEPs" .. Archipelago.PlayerNumber and val) then
		for EPID, _ in pairs(val) do
			local location = Tracker:FindObjectForCode(EP_DATASTORAGE_IDS[tonumber(EPID)][1])
			location.AvailableChestCount = location.AvailableChestCount - 1
		end

	elseif(key == "WitnessOpenedDoors" .. Archipelago.PlayerNumber and val) then
		for k, _ in pairs(val) do
			if k == "0x1475b" and not Tracker:FindObjectForCode("Discarded").Active then
				local location = Tracker:FindObjectForCode("@Jungle Discard/Discard")
				location.AvailableChestCount = location.AvailableChestCount - 1

			elseif k == "0x2779a" and not Tracker:FindObjectForCode("Discarded").Active then
				for _, loc in pairs{"@Outside Glass Factory/Rooftop Discard", "@Theater/Discard", "@Tutorial Outpost/Discard"} do
					local location = Tracker:FindObjectForCode(loc)
					location.AvailableChestCount = location.AvailableChestCount - 1
				end
			end
		end

	elseif(key == "WitnessUnlockedWarps" .. Archipelago.PlayerNumber and val) then
		-- implement later

	elseif(key == "WitnessHuntEntityStatus" .. Archipelago.PlayerNumber and val) then
		if Tracker:FindObjectForCode("panelHunt").CurrentStage == 5 then
			local count = 0
			for _, _ in pairs(val) do
				count = count + 1
			end
			Tracker:FindObjectForCode("panelHunt"):SetOverlay(tostring(count))
			Tracker:FindObjectForCode("panelHuntCount").AcquiredCount = count
		end

	elseif(key == "WitnessEasterEggStatus" .. Archipelago.PlayerNumber and val) then
		for id, _ in pairs(val) do
			if tonumber(id) ~= 975103 then
				local eggLoc = Tracker:FindObjectForCode(EASTER_EGG_DATASTORAGE_IDS[tonumber(id)][1])
				eggLoc.AvailableChestCount = eggLoc.AvailableChestCount - 1
			end
		end
		RECEIVED_EGGS = true

		local dummy_item = Tracker:FindObjectForCode("Dummy")
		dummy_item.Active = not dummy_item.Active

	elseif(key == "WitnessDeadChecks" .. Archipelago.PlayerNumber and val) then
		if Tracker:FindObjectForCode("clearJunk").Active then
			for k, _ in pairs(val) do
				local location = Tracker:FindObjectForCode(LOCATION_MAPPING[tonumber(k)][1])
				location.AvailableChestCount = location.AvailableChestCount - 1
				if tonumber(k) > 159699 and tonumber(k) < 159756 then
					for _, l in pairs(OBELISK_MAPPING[tonumber(k)]) do
						local location = Tracker:FindObjectForCode(EP_DATASTORAGE_IDS[tonumber(l)][1])
						location.AvailableChestCount = location.AvailableChestCount - 1
					end
				end
			end
		end
	end
end

function onClear(slot_data)
	Tracker.BulkUpdate = true

	EGG_TOTAL = 120
	RECEIVED_EGGS = false
	lasers = {0,0,0,0,0,0,0,0,0,0,0}

	Archipelago:Get({"WitnessActivatedLasers" .. Archipelago.PlayerNumber})
	Archipelago:SetNotify({"WitnessActivatedLasers" .. Archipelago.PlayerNumber})

	Archipelago:Get({"WitnessSolvedEPs" .. Archipelago.PlayerNumber})
	Archipelago:SetNotify({"WitnessSolvedEPs" .. Archipelago.PlayerNumber})

	Archipelago:Get({"WitnessActivatedAudioLogs" .. Archipelago.PlayerNumber})
	Archipelago:SetNotify({"WitnessActivatedAudioLogs" .. Archipelago.PlayerNumber})

	Archipelago:Get({"WitnessSetting" .. Archipelago.PlayerNumber .. "-Disabled"})
	Archipelago:SetNotify({"WitnessSetting" .. Archipelago.PlayerNumber .. "-Disabled"})

	Archipelago:Get({"WitnessOpenedDoors" .. Archipelago.PlayerNumber})
	Archipelago:SetNotify({"WitnessOpenedDoors" .. Archipelago.PlayerNumber})

	Archipelago:Get({"WitnessUnlockedWarps" .. Archipelago.PlayerNumber})
	Archipelago:SetNotify({"WitnessUnlockedWarps" .. Archipelago.PlayerNumber})

	Archipelago:Get({"WitnessHuntEntityStatus" .. Archipelago.PlayerNumber})
	Archipelago:SetNotify({"WitnessHuntEntityStatus" .. Archipelago.PlayerNumber})

	Archipelago:Get({"WitnessDeadChecks" .. Archipelago.PlayerNumber})
	Archipelago:SetNotify({"WitnessDeadChecks" .. Archipelago.PlayerNumber})

	Archipelago:Get({"WitnessEasterEggStatus" .. Archipelago.PlayerNumber})
	Archipelago:SetNotify({"WitnessEasterEggStatus" .. Archipelago.PlayerNumber})

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

		if k == "disable_non_randomized_puzzles" or k == "shuffle_boat" then
			value = not value
		end

		if k == "shuffle_symbols" and value == false then
			Tracker:FindObjectForCode("ProgressiveDots").CurrentStage = 2
			Tracker:FindObjectForCode("ProgressiveSymmetry").CurrentStage = 2
			Tracker:FindObjectForCode("SoundDots").Active = true
			Tracker:FindObjectForCode("Triangles").Active = true
			Tracker:FindObjectForCode("Eraser").Active = true
			Tracker:FindObjectForCode("Shapers").Active = true
			Tracker:FindObjectForCode("RotatedShapers").Active = true
			Tracker:FindObjectForCode("NegativeShapers").Active = true
			Tracker:FindObjectForCode("ProgressiveStars").CurrentStage = 2
			Tracker:FindObjectForCode("BWSquare").Active = true
			Tracker:FindObjectForCode("ColoredSquares").Active = true
			Tracker:FindObjectForCode("Arrows").Active = true
		elseif k == "obelisk_keys" and value == false then
			Tracker:FindObjectForCode("Desert Obelisk Key").Active = true
			Tracker:FindObjectForCode("Monastery Obelisk Key").Active = true
			Tracker:FindObjectForCode("Treehouse Obelisk Key").Active = true
			Tracker:FindObjectForCode("Mountainside Obelisk Key").Active = true
			Tracker:FindObjectForCode("Quarry Obelisk Key").Active = true
			Tracker:FindObjectForCode("Town Obelisk Key").Active = true
		elseif k == "shuffle_EPs" then
			obj.CurrentStage = value
			if value == 0 then
				Tracker:FindObjectForCode("Desert Obelisk Key").Active = true
				Tracker:FindObjectForCode("Monastery Obelisk Key").Active = true
				Tracker:FindObjectForCode("Treehouse Obelisk Key").Active = true
				Tracker:FindObjectForCode("Mountainside Obelisk Key").Active = true
				Tracker:FindObjectForCode("Quarry Obelisk Key").Active = true
				Tracker:FindObjectForCode("Town Obelisk Key").Active = true
			end
		elseif k == "EP_difficulty" then
			obj.CurrentStage = value
		elseif k == "shuffle_doors" then
			obj.CurrentStage = value
			obj.Active = true
		elseif k == "door_groupings" then
			obj.CurrentStage = value
			obj.Active = true
		elseif k == "mountain_lasers" or k == "challenge_lasers" then
			obj.AcquiredCount = value
		elseif k == "victory_condition" then
			obj.Active = true
			obj.CurrentStage = value
		elseif k == "panel_hunt_postgame" then
			obj.Active = true
			obj.CurrentStage = value
		elseif k == "easter_egg_hunt" then
			obj.Active = true
			obj.CurrentStage = value
			if value >= 3 then -- hard/very_hard/expert eggs
				EGG_STEP = 4
			elseif value >= 1 then -- easy/normal eggs
				EGG_STEP = 3
			end
		elseif k == "panel_hunt_required_absolute" then
			obj.AcquiredCount = value
		elseif k == "puzzle_randomization" then
			obj.CurrentStage = value
			ScriptHost:LoadScript(getLogicFile())
		elseif k == "early_caves" then
			obj.CurrentStage = value
			if value == 2 then
				Tracker:FindObjectForCode("Caves Swamp Shortcut (Door)").Active = true
				Tracker:FindObjectForCode("Caves Mountain Shortcut (Door)").Active = true
			end
		elseif k == "disabled_entities" then
			disabledDict = {}
			for num, id in pairs(value) do
				disabledDict[id] = true
				if id >= 974848 and id <= 974967 and Tracker:FindObjectForCode("eggHuntDifficulty").CurrentStage ~= 0 then
					EGG_TOTAL = EGG_TOTAL - 1
					local eggLoc = Tracker:FindObjectForCode(EASTER_EGG_DATASTORAGE_IDS[tonumber(id)][1])
					eggLoc.AvailableChestCount = eggLoc.AvailableChestCount - 1
				end
			end
		elseif k == "shuffle_dog" then
			obj.CurrentStage = value
		elseif k == "elevators_come_to_you" then
			for _, mover in ipairs(value) do
				if mover == "Quarry Elevator" then
					Tracker:FindObjectForCode("autoQuarryElevator").Active = true
				elseif mover == "Swamp Long Bridge" then
					Tracker:FindObjectForCode("autoSwampLongBridge").Active = true
				elseif mover == "Bunker Elevator" then
					Tracker:FindObjectForCode("autoBunkerElevator").Active = true
				elseif mover == "Town Maze Bridge" then
					Tracker:FindObjectForCode("autoTownMazeBridge").Active = true
				end
			end
		else
			obj.Active = value
		end
	end

	Tracker.BulkUpdate = false

	Tracker:FindObjectForCode("Tutorial 1 Extra").Active,
	Tracker:FindObjectForCode("Tutorial 2 Extra").Active,
	Tracker:FindObjectForCode("Desert 1 Extra").Active,
	Tracker:FindObjectForCode("Desert 2 Extra").Active = getExtraLocations()

	if Tracker:FindObjectForCode("hiddenGoal").CurrentStage == 4 then
		Tracker:FindObjectForCode("Goal").CurrentStage = 5
	end

	-- Dummy item state change so canSolve works properly with 0 items received
	local dummy_item = Tracker:FindObjectForCode("Dummy")
	dummy_item.Active = not dummy_item.Active

end

function getExtraLocations()
	local first_tutorial_loc = 158000
	local second_tutorial_loc = 158001
	local desert_first_loc = 158076
	local desert_second_loc = 158077
	local tutorial_1_enabled = false
	local tutorial_2_enabled = false
	local desert_1_enabled = false
	local desert_2_enabled = false
	for _, i in ipairs(Archipelago.CheckedLocations) do
		if first_tutorial_loc == i then
			tutorial_1_enabled = true
		elseif second_tutorial_loc == i then
			tutorial_2_enabled = true
		elseif desert_first_loc == i then
			desert_1_enabled = true
		elseif desert_second_loc == i then
			desert_2_enabled = true
		end
	end
	for _, i in ipairs(Archipelago.MissingLocations) do
		if first_tutorial_loc == i then
			tutorial_1_enabled = true
		elseif second_tutorial_loc == i then
			tutorial_2_enabled = true
		elseif desert_first_loc == i then
			desert_1_enabled = true
		elseif desert_second_loc == i then
			desert_2_enabled = true
		end
	end
	return tutorial_1_enabled, tutorial_2_enabled, desert_1_enabled, desert_2_enabled
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
		print(string.format("local items: %s", dump(LOCAL_ITEMS)))
		print(string.format("global items: %s", dump(GLOBAL_ITEMS)))
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

	if location_name == "Town Pet the Dog" then
		local dog_1 = Tracker:FindObjectForCode("@Doggie/")
		dog_1.AvailableChestCount = dog_1.AvailableChestCount - 1

		local dog_2 = Tracker:FindObjectForCode("@Town/Pet the Dog")
		dog_2.AvailableChestCount = dog_2.AvailableChestCount - 1
	end

	if location_id > 159699 and location_id < 159756 then
		for _, l in pairs(OBELISK_MAPPING[location_id]) do
			local location = Tracker:FindObjectForCode(EP_DATASTORAGE_IDS[tonumber(l)][1])
			location.AvailableChestCount = location.AvailableChestCount - 1
		end
	end
end

function doorsRegional(item_name)
	for _, door in pairs(doors[item_name]) do
		Tracker:FindObjectForCode(door).Active = true
	end
end

function laserCounting()
	laserCount = 0
	for k, v in pairs(lasers) do
		laserCount = laserCount + v
	end

	Tracker:FindObjectForCode("lasers").AcquiredCount = laserCount
	handleDesertLaser()
end

function showGoal()
	Tracker:FindObjectForCode("Goal").CurrentStage = Tracker:FindObjectForCode("hiddenGoal").CurrentStage + 1
	Tracker:FindObjectForCode("boxShort").AcquiredCount = Tracker:FindObjectForCode("hiddenShort").AcquiredCount
	Tracker:FindObjectForCode("boxLong").AcquiredCount = Tracker:FindObjectForCode("hiddenLong").AcquiredCount
end

function randomizationChanged()
	ScriptHost:LoadScript(getLogicFile())
end

function handleDesertLaser()
	desert_laser = Tracker:FindObjectForCode("Desert Laser")
	lasers_object = Tracker:FindObjectForCode("lasers")
	laserCount = lasers_object.AcquiredCount
	has_desert_laser = lasers[2] == 1 or laserCount >= 11

	if laserCount == 0 then
		if has_desert_laser or desert_laser.Active then
			laserCount = 1
			lasers_object.AcquiredCount = 1
		else
			desert_laser.Active = false
		end
	end
	if has_desert_laser then
		desert_laser.Active = true
	end
	if desert_laser.Active and not hasPanel("Town Desert Laser Redirect Control (Panel)") then
		laserCount = laserCount - 1
	end

	Tracker:FindObjectForCode("laserLatches").AcquiredCount = laserCount
end

function clearJunkChanged()
	if Tracker:FindObjectForCode("clearJunk").Active then
		Archipelago:Get({"WitnessDeadChecks" .. Archipelago.PlayerNumber})
	end
end

function loc_checked(section)
	local locID = section.FullID
	if locID:sub(1, 5) == "Eggs/" and locID:sub(-5) ~= "/Eggs" and RECEIVED_EGGS then
		local dummy_item = Tracker:FindObjectForCode("Dummy")
		dummy_item.Active = not dummy_item.Active
	end
	if locID:sub(1, 6) ~= "Paths/" then
		return
	end
	itemName = string.match(locID, "[^/]+/([^/]+)")
	Tracker:FindObjectForCode(itemName).Active = Tracker:FindObjectForCode("@"..locID).AvailableChestCount == 0
end

-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("setReply", setReply)
Archipelago:AddRetrievedHandler("setReply", setReply)

ScriptHost:AddWatchForCode("RandomizationChanged", "puzzleRandomization", randomizationChanged)
ScriptHost:AddWatchForCode("LasersChanged", "lasers", handleDesertLaser)
ScriptHost:AddWatchForCode("DesertRedirectChanged", "Town Desert Laser Redirect Control (Panel)", handleDesertLaser)
ScriptHost:AddWatchForCode("DesertLaserChanged", "Desert Laser", handleDesertLaser)
ScriptHost:AddWatchForCode("DoorsModeChanged", "doorsSetting", handleDesertLaser)
ScriptHost:AddWatchForCode("ClearJunkChanged", "clearJunk", clearJunkChanged)

ScriptHost:AddOnLocationSectionChangedHandler("loc_checked", loc_checked)
