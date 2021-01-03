if ( SERVER ) then
    local firstTime

    function SCHEMA:PlayerLoadout(ply)
        firstTime = not firstTime
	    if ( not firstTime ) then return end

        netstream.Start(player.GetAll(), "forp_PlayerLoadout", ply)
    end
else
    netstream.Hook("forp_PlayerLoadout", function(ply)
        hook.Run("PlayerLoadout", ply)
    end)
end