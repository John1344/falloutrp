PLUGIN.name = "Lockpicking"
PLUGIN.author = "Cat.jpeg"
PLUGIN.desc = "Allows to pick locks with bobbypins"


PLUGIN.Config = {
    UnlockSize = 4,
    WeakSize = 40,
    UnlockMaxAngle = -90,
    HardMaxAngle = -30,
    TurningSpeed = 90,
    ReleasingSpeed = 200,
    SpamTime = 0.1,
	MaxLookDistance = 50,
	FadeTime = 4
}


-- Lockpick stop messages
PLUGIN.STOP_AFK = 1
PLUGIN.STOP_FAR = 2

PLUGIN.Messages = {
	"lpAfk",
	"lpTooFar"
}


nut.util.include("sv_plugin.lua")
nut.util.include("cl_plugin.lua")
nut.util.include("derma/cl_interface.lua")