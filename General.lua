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

function Module:MERCHANT_SHOW()
    -- Auto Repair
    -- by Sanluli36li
    if Module:GetConfig(CONFIG_AUTO_REPAIR) then
        if (CanMerchantRepair()) then
            local cost = GetRepairAllCost()
            if cost > 0 then
                if (Module:GetConfig(CONFIG_AUTO_REPAIR_FUNDS) == CONFIG_AUTO_REPAIR_FUNDS_GUILD and CanGuildBankRepair() and GetGuildBankWithdrawMoney() + GetMoney() >= cost) then
                    if (GetGuildBankWithdrawMoney() >= cost) then
                        -- 公修充足，使用公会资金
                        RepairAllItems(true)
                        SanluliUtils:Print(L["general.autoRepair.message.repaired"]:format("|cffffffff"..generateMoneyText(cost).."|r("..L["general.autoRepair.message.guild"]..")"))
                    elseif (GetGuildBankWithdrawMoney() == 0) then
                        -- 公修耗尽，使用个人资金并提示公修耗尽
                        RepairAllItems(false)
                        SanluliUtils:Print(L["general.autoRepair.message.repaired"]:format("|cffffffff"..generateMoneyText(cost).."|r"))
                        SanluliUtils:Print(L["general.autoRepair.message.guildExhausted"])
                    else
                        -- 公修不足，使用公会资金和个人资金修理并提示公修耗尽
                        local guildMoney = GetGuildBankWithdrawMoney()
                        RepairAllItems(true)
                        SanluliUtils:Print(L["general.autoRepair.message.repaired"]:format("|cffffffff"..generateMoneyText(guildMoney).."|r("..L["general.autoRepair.message.guild"]..")"))
                        SanluliUtils:Print(L["general.autoRepair.message.repaired"]:format("|cffffffff"..generateMoneyText(cost - guildMoney).."|r"))
                        SanluliUtils:Print(L["general.autoRepair.message.guildExhausted"])
                    end
                elseif (GetMoney() >= cost) then
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

    -- Auto Sell Junk
    -- by Sanluli36li
    if (Module:GetConfig(CONFIG_AUTO_SELL_JUNK)) then
        local npcId = select(6, strsplit("-", UnitGUID("npc")))
        -- 排除自动铁锤
        if (C_MerchantFrame.IsSellAllJunkEnabled() and npcId and not HAMMER_MERCHANTS[npcId]) then
            local sold = 0
            local totalPrice = 0

            for bagId = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
                if (sold >= 12 and Module:GetConfig(CONFIG_AUTO_SELL_JUNK_METHOD) == CONFIG_AUTO_SELL_JUNK_METHOD_12_ITEMS) then
                    break
                end

                -- 跳过定义为忽略出售垃圾的背包
                if (not C_Container.GetBagSlotFlag(bagId, 64)) then

                    for slot = 0, C_Container.GetContainerNumSlots(bagId) do
                        -- 仅售出12件物品，保证可以回购，防止误售
                        if (sold >= 12 and Module:GetConfig(CONFIG_AUTO_SELL_JUNK_METHOD) == CONFIG_AUTO_SELL_JUNK_METHOD_12_ITEMS) then
                            break
                        end

                        local itemInfo = C_Container.GetContainerItemInfo(bagId, slot)
                        if (itemInfo and not itemInfo.isLocked) then
                            if (itemInfo.quality == Enum.ItemQuality.Poor and not itemInfo.hasNoValue) then
                                local price = itemInfo.stackCount * select(11, GetItemInfo(itemInfo.hyperlink))

                                if (not Module:GetConfig(CONFIG_AUTO_SELL_JUNK_METHOD) == CONFIG_AUTO_SELL_JUNK_METHOD_BLIZZARD) then
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

            if (Module:GetConfig(CONFIG_AUTO_SELL_JUNK_METHOD) == CONFIG_AUTO_SELL_JUNK_METHOD_BLIZZARD) then
                -- 使用暴雪内置出售所有垃圾方法
                C_MerchantFrame.SellAllJunkItems()
            end
            if totalPrice > 0 then
                SanluliUtils:Print(L["general.autoSellJunk.message.sold"]:format(sold, "|cffffffff"..generateMoneyText(totalPrice).."|r"))
            end
        end
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
