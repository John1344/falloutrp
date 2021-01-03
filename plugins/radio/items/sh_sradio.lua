ITEM.name = "Stationary Radio"
ITEM.model = "models/props_fallout/hamradio.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.category = "Communication"
ITEM.price = 250
ITEM.permit = "elec"
ITEM.desc = ""

local function getText(togga)
	if (togga) then
		return "<color=39, 174, 96>" .. L"On" .. "</color>"
	else
		return "<color=192, 57, 43>" .. L"Off" .. "</color>"
	end
end

function ITEM:getDesc()	
	if (!self.entity or !IsValid(self.entity)) then
		return L("sradioDesc", getText(self:getData("power")), self:getData("freq", "000.0"))
	else
		local data = self.entity:getData()
		
		return L("sradioDescEnt", (self.entity:getData("power") and "On" or "Off"), self.entity:getData("freq", "000.0"))
	end
end

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		if (item:getData("power")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end

	local GLOW_MATERIAL = Material("sprites/glow04_noz.vmt")
	local COLOR_ACTIVE = Color(0, 255, 0)
	local COLOR_INACTIVE = Color(255, 0, 0)

	function ITEM:drawEntity(entity, item)
		if entity:getData("power") then
			entity:SetMaterial("optinvfallout/hamradio1")
			local dlight = DynamicLight( LocalPlayer():EntIndex() )
			if ( dlight ) then
				dlight.pos = entity:GetPos() + entity:GetForward() * 3 + entity:GetUp() * 0 + entity:GetRight() * -0.5
				dlight.r = 255
				dlight.g = 255
				dlight.b = 153
				dlight.brightness = 0.25
				dlight.Decay = 2000
				dlight.Size = 128
				dlight.DieTime = CurTime() + 1
			end
		else
			entity:SetMaterial("models/lazarusprops/hamradio")
		end
	
		entity:DrawModel()
		
		local position = entity:GetPos() + entity:GetForward() * 1.5 + entity:GetUp() * 0 + entity:GetRight() * -0.5

		render.SetMaterial(GLOW_MATERIAL)
		--render.DrawSprite(position, 14, 14, entity:getData("power", false) and COLOR_ACTIVE or COLOR_INACTIVE)
	end
end

// On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.toggle = { -- sorry, for name order.
	name = "Toggle",
	tip = "useTip",
	icon = "icon16/connect.png",
	onRun = function(item)
		item:setData("power", !item:getData("power", false), nil, nil)
		item.player:EmitSound("buttons/button14.wav", 70, 150)

		return false
	end,
}

ITEM.functions.use = { -- sorry, for name order.
	name = "Freq",
	tip = "useTip",
	icon = "icon16/wrench.png",
	onRun = function(item)
		netstream.Start(item.player, "radioAdjust", item:getData("freq", "000,0"), item.id)

		return false
	end,
}
