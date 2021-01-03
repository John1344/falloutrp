local PANEL = {}

function PANEL:Init()
    local self = self

    self.BaseClass.Init(self)
    --self:SetTitle("Transfer")
    self:BlurBackground(true)
    self:HideHUD(true)

    self.fInv = self:Add("nutInventory")
    self.fInv:SetDraggable(false)
    self.fInv.Paint = function() end
    self.fInv:SetTitle("")
    self.fTitle = self:Add("forpLabel")
    self.fTitle:SetFont("Monofonto24")
    self.fTitle:SetText("Inventory")

    self.sInv = self:Add("nutInventory")
    self.sInv:SetDraggable(false)
    self.sInv.Paint = function() end
    self.sInv:SetTitle("")
    self.sTitle = self:Add("forpLabel")
    self.sTitle:SetFont("Monofonto24")
    self.sTitle:SetText("Cash Register")

    self.quit = self:Add("forpButton")
    self.quit:SetFont("Monofonto24")
    self.quit:SetText("Quit E)")
    self.quit.DoClick = function()
        self:Remove()
    end
end

local MARGIN = 65
local INV_SPACING = 50
local BOTTOM_SPACE = 100

function PANEL:PerformLayout(w, h)
    local fInv = self.fInv
    local fTitle = self.fTitle
    local sInv = self.sInv
    local sTitle = self.sTitle
    local quit = self.quit

    local wide = MARGIN*2 + fInv:GetWide() + sInv:GetWide() + INV_SPACING
    local height = MARGIN*2 + fInv:GetTall() + BOTTOM_SPACE
    self:SetSize(wide, height)
    self:Center()
    local x, y = self:GetPos()

    fInv:SetPos(x + MARGIN, y + MARGIN)
    fTitle:SetPos(MARGIN + 2, MARGIN - 2)
    sInv:SetPos(x + MARGIN + fInv:GetWide() + INV_SPACING, y + MARGIN)
    sTitle:SetPos(MARGIN + 2 + fInv:GetWide() + INV_SPACING, MARGIN - 2)
    quit:SetPos(wide - quit:GetWide() - MARGIN - 4, height - MARGIN - BOTTOM_SPACE/2)
end

function PANEL:SetFirstInv(inv)
    self.fInv:setInventory(inv)
end

function PANEL:SetFirstInvTitle(title)
    self.fTitle:SetText(title)
end

function PANEL:SetSecondInv(inv)
    self.sInv:setInventory(inv)
end

function PANEL:SetSecondTitle(title)
    self.sTitle:SetText(title)
end

vgui.Register("forpInvTransfer", PANEL, "forpPanel")