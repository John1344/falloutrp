local PLUGIN = PLUGIN
PLUGIN.name = "Jukeboxes & Radios"
PLUGIN.desc = "Add jukeboxes and radios ( handle stream urls )"
PLUGIN.author = "Cat.jpeg"


nut.config.add("radioDist", 1000, "Maximum radios/jukeboxes hear distance.", function(old, new)
    if ( CLIENT ) then
        for _, v in pairs(PLUGIN.activeRadios) do
            local channel = v.channel
            if ( channel and channel:IsValid() ) then
                channel:Set3DFadeDistance(new * 0.5, new)
            end
        end
    end
end, {data = {min = 1, max = 2000}, category = "Jukeboxes & Radios"})

nut.config.add("radioUrl", "http://fallout.fm:8000/falloutfm3.ogg", "The radio url used by radios and jukeboxes.", function()
    if ( CLIENT ) then
        for _, v in pairs(PLUGIN.activeRadios) do
            v:StopStream()
            v:StartStream()
        end
    end
end, {category = "Jukeboxes & Radios"})


nut.util.include("sv_plugin.lua")
nut.util.include("cl_plugin.lua")