local PLUGIN = PLUGIN
PLUGIN.nextCheck = 0
PLUGIN.activeRadios = PLUGIN.activeRadios or {}


function PLUGIN:Think()
    local time = CurTime()

    -- Avoid lag
    if ( time < self.nextCheck ) then return end
    self.nextCheck = time + 0.2

    -- Start near inactive radios
    local ents = ents.FindInSphere(LocalPlayer():GetPos(), nut.config.get("radioDist"))

    for _, v in pairs ( ents ) do

        if ( v.forp_IsRadio and v:getNetVar("power") == true ) then
            if ( not v.started ) then
                v:StartStream()
                table.insert(self.activeRadios, v)
            end

            -- Tell the last check for the next loop
            v.lastCheck = time
        end

    end

    -- Stop far away radios
    for k, v in pairs(self.activeRadios) do

        if ( IsValid(v) and time > v.lastCheck or not v:getNetVar("power") ) then
            v:StopStream()
            self.activeRadios[k] = nil
        end

    end
end