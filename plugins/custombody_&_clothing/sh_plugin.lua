PLUGIN.name = "Character Customization"
PLUGIN.author = "Lazarus, Cat.jpeg"
PLUGIN.desc = "Permits to make a custom character."

nut.util.include("sh_anims.lua")
nut.util.include("sh_data.lua")
nut.util.include("sh_clothes.lua")
nut.util.include("sv_plugin.lua")
nut.util.include("cl_names.lua")
nut.util.include("cl_cinematics.lua")
nut.util.include("cl_charcreation.lua")
nut.util.include("cl_plugin.lua")


--------------
--[[ UTIL ]]--
--------------
function PLUGIN:IsFemale(ply) -- Feminism
    local model = ply:GetModel():lower()

	return model:find("female") or model:find("alyx") or model:find("mossman") or nut.anim.getModelClass(model) == "citizen_female"
end

function PLUGIN:GetGender(ply)
    if ( self:IsFemale(ply) ) then
		return "female"
	else
		return "male"
	end
end

function PLUGIN:IsRagdolled(ply)
	local index = ply:getNetVar("ragdoll", -1)
	local entity = Entity(index)

	if (SERVER) then
		return IsValid(entity), entity
	end

	return IsValid(entity) or index > 0, entity
end

function PLUGIN:HaveFalloutModel(ply)
	return self.SkinTones[string.lower(ply:GetModel())] ~= nil
end

function PLUGIN:GetSkinTone(ply)
    local skin = self.SkinTones[ply:GetModel()]

	if ( skin ) then
		return skin
    elseif ( ply:getChar() ) then
        local char = ply:getChar()
        return char:getData("facemap", 0)
	else
		return 0
	end
end

function PLUGIN:GetOrigin(ply)
    local skinTone = self:GetSkinTone(ply)

	if (skinTone == 3) then
		origin = "african"
	elseif (skinTone == 7) then
		origin = "asian"
	elseif (skinTone == 1) then
		origin = "caucasian"
	elseif (skinTone == 5) then
		origin = "hispanic"
	end

	return origin or "caucasian" -- Why caucasian ? why ?! why ?!
end