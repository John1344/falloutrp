local SCHEMA = SCHEMA
local Panel = FindMetaTable("Panel")


SCHEMA.BlurPanel = SCHEMA.BlurPanel or vgui.Create("DPanel")
SCHEMA.BlurPanel:SetSize(sW(), sH())
SCHEMA.BlurPanel:Hide()
local blurPanel = SCHEMA.BlurPanel

SCHEMA.BlurPanels = SCHEMA.BlurPanels or {}

function Panel:BlurBackground(state)
    if ( state ) then
        SCHEMA.BlurPanels[self] = true
    else
        SCHEMA.BlurPanels[self] = nil
    end
end

hook.Add("HUDPaintBackground", "forp_blur_panels", function()
    for p, _ in pairs (SCHEMA.BlurPanels) do
        if ( IsValid(p) ) then
            Derma_DrawBackgroundBlur(blurPanel)
        else
            SCHEMA.BlurPanels[p] = nil
        end
    end
end)


SCHEMA.HideHUDPanels = SCHEMA.HideHUDPanels or {}

function Panel:HideHUD(state)
    if ( state ) then
        SCHEMA.HideHUDPanels[self] = true
    else
        SCHEMA.HideHUDPanels[self] = nil
    end
end

hook.Add("FalloutHUDShouldDraw", "forp_Interface", function()
    for p, _ in pairs (SCHEMA.HideHUDPanels) do
        if ( IsValid(p) ) then
            return false
        else
            SCHEMA.HideHUDPanels[p] = nil
        end
    end
end)

hook.Add("OnSpawnMenuOpen", "lpRestrictSpawnMenu", function()
    for p, _ in pairs (SCHEMA.HideHUDPanels) do
        if ( IsValid(p) ) then
            return false
        else
            SCHEMA.HideHUDPanels[p] = nil
        end
    end
end)

hook.Add("CanDrawDoorInfo", "lpHideDoorInfo", function()
    for p, _ in pairs (SCHEMA.HideHUDPanels) do
        if ( IsValid(p) ) then
            return false
        else
            SCHEMA.HideHUDPanels[p] = nil
        end
    end
end)

hook.Add("CanDrawEntInt", "lpHideDoorInfo", function()
    for p, _ in pairs (SCHEMA.HideHUDPanels) do
        if ( IsValid(p) ) then
            return false
        else
            SCHEMA.HideHUDPanels[p] = nil
        end
    end
end)