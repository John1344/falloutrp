local PLUGIN = PLUGIN
PLUGIN.Interface = PLUGIN.Interface
PLUGIN.Scales = PLUGIN.Scales or {}



-----------------------------------------
--[[ RELATIVE TO SCR PANEL SCALES ]]-----
-----------------------------------------
function PLUGIN:LoadFonts()
    local sc = self.Scales

    sc.sW = sW()
    sc.sH = sH()
    sc.scale = (sc.sH/1080) * 0.75 
    sc.pickW = 836 * sc.scale
    sc.pickH = 38 * sc.scale
    sc.lockInnerW = 1037 * sc.scale
    sc.lockInnerH = 1037 * sc.scale
    sc.backgroundW = 730 * sc.scale
    sc.backgroundH = 730 * sc.scale
    sc.lockOuterW = 1037 * sc.scale
    sc.lockOuterH = 1037 * sc.scale
end



-----------------------------------
--[[ CREATE / REMOVE INTERFACE ]]--
-----------------------------------
function PLUGIN:CreateInterface()
    local i = setmetatable({}, self.InterfaceClass)
    self.Interface = i
    return i
end

function PLUGIN:RemoveInterface()
	local i = PLUGIN.Interface
	i = nil
	PLUGIN.Interface = nil
end


-------------------------
--[[ INTERFACE CLASS ]]--
-------------------------
local Class = PLUGIN.InterfaceClass or {}
Class.__index = Class
Class.Sounds = {}
Class.LockAngle = 0
Class.OldPinRotation = 0
Class.NextPickSound = 1.5


-- Open interface panel and enable lock movements
function Class:Start()
	self.Panel = vgui.Create("forpLockpick")
	self.Panel:OnInit()
end

-- Close interface panel and disable lock movements
function Class:Stop(share, msg)
    local panel = self.Panel
    if ( IsValid(panel) ) then
        panel:Remove()
	end

    self:StopSound("tension")

	-- Stop hooks
	if ( msg )  then
		LocalPlayer():foNotify(L(PLUGIN.Messages[msg]))
	end

    if ( share ) then
        netstream.Start("lpStop")
	end
	
    PLUGIN:RemoveInterface()
end


-- Stared action that will start the lockpicking
function Class:StartingAction(state, enterMoment)
    if (state) then
		if (enterMoment) then
			timer.Create("lpEnterSound", enterMoment - 1, 1, function()
				self:PlaySound("lockpicking/enter.wav", 50, 1, "enter")
			end)
		end

		if (IsValid(nut.gui.menu)) then
			nut.gui.menu:Remove()
		end
	end
end

-- Stared action that will load another bobbypin
function Class:ChangePinAction(time)
	self.RotatingLock = false
	self.ChangingPin = true
	timer.Simple(time, function()
		self.ChangingPin = false
	end)

	self:PlaySound("lockpicking/pickbreak_"..math.random(3)..".wav", 50, 1)

	timer.Create("lpEnterSound" ,time - 1, 1, function()
		self:PlaySound("lockpicking/enter.wav", 50, 1, "enter")
	end)
end


-- Play a lockpicking sound that can be stopped whenever we want
function Class:PlaySound(soundName, soundLevel, volume, id)
    local sound = CreateSound(LocalPlayer(), soundName)
	sound:ChangeVolume(volume)
	sound:SetSoundLevel(soundLevel)
	sound:Play()
        
    local sounds = self.Sounds
	if (id) then
		sounds[id] = sound
    end
end

-- Stop a lockpicking sound
function Class:StopSound(id)
	local sounds = self.Sounds
	if (sounds[id]) then
		sounds[id]:Stop()
		sounds[id] = nil
	end
end


-- Move lock cylinder and simulate physics
function Class:Think()
	local cfg = PLUGIN.Config

	self.MaxLockAngle = self.MaxLockAngle or cfg.HardMaxAngle

	self.exceedMax = false
	if (not self.Success) then
		if (self.RotatingLock and not self.ChangingPin) then
			self.LockAngle = self.LockAngle - (cfg.TurningSpeed * FrameTime())

			if (self.LockAngle < self.MaxLockAngle) then
				self.exceedMax = true
				self.LockAngle = self.MaxLockAngle
			end

			if (not self.CylinderTurned) then
				self:PlaySound("lockpicking/cylinderturn_"..math.random(8)..".wav", 50, 1, "cylinder")
				self:PlaySound("lockpicking/a/cylindersqueak_"..math.random(7)..".wav", 50, 1, "squeak")

				self.CylinderTurned = true
			end
		else
			self.LockAngle = self.LockAngle + (cfg.ReleasingSpeed * FrameTime())
			self.LockAngle = math.min(self.LockAngle, 0)
			self.CylinderTurned = nil

			self:StopSound("cylinder")
			self:StopSound("squeak")
		end
	end

	if (self.exceedMax) then
		if (self.LockAngle <= cfg.UnlockMaxAngle) then
			self.Success = true
			netstream.Start("lpSuccess")
			self:PlaySound("lockpicking/unlock.wav", 50, 1)
		else
			if (not self.CylinderStopped) then
				self.CylinderStopped = true

				self:PlaySound("lockpicking/picktension.wav", 50, 1, "tension")
				self:PlaySound("lockpicking/cylinderstop_"..math.random(4)..".wav", 50, 1)
			end
		end
		
	else
		self.CylinderStopped = false
		self:StopSound("tension")
	end
	
	-- Draw the bobbypin
	if (not self.RotatingLock and not self.Success and not self.ChangingPin) then
		local mX, mY = gui.MouseX(), gui.MouseY()
		self.PinAngle = math.deg(math.atan2(mY - sH() / 2, mX - sW() / 2))
			
		if (self.OldPinRotation ~= self.PinAngle) then
			self.MaxLockAngle = nil
			self.LastPickMove = CurTime()

			if (CurTime() > self.NextPickSound) then
				self.NextPickSound = CurTime() + math.Rand(0.5, 1)
				self:PlaySound("lockpicking/pickmovement_"..math.random(13)..".wav", 50, 1)
			end
				
			self.OldPinRotation = self.PinAngle
		end
	end
end


PLUGIN.InterfaceClass = Class



----------------
--[[ HOOKS ]]---
----------------
-- Start lock rotation / Close the interface
function PLUGIN:PlayerButtonDown(ply, btn)
	local cfg = self.Config
    local i = self.Interface

	if ( not i ) then return end

    local panel = i.Panel

	if (btn == KEY_D) then
		if (i.LockAngle ~= 0) then return end
		if (i.Success) then return end
		if (i.ChangingPin) then return end
		if (i.LastRotating and CurTime() - i.LastRotating < cfg.SpamTime + 0.08) then return end

		netstream.Start("lpRotat", true, i.PinAngle)

		i.LastRotating = CurTime()
		i.RotatingLock = true
	elseif (btn == KEY_E) then
		i:Stop(true)
	end
end

-- Stop lock rotation
function PLUGIN:PlayerButtonUp(ply, btn)
	local i = self.Interface
    if ( not i ) then return end
    
	if (btn == KEY_D) then
		if (not i.RotatingLock) then return end
		if (i.Success) then return end
		if (i.ChangingPin) then return end

		netstream.Start("lpRotat", false)

		i.RotatingLock = false
	end
end


local allowCommand
function PLUGIN:StartCommand(ply, cmd)
	if ( not allowCommand and self.Interface and ply == LocalPlayer() ) then
        cmd:SetButtons(0)
    end

    allowCommand = false
end

function PLUGIN:Move(ply, mvd)
    if ( self.Interface and ply == LocalPlayer() ) then
        return true
    end
end

function PLUGIN:PlayerSwitchWeapon(ply, oldWep, newWep)
    local allowCommand = ( newWep:GetClass() == "nut_hands" )

	if ( not allowCommand and self.Interface and ply == LocalPlayer() ) then
        return true
    end
end



--------------------
--[[ NETWORKING ]]--
--------------------
netstream.Hook("lpStarting", function(state, enterMoment)
    local i = PLUGIN:CreateInterface()
    i:StartingAction(state, enterMoment)
end)


netstream.Hook("lpChange", function(time)
    local i = PLUGIN.Interface
    if ( not i ) then return end

    i:ChangePinAction(time)
end)


netstream.Hook("lpStart", function(itemId)
    local i = PLUGIN.Interface
	if ( not i ) then return end
	local item = nut.item.instances[itemId]
	if ( not item ) then return end

	i.Item = item
    i:Start()
end)

netstream.Hook("lpStop", function(reason)
	local i = PLUGIN.Interface
    if ( not i ) then return end

    i:Stop(false, reason)
end)


netstream.Hook("lpMax", function(pickAng, ang)
	local i = PLUGIN.Interface
    if ( not i ) then return end

	if (tostring(pickAng) == tostring(i.PinAngle)) then
		i.MaxLockAngle = ang
	end
end)


netstream.Hook("lpFail", function()
	local i = PLUGIN.Interface
	if ( not i ) then return end
	
	i:PlaySound("lockpicking/pickbreak_"..math.random(3)..".wav", 50, 1)
	i:Stop()
end)