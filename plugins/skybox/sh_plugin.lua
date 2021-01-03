PLUGIN.name = "Fallout Sky"
PLUGIN.author = "vin"
PLUGIN.desc = "Emulates the iconic sky of the Mojave desert."
-- sky
PLUGIN.SkyName = "painted"
PLUGIN.TopVector = "0.04 0.11 1.00"
PLUGIN.BottomVector = "1.00 1.00 1.00"
PLUGIN.SkyFade = "1.00"
PLUGIN.HDRScale = "1.00"
-- clouds
PLUGIN.CloudTexture = "forp/fallout_cloud3"
PLUGIN.StarScale = "0.65"
PLUGIN.StarFade = "0.78"
PLUGIN.StarSpeed = "0.0225"
-- lighting
PLUGIN.DuskIntensity = "4.69"
PLUGIN.DuskScale = "1.00"
PLUGIN.DuskColor = "0.94 0.71 0.18"

function PLUGIN:Initialize() -- automatically load the sky
	if not nut.config.get("falloutSky") or nut.config.get("falloutSky") == true then
		RunConsoleCommand("sv_skyname", "painted")
		if SERVER then
			for k,v in pairs(ents.FindByClass("env_skypaint")) do
				v:Remove()
			end
			PLUGIN.SkyPaint = ents.Create("env_skypaint")
			PLUGIN.SkyPaint:Spawn()

			local sky = PLUGIN.SkyPaint

			sky:SetKeyValue("TopColor", PLUGIN.TopVector)
			sky:SetKeyValue("BottomColor", PLUGIN.BottomVector)
			sky:SetKeyValue("FadeBias", PLUGIN.SkyFade)
			sky:SetKeyValue("HDRScale", PLUGIN.HDRScale)
			--Stars
			sky:SetKeyValue("DrawStars", "true")
			sky:SetKeyValue("StarTexture", PLUGIN.CloudTexture)
			sky:SetKeyValue("StarScale", PLUGIN.StarScale)
			sky:SetKeyValue("StarFade", PLUGIN.StarFade)
			sky:SetKeyValue("StarSpeed", PLUGIN.StarSpeed)
			--Dusk
			sky:SetKeyValue("DuskIntensity", PLUGIN.DuskIntensity)
			sky:SetKeyValue("DuskScale", PLUGIN.DuskScale)
			sky:SetKeyValue("DuskColor", PLUGIN.DuskColor)
			--Sun
			sky:SetKeyValue("SunSize", "0")
			skyLoaded = true

			print("[FALLOUTRP] Skybox setup!")
		end
	end
end

nut.config.add("falloutSky", true, "Wether or not to use the custom sky shader. (requires restart)", nil, {
	category = "appearance"
})