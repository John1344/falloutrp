---------------
--[[ FONTS ]]--
---------------
local CreateFont = surface.CreateFont
function SCHEMA:LoadFonts(font)

    CreateFont("LargeText54",{
	    font = "Arial",
	    size = 54,
	    antialias = true,
	    blursize = 0,
	    scanlines = 0,
	    weight = 200
    })

    CreateFont("ColaborateL12",{
    	font = "ColaborateLight",
	    size = 12,
    	antialias = true,
	    blursize = 0,
    	scanlines = 0,
    	weight = 200
    })

    CreateFont("ColaborateL16",{
	    font = "ColaborateLight",
	    size = 16,
	    antialias = true,
    	blursize = 0,
    	scanlines = 0,
    	weight = 200
    })

    CreateFont("ColaborateL24",{
    	font = "ColaborateLight",
	    size = 24,
    	antialias = true,
    	blursize = 0,
    	scanlines = 0,
	    weight = 200
    })

    CreateFont("ColaborateL36",{
	    font = "ColaborateLight",
	    size = 36,
	    antialias = true,
	    blursize = 0,
	    scanlines = 0,
	    weight = 200
    })

    CreateFont( "FOFont_big",{
	    font = "Impact",
	    size = 45,
	    weight = 400,
	    underline = 0,
	    additive = false,
	    outline = false,
	    blursize = 1
    })

    CreateFont( "FOFont_normal",{
	    font = "Impact",
	    size = 25,
	    weight = 400,
	    underline = 0,
	    additive = false,
    	outline = false,
	    blursize = 1
    })

    CreateFont("FOFont_big_blur",{
    	font = "Impact",
	    size = 45,
	    weight = 400,
	    underline = 0,
	    additive = false,
	    outline = false,
	    blursize = 1
    })

    CreateFont("FOFont_normal_blur",{
    	font = "Impact",
    	size = 25,
    	weight = 400,
    	underline = 0,
    	additive = false,
    	outline = false,
    	blursize = 1
    })

    CreateFont("forp_ChatFontWhisper", {
    	font = "ChatFont",
    	size = 14,
    	weight = 1600,
    	italic = false
    })

    CreateFont("forp_ChatFontActionClose", {
    	font = "ChatFont",
    	size = 14,
    	weight = 1600,
    	italic = true
    })

    CreateFont("forp_ChatFontAction", {
    	font = "ChatFont",
    	size = 20,
    	weight = 1600,
    	italic = true
    })

    CreateFont("forp_ChatFontActionLong", {
    	font = "ChatFont",
    	size = 26,
    	weight = 1600,
    	italic = true
    })

    CreateFont("forp_ChatFontYell", {
    	font = "ChatFont",
    	size = 26,
    	weight = 1600,
    	italic = false
    })

    CreateFont("forp_ChatFontEvent", {
    	font = "ChatFont",
    	size = 22,
    	weight = 1600,
    	italic = true
    })

    CreateFont("nut_MenuButtonFont", {
	    font = "ChatFont",
	    size = 24,
	    weight = 800
    })

    CreateFont("nut_newchatfont", {
    	font = "ChatFont",
    	size = 18,
    	weight = 1200
    })

    CreateFont("nut_menufont", {
    	font = "ChatFont",
    	size = 14,
    	weight = 500
    })

    CreateFont("Monofonto18", {
	    font = "Monofonto",
	    size = 18,
	    weight = 300
    })

    CreateFont("Monofonto24", {
    	font = "Monofonto",
    	size = 24,
    	weight = 500
    })
	
    CreateFont("Monofonto24_blur", {
    	font = "Monofonto",
    	size = 24,
    	weight = 400,
    	underline = 0,
    	additive = false,
    	outline = false,
	    blursize = 1
    })

    CreateFont("Monofonto32", {
    	font = "Monofonto",
    	size = 32
    })

    CreateFont("Monofonto24CC", {
	    font = "Monofonto",
	    size = 24,	
	    weight = 0,
	
    })

    CreateFont("Monofonto36", {
    	font = "Monofonto",
    	size = 36,	
    	--weight = 500,
    	--shadow = true
    })

	CreateFont("MonofontoTitle", {
    	font = "Monofonto",
    	size = 64,	
    	weight = 500,
    	--shadow = true
    })

	CreateFont("MonofontoSubtitle", {
    	font = "Monofonto",
    	size = 34,	
    	weight = 500,
    	--shadow = true
    })

    CreateFont("FranKleinBold", {
    	font = "FranKleinBold",
    	size = 32,	
    	weight = 500,
    	--shadow = true
    })

    CreateFont("Monofonto20CC", {
    	font = "Monofonto",
    	size = 20,	
    	weight = 0,
	
    })

    CreateFont("Monofonto30CC", {
    	font = "Monofonto",
      	size = 30,	
    	weight = 0,
	
    })

end


------------------------
--[[ CURSOR DRAWING ]]--
------------------------
local cursor = Material("forp/cursor.png")

function SCHEMA:DrawOverlay()
	if vgui.CursorVisible() then
		local panel = vgui.GetHoveredPanel()

		if (panel) then
			panel:SetCursor("blank")
		end

		local x, y = input.GetCursorPos()

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(cursor)
		surface.DrawTexturedRect(x, y, 25, 34)
	end
end