local PLUGIN = PLUGIN

local background = background or Material("forp/charcreate/background.png", "noclamp smooth")
local buttons_base = buttons_base or Material("forp/charcreate/base_buttons.png", "noclamp smooth")
local foreground_base = foreground_base or Material("forp/charcreate/robco_base.png", "noclamp smooth")
local button_test = button_test or Material("forp/charcreate/button_test.png", "noclamp smooth")

local adjust_decrease = adjust_decrease or Material("forp/adjust_decrease.png", "noclamp smooth")
local adjust_decrease_over = adjust_decrease_over or Material("forp/adjust_decrease_over.png", "noclamp smooth")
local adjust_increase = adjust_increase or Material("forp/adjust_increase.png", "noclamp smooth")
local adjust_increase_over = adjust_increase_over or Material("forp/adjust_increase_over.png", "noclamp smooth")

PLUGIN.CategoryID = {}
PLUGIN.CategoryID[1] = "Sex"
PLUGIN.CategoryID[2] = "Race"
PLUGIN.CategoryID[3] = "Face"
PLUGIN.CategoryID[4] = "Hair"

PLUGIN.CharCreateTable = {}
PLUGIN.CharCreateTable["name"] = ""
PLUGIN.CharCreateTable["attribs"] = ""
PLUGIN.CharCreateTable["desc"] = ""
PLUGIN.CharCreateTable["sex"] = "Male" -- default gender
PLUGIN.CharCreateTable["model"] = ""
PLUGIN.CharCreateTable["skintone"] = "Caucasian" -- default gender
PLUGIN.CharCreateTable["facemap"] = 0
PLUGIN.CharCreateTable["eyecolor"] = 1
PLUGIN.CharCreateTable["hair"] = 1
PLUGIN.CharCreateTable["haircolor"] = 1
PLUGIN.CharCreateTable["facialhair"] = 0


PLUGIN.CategoryTable = {}
PLUGIN.CategoryTable[1] = {{"Male", "sex", "button"}, {"Female", "sex", "button"}}
PLUGIN.CategoryTable[2] = {{"Caucasian", "skintone", "button"}, {"African", "skintone", "button"}, {"Asian", "skintone", "button"}, {"Hispanic", "skintone", "button"}}
PLUGIN.CategoryTable[3] = {{"Eye Color", "eyecolor", "slider", {min = 1, max = 26}}, {"Facemap", "facemap", "slider", {min = 0, max = 15}} }
PLUGIN.CategoryTable[4] = {{"Color", "haircolor", "slider", {min = 1, max = 20}}, {"Style", "hair", "slider", {min = 0, max = 32}}, {"Facial", "facialhair", "slider", {min = 0, max = 16}} }

local BackgroundPanel = BackgroundPanel or nil

function PLUGIN:CreateCharacter()
	BackgroundPanel = vgui.Create("DPanel")
	BackgroundPanel:SetSize(ScrW(), ScrH())
	BackgroundPanel.Paint = function(p, w, h)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawRect(0,0,w,h)
	end
	BackgroundPanel:SetPos(0,0)

	surface.PlaySound("fosounds/fix/ui_levelup.mp3")

	local NameFrame = vgui.Create("DFrame")
	NameFrame:SetSize(400, 230)
	NameFrame:SetTitle("Enter Name")
	NameFrame:Center()
	NameFrame:MakePopup()
	NameFrame.OnClose = function()
		BackgroundPanel:Remove()
	end
	NameFrame:ShowCloseButton(false)
	
	self.CharCreateTable["attribs"] = {}
	
	local container = BackgroundPanel:Add("DPanel")
	container:SetWide(BackgroundPanel:GetWide() - 16)

	local y2 = 0
	local total = 0
	local maximum = hook.Run("GetStartAttribPoints", LocalPlayer(), self.CharCreateTable) or nut.config.get("maxAttribs", 30)

	for k, v in SortedPairsByMemberValue(nut.attribs.list, "name") do
		self.CharCreateTable["attribs"][k] = 0

		local bar = container:Add("nutAttribBar")
		bar:setMax(maximum)
		bar:Dock(TOP)
		bar:DockMargin(2, 2, 2, 2)
		bar:setText(L(v.name))
		bar.onChanged = function(this, difference)
			if ((total + difference) > maximum) then
				return false
			end

			total = total + difference
			self.CharCreateTable["attribs"][k] = self.CharCreateTable["attribs"][k] + difference
		end

		if (v.noStartBonus) then
			bar:setReadOnly()
		end

		y2 = y2 + bar:GetTall() + 4
	end

	container:SetTall(y2)
	
	local xSize, ySize = container:GetSize()
	container:SetPos(0, ScrH() - ySize)

	local NameLabel = vgui.Create("DLabel", NameFrame)
	NameLabel:SetPos(10, 40)
	NameLabel:SetFont("Monofonto30CC")
	NameLabel:SetText("NAME:")
	NameLabel:SetTextColor(Color(255,255,255,255))
	NameLabel:SizeToContents()

	local NameEntry = vgui.Create("DTextEntry", NameFrame)
	NameEntry:SetWide(314)
	NameEntry:SetTall(30)
	NameEntry:SetPos(76, 40)
	NameEntry:SetContentAlignment(5)
	NameEntry:SetFont("Monofonto20CC")

	local RandomMale = vgui.Create("DButton", NameFrame)
	RandomMale:SetWide(185)
	RandomMale:SetTall(30)
	RandomMale:SetText("Random Male Name")
	RandomMale:SetPos((NameFrame:GetWide()/2) - 190, 84)
	RandomMale:SetFont("Monofonto20CC")
	RandomMale.DoClick = function()
		NameEntry:SetText(table.Random(PLUGIN.MaleNames).." "..table.Random(PLUGIN.LastNames))
	end

	local RandomFemale = vgui.Create("DButton", NameFrame)
	RandomFemale:SetWide(185)
	RandomFemale:SetTall(30)
	RandomFemale:SetText("Random Female Name")
	RandomFemale:SetPos((NameFrame:GetWide()/2) + 5, 84)
	RandomFemale:SetFont("Monofonto20CC")
	RandomFemale.DoClick = function()
		NameEntry:SetText(table.Random(PLUGIN.FemaleNames).." "..table.Random(PLUGIN.LastNames))
	end

	local DescLabel = vgui.Create("DLabel", NameFrame)
	DescLabel:SetPos(10, 130)
	DescLabel:SetFont("Monofonto30CC")
	DescLabel:SetText("DESC:")
	DescLabel:SetTextColor(Color(255,255,255,255))
	DescLabel:SizeToContents()

	local DescEntry = vgui.Create("DTextEntry", NameFrame)
	DescEntry:SetWide(314)
	DescEntry:SetTall(30)
	DescEntry:SetPos(76, 130)
	DescEntry:SetContentAlignment(5)
	DescEntry:SetFont("Monofonto20CC")

	local NextButton = vgui.Create("DButton", NameFrame)
	NextButton:SetWide(70)
	NextButton:SetTall(30)
	NextButton:SetText("NEXT")
	NextButton:SetPos((NameFrame:GetWide()/2) - (NextButton:GetWide()/2), NameFrame:GetTall() - 40)
	NextButton:SetFont("Monofonto20CC")
	NextButton.DoClick = function()
		if (string.len(NameEntry:GetValue()) >= 6) and (string.len(DescEntry:GetValue()) >= 16) then
			PLUGIN.CharCreateTable["name"] = NameEntry:GetValue()
			PLUGIN.CharCreateTable["desc"] = DescEntry:GetValue()
			surface.PlaySound("fosounds/fix/ui_popup_messagewindow.mp3")
			Derma_Query("Would you like to proceed?\nYou will have an opportunity to change this info once more in the future.", "Notification.", "GO BACK", function() surface.PlaySound("forp/ui_menu_ok.wav") end, "PROCEED", function() surface.PlaySound("forp/ui_menu_ok.wav") NameFrame:Remove() PLUGIN:CustomizeFace() end)
		else
			surface.PlaySound("fosounds/fix/ui_popup_messagewindow.mp3")
			Derma_Query("Your Information Needs To Be Longer.","Notification.", "OK", function() surface.PlaySound("forp/ui_menu_ok.wav") end)
		end
	end
end

function PLUGIN:FinalizeCharacter()
	surface.PlaySound("fosounds/fix/ui_levelup.mp3")

	local NameFrame = vgui.Create("DFrame")
	NameFrame:SetSize(400, 230)
	NameFrame:SetTitle("Confirm Character")
	NameFrame:Center()
	NameFrame:MakePopup()
	NameFrame.OnClose = function()
		BackgroundPanel:Remove()
	end

	local NameLabel = vgui.Create("DLabel", NameFrame)
	NameLabel:SetPos(10, 40)
	NameLabel:SetFont("Monofonto30CC")
	NameLabel:SetText("NAME:")
	NameLabel:SetTextColor(Color(255,255,255,255))
	NameLabel:SizeToContents()
	NameFrame:ShowCloseButton(false)

	local NameEntry = vgui.Create("DTextEntry", NameFrame)
	NameEntry:SetWide(314)
	NameEntry:SetTall(30)
	NameEntry:SetPos(76, 40)
	NameEntry:SetContentAlignment(5)
	NameEntry:SetFont("Monofonto20CC")
	NameEntry:SetText(self.CharCreateTable["name"])
	NameEntry.OnValueChanged = function(value)
		PLUGIN.CharCreateTable["name"] = value
	end

	local RandomMale = vgui.Create("DButton", NameFrame)
	RandomMale:SetWide(185)
	RandomMale:SetTall(30)
	RandomMale:SetText("Random Male Name")
	RandomMale:SetPos((NameFrame:GetWide()/2) - 190, 84)
	RandomMale:SetFont("Monofonto20CC")
	RandomMale.DoClick = function()
		NameEntry:SetText(table.Random(PLUGIN.MaleNames).." "..table.Random(PLUGIN.LastNames))
	end

	local RandomFemale = vgui.Create("DButton", NameFrame)
	RandomFemale:SetWide(185)
	RandomFemale:SetTall(30)
	RandomFemale:SetText("Random Female Name")
	RandomFemale:SetPos((NameFrame:GetWide()/2) + 5, 84)
	RandomFemale:SetFont("Monofonto20CC")
	RandomFemale.DoClick = function()
		NameEntry:SetText(table.Random(PLUGIN.FemaleNames).." "..table.Random(PLUGIN.LastNames))
	end

	local DescLabel = vgui.Create("DLabel", NameFrame)
	DescLabel:SetPos(10, 130)
	DescLabel:SetFont("Monofonto30CC")
	DescLabel:SetText("DESC:")
	DescLabel:SetTextColor(Color(255,255,255,255))
	DescLabel:SizeToContents()

	local DescEntry = vgui.Create("DTextEntry", NameFrame)
	DescEntry:SetWide(314)
	DescEntry:SetTall(30)
	DescEntry:SetPos(76, 130)
	DescEntry:SetContentAlignment(5)
	DescEntry:SetFont("Monofonto20CC")
	DescEntry:SetText(self.CharCreateTable["desc"])
	DescEntry.OnValueChanged = function(value)
		PLUGIN.CharCreateTable["desc"] = value
	end

	local NextButton = vgui.Create("DButton", NameFrame)
	NextButton:SetWide(70)
	NextButton:SetTall(30)
	NextButton:SetText("NEXT")
	NextButton:SetPos((NameFrame:GetWide()/2) - (NextButton:GetWide()/2), NameFrame:GetTall() - 40)
	NextButton:SetFont("Monofonto20CC")
	NextButton.DoClick = function()
		if (string.len(NameEntry:GetText()) >= 6) and (string.len(DescEntry:GetText()) >= 16) then
			PLUGIN.CharCreateTable["name"] = NameEntry:GetText()
			PLUGIN.CharCreateTable["desc"] = DescEntry:GetText()
			surface.PlaySound("fosounds/fix/ui_popup_messagewindow.mp3")
			Derma_Query("Would you like to proceed?\nYou will not be able to change this after this point.", "Notification.", "GO BACK", function() surface.PlaySound("forp/ui_menu_ok.wav") end, "PROCEED", function()
				surface.PlaySound("forp/ui_menu_ok.wav") 
				NameFrame:Remove()			

				netstream.Start("forp_BodyData", {
					forp_skintone = self.CharCreateTable["skintone"],
					forp_facemap = self.CharCreateTable["facemap"],
					forp_eyecolor = self.CharCreateTable["eyecolor"],
					forp_hair = self.CharCreateTable["hair"],
					forp_haircolor = self.CharCreateTable["haircolor"],
					forp_facialhair = self.CharCreateTable["facialhair"]
				})

				timer.Simple(0.1, function()
					netstream.Start("charCreate", {
						name = PLUGIN.CharCreateTable["name"],
						gender = string.lower(PLUGIN.CharCreateTable["sex"]),
						desc = PLUGIN.CharCreateTable["desc"],
						model = table.KeyFromValue( nut.faction.indices[PLUGIN.creationfaction].models, "models/lazarusroleplay/heads/"..PLUGIN.CharCreateTable["sex"].."_"..PLUGIN.CharCreateTable["skintone"]..".mdl"),
						faction = PLUGIN.creationfaction,
						attribs = PLUGIN.CharCreateTable["attribs"]
					})
				end)
			end)
		else
			surface.PlaySound("fosounds/fix/ui_popup_messagewindow.mp3")
			Derma_Query("Your Information Needs To Be Longer.","Notification.", "OK", function() surface.PlaySound("forp/ui_menu_ok.wav") end)
		end
	end
end

function PLUGIN:SwitchCategory(ButtonList, Category, frame)
	if (ButtonList and ButtonList:IsValid()) then
		for k, p in pairs(ButtonList:GetChildren()) do
			p:Remove()
		end
	else
		return
	end

	if (!self.CategoryTable[Category]) then
		return
	end

	ButtonList.Category = Category

	local Button = vgui.Create("DButton", ButtonList)
	Button:Dock(TOP)
	Button:SetContentAlignment(4)
	Button:SetTall(50)
	Button:SetFont("Monofonto24CC")
	Button:SetTextColor(Color(100, 250, 100))
	Button:SetText("    "..Category..". "..self.CategoryID[Category])
	Button:DockMargin(0, 10, 0, 5)
	Button.Paint = function(p, w, h)

	end

	local NextButton = vgui.Create("DButton", ButtonList)
	NextButton:SetContentAlignment(4)
	NextButton:SetFont("Monofonto24CC")
	NextButton:SetTextColor(Color(100, 250, 100))
	if (Category == 4) then
		NextButton:SetText("DONE")
	else
		NextButton:SetText("NEXT")
	end
	NextButton:SizeToContents()
	NextButton:SetPos(140, 310)
	NextButton.OnHover = function()
		surface.PlaySound("forp/ui_menu_focus.wav")
	end
	NextButton.Paint = function(p, w, h)
		local a = 0
		if (p:IsHovered()) then
			a = 10
		end
	
		surface.SetDrawColor(160,255,160, a)
		surface.DrawRect(0, 0, w, h)
	
		if (p.Hovered and !p.CallHover) then
			p.CallHover = true
			p:OnHover()
		elseif (!p.Hovered and p.CallHover) then
			p.CallHover = false
		end
	end
	NextButton.DoClick = function()
		surface.PlaySound("forp/ui_menu_ok.wav")
		if (Category == 4) then
			PLUGIN:FinalizeCharacter()
			frame:Remove()
		else
			PLUGIN:SwitchCategory(ButtonList, Category + 1, frame)
		end
	end

	if (Category != 1) then
		local NextButton = vgui.Create("DButton", ButtonList)
		NextButton:SetContentAlignment(4)
		NextButton:SetFont("Monofonto24CC")
		NextButton:SetTextColor(Color(100, 250, 100))
		NextButton:SetText("PREV")
		NextButton:SizeToContents()
		NextButton:SetPos(25, 310)
		NextButton.OnHover = function()
			surface.PlaySound("forp/ui_menu_focus.wav")
		end
		NextButton.Paint = function(p, w, h)
			local a = 0
			if (p:IsHovered()) then
				a = 10
			end
	
			surface.SetDrawColor(160,255,160, a)
			surface.DrawRect(0, 0, w, h)
	
			if (p.Hovered and !p.CallHover) then
				p.CallHover = true
				p:OnHover()
			elseif (!p.Hovered and p.CallHover) then
				p.CallHover = false
			end
		end
		NextButton.DoClick = function()
			surface.PlaySound("forp/ui_menu_ok.wav")
			PLUGIN:SwitchCategory(ButtonList, Category - 1, frame)
		end
	end

	for k, widget in pairs(self.CategoryTable[Category]) do
		if widget[3] == "button" then
			local Button = vgui.Create("DButton", ButtonList)
			Button:Dock(TOP)
			Button:SetContentAlignment(4)
			Button:SetTall(30)
			Button:SetFont("Monofonto24CC")
			Button:SetTextColor(Color(100, 250, 100))
			Button:SetText("    "..widget[1])
			Button:DockMargin(0, 2, 0, 2)
			Button.OnHover = function()
				surface.PlaySound("forp/ui_menu_prevnext.wav")
			end
			Button.Paint = function(p, w, h)
				local a = 0
				if (p:IsHovered()) then
					a = 10
				end

				surface.SetDrawColor(160,255,160, a)
				surface.DrawRect(0, 0, w, h)
		
				if (self.CharCreateTable[widget[2]] == widget[1]) then
					surface.SetDrawColor(Color(100, 250, 100))
					surface.DrawRect(18, 10, 10, 10)
				end

				if (p.Hovered and !p.CallHover) then
					p.CallHover = true
					p:OnHover()
				elseif (!p.Hovered and p.CallHover) then
					p.CallHover = false
				end
			end
			Button.DoClick = function()
				surface.PlaySound("forp/ui_menu_ok.wav")
				PLUGIN.CharCreateTable[widget[2]] = widget[1]
			end
		elseif widget[3] == "slider" then
			local Panel = vgui.Create("DPanel", ButtonList)
			Panel:Dock(TOP)
			Panel:SetContentAlignment(4)
			Panel:SetTall(48)
			Panel:DockMargin(0, 2, 0, 2)
			Panel.OnHover = function()
				surface.PlaySound("forp/ui_menu_prevnext.wav")
			end
			Panel.Paint = function(p, w, h)
				local a = 0
				if (p:IsHovered()) then
					a = 10
				end
				for k, v in pairs(p:GetChildren()) do
					if (v:IsHovered()) then
						a = 10
					end
				end
				surface.SetDrawColor(160,255,160, a)
				surface.DrawRect(0, 0, w, h)
			end

			local minusbutton = vgui.Create("DButton", Panel)
			minusbutton:Dock(LEFT)
			minusbutton:DockMargin(8, 0, 8, 0)
			minusbutton:SetWide(48)
			minusbutton:SetText("")
			minusbutton.OnHover = function()
				surface.PlaySound("forp/ui_menu_prevnext.wav")
			end
			minusbutton.DoClick = function()
				surface.PlaySound("forp/ui_menu_ok.wav")
				if (PLUGIN.CharCreateTable[widget[2]] == widget[4].min) then
					PLUGIN.CharCreateTable[widget[2]] = widget[4].min
				else
					PLUGIN.CharCreateTable[widget[2]] = PLUGIN.CharCreateTable[widget[2]] - 1
				end
			end
			minusbutton.Paint = function(p, w, h)
				if (p.Hovered) then
					surface.SetMaterial(adjust_decrease_over)
					surface.SetDrawColor(100,255,100)
					surface.DrawTexturedRect(0, 0, 48, 48)
				else
					surface.SetMaterial(adjust_decrease)
					surface.SetDrawColor(100,255,100)
					surface.DrawTexturedRect(0, 0, 48, 48)
				end

				if (p.Hovered and !p.CallHover) then
					p.CallHover = true
					p:OnHover()
				elseif (!p.Hovered and p.CallHover) then
					p.CallHover = false
				end
			end

			local plusbutton = vgui.Create("DButton", Panel)
			plusbutton:Dock(RIGHT)
			plusbutton:DockMargin(10, 0, 10, 0)
			plusbutton:SetWide(48)
			plusbutton:SetText("")
			plusbutton.DoClick = function()
				surface.PlaySound("forp/ui_menu_ok.wav")
				if (PLUGIN.CharCreateTable[widget[2]] + 1) > widget[4].max then
					PLUGIN.CharCreateTable[widget[2]] = widget[4].min
				else
					PLUGIN.CharCreateTable[widget[2]] = PLUGIN.CharCreateTable[widget[2]] + 1
				end
			end
			plusbutton.OnHover = function()
				surface.PlaySound("forp/ui_menu_prevnext.wav")
			end
			plusbutton.Paint = function(p, w, h)
				if (p.Hovered) then
					surface.SetMaterial(adjust_increase_over)
					surface.SetDrawColor(100,255,100)
					surface.DrawTexturedRect(0, 0, 48, 48)
				else
					surface.SetMaterial(adjust_increase)
					surface.SetDrawColor(100,255,100)
					surface.DrawTexturedRect(0, 0, 48, 48)
				end

				if (p.Hovered and !p.CallHover) then
					p.CallHover = true
					p:OnHover()
				elseif (!p.Hovered and p.CallHover) then
					p.CallHover = false
				end
			end

			local sliderlabel = vgui.Create("DLabel", Panel)
			sliderlabel:Dock(FILL)
			sliderlabel:SetFont("Monofonto20CC")
			sliderlabel:SetText(widget[1])
			sliderlabel:SetContentAlignment(5)
			sliderlabel:SetTextColor(Color(100, 250, 100))
		end
	end
end

function PLUGIN:CustomizeFace()
	local charframe = vgui.Create("DFrame")
	charframe:SetSize(1280, 720)
	charframe:Center()
	charframe:MakePopup()
	charframe.Paint = function(p, w, h)
		surface.SetMaterial(background)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(0, 0, w, h)
	end
	charframe:SetTitle("")
	charframe:ShowCloseButton(false)

	local modelpanel = vgui.Create("LZModelPanel", charframe)
	modelpanel:SetModel("models/lazarusroleplay/heads/male_caucasian.mdl", "models/thespireroleplay/humans/group100/arms/male_arm.mdl")
	modelpanel:SetSize(490, 490)
	modelpanel:SetPos(250, 120)
	modelpanel:SetFOV(15)
	modelpanel.Sex = "Male"
	modelpanel.skintone = "Caucasian"
	modelpanel:GetEntity():SetPos(Vector(0,0,2))
	modelpanel:GetEntity():SetAngles(Angle(0,45,0))
	modelpanel:GetBody():SetAngles(Angle(0,45,0))
	modelpanel.Front = true
	modelpanel.PaintOver = function()
		if ((modelpanel.Sex != PLUGIN.CharCreateTable["sex"]) or (modelpanel.skintone != PLUGIN.CharCreateTable["skintone"])) then
			modelpanel:SetModel("models/lazarusroleplay/heads/"..PLUGIN.CharCreateTable["sex"].."_"..PLUGIN.CharCreateTable["skintone"]..".mdl", "models/thespireroleplay/humans/group100/arms/"..PLUGIN.CharCreateTable["sex"].."_arm.mdl")
			modelpanel.Sex = PLUGIN.CharCreateTable["sex"]
			modelpanel.skintone = PLUGIN.CharCreateTable["skintone"]
			modelpanel:GetEntity():ResetSequenceInfo()
			modelpanel:GetBody():SetSkin(PLUGIN.SkinTones["models/lazarusroleplay/heads/"..string.lower(PLUGIN.CharCreateTable["sex"]).."_"..string.lower(PLUGIN.CharCreateTable["skintone"])..".mdl"])
			if (PLUGIN.CharCreateTable["sex"] == "Female") then
				modelpanel:GetEntity():SetSequence(ACT_GLIDE)
			else
				modelpanel:GetEntity():SetSequence(ACT_IDLE)
			end
		end

		local gender = string.lower(PLUGIN.CharCreateTable["sex"])
		local index = 3

		if (gender == "female") then
			index = 1
		end

		modelpanel:SetSubMaterial(index, nut.util.getMaterial("models/lazarus/shared/"..PLUGIN.EyeTable[PLUGIN.CharCreateTable["eyecolor"]].mat))

		if (string.lower(PLUGIN.CharCreateTable["sex"]) == "female") then
			local race = string.lower(PLUGIN.CharCreateTable["skintone"])
			local skintone = (PLUGIN.CharCreateTable["facemap"] + 1)
			if (PLUGIN.FemaleFaces[race][skintone]) then
				modelpanel:SetSubMaterial2(0, nut.util.getMaterial("models/lazarus/female/"..PLUGIN.FemaleFaces[race][skintone]))
			end
		else
			local race = string.lower(PLUGIN.CharCreateTable["skintone"])
			local skintone = (PLUGIN.CharCreateTable["facemap"] + 1)
			if (PLUGIN.MaleFaces[race][skintone]) then
				modelpanel:SetSubMaterial2(0, nut.util.getMaterial("models/lazarus/male/"..PLUGIN.MaleFaces[race][skintone]))
			end
		end

		modelpanel:GetEntity():SetSkin(PLUGIN.CharCreateTable["facemap"])
		modelpanel:GetEntity():SetBodygroup(2, PLUGIN.CharCreateTable["hair"])
		modelpanel:GetEntity():SetBodygroup(3, PLUGIN.CharCreateTable["facialhair"])
		modelpanel:SetHairColor(PLUGIN.HairTable[PLUGIN.CharCreateTable["haircolor"]].color)

		if (modelpanel.Front) then
			if (modelpanel.Sex == "Male") then
				modelpanel:GetEntity():SetAngles(Angle(0,45,0))
				modelpanel:SetLookAt(Vector(0, -2, 65))
			else
				modelpanel:GetEntity():SetAngles(Angle(0,135,0))
				modelpanel:SetLookAt(Vector(0, -0.5, 63))
			end
		else
			if (modelpanel.Sex == "Male") then
				modelpanel:GetEntity():SetAngles(Angle(0,225,0))
				modelpanel:SetLookAt(Vector(0, 1, 65))
			else
				modelpanel:GetEntity():SetAngles(Angle(0,315,0))
				modelpanel:SetLookAt(Vector(0, -1, 65))
			end
		end
	end
	modelpanel:GetEntity():SetSequence(ACT_IDLE)
	modelpanel:SetAnimated(true)

	local ButtonList = vgui.Create("DPanel", charframe)
	ButtonList:SetPos(738, 190)
	ButtonList:SetSize(215, 390)
	ButtonList.PaintOver = function(p, w, h)
		surface.SetDrawColor(50, 255, 50, 0)
		surface.DrawRect(0,0,w,h)
	end
	ButtonList.Category = 1

	local sexbutton = vgui.Create("DButton", charframe)
	sexbutton:SetPos(381, 595)
	sexbutton:SetSize(41, 41)
	sexbutton:SetText("")
	sexbutton.OnHover = function()
		surface.PlaySound("forp/ui_menu_focus.wav")
	end
	sexbutton.PaintButton = function(p, w, h)
		local w, h = p:GetSize()
		local x, y = p:GetPos()
		local a = 0

		if (p:IsHovered()) then
			a = 50
		end
		if (ButtonList.Category == 1) then
			a = 255
		end
		surface.SetMaterial(button_test)
		surface.SetDrawColor(255,255,255, a)
		surface.DrawTexturedRect(x, y, w, h)

		if (p.Hovered and !p.CallHover) then
			p.CallHover = true
			p:OnHover()
		elseif (!p.Hovered and p.CallHover) then
			p.CallHover = false
		end
	end

	sexbutton.DoClick = function()
		PLUGIN:SwitchCategory(ButtonList, 1, charframe, charframe)
		surface.PlaySound("forp/ui_menu_ok.wav")
	end

	local racebutton = vgui.Create("DButton", charframe)
	racebutton:SetPos(452, 595)
	racebutton:SetSize(41, 41)
	racebutton:SetText("")
	racebutton.OnHover = function()
		surface.PlaySound("forp/ui_menu_focus.wav")
	end
	racebutton.PaintButton = function(p, w, h)
		local w, h = p:GetSize()
		local x, y = p:GetPos()
		local a = 0

		if (p:IsHovered()) then
			a = 50
		end
		if (ButtonList.Category == 2) then
			a = 255
		end
		surface.SetMaterial(button_test)
		surface.SetDrawColor(255,255,255, a)
		surface.DrawTexturedRect(x, y, w, h)

		if (p.Hovered and !p.CallHover) then
			p.CallHover = true
			p:OnHover()
		elseif (!p.Hovered and p.CallHover) then
			p.CallHover = false
		end
	end

	racebutton.DoClick = function()
		PLUGIN:SwitchCategory(ButtonList, 2, charframe, charframe)
		surface.PlaySound("forp/ui_menu_ok.wav")
	end

	local facebutton = vgui.Create("DButton", charframe)
	facebutton:SetPos(522, 595)
	facebutton:SetSize(41, 41)
	facebutton:SetText("")
	facebutton.OnHover = function()
		surface.PlaySound("forp/ui_menu_focus.wav")
	end

	facebutton.PaintButton = function(p, w, h)
		local w, h = p:GetSize()
		local x, y = p:GetPos()
		local a = 0

		if (p:IsHovered()) then
			a = 50
		end
		if (ButtonList.Category == 3) then
			a = 255
		end
		surface.SetMaterial(button_test)
		surface.SetDrawColor(255,255,255, a)
		surface.DrawTexturedRect(x, y, w, h)

		if (p.Hovered and !p.CallHover) then
			p.CallHover = true
			p:OnHover()
		elseif (!p.Hovered and p.CallHover) then
			p.CallHover = false
		end
	end

	facebutton.DoClick = function()
		PLUGIN:SwitchCategory(ButtonList, 3, charframe)
		surface.PlaySound("forp/ui_menu_ok.wav")
	end

	local hairbutton = vgui.Create("DButton", charframe)
	hairbutton:SetPos(593, 595)
	hairbutton:SetSize(41, 41)
	hairbutton:SetText("")
	hairbutton.OnHover = function()
		surface.PlaySound("forp/ui_menu_focus.wav")
	end

	hairbutton.PaintButton = function(p, w, h)
		local w, h = p:GetSize()
		local x, y = p:GetPos()
		local a = 0

		if (p:IsHovered()) then
			a = 50
		end
		if (ButtonList.Category == 4) then
			a = 255
		end
		surface.SetMaterial(button_test)
		surface.SetDrawColor(255,255,255, a)
		surface.DrawTexturedRect(x, y, w, h)
		if (p.Hovered and !p.CallHover) then
			p.CallHover = true
			p:OnHover()
		elseif (!p.Hovered and p.CallHover) then
			p.CallHover = false
		end
	end

	hairbutton.DoClick = function()
		PLUGIN:SwitchCategory(ButtonList, 4, charframe)
		surface.PlaySound("forp/ui_menu_ok.wav")
	end

	local rotationbutton = vgui.Create("DButton", charframe)
	rotationbutton:SetSize(350, 400)
	rotationbutton:SetPos((375-44), 150)
	rotationbutton:SetText("")
	rotationbutton.Paint = function()
	end
	rotationbutton.DoClick = function()
		modelpanel.Front = !modelpanel.Front
		surface.PlaySound("forp/ui_menu_focus.wav")
	end

	charframe.PaintOver = function(p, w, h)
		surface.SetMaterial(foreground_base)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(0, 0, w, h)
	
		surface.SetMaterial(buttons_base)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(0, 0, w, h)
		local x, y = sexbutton:GetSize()
		sexbutton:PaintButton(sexbutton, x, y)
		racebutton:PaintButton(racebutton, x, y) 
		facebutton:PaintButton(facebutton, x, y) 
		hairbutton:PaintButton(hairbutton, x, y)
	end

	self:SwitchCategory(ButtonList, 1, charframe)
end

netstream.Hook("charAuthed", function(fault, ...)

	if (type(fault) == "table") then
		nut.characters = fault
	end

	if (BackgroundPanel) then
		BackgroundPanel:Remove()
	end

	surface.PlaySound("fosounds/fix/ui_popup_messagewindow.mp3")

	if (IsValid(nut.gui.char)) then
		nut.gui.char:FadeOutMusic()
	end
		
		nut.gui.char = vgui.Create("nutCharMenu")
end)