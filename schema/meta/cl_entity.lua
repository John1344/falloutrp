local Entity = FindMetaTable( "Entity" )


------------------------------------
--[[ Get unique id of an entity ]]--
------------------------------------
SCHEMA.NextEntId = SCHEMA.NextEntId or 0

hook.Add("OnEntityCreated", "forp_ClientsideEntId", function(entity)
    SCHEMA.NextEntId = SCHEMA.NextEntId + 1
    entity.forp_EntId = SCHEMA.NextEntId
end)

function Entity:forp_GetId()
    return self.forp_EntId
end



------------------------------------
--[[ Delete an entity on remove ]]--
------------------------------------
function Entity:forp_DeleteOnRemove(otherEnt)
    self:CallOnRemove("forp_DelEnt_"..otherEnt:forp_GetId(), function()
        if ( IsValid(otherEnt) ) then
            otherEnt:Remove()
        end
    end)
end



-----------------------------------
--[[ Add GM: hooks on entities ]]--
-----------------------------------
function Entity:forp_AddHook(eventName, eventId, func)
    local id = "forp_Ent_"..self:forp_GetId()..eventId

    self.forp_Hooks = self.forp_Hooks or {}
    self.forp_Hooks[eventName] = self.forp_Hooks[eventName] or {}
    self.forp_Hooks[eventName][id] = true

    local ent = self
    hook.Add(eventName, id, function(...)
        func(ent, ...)
    end)
end

hook.Add("EntityRemoved", "forp_RemoveEntHooks", function(ent)
    local hooks = ent.forp_Hooks
    if ( hooks ) then
        for k, v in pairs(hooks) do
            for k2, _ in pairs (v) do
                hook.Remove(k, k2)
            end
        end
    end
end)



-----------------------------------
--[[ Attach models to entities ]]--
-----------------------------------
function Entity:forp_BonemergeAttach(mdl)
    local m = ClientsideModel( mdl, RENDERGROUP_OPAQUE )
    if ( not IsValid(m) ) then return end

    m:InvalidateBoneCache()
    m:SetParent( self )
    m:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL,EF_PARENT_ANIMATES))
    m:SetupBones()
    self:forp_DeleteOnRemove(m)

    function m:NoDrawCheck()
        local p = self:GetParent()

        if ( p:IsValid() ) then
            local noDraw = p:GetNoDraw()
            if ( noDraw ~= self.forp_LastDrawState ) then
                self:SetNoDraw( noDraw )
            end
            self.forp_LastDrawState = noDraw
        end
    end
    m:forp_AddHook("Think", "NoDrawCheck", m.NoDrawCheck)

    return m
end

function Entity:forp_BoneAttach(mdl, bone, pos, ang)
    local m = ClientsideModel( mdl, RENDERGROUP_OPAQUE )
    if ( not IsValid(m) ) then return end

    local id = self:LookupBone( bone )
    if ( not id ) then return end
    m:FollowBone(self, id)
    m:SetLocalPos(pos or Vector())
    m:SetLocalAngles(ang or Angle())

    function m:NoDrawCheck()
        local p = self:GetParent()

        if ( p:IsValid() ) then
            local noDraw = p:GetNoDraw()
            if ( noDraw ~= self.forp_LastDrawState ) then
                self:SetNoDraw( noDraw )
            end
            self.forp_LastDrawState = noDraw
        end
    end
    m:forp_AddHook("Think", "NoDrawCheck", m.NoDrawCheck)

    return m
end