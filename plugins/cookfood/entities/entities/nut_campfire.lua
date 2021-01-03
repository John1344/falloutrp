AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Campfire"
ENT.Author = "Black Tea, VJ-Base dev team, SuperMicronde"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup 		= RENDERGROUP_BOTH
ENT.Category = "NutScript"
ENT.invType = "campfire"
nut.item.registerInv(ENT.invType, 2, 2)

if (SERVER) then
	
	function ENT:Initialize()
		self:SetModel("models/optinvfallout/campfire3.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:setNetVar("active", false)
		self:SetUseType(SIMPLE_USE)
		self.loopsound = CreateSound(self, "ambient/fire/fire_small_loop1.wav")
		self.loopsound:SetSoundLevel(60)
		self.receivers = {}
		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:Wake()
		end

		nut.item.newInv(0, self.invType, function(inventory)
			self:setInventory(inventory)
			inventory.noBags = true

			function inventory:onCanTransfer(client, oldX, oldY, x, y, newInvID)
				return hook.Run("StorageCanTransfer", inventory, client, oldX, oldY, x, y, newInvID)
			end
		end)
	end

	function ENT:setInventory(inventory)
		if (inventory) then
			self:setNetVar("id", inventory:getID())

			inventory.onAuthorizeTransfer = function(inventory, client, oldInventory, item)
				if (IsValid(client) and IsValid(self) and self.receivers[client]) then
					return true
				end
			end

			inventory.getReceiver = function(inventory)
				local receivers = {}

				for k, v in pairs(self.receivers) do
					if (IsValid(k)) then
						receivers[#receivers + 1] = k
					end
				end

				return #receivers > 0 and receivers or nil
			end
		end
	end
	
	function ENT:activate(seconds)

		local timerName = self:GetClass():lower() .. "_" .. self:EntIndex() .. "_stoveThink"
		if (seconds != 0 and !self:getNetVar("active")) then
			seconds = math.abs(seconds)

			timer.Create(timerName, seconds, 1, function()
				if (self and self:IsValid()) then
					self:activate(0)
				end
			end)
		else
			timer.Destroy(timerName)
		end

		self:setNetVar("active", !self:getNetVar("active"))
		
		if (self:getNetVar("active")) then
			netstream.Start(player.GetAll(), "cookfood_fireplace", self, seconds)
			self:EmitSound(Sound("ambient/fire/mtov_flame2.wav"),60,100)
			self.loopsound:ChangeVolume(0.6)
			self.loopsound:Play()
		else
			
			self.loopsound:ChangeVolume(0, 1)
			timer.Simple(1, function()
				self.loopsound:Stop()
			end)
		end
	end
	
	function ENT:Use(activator)
		local inventory = self:getInv()

		if (inventory and (activator.nutNextOpen or 0) < CurTime()) then
			if (activator:getChar()) then
				if (activator:GetPos():Distance(self:GetPos()) <= 100) then
					self.receivers[activator] = true
					activator.nutBagEntity = self
						
					inventory:sync(activator)
					netstream.Start(activator, "stvOpen", self, inventory:getID())
				end
			end

			activator.nutNextOpen = CurTime() + 1.5
		end
	end

	function ENT:OnRemove()
		self.loopsound:Stop()
		local index = self:getNetVar("id")

		if (!nut.shuttingDown and !self.nutIsSafe and index) then
			local item = nut.item.inventories[index]

			if (item) then
				nut.item.inventories[index] = nil

				nut.db.query("DELETE FROM nut_items WHERE _invID = "..index)
				nut.db.query("DELETE FROM nut_inventories WHERE _invID = "..index)

				hook.Run("StorageItemRemoved", self, item)
			end
		end
	end

	function ENT:getInv()
		return nut.item.inventories[self:getNetVar("id", 0)]
	end

	local heatCooks = {
		{0, 3, 1},
		{3, 10, 3},
		{10, 25, 4},
	}
	function ENT:Think()
		if (self:getNetVar("active")) then
			local items = self:getInv():getItems(true)

			for k, v in pairs(items) do
				v:setData("heat", v:getData("heat", 0) + 1)

				if (v.ammo) then
					if (v:getData("heat") > 3) then
						self:explode()
					end
				end

				if (v.isFood and v.cookable) then
					local heat = v:getData("heat")
					local cookLevel = v:getData("cooked", 0)
					local overheat = true

					for _, range in ipairs(heatCooks) do
						if (heat >= range[1] and heat < range[2]) then
							if (cookLevel != range[3]) then
								v:setData("cooked", range[3])
							end
							overheat = false

							break
						end
					end

					if (overheat) then
						if (cookLevel != 2) then
							v:setData("cooked", 2)
						end
					end
				end
			end

			self:NextThink(CurTime() + 1)
			return true
		end
	end
	
	function ENT:Touch(entity)
		if (IsValid(entity) && entity:GetPos():Distance(self:GetPos()) <= 38 && self:getNetVar("active") && (entity:IsNPC() or entity:IsPlayer())) then
			entity:Ignite(math.Rand(3,5))
		end
	end

	netstream.Hook("stvActive", function(client, entity, seconds)
		local distance = client:GetPos():Distance(entity:GetPos())
		
		if (entity:IsValid() and client:IsValid() and client:getChar() and
			distance < 128) then
			entity:activate(seconds)
		end
	end)
else

	function ENT:Draw()
		self:DrawModel()
	end
	
	function ENT:Think()
		self.oldValue = self.oldValue or false
		local activated = self:getNetVar("active")
		
		if activated != self.oldValue then
	
			if activated then
				self.FireLight = DynamicLight(self:EntIndex())
				if (self.FireLight) then
					self.FireLight.Pos = self:GetPos() +self:GetUp()*15
					self.FireLight.r = 255
					self.FireLight.g = 100
					self.FireLight.b = 0
					self.FireLight.Brightness = 2
					self.FireLight.Size = 400
					self.FireLight.Decay = 400
					self.FireLight.DieTime = CurTime() + 999
				end
				
				ParticleEffectAttach("env_fire_tiny_smoke",PATTACH_ABSORIGIN_FOLLOW,self,0)
			else
				if IsValid(self.FireLight) then
					self.FireLight = CurTime()
				end
				
				self:StopParticles()
			end
			
		end
		
		self.oldValue = activated
		
		self:NextThink( CurTime() + 0.3 )
		return true
	end
	
end
