Tracker:AddMaps("maps/maps.json")
Tracker:AddItems("items/items.json")

ScriptHost:LoadScript("scripts/logic.lua")
ScriptHost:LoadScript("scripts/archipelago.lua")

Tracker:AddLocations("locations/logic.json")
Tracker:AddLocations("locations/locations.json")
Tracker:AddLocations("locations/paths.json")
Tracker:AddLocations("locations/audioLogs.json")
Tracker:AddLocations("locations/easterEggs.json")

Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/settings.json")

Tracker.AllowDeferredLogicUpdate = true
