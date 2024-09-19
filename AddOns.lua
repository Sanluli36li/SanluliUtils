local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("addons")
local L = SanluliUtils.Locale

function Module.SetSimulationCraftMinimap(value)
    if LibDBIcon then
        if value then
            LibDBIcon:Show("SimulationCraft")
        else
            LibDBIcon:Hide("SimulationCraft")
        end
        
    end
end

function Module:PLAYER_ENTERING_WORLD()
    if Module:GetConfig("simulationcraft.forceHideMinimap") then
        Module.SetSimulationCraftMinimap(false)
    end
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

Module:RegisterEvent("PLAYER_ENTERING_WORLD")
