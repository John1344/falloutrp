include("shared.lua")
local PLUGIN = PLUGIN


function ENT:Draw()
    self:DrawModel()
end


function ENT:Think()
    local channel = self.channel
    if ( channel and channel:IsValid() ) then
        channel:SetPos(self:GetPos())
    end
end


function ENT:StartStream()
    sound.PlayURL( nut.config.get("radioUrl"), "3d", function(channel)
        if ( channel ) then
            self.channel = channel
            channel:SetPos( self:GetPos() )
            channel:Set3DFadeDistance(nut.config.get("radioDist") * 0.5, nut.config.get("radioDist"))
            channel:Play()
        end
    end)

    self.started = true
end

function ENT:StopStream()
    local channel = self.channel

    if ( channel and channel:IsValid() ) then
        channel:Stop()
    end

    self.started = false
end

function ENT:OnRemove()
    self:StopStream()
    table.RemoveByValue(PLUGIN.activeRadios, self)
end