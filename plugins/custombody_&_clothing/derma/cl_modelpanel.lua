local PANEL = {}

AccessorFunc( PANEL, "m_fAnimSpeed",	"AnimSpeed" )
AccessorFunc( PANEL, "Entity",			"Entity" )
AccessorFunc( PANEL, "vCamPos",			"CamPos" )
AccessorFunc( PANEL, "fFOV",			"FOV" )
AccessorFunc( PANEL, "vLookatPos",		"LookAt" )
AccessorFunc( PANEL, "aLookAngle",		"LookAng" )
AccessorFunc( PANEL, "colAmbientLight",	"AmbientLight" )
AccessorFunc( PANEL, "colColor",		"Color" )
AccessorFunc( PANEL, "bAnimated",		"Animated" )

--[[---------------------------------------------------------
	Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self.Entity = nil
	self.Body = nil
	self.LastPaint = 0
	self.DirectionalLight = {}
	self.FarZ = 4096

	self:SetCamPos( Vector( 50, 50, 50 ) )
	self:SetLookAt( Vector( 0, 0, 40 ) )
	self:SetFOV( 70 )

	self:SetText( "" )
	self:SetAnimSpeed( 0.5 )
	self:SetAnimated( false )

	self:SetAmbientLight( Color( 50, 50, 50 ) )

	self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )

	self:SetColor( Color( 255, 255, 255, 255 ) )

end

function PANEL:SetSubMaterial(index, override)
	self.SubMaterial = {index, override}
end

function PANEL:SetSubMaterial2(index, override)
	self.SubMaterial2 = {index, override}
end

--[[---------------------------------------------------------
	Name: SetDirectionalLight
-----------------------------------------------------------]]
function PANEL:SetDirectionalLight( iDirection, color )
	self.DirectionalLight[ iDirection ] = color
end

--[[---------------------------------------------------------
	Name: SetModel
-----------------------------------------------------------]]
function PANEL:SetModel( strModelName, strBody )

	-- Note - there's no real need to delete the old 
	-- entity, it will get garbage collected, but this is nicer.
	if ( IsValid( self.Entity ) ) then
		self.Entity:Remove()
		self.Entity = nil
	end

	-- Note: Not in menu dll
	if ( !ClientsideModel ) then return end

	self.Entity = ClientsideModel( strModelName, RENDER_GROUP_OPAQUE_ENTITY )
	if ( !IsValid( self.Entity ) ) then return end

	self.Entity:SetNoDraw( true )

	if ( IsValid( self.Body ) ) then
		self.Body:Remove()
		self.Body = nil
	end

	-- Note: Not in menu dll
	if ( !ClientsideModel ) then return end

	self.Body = ClientsideModel( strBody, RENDER_GROUP_OPAQUE_ENTITY )
	if ( !IsValid( self.Body ) ) then return end

	self.Body:SetNoDraw( true )
	self.Body:SetParent(self.Entity)
	self.Body:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL,EF_PARENT_ANIMATES))

	-- Try to find a nice sequence to play
	local iSeq = self.Entity:LookupSequence( "walk_all" )
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "WalkUnarmed_all" ) end
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "walk_all_moderate" ) end

	if ( iSeq > 0 ) then self.Entity:ResetSequence( iSeq ) end

end

--[[---------------------------------------------------------
	Name: GetModel
-----------------------------------------------------------]]
function PANEL:GetModel()
	if ( !IsValid( self.Entity ) ) then return end

	return self.Entity:GetModel()
end

function PANEL:GetBody()
	if ( !IsValid( self.Body ) ) then return end

	return self.Body
end

--[[---------------------------------------------------------
	Name: DrawModel
-----------------------------------------------------------]]
function PANEL:DrawModel()
	local curparent = self
	local rightx = self:GetWide()
	local leftx = 0
	local topy = 0
	local bottomy = self:GetTall()
	local previous = curparent
	while( curparent:GetParent() != nil ) do
		curparent = curparent:GetParent()
		local x, y = previous:GetPos()
		topy = math.Max( y, topy + y )
		leftx = math.Max( x, leftx + x )
		bottomy = math.Min( y + previous:GetTall(), bottomy + y )
		rightx = math.Min( x + previous:GetWide(), rightx + x )
		previous = curparent
	end
	render.SetScissorRect( leftx, topy, rightx, bottomy, true )

	render.SetLightingOrigin( self.Body:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
	render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
	render.SetBlend( self.colColor.a/255 )

	for i=0, 12 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
		end
	end

	--render.SuppressEngineLighting( true )
	self.Body:DrawModel()

	if (self.SubMaterial) then
		render.MaterialOverrideByIndex(self.SubMaterial[1], self.SubMaterial[2]) 
	end

	if (self.SubMaterial2) then
		render.MaterialOverrideByIndex(self.SubMaterial2[1], self.SubMaterial2[2]) 
	end

	render.SetLightingOrigin( self.Entity:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
	if (self.HairColor) then
		render.SetColorModulation( self.HairColor.r/255, self.HairColor.g/255, self.HairColor.b/255 )
		render.SetBlend( self.HairColor.a/255 )
	else
		render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
		render.SetBlend( self.colColor.a/255 )
	end

	for i=0, 12 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
		end
	end

	--render.SuppressEngineLighting( true )
	self.Entity:DrawModel()

	render.SetScissorRect( 0, 0, 0, 0, false )
end

function PANEL:SetHairColor(color)
	self.HairColor = color
end

--[[---------------------------------------------------------
	Name: OnMousePressed
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	if ( !IsValid( self.Entity ) ) then return end

	local x, y = self:LocalToScreen( 0, 0 )

	self:LayoutEntity( self.Entity )
	self:LayoutEntity( self.Body )
	local ang = self.aLookAngle
	if ( !ang ) then
		ang = (self.vLookatPos-self.vCamPos):Angle()
	end

	cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )

	--render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity:GetPos() )
	--render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
	--if (self.HairColor) then
	--	print(self.HairColor)
	--	render.SetColorModulation( self.HairColor.r/255, self.HairColor.g/255, self.HairColor.b/255 )
	--	render.SetBlend( self.HairColor.a/255 )
	--else
	--	render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
	--	render.SetBlend( self.colColor.a/255 )
	--end

	self:DrawModel()

	render.SuppressEngineLighting( false )
	cam.End3D()

	self.LastPaint = RealTime()

end

--[[---------------------------------------------------------
	Name: RunAnimation
-----------------------------------------------------------]]
function PANEL:RunAnimation()
	self.Entity:FrameAdvance( ( RealTime() - self.LastPaint ) * self.m_fAnimSpeed )
	self.Body:FrameAdvance( ( RealTime() - self.LastPaint ) * self.m_fAnimSpeed )
end

--[[---------------------------------------------------------
	Name: RunAnimation
-----------------------------------------------------------]]
function PANEL:StartScene( name )

	if ( IsValid( self.Scene ) ) then
		self.Scene:Remove()
	end

	self.Scene = ClientsideScene( name, self.Entity )

end

--[[---------------------------------------------------------
	Name: LayoutEntity
-----------------------------------------------------------]]
function PANEL:LayoutEntity( Entity )

	--
	-- This function is to be overriden
	--

	if ( self.bAnimated ) then
		self:RunAnimation()
	end

	--Entity:SetAngles( Angle( 0, RealTime() * 10, 0 ) )

end

function PANEL:OnRemove()
	if ( IsValid( self.Entity ) ) then
		self.Entity:Remove()
	end

	if ( IsValid( self.Body ) ) then
		self.Body:Remove()
	end
end

--[[---------------------------------------------------------
	Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetSize( 300, 300 )
	ctrl:SetModel( "models/error.mdl" )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "LZModelPanel", "A panel containing a model", PANEL, "DButton" )