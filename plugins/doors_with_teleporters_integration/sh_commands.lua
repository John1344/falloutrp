local PLUGIN = PLUGIN
nut.command.add("doorsell", {
	onRun = function(client, arguments)
		-- Get the entity 96 units infront of the player.
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*96
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity
		
		if entity:getNetVar("chargeHidden") then
			client:notifyLocalized("dNotValid")
			return
		end

		-- Check if the entity is a valid door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			-- Check if the player owners the door.
			if (client == entity:GetDTEntity(0)) then
				-- Get the price that the door is sold for.
				local price = math.Round(entity:getNetVar("price", nut.config.get("doorCost")) * nut.config.get("doorSellRatio"))

				-- Remove old door information.
				entity:RunOnAllDoors(function(entity, args)
					entity:removeDoorAccessData()
				end)

				-- Remove door information on child doors
				PLUGIN:callOnDoorChildren(entity, function(child)
					child:RunOnAllDoors(function(entity, args)
						entity:removeDoorAccessData()
					end)
				end)

				-- Take their money and notify them.
				client:getChar():giveMoney(price)
				client:notifyLocalized("dSold", nut.currency.get(price))
				hook.Run("OnPlayerPurchaseDoor", client, entity, false, PLUGIN.callOnDoorChildren) -- i fucking hate this life
				nut.log.add(client, "selldoor")
			else
				-- Otherwise tell them they can not.
				client:notifyLocalized("notOwner")
			end
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end		
	end
})

nut.command.add("doorbuy", {
	onRun = function(client, arguments)
		-- Get the entity 96 units infront of the player.
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*96
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity
		
		if entity:getNetVar("chargeHidden") then
			client:notifyLocalized("dNotValid")
			return
		end

		-- Check if the entity is a valid door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			if (entity:getNetVar("noSell") or entity:getNetVar("faction") or entity:getNetVar("class")) then
				return client:notifyLocalized("dNotAllowedToOwn")
			end

			if (IsValid(entity:GetDTEntity(0))) then
				client:notifyLocalized("dOwnedBy", entity:GetDTEntity(0):Name())
				return false
			end
			-- Get the price that the door is bought for.
			local price = entity:getNetVar("price", nut.config.get("doorCost"))

			-- Check if the player can actually afford it.
			if (client:getChar():hasMoney(price)) then

				entity:RunOnAllDoors(function(entity, args)
					-- Set the door to be owned by this player.
					entity:SetDTEntity(0, args[1])
					entity.nutAccess = {
						[args[1]] = DOOR_OWNER
					}
				end, {client})
				
				
				PLUGIN:callOnDoorChildren(entity, function(child)

					child:RunOnAllDoors(function(entity, args)
						entity:SetDTEntity(0, args[1])
					end, {client})
					
				end)

				-- Take their money and notify them.
				client:getChar():takeMoney(price)
				client:notifyLocalized("dPurchased", nut.currency.get(price))

				hook.Run("OnPlayerPurchaseDoor", client, entity, true, PLUGIN.callOnDoorChildren) -- i fucking hate this life
				nut.log.add(client, "buydoor")
			else
				-- Otherwise tell them they can not.
				client:notifyLocalized("canNotAfford")
			end
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end
	end
})

nut.command.add("doorsetunownable", {
	adminOnly = true,
	syntax = "[string name]",
	onRun = function(client, arguments)
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity
		local name = table.concat(arguments, " ")
		
		if entity:getNetVar("chargeHidden") then
			client:notifyLocalized("dNotValid")
			return
		end
	
		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			-- Set it so it is unownable.
			entity:RunOnAllDoors(function(entity, args)
				entity:setNetVar("noSell", true)
			end)
			
			-- Change the name of the door if needed.
			if (arguments[1] and name:find("%S")) then
			
				entity:RunOnAllDoors(function(entity, args)
					entity:setNetVar("name", args[1])
				end, {name})
			
			end

			PLUGIN:callOnDoorChildren(entity, function(child)
			
				child:RunOnAllDoors(function(entity, args)
					entity:setNetVar("noSell", true)
				end)
				

				if (arguments[1] and name:find("%S")) then
					
					child:RunOnAllDoors(function(entity, args)
						entity:setNetVar("name", args[1])
					end, {name})
					
				end
			end)

			-- Tell the player they have made the door unownable.
			client:notifyLocalized("dMadeUnownable")

			-- Save the door information.
			PLUGIN:SaveDoorData()
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end
	end
})

nut.command.add("doorsetownable", {
	adminOnly = true,
	syntax = "[string name]",
	onRun = function(client, arguments)
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity
		local name = table.concat(arguments, " ")
		
		if entity:getNetVar("chargeHidden") then
			client:notifyLocalized("dNotValid")
			return
		end

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			
			entity:RunOnAllDoors(function(entity, args)
				-- Set it so it is ownable.
				entity:setNetVar("noSell", nil)
			end)

			-- Update the name.
			if (arguments[1] and name:find("%S")) then
				
				entity:RunOnAllDoors(function(entity, args)
					entity:setNetVar("name", args[1])
				end, {name})
				
			end

			PLUGIN:callOnDoorChildren(entity, function(child)

				child:RunOnAllDoors(function(entity, args)
					entity:setNetVar("noSell", nil)
				end)

				if (arguments[1] and name:find("%S")) then
					child:RunOnAllDoors(function(entity, args)
						entity:setNetVar("name", args[1])
					end, {args})
				end
			end)

			-- Tell the player they have made the door ownable.
			client:notifyLocalized("dMadeOwnable")

			-- Save the door information.
			PLUGIN:SaveDoorData()
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end
	end
})

nut.command.add("doorsetfaction", {
	adminOnly = true,
	syntax = "[string faction]",
	onRun = function(client, arguments)
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity
		
		if entity:getNetVar("chargeHidden") then
			client:notifyLocalized("dNotValid")
			return
		end

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			local faction

			-- Check if the player supplied a faction name.
			if (arguments[1]) then
				-- Get all of the arguments as one string.
				local name = table.concat(arguments, " ")

				-- Loop through each faction, checking the uniqueID and name.
				for k, v in pairs(nut.faction.teams) do
					if (nut.util.stringMatches(k, name) or nut.util.stringMatches(L(v.name, client), name)) then
						-- This faction matches the provided string.
						faction = v

						-- Escape the loop.
						break
					end
				end
			end

			-- Check if a faction was found.
			if (faction) then
			
				entity:RunOnAllDoors(function(entity, args)
					entity.nutFactionID = args[1]
					entity:setNetVar("faction", args[2])
				end, {faction.uniqueID, faction.index})
			
				PLUGIN:callOnDoorChildren(entity, function()
				
					entity:RunOnAllDoors(function(entity, args)
						entity.nutFactionID = args[1]
						entity:setNetVar("faction", args[2])
					end, {faction.uniqueID, faction.index})
				
				end)

				client:notifyLocalized("dSetFaction", L(faction.name, client))
			-- The faction was not found.
			elseif (arguments[1]) then
				client:notifyLocalized("invalidFaction")
			-- The player didn't provide a faction.
			else

				entity:RunOnAllDoors(function(entity, args)
					entity:setNetVar("faction", nil)
				end)

				PLUGIN:callOnDoorChildren(entity, function()					
					entity:RunOnAllDoors(function(entity, args)
						entity:setNetVar("faction", nil)
					end)
				end)

				client:notifyLocalized("dRemoveFaction")
			end

			-- Save the door information.
			PLUGIN:SaveDoorData()
		end
	end
})

nut.command.add("doorsetdisabled", {
	adminOnly = true,
	syntax = "<bool disabled>",
	onRun = function(client, arguments)
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity
		
		if entity:getNetVar("chargeHidden") then
			client:notifyLocalized("dNotValid")
			return
		end

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor()) then
			local disabled = util.tobool(arguments[1] or true)

			entity:RunOnAllDoors(function(entity, args)
				-- Set it so it is ownable.
				entity:setNetVar("disabled", args[1])
			end, {disabled})

			PLUGIN:callOnDoorChildren(entity, function(child)
				child:RunOnAllDoors(function(entity, args)
					-- Set it so it is ownable.
					entity:setNetVar("disabled", args[1])
				end, {disabled})
			end)

			-- Tell the player they have made the door (un)disabled.
			client:notifyLocalized("dSet"..(disabled and "" or "Not").."Disabled")

			-- Save the door information.
			PLUGIN:SaveDoorData()
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end
	end
})

nut.command.add("doorsettitle", {
	syntax = "<string title>",
	onRun = function(client, arguments)
		-- Get the door infront of the player.
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*96
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity
		
		if entity:getNetVar("chargeHidden") then
			client:notifyLocalized("dNotValid")
			return
		end

		-- Validate the door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			-- Get the supplied name.
			local name = table.concat(arguments, " ")

			-- Make sure the name contains actual characters.
			if (!name:find("%S")) then
				return client:notifyLocalized("invalidArg", 1)
			end

			--[[
				NOTE: Here, we are setting two different networked names.
				The title is a temporary name, while the other name is the
				default name for the door. The reason for this is so when the
				server closes while someone owns the door, it doesn't save THEIR
				title, which could lead to unwanted things.
			--]]

			-- Check if they are allowed to change the door's name.
			if (entity:checkDoorAccess(client, DOOR_TENANT)) then
				entity:RunOnAllDoors(function(entity, args)
					entity:setNetVar("title", args[1])
				end, {name})
				
			elseif (client:IsAdmin()) then
				entity:RunOnAllDoors(function(entity, args)
					entity:setNetVar("name", args[1])
				end, {name})

				PLUGIN:callOnDoorChildren(entity, function(child)
				
					chlid:RunOnAllDoors(function(entity, args)
						entity:setNetVar("name", args[1])
					end, {name})
				end)
			else
				-- Otherwise notify the player he/she can't.
				client:notifyLocalized("notOwner")
			end
		else
			-- Notification of the door not being valid.
			client:notifyLocalized("dNotValid")
		end
	end
})

nut.command.add("doorsetparent", {
	adminOnly = true,
	onRun = function(client, arguments)
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity
		
		if entity:getNetVar("chargeHidden") then
			client:notifyLocalized("dNotValid")
			return
		end

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			client.nutDoorParent = entity
			client:notifyLocalized("dSetParentDoor")
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end		
	end
})

nut.command.add("doorsetchild", {
	adminOnly = true,
	onRun = function(client, arguments)
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity
		
		if entity:getNetVar("chargeHidden") then
			client:notifyLocalized("dNotValid")
			return
		end

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			if (client.nutDoorParent == entity) then
				return client:notifyLocalized("dCanNotSetAsChild")
			end

			-- Check if the player has set a door as a parent.
			if (IsValid(client.nutDoorParent)) then
				-- Add the door to the parent's list of children.
				client.nutDoorParent.nutChildren = client.nutDoorParent.nutChildren or {}
				client.nutDoorParent.nutChildren[entity:MapCreationID()] = true
				
				entity:RunOnAllDoors(function(entity, args)
					-- Set the door's parent to the parent.
						entity.nutParent = args[1]
				end, {client.nutDoorParent})

				client:notifyLocalized("dAddChildDoor")

				-- Save the door information.
				PLUGIN:SaveDoorData()
				PLUGIN:copyParentDoor(entity)
			else
				-- Tell the player they do not have a door parent.
				client:notifyLocalized("dNoParentDoor")
			end
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end		
	end
})

nut.command.add("doorremovechild", {
	adminOnly = true,
	onRun = function(client, arguments)
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity
		
		if entity:getNetVar("chargeHidden") then
			client:notifyLocalized("dNotValid")
			return
		end

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			if (client.nutDoorParent == entity) then
				PLUGIN:callOnDoorChildren(entity, function(child)
				
					child:RunOnAllDoors(function(entity, args)
						entity.nutParent = nil
					end)
				end)
				
				entity:RunOnAllDoors(function(entity, args)
					entity.nutParent = nil
				end)

				return client:notifyLocalized("dRemoveChildren")
			end

			-- Check if the player has set a door as a parent.
			if (IsValid(entity.nutParent) and entity.nutParent.nutChildren) then

				entity:RunOnAllDoors(function(entity, args)
					-- Remove the door from the list of children.
					entity.nutParent.nutChildren[args[1]] = nil
					-- Remove the variable for the parent.
					entity.nutParent = nil
				end, args{entity:MapCreationID()})

				client:notifyLocalized("dRemoveChildDoor")

				-- Save the door information.
				PLUGIN:SaveDoorData()
			end
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end		
	end
})

nut.command.add("doorsethidden", {
	adminOnly = true,
	syntax = "<bool hidden>",
	onRun = function(client, arguments)
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity
		
		if entity:getNetVar("chargeHidden") then
			client:notifyLocalized("dNotValid")
			return
		end

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor()) then
			local hidden = util.tobool(arguments[1] or true)

			entity:setNetVar("hidden", hidden)
			
			PLUGIN:callOnDoorChildren(entity, function(child)
				child:setNetVar("hidden", hidden)
			end)

			-- Tell the player they have made the door (un)hidden.
			client:notifyLocalized("dSet"..(hidden and "" or "Not").."Hidden")

			-- Save the door information.
			PLUGIN:SaveDoorData()
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end
	end
})

nut.command.add("doorsetclass", {
	adminOnly = true,
	syntax = "[string faction]",
	onRun = function(client, arguments)
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity
		
		if entity:getNetVar("chargeHidden") then
			client:notifyLocalized("dNotValid")
			return
		end

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			local class, classData

			if (arguments[1]) then
				local name = table.concat(arguments, " ")

				for k, v in pairs(nut.class.list) do
					if (nut.util.stringMatches(v.name, name) or nut.util.stringMatches(L(v.name, client), name)) then
						class, classData = k, v

						break
					end
				end
			end

			-- Check if a faction was found.
			if (class) then
				
				entity:RunOnAllDoors(function(entity, args)
					entity.nutClassID = args[1]
					entity:setNetVar("class", args[1])
				end, {class})

				PLUGIN:callOnDoorChildren(entity, function()
					
					entity:RunOnAllDoors(function(entity, args)
						entity.nutClassID = args[1]
						entity:setNetVar("class", args[1])
					end, {class})
				end)

				client:notifyLocalized("dSetClass", L(classData.name, client))
			elseif (arguments[1]) then
				client:notifyLocalized("invalidClass")
			else
				entity:RunOnAllDoors(function(entity, args)
					entity:setNetVar("class", nil)
				end)

				PLUGIN:callOnDoorChildren(entity, function()
					
					entity:RunOnAllDoors(function(entity, args)
						entity:setNetVar("class", nil)
					end)
					
				end)

				client:notifyLocalized("dRemoveClass")
			end

			PLUGIN:SaveDoorData()
		end
	end,
	alias = {"jobdoor"}
})