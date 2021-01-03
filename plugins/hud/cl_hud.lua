function PLUGIN:CanDrawAmmoHUD()
	return false
end

-- Remove certain bars 
local barsToRemove = {
	["health"] = true,
	["stm"] = true
}

for k, v in pairs(nut.bar.list) do
	if barsToRemove[v.identifier] then
		nut.bar.list[k] = nil
	end
end
--

local function splitString(inputstr)
	local t = {}
	
	for str in string.gmatch(inputstr, "[^%\n$]+") do
		table.insert(t, str)
	end
	
	return t
end

local function DrawBlur(x,y,text,align,blur,color,font,blurfont,alpha)

	local alpha = alpha or 255

	if blur == nil then 
		blur = false 
	end

	if color and color != 0 then
		color = color
	else
		color = fo.ui.GetHUDColor()
	end

	local normfo, blurfo = "FOFont_normal", "FOFont_normal_blur"

	if (font and blurfont) then
		normfo = font
		blurfo = blurfont
	end
	
	local linesToDisplay = splitString(text)
	local i = 0

	for k, v in pairs(linesToDisplay) do
		i = i + 1
		local fixedY = y + ((i - 1) * 28)
	
		if (!blur) then
			for i =0,3 do			
				draw.SimpleText(v, blurfo, x, fixedY, Color(0, 0, 0, alpha), align, 0)
			end

			draw.SimpleText(v, normfo, x, fixedY, color, align, 0)
		else
			for i =0,3 do
				draw.SimpleText(v, "FOFont_big_blur", x, fixedY, Color(0, 0, 0, alpha), align, 0)
			end

			draw.SimpleText(v, "FOFont_big", x, fixedY, color, align, 0)
		end
	end
end

local intEntities = {
    nut_microwave = "intMicroW",
    nut_stove = "intStove",
    nut_campfire = "intCampfire",
	nut_vendor = {intName = "intSpeakToVendor"},
	nut_storage = function(ent) return string.upper(input.LookupBinding( "+use" ))..") "..L"intOpen".."\n"..STORAGE_DEFINITIONS[ent:GetModel():lower()].name end
}

local intHooks = {
	door = function(ent)
		if (ent:isDoor() && !ent:getNetVar("hidden")) then
			return string.upper(input.LookupBinding( "+use" ))..") "..L"intUse".."\n"..L"intDoor"
		end
	end,
	corpse = function(ent)
		if (ent:IsCorpse()) then
			local corpseName

			if ( LocalPlayer():getChar():doesRecognize(ent:GetNW2Int("corpseChrId")) ) then
				corpseName = ent:GetNW2String("corpseChrName")
			end
			corpseName = corpseName or "Corpse"

			return string.upper(input.LookupBinding( "+use" ))..") ".."Search\n"..corpseName
		end
	end
}

local nextRefresh = 0
local text

function PLUGIN:Tick()
	if CurTime() > nextRefresh && LocalPlayer().GetEyeTraceNoCursor then
		text = nil
		local trace = LocalPlayer():GetEyeTraceNoCursor()

		if (LocalPlayer():GetPos():Distance(trace.HitPos)) < 110 then
			local ent = trace.Entity
			if (ent and ent:GetClass() != "Worldspawn") then
				local class = ent:GetClass()
				
				if intEntities[class] then
					
					local interaction = intEntities[class]
					local Type = type(interaction)

					if Type == "string" then
						text = string.upper(input.LookupBinding( "+use" ))..") "..L"intUse".."\n"..L(interaction)
					elseif Type == "table" then
						text = string.upper(input.LookupBinding( interaction.key or "+use" ))..") "..L(interaction.intName or "intUse").."\n"
						
						if (interaction.entName) then
							text = text..L(interaction.entName)
						end
					else
						text = interaction(ent)
					end
					
				else
					for k, v in pairs(intHooks) do
						local textReturned = v(ent)
						
						if textReturned then
							text = textReturned
							break
						end
					end
				end
			end
		end
		nextRefresh = CurTime() + 0.1
	end
end

local hammo = surface.GetTextureID("hud/fo/ammo")
local htock = surface.GetTextureID("hud/fo/tick") 
local cross_normal = Material("forp/glow_crosshair.png", "noclamp smooth")
local cross_highlight = Material("forp/glow_crosshair_filled.png", "noclamp smooth")
local bottom_infobars = Material("forp/glow_hud_bottom_info_seperator_divider.png", "noclamp smooth")

local validclasses = {"nut_keys", "nut_hands", "weapon_physgun", "gmod_tool"}

local compass = surface.GetTextureID("hud/fo/compass") 
local npc = surface.GetTextureID("hud/fo/pointer2") 
local player = surface.GetTextureID("hud/fo/player_found") 
local objetive = surface.GetTextureID("hud/fo/objetive")

local htick = surface.GetTextureID("hud/fo/tick") 
local hbar = surface.GetTextureID("hud/fo/life_hud") 
local henemy = surface.GetTextureID("hud/fo/enemy_health") 
local armor = surface.GetTextureID("hud/fo/armor") 




function PLUGIN:HUDPaint()
	if ( hook.Run("FalloutHUDShouldDraw") == false ) then return end

	if !LocalPlayer():getChar() then 
		return 
	end
	
	local class
	if (LocalPlayer():Alive() and LocalPlayer():GetActiveWeapon():IsValid()) then
		class = LocalPlayer():GetActiveWeapon():GetClass()
	end

		if (LocalPlayer():Alive() and !LocalPlayer():getLocalVar("ragdoll") && hook.Run("CanDrawEntInt") != false) then
			if !nut.config.get("hCrossWhenWep") or table.HasValue(validclasses, class) then
			if !nut.config.get("hCrossWhenWep") or !(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) > 0 or LocalPlayer():GetActiveWeapon():Clip1() > -1) then
				if (text != nil) then
					surface.SetMaterial(cross_highlight)
					surface.SetDrawColor(fo.ui.GetHUDColor())
					surface.DrawTexturedRectRotated(ScrW()/2, ScrH() /2, 64,64,0)

					DrawBlur(ScrW()/2, ScrH() - 130, text, 1, false)
				else
					surface.SetMaterial(cross_normal)
					surface.SetDrawColor(fo.ui.GetHUDColor())
					surface.DrawTexturedRectRotated(ScrW()/2, ScrH() /2, 64,64,0)
				end
			end
			end
		end

	surface.SetTexture(hammo)
	surface.SetDrawColor(fo.ui.GetHUDColor())   
	surface.DrawTexturedRectRotated( ScrW() - 170, ScrH() - 40, 390,200,0 )

	if LocalPlayer():getLocalVar("stm") && LocalPlayer():getLocalVar("stm") <= 100 && LocalPlayer():getLocalVar("stm") then
		hl = LocalPlayer():getLocalVar("stm")
		for i=0,hl/2.75 do
			surface.SetTexture(htock)
			surface.SetDrawColor(fo.ui.GetHUDColor())
			surface.DrawTexturedRectRotated( ScrW()  - 90 - i * 6, ScrH() - 100, 20,24,0 )
		end

	elseif(LocalPlayer():Health() > 0) then

		for i=0,36.3636 do
			surface.SetTexture(htock)
			surface.SetDrawColor(fo.ui.GetHUDColor())
			surface.DrawTexturedRectRotated( ScrW() - 100 - i * 7, ScrH() - 116, 24,30,0 )
		end
	end


	DrawBlur(90,ScrH() - 135,"HP",0)
	DrawBlur(ScrW() - 95, ScrH() - 135,"STM",2)

	if(LocalPlayer():GetActiveWeapon():IsValid()) then
		if LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) > 0 or LocalPlayer():GetActiveWeapon():Clip1() > -1 then
			if(LocalPlayer():GetActiveWeapon():Clip1() > -1) then
				DrawBlur(ScrW() - 95,ScrH() - 80,tostring(LocalPlayer():GetActiveWeapon():Clip1()).."/"..tostring(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())),2)
			else
				DrawBlur(ScrW() - 95,ScrH() - 80,tostring(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())),2)
			end
		end
	end

	for c,b in pairs(ents.GetAll()) do
		if(b:GetNWBool("FOObjetive") == true) then
			ang = LocalPlayer():GetAngles().y - SCHEMA.GetAngleOfLineBetweenTwoPoints(LocalPlayer(),b)
				if (ang < -103) then
					ang = -104
				elseif(ang > 145) then
					ang = 145
				end

				surface.SetTexture(objetive)

				if(b:GetNWBool("Enemy") == true) then
					surface.SetDrawColor(255,75,75,255)
				else
					surface.SetDrawColor(fo.ui.GetHUDColor())
				end
			surface.DrawTexturedRectRotated(ang + 202, ScrH() - 48 , 48,48,0 )
		end
	end
	surface.SetTexture(compass)
	surface.SetDrawColor(fo.ui.GetHUDColor())
	SCHEMA.DrawPartialTexturedRect( 82, ScrH() - 97, 256, 64, (-LocalPlayer():GetAngles().y/360) * 1024, 0, 256, 64,1024,64 );

	surface.SetTexture(hbar)
	surface.SetDrawColor(fo.ui.GetHUDColor())
	surface.DrawTexturedRectRotated( 264, ScrH() - 40, 390,200,0 )

	if(LocalPlayer():Health() <= 100 && LocalPlayer():Health() > 0) then
		hl = LocalPlayer():Health()
		for i=0,hl/2.75 do
			surface.SetTexture(htick)
			surface.SetDrawColor(fo.ui.GetHUDColor())
			surface.DrawTexturedRectRotated( 92.5 + i * 6, ScrH() - 100, 20,24,0 )
		end
	elseif(LocalPlayer():Health() > 0) then
		for i=0,36.3636 do
			surface.SetTexture(htick)
			surface.SetDrawColor(fo.ui.GetHUDColor())
			surface.DrawTexturedRectRotated( 92.5 + i * 6, ScrH() - 100, 20,24,0 )
		end
	end

	if (LocalPlayer():Armor() > 0) then
			surface.SetTexture(armor)
			surface.SetDrawColor(fo.ui.GetHUDColor())
			surface.DrawTexturedRectRotated( 327, ScrH() - 102, 20,20,0 )
	end

	if(LocalPlayer():GetNWEntity("FOVictim"):IsValid()) then
		DrawBlur(ScrW()/2,ScrH() - 85,LocalPlayer():GetNWEntity("FOVictim"):GetClass(),1,false)

		surface.SetTexture(henemy)
		surface.SetDrawColor(255,70,70,255)
		surface.DrawTexturedRectRotated( ScrW() / 2 + 60, ScrH() - 75, 390,75,0 )
		exponent = LocalPlayer():GetNWInt("VOHLT")/LocalPlayer():GetNWInt("VLIFE") * 100

		for i=0,exponent/6.5 do
			surface.SetTexture(htick)
			surface.SetDrawColor(255,70,70,255)
			surface.DrawTexturedRectRotated( ScrW() / 2 + 5 - i * 6, ScrH() - 100, 24,30,0 )
		end

		for i=0,exponent/6.5 do
			surface.SetTexture(htick)
			surface.SetDrawColor(255,70,70,255)
			surface.DrawTexturedRectRotated( ScrW() / 2 + 10 + i * 6, ScrH() - 100, 23,30,0 )
		end
	end
end






function SCHEMA.DrawPartialTexturedRect(x, y, w, h, partx, party, partw, parth, texw, texh)

    -- Verify that we recieved all arguments
    if !( x && y && w && h && partx && party && partw && parth && texw && texh ) then

        return
    end

    -- Get the positions and sizes as percentages / 100
    local percX, percY = partx / texw, party / texh
    local percW, percH = partw / texw, parth / texh

    -- Process the data
    local vertexData = {
        {
            x = x,
            y = y,
            u = percX,
            v = percY
        },
        {
            x = x + w,
            y = y,
            u = percX + percW,
            v = percY
        },
        {
            x = x + w,
            y = y + h,
            u = percX + percW,
            v = percY + percH
        },
        {
            x = x,
            y = y + h,
            u = percX,
            v = percY + percH
        }
    }
    surface.DrawPoly( vertexData )
end