PLUGIN.name = "Looting"
PLUGIN.author = "SuperMicronde"
PLUGIN.desc = "Permits to search NPCs and players corpses."
PLUGIN.corpseMaxDist = 80 -- Max looking distance on a corpse

-- Includes
local dir = PLUGIN.folder.."/"

nut.util.includeDir(dir.."ragdolling", true, true)
nut.util.includeDir(dir.."looting", true, true)
nut.util.include("sv_ignored.lua")