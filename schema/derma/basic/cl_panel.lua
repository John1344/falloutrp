local PANEL = {}
local fontWidth, fontHeight = surface.GetTextSize("Monofonto24")

function PANEL:Init()
    self.colour = fo.ui.GetHUDColor()
    self.title = ""
    self:MakePopup()
end

function PANEL:SetTitle(title)
    self.title = string.upper(title) -- All fallout frame titles are capitalized
    surface.SetFont("Monofonto24")
    self.textsize = surface.GetTextSize(self.title) -- Cache the text size
end

function PANEL:GetRealBounds(thickness) -- wip function, used for getting position for child elements
    local thickness = thickness or 16
    local w, h = self:GetSize()
    local x, y = 0, 0
    
    return x + (thickness * 2), y + (thickness * 2), w - (thickness * 4), h - (thickness * 4)
end

function PANEL:Paint(w, h)
    -- Drawing frame
    local x, y, w, h = fo.ui.DrawFalloutBlur(0, 0, w, h)
    
    -- Setup colours
    surface.SetDrawColor(self.colour)
    surface.SetTextColor(self.colour)
    
    -- Draw title
    surface.SetFont("Monofonto24")
    surface.SetTextPos(x+w*.07, y*0.7)
    surface.DrawText(self.title)
    
    
    -- Draw border
    if self.textsize then -- if has title
        local textSize = self.textsize
        local lineOneEnd = w*.06
        local lineTwoEnd = w*.08
        surface.DrawRect(x, y, lineOneEnd, 2)
        surface.DrawRect(x+lineTwoEnd+textSize, y, w-lineTwoEnd-textSize+1, 2)
    else
        surface.DrawRect(x, y, w, 2)
    end
    surface.DrawRect(x, y, 2, h)
    surface.DrawRect(x + w, y, 2, h+2)
    surface.DrawRect(x, y + h, w, 2)
end

vgui.Register("forpPanel", PANEL, "DPanel")
