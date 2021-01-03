--------------
--[[ INFO ]]--
--------------
SCHEMA.name = "Fallout: New Vegas"
SCHEMA.author = "SuperMicronde, vin, Trip, Otunga"
SCHEMA.desc = "An official NutScript schema"

-----------------------
--[[ GLOBAL TABLES ]]--
-----------------------
FO_AMB = FO_AMB or {} -- Ambience

------------------
--[[ INCLUDES ]]--
------------------
nut.util.includeDir("libs", nil, true)
nut.util.includeDir("meta", nil, true)
nut.util.includeDir("modules", nil, true)
nut.util.includeDir("hooks", nil, true)
nut.util.includeDir("derma", nil, true)

-----------------------
--[[ CONFIGURATION ]]--
-----------------------
nut.currency.set("","Cap", "Caps")

SCHEMA:DisablePlugin("doors")
SCHEMA:DisablePlugin("crosshair")
SCHEMA:DisablePlugin("storage")

SCHEMA:OverrideConfig("color", forp_amber)
SCHEMA:OverrideConfig("font", "Monofonto")

---------------
--[[ FILES ]]--
---------------
if ( SERVER ) then
resource.AddWorkshop( "891790188" ) -- Fallout 3 Custom Backpacks
resource.AddWorkshop( "203873185" ) -- Fallout Collection: Aid Props
end