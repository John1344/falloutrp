local Entity = FindMetaTable( "Entity" )


local VARS_TO_CLONE = {
	"Model",
	"Pos",
	"Angles",
	"Color",
	"Skin",
}

-- Make an entity look like another
function Entity:CloneVarsOn( ent )
	-- Vars
	for _, v in pairs( VARS_TO_CLONE ) do
        local get = Entity["Get"..v]
        local set = Entity["Set"..v]
            
        set(ent, get(self))
    end

	-- Tables
	local bgs = self:GetBodyGroups()
	if ( bgs ) then
	   
		for _, v in pairs( bgs ) do
			local bgId = v.id
			local bgValue = self:GetBodygroup( bgId )

			if ( bgValue > 0 ) then
				ent:SetBodygroup( bgId, bgValue )
			end
		end
		
	end

	local mats = self:GetMaterials()
	for k, v in pairs( mats ) do
		ent:SetSubMaterial(k - 1, self:GetSubMaterial(k - 1))
	end
end


-- Weld an entity to another
function Entity:AttachTo(otherEntity)
	constraint.Weld(self, otherEntity, 0, 0, 0, false)

	self:DeleteOnRemove( otherEntity )
	otherEntity:DeleteOnRemove( self )
end