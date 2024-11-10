local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("general")
local L = SanluliUtils.Locale

local CONFIG_AUTO_INPUT_CONFIRM = "autoInputConfirm.enable"
local CONFIG_AUTO_REPAIR = "autoRepair.enable"
local CONFIG_AUTO_REPAIR_FUNDS = "autoRepair.funds"
local CONFIG_AUTO_REPAIR_FUNDS_PERSONAL = 1
local CONFIG_AUTO_REPAIR_FUNDS_GUILD = 2
local CONFIG_AUTO_SELL_JUNK = "autoSellJunk.enable"
local CONFIG_AUTO_SELL_JUNK_METHOD = "autoSellJunk.method"
local CONFIG_AUTO_SELL_JUNK_METHOD_12_ITEMS = 1
local CONFIG_AUTO_SELL_JUNK_METHOD_ALL_ITEMS = 2
local CONFIG_AUTO_SELL_JUNK_METHOD_BLIZZARD = 3
local CONFIG_FASTER_AUTO_LOOT = "fasterAutoLoot.enable"
local CONFIG_AUTO_COMBATLOG = "autoCombatlog.enable"
local CONFIG_AUTO_COMBATLOG_RAID = "autoCombatlog.raid"
local CONFIG_AUTO_COMBATLOG_RAID_DIFFICULTY = "autoCombatlog.raid.difficulty"
local CONFIG_AUTO_COMBATLOG_RAID_DIFFICULTY_LFR = 1
local CONFIG_AUTO_COMBATLOG_RAID_DIFFICULTY_NORMAL = 2
local CONFIG_AUTO_COMBATLOG_RAID_DIFFICULTY_HEROIC = 3
local CONFIG_AUTO_COMBATLOG_RAID_DIFFICULTY_MYTHIC = 4
local CONFIG_AUTO_COMBATLOG_DUNGEON = "autoCombatlog.dungeon"
local CONFIG_AUTO_COMBATLOG_DUNGEON_DIFFICULTY = "autoCombatlog.dungeon.difficulty"
local CONFIG_AUTO_COMBATLOG_DUNGEON_DIFFICULTY_HEROIC = 2
local CONFIG_AUTO_COMBATLOG_DUNGEON_DIFFICULTY_MYTHIC = 3
local CONFIG_AUTO_COMBATLOG_DUNGEON_DIFFICULTY_MYTHIC_PLUS = 4

local DIFFICULTY = {
    
}

local CVAR_AUTO_LOOT = "autoLootDefault"
local BINDING_AUTO_LOOT = "AUTOLOOTTOGGLE"

local TEXT_MONEY_GOLD_SLIVER_COPPER = "%d|Tinterface/moneyframe/ui-goldicon:0|t%d|Tinterface/moneyframe/ui-silvericon:0|t%d|Tinterface/moneyframe/ui-coppericon:0|t"
local TEXT_MONEY_SLIVER_COPPER = "%d|Tinterface/moneyframe/ui-silvericon:0|t%d|Tinterface/moneyframe/ui-coppericon:0|t"
local TEXT_MONEY_COPPER = "%d|Tinterface/moneyframe/ui-coppericon:0|t"

local HAMMER_MERCHANTS = {
    ["100995"] = true,    -- 自动铁锤
    ["113831"] = true,    -- 自动铁锤(里弗斯)
}

local CONFIRM_STRINGS = {
    ["CONFIRM_AZERITE_EMPOWERED_RESPEC_EXPENSIVE"] = CONFIRM_AZERITE_EMPOWERED_RESPEC_STRING,   -- BfA 特质装高价重铸
    ["DELETE_GOOD_ITEM"] = DELETE_ITEM_CONFIRM_STRING,                                          -- 删除物品
    ["DELETE_GOOD_QUEST_ITEM"] = DELETE_ITEM_CONFIRM_STRING,                                    -- 删除任务物品
    ["CONFIRM_DESTROY_COMMUNITY"] = COMMUNITIES_DELETE_CONFIRM_STRING,                          -- 删除社区
    ["UNLEARN_SKILL"] = UNLEARN_SKILL_CONFIRMATION,                                             -- 忘却专业
    ["CONFIRM_RAF_REMOVE_RECRUIT"] = REMOVE_RECRUIT_CONFIRM_STRING,                             -- 移除战友招募
}

local function generateMoneyText(copper)
    if copper >= 10000 then
        return (TEXT_MONEY_GOLD_SLIVER_COPPER):format(copper / 100 / 100, (copper / 100) % 100, copper % 100)
    elseif copper >= 100 then
        return (TEXT_MONEY_SLIVER_COPPER):format((copper / 100) % 100, copper % 100)
    else
        return (TEXT_MONEY_COPPER):format(copper % 100)
    end
end

local function RepairItems(guildBankRepair)
    if CanMerchantRepair() then
        local cost = GetRepairAllCost()
        if cost > 0 then
            local money = GetMoney()
            local guildMoney = GetGuildBankWithdrawMoney()
            if guildBankRepair and CanGuildBankRepair() and guildMoney + money >= cost then
                if guildMoney >= cost then
                    -- 公修充足，使用公会资金
                    RepairAllItems(true)
                    SanluliUtils:Print(L["general.autoRepair.message.repaired"]:format("|cffffffff"..generateMoneyText(cost).."|r("..L["general.autoRepair.message.guild"]..")"))
                elseif guildMoney == 0 then
                    -- 公修耗尽，使用个人资金并提示公修耗尽
                    RepairAllItems(false)
                    SanluliUtils:Print(L["general.autoRepair.message.repaired"]:format("|cffffffff"..generateMoneyText(cost).."|r"))
                    SanluliUtils:Print(L["general.autoRepair.message.guildExhausted"])
                else
                    -- 公修不足，使用公会资金和个人资金修理并提示公修耗尽
                    RepairAllItems(true)
                    SanluliUtils:Print(L["general.autoRepair.message.repaired"]:format("|cffffffff"..generateMoneyText(guildMoney).."|r("..L["general.autoRepair.message.guild"]..")"))
                    SanluliUtils:Print(L["general.autoRepair.message.repaired"]:format("|cffffffff"..generateMoneyText(cost - guildMoney).."|r"))
                    SanluliUtils:Print(L["general.autoRepair.message.guildExhausted"])
                end
            elseif money >= cost then
                -- 使用个人资金
                RepairAllItems(false)
                SanluliUtils:Print(L["general.autoRepair.message.repaired"]:format("|cffffffff"..generateMoneyText(cost).."|r"))
            else
                -- 金钱不足，提示
                SanluliUtils:Print(L["general.autoRepair.message.oom"]:format("|cffffffff"..generateMoneyText(cost).."|r"))
            end
        end
    end
end

local function SellJunkItems(blizzardMethod, sellAllItems)
    local npcId = select(6, strsplit("-", UnitGUID("npc")))
    -- 排除自动铁锤
    if (C_MerchantFrame.IsSellAllJunkEnabled() and npcId and not HAMMER_MERCHANTS[npcId]) then
        local sold = 0
        local totalPrice = 0

        for bagId = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
            if sold >= 12 and (not blizzardMethod) and (not sellAllItems) then
                break
            end

            -- 跳过定义为忽略出售垃圾的背包
            if (not C_Container.GetBagSlotFlag(bagId, 64)) then

                for slot = 0, C_Container.GetContainerNumSlots(bagId) do
                    -- 仅售出12件物品，保证可以回购，防止误售
                    if sold >= 12 and (not blizzardMethod) and (not sellAllItems) then
                        break
                    end

                    local itemInfo = C_Container.GetContainerItemInfo(bagId, slot)
                    if (itemInfo and not itemInfo.isLocked) then
                        if (itemInfo.quality == Enum.ItemQuality.Poor and not itemInfo.hasNoValue) then
                            local price = itemInfo.stackCount * select(11, GetItemInfo(itemInfo.hyperlink))
                            if not blizzardMethod then
                                -- 使用右键方式出售物品
                                C_Container.UseContainerItem(bagId, slot)
                            end

                            -- 统计物品数量和价值
                            totalPrice = totalPrice + price
                            sold = sold + 1
                        end
                    end
                end
            end
        end

        if blizzardMethod then
            -- 使用暴雪内置出售所有垃圾方法
            C_MerchantFrame.SellAllJunkItems()
        end
        if totalPrice > 0 then
            SanluliUtils:Print(L["general.autoSellJunk.message.sold"]:format(sold, "|cffffffff"..generateMoneyText(totalPrice).."|r"))
        end
    end
end

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

local function toggleCombatlog(force)
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
        Module:GetConfig(CONFIG_AUTO_COMBATLOG_RAID) and instanceType == "raid" and (               -- 团队副本
            Module:GetConfig(CONFIG_AUTO_COMBATLOG_RAID_DIFFICULTY) <= (
                (displayMythic and CONFIG_AUTO_COMBATLOG_RAID_DIFFICULTY_MYTHIC) or                 -- 史诗
                ((displayHeroic or isHeroic) and CONFIG_AUTO_COMBATLOG_RAID_DIFFICULTY_HEROIC) or   -- 英雄
                (difficultyID == 17 and CONFIG_AUTO_COMBATLOG_RAID_DIFFICULTY_LFR) or               -- 团队查找器
                CONFIG_AUTO_COMBATLOG_RAID_DIFFICULTY_NORMAL                                        -- 普通难度
            )
        )
    ) or (
        Module:GetConfig(CONFIG_AUTO_COMBATLOG_DUNGEON) and instanceType == "party" and (           -- 地下城
            Module:GetConfig(CONFIG_AUTO_COMBATLOG_DUNGEON_DIFFICULTY) <= (
                (isChallengeMode and CONFIG_AUTO_COMBATLOG_DUNGEON_DIFFICULTY_MYTHIC_PLUS) or       -- 史诗钥石
                (displayMythic and CONFIG_AUTO_COMBATLOG_DUNGEON_DIFFICULTY_MYTHIC) or              -- 史诗难度
                (isHeroic and CONFIG_AUTO_COMBATLOG_DUNGEON_DIFFICULTY_HEROIC) or                   -- 英雄难度
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

--------------------
-- 暴雪函数安全钩子
--------------------

-- 提示框 显示
for dialogName, confirmString in pairs(CONFIRM_STRINGS) do
    hooksecurefunc(StaticPopupDialogs[dialogName], "OnShow", function(self)
        -- 自动输入DELETE
        if Module:GetConfig(CONFIG_AUTO_INPUT_CONFIRM) then
            self.editBox:SetText(confirmString)
        end
    end)
end

--------------------
-- 事件处理
--------------------

function Module:MERCHANT_SHOW()
    if self:GetConfig(CONFIG_AUTO_REPAIR) then
        RepairItems(self:GetConfig(CONFIG_AUTO_REPAIR_FUNDS) == CONFIG_AUTO_REPAIR_FUNDS_GUILD)
    end

    if (self:GetConfig(CONFIG_AUTO_SELL_JUNK)) then
        SellJunkItems(
            self:GetConfig(CONFIG_AUTO_SELL_JUNK_METHOD) == CONFIG_AUTO_SELL_JUNK_METHOD_BLIZZARD,
            self:GetConfig(CONFIG_AUTO_SELL_JUNK_METHOD) == CONFIG_AUTO_SELL_JUNK_METHOD_ALL_ITEMS or self:GetConfig(CONFIG_AUTO_SELL_JUNK_METHOD) == CONFIG_AUTO_SELL_JUNK_METHOD_BLIZZARD
        )
    end
end
Module:RegisterEvent("MERCHANT_SHOW")

function Module:LOOT_OPENED(...)
    -- Faster Auto Loot
    -- Source: https://www.curseforge.com/wow/addons/auto-loot-plus by mjbmitch
    if self:GetConfig(CONFIG_FASTER_AUTO_LOOT) then
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

function Module:START_LOOT_ROLL(rollID, rollTime, lootHandle)
    if Module:GetConfig("autoRoll.enable") then
        local texture, name, count, quality, bindOnPickUp, canNeed, canGreed, canDisenchant, reasonNeed, reasonGreed, reasonDisenchant, deSkillRequired, canTransmog = GetLootRollItemInfo(rollID)
        local itemLink = GetLootRollItemLink(rollID)

        if not canNeed then
            local reasonText = ""
            if _G["LOOT_ROLL_INELIGIBLE_REASON"..reasonNeed] then
                reasonText = "(".._G["LOOT_ROLL_INELIGIBLE_REASON"..reasonNeed]..")"
            end

            if Module:GetConfig("autoRoll.method") == 1 then
                if canTransmog then
                    removeWaitingRolls(rollID)
                    RollOnLoot(rollID, 4)   -- 幻化
                    SanluliUtils:Print(L["general.autoRoll.message.transmog"]:format(itemLink)..reasonText)
                elseif canGreed then
                    removeWaitingRolls(rollID)
                    RollOnLoot(rollID, 2)   -- 贪婪
                    SanluliUtils:Print(L["general.autoRoll.message.greed"]:format(itemLink)..reasonText)
                end
            else
                removeWaitingRolls(rollID)
                RollOnLoot(rollID, 0)       -- 放弃
                SanluliUtils:Print(L["general.autoRoll.message.pass"]:format(itemLink)..reasonText)
            end
        end
    end
end
Module:RegisterEvent("START_LOOT_ROLL")

function Module:UPDATE_INSTANCE_INFO()
    if Module:GetConfig(CONFIG_AUTO_COMBATLOG) then
        toggleCombatlog()
    end
end
Module:RegisterEvent("UPDATE_INSTANCE_INFO")

function Module:CHALLENGE_MODE_START()
    if Module:GetConfig(CONFIG_AUTO_COMBATLOG) then
        toggleCombatlog()
    end
end
Module:RegisterEvent("CHALLENGE_MODE_START")


