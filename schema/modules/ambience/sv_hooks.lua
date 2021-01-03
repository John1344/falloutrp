hook.Add( "PlayerDeath", "AmbienceDeath", function( victim, inflictor, attacker )
	netstream.Start(victim, "ambienceDeath")
end)