local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("general")
local L = SanluliUtils.Locale

local CONFIG_AUTO_INPUT_CONFIRM = "autoInputConfirm.enable"
local CONFIG_AUTO_REPAIR = "autoRepair.enable"
local CONFIG_AUTO_REPAIR_FUNDS = "general.autoRepair.funds"
local CONFIG_AUTO_REPAIR_FUNDS_PERSONAL = 1
local CONFIG_AUTO_REPAIR_FUNDS_GUILD = 2
local CONFIG_AUTO_SELL_JUNK = "autoSellJunk.enable"
local CONFIG_AUTO_SELL_JUNK_METHOD = "autoSellJunk.method"
local CONFIG_AUTO_SELL_JUNK_METHOD_12_ITEMS = 1
local CONFIG_AUTO_SELL_JUNK_METHOD_ALL_ITEMS = 2
local CONFIG_AUTO_SELL_JUNK_METHOD_BLIZZARD = 3
local CONFIG_FASTER_AUTO_LOOT = "fasterAutoLoot.enable"
local CONFIG_CHAT_TYPE_TAB_SWITCH = "chatTypeTabSwitch.enable"

local CVAR_AUTO_LOOT = "autoLootDefault"

local BINDING_AUTO_LOOT = "AUTOLOOTTOGGLE"

local TEXT_MONEY_GOLD_SLIVER_COPPER = "%d|Tinterface/moneyframe/ui-goldicon:0|t%d|Tinterface/moneyframe/ui-silvericon:0|t%d|Tinterface/moneyframe/ui-coppericon:0|t"
local TEXT_MONEY_SLIVER_COPPER = "%d|Tinterface/moneyframe/ui-silvericon:0|t%d|Tinterface/moneyframe/ui-coppericon:0|t"
local TEXT_MONEY_COPPER = "%d|Tinterface/moneyframe/ui-coppericon:0|t"

local HAMMER_MERCHANTS = {
    [100995] = true,    -- 自动铁锤
    [113831] = true,    -- 自动铁锤(里弗斯)
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

function Module:MERCHANT_SHOW()
    if Module:GetConfig(CONFIG_AUTO_REPAIR) then
        RepairItems(Module:GetConfig(CONFIG_AUTO_REPAIR_FUNDS) == CONFIG_AUTO_REPAIR_FUNDS_GUILD)
    end

    if (Module:GetConfig(CONFIG_AUTO_SELL_JUNK)) then
        SellJunkItems(
            Module:GetConfig(CONFIG_AUTO_SELL_JUNK_METHOD) == CONFIG_AUTO_SELL_JUNK_METHOD_BLIZZARD,
            Module:GetConfig(CONFIG_AUTO_SELL_JUNK_METHOD) == CONFIG_AUTO_SELL_JUNK_METHOD_ALL_ITEMS or Module:GetConfig(CONFIG_AUTO_SELL_JUNK_METHOD) == CONFIG_AUTO_SELL_JUNK_METHOD_BLIZZARD
        )
    end
end
Module:RegisterEvent("MERCHANT_SHOW")

function Module:LOOT_OPENED(...)
    -- Faster Auto Loot
    -- Source: https://www.curseforge.com/wow/addons/auto-loot-plus by mjbmitch
    if Module:GetConfig(CONFIG_FASTER_AUTO_LOOT) then
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

local CONFIRM_STRINGS = {
    ["CONFIRM_AZERITE_EMPOWERED_RESPEC_EXPENSIVE"] = CONFIRM_AZERITE_EMPOWERED_RESPEC_STRING,   -- BfA 特质装高价重铸
    ["DELETE_GOOD_ITEM"] = DELETE_ITEM_CONFIRM_STRING,                                          -- 删除物品
    ["DELETE_GOOD_QUEST_ITEM"] = DELETE_ITEM_CONFIRM_STRING,                                    -- 删除任务物品
    ["CONFIRM_DESTROY_COMMUNITY"] = COMMUNITIES_DELETE_CONFIRM_STRING,                          -- 删除社区
    ["UNLEARN_SKILL"] = UNLEARN_SKILL_CONFIRMATION,                                             -- 忘却专业
    ["CONFIRM_RAF_REMOVE_RECRUIT"] = REMOVE_RECRUIT_CONFIRM_STRING,                             -- 移除战友招募
}

for dialogName, confirmString in pairs(CONFIRM_STRINGS) do
    hooksecurefunc(StaticPopupDialogs[dialogName], "OnShow", function(self)
        -- 自动输入DELETE
        if Module:GetConfig(CONFIG_AUTO_INPUT_CONFIRM) then
            self.editBox:SetText(confirmString)
        end
    end)
end

local CHAT_TYPE_ID = {
    SAY = 1,
    PARTY = 2,
    RAID = 3,
    INSTANCE_CHAT = 4,
    GUILD = 5,
    OFFICER = 6
}

local CHAT_TYPES = {
    [CHAT_TYPE_ID.SAY] = {              -- 说 (总是使用)
        type = "SAY"
    },
    [CHAT_TYPE_ID.PARTY] = {            -- 小队 (在小队中，且不在团队中(非随机副本队伍))
        type = "PARTY",
        isEnable = function() return IsInGroup(LE_PARTY_CATEGORY_HOME) and not IsInRaid(LE_PARTY_CATEGORY_HOME) end
    },
    [CHAT_TYPE_ID.RAID] = {             -- 团队 (在团队中(非随机副本队伍))
        type = "RAID",
        isEnable = function()
            return IsInRaid(LE_PARTY_CATEGORY_HOME)
        end
    },
    [CHAT_TYPE_ID.INSTANCE_CHAT] = {    -- 副本 (在副本队伍中)
        type = "INSTANCE_CHAT",
        isEnable = function ()
            return IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
        end
    },
    [CHAT_TYPE_ID.GUILD] = {            -- 公会 (在公会中)
        type = "GUILD",
        isEnable = function()
            return IsInGuild()
        end
    },
    [CHAT_TYPE_ID.OFFICER] = {          -- 官员 (是公会官员)
        type = "OFFICER",
        isEnable = function ()
            return C_GuildInfo.IsGuildOfficer()
        end
    }
}

local lastChatType = 1

local function TrySetChatType(editBox, id)
    if CHAT_TYPES[id] and (CHAT_TYPES[id].isEnable and CHAT_TYPES[id].isEnable()) or not CHAT_TYPES[id].isEnable then
        editBox:SetAttribute("chatType", CHAT_TYPES[id].type)
        ChatEdit_UpdateHeader(editBox)
        return true
    else
        return false
    end
end

hooksecurefunc("ChatEdit_OnTabPressed", function(editBox)
    if Module:GetConfig(CONFIG_CHAT_TYPE_TAB_SWITCH) and editBox == ChatFrame1EditBox then
        if not (strsub(editBox:GetText(), 1, 1) == "/") then    -- "/"开头命令自动补全时不执行
            -- print("Current: ", editBox:GetAttribute("chatType"), CHAT_TYPE_ID[editBox:GetAttribute("chatType")])
            local currentId = CHAT_TYPE_ID[editBox:GetAttribute("chatType")] or 0

            if currentId == 0 then  -- 非循环表中的情况 切换上次TAB切换到的频道, 或切换为“说”
                return TrySetChatType(editBox, lastChatType) or TrySetChatType(editBox, 1)
            else
                local nextId = ((currentId >= #CHAT_TYPES) and 1) or currentId + 1
                while true do
                    if nextId == currentId then -- 循环一圈没有找到下一个, 跳出
                        break
                    elseif TrySetChatType(editBox, nextId) then -- 尝试设置下一个
                        lastChatType = nextId
                        return
                    else                                        -- 下一个不满足条件
                        nextId = ((nextId >= #CHAT_TYPES) and 1) or (nextId + 1)
                    end
                end
            end
        end
    end
end)
