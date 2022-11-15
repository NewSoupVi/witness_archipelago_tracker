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

function onClear(slot_data)

    print(dump(slot_data))

    SLOT_DATA = slot_data
    CUR_INDEX = -1
	
	
	Tracker:FindObjectForCode("doorsNo").Active = false
	Tracker:FindObjectForCode("doorsPanel").Active = false
	Tracker:FindObjectForCode("doorsSimple").Active = false
	Tracker:FindObjectForCode("doorsComplex").Active = false
	Tracker:FindObjectForCode("goal").Active = false
	Tracker:FindObjectForCode("boxShort").Active = false
	Tracker:FindObjectForCode("boxLong").Active = false
	
	
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
	
	Tracker:FindObjectForCode("goal").CurrentStage = 0
	Tracker:FindObjectForCode("boxShort").AcquiredCount = 0
	Tracker:FindObjectForCode("boxLong").AcquiredCount = 0
	
	for k, v in pairs(SETTINGS_MAPPING) do
		obj = Tracker:FindObjectForCode(v)
		
		local value = SLOT_DATA[k]
		
		if k == "disable_non_randomized_puzzles" then
			value = not value
		end

		if k == "shuffle_symbols" and value == false then
			Tracker:FindObjectForCode("Dots").Active = true
			Tracker:FindObjectForCode("ColoredDots").Active = true
			Tracker:FindObjectForCode("SoundDots").Active = true
			Tracker:FindObjectForCode("Symmetry").Active = true
			Tracker:FindObjectForCode("Triangles").Active = true
			Tracker:FindObjectForCode("Eraser").Active = true
			Tracker:FindObjectForCode("Shapers").Active = true
			Tracker:FindObjectForCode("RotatedShapers").Active = true
			Tracker:FindObjectForCode("NegativeShapers").Active = true
			Tracker:FindObjectForCode("Stars").Active = true
			Tracker:FindObjectForCode("StarSameColor").Active = true
			Tracker:FindObjectForCode("BWSquare").Active = true
			Tracker:FindObjectForCode("ColoredSquares").Active = true
		end
		
		if k == "shuffle_doors" then
			if value == 0 then
				Tracker:FindObjectForCode("doorsNo").Active = true
				Tracker:FindObjectForCode("Boat").Active = true
			elseif value == 1 then Tracker:FindObjectForCode("doorsPanel").Active = true
			elseif value == 2 then
				Tracker:FindObjectForCode("doorsSimple").Active = true
				Tracker:FindObjectForCode("Boat").Active = true
			elseif value == 3 then
				Tracker:FindObjectForCode("doorsComplex").Active = true
				Tracker:FindObjectForCode("Boat").Active = true
			elseif value == 4 then Tracker:FindObjectForCode("doorsMax").Active = true
			end
		elseif k == "mountain_lasers" or k == "challenge_lasers" then
			obj.AcquiredCount = value
		elseif k == "victory_condition" then
			obj.CurrentStage = value
		else
			obj.Active = value
		end
		
		
		
	end
	
	if (Tracker:FindObjectForCode("Caves").Active) then
		Tracker:FindObjectForCode("Caves Swamp Shortcut").Active = true
		Tracker:FindObjectForCode("Caves Mountain Shortcut").Active = true
	end
	
	if (not Tracker:FindObjectForCode("Uncommon").Active) or (not Tracker:FindObjectForCode("Unrandomized").Active) then showGoal() end
	
	
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
	if item_id > 159902 and item_id < 159988 then
		doorsSimple(item_name)
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
	if Tracker:ProviderCountForCode("shuffleLasers") == 1 then
		result = Tracker:ProviderCountForCode("Symmetry Laser") + Tracker:ProviderCountForCode("Desert Laser") + Tracker:ProviderCountForCode("Quarry Laser") + Tracker:ProviderCountForCode("Shadows Laser") + Tracker:ProviderCountForCode("Keep Laser") + Tracker:ProviderCountForCode("Monastery Laser") + Tracker:ProviderCountForCode("Town Laser") + Tracker:ProviderCountForCode("Jungle Laser") + Tracker:ProviderCountForCode("Bunker Laser") + Tracker:ProviderCountForCode("Swamp Laser") + Tracker:ProviderCountForCode("Treehouse Laser")
	else
		tower = Tracker:FindObjectForCode("@Keep Tower/Laser Pressure Plates").AvailableChestCount + Tracker:FindObjectForCode("@Keep Tower/Laser Hedges").AvailableChestCount - 1
		if tower < 0 then tower = 0 end
		result = 11 - (Tracker:FindObjectForCode("@Symmetry Island/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Desert/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Quarry Laser/Laser").AvailableChestCount + tower + Tracker:FindObjectForCode("@Treehouse Laser House/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Swamp Laser/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Town Laser/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Monastery/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Shadows Laser/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Jungle Laser/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Color Bunker/Laser").AvailableChestCount)
	end
	Tracker:FindObjectForCode("lasers").AcquiredCount = result	
end

function doorsSimple(item_name)
	if item_name == "Outside Tutorial Outpost Doors" then
		Tracker:FindObjectForCode("Outside Tutorial Optional Door").Active = true
		Tracker:FindObjectForCode("Outside Tutorial Outpost Entry Door").Active = true
		Tracker:FindObjectForCode("Outside Tutorial Outpost Exit Door").Active = true
	elseif item_name == "Symmetry Island Doors"  then
		Tracker:FindObjectForCode("Symmetry Island Lower Door").Active = true
		Tracker:FindObjectForCode("Symmetry Island Upper Door").Active = true
	elseif item_name == "Orchard Gates"  then
		Tracker:FindObjectForCode("Orchard Middle Gate").Active = true
		Tracker:FindObjectForCode("Orchard Final Gate").Active = true
	elseif item_name == "Desert Doors"  then
		Tracker:FindObjectForCode("Desert Door to Flood Light Room").Active = true
		Tracker:FindObjectForCode("Desert Door to Pond Room").Active = true
		Tracker:FindObjectForCode("Desert Door to Water Levels Room").Active = true
		Tracker:FindObjectForCode("Desert Door to Elevator Room").Active = true
	elseif item_name == "Quarry Main Entry"  then
		Tracker:FindObjectForCode("Quarry Main Entry 1").Active = true
		Tracker:FindObjectForCode("Quarry Main Entry 2").Active = true
	elseif item_name == "Quarry Mill Shortcuts"  then
		Tracker:FindObjectForCode("Quarry Mill Side Door").Active = true
		Tracker:FindObjectForCode("Quarry Mill Rooftop Shortcut").Active = true
		Tracker:FindObjectForCode("Quarry Mill Stairs").Active = true
	elseif item_name == "Quarry Boathouse Barriers"  then
		Tracker:FindObjectForCode("Quarry Boathouse First Barrier").Active = true
		Tracker:FindObjectForCode("Quarry Boathouse Shortcut").Active = true
	elseif item_name == "Shadows Laser Room Door"  then
		Tracker:FindObjectForCode("Shadows Laser Room Right Door").Active = true
		Tracker:FindObjectForCode("Shadows Laser Room Left Door").Active = true
	elseif item_name == "Shadows Barriers"  then
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
	elseif item_name == "Monastery Entry Door"  then
		Tracker:FindObjectForCode("Monastery Inner Door").Active = true
		Tracker:FindObjectForCode("Monastery Outer Door").Active = true
	elseif item_name == "Monastery Shortcuts"  then
		Tracker:FindObjectForCode("Monastery Shortcut").Active = true
		Tracker:FindObjectForCode("Monastery Door to Garden").Active = true
	elseif item_name == "Town Tower Doors" then
		Tracker:FindObjectForCode("Town Tower Blue Panels Door").Active = true
		Tracker:FindObjectForCode("Town Tower Lattice Door").Active = true
		Tracker:FindObjectForCode("Town Tower Environmental Set Door").Active = true
		Tracker:FindObjectForCode("Town Tower Wooden Roof Set Door").Active = true
	elseif item_name == "Town Doors"  then
		Tracker:FindObjectForCode("Town Cargo Box Door").Active = true
		Tracker:FindObjectForCode("Town Wooden Roof Staircase").Active = true
		Tracker:FindObjectForCode("Town Tinted Door to RGB House").Active = true
		Tracker:FindObjectForCode("Town Door to Church").Active = true
		Tracker:FindObjectForCode("Town Maze Staircase").Active = true
		Tracker:FindObjectForCode("Town Windmill Door").Active = true
		Tracker:FindObjectForCode("Town RGB House Staircase").Active = true
	elseif item_name == "Theater Exit Door"  then
		Tracker:FindObjectForCode("Theater Exit Door Left").Active = true
		Tracker:FindObjectForCode("Theater Exit Door Right").Active = true
	elseif item_name == "Jungle & River Shortcuts"  then
		Tracker:FindObjectForCode("Jungle Bamboo Shortcut to River").Active = true
		Tracker:FindObjectForCode("River Shortcut to Monastery Garden").Active = true
	elseif item_name == "Bunker Doors"  then
		Tracker:FindObjectForCode("Bunker Bunker Entry Door").Active = true
		Tracker:FindObjectForCode("Bunker Tinted Glass Door").Active = true
		Tracker:FindObjectForCode("Bunker Door to Ultraviolet Room").Active = true
		Tracker:FindObjectForCode("Bunker Door to Elevator").Active = true
	elseif item_name == "Swamp Doors"  then
		Tracker:FindObjectForCode("Swamp Entry Door").Active = true
		Tracker:FindObjectForCode("Swamp Door to Broken Shapers").Active = true
		Tracker:FindObjectForCode("Swamp Platform Shortcut Door").Active = true
		Tracker:FindObjectForCode("Swamp Door to Rotated Shapers").Active = true
		Tracker:FindObjectForCode("Swamp Red Underwater Exit").Active = true
	elseif item_name == "Swamp Water Pumps"  then
		Tracker:FindObjectForCode("Swamp Cyan Water Pump").Active = true
		Tracker:FindObjectForCode("Swamp Red Water Pump").Active = true
		Tracker:FindObjectForCode("Swamp Blue Water Pump").Active = true
		Tracker:FindObjectForCode("Swamp Purple Water Pump").Active = true
	elseif item_name == "Treehouse Entry Doors"  then
		Tracker:FindObjectForCode("Treehouse First Door").Active = true
		Tracker:FindObjectForCode("Treehouse Second Door").Active = true
		Tracker:FindObjectForCode("Treehouse Beyond Yellow Bridge Door").Active = true
	elseif item_name == "Inside Mountain Second Layer Stairs & Doors"  then
		Tracker:FindObjectForCode("Inside Mountain Second Layer Staircase Near").Active = true
		Tracker:FindObjectForCode("Inside Mountain Second Layer Exit Door").Active = true
		Tracker:FindObjectForCode("Inside Mountain Second Layer Staircase Far").Active = true
	elseif item_name == "Inside Mountain Bottom Layer Doors to Caves"  then
		Tracker:FindObjectForCode("Inside Mountain Bottom Layer Rock").Active = true
		Tracker:FindObjectForCode("Inside Mountain Door to Secret Area").Active = true
	elseif item_name == "Caves Doors to Challenge"  then
		Tracker:FindObjectForCode("Caves Pillar Door").Active = true
		Tracker:FindObjectForCode("Challenge Entry Door").Active = true
	elseif item_name == "Caves Exits to Main Island"  then
		Tracker:FindObjectForCode("Caves Swamp Shortcut").Active = true
		Tracker:FindObjectForCode("Caves Mountain Shortcut").Active = true
	elseif item_name == "Theater Walkway Doors"  then
		Tracker:FindObjectForCode("Theater Walkway Door to Back of Theater").Active = true
		Tracker:FindObjectForCode("Theater Walkway Door to Desert Elevator Room").Active = true
		Tracker:FindObjectForCode("Theater Walkway Door to Town").Active = true
	end
end
	

function showGoal()
	Tracker:FindObjectForCode("Goal").CurrentStage = Tracker:FindObjectForCode("hiddenGoal").CurrentStage + 1
	Tracker:FindObjectForCode("boxShort").AcquiredCount = Tracker:FindObjectForCode("hiddenShort").AcquiredCount
	Tracker:FindObjectForCode("boxLong").AcquiredCount = Tracker:FindObjectForCode("hiddenLong").AcquiredCount
	print(Tracker:FindObjectForCode("Goal").CurrentStage, Tracker:FindObjectForCode("hiddenGoal").CurrentStage)
end


-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)