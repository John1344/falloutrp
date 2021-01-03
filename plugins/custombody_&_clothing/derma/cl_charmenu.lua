
local PLUGIN = PLUGIN
local PANEL = {}

local gradient = surface.GetTextureID("gui/gradient_up")
local gradient2 = surface.GetTextureID("gui/gradient_down")
local gradient3 = surface.GetTextureID("gui/center_gradient")

local backgroundNV = Material("thespireroleplay/vgui/charmenu/background.png")

function PANEL:Init()
	
	timer.Remove("falloutMenuFadeNS")
	
	if (IsValid(nut.gui.loading)) then
		nut.gui.loading:Remove()
	end
		
	if (IsValid(nut.gui.char) or (LocalPlayer().getChar and LocalPlayer():getChar())) then
		nut.gui.char:Remove()
	end

	nut.gui.char = self

	self:SetSize(ScrW(), ScrH())
	self:SetDrawBackground(false)
	self:MakePopup()

	self.FalloutLogo = vgui.Create("nsFade", self)
	self.FalloutLogo:SetText(" ")
	self.FalloutLogo:FadeIn(1.5)
	self.FalloutLogo:SetImage("thespireroleplay/vgui/charmenu/main.png")
	self.FalloutLogo:SetImageSize(512, 128)
	self.FalloutLogo:SetSize(512,128)
	self.FalloutLogo:SetMouseInputEnabled(false)
	self.FalloutLogo:SetPos(24, ((ScrH() / 2)-42))

	timer.Simple(0.7, function()
				
		if (LocalPlayer().getChar && LocalPlayer():getChar()) then
			self.createButton = vgui.Create("SButton", self)
			self.createButton:SetText("Continue")
			self.createButton:FadeIn(1)
			self.createButton:SetWide(220)
			self.createButton:SetPos(ScrW() - (200 + self.createButton:GetWide()/2), (ScrH() / 2) - 150)
			self.createButton:SetMouseInputEnabled(true)
			self.createButton.DoClick = function(panel)	
					
			self:FadeOutMusic()
			self:Remove()
		end
				
	end
	
	self.continueButton = vgui.Create("SButton", self)
	self.continueButton:SetText("Create")
	self.continueButton:FadeIn(1)
	self.continueButton:SetWide(220)
	self.continueButton:SetPos(ScrW() - (200 + self.continueButton:GetWide()/2), (ScrH() / 2) - 100)
	self.continueButton:SetMouseInputEnabled(true)
	self.continueButton.DoClick = function(panel)
		if IsValid(factionPanel) and factionPanel.Active then
			factionPanel:FadeOut(factionPanel)
			return
		end

		if IsValid(characterPanel) and characterPanel.Active then 
			characterPanel:FadeOut(characterPanel)
			return
		end
	
		if (IsValid(nut.gui.charCreate)) then
			return false
		end
	
		if (nut.characters and table.Count(nut.characters) >= nut.config.get("maxChars")) then
			return false
		end
	
		if (IsValid(self.selector)) then
			self.selector:Remove()
			return
		end
	
		local grace = CurTime() + 0.1
	
		local y = 0
	
		factionPanel = vgui.Create("DPanel", self)
		factionPanel:SetPos(ScrW() - (775), (ScrH() / 2) - 150)
		factionPanel:SetSize(460, 500)
		factionPanel.Active = true
		factionPanel.Paint = function(p, w, h)
			surface.SetDrawColor(50, 50, 50, 0) 
			surface.DrawRect(0, 0, w, h) -- Draw the rect
		end
		factionPanel.FadeOut = function(p)
			local children = p:GetChildren()
			for _, panel in pairs(children) do
				panel:FadeOut(0.25)
			end
			p.Active = false
			timer.Simple(2, function()
				if IsValid(p) then
					p:Remove()
				end
			end)
		end
	
		for k, v in SortedPairs(nut.faction.teams) do
			if (nut.faction.hasWhitelist(v.index)) then
				self.factionSelect = vgui.Create("SButton", factionPanel)
				self.factionSelect:SetText(v.name)
				self.factionSelect:SetWide(450)
				self.factionSelect:FadeIn(0.5)
				self.factionSelect:SetMouseInputEnabled(true)
				self.factionSelect:SetPos(0, y)
				self.factionSelect.DoClick = function(panel)
					PLUGIN.creationfaction = v.index
					if IsValid(factionPanel) and factionPanel.Active then
						factionPanel:FadeOut(factionPanel)
					end
					self:FadeOutMusic()
					self:Remove()
					PLUGIN:PlayIntro()
				end
	
				y = self.factionSelect:GetTall() + 10 + y
			end
		end
	end
	
	self.loadButton = vgui.Create("SButton", self)
	self.loadButton:SetText("Load")
	self.loadButton:FadeIn(1)
	self.loadButton:SetWide(220)
	self.loadButton:SetPos(ScrW() - (200 + self.loadButton:GetWide()/2), (ScrH() / 2) - 50)
	self.loadButton:SetMouseInputEnabled(true)
	self.loadButton.DoClick = function(panel)
	
	if IsValid(characterPanel) and characterPanel.Active then
		characterPanel:FadeOut(characterPanel)
		return
	end
	
	if IsValid(factionPanel) and factionPanel.Active then 
		factionPanel:FadeOut(factionPanel)
		return
	end
		
	self.characters = {}
	local y = 0
	
	characterPanel = vgui.Create("DPanel", self)
	characterPanel:SetPos(ScrW() - (775), (ScrH() / 2) - 150)
	characterPanel:SetSize(460, 500)
	characterPanel.Active = true
	characterPanel.Paint = function(p, w, h)
	   surface.SetDrawColor(50, 50, 50, 0) 
	    surface.DrawRect(0, 0, characterPanel:GetWide(), characterPanel:GetTall()) -- Draw the rect
	end
	characterPanel.FadeOut = function(p)
	local children = p:GetChildren()
	for _, panel in pairs(children) do
		panel:FadeOut(0.25)
	end
			p.Active = false
						timer.Simple(2, function()
							if IsValid(p) then
								p:Remove()
							end
						end)
					end

					if (nut.characters and table.Count(nut.characters) > 0) then
						for k, v in ipairs(nut.characters) do
							
							local character = nut.char.loaded[v]
						
							local color = nut.config.get("color")
							local r, g, b = color.r, color.g, color.b
	
							self.charSelect = vgui.Create("SButton", characterPanel)
							local name = character:getName() or "Error"
							self.charSelect:SetText("Load - "..name)
							self.charSelect:SetWide(450)
							self.charSelect:FadeIn(0.5)
							self.charSelect:SetMouseInputEnabled(true)
							self.charSelect:SetPos(0,y)
							self.charSelect.DoClick = function(panel)
							
								self.id = character:getID()
								
								local status, result = hook.Run("CanPlayerUseChar", client, nut.char.loaded[self.id])

								if (status == false) then
									if (result:sub(1, 1) == "@") then
										nut.util.notifyLocalized(result:sub(2))
									else
										nut.util.notify(result)
									end

									return
								end
									
								if (self.id) then
									netstream.Start("charChoose", self.id)
									self:FadeOutMusic()
									self:Remove()
								else
									return false
								end
							end
	
							y = self.charSelect:GetTall() + 10 + y
	
							self.characters[character:getID()] = panel
						end
					end
				end
	
				self.settingsButton = vgui.Create("SButton", self)
				self.settingsButton:SetText("Delete")
				self.settingsButton:FadeIn(1)
				self.settingsButton:SetWide(220)
				self.settingsButton:SetPos(ScrW() - (200 + self.settingsButton:GetWide()/2), (ScrH() / 2))
				self.settingsButton:SetMouseInputEnabled(true)
				self.settingsButton.DoClick = function(panel)
					if IsValid(characterPanel) and characterPanel.Active then
						characterPanel:FadeOut(characterPanel)
						return
					end
	
					if IsValid(factionPanel) and factionPanel.Active then 
						factionPanel:FadeOut(factionPanel)
						return
					end
		
					self.characters = {}
					local y = 0
	
					characterPanel = vgui.Create("DPanel", self)
					characterPanel:SetPos(ScrW() - (775), (ScrH() / 2) - 150)
					characterPanel:SetSize(460, 250)
					characterPanel.Active = true
					characterPanel.Paint = function(p, w, h)
					    surface.SetDrawColor(50, 50, 50, 0) 
						
						if (characterPanel:IsValid()) then	
							surface.DrawRect(0, 0, characterPanel:GetWide(), characterPanel:GetTall()) -- Draw the rect
						end
					end
					characterPanel.FadeOut = function(p)
						local children = p:GetChildren()
						for _, panel in pairs(children) do
							panel:FadeOut(0.25)
						end
						p.Active = false
						timer.Simple(2, function()
							if IsValid(p) then
								p:Remove()
							end
						end)
					end

					if (nut.characters and table.Count(nut.characters) > 0) then
						for k, v in ipairs(nut.characters) do
							
							local character = nut.char.loaded[v]
						
							local color = nut.config.get("color")
							local r, g, b = color.r, color.g, color.b
	
							self.charDelete = vgui.Create("SButton", characterPanel)
							local name = character:getName() or "Error"
							self.charDelete:SetText("Delete - "..name)
							self.charDelete:SetWide(450)
							self.charDelete:FadeIn(0.5)
							self.charDelete:SetTextColor(Color(255,80,80))
							self.charDelete:SetMouseInputEnabled(true)
							self.charDelete:SetPos(0,y)
							self.charDelete.DoClick = function(panel)
								self.id = character:getID()
	
								if (self.id) then
									netstream.Start("charDel", self.id)
								else
									return false
								end
	
								for k, v in pairs(nut.characters) do
									if (nut.char.loaded[v] == self.id) then
										nut.characters[k] = nil
									end
								end
	
								timer.Simple(0, function()
									if (IsValid(nut.gui.char)) then
										nut.gui.char:FadeOutMusic()
									end
			
									nut.gui.char = vgui.Create("nutCharMenu")
								end)
							end
	
							y = self.charDelete:GetTall() + 10 + y
							self.characters[character:getID()] = panel
						end
					end
				end
	
				self.creditsTab = vgui.Create("SButton", self)
				self.creditsTab:SetText("Steam Group")
				self.creditsTab:SetWide(220)
				self.creditsTab:FadeIn(1)
				self.creditsTab:SetPos(ScrW() - (200 + self.settingsButton:GetWide()/2), (ScrH() / 2) + 50)
				self.creditsTab:SetMouseInputEnabled(true)
 				self.creditsTab.DoClick = function(panel)
					gui.OpenURL("")
				end
	
				self.Forums = vgui.Create("SButton", self)
				self.Forums:SetText("Discord")
				self.Forums:SetWide(220)
				self.Forums:FadeIn(1)
				self.Forums:SetPos(ScrW() - (200 + self.Forums:GetWide()/2), (ScrH() / 2) + 100)
				self.Forums:SetMouseInputEnabled(true)
				self.Forums.DoClick = function(panel)
					gui.OpenURL("")
				end
	
				self.Leave = vgui.Create("SButton", self)
				self.Leave:SetText("Disconnect")
				self.Leave:FadeIn(1)
				self.Leave:SetWide(220)
				self.Leave:SetPos(ScrW() - (200 + self.Leave:GetWide()/2), (ScrH() / 2) + 150)
				self.Leave:SetMouseInputEnabled(true)
				self.Leave.DoClick = function(panel)
					if (LocalPlayer().character) then
						if (IsValid(nut.gui.charCreate)) then
							return false
						end
						self:FadeOutMusic()
						self:Remove()
					else
						RunConsoleCommand("disconnect")
					end
				end
	
				if (LocalPlayer().character) then
					self.Leave:SetText("Back")
					self.disconnect = vgui.Create("SButton", self)
					self.disconnect:SetText("Disconnect")
					self.disconnect:SetWide(220)
					self.disconnect:FadeIn(1)
					self.disconnect:SetPos(ScrW() - (200 + self.Leave:GetWide()/2), ScrH() - 100)
					self.disconnect:SetMouseInputEnabled(true)
					self.disconnect.DoClick = function(panel)
						RunConsoleCommand("disconnect")
					end
				end
			end)

		do
			if (nut.menuMusic) then
				nut.menuMusic:Stop()
				nut.menuMusic = nil
			end
			
			sound.PlayFile( "sound/fosounds/fix/MainTitle.mp3", "noplay", function(music, errorId, errorName)
				music:SetVolume(0.8)
				music:Play()
				nut.menuMusic = music
			end)
		end

		nut.loaded = true
	end

	function PANEL:FadeOutMusic()
		if (!nut.menuMusic) then
			return
		end

		timer.Create("falloutMenuFadeNS", 0.1, 0, function()
			if (nut.menuMusic) then
				nut.menuMusic:SetVolume(math.max(nut.menuMusic:GetVolume() - 0.1, 0))
				
				if (nut.menuMusic:GetVolume() == 0) then
					nut.menuMusic:Stop()
					nut.menuMusic = nil
					timer.Remove("falloutMenuFadeNS")
				end
			end
		end)
	end

	function PANEL:Paint(w, h)
		surface.SetDrawColor(20, 20, 20)
		surface.SetTexture(gradient)
		surface.DrawTexturedRect(0, 0, w, h)

		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(backgroundNV)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	function PANEL:FadeIn()
		timer.Simple(0.1, function()
			self.Leave:SetAlpha(0)
			self.Forums:SetAlpha(0)
			self.creditsTab:SetAlpha(0)
			self.settingsButton:SetAlpha(0)
			self.loadButton:SetAlpha(0)
			self.continueButton:SetAlpha(0)
			
			if IsValid(self.createButton) then
				self.createButton:SetAlpha(0)
			end
			
			self.FalloutLogo:SetAlpha(0)

			timer.Simple(1.4, function()
				self.Leave:FadeIn(1)
				self.Forums:FadeIn(1)
				self.creditsTab:FadeIn(1)
				self.settingsButton:FadeIn(1)
				if IsValid(self.createButton) then
					self.loadButton:FadeIn(1)
				end
				self.continueButton:FadeIn(1)
				self.createButton:FadeIn(1)
			end)

			self.FalloutLogo:FadeIn(1.5)
		end)
	end

vgui.Register("nutCharMenu", PANEL, "DPanel")