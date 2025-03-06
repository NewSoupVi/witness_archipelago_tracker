function isNotDoors()
	return (Tracker:ProviderCountForCode("doorsNo") + Tracker:ProviderCountForCode("doorsPanel") > 0) 
end

function isNotPanels()
	return (Tracker:ProviderCountForCode("doorsNo") + Tracker:ProviderCountForCode("doorsDoor") > 0)
end

function isNotPanelsOnly()
	return (1 - Tracker:ProviderCountForCode("doorsPanel") > 0)
end

function isNotVanilla()
	return (1 - Tracker:ProviderCountForCode("randomizationVanilla") > 0)
end

function isNotVariety()
	return (1 - Tracker:ProviderCountForCode("Variety") > 0)
end

function isNotExpert()
	return (1 - Tracker:ProviderCountForCode("Expert") > 0)
end

function isVanillaOrNormal()
	return (Tracker:ProviderCountForCode("randomizationVanilla") + Tracker:ProviderCountForCode("randomizationSigma") > 0)
end

function isVanillaOrVariety()
	return (Tracker:ProviderCountForCode("randomizationVanilla") + Tracker:ProviderCountForCode("Variety") > 0)
end

function isVanillaOrExpert()
	return (Tracker:ProviderCountForCode("randomizationVanilla") + Tracker:ProviderCountForCode("Expert") > 0)
end

function isNormalOrVariety()
	return (Tracker:ProviderCountForCode("randomizationSigma") + Tracker:ProviderCountForCode("Variety") > 0)
end

function isVarietyOrExpert()
	return (Tracker:ProviderCountForCode("Variety") + Tracker:ProviderCountForCode("Expert") > 0)
end

function isNotLaserShuffle()
	return (1 - Tracker:ProviderCountForCode("shuffleLasers") > 0)
end

function isNotAutoSwampLongBridge()
	return (1 - Tracker:ProviderCountForCode("autoSwampLongBridge") > 0)
end

function unrandomizedDisabled()
	return (Tracker:ProviderCountForCode("Unrandomized") == 0)
end

function unrandomizedDisabledButSolvable()
	return (unrandomizedDisabled() and Tracker:ProviderCountForCode("disabledPanelsEnabled") > 0)
end

function isNotDeathLink()
	return (1 - Tracker:ProviderCountForCode("deathLink") > 0)
end

function deathAvoidableOrUnimportant()
	return isNotDeathLink() or (Tracker:ProviderCountForCode("randomizationVanilla") > 0)
end

function isNotPanelHunt()
	return (1 - Tracker:ProviderCountForCode("panelHunt") > 0)
end

function canPanelHuntGoal()
	return Tracker:FindObjectForCode("panelHuntCount").AcquiredCount >= Tracker:FindObjectForCode("panelHuntRequired").AcquiredCount
end

function longBoxWithoutMountainEntry()
	return (Tracker:ProviderCountForCode("boxLong") < 8 or Tracker:ProviderCountForCode("boxShort") > 7 or Tracker:ProviderCountForCode("panelHunt") + Tracker:ProviderCountForCode("shortboxOff") > 1 and Tracker:ProviderCountForCode("boxLong") > 7)
end

function showPartialSidesOrSolvableSide(side)
	if Tracker:ProviderCountForCode("partialSides") > 0 then
		return true
	end
	local eval = true
	local showSnipes = Tracker:ProviderCountForCode("showSnipes") > 0
	for _, k in pairs(OBELISK_MAPPING[tonumber(side)]) do
		local locationAccessibility = Tracker:FindObjectForCode(EP_DATASTORAGE_IDS[tonumber(k)][1]).AccessibilityLevel
		eval = (locationAccessibility == AccessibilityLevel.Normal or showSnipes and locationAccessibility == AccessibilityLevel.SequenceBreak)
		if not eval then
			return eval
		end
	end
	return eval
end

function isDisabled(id)
	return disabledDict[tonumber(id)]
end

function isNotDisabled(id)
	return not disabledDict[tonumber(id)]
end

function anyIsNotDisabled(ids)
	local eval = false
	ids = parseIds(ids)
	for id in ids:gmatch("%S+") do
		eval = isNotDisabled(id)
		if eval then
			return eval
		end
	end
	return eval
end

function hasAllLasers()
	return Tracker:ProviderCountForCode("lasers") >= 11
end

function hasAllLasersAndRedirect()
	return Tracker:ProviderCountForCode("laserLatches") >= 11
end

function laserBox(box)
	if box == "short" then
		return (hasAllLasersAndRedirect()
		or Tracker:ProviderCountForCode("laserLatches") >= Tracker:ProviderCountForCode("boxShort") and Tracker:ProviderCountForCode("boxShort") > 0)
	elseif box == "long" then
		return (hasAllLasersAndRedirect()
		or Tracker:ProviderCountForCode("laserLatches") >= Tracker:ProviderCountForCode("boxLong") and Tracker:ProviderCountForCode("boxLong") > 0)
	elseif box == "elevator" then
		return (hasAllLasers()
		or Tracker:ProviderCountForCode("lasers") >= Tracker:ProviderCountForCode("boxShort") and Tracker:ProviderCountForCode("boxShort") > 0)
	elseif box == "challenge" then
		return (hasAllLasers()
		or Tracker:ProviderCountForCode("lasers") >= Tracker:ProviderCountForCode("boxLong") and Tracker:ProviderCountForCode("boxLong") > 0)
	end
end

function hasPanel(panel)
	if Tracker:ProviderCountForCode("doorsNo") + Tracker:ProviderCountForCode("doorsDoor") > 0 then return true
	else return (Tracker:ProviderCountForCode(panel) > 0)
	end
end

function hasObeliskKey(key)
	if Tracker:ProviderCountForCode("obeliskKeys") == 0 then return true
	else return (Tracker:ProviderCountForCode(string.format("%s %s", key, "Obelisk Key")) > 0)
	end
end

function isNotPanelsOnlyOrHasPanel(panel)
	return isNotPanelsOnly() or hasPanel(panel)
end

function eggs(number)
	if (Tracker:ProviderCountForCode("eggsOff") > 0) then
		return false
	end
	local count = 0
	local countWithSnipes = 0
	local requiredCount = 0
	local showSnipes = (Tracker:ProviderCountForCode("showSnipes") > 0)

	if (Tracker:ProviderCountForCode("easyEggs") > 0) then
		requiredCount = tonumber(number) * 8 / 3
	elseif (Tracker:ProviderCountForCode("normalEggs") > 0) then
		requiredCount = tonumber(number) * 6 / 3
	elseif (Tracker:ProviderCountForCode("hardEggs") > 0) then
		requiredCount = tonumber(number) * 6 / 4
	elseif (Tracker:ProviderCountForCode("veryHardEggs") > 0) then
		requiredCount = tonumber(number) * 5 / 4
	else -- extremeEggs
		requiredCount = tonumber(number)
	end

	if requiredCount > EGG_TOTAL then
		return AccessibilityLevel.Inspect
	end

	for key, val in pairs(EASTER_EGG_DATASTORAGE_IDS) do
		if isNotDisabled(key) then
			local locationAccessibility = Tracker:FindObjectForCode(val[1]).AccessibilityLevel
			if (locationAccessibility == AccessibilityLevel.Normal or locationAccessibility == AccessibilityLevel.Cleared) then
				count = count + 1
				if count >= requiredCount then
					return AccessibilityLevel.Normal
				end
				countWithSnipes = countWithSnipes + 1
			elseif (showSnipes and locationAccessibility == AccessibilityLevel.SequenceBreak) then
				countWithSnipes = countWithSnipes + 1
			end
		end
	end
	if count >= requiredCount then
		return AccessibilityLevel.Normal
	end
	if countWithSnipes >= tonumber(number) then
		return AccessibilityLevel.SequenceBreak
	end
	return AccessibilityLevel.None
end

function eggloc(number)
	if (Tracker:ProviderCountForCode("eggsOff") > 0 or tonumber(number) > EGG_TOTAL) then
		return false
	end
	return tonumber(number) % EGG_STEP == 0
end

function isNormalHardOrVeryHardEggs()
	return (Tracker:ProviderCountForCode("normalEggs") + Tracker:ProviderCountForCode("hardEggs") + Tracker:ProviderCountForCode("veryHardEggs") > 0)
end

function eggGroupAccess(region, total)
	if (Tracker:ProviderCountForCode("eggsOff") > 0) then
		return AccessibilityLevel.Cleared
	end
	local snipe = false
	local inaccessible = false
	for eggNumber = 1, total do
		local accessibility = Tracker:FindObjectForCode("@" .. region .. " Area/Egg " .. eggNumber).AccessibilityLevel
		if accessibility == AccessibilityLevel.Normal then
			return AccessibilityLevel.Normal
		end
		if accessibility == AccessibilityLevel.SequenceBreak then
			snipe = true
		elseif accessibility == AccessibilityLevel.None then
			inaccessible = true
		end
	end
	if snipe == true then
		return AccessibilityLevel.SequenceBreak
	end
	if inaccessible == true then
		return AccessibilityLevel.None
	end
	local eggGroup = Tracker:FindObjectForCode("@" .. region .. " Area/Eggs")
	eggGroup.AvailableChestCount = eggGroup.AvailableChestCount - 1
	return AccessibilityLevel.Cleared
end

function dots(level)
	return Tracker:FindObjectForCode("ProgressiveDots").CurrentStage >= tonumber(level)
end

function stars(level)
	return Tracker:FindObjectForCode("ProgressiveStars").CurrentStage >= tonumber(level)
end

function symmetry(level)
	return Tracker:FindObjectForCode("ProgressiveSymmetry").CurrentStage >= tonumber(level)
end

function expertPP2()
	return (
	Tracker:ProviderCountForCode("Keep Pressure Plates 1 Exit (Door)") == 1 and
	Tracker:ProviderCountForCode("Keep Pressure Plates 3 Exit (Door)") == 1 and
	(Tracker:ProviderCountForCode("Keep Shadows Shortcut (Door)") == 1 or
	(Tracker:ProviderCountForCode("Keep Pressure Plates 4 Exit (Door)") == 1 and
	(Tracker:ProviderCountForCode("Keep Tower Shortcut (Door)") == 1 or
	(Tracker:ProviderCountForCode("Keep Hedge Maze 4 Exit (Door)") == 1 and
	(Tracker:ProviderCountForCode("Keep Hedge Maze 4 Shortcut (Door)") == 1 or
	(Tracker:ProviderCountForCode("Keep Hedge Maze 3 Exit (Door)") == 1 and
	(Tracker:ProviderCountForCode("Keep Hedge Maze 3 Shortcut (Door)") == 1 or
	(Tracker:ProviderCountForCode("Keep Hedge Maze 2 Exit (Door)") == 1 and
	(Tracker:ProviderCountForCode("Keep Hedge Maze 2 Shortcut (Door)") == 1 or
	(Tracker:ProviderCountForCode("Keep Hedge Maze 1 Exit (Door)") == 1))))))))))
	)
end

symbolCheck = {
	["Black/White Squares"] = "BWSquare",
	["Colored Squares"] = "ColoredSquares",
	["Sound Dots"] = "SoundDots",
	["Shapers"] = "Shapers",
	["Rotated Shapers"] = "RotatedShapers",
	["Negative Shapers"] = "NegativeShapers",
	["Eraser"] = "Eraser",
	["Triangles"] = "Triangles",
	["Arrows"] = "Arrows"
}

function hasSymbol(symbol)
	if symbol == "Dots" then
		return dots(1)
	elseif symbol == "Full Dots" then
		return dots(2)
	elseif symbol == "Stars" then
		return stars(1)
	elseif symbol == "Stars + Same Colored Symbol" then
		return stars(2)
	elseif symbol == "Symmetry" then
		return symmetry(1)
	elseif symbol == "Colored Dots" then
		return symmetry(2)
	elseif symbolCheck[symbol] ~= nil then
		return Tracker:ProviderCountForCode(symbolCheck[symbol]) == 1
	elseif symbol == "True" then
		return true
	else
		print("Invalid Symbol:", symbol)
		return false
	end
end

function getLogicFile()
	if Tracker:ProviderCountForCode("Expert") == 1 then
		return "scripts/WitnessLogicExpert.lua"
	elseif Tracker:ProviderCountForCode("randomizationSigma") == 1 then
		return "scripts/WitnessLogic.lua"
	elseif Tracker:ProviderCountForCode("Variety") == 1 then
		return "scripts/WitnessLogicVariety.lua"
	elseif Tracker:ProviderCountForCode("randomizationVanilla") == 1 then
		return "scripts/WitnessLogicVanilla.lua"
	end
end

function parseIds(ids)
	dash = string.find(ids, "-")
	if not dash then
		return ids
	else
		output = ""
		for i = tonumber(string.sub(ids, 1, dash-1)), tonumber(string.sub(ids, dash+1, -1)), 1 do
			output = output .. i .. " "
		end
		return string.sub(output, 1, -2)
	end
end

ScriptHost:LoadScript(getLogicFile())
function canSolve(ids)
	if Tracker:ProviderCountForCode("Symbols") == 0 then
		return true
	end
	ids = parseIds(ids)
	for id in ids:gmatch("%S+") do
		requiredSymbols = panel[tonumber(id)]
		for k, v in pairs(requiredSymbols) do
			if(not hasSymbol(v)) then
				return false
			end
		end
	end
	return true
end
