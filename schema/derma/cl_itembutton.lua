local PANEL = {}

function PANEL:Init()
	self:setText("Unknown item")
	self:SetEnabledColor(Color(0, 248, 161))
	self:SetDisabledColor(Color(23, 89, 50))
end

function PANEL:Think()
	local amount = 0
	self.instance = nil
		
	for k, v in pairs(LocalPlayer():getChar():getInv():getItems()) do
		if v.uniqueID == self.itemId && v.functions[self.itmFunc].onCanRun(v) then
			if !self.instance then
				self.instance = v
			end
				
			amount = amount + 1
		end
	end
		
	if amount == 0 then
		self:SetMouseInputEnabled( false )
		self:SetTextColor(self.disabledColor)
	else
		self:SetMouseInputEnabled( true )
		self:SetTextColor(self.enabledColor)
	end
		
	self:setText("("..tostring(amount)..") "..self.itemName)
	
	if self.think then
		self.think()
	end
end

function PANEL:SetEnabledColor(col)
	self.enabledColor = col
end

function PANEL:SetDisabledColor(col)
	self.disabledColor = col
end

function PANEL:DoClick()
	if self.instance then
		netstream.Start("invAct", self.itmFunc, self.instance:getID(), LocalPlayer():getChar():getInv():getID(), self.instance:getID())
	end
end

function PANEL:SetItem(name, id, func)
	self.itemName = name
	self.itemId = id
	self.itmFunc = func
end
	
vgui.Register("forpItemButton", PANEL, "forpButton")