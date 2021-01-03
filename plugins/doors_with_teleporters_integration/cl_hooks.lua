foscTeleported = false

// Hide nutscript hud when we use a door
netstream.Hook("nut_Teleporting", function(teleport)
	foscTeleported = !teleport
end)

hook.Add("ShouldHideBars", "Hide_bars_when_teleporting", function()
	return foscTeleported -- Hide bars when teleporting
end)