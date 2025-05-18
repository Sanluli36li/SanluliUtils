local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("automatic.autoRoll")
local L = SanluliUtils.Locale

local STRING_LOOT_ROLL_INELIGIBLE_REASON_AFFIX = "LOOT_ROLL_INELIGIBLE_REASON"

local CONFIG_ENABLE = "enable"
local CONFIG_METHOD = "method"

local LOCALE_MESSAGE_TRANSMOG = "automatic.autoRoll.message.transmog"
local LOCALE_MESSAGE_GREED = "automatic.autoRoll.message.greed"
local LOCALE_MESSAGE_PASS = "automatic.autoRoll.message.pass"

local function removeWaitingRolls(rollID)
    local waitingRolls = GroupLootContainer.waitingRolls
    if #waitingRolls > 0 then
        for i = #waitingRolls, 1 ,-1 do
            if waitingRolls[i].rollID == rollID then
                table.remove(waitingRolls, i)
            end
        end
    end
end

local function HandleLootRoll(rollID)
    if Module:GetConfig(CONFIG_ENABLE) then
        local texture, name, count, quality, bindOnPickUp, canNeed, canGreed, canDisenchant, reasonNeed, reasonGreed, reasonDisenchant, deSkillRequired, canTransmog = GetLootRollItemInfo(rollID)
        local itemLink = GetLootRollItemLink(rollID)

        if not canNeed then
            local reasonText = ""
            if _G[STRING_LOOT_ROLL_INELIGIBLE_REASON_AFFIX..reasonNeed] then
                reasonText = "(".._G[STRING_LOOT_ROLL_INELIGIBLE_REASON_AFFIX..reasonNeed]..")"
            end

            if Module:GetConfig(CONFIG_METHOD) == 1 then
                if canTransmog then
                    removeWaitingRolls(rollID)
                    RollOnLoot(rollID, 4)   -- 幻化
                    SanluliUtils:Print(L[LOCALE_MESSAGE_TRANSMOG]:format(itemLink)..reasonText)
                elseif canGreed then
                    removeWaitingRolls(rollID)
                    RollOnLoot(rollID, 2)   -- 贪婪
                    SanluliUtils:Print(L[LOCALE_MESSAGE_GREED]:format(itemLink)..reasonText)
                end
            else
                removeWaitingRolls(rollID)
                RollOnLoot(rollID, 0)       -- 放弃
                SanluliUtils:Print(L[LOCALE_MESSAGE_PASS]:format(itemLink)..reasonText)
            end
        end
    end
end

function Module:START_LOOT_ROLL(rollID, rollTime, lootHandle)
    if Module:GetConfig(CONFIG_ENABLE) then
        HandleLootRoll(rollID)
    end
end
Module:RegisterEvent("START_LOOT_ROLL")