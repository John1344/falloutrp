local PANEL = {}
local alpha = 0
local titleNV = Material("thespireroleplay/vgui/charmenu/main.png")
local w = 0
local h = 0

function PANEL:SetImage(path)

	titleNV = Material(path)

end

function PANEL:SetImageSize(x, y)
	w = x
	h = y
end

function PANEL:SetDisabled(disabled)
	self.Disabled = disabled
end

function PANEL:GetDisabled()
	return self.Disabled
end

function PANEL:SetDepressed(depressed)
	self.Depressed = depressed
end

function PANEL:GetDepressed()
	return self.Depressed
end

function PANEL:SetHovered(hovered)
	self.Hovered = hovered
end

function PANEL:GetHovered()
	return self.Hovered
end

function PANEL:OnCursorEntered()
	if (!self:GetDisabled()) then
		surface.PlaySound("forp/ui_menu_focus.wav")
		self:SetHovered(true)
	end
	DLabel.ApplySchemeSettings(self)
end

function PANEL:OnCursorExited()
	self:SetHovered(false)
	DLabel.ApplySchemeSettings(self)
end

function PANEL:OnMousePressed(code)
	self:MouseCapture(true)
	self:SetDepressed(true)
end

function PANEL:OnMouseReleased(code)
	self:MouseCapture(false)
	
	if (!self:GetDepressed()) then
		return
	end
	
	self:SetDepressed(false)
	
	if (!self:GetHovered()) then
		surface.PlaySound("forp/ui_menu_cancel.wav")
		return
	end
	
	if (code == MOUSE_LEFT and self.DoClick
	and !self:GetDisabled()) then
		self.DoClick(self)
	end
end

function PANEL:FadeOut(speed, Callback)
	self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
		panel:SetAlpha(255 - (delta * 255))
		
		alpha = (255 - (delta * 255))

		if (animation.Finished) then
			panel:SetVisible(false)
				if (Callback) then
					Callback()
				end
			self.animation = nil
		end
	end)
	
	if (self.animation) then
		self.animation:Start(speed)
	end
	
end

function PANEL:FadeIn(speed, Callback)
	self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
		panel:SetAlpha(delta * 255)
		
		alpha = (delta * 255)
		
		if (animation.Finished) then
			if (Callback) then
				Callback()
			end
			
			self.animation = nil
		end
	end)
	
	if (self.animation) then
		self.animation:Start(speed)
	end
	
	self:SetVisible(true)
end

function PANEL:OverrideTextColor(color)
	if (color) then
		self.OverrideColorNormal = color
		self.OverrideColorHover = Color(math.max(color.r + 20, 0), math.max(color.g + 20, 0), math.max(color.b + 20, 0), color.a)
	else
		self.OverrideColorNormal = nil
		self.OverrideColorHover = nil
	end
end

function PANEL:Paint(w, h) 

		surface.SetDrawColor(255,255,255,alpha)
		surface.SetMaterial(titleNV)
		surface.DrawTexturedRect(0, 0, w, h)

end

function PANEL:Think()
	if (self.animation) then
		self.animation:Run()
	end
	
	local colorWhite = Color(255,255,255,255)
	local colorDisabled = Color(
		math.max(colorWhite.r + 20, 0),
		math.max(colorWhite.g + 20, 0),
		math.max(colorWhite.b + 20, 0),
		255
	)
	local colorInfo = Color(255,100,0,255)
	
	if (self:GetDisabled()) then
		self:SetTextColor(self.OverrideColorHover or colorDisabled)
	elseif (self:GetHovered()) then
		self:SetTextColor(self.OverrideColorHover or colorInfo)
	else
		self:SetTextColor(self.OverrideColorNormal or colorWhite)
	end
	
	self:SetExpensiveShadow(1, Color(0, 0, 0, 150))
end

function PANEL:SetCallback(Callback)
	self.DoClick = function(button)
		surface.PlaySound("forp/ui_menu_ok.wav")
		Callback(button)
	end
end

vgui.Register("nsFade", PANEL, "DLabel")