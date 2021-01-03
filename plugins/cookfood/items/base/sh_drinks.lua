ITEM.name = "Food Base Thirst"
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.isFood = true
ITEM.thirstAmount = 30
ITEM.foodDesc = "This is test drink."
ITEM.category = "Drinks"
ITEM.quantity = 1

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		local quantity = item:getData("quantity", item.quantity)

		if (quantity > 1) then
			draw.SimpleText(quantity, "DermaDefault", 5, h-5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, color_black)
		end

	end
else
	function ITEM:onInstanced(index, x, y, item)
		item:setData("quantity", item.quantity)
	end
end

ITEM.functions.use = {
	name = "Drink",
	tip = "useTip",
	icon = "icon16/cup.png",
	onRun = function(item)
	
			local client = item.player
			
			local quantity = item:getData("quantity", item.quantity)

			client:addThirst(item.thirstAmount) 
			
			if (item.staminaAmount) then
				local value = client:getLocalVar("stm", 0) + item.staminaAmount

				client:setLocalVar("stm", math.max(100, value))
			end

			quantity = quantity - 1

			client:EmitSound(item.usesound)
			
			if (item.givebottlecap) then
				timer.Simple(0.25, function()
					client:EmitSound("fosounds/fix/ui_items_bottlecaps_up_0"..math.random(1,4)..".mp3")
					client:getChar():giveMoney(1)
					client:notify("You have received 1 bottle cap.")
				end)
			end

			if (quantity >= 1) then
				item:setData("quantity", quantity)

				return false
			end

			return true
			
	end
}