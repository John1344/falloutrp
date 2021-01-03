---------------------------------
--[[ Precache body materials ]]--
---------------------------------
for k, v in pairs(PLUGIN.FemaleFaces) do
	for k2, v2 in pairs(v) do
		surface.SetMaterial(nut.util.getMaterial("models/lazarus/female/"..v2))
	end
end

for k, v in pairs(PLUGIN.MaleFaces) do
	for k2, v2 in pairs(v) do
		surface.SetMaterial(nut.util.getMaterial("models/lazarus/male/"..v2))
	end
end

for k, v in pairs(PLUGIN.EyeTable) do
	surface.SetMaterial(nut.util.getMaterial("models/lazarus/shared/"..v.mat))
end

for k, v in pairs(PLUGIN.MiscData) do
	surface.SetMaterial(nut.util.getMaterial(v))
end



function PLUGIN:PlayerLoadout(ply)
    -------------------------------------
    --[[ Attach naked torso and arms ]]--
	-------------------------------------
	local haveFalloutModel = self:HaveFalloutModel(ply)
	local torsoAttach = ply.forp_TorsoAttach
	local armAttach = ply.forp_ArmAttach

	if ( haveFalloutModel ) then
		local gender = self:GetGender(ply)

		if ( not IsValid(torsoAttach) ) then
			torsoAttach = ply:forp_BonemergeAttach("models/thespireroleplay/humans/group100/"..gender..".mdl")
		end
		if ( not IsValid(armAttach) ) then
			armAttach = ply:forp_BonemergeAttach("models/thespireroleplay/humans/group100/arms/"..gender.."_arm.mdl")
		end
	else
		if ( IsValid(torsoAttach) ) then
			torsoAttach:Remove()
		end
		if ( IsValid(armAttach) ) then
			armAttach:Remove()
		end
	end
    
    -------------------------------------------
    --[[ Load all already equipped clothes ]]--
    -------------------------------------------
	if ( haveFalloutModel ) then
		
	end
end