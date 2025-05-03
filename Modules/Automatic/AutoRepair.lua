local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("automatic.autoRepair")
local L = SanluliUtils.Locale

local CONFIG_ENABLE = "enable"
local CONFIG_FUNDS = "funds"
local CONFIG_FUNDS_PERSONAL = 1
local CONFIG_FUNDS_GUILD = 2

local LOCALE_MESSAGE_REPAIRED = "general.autoRepair.message.repaired"
local LOCALE_MESSAGE_GUILD = "general.autoRepair.message.guild"
local LOCALE_MESSAGE_GUILD_EXHAUSTED = "general.autoRepair.message.guildExhausted"
local LOCALE_MESSAGE_OOM = "general.autoRepair.message.oom"

local TEXT_MONEY_GOLD_SLIVER_COPPER = "%d|Tinterface/moneyframe/ui-goldicon:0|t%d|Tinterface/moneyframe/ui-silvericon:0|t%d|Tinterface/moneyframe/ui-coppericon:0|t"
local TEXT_MONEY_SLIVER_COPPER = "%d|Tinterface/moneyframe/ui-silvericon:0|t%d|Tinterface/moneyframe/ui-coppericon:0|t"
local TEXT_MONEY_COPPER = "%d|Tinterface/moneyframe/ui-coppericon:0|t"

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
            local guildMoney = (GetGuildBankWithdrawMoney() == -1 and 9999999999) or GetGuildBankWithdrawMoney()
            if guildBankRepair and CanGuildBankRepair() and guildMoney + money >= cost then
                if guildMoney >= cost then
                    -- 公修充足，使用公会资金
                    RepairAllItems(true)
                    SanluliUtils:Print(L[LOCALE_MESSAGE_REPAIRED]:format("|cffffffff"..generateMoneyText(cost).."|r("..L[LOCALE_MESSAGE_GUILD]..")"))
                elseif guildMoney == 0 then
                    -- 公修耗尽，使用个人资金并提示公修耗尽
                    RepairAllItems(true)
                    SanluliUtils:Print(L[LOCALE_MESSAGE_REPAIRED]:format("|cffffffff"..generateMoneyText(cost).."|r"))
                    SanluliUtils:Print(L[LOCALE_MESSAGE_GUILD_EXHAUSTED])
                else
                    -- 公修不足，使用公会资金和个人资金修理并提示公修耗尽
                    RepairAllItems(true)
                    SanluliUtils:Print(L[LOCALE_MESSAGE_REPAIRED]:format("|cffffffff"..generateMoneyText(guildMoney).."|r("..L[LOCALE_MESSAGE_GUILD]..")"))
                    SanluliUtils:Print(L[LOCALE_MESSAGE_REPAIRED]:format("|cffffffff"..generateMoneyText(cost - guildMoney).."|r"))
                    SanluliUtils:Print(L[LOCALE_MESSAGE_GUILD_EXHAUSTED])
                end
            elseif money >= cost then
                -- 使用个人资金
                RepairAllItems(false)
                SanluliUtils:Print(L[LOCALE_MESSAGE_REPAIRED]:format("|cffffffff"..generateMoneyText(cost).."|r"))
            else
                RepairAllItems(false)
                -- 金钱不足，提示
                SanluliUtils:Print(L[LOCALE_MESSAGE_OOM]:format("|cffffffff"..generateMoneyText(cost).."|r"))
            end
        end
    end
end

function Module:MERCHANT_SHOW()
    if self:GetConfig(CONFIG_ENABLE) then
        RepairItems(self:GetConfig(CONFIG_FUNDS) == CONFIG_FUNDS_GUILD)
    end
end
Module:RegisterEvent("MERCHANT_SHOW")