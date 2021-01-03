local PLUGIN = PLUGIN
PLUGIN.name = "Cook Food"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "How about getting new foods in NutScript?"
PLUGIN.hungrySeconds = 1100 -- A player can stand up 300 seconds without any foods
PLUGIN.thirstSeconds = 550 -- A player can stand up 300 seconds without any foods

COOKLEVEL = {
	[1] = {"cookNever", 2, color_white},
	[2] = {"cookFailed", 1, Color(207, 0, 15)},
	[3] = {"cookWell", 3, Color(235, 149, 50)},
	[4] = {"cookDone", 4, Color(103, 128, 159)},
	[5] = {"cookGood", 6, Color(63, 195, 128)},
}
COOKER_MICROWAVE = 1
COOKER_STOVE = 2

nut.util.include("cl_vgui.lua")

local playerMeta = FindMetaTable("Player")
local entityMeta = FindMetaTable("Entity")

nut.config.add("hungerTime", 600, "After how long a player is hungry.", nil,{
	form = "Int",
	data = {min = 0, max = 999999},
	category = "server"
})

nut.config.add("thirstTime", 300, "After how long a player is thirsty.", nil,{
	form = "Int",
	data = {min = 0, max = 999999},
	category = "server"
})

function getHungerSec()
	return PLUGIN.hungrySeconds
end

function getThirstSec()
	return PLUGIN.thirstSeconds
end

function playerMeta:getHunger()
	return (self:getNetVar("hunger")) or 0
end

function playerMeta:getThirst()
	return (self:getNetVar("thirst")) or 0
end

function playerMeta:getHungerPercent()
	return math.Clamp(((CurTime() - self:getHunger()) / PLUGIN.hungrySeconds), 0 ,1)
end

function playerMeta:getThirstPercent()
	return math.Clamp(((CurTime() - self:getThirst()) / PLUGIN.thirstSeconds), 0 ,1)
end

function playerMeta:addThirst(amount)
	local curThirst = CurTime() - self:getThirst()

	self:setNetVar("thirst", 
		CurTime() - math.Clamp(math.min(curThirst, PLUGIN.thirstSeconds) - amount, 0, PLUGIN.thirstSeconds)
	)
end

function playerMeta:addHunger(amount)
	local curHunger = CurTime() - self:getHunger()

	self:setNetVar("hunger", 
		CurTime() - math.Clamp(math.min(curHunger, PLUGIN.hungrySeconds) - amount, 0, PLUGIN.hungrySeconds)
	)
end

function entityMeta:isStove()
	local class = self:GetClass()

	return (class == "nut_stove" or class == "nut_microwave")
end

-- Register HUD Bars.
if (CLIENT) then

	do

	nut.bar.add(function()
		return (1 - LocalPlayer():getHungerPercent())
	end, Color(211, 129, 42), nil, "hunger")
		
	nut.bar.add(function()
		return (1 - LocalPlayer():getThirstPercent())
	end, Color(73, 123, 188), nil, "thirst")

	end

	local timers = {5, 15, 30}

	netstream.Hook("stvOpen", function(entity, index)
		local inventory = nut.item.inventories[index]

		if (IsValid(entity) and inventory and inventory.slots) then
			nut.gui.inv1 = vgui.Create("nutInventory")
			nut.gui.inv1:ShowCloseButton(true)

			local inventory2 = LocalPlayer():getChar():getInv()

			if (inventory2) then
				nut.gui.inv1:setInventory(inventory2)
			end

			local panel = vgui.Create("nutInventory")
			panel:ShowCloseButton(true)
			panel:SetTitle("Cookable Object")
			panel:setInventory(inventory)
			panel:MoveLeftOf(nut.gui.inv1, 4)
			panel.OnClose = function(this)
				if (IsValid(nut.gui.inv1) and !IsValid(nut.gui.menu)) then
					nut.gui.inv1:Remove()
				end

				netstream.Start("invExit")
			end
			
			function nut.gui.inv1:OnClose()
				if (IsValid(panel) and !IsValid(nut.gui.menu)) then
					panel:Remove()
				end

				netstream.Start("invExit")
			end

			local actPanel = vgui.Create("DPanel")
			actPanel:SetDrawOnTop(true)
			actPanel:SetSize(100, panel:GetTall())
			actPanel.Think = function(this)
				if (!panel or !panel:IsValid() or !panel:IsVisible()) then
					this:Remove()

					return
				end

				local x, y = panel:GetPos()
				this:SetPos(x - this:GetWide() - 5, y)
			end

			for k, v in ipairs(timers) do
				local btn = actPanel:Add("DButton")
				btn:Dock(TOP)
				btn:SetText(v .. " Seconds")
				btn:DockMargin(5, 5, 5, 0)

				function btn.DoClick()
					netstream.Start("stvActive", entity, v)
				end
			end

			nut.gui["inv"..index] = panel
		end
	end)
else
	local PLUGIN = PLUGIN

	function PLUGIN:LoadData()
		if (true) then return end
		
		local savedTable = self:getData() or {}

		for k, v in ipairs(savedTable) do
			local stove = ents.Create(v.class)
			stove:SetPos(v.pos)
			stove:SetAngles(v.ang)
			stove:Spawn()
			stove:Activate()
		end
	end
	
	function PLUGIN:SaveData()
		if (true) then return end

		local savedTable = {}

		for k, v in ipairs(ents.GetAll()) do
			if (v:isStove()) then
				table.insert(savedTable, {class = v:GetClass(), pos = v:GetPos(), ang = v:GetAngles()})
			end
		end

		self:setData(savedTable)
	end
	
	function PLUGIN:CharacterPreSave(character)
		local savedHunger = math.Clamp(CurTime() - character.player:getHunger(), 0, PLUGIN.hungrySeconds)
		character:setData("hunger", savedHunger)
		
		local savedThirst = math.Clamp(CurTime() - character.player:getThirst(), 0, PLUGIN.thirstSeconds)
		character:setData("thirst", savedThirst)
	end

	function PLUGIN:PlayerLoadedChar(client, character, lastChar)
		if (character:getData("hunger")) then
			client:setNetVar("hunger", CurTime() - character:getData("hunger"))
		else
			client:setNetVar("hunger", CurTime())
		end
		
		if (character:getData("thirst")) then
			client:setNetVar("thirst", CurTime() - character:getData("thirst"))
		else
			client:setNetVar("thirst", CurTime())
		end
	end

	function PLUGIN:PlayerDeath(client)
		client.refillHunger = true
		client.refillThirst = true
	end

	function PLUGIN:PlayerSpawn(client)
		if (client.refillHunger) then
			client:setNetVar("hunger", CurTime())
			client.refillHunger = false
		end
		
		if (client.refillThirst) then
			client:setNetVar("thirst", CurTime())
			client.refillThirst = false
		end
	end

	local thinkTime = CurTime()
	local thinkTimeThirst = CurTime()
	function PLUGIN:PlayerPostThink(client)
		if (thinkTime < CurTime()) then
			local percent = (1 - client:getHungerPercent())

			if (percent <= 0) then
				
				if (client:Alive() and client:Health() <= 0) then
					client:Kill()
				else
					client:SetHealth(math.Clamp(client:Health() - 1, 0, client:GetMaxHealth()))
				end
			end

			thinkTime = CurTime() + nut.config.get("hungerTime")
		end
		
		if (thinkTimeThirst < CurTime()) then
			local percent = (1 - client:getThirstPercent())

			if (percent <= 0) then
				
				if (client:Alive() and client:Health() <= 0) then
					client:Kill()
				else
					client:SetHealth(math.Clamp(client:Health() - 1, 0, client:GetMaxHealth()))
				end
			end

			thinkTimeThirst = CurTime() + nut.config.get("thirstTime")
		end
	end
end