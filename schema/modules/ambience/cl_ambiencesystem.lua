FO_AMB = FO_AMB or {}
FO_AMB.Tracks = FO_AMB.Tracks or {}
--
FO_AMB.TimerName = "AMBIENCE SYSTEM"
FO_AMB.Fade = 5
----------------------------------------------------

local VOLUME_CVAR = VOLUME_CVAR or CreateClientConVar("fallout_ambience_vol", "35", true)

local PANEL = {}

function PANEL:Init()
	self:SetTitle(L("volume"))
	self:SetSize(300, 100)
	self:Center()
	self:MakePopup()

	local cfg = self:Add("DNumSlider")
	cfg:Dock(TOP)
	cfg:SetMin(0)				 // Set the minimum number you can slide to
	cfg:SetMax(100)				// Set the maximum number you can slide to
	cfg:SetDecimals(0)			 // Decimal places - zero for whole number
	cfg:SetConVar("fallout_ambience_vol") // Changes the ConVar when you slide
	
	local reset = self:Add("DButton")
	reset:Dock(TOP)
	reset:SetText("Reset to default")
	reset.DoClick = function(btn)
		VOLUME_CVAR:SetInt(tonumber(VOLUME_CVAR:GetDefault()))
	end
end

vgui.Register("nutAmbienceVolume", PANEL, "DFrame")

hook.Add("SetupQuickMenu", "addVolumeTab", function(menu)
	local button = menu:addButton(L"ambienceVolume", function()
		if (nut.gui.tpconfig and nut.gui.tpconfig:IsVisible()) then
			nut.gui.tpconfig:Close()
			nut.gui.tpconfig = nil
		end

		nut.gui.tpconfig = vgui.Create("nutAmbienceVolume")
	end)

	menu:addSpacer()
end)

local function volumeAndFade()
	if !FO_AMB.Sound then return end
	
	local vol = (VOLUME_CVAR:GetInt() / 100) * (FO_AMB.CurrentTrackVol/100)

	if FO_AMB.FadeType then
		local currentFade = math.min( CurTime() - FO_AMB.FadeStart, FO_AMB.Fade) -- Fade is 5 seconds for in and out
		local fade = currentFade / FO_AMB.Fade
		
		if FO_AMB.FadeType == "in" then
			FO_AMB.Sound:ChangeVolume(vol * fade)
		else
			FO_AMB.Sound:ChangeVolume(vol - (vol * fade))
		end
		
		if currentFade == FO_AMB.Fade then
			FO_AMB.FadeType = nil
			FO_AMB.FadeStart = nil
		end
	else
		FO_AMB.Sound:ChangeVolume(vol)
	end
end

hook.Add( "Tick", "AmbienceTick", function()
	volumeAndFade()
	FO_AMB.RadiusThink()
	if !LocalPlayer() then return end
	local disabled = false
	if disabled or (nut.gui.char && nut.gui.char:IsVisible()) then
		FO_AMB.StopTrack()
	return end
	--------------
	if FO_AMB.CanChangeSound() then
		FO_AMB.PlayTrack(5)
	end
end)

netstream.Hook("ambienceDeath", function(ent)
	FO_AMB.StopTrack(5)
end)

--------------------------------
--AMBIENCE
function FO_AMB.CanChangeSound()
	return !FO_AMB.CurrentTrack && (LocalPlayer().Alive && LocalPlayer():Alive())
end

function FO_AMB.SetVolume(vol)
	FO_AMB.TrackVol = vol
	local track = FO_AMB.Sound
		
	if track != nil then
		track:ChangeVolume(vol/100)
	end
end

function FO_AMB.GetRadius()
	return FO_AMB.Radius
end

function FO_AMB.SetRadius(rad)
	FO_AMB.Radius = rad
	if rad == nil then 
		FO_AMB.SetNextTrack()
		FO_AMB.PlayTrack()
		return 
	end
	FO_AMB.SelectRadTrack(true)
end

function FO_AMB.GetRadTracks(rad, ignore)
	local tracks = FO_AMB.Tracks
	local selected = {}
	--
	for k,v in pairs(tracks) do
		if FO_AMB.CurrentTrack == k then continue end
		
		if v.RadiusName == rad or !ignore and v.IgnoreRad and table.HasValue(v.IgnoreRad, rad) then
			table.insert(selected, k)
		end
	end
	--
	return selected
end

function FO_AMB.SelectRadTrack(ignore)
	local rad = FO_AMB.GetRadius()
	local selected = FO_AMB.GetRadTracks(rad, ignore)
	--
	local index = table.Random(selected)
	FO_AMB.CurrentTrack = index
	print("Set track to RADIUS "..index)
end

function FO_AMB.RegisterTrack(name,dir,length,volume,ignore_rad,radname)
	if !name or name == "" then return end
	FO_AMB.Tracks[name] = {
	  Dir = dir,
	  Length = length,
	  Volume = volume,
	  IgnoreRad = ignore_rad,
	  RadiusName = radname
	}
end

function FO_AMB.CacheTracks()
	FO_AMB.Cached = FO_AMB.Cached or {}
	for k,v in pairs(FO_AMB.Tracks) do
		if v.RadiusName then continue end
		
		table.insert(FO_AMB.Cached,k)
	end
end

function FO_AMB.StopTrack(doFade, onStopped)
	timer.Destroy(FO_AMB.TimerName)

	if !doFade then
		if FO_AMB.CurrentTrack != nil then
			FO_AMB.Sound:Stop()
			FO_AMB.CurrentTrack = nil
			if onStopped then
				onStopped()
			end
		end
	else
		if FO_AMB.CurrentTrack != nil then
			if doFade then
				FO_AMB.FadeType = "out"
				FO_AMB.FadeStart = CurTime()
			end
			timer.Simple(FO_AMB.Fade, function()
				FO_AMB.Sound:Stop()
				FO_AMB.CurrentTrack = nil
				if onStopped then
					onStopped()
				end
			end)
		end
	end
  
end

function FO_AMB.PlayTrack(fade, trackName)
	fade = fade or 0

	if timer.Exists(FO_AMB.TimerName) then
		timer.Destroy(FO_AMB.TimerName)
	end
	
	local tbl
		
	if trackName then
		FO_AMB.CurrentTrack = trackName
		tbl = FO_AMB.Tracks[trackName]
	else
		if !FO_AMB.Cached then
			FO_AMB.CacheTracks()
		end

		tbl = FO_AMB.Tracks[table.Random(FO_AMB.Cached)]
		FO_AMB.CurrentTrack = table.KeyFromValue(FO_AMB.Tracks, tbl)
	end
			
	local volume = FO_AMB.TrackVol or tbl.Volume or 75
	FO_AMB.CurrentTrackVol = volume
	FO_AMB.Sound = CreateSound(LocalPlayer(),tbl.Dir)
	FO_AMB.Sound:Play()
	if fade then
		FO_AMB.FadeType = "in"
		FO_AMB.FadeStart = CurTime()
	end
	timer.Create(FO_AMB.TimerName,tbl.Length,1,function()
		FO_AMB.PlayTrack()
	end)
end

local delay = 2.5
FO_AMB = FO_AMB or {}
FO_AMB.RadiusVecs = FO_AMB.RadiusVecs or {}
--------------------------
------

function FO_AMB.RadiusThink()
	FO_AMB.NextRadius = FO_AMB.NextRadius or CurTime() + (delay*2)
	if FO_AMB.NextRadius > CurTime() then return end
	FO_AMB.NextRadius = CurTime() + delay
	--
	local ply = LocalPlayer()
	local pos = ply:GetPos()
	local tbl = FO_AMB.RadiusVecs
	if !tbl then return end
	
	for k,v in pairs(tbl) do
		if FO_AMB.Entered and FO_AMB.Entered != k then continue end
		
		local dist = pos:Distance(v.Vec)
		local radius = v.Rad
		if dist > radius then
			if FO_AMB.Entered then
				FO_AMB.SetRadius(nil)
				FO_AMB.Entered = nil
				print("Resetting Radius..")
			end
			continue
		end
		-- -- --
		local diff = (pos.z - v.Vec.z)
		if diff < -500 or diff > 0 and diff > 500 then
			if FO_AMB.Entered then
				FO_AMB.SetRadius(nil)
				FO_AMB.Entered = nil
				print("Resetting Radius..")
			end
			continue
		end

		local myrad = k
		local rad = FO_AMB.GetRadius()
		if rad != myrad and !FO_AMB.Entered then
			FO_AMB.SetRadius(myrad)
			FO_AMB.PlayTrack()
			FO_AMB.Entered = k
		end
	end
end
--------------------------------
--
concommand.Add("AMBIENCE_SetTrack",function(ply,cmd,args)
	local track = args[1]
	if !FO_AMB.Tracks[track] then return end
	print("Setting track to: "..track)
	FO_AMB.PlayTrack(0, track)
end)

concommand.Add("AMBIENCE_ReCacheSounds",function()
	FO_AMB.CacheTracks()
end)