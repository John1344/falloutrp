local PLUGIN = PLUGIN

function PLUGIN:PlayerInitialSpawn(ply)
    if ( self.streamUrl == self.defaultUrl ) then return end
    netstream.Start(ply, "foRadioUrl", self.streamUrl)
end