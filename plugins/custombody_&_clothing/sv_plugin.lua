--------------------------
--[[ BODY DATA SAVING ]]--
--------------------------
local bodyVars = { -- Server will only accept theses vars from client ( avoid ability to change any char var )
	"forp_skintone",
	"forp_facemap",
	"forp_eyecolor",
	"forp_hair",
	"forp_haircolor",
	"forp_facialhair"
}

-- Store body data sended by the client to saved when char is created
netstream.Hook("forp_BodyData", function(ply, bodyData)
	ply.forp_BodyData = bodyData
end)

-- Save permanently body data sended by client before char creation
function PLUGIN:OnCharCreated(ply, char)
	local bodyData = ply.forp_BodyData

	if ( bodyData ) then
		for _, v in pairs( bodyVars ) do
			char:setData(v, bodyData[v])
		end
	end
end



----------------------------------
--[[ LOAD BODY DATA ON PLAYER ]]--
----------------------------------
local firstTime = false

function PLUGIN:PlayerLoadout(ply)
	-- Make the hook not called two times
	firstTime = not firstTime
	if ( not firstTime ) then return end

	local char = ply:getChar()
	if ( not char ) then return end

	-- Default loadout
	if ( not self:HaveFalloutModel(ply) ) then
		ply:SetColor(Color(255,255,255))
		ply:SetSubMaterial(0, nil)
		ply:SetSubMaterial(1, nil)
		ply:SetSubMaterial(2, nil)
		ply:SetSubMaterial(3, nil)
		ply:SetMaterial(nil)
		ply:SetBodyGroups("000000000")
		ply:SetSkin(0)
		return
	end

	-- Adapt fallout models for Gmod
	ply:SetModelScale(1, 1) 
	ply:SetViewOffset(Vector(0,0,64))

	-- Apply body data on char
	local isFemale = self:IsFemale(ply)

	local index
	if ( isFemale ) then
		index = 1
	else
		index = 3
	end

	local eyeColor = char:getData("forp_eyecolor")
	if ( eyeColor ) then
		ply:SetSubMaterial(index, "models/lazarus/shared/"..self.EyeTable[eyeColor].mat)
	else
		ply:SetSubMaterial(index, "models/lazarus/shared/"..self.EyeTable[1].mat)
	end
			
	local facemap = char:getData("forp_facemap")
	if ( facemap ) then
		local face = facemap + 1
		local origin = self:GetOrigin(ply)

		if ( isFemale ) then
			ply:SetSubMaterial(0, "models/lazarus/female/"..self.FemaleFaces[origin][face])
		else
			ply:SetSubMaterial(0, "models/lazarus/male/"..self.MaleFaces[origin][face])
		end
	end

	local hairColor = char:getData("forp_haircolor")
	if ( hairColor ) then
		ply:SetColor(self.HairTable[hairColor].color)
	else
		ply:SetColor(Color(255,255,255,255))
	end

	ply:SetBodygroup(2, char:getData("forp_hair", 1))
	ply:SetBodygroup(3, char:getData("forp_facialhair", 0))
end