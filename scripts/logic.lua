function isNotDoors()
	return (Tracker:ProviderCountForCode("doorsNo") + Tracker:ProviderCountForCode("doorsPanel") > 0) 
end

function isNotPanelsOnly()
	return (1 - Tracker:ProviderCountForCode("doorsPanel") > 0)
end

function isNotExpert(check)
	return (1 - Tracker:ProviderCountForCode("Expert") > 0)
end

function isNotLaserShuffle()
	return (1 - Tracker:ProviderCountForCode("shuffleLasers") > 0)
end

function isNotAutoElevators()
	return (1 - Tracker:ProviderCountForCode("autoElevators") > 0)
end

function unrandomizedDisabled()
	return (Tracker:ProviderCountForCode("Unrandomized") == 0)
end

function unrandomizedDisabledButSolvable()
	return (unrandomizedDisabled() and Tracker:ProviderCountForCode("disabledPanelsEnabled") > 0)
end

function longBoxWithoutMountainEntry()
	return (Tracker:ProviderCountForCode("boxLong") < 8 or Tracker:ProviderCountForCode("boxShort") > 7)
end

function showPartialSidesOrSolvableSide(side)
	if Tracker:ProviderCountForCode("partialSides") > 0 then
		return true
	end
	local eval = true
	for _, k in pairs(OBELISK_MAPPING[tonumber(side)]) do
		local loc = EP_DATASTORAGE_IDS[tonumber(k)][1]
		if loc then
			local location = Tracker:FindObjectForCode(loc)
			if location then
				eval = (location.AccessibilityLevel > 4 or Tracker:ProviderCountForCode("showSnipes") > 0 and location.AccessibilityLevel > 3)
			end
			if not eval then
				return eval
			end
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

function laserBox(box)
	if box == "short" then
		return Tracker:ProviderCountForCode("laserLatches")>=Tracker:ProviderCountForCode("boxShort") and Tracker:ProviderCountForCode("boxShort") > 0
	elseif box == "long" then
		return Tracker:ProviderCountForCode("laserLatches")>=Tracker:ProviderCountForCode("boxLong") and Tracker:ProviderCountForCode("boxLong") > 0
	elseif box == "elevator" then
		return Tracker:ProviderCountForCode("lasers")>=Tracker:ProviderCountForCode("boxShort") and Tracker:ProviderCountForCode("boxShort") > 0
	elseif box == "challenge" then
		return Tracker:ProviderCountForCode("lasers")>=Tracker:ProviderCountForCode("boxLong") and Tracker:ProviderCountForCode("boxLong") > 0
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

function Snipeable(difficulty)
	return Tracker:FindObjectForCode("snipesDifficulty").CurrentStage >= tonumber(difficulty)
end

function Foreknowable(difficulty)
	return Tracker:FindObjectForCode("Foreknowledge").CurrentStage >= tonumber(difficulty)
end

function Warp(location)
	if location == "First Hallway" or location == "First Hallway Room" or location == "Tutorial" then return true
	else return false
	end
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

function pp2()
	
	return (isNotExpert() or (isNotDoors() and canSolve("158198 158200 158202 158204")) or
	(
	Tracker:ProviderCountForCode("Keep Pressure Plates 1 Exit Door") == 1 and
	Tracker:ProviderCountForCode("Keep Pressure Plates 3 Exit Door") == 1 and
	(Tracker:ProviderCountForCode("Keep Shortcut to Shadows") == 1 or
	(Tracker:ProviderCountForCode("Keep Pressure Plates 4 Exit Door") == 1 and
	(Tracker:ProviderCountForCode("Keep Tower Shortcut") == 1 or
	(Tracker:ProviderCountForCode("Keep Hedge Maze 4 Exit Door") == 1 and
	(Tracker:ProviderCountForCode("Keep Hedge Maze 4 Shortcut") == 1 or
	(Tracker:ProviderCountForCode("Keep Hedge Maze 3 Exit Door") == 1 and
	(Tracker:ProviderCountForCode("Keep Hedge Maze 3 Shortcut") == 1 or
	(Tracker:ProviderCountForCode("Keep Hedge Maze 2 Exit Door") == 1 and
	(Tracker:ProviderCountForCode("Keep Hedge Maze 2 Shortcut") == 1 or
	(Tracker:ProviderCountForCode("Keep Hedge Maze 1 Exit Door") == 1))))))))))))

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
	else
		return true
	end
end

function getLogicFile()
	if Tracker:ProviderCountForCode("Expert") == 1 then
		return "WitnessLogicExpert"
	elseif Tracker:ProviderCountForCode("randomizationSigma") == 1 then
		return "WitnessLogic"
	else
		return "WitnessLogicVanilla"
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

require(getLogicFile())
function canSolve(ids)
	if Tracker:ProviderCountForCode("Symbols") == 0 or isClearing() then
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
