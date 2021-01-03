local PANEL = {}

function PANEL:Init()
	self:SetTextColor(fo.ui.GetHUDColor())
	self:SetFont("Monofonto32")
	self:SetContentAlignment(6)
	self:SetTall(self:GetTall() + 16)
end

function PANEL:Think()
	if (self.animation) then
		self.animation:Run()
	end

	if self.Hovered and !self.CallHover then
		self.CallHover = true
		self:OnHover()
	elseif !self.Hovered and self.CallHover then
		self.CallHover = false
	end

	if (!self.TextFix) then
		self.TextFix = true
		self:SetText(self:GetText().." ")
	end
end

function PANEL:Setup(sx, sy, px, py, font, text)
	self:SetSize(sx, sy)
	self:SetPos(px, py)
	self:SetFont(font)
	self:SetText(text)
end

function PANEL:OnMouseReleased(key)
	self:MouseCapture(false)
	
	if !self.Hovered then
		surface.PlaySound("forp/ui_menu_cancel.wav")
	end

	if (key == MOUSE_LEFT and self.DoClick and self.Hovered) then
		surface.PlaySound("forp/ui_menu_ok.wav")
		self.DoClick(self)
	end
end

function PANEL:FadeIn(speed)
	self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
		panel:SetAlpha(delta * 255)
		
		alpha = (delta * 255)
		
		if (animation.Finished) then
			self.animation = nil
		end
	end)

	if (self.animation) then
		self.animation:Start(speed)
	end
	
	self:SetVisible(true)
end

function PANEL:FadeOut(speed)
	self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
		panel:SetAlpha(255 - (delta * 255))
		
		if (animation.Finished) then
			self.animation = nil
		end
	end)
	
	if (self.animation) then
		self.animation:Start(speed)
	end
	
end

function PANEL:Paint(w, h)
	if self.Hovered then
		local r, g, b = self:GetTextColor().r, self:GetTextColor().g, self:GetTextColor().b

		surface.SetDrawColor(Color(r,g,b,10))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(Color(r,g,b,245))
		surface.DrawRect(0, 0, w, 2)
		surface.DrawRect(0, h-2, w, 2)
		surface.DrawRect(0, 0, 2, h)
		surface.DrawRect(w-2, 0, 2, h)
	end
end

function PANEL:OnHover()
	surface.PlaySound("forp/ui_menu_focus.wav")
end

vgui.Register("SButton", PANEL, "DButton")