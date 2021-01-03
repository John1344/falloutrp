--[[ Equip/Unequip a clothe item ]]--

clothes.Items = clothes.Items or {}

function clothes.WearItem(ply, item, firstTime, dontShare)

    local slot = item.Type

    if ( !clothes.Items[ply:UserID()] ) then
        clothes.Items[ply:UserID()] = {}
    end

    clothes.Items[ply:UserID()][slot] = item

    // Run a different code on server and client
    clothes.OnItemWeared(ply, item, firstTime, dontShare)

end

function clothes.TakeItem(ply, item, firstTime, dontShare)

    local clothe = item.ClotheInfo
    local slot = item.Type

    clothes.Items[ply:UserID()][slot] = nil

    // Run a different code on server and client
    clothes.OnItemTaken(ply, item, firstTime, dontShare)

end



--[[ Get the current clothes of a player ]]--

function clothes.GetItems(ply)

    return clothes.Items[ply:UserID()] or {}
    
end

function clothes.GetItem(ply, slot)

    return clothes.GetItems(ply)[slot]

end



--[[ Load all equipped clothes when a player load a character ]]--

function clothes.ItemLoadout(ply, items)

    if (ply:getChar()) then

        for k, item in pairs(clothes.GetItems(ply)) do
            clothes.TakeItem(ply, item, false, true)
        end

        if (SERVER) then

            itemIds = {}
            for k, v in pairs(ply:getChar():getInv():getItems()) do
                if v:IsClothing() && v:getData("equip") then
                    clothes.WearItem(ply, v, false, true)

                    itemIds[#itemIds + 1] = v:getID()
                end
            end

            netstream.Start(player.GetAll(), "lClt", ply:UserID(), itemIds)
        else
            for k, v in pairs(clothes.GetEnts(ply)) do
                clothes.RemoveEnt(ply, k)
            end

            for k, v in pairs(items) do
                v = nut.item.instances[v]

                if (v) then
                    if v:IsClothing() && v:getData("equip") then
                        clothes.WearItem(ply, v, false)
                    end
                end
            end

            clothes.Fix(ply)
        end

    end
    
end