ITEM.name = "Food Base"
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.isFood = true
ITEM.cookable = true
ITEM.hungerAmount = 30
ITEM.foodDesc = "This is test food."
ITEM.category = "Food"
ITEM.mustCooked = false
ITEM.quantity = 1

function ITEM:getDesc()
	local str = L(self.foodDesc or "ERROR")

	if (!IsValid(self.entity)) then
		if (self.mustCooked != false) then
			str = str .. "\n" .. L"cookNeeded"
		end

		if (self.cookable != false) then
			local cookData = COOKLEVEL[(self:getData("cooked") or 1)]

			str = (str .. "\n" .. L"cookedLevel" ..L(cookData[1]))
		end
	end

	return str
end

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		local cooked = item:getData("cooked", 1)
		local quantity = item:getData("quantity", item.quantity)

		if (quantity > 1) then
			draw.SimpleText(quantity, "DermaDefault", 5, h-5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, color_black)
		end

		if (cooked > 1) then
			local col = COOKLEVEL[cooked][3]

			surface.SetDrawColor(col.r, col.g, col.b, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
else
	function ITEM:onInstanced(index, x, y, item)
		item:setData("quantity", item.quantity)
	end
end

local function canEat(ply, item)
	
	local curHunger = CurTime() - ply:getHunger()

	local futureHunger = CurTime() - math.Clamp(math.min(curHunger, getHungerSec()) - (item.hungerAmount * COOKLEVEL[item:getData("cooked", 1)][2]), 0, getHungerSec())
	
	local percent = (CurTime() - futureHunger) / getHungerSec()
	
		if percent > 1 then
			return false
		end
		
	return true
	
end

ITEM.functions.use = {
	name = "Eat",
	tip = "useTip",
	icon = "icon16/cup.png",
	onRun = function(item)
	
			local client = item.player
			
			local cooked = item:getData("cooked", 1)
			local quantity = item:getData("quantity", item.quantity)
			local mul = COOKLEVEL[cooked][2]

			client:addHunger(item.hungerAmount * mul) 
			
			if (item.staminaAmount) then
				local value = client:getLocalVar("stm", 0) + item.staminaAmount

				client:setLocalVar("stm", math.max(100, value))
			end

			quantity = quantity - 1

			client:EmitSound(item.usesound)

			if (quantity >= 1) then
				item:setData("quantity", quantity)

				return false
			end

			return true
			
	end,
	onCanRun = function(item)
		if (item.mustCooked and item:getData("cooked", 1) == 1) then
			return false
		end

		--return (!IsValid(item.entity))
		return true
	end
}