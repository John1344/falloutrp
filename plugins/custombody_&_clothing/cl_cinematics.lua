local PLUGIN = PLUGIN

local currentFrame = currentFrame or 0
local frameMaterials = frameMaterials or {}
local frameTime = frameTime or CurTime()
local cinematicTransitionState

local introFrame = introFrame or nil

concommand.Add("skipintro", function()
	cinematicTransitionState = 0
	currentFrame = 15
	frameTime = CurTime()
end)

local frames = {
	[1] = {len = 3, image = "intro/frame1.png", narration = "vending_vintronarration_0016950c_1.ogg", sub = "introSub1"},
	[2] = {len = 5, image = "intro/frame2.png", narration = "vending_vintronarration_0016950d_1.ogg", sub = "introSub2"},
	[3] = {len = 9, image = "intro/frame3.png", narration = "vending_vintronarration_0016950e_1.ogg", sub = "introSub3"},
	[4] = {len = 5, image = "intro/frame4.png", narration = "vending_vintronarration_0016950f_1.ogg", sub = "introSub4"},
	[5] = {len = 7, image = "intro/frame5.png", narration = "vending_vintronarration_00169510_1.ogg", sub = "introSub5"},
	[6] = {len = 10, image = "intro/frame6.png", narration = "vending_vintronarration_00169511_1.ogg", sub = "introSub6"},
	[7] = {len = 8, image = "intro/frame7.png", narration = "vending_vintronarration_00169512_1.ogg", sub = "introSub7"},
	[8] = {len = 7, image = "intro/frame8.png", narration = "vending_vintronarration_00169513_1.ogg", sub = "introSub8"},
	[9] = {len = 5, image = "intro/frame9.png", narration = "vending_vintronarration_00169514_1.ogg", sub = "introSub9"},
	[10] = {len = 6, image = "intro/frame9.png", narration = "vending_vintronarration_00169515_1.ogg", sub = "introSub10"},
	[11] = {len = 8, image = "intro/frame11.png", narration = "vending_vintronarration_00169516_1.ogg", sub = "introSub11"},
	[12] = {len = 6, image = "intro/frame12.png", narration = "vending_vintronarration_00169517_1.ogg", sub = "introSub12"},
	[13] = {len = 7, image = "intro/frame13.png", narration = "vending_vintronarration_00169518_1.ogg", sub = "introSub13"},
	[14] = {len = 4, image = "intro/frame14.png", narration = "vending_vintronarration_00169519_1.ogg", sub = "introSub14"},
	[15] = {len = 4, image = "intro/frame14.png", narration = "", sub = "introSub15"}
}

--precache the intro

util.PrecacheSound("intro/mus_inc_peaceful-024.ogg") 
util.PrecacheSound("fosounds/fix/mus_SCR_DocMitchell.mp3")

for k, v in pairs(frames) do
	frameMaterials[k] = Material(v.image)
end

function PLUGIN:PlayIntro()
	introFrame = vgui.Create("DFrame")
	introFrame:SetPos(ScrW(), ScrH())
	introFrame:MakePopup()

	local lentotal = 0
	for k, v in pairs(frames) do
		lentotal = v.len + lentotal
	end
	cinematicTransitionState = 0

	self:PlayIntroSound("intro/"..frames[1].narration)
	self:PlayIntroSound("fosounds/fix/mus_SCR_DocMitchell.mp3")
	
	frameTime = CurTime() + frames[1].len
	self:PlayIntroSound("intro/"..frames[1].len)
	currentFrame = 1
	
	self:PlayIntroSound("intro/mus_inc_peaceful-024.ogg")
	
	hook.Add("Think", "IntroThink", function()
		if frameTime != 0 then
			if (frameTime < CurTime()) then
				self:NextFrame()
			end
		end
	end)
	
	hook.Add("HUDDrawScoreBoard", "RenderIntro", function()
	
		local width = ScrW()
		local height = ScrH()
	
		if frameMaterials[currentFrame] then
			surface.SetMaterial(frameMaterials[currentFrame])
		else
			surface.SetMaterial(frameMaterials[14])
		end
		surface.SetDrawColor(255,255,255,255)
		for i = 1, 30 do
			surface.DrawTexturedRect(0, 0, width, height) 
		end
		
		if frameMaterials[currentFrame] then
			draw.SimpleText(L(frames[currentFrame].sub), "ColaborateL24", (width / 2), (height - height*0.1), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		else
			draw.SimpleText(L(frames[14].sub), "ColaborateL24", (width / 2), (height - height*0.1), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
	end)
end

function PLUGIN:NextFrame()
	local self = self

	currentFrame = currentFrame + 1
	if (frames[currentFrame]) then
		frameTime = CurTime() + frames[currentFrame].len + 1.5
		self:PlayIntroSound("intro/"..frames[currentFrame].narration)
	elseif (cinematicTransitionState == 0) then
		cinematicTransitionState = 1
		local fade = vgui.Create("nsFade")
		fade:SetText(" ")
		fade:SetPos(0,0)
		fade:SetSize(ScrW(), ScrH())
		fade:SetImage("forp/black.png")
		fade:FadeIn(2)

		timer.Simple(2, function()
			fade:FadeOut(0.1)
			timer.Simple(0.1, function()
				fade:Remove()
			end)
			self:CreateCharacter()
			frameTime = 0
			hook.Remove("Think", "IntroThink")
			hook.Remove("HUDDrawScoreBoard", "RenderIntro")
			introFrame:Remove()
		end)
		self:PlayIntroSound("intro/mus_endgametransitionstinger.ogg")
	end
end

function PLUGIN:PlayIntroSound(path)
	path = "sound/"..path
	sound.PlayFile(path, "", function(station)
		if (IsValid(station)) then
			station:Play()
		end
	end) 
end