local PANEL = {}
local fontWidth, fontHeight = surface.GetTextSize("Monofonto24")

function PANEL:Init()
    self.colour = fo.ui.GetHUDColor()
    self.state = "normal"
    self.content = {"No message content error!"}
    self:SetPos(0,0)
    self:SetSize(ScrW() *.25,ScrH() *.15)
end

function PANEL:SetColor(col)
    self.colour = col
end

function PANEL:SetState(state)
    self.state = state
end

function PANEL:SetMessage(message)
    self.content = fo.string.WrapText(message, "Monofonto24", self:GetWide()-ScrW()*.068)
end

-- Pre-load materials
local frame = Material("forp/border")
local states = {
    normal = Material("forp/notify/happy.png"),
    sad = Material("forp/notify/sad.png"),
    caps = Material("forp/notify/cap.png"),
    lock = Material("forp/notify/lock.png"),
    gift = Material("forp/notify/gift.png"),
    ncr = Material("forp/notify/ncr.png"),
    legion = Material("forp/notify/legion.png"),
    bos = Material("forp/notify/bos.png"),
    key = Material("forp/notify/key.png"),
    map = Material("forp/notify/map.png"),
    pain = Material("forp/notify/pain.png"),
    radio = Material("forp/notify/radio.png")
}

function PANEL:Paint(w, h)
    -- Drawing frame
    surface.SetDrawColor(self.colour)
    surface.SetMaterial(frame)
    surface.DrawTexturedRect(0, 0, w, h)
    
    -- Drawing state icon
    local iconScale = ScrW()*.08
    surface.SetMaterial(states[self.state])
    surface.DrawTexturedRect(0, 0, iconScale, iconScale)
    
    -- Drawing text
    surface.SetTextColor(self.colour)
    surface.SetFont("Monofonto24")
    fo.ui.DrawWrappedText(self.content, "Monofonto24", self.colour, ScrW()*.068, ScrH()*.02)
end

vgui.Register("forpNotify", PANEL, "DPanel")
