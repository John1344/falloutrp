PLUGIN.name = "Fallout Weapon Selector"
PLUGIN.author = "Lazarus, vin"
PLUGIN.desc = "Adds the classic Fallout 3/NV HUD."

nut.config.add("hCrossWhenWep", false, "hCrossWhenWepDesc", nil, {category = "visual"})

nut.util.include("cl_hud.lua")