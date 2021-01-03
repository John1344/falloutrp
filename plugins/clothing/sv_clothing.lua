--[[ Equip/Unequip a clothe item ]]--

function clothes.OnItemWeared(ply, item, firstTime, dontShare)
    // Call Player:WearCltItem() at clients
    if (!dontShare) then
        netstream.Start(player.GetAll(), "wClt", ply:UserID(), item:getID())
    end

end

function clothes.OnItemTaken(ply, item, firstTime, dontShare)
    // Call Player:TakeCltItem() at clients
    if (!dontShare) then
        netstream.Start(player.GetAll(), "tClt", ply:UserID(), item:getID())
    end

end


--[[ Load all equipped clothes when a player load a character ]]--

function PLUGIN:PlayerSpawn(ply)
    clothes.ItemLoadout(ply)
end



--[[ Send all the clothes when a player spawn on the server ]]--

function PLUGIN:PlayerInitialSpawn(ply)
	netstream.Hook(ply, "aClt", clothes.Items)
end
