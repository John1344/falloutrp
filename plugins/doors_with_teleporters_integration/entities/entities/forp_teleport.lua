AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Teleporter"
ENT.Category = "Fallout Roleplay"
ENT.Author = "Johnny Guitar"
ENT.Spawnable = true
ENT.isdoor = true
ENT.otherDoors = {}
ENT.nextLockSound = 0

function ENT:SetupDataTables()
	self:NetworkVar("String", 1, "Destination")
	self:NetworkVar("String", 2, "Type")
	self:NetworkVar("String", 3, "UID")
end

function ENT:AcceptInput(inputName, activator, called, data)
	if (inputName == "lock") then
		self.locked = true
	elseif (inputName == "unlock") then
		self.locked = false
	end
end

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_c17/door01_left.mdl")
		self:SetSolid(SOLID_BSP)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetHealth(100)
		self:SetUseType(SIMPLE_USE)
		self:SetUID("DefaultUID")
		self:SetType("Door")
		self:SetDestination("The Mojave Wasteland")

		local physicsObject = self:GetPhysicsObject();

		if (IsValid(physicsObject)) then
			physicsObject:Wake()
			physicsObject:EnableMotion(true)
		end
	end

	function ENT:Use(client)
	
		if !client:IsPlayer() then
			return
		end
		
		if self.locked then
		
			if CurTime() > self.nextLockSound then
				self:RunOnAllDoors(function(entity, args)
					entity.nextLockSound = CurTime() + 1
					entity:EmitSound("doors/default_locked.wav")
				end)
			end
			
			return
		end
		
		SCHEMA:TeleportPlayer(self:GetUID(), client)
	end
end