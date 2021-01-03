--[[ Util ]]--

function clothes.findArms(ent, model)

    local gender = ent:GetGender()

    if ( type(model) == "string" )  then

        if ( file.Exists(model.."arms/", "GAME") ) then
            return model.."arms/"..gender.."_arm.mdl"
        end

    else

        if ( model[3] && file.Exists(model[3], "GAME") ) then
            return model[3]..gender.."_arm.mdl"
        end

    end

end

function clothes.findModel(ent, mdl)

    local gender = ent:GetGender()

    if ( type(mdl) == "string" )  then

        if (string.find(mdl, ".mdl")) then
            return mdl
        else
            return mdl..gender..".mdl"
        end

    else

        local g
        if ( gender == "male" ) then g = 1 else g = 2 end
        
        return mdl[g]

    end

end



--[[ Equip/Unequip a clothe item ]]--

function clothes.OnItemWeared(ply, item, firstTime, dontShare)

    local clothe = item.ClotheInfo
    local slot = item.Type
    local ent = clothes.MakeEnt(ply, slot, clothe.mdl, clothe.skin, clothe.bg, clothe.attach)

    if (IsValid(ent)) then
        local arms = clothes.findArms(ply, clothe.mdl)
        if (arms) then
            clothes.MakeEnt(ply, "Arms", arms, ply:GetSkinTone())
        end
    end

    clothes.Fix(ply)

    if (firstTime) then
        ply:EmitSound("fosounds/fix/ui_items_generic_up_01.mp3")
    end

end

function clothes.OnItemTaken(ply, item, firstTime, dontShare)

    local slot = item.Type
    clothes.RemoveEnt(ply, slot)
    clothes.Fix(ply)

    if (firstTime) then
        ply:EmitSound("fosounds/fix/ui_items_generic_down.mp3")
    end

end



--[[ Clothe entites ]]--

function clothes.MakeEnt(entity, slot, mdl, skin, bg, attach)
    local gender = entity:GetGender()

    clothes.RemoveEnt(entity, slot)

    local m = ClientsideModel( clothes.findModel(entity, mdl), RENDERGROUP_OPAQUE )

    if ( !IsValid(m) ) then return end

    if ( attach ) then
        local boneId = entity:LookupBone( attach.bone )
        if ( !boneId ) then return end

        m:FollowBone(entity, boneId)
        m:SetLocalPos(attach.pos)
        m:SetLocalAngles(attach.ang)
    else
        m:InvalidateBoneCache()
        m:SetParent( entity )

        entity.nextClotheId = (entity.nextClotheId or 0) + 1
        entity:CallOnRemove("clothe"..entity.nextClotheId, function(ent)
            m:Remove()
        end)

        m:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL,EF_PARENT_ANIMATES))
        m:SetupBones()
    end

    if ( bg ) then
        m:SetBodygroup(bg[1], bg[2])
    end

    m:SetSkin(skin or 0)

    function m:Think()
        
        local parent = self:GetParent()
        local slotUsed = self.ClotheInfo.slot

        if( parent:IsValid() ) then

            if (parent:IsPlayer() && parent:getChar()) then

                if (parent:Alive()) then
                    self.hasSpawned = true
                elseif (self.hasSpawned) then
                    clothes.RemoveEnt(parent, slotUsed)
                end

            end

            local noDraw = parent:GetNoDraw()
            if ( noDraw != self.LastDrawState ) then
                self:SetNoDraw( noDraw )
            end
            self.LastDrawState = noDraw

        end

    end
    hook.Add("Think", m, m.Think)

    m.ClotheInfo = {
        slot = slot,
        mdl = mdl,
        skin = skin,
        bg = bg,
        attach = attach
    }

    if ( !entity.Clothes ) then
        entity.Clothes = {}
    end
    entity.Clothes[slot] = m

    return m
end

function clothes.RemoveEnt(entity, slot)
    if (!entity.Clothes) then return end

    if (entity.Clothes[slot]) then
        entity.Clothes[slot]:Remove()
        entity.Clothes[slot] = nil
    end
end

function clothes.GetEnts(entity)
    return entity.Clothes or {}
end

function clothes.GetEnt(entity, slot)
    return clothes.GetEnts(entity)[slot]
end



--[[ Make the clothing realistic and show the player topless ]]--

function clothes.Fix(entity)
    if (!clothes.GetEnt(entity, "Suit")) then
        local ent = clothes.MakeEnt(entity, "Suit", "models/thespireroleplay/humans/group100/")

        if (IsValid(ent)) then
            local arms = clothes.findArms(entity, "models/thespireroleplay/humans/group100/")
            if (arms) then
                clothes.MakeEnt(entity, "Arms", arms, entity:GetSkinTone())
            end
        end
    end

    if (clothes.GetEnt(entity, "Hat") or clothes.GetEnt(entity, "Helmet") or clothes.GetEnt(entity, "Fullhat")) then
		if (entity:GetGender() == "female") then
			entity:SetBodygroup(2, 10)
		else
			entity:SetBodygroup(2, 4)
		end
    else
        entity:SetBodygroup(2, entity:getChar():getData("hair") or 1)
    end
end



--[[ Networking ]]--

-- Call Player:WearCltItem()
netstream.Hook("wClt", function(userId, item)
    local ply = Player(userId)

    if ( IsValid(ply) ) then
        item = nut.item.instances[item]

        if (item) then
            clothes.WearItem(ply, item, true)
        end
    end
end)

-- Call Player:TakeCltItem()
netstream.Hook("tClt", function(userId, item)
    local ply = Player(userId)

    if ( IsValid(ply) ) then
        item = nut.item.instances[item]

        if (item) then
            clothes.TakeItem(ply, item, true)
        end
    end
end)

-- Call Player:CltLoadout()
netstream.Hook("lClt", function(userId, items)
	local ply = Player(userId)

    if ( IsValid(ply) ) then
        clothes.ItemLoadout(ply, items)
    end
end)

-- Load all equipped clothes when a player load a character
netstream.Hook("aClt", function(clothing)
	for k, v in pairs(clothing) do

        local ply = Player(k)

        if ( IsValid(ply) ) then
            for k2, v2 in pairs(v) do
                v2 = nut.item.instances[v2]

                if (v2) then
                    clothes.WearItem(ply, v2, false)
                end
            end
        end
	end
end)



--[[ Display clothing in Nutscript UI (Scoreboard...) ]]--

function clothes.Clone(from, to)
    if (!clothes.GetEnts(from)) then return end

    for k, v in pairs(clothes.GetEnts(to)) do
        clothes.RemoveEnt(to, k)
    end

    for k, v in pairs(clothes.GetEnts(from)) do
        local info = v.ClotheInfo
        clothes.MakeEnt(to, info.slot, info.mdl, info.skin, info.bg, info.attach)
    end
end

function PLUGIN:DrawNutModelView(panel, ent)

    // Check that the ModelPanel drawn is in the F1 menu
    if ( IsValid(nut.gui.info) && nut.gui.info.model == panel ) then

        if (!panel.ClotheSet) then

            clothes.Clone(LocalPlayer(), ent)

            panel.OnRemove = function()
                for k, v in pairs(clothes.GetEnts(ent)) do
                    clothes.RemoveEnt(ent, k)
                end
            end

            panel.ClotheSet = true
        end

        for k, v in pairs(clothes.GetEnts(ent)) do
            v:DrawModel()
        end

    end

end

function PLUGIN:ShouldAllowScoreboardOverride(client, var)

    local slot = client.nutScoreSlot

    if (IsValid(slot)) then

        local mPanel = slot.model

        if (IsValid(mPanel)) then

            local entity = mPanel.Entity

            if (IsValid(entity)) then

                clothes.Clone(client, entity)

                mPanel.PostDrawModel = function()
                    for k, v in pairs(clothes.GetEnts(entity)) do
                        v:DrawModel()
                    end
                end

                mPanel.OnRemove = function()
                    for k, v in pairs(clothes.GetEnts(entity)) do
                        clothes.RemoveEnt(entity, k)
                    end
                end

            end

        end

    end

end