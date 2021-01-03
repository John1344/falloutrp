PLUGIN.name = "Doors with teleports integration"
PLUGIN.author = "Chessnut and SuperMicronde (Rewriting)"
PLUGIN.desc = "Permits to use fake doors (teleporters) as standard doors with the NutScript system."

DOOR_OWNER = 3
DOOR_TENANT = 2
DOOR_GUEST = 1
DOOR_NONE = 0

nut.util.include("sv_plugin.lua")
nut.util.include("cl_plugin.lua")
nut.util.include("sh_commands.lua")
nut.util.include("cl_hooks.lua")
nut.util.include("sh_teleporters.lua")
nut.util.include("sv_hooks.lua")

do
	local entityMeta = FindMetaTable("Entity")

	function entityMeta:checkDoorAccess(client, access)
		if (!self:isDoor()) then
			return false
		end

		access = access or DOOR_GUEST

		local parent = self.nutParent

		if (IsValid(parent)) then
			return parent:checkDoorAccess(client, access)
		end

		if (hook.Run("CanPlayerAccessDoor", client, self, access)) then
			return true
		end

		if (self.nutAccess and (self.nutAccess[client] or 0) >= access) then
			return true
		end

		return false
	end

	if (SERVER) then
		function entityMeta:removeDoorAccessData()
			-- Don't ask why. This happened with 60 player servers.
			if (IsValid(self)) then
				for k, v in pairs(self.nutAccess or {}) do
					netstream.Start(k, "doorMenu")
				end
				
				self.nutAccess = {}
				self:SetDTEntity(0, nil)
			end
		end
	end
	
	local playerMeta = FindMetaTable("Player")
	
	-- Check that the entity is a teleporter
	function entityMeta:isFakeDoor()
		return self:GetClass() == "forp_teleport"
	end

	-- Checks if an entity is a door by comparing its class.
	function entityMeta:isDoor()
		return self:GetClass():find("door") or self:isFakeDoor()
	end
	
	function entityMeta:RunOnAllDoors(funcToExec, args)
	
		if !args then
			args = {}
		end
	
		funcToExec(self, args)
	
		if self:isFakeDoor() then
			for k, v in pairs(self.otherDoors) do
				funcToExec(v, args)
			end
		end
	end
end

-- Configurations for door prices.
nut.config.add("doorCost", 10, "The price to purchase a door.", nil, {
	data = {min = 0, max = 500},
	category = "dConfigName"
})
nut.config.add("doorSellRatio", 0.5, "How much of the door price is returned when selling a door.", nil, {
	form = "Float",
	data = {min = 0, max = 1.0},
	category = "dConfigName"
})
nut.config.add("doorLockTime", 1, "How long it takes to (un)lock a door.", nil, {
	form = "Float",
	data = {min = 0, max = 10.0},
	category = "dConfigName"
})