local PLUGIN = PLUGIN

-- Corpse accessors list
local cur_corpse_vars = {
	"Entity",
	"Inventory",
	"Money",
	"Name"
}

-- Create all corpse accessors
for _, v in pairs(cur_corpse_vars) do
	local name = "Corpse"..v
	AccessorFunc(PLUGIN, name, name)
end

-- Set to nil all corpse vars
function PLUGIN:EraseCorpseVars()
	for _, v in pairs(cur_corpse_vars) do
		PLUGIN["SetCorpse"..v](PLUGIN, nil)
	end
end

-- Next check to know if the player is looking nearly the corpse
PLUGIN.nextTrace = PLUGIN.nextTrace or 0
-- Request corpse opening when pressing E on a corpse
function PLUGIN:KeyPress(_, key)
	if ( key == IN_USE and CurTime() > PLUGIN.nextTrace ) then
		local entLooked = PLUGIN:EyeTrace(LocalPlayer())

		if ( IsValid(entLooked) and entLooked:IsCorpse() ) then
			PLUGIN:SetCorpseEntity(entLooked)

			netstream.Start("corpses_opn")
		end

		PLUGIN.nextTrace = CurTime() + 0.5
	end
end

-- Request widthdraw corpe money
local function widthdrawMoney(panel)
	local entry = PLUGIN.corpsePanel.widthdrawEntry
	local value = tonumber(entry:GetValue()) or 0

	if ( PLUGIN:GetCorpseMoney() >= value and value > 0 ) then
		surface.PlaySound("hgn/crussaria/items/itm_gold_up.wav")
		netstream.Start("corpses_WdMny", value)
		entry:SetValue(0)
	elseif ( value < 1  ) then
		nut.util.notify(L("provideValidNumber"))
		entry:SetValue(0)
	else
		nut.util.notify(L("cantAfford"))
		entry:SetValue(0)
	end
end

-- Request deposit corpe money
local function depositMoney(panel)
	local entry = PLUGIN.corpsePanel.depositEntry
	local value = tonumber(entry:GetValue()) or 0

	if ( value and value > 0 ) then

		if ( LocalPlayer():getChar():hasMoney(value) ) then
			surface.PlaySound("hgn/crussaria/items/itm_gold_down.wav")
			netstream.Start("corpses_DpMny", value)
			entry:SetValue(0)
		else
			nut.util.notify(L("provideValidNumber"))
			entry:SetValue(0)
		end

	else
		nut.util.notify(L("cantAfford"))
		entry:SetValue(0)
	end
end

-- Update corpse money on interface
function PLUGIN:UpdateWidthdrawText()
	local corpsePanel = PLUGIN.corpsePanel

	if ( corpsePanel ) then
		corpsePanel.widthdrawText:SetText(PLUGIN:GetCorpseMoney())
	end
end

-- Set the widthdraw entry value on interface to corpse money
function PLUGIN:SetWidthdrawEntryToMax()
	local corpsePanel = PLUGIN.corpsePanel

	if ( corpsePanel ) then
		corpsePanel.widthdrawEntry:SetValue(PLUGIN:GetCorpseMoney())
	end
end

-- Receive Serverside corpse money
netstream.Hook("corpses_mny", function(value)
	PLUGIN:SetCorpseMoney(value)
	PLUGIN:UpdateWidthdrawText()
end)

local UNKNOWN_CORPSE_NAME = "Corpse"

function PLUGIN:OpenInterface()

	PLUGIN.InterfaceOpened = true

	-- Player inventory
	nut.gui.inv1 = vgui.Create("nutInventory")
	nut.gui.inv1:ShowCloseButton(true)
	nut.gui.inv1:SetTitle("Your inventory")

	local oldClose = nut.gui.inv1.OnClose
	nut.gui.inv1.OnClose = function()
		if (IsValid(PLUGIN.corpsePanel) and not IsValid(nut.gui.menu)) then
			PLUGIN:CloseInterface()
		end

		netstream.Start("corpses_ext")

		oldClose()
	end

	local inventory2 = LocalPlayer():getChar():getInv()
	if (inventory2) then
		nut.gui.inv1:setInventory(inventory2)
	end

	-- Adjust inventory size to show deposit elements
	nut.gui.inv1:SetSize(nut.gui.inv1:GetWide(), nut.gui.inv1:GetTall() + 48)

	local depositText = nut.gui.inv1:Add("DLabel")
	depositText:Dock(BOTTOM)
	depositText:DockMargin(0, 0, nut.gui.inv1:GetWide()/2, 0)
	depositText:SetTextColor(color_white)
	depositText:SetFont("nutGenericFont")
	depositText:SetText( nut.currency.get(LocalPlayer():getChar():getMoney()) )
	depositText.Think = function()
		local char = LocalPlayer():getChar()

		if ( char ) then
			depositText:SetText( nut.currency.get(char:getMoney()) )
		end
	end

	local depositEntry = nut.gui.inv1:Add("DTextEntry")
	depositEntry:Dock(BOTTOM)
	depositEntry:SetNumeric(true)
	depositEntry:DockMargin(nut.gui.inv1:GetWide()/2, 0, 0, 0)
	depositEntry:SetValue(0)
	depositEntry.OnEnter = depositMoney

	local depositButton = nut.gui.inv1:Add("DButton")
	depositButton:Dock(BOTTOM)
	depositButton:DockMargin(nut.gui.inv1:GetWide()/2, 40, 0, -40)
	depositButton:SetTextColor( Color( 255, 255, 255 ) )
	depositButton:SetText("Deposit")
	depositButton.DoClick = depositMoney
	
	-- Victim inventory
	local inventory = PLUGIN:GetCorpseInventory()

	local corpsePanel = vgui.Create("nutInventory")
	corpsePanel:ShowCloseButton(true)

	local title
	local corpseName = PLUGIN:GetCorpseName()

	if ( corpseName ) then
		title = corpseName.."'s' inventory"
	else
		title = UNKNOWN_CORPSE_NAME.." inventory"
	end

	corpsePanel:SetTitle(title)
	corpsePanel:setInventory(inventory)
	corpsePanel.OnClose = function(this)
		if (IsValid(nut.gui.inv1) and not IsValid(nut.gui.menu)) then
			PLUGIN:CloseInterface()
		end

		netstream.Start("corpses_ext")
	end

	-- Adjust inventory size to show widthdraw elements
	corpsePanel:SetSize(corpsePanel:GetWide(), corpsePanel:GetTall() + 48)

	local widthdrawText = corpsePanel:Add("DLabel")
	widthdrawText:Dock(BOTTOM)
	widthdrawText:DockMargin(0, 0, corpsePanel:GetWide()/2, 0)
	widthdrawText:SetTextColor(color_white)
	widthdrawText:SetFont("nutGenericFont")

	local widthdrawEntry = corpsePanel:Add("DTextEntry")
	widthdrawEntry:Dock(BOTTOM)
	widthdrawEntry:SetNumeric(true)
	widthdrawEntry:DockMargin(corpsePanel:GetWide()/2, 0, 0, 0)
	widthdrawEntry.OnEnter = widthdrawMoney

	local widthdrawButton = corpsePanel:Add("DButton")
	widthdrawButton:Dock(BOTTOM)
	widthdrawButton:DockMargin(corpsePanel:GetWide()/2, 40, 0, -40)
	widthdrawButton:SetTextColor( Color( 255, 255, 255 ) )
	widthdrawButton:SetText("Widthdraw")
	widthdrawButton.DoClick = widthdrawMoney

	nut.gui["inv"..inventory:getID()] = corpsePanel

	-- Center panels
	local OFFSET = 4

	local x, y = corpsePanel:GetPos()
	local corpseInvWide = corpsePanel:GetWide()
	local plyInvWide = nut.gui.inv1:GetWide()
	local totalWidth = corpseInvWide + OFFSET + plyInvWide

	local newX = (ScrW() - totalWidth) / 2

	corpsePanel:SetPos(newX, y)
	nut.gui.inv1:SetPos(newX + corpseInvWide + OFFSET, y)

	PLUGIN.corpsePanel = corpsePanel
	corpsePanel.depositEntry = depositEntry
	corpsePanel.widthdrawText = widthdrawText
	corpsePanel.widthdrawEntry = widthdrawEntry
	corpsePanel.widthdrawButton = widthdrawButton

end

function PLUGIN:CloseInterface()
	PLUGIN.InterfaceOpened = false

	if ( IsValid(nut.gui.inv1) ) then
		nut.gui.inv1:Remove()
	end

	if ( IsValid(PLUGIN.corpsePanel) ) then
		PLUGIN.corpsePanel:Remove()
	end
end

function PLUGIN:GetRecognizedCorpseName(corpse)
	local char = LocalPlayer():getChar()

	if ( char and char.doesRecognize and char:doesRecognize(corpse:GetNW2Int("corpseChrId")) ) then
		local corpseName = corpse:GetNW2String("corpseChrName")
		return corpseName
	end
end

-- Setup corpse vars received from Server and open interface ( this request is received after the corpse searching progress bar is done )
netstream.Hook("corpses_opn", function(invId, money)
	local corpse = PLUGIN:GetCorpseEntity()
	local inventory = nut.item.inventories[invId]

	if ( IsValid(corpse) and inventory and isnumber(money) ) then
		PLUGIN:SetCorpseInventory(inventory)
		PLUGIN:SetCorpseMoney(money)
		PLUGIN:SetCorpseName(PLUGIN:GetRecognizedCorpseName(corpse))

		PLUGIN:OpenInterface()
		PLUGIN:UpdateWidthdrawText()
		PLUGIN:SetWidthdrawEntryToMax()
	end
end)

function PLUGIN:Think()
	if ( !PLUGIN.InterfaceOpened ) then return end

	if ( CurTime() < (PLUGIN.NextTraceCheck or 0) ) then return end
	PLUGIN.NextTraceCheck = CurTime() + 0.1

	local corpse = PLUGIN:GetCorpseEntity()

	if ( not IsValid(corpse) or PLUGIN:EyeTrace(LocalPlayer()) ~= corpse ) then
		PLUGIN:CloseInterface()
	end
end

-- Close corpse interface
netstream.Hook("corpses_ext", function(invId, money)
	PLUGIN:CloseInterface()
end)