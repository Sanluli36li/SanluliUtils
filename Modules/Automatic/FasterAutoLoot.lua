local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("automatic.fasterAutoLoot")
local L = SanluliUtils.Locale

local CONFIG_ENABLE = "enable"

local CVAR_AUTO_LOOT = "autoLootDefault"
local BINDING_AUTO_LOOT = "AUTOLOOTTOGGLE"

function Module:LOOT_OPENED(...)
    -- Faster Auto Loot
    -- Source: https://www.curseforge.com/wow/addons/auto-loot-plus by mjbmitch
    if self:GetConfig(CONFIG_ENABLE) then
        -- Check if auto loot is enabled xor its activation key is pressed
        if GetCVarBool(CVAR_AUTO_LOOT) ~= IsModifiedClick(BINDING_AUTO_LOOT) then
            -- Work backwards toward the built-in auto loot iterator
            for i = GetNumLootItems(), 1, -1 do
                if LootSlotHasItem(i) then
                    LootSlot(i)
                end
            end
        end
    end
end
Module:RegisterEvent("LOOT_OPENED")