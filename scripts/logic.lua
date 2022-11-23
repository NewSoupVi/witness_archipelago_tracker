function unrandomized_off()
	return 1 - Tracker:ProviderCountForCode("Unrandomized")
end

function isDoors(check)
	if check == "on" then
		result = (Tracker:ProviderCountForCode("doorsSimple") + Tracker:ProviderCountForCode("doorsComplex") + Tracker:ProviderCountForCode("doorsMax"))
	else
		result = (Tracker:ProviderCountForCode("doorsNo") + Tracker:ProviderCountForCode("doorsPanel")) 
	end 
	return result
end

function isLaserShuffle(check)
	if check == "on" then
		result = Tracker:ProviderCountForCode("shuffleLasers")
	else
		result = 1 - Tracker:ProviderCountForCode("shuffleLasers")
	end 
	return result
end

function isExpert(check)
	if check == "on" then
		result = Tracker:ProviderCountForCode("Expert")
	else
		result = 1 - Tracker:ProviderCountForCode("Expert")
	end 
	return result
end

function laserCount(amount)
	if Tracker:ProviderCountForCode("shuffleLasers") == 1 then
		result = Tracker:ProviderCountForCode("Symmetry Laser") + Tracker:ProviderCountForCode("Desert Laser") + Tracker:ProviderCountForCode("Quarry Laser") + Tracker:ProviderCountForCode("Shadows Laser") + Tracker:ProviderCountForCode("Keep Laser") + Tracker:ProviderCountForCode("Monastery Laser") + Tracker:ProviderCountForCode("Town Laser") + Tracker:ProviderCountForCode("Jungle Laser") + Tracker:ProviderCountForCode("Bunker Laser") + Tracker:ProviderCountForCode("Swamp Laser") + Tracker:ProviderCountForCode("Treehouse Laser")
	else
		tower = Tracker:FindObjectForCode("@Keep Tower/Laser Pressure Plates").AvailableChestCount + Tracker:FindObjectForCode("@Keep Tower/Laser Hedges").AvailableChestCount - 1
		if tower < 0 then tower = 0 end
		result = 11 - (Tracker:FindObjectForCode("@Symmetry Island/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Desert/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Quarry Laser/Laser").AvailableChestCount + tower + Tracker:FindObjectForCode("@Treehouse Laser House/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Swamp Laser/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Town Laser/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Monastery/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Shadows Laser/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Jungle Laser/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Color Bunker/Laser").AvailableChestCount)
	end
	Tracker:FindObjectForCode("lasers").AcquiredCount = result
	if tonumber(amount) > 0 then
		return(result >= tonumber(amount))
	else
		return false
	end
end
	
function laserBox(box)
	if box == "short" then
		return laserCount(tostring(Tracker:ProviderCountForCode("boxShort")))
	else
		return laserCount(tostring(Tracker:ProviderCountForCode("boxLong")))
	end
end

function hasPanel(panel)
	if Tracker:ProviderCountForCode("doorsNo") + Tracker:ProviderCountForCode("doorsSimple") + Tracker:ProviderCountForCode("doorsComplex") > 0 then return true
	else return Tracker:ProviderCountForCode(panel)
	end
end

function dots(level)
	return Tracker:FindObjectForCode("ProgressiveDots").CurrentStage >= tonumber(level)
end

function stars(level)
	return Tracker:FindObjectForCode("ProgressiveStars").CurrentStage >= tonumber(level)
end

function pp2()
	return true
end

function hasSymbol(symbol)
	if symbol == "Dots" then
		return dots(1)
	elseif symbol == "Full Dots" then
		return dots(2)
	elseif symbol == "Stars" then
		return stars(1)
	elseif symbol == "Stars + Same Colored Symbol" then
		return stars(2)
	elseif symbol == "Black/White Squares" then
		return Tracker:ProviderCountForCode("BWSquare") == 1
	elseif symbol == "Colored Squares" then
		return Tracker:ProviderCountForCode("ColoredSquares") == 1
	elseif symbol == "Symmetry" then
		return Tracker:ProviderCountForCode("Symmetry") == 1
	elseif symbol == "Colored Dots" then
		return Tracker:ProviderCountForCode("ColoredDots") == 1
	elseif symbol == "Sound Dots" then
		return Tracker:ProviderCountForCode("SoundDots") == 1
	elseif symbol == "Shapers" then
		return Tracker:ProviderCountForCode("Shapers") == 1
	elseif symbol == "Rotated Shapers" then
		return Tracker:ProviderCountForCode("RotatedShapers") == 1
	elseif symbol == "Negative Shapers" then
		return Tracker:ProviderCountForCode("NegativeShapers") == 1
	elseif symbol == "Eraser" then
		return Tracker:ProviderCountForCode("Eraser") == 1
	elseif symbol == "Triangles" then
		return Tracker:ProviderCountForCode("Triangles") == 1
	elseif symbol == "Arrows" then
		return Tracker:ProviderCountForCode("Arrows") == 1
	else
		return true
	end
end

function getLogicFile()
	if Tracker:ProviderCountForCode("Expert") == 1 then
		return "WitnessLogicExpert"
	else
		return "WitnessLogic"
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


function canSolve(ids)
	ids = parseIds(ids)
	require(getLogicFile())
	for id in ids:gmatch("%S+") do
		requiredSymbols = getLogic()[tonumber(id)]
		for k, v in pairs(requiredSymbols) do
			if(not hasSymbol(v)) then
				return false
			end
		end
	end
	return true
end