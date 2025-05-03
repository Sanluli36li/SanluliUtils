local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("automatic.autoCombatlog")
local L = SanluliUtils.Locale

local CONFIG_ENABLE = "enable"
local CONFIG_RAID = "raid"
local CONFIG_RAID_DIFFICULTY = "raid.difficulty"
local CONFIG_RAID_DIFFICULTY_LFR = 1
local CONFIG_RAID_DIFFICULTY_NORMAL = 2
local CONFIG_RAID_DIFFICULTY_HEROIC = 3
local CONFIG_RAID_DIFFICULTY_MYTHIC = 4
local CONFIG_DUNGEON = "dungeon"
local CONFIG_DUNGEON_DIFFICULTY = "dungeon.difficulty"
local CONFIG_DUNGEON_DIFFICULTY_HEROIC = 2
local CONFIG_DUNGEON_DIFFICULTY_MYTHIC = 3
local CONFIG_DUNGEON_DIFFICULTY_MYTHIC_PLUS = 4

local function ToggleCombatlog(force)
    if type(force) == "boolean" then
        if LoggingCombat() ~= force then
            LoggingCombat(force)
            SanluliUtils:Print((force and COMBATLOGENABLED) or COMBATLOGDISABLED)
        end
        return
    end

    local _, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
    local _, groupType, isHeroic, isChallengeMode, displayHeroic, displayMythic, toggleDifficultyID = GetDifficultyInfo(difficultyID)
    local legacyLoot = C_Loot.IsLegacyLootModeEnabled()

    if not legacyLoot and ((
        Module:GetConfig(CONFIG_RAID) and instanceType == "raid" and (               -- 团队副本
            Module:GetConfig(CONFIG_RAID_DIFFICULTY) <= (
                (displayMythic and CONFIG_RAID_DIFFICULTY_MYTHIC) or                 -- 史诗
                ((displayHeroic or isHeroic) and CONFIG_RAID_DIFFICULTY_HEROIC) or   -- 英雄
                (difficultyID == 17 and CONFIG_RAID_DIFFICULTY_LFR) or               -- 团队查找器
                CONFIG_RAID_DIFFICULTY_NORMAL                                        -- 普通难度
            )
        )
    ) or (
        Module:GetConfig(CONFIG_DUNGEON) and instanceType == "party" and (           -- 地下城
            Module:GetConfig(CONFIG_DUNGEON_DIFFICULTY) <= (
                (isChallengeMode and CONFIG_DUNGEON_DIFFICULTY_MYTHIC_PLUS) or       -- 史诗钥石
                (displayMythic and CONFIG_DUNGEON_DIFFICULTY_MYTHIC) or              -- 史诗难度
                (isHeroic and CONFIG_DUNGEON_DIFFICULTY_HEROIC) or                   -- 英雄难度
                1
            )
        )
    ))
    then
        if not LoggingCombat() then
            LoggingCombat(true)
            SanluliUtils:Print(COMBATLOGENABLED)
        end
    else
        if LoggingCombat() then
            LoggingCombat(false)
            SanluliUtils:Print(COMBATLOGDISABLED)
        end
    end
end

function Module:UPDATE_INSTANCE_INFO()
    if Module:GetConfig(CONFIG_ENABLE) then
        ToggleCombatlog()
    end
end
Module:RegisterEvent("UPDATE_INSTANCE_INFO")

function Module:CHALLENGE_MODE_START()
    if Module:GetConfig(CONFIG_ENABLE) then
        ToggleCombatlog()
    end
end
Module:RegisterEvent("CHALLENGE_MODE_START")