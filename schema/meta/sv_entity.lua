local Entity = FindMetaTable( "Entity" )

function Entity:IsDoorLocked()
	return self:GetSaveTable().m_bLocked or self.locked or false
end