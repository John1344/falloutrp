local Player = FindMetaTable("Player")


if ( CLIENT ) then
	local forpNotifyQueue = forpNotifyQueue or {}

	local function displayNotify(message, state, colour)
		local notify = vgui.Create("forpNotify")
		notify:SetMessage(message)
		if ( state ) then
			notify:SetState(state) -- Sets icon 
		end
		if ( colour ) then
			notify:SetColor(colour)
		end
		surface.PlaySound("forp/notify.mp3") -- Play dat bing
		timer.Simple(7, function() 
			table.remove(forpNotifyQueue, 1) -- Remove from table

			if ( forpNotifyQueue[1] ) then
				notify:Remove()
				local nextNotify = forpNotifyQueue[1] -- Get what notification is next in line
				displayNotify(nextNotify[1], (nextNotify[2] or nil), (nextNotify[3] or nil)) -- Display it
			else
				notify:AlphaTo(0, 1, 0, function() notify:Remove() end) -- Fade out if it's the last notification
			end
		end)
	end

	function pushNotify(message, state, colour)
		table.insert(forpNotifyQueue, {message, (state or nil), (colour or nil)}) -- Put in queue

		if ( #forpNotifyQueue == 1 ) then -- If nothing is in front; display
			return displayNotify(message, (state or nil), (colour or nil))
		end
	end

	netstream.Hook("foNotify", pushNotify)
	netstream.Hook("foNotifyLocalized", function(message, translateCodes, state, colour)
		pushNotify(L(message, unpack(translateCodes)), (state or nil), (colour or nil))
	end)
end

-- Hijack the nutscript notification system and route it through fallout notify
function nut.util.notify(message, client)
	(client or LocalPlayer()):foNotify(message)
end

-- State can be: normal, sad, caps, lock, gift, ncr, legion, bos, key, map, pain and radio | Colour will auto set based on clients ui colour
function Player:foNotify(message, state, colour)
	if ( SERVER ) then
		netstream.Start(self, "foNotify", message, (state or nil), (colour or nil))
	else
		pushNotify(message, (state or nil), (colour or nil))
	end
end

-- Notify a translated message
function Player:foNotifyLocalized(message, translateCodes, state, colour) -- Translate codes is a tables
	if ( SERVER ) then
		netstream.Start(self, "foNotifyLocalized", message, translateCodes, (state or nil), (colour or nil))
	else
		pushNotify(L(message, unpack(translateCodes)), (state or nil), (colour or nil))
	end
end


-- Get the looked entity for a certain distance
function Player:GetLookedEntity(dist)
    local d = {}
    d.filter = self
    d.start = self:GetShootPos()
    d.endpos = d.start + self:GetAimVector()*dist

    return util.TraceLine(d).Entity
end

-- Get half the ping of a player ( used for lag compensation )
function Player:NetLag()
    return self:Ping() / 2000
end