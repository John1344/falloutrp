fo.ui = fo.ui or {}


-- Get a number multiplied by screen wide
function sW(num)
	local scrW = ScrW()
	if ( num ) then
		scrW = scrW * num
	end
	
	return scrW
end

-- Get a number multiplied by screen height
function sH(num)
	local scrH = ScrH()
	if ( num ) then
		scrH = scrH * num
	end

	return scrH
end

-- Original Fallout colors
forp_amber = Color(255, 182, 66, 255)
forp_white = Color(192, 255, 255 ,255)
forp_green = Color(26, 255, 128, 255)
forp_blue = Color(46, 207, 255, 255)
forp_red = Color(249, 65, 41)

forp_amber_grey = Color(78, 57, 25, 255)
forp_white_grey = Color(92, 114, 107, 255)
forp_green_grey = Color(23, 117, 60, 255)
forp_blue_grey = Color(31, 96, 112, 255)

-- Available ATH colors
local hudColors = {
	amber = forp_amber,
	white = forp_white,
	green = forp_green,
	blue = forp_blue
}

local hudGreyColors = {
	amber = forp_amber_grey,
	white = forp_white_grey,
	green = forp_green_grey,
	blue = forp_blue_grey
}

-- ATH color ConVar
FORP_CVAR_COLOUR = CreateClientConVar("forp_colour", "amber", true, false, "Changes the hud colour, can be amber, white, green or blue.")

-- Get ATH greyed color from ConVar
function fo.ui.GetHUDColor()
	return hudColors[FORP_CVAR_COLOUR:GetString()] or forp_amber
end

-- Get ATH greyed color from ConVar
function fo.ui.GetHUDGreyColor()
	return hudGreyColors[FORP_CVAR_COLOUR:GetString()] or forp_amber_grey
end


-- Show cursor and disable gui.EnableScreenClicker function
fo.ui.oldEnableScreenClicker = fo.ui.oldEnableScreenClicker or gui.EnableScreenClicker
function fo.ui.LockCursor()
	gui.EnableScreenClicker(true)
	gui.EnableScreenClicker = function() end
end


-- Hide cursor and enable gui.EnableScreenClicker
function fo.ui.UnlockCursor()
	gui.EnableScreenClicker = fo.ui.oldEnableScreenClicker
	gui.EnableScreenClicker(false)
end


-- Draw all text lines of a string table
function fo.ui.DrawWrappedText(lines, font, color, x, y, gap)
	local fontHeight = draw.GetFontHeight( font )
	surface.SetFont(font)
	surface.SetTextColor(color)

	for _, line in pairs(lines) do
		surface.SetTextPos(x, y)
		surface.DrawText(line)
		y = y + fontHeight + (gap or 0)
	end
end


-- Draw a rotated texture from his center
function fo.ui.DrawTexturedRectRotatedPoint(x, y, w, h, rot, x0, y0)
	local c = math.cos( math.rad( rot ) )
	local s = math.sin( math.rad( rot ) )
	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s

	surface.DrawTexturedRectRotated(x + newx, y + newy, w, h, rot)
end


-- Draw original Fallout blur
function fo.ui.DrawFalloutBlur(x, y, w, h, thickness)
	local col = Color(0,0,0)
	local thickness = thickness or 16

	for i = 0, thickness do
		local xChange, yChange, wChange, hChange = x + (i * 2), y + (i * 2), w - (i * 4), h - (i * 4)
		draw.RoundedBox(8, xChange, yChange, wChange, hChange, Color(col.r, col.g, col.b, 2 + (i * 4)))

		if i == thickness then
			return xChange, yChange, wChange, hChange -- We return the size of the inner frame so we can use it in panels to make the UI, this might not be the best way.
		end
	end
end

function fo.ui.DrawFalloutBlurText(x, y, text, xAlign, yAlign)
	local col = fo.ui.GetHUDColor()
	local bgCol = col
	bgCol.a = 180

	draw.SimpleText(text, "Monofonto24_blur", x, y, col, xAlign or nil, yAlign or nil)
    draw.SimpleText(text, "Monofonto24", x, y, bgCol, xAlign or nil, yAlign or nil)
end
