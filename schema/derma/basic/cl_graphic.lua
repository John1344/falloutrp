local PANEL = {}

function PANEL:Init()
    self.colour = fo.ui.GetHUDColor()
end

function PANEL:SetImage(image)
    self.material = Material(image)
end

function PANEL:SetColor(color)
    self.colour = color
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(self.colour)
    surface.SetMaterial(self.material)
    surface.DrawTexturedRect(0, 0, w, h)
end

vgui.Register("forpGraphic", PANEL, "DPanel")

