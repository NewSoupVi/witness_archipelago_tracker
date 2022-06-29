function unrandomized_off()
	return 1 - Tracker:ProviderCountForCode("Unrandomized")
end

function laser_count(amount, trick)
	bwSquares = Tracker:ProviderCountForCode("BWSquare")
	coloredSquares = Tracker:ProviderCountForCode("ColoredSquares")
	dots = Tracker:ProviderCountForCode("Dots")
	coloredDots = Tracker:ProviderCountForCode("ColoredDots")
	soundDots = Tracker:ProviderCountForCode("SoundDots")
	eraser = Tracker:ProviderCountForCode("Eraser")
	triangles = Tracker:ProviderCountForCode("Triangles")
	stars = Tracker:ProviderCountForCode("Stars")
	starsSameColor = Tracker:ProviderCountForCode("StarSameColor")
	symmetry = Tracker:ProviderCountForCode("Symmetry")
	shapers = Tracker:ProviderCountForCode("Shapers")
	rotatedShapers = Tracker:ProviderCountForCode("RotatedShapers")
	negativeShapers = Tracker:ProviderCountForCode("NegativeShapers")
	unrandomizedOff = unrandomized_off()
	
	symmetryLaser = symmetry * coloredDots * dots
	desertLaser = 1
	shadowsLaser = (1 - unrandomizedOff) + unrandomizedOff * (bwSquares + triangles*dots + triangles*shapers)
	if shadowsLaser > 1 then
		shadowsLaser = 1
	end
	keepLaser = dots*bwSquares*coloredSquares*starsSameColor*stars*shapers*symmetry
	monasteryLaser = 1
	bunkerLaser = unrandomizedOff * (dots + triangles) + (1 - unrandomizedOff) * (bwSquares*coloredSquares)
	if bunkerLaser > 1 then
		bunkerLaser = 1
	end
	swampLaser = shapers*rotatedShapers*negativeShapers
	quarryLaser = dots*(bwSquares + trick)*coloredSquares*eraser*shapers*stars*starsSameColor
	if quarryLaser > 1 then
		quarryLaser = 1
	end
	treehouseLaser = stars*starsSameColor*bwSquares*dots*coloredSquares
	
	townLaser = dots*stars*rotatedShapers*shapers*eraser*symmetry*bwSquares
	if townLaser > 1 then
		townLaser = 1
	end
	
	jungleLaser = soundDots
	
	amountGotten = symmetryLaser + desertLaser + shadowsLaser + keepLaser + monasteryLaser + bunkerLaser + swampLaser + quarryLaser + treehouseLaser + townLaser + jungleLaser
	
	if amountGotten >= amount + 0 then
		return 1
	end
	return shadowsLaser
end
	