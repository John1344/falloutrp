--[[ Meta tables ]]--

local ItemMeta = nut.meta.item



--[[ Item interactions checks ]]--

function clothes.CanWearItem(ply, item)

    local clothe = item.ClotheInfo
    local slot = clothe.Type

    if (clothes.GetItem(ply, slot)) then return false end
    if (item:getData("equip")) then return false end
    if (clothe.maleonly && ply:GetGender() == "female") then return false end
    if (clothe.blockothers && table.Count(clothes.GetItems(ply)) != 0) then return false end
    for k, v in pairs(clothes.GetItems(ply)) do
        if (v.ClotheInfo && v.ClotheInfo.blockothers) then return false end
    end
    local mask = clothes.GetItem(ply, "Mask")
    local fullhat = clothes.GetItem(ply, "Fullhat")
    if (slot == "Glasses" && ((mask && !mask.ClotheInfo.allowglasses) or (fullhat && !fullhat.ClotheInfo.allowglasses))) then return false end
    if (!clothe.allowglasses && (slot == "Mask" or slot == "Fullhat") && clothes.GetItem(ply, "Glasses")) then return false end
    if (IsValid(item.entity)) then return false end

    return true
    
end

function clothes.CanTakeOffItem(ply, item)

    local clothe = item.ClotheInfo
    local slot = item.Type
            
    if (!clothes.GetItem(ply, slot)) then return false end
    if (!item:getData("equip")) then return false end
    if (IsValid(item.entity)) then return false end

    return true
    
end



--[[ Add clothes on items ]]--

function ItemMeta:SetClothing(clotheInfo)

    self:LoadClothingFuncs()

    self.ClotheInfo = clotheInfo

end

function ItemMeta:LoadClothingFuncs()

    function self:paintOver(item, w, h)
        if ( item:getData("equip") ) then
            surface.SetDrawColor(110, 255, 110, 100)
            surface.DrawRect(w - 14, h - 14, 8, 8)
        end
    end

    self:hook("drop", function(item)
        if ( item:getData("equip") ) then
            item.player:notify("You must unequip the item before doing that.")
            return false
        end
    end)

    self.functions.Equip = {
        name = "Wear",
        tip = "equipTip",
        icon = "icon16/tick.png",
        onRun = function(item)
            if ( SERVER ) then
                local ply = item.player
                
                clothes.WearItem(ply, item, true)
                item:setData("equip", true)
                
                return false
            end
        end,
        onCanRun = function(item)
            local ply = item.player or LocalPlayer()

            return clothes.CanWearItem(ply, item)
        end
    }

    self.functions.EquipUn = {
        name = "Take Off",
        tip = "equipTip",
        icon = "icon16/cross.png",
        onRun = function(item)
            if ( SERVER ) then
                local ply = item.player
                
                clothes.WearItem(ply, item, true)
                item:setData("equip", false)
                
                return false
            end
        end,
        onCanRun = function(item)
            local ply = item.player or LocalPlayer()
        
            return clothes.CanTakeOffItem(ply, item)
        end
    }

    function self:onCanBeTransfered(oldInventory, newInventory)
    
        if ( oldInventory && newInventory and self:getData("equip") ) then
            if ( SERVER ) then
                self.player:notify("You must unequip the item before doing that.")
            end
            return false
        end

        return true
    end

end



function ItemMeta:IsClothing()

    return self.ClotheInfo

end