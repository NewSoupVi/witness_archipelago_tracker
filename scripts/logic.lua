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

function laserCount(amount)
	if Tracker:ProviderCountForCode("shuffleLasers") == 1 then
		result = Tracker:ProviderCountForCode("Symmetry Laser") + Tracker:ProviderCountForCode("Desert Laser") + Tracker:ProviderCountForCode("Quarry Laser") + Tracker:ProviderCountForCode("Shadows Laser") + Tracker:ProviderCountForCode("Keep Laser") + Tracker:ProviderCountForCode("Monastery Laser") + Tracker:ProviderCountForCode("Town Laser") + Tracker:ProviderCountForCode("Jungle Laser") + Tracker:ProviderCountForCode("Bunker Laser") + Tracker:ProviderCountForCode("Swamp Laser") + Tracker:ProviderCountForCode("Treehouse Laser")
	else
		tower = Tracker:FindObjectForCode("@Keep Tower/Laser Pressure Plates").AvailableChestCount + Tracker:FindObjectForCode("@Keep Tower/Laser Hedges").AvailableChestCount - 1
		if tower < 0 then tower = 0 end
		result = 11 - (Tracker:FindObjectForCode("@Symmetry Island/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Desert/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Quarry Laser/Laser").AvailableChestCount + tower + Tracker:FindObjectForCode("@Treehouse Laser House/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Swamp Laser/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Town Laser/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Monastery/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Shadows Laser/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Jungle Laser/Laser").AvailableChestCount + Tracker:FindObjectForCode("@Color Bunker/Laser").AvailableChestCount)
	end
	Tracker:FindObjectForCode("lasers").AcquiredCount = result
	return(result >= tonumber(amount))
end
	