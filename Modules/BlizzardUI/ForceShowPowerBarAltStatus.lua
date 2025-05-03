local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("blizzardui.forceShowPowerBarAltStatus")
local L = SanluliUtils.Locale

hooksecurefunc(PlayerPowerBarAltStatusFrame, "Hide", function(self)
    if Module:GetConfig() then
        self:Show()
    end
end)