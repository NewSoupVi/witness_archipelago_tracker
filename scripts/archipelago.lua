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
currentlyClearing = false

lasers = {0,0,0,0,0,0,0,0,0,0,0}

doors = {
	["Outside Tutorial Outpost Doors"] = {"Outside Tutorial Optional Door", 
		"Outside Tutorial Outpost Entry Door", 
		"Outside Tutorial Outpost Exit Door"},
	["Glass Factory Doors"] = {"Glass Factory Entry Door", 
		"Glass Factory Back Wall"},
	["Symmetry Island Doors"] = {"Symmetry Island Lower Door", 
		"Symmetry Island Upper Door"},
	["Orchard Gates"] = {"Orchard Middle Gate", 
		"Orchard Final Gate"},
	["Desert Doors"] = {"Desert Door to Light Room", 
		"Desert Door to Pond Room", 
		"Desert Door to Flood Room", 
		"Desert Door to Elevator Room", 
		"Desert Elevator Door"},
	["Quarry Entry Doors"] = {"Quarry Main Entry 1", 
		"Quarry Main Entry 2"},
	["Quarry Stoneworks Doors"] = {"Quarry Door to Stoneworks", 
		"Quarry Stoneworks Side Door", 
		"Quarry Stoneworks Rooftop Shortcut", 
		"Quarry Stoneworks Stairs"},
	["Quarry Boathouse Doors"] = {"Quarry Boathouse Boat Staircase", 
		"Quarry Boathouse First Barrier", 
		"Quarry Boathouse Shortcut"},
	["Shadows Laser Room Doors"] = {"Shadows Laser Room Right Door", 
		"Shadows Laser Room Left Door"},
	["Shadows Lower Doors"] = {"Shadows Timed Door", 
		"Shadows Barrier to Quarry", 
		"Shadows Barrier to Ledge"},
	["Keep Hedge Maze Doors"] = {"Keep Hedge Maze 1 Exit Door", 
		"Keep Hedge Maze 2 Shortcut", 
		"Keep Hedge Maze 2 Exit Door", 
		"Keep Hedge Maze 3 Shortcut", 
		"Keep Hedge Maze 3 Exit Door", 
		"Keep Hedge Maze 4 Shortcut", 
		"Keep Hedge Maze 4 Exit Door"},
	["Keep Pressure Plates Doors"] = {"Keep Pressure Plates 1 Exit Door", 
		"Keep Pressure Plates 2 Exit Door", 
		"Keep Pressure Plates 3 Exit Door", 
		"Keep Pressure Plates 4 Exit Door"},
	["Keep Shortcuts"] = {"Keep Shortcut to Shadows", 
		"Keep Tower Shortcut"},
	["Monastery Entry Doors"] = {"Monastery Inner Door", 
		"Monastery Outer Door"},
	["Monastery Shortcuts"] = {"Monastery Shortcut", 
		"Monastery Door to Garden", 
		"River Shortcut to Monastery Garden"},
	["Town Doors"] = {"Town Cargo Box Door", 
		"Town Wooden Roof Staircase", 
		"Town Tinted Door to RGB House", 
		"Town Door to Church", 
		"Town Maze Staircase", 
		"Town RGB House Staircase"},
	["Town Tower Doors"] = {"Town Tower Red Roof Set Door", 
		"Town Tower Lattice Door", 
		"Town Tower Environmental Set Door", 
		"Town Tower Wooden Roof Set Door"},
	["Windmill & Theater Doors"] = {"Town Windmill Door", 
		"Theater Entry Door", 
		"Theater Exit Door Left", 
		"Theater Exit Door Right"},
	["Jungle Doors"] = {"Jungle Bamboo Shortcut to River", 
		"Jungle Popup Wall"},
	["Bunker Doors"] = {"Bunker Entry Door", 
		"Bunker Tinted Glass Door", 
		"Bunker Door to Ultraviolet Room", 
		"Bunker Door to Elevator"},
	["Swamp Doors"] = {"Swamp Entry Door", 
		"Swamp Door to Broken Shapers", 
		"Swamp Door to Rotated Shapers"},
	["Swamp Shortcuts"] = {"Swamp Platform Shortcut Door", 
		"Swamp Near Laser Shortcut"},
	["Swamp Water Pumps"] = {"Swamp Red Underwater Exit", 
		"Swamp Cyan Water Pump", 
		"Swamp Red Water Pump", 
		"Swamp Blue Water Pump", 
		"Swamp Purple Water Pump"},
	["Treehouse Entry Doors"] = {"Treehouse First Door", 
		"Treehouse Second Door", 
		"Treehouse Beyond Yellow Bridge Door"},
	["Treehouse Upper Doors"] = {"Treehouse Timed Door to Laser House", 
		"Treehouse Drawbridge"},
	["Mountain Floor 1 & 2 Doors"] = {"Inside Mountain First Layer Exit Door", 
		"Inside Mountain Second Layer Staircase Near", 
		"Inside Mountain Second Layer Staircase Far", 
		"Inside Mountain Second Layer Exit Door"},
	["Mountain Bottom Floor Doors"] = {"Inside Mountain Bottom Layer Rock", 
		"Inside Mountain Giant Puzzle Exit Door", 
		"Inside Mountain Door to Final Room"},
	["Caves Doors"] = {"Inside Mountain Door to Secret Area", 
		"Caves Pillar Door", 
		"Challenge Entry Door"},
	["Caves Shortcuts"] = {"Caves Swamp Shortcut", 
		"Caves Mountain Shortcut"},
	["Tunnels Doors"] = {"Challenge Door to Theater Walkway", 
		"Theater Walkway Door to Back of Theater", 
		"Theater Walkway Door to Desert Elevator Room", 
		"Theater Walkway Door to Town"},
	["Desert Control Panels"] = {"Desert Flood Room Flood Controls (Panel)", 
		"Desert Light Room Light Control (Panel)"},
	["Quarry Stoneworks Control Panels"] = {"Quarry Stoneworks Ramp Controls (Panel)", 
		"Quarry Stoneworks Elevator Controls (Panel)"},
	["Quarry Boathouse Control Panels"] = {"Quarry Boathouse Ramp Height Control (Panel)", 
		"Quarry Boathouse Ramp Horizontal Control (Panel)", 
		"Quarry Boathouse Hook Control (Panel)"},
	["Town Control Panels"] = {"Town Maze Rooftop Bridge (Panel)", 
		"Town RGB Room RGB Control (Panel)"},
	["Windmill & Theater Control Panels"] = {"Windmill Turn Control (Panel)", 
		"Theater Video Input (Panel)"},
	["Bunker Control Panels"] = {"Bunker Elevator Control (Panel)", 
		"Bunker UV Room Drop-Down Door Control (Panel)"},
	["Swamp Control Panels"] = {"Swamp Sliding Bridge (Panel)", 
		"Swamp Rotating Bridge (Panel)", 
		"Swamp Long Bridge (Panel)", 
		"Swamp Maze Control (Panel)"},
	["Mountain & Caves Control Panels"] = {"Mountain Floor 1 Bridge (Panel)", 
		"Mountain Floor 2 Bridge Near (Panel)", 
		"Mountain Floor 2 Bridge Far (Panel)", 
		"Mountain Elevator (Panel)", 
		"Caves Elevator (Panel)"},
	["Symmetry Island Panels"] = {"Door to Symmetry Island Lower (Panel)", 
		"Door to Symmetry Island Upper (Panel)"},
	["Tutorial Outpost Panels"] = {"Tutorial Outpost Entry (Panel)", 
		"Tutorial Outpost Exit (Panel)"},
			["Desert Panels"] = {"Desert Light Room Light Control (Panel)", 
		"Desert Flood Room Flood Controls (Panel)", 
		"Desert Light Room Entry (Panel)", 
		"Desert Flood Room Entry (Panel)"},
	["Quarry Outside Panels"] = {"Quarry Entry 1 (Panel)", 
		"Quarry Entry 2 (Panel)", 
		"Quarry Elevator (Panel)"},
	["Quarry Stoneworks Panels"] = {"Quarry Stoneworks Ramp Controls (Panel)", 
		"Quarry Stoneworks Elevator Controls (Panel)", 
		"Quarry Door to Stoneworks (Panel)"},
	["Quarry Boathouse Panels"] = {"Quarry Boathouse Ramp Height Control (Panel)", 
		"Quarry Boathouse Ramp Horizontal Control (Panel)", 
		"Quarry Boathouse Hook Control (Panel)"},
	["Keep Hedge Maze Panels"] = {"Keep Hedge Maze 1 (Panel)", 
		"Keep Hedge Maze 2 (Panel)", 
		"Keep Hedge Maze 3 (Panel)", 
		"Keep Hedge Maze 4 (Panel)"},
	["Monastery Panels"] = {"Monastery Entry Door Left (Panel)", 
		"Monastery Entry Door Right (Panel)", 
		"Monastery Shutter Control (Panel)"},
	["Town Church & RGB House Panels"] = {"Town Door to RGB House (Panel)", 
		"Town RGB Room RGB Control (Panel)", 
		"Town Door to Church (Panel)"},
	["Town Maze Panels"] = {"Town Maze Panel (Drop-Down Staircase) (Panel)", 
		"Town Maze Rooftop Bridge (Panel)"},
	["Town Windmill & Theater Panels"] = {"Windmill Entry (Panel)", 
		"Windmill Turn Control (Panel)", 
		"Theater Entry (Panel)", 
		"Theater Video Input (Panel)", 
		"Theater Exit (Panel)"},
	["Treehouse Panels"] = {"Treehouse First & Second Doors (Panel)", 
		"Treehouse Third Door (Panel)", 
		"Treehouse Laser House Door Timer (Panel)", 
		"Treehouse Drawbridge (Panel)"},
	["Bunker Panels"] = {"Bunker Entry (Panel)", 
		"Inside Bunker Door to Bunker Proper (Panel)", 
		"Bunker UV Room Drop-Down Door Control (Panel)", 
		"Bunker Elevator Control (Panel)"},
	["Swamp Panels"] = {"Swamp Entry (Panel)", 
		"Swamp Platform Shortcut (Panel)", 
		"Swamp Sliding Bridge (Panel)", 
		"Swamp Rotating Bridge (Panel)", 
		"Swamp Long Bridge (Panel)", 
		"Swamp Maze Control (Panel)"},
	["Mountain Panels"] = {"Mountain Floor 1 Bridge (Panel)", 
		"Mountain Floor 2 Bridge Near (Panel)", 
		"Mountain Floor 2 Bridge Far (Panel)", 
		"Mountain Elevator (Panel)"},
	["Caves Panels"] = {"Caves Entry (Panel)", 
		"Challenge Entry (Panel)", 
		"Caves Elevator (Panel)"},
	["Tunnels Panels"] = {"Tunnels Entry (Panel)", 
		"Tunnels Town Shortcut (Panel)"}
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
	local separatorIndex, _ = key:find("-")
	local locationID = tonumber(key:sub(separatorIndex + 1))
	if key:sub(1, 12) == "WitnessLaser" and val then
		locationName = LASER_DATASTORAGE_ID[locationID][1]
		locationTable = LASER_DATASTORAGE_ID[locationID][2]

		lasers[locationTable[1]]=1

		local location = Tracker:FindObjectForCode(locationName)
		if location then
			location.AvailableChestCount = location.AvailableChestCount - 1
		end
		if locationTable[2] ~= nil then
			if unrandomizedDisabled() and Tracker:FindObjectForCode("Discarded").Active == false then
				local location = Tracker:FindObjectForCode(locationTable[2])
				if location then
					location.AvailableChestCount = location.AvailableChestCount - 1
				end
				local location = Tracker:FindObjectForCode(locationTable[3])
				if location then
					location.AvailableChestCount = location.AvailableChestCount - 1
				end
			end
		end

	elseif(key == "WitnessSetting" .. Archipelago.PlayerNumber .. "-Disabled" and val) then
		Tracker:FindObjectForCode("disabledPanelsEnabled").Active = (val ~= "Prevent Solve")

	elseif(key:sub(1, 15) == "WitnessAudioLog" and val) then
		local locationName = AUDIO_LOG_DATASTORAGE_IDS[locationID][1]
		if locationName then
			local location = Tracker:FindObjectForCode(locationName)
			if location then
				location.AvailableChestCount = location.AvailableChestCount - 1
			end
		end

	elseif(key:sub(1, 9) == "WitnessEP" and val) then
		local locationName = EP_DATASTORAGE_IDS[locationID][1]
		if locationName then
			local location = Tracker:FindObjectForCode(locationName)
			if location then
				location.AvailableChestCount = location.AvailableChestCount - 1
			end
		end
	end
	laserCounting()
end

function onClear(slot_data)
	currentlyClearing = true

	lasers = {0,0,0,0,0,0,0,0,0,0,0}

	for LaserID, _ in pairs(LASER_DATASTORAGE_ID) do
		Archipelago:Get({"WitnessLaser" .. Archipelago.PlayerNumber .. "-" .. LaserID})
		Archipelago:SetNotify({"WitnessLaser" .. Archipelago.PlayerNumber .. "-" .. LaserID})
	end

	for AudioLogID, _ in pairs(AUDIO_LOG_DATASTORAGE_IDS) do

		Archipelago:Get({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-" .. AudioLogID})
		Archipelago:SetNotify({"WitnessAudioLog" .. Archipelago.PlayerNumber .. "-" .. AudioLogID})
	end

	Archipelago:Get({"WitnessSetting" .. Archipelago.PlayerNumber .. "-Disabled"})
	Archipelago:SetNotify({"WitnessSetting" .. Archipelago.PlayerNumber .. "-Disabled"})

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
			Tracker:FindObjectForCode("doorsSetting").Active = true
		elseif k == "door_groupings" then
			Tracker:FindObjectForCode("doorsGrouping").CurrentStage = value
			Tracker:FindObjectForCode("doorsGrouping").Active = true
		elseif k == "mountain_lasers" or k == "challenge_lasers" then
			obj.AcquiredCount = value
		elseif k == "victory_condition" then
			obj.CurrentStage = value
			obj.Active = true
		elseif k == "puzzle_randomization" then
			Tracker:FindObjectForCode("puzzleRandomization").CurrentStage = value
			require(getLogicFile())
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
		else
			obj.Active = value
		end
	end

	currentlyClearing = false
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
end

function showGoal()
	Tracker:FindObjectForCode("Goal").CurrentStage = Tracker:FindObjectForCode("hiddenGoal").CurrentStage
	Tracker:FindObjectForCode("boxShort").AcquiredCount = Tracker:FindObjectForCode("hiddenShort").AcquiredCount
	Tracker:FindObjectForCode("boxLong").AcquiredCount = Tracker:FindObjectForCode("hiddenLong").AcquiredCount
end

function laser(num)
	return (lasers[tonumber(num)] > 0)
end

function isClearing()
	return currentlyClearing
end

function randomizationChanged()
    require(getLogicFile())
end


-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("setReply", setReply)
Archipelago:AddRetrievedHandler("setReply", setReply)

ScriptHost:AddWatchForCode("RandomizationChanged", "puzzleRandomization", randomizationChanged)
