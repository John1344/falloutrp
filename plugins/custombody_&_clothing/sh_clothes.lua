----------------------------
--[[ Clothing metatable ]]--
----------------------------
local ITEM = {}

function ITEM:paintOver(self, item, w, h)
    if ( item:getData("equip") ) then
        surface.SetDrawColor(110, 255, 110, 100)
        surface.DrawRect(w - 14, h - 14, 8, 8)
    end
end

function ITEM.hooks.drop(item)
    if ( self:getData("equip") ) then
        self.player:notify("You must unequip the item before doing that.")
        return false
    end
end

function ITEM:onCanBeTransfered(self, oldInv, newInv)
    if ( oldInv and newInv and self:getData("equip") ) then
        if ( SERVER ) then
            self.player:notify("You must unequip the item before doing that.")
        end
        return false
    end

    return true
end

ITEM.functions.Wear = {
    name = "Wear",
    tip = "equipTip",
    icon = "icon16/tick.png",
    onRun = function(item)
        if ( SERVER ) then
            local ply = item.player
                        
            return false
        end
    end,
    onCanRun = function(item)
    end
}

ITEM.functions.TakeOff = {
    name = "Take Off",
    tip = "equipTip",
    icon = "icon16/cross.png",
    onRun = function(item)
        if ( SERVER ) then
            local ply = item.player
                    
            return false
        end
    end,
    onCanRun = function(item)
    end
}



---------------------------
--[[ All items methods ]]--
---------------------------
local Item = nut.meta.item


function Item:IsClothing()
    return self.ClotheStruct
end


function Item:SetClothing(clotheStruct)
    -- Load clothing metatable on item
    setmetatable(self, ITEM)

    -- Register clothe structure
    self.ClotheStruct = clotheStruct
end