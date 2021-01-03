-- Teleport a player to a door
function SCHEMA:TeleportPlayer(UID, client)
	for _, ent in pairs(ents.FindByClass("forp_teleportdestination")) do
		if ent:GetUID() == UID then
			netstream.Start(client, "nut_Teleporting", false)
			client:ScreenFade(SCREENFADE.OUT, Color(0,0,0), 0.7, 0.5)
			client:Freeze(true)
			client:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			client:EmitSound("doors/latchunlocked1.wav")

			timer.Simple(0.7, function()
				client:SetPos(ent:GetPos() + Vector(0,0,10))
				client:SetEyeAngles(Angle(0, ent:GetAngles().yaw - 90, 0))
				client:Freeze(false)
				client:ScreenFade(SCREENFADE.IN, Color(0,0,0), 0.7, 0.5)

				timer.Simple(0.75, function()
					client:EmitSound("doors/door_wood_close1.wav")
				end)

				timer.Simple(1.5, function()
					netstream.Start(client, "nut_Teleporting", true)
				end)
				
				timer.Simple(10, function()
					client:SetCollisionGroup(COLLISION_GROUP_PLAYER)
				end)
			end) 

			return
		end
	end
end


//Load teleporters

local mapName = game.GetMap()
local teleporterTable = FORP_TELEPORTERS[mapName]

function LoadTeleporters()

	if !teleporterTable then return end

	for k, v in pairs(teleporterTable.doorinfo) do
		local teleport = ents.Create("forp_teleport")
		teleport:SetPos(v.pos)
		teleport:SetAngles(v.angs)
		teleport:Spawn()
		teleport:SetNoDraw(true)
	
		local phys = teleport:GetPhysicsObject()
		if (phys and phys:IsValid()) then
			phys:EnableMotion(false)
		end
	
		teleport:SetType(v.Type)
		teleport:SetDestination(v.dest)
		teleport:SetUID(v.uid)
		teleport.doorindex = k
	end
	
	for k, v in pairs(teleporterTable.destinfo) do
		local teleport = ents.Create("forp_teleportdestination")
		teleport:SetPos(v.pos)
		teleport:SetAngles(v.angs)
		teleport:Spawn()
		teleport:SetNoDraw(true)
	
		local phys = teleport:GetPhysicsObject()
		if (phys and phys:IsValid()) then
			phys:EnableMotion(false)
		end
	
		teleport:SetUID(v.uid)		
	end
	
	for k, v in pairs(ents.FindByClass( "forp_teleport" )) do
		v.otherDoors = {}
		for k2, v2 in pairs(teleporterTable.linkData) do
			if table.HasValue(v2, v.doorindex) then
				for k3, v3 in pairs(v2) do
					if v3 != v.doorindex then
						for k4, v4 in pairs(ents.FindByClass( "forp_teleport" )) do
							if v4.doorindex == v3 then
								table.insert(v.otherDoors, v4)
							end
						end
					end
				end
			end
		end
	end
		
end

--[[ local FOLDER_NAME = "nutscript/forp_teleporters"
local FILE_NAME = game.GetMap()
local FILE_EMPLACEMENT = FOLDER_NAME.."/"..FILE_NAME..".txt"



if !nutFakedoors then
	nutFakedoors = {}
end

// Commandes pour ajouter des teleporters
nut.command.add("registerfakedoor", {
	superadminOnly = true,
	syntax = "<number id>",
	onRun = function(client, arguments)
		if IsValid(client) && IsValid(client:GetEyeTraceNoCursor().Entity) then
			local ent = client:GetEyeTraceNoCursor().Entity
			local id = tonumber(arguments[1])
			
			ent:setNetVar("name", "DOOR REGISTERED "..tostring(id))
			ent.id = id
			
			if !nutFakedoors[id] then
				nutFakedoors[id] = {}
			end
			
			table.insert(nutFakedoors[id], ent.doorindex)
			
			if !file.Write( FILE_EMPLACEMENT, util.TableToJSON( nutFakedoors ) ) then
				file.CreateDir(FOLDER_NAME)
			end
				
		end
	end
})

nut.command.add("deletefakedoor", {
	superadminOnly = true,
	syntax = "<bool all>, <string id>",
	onRun = function(client, arguments)
		if IsValid(client) then
			local all = false
			if arguments[1] == "true" then
				all = true
			end
			
			local id
			
			if !arguments[2] then
				id = tonumber(arguments[1])
			else
				id = tonumber(arguments[2])
			end
			
			if all == true && !id then
				for k, v in pairs(ents.FindByClass( "forp_teleport" )) do
					v:setNetVar("name", "unregistered")
					v.id = nil
				end
				nutFakedoors = {}
			elseif id then
				
				for k, v in pairs(ents.FindByClass( "forp_teleport" )) do
					if v.id == id then
						v:setNetVar("name", "unregistered")
						v.id = nil
					end
				end
				
				nutFakedoors[id] = nil
			end
			file.Write( FILE_EMPLACEMENT, util.TableToJSON( nutFakedoors ) )
		end
	end
})

nut.command.add("printfakedoors", {
	superadminOnly = true,
	syntax = "<bool all>, <string id>",
	onRun = function(client, arguments)
		if nutFakedoors and #nutFakedoors > 0 then
			PrintTable(nutFakedoors)
		else
			print("Table empty")
		end
	end
})

nut.command.add("getdoorindex", {
	superadminOnly = true,
	syntax = "<bool all>, <string id>",
	onRun = function(client, arguments)
		local ent = client:GetEyeTrace().Entity
		
		if IsValid(ent) && ent.doorindex then
			client:notify(ent.doorindex)
		end
	end
})

nut.command.add("showfakedoorsid", {
	superadminOnly = true,
	onRun = function(client, arguments)
		for k, v in pairs(ents.FindByClass("forp_teleport")) do
			local index
			
			for k2, v2 in pairs(nutFakedoors) do
				if table.HasValue(v2, v.doorindex) then
					index = k2
				end
			end
			
			if index then
				v.id = index
				v:setNetVar("name", "DOOR REGISTERED "..tostring(index))
			end
		end
	end
})

nut.command.add("tptofakedoorwithtid", {
	superadminOnly = true,
	syntax = "<bool generateTbl>",
	onRun = function(client, arguments)
		
		if arguments[1] == "true" then
		
			client.doorwithtid = {}
			client.doorwithtidindex = 1
			for k, v in pairs(ents.FindByClass("forp_teleport")) do
				if !v.id then
					table.insert(client.doorwithtid, v)
				end
			end
		end
		
		if !IsValid(client.doorwithtid[client.doorwithtidindex or 1]) or !client.doorwithtid[client.doorwithtidindex or 1].id then
			client.doorwithtindex = 1
		end
		
		if !client.doorwithtid[client.doorwithtidindex or 1].id then
			if IsValid(client.doorwithtid[client.doorwithtidindex or 1]) then
				client:SetPos(client.doorwithtid[client.doorwithtidindex or 1]:GetPos())
			end
		end
		
		client.doorwithtidindex = client.doorwithtidindex + 1
		if client.doorwithtidindex > #client.doorwithtid then
			client.doorwithtidindex = 1
		end
	end
})


nut.command.add("printfakedoorsforlua", {
	superadminOnly = true,
	onRun = function(client, arguments)
		
		local stringToPrint = ""
	
		for k, v in pairs(nutFakedoors) do
			
			stringToPrint = stringToPrint.."{"
			
			for k2, v2 in pairs(v) do
				
				stringToPrint = stringToPrint..tostring(v2)
			
				if k2 != #v then
					stringToPrint = stringToPrint..", "
				end
			end
			
			if k != #nutFakedoors then
				stringToPrint = stringToPrint.."},\n"
			else
				stringToPrint = stringToPrint.."}"
			end
			
		end
		
		print(stringToPrint)
	end
}) ]]