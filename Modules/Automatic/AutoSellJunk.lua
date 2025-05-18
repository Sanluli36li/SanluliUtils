local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("automatic.autoSellJunk")
local L = SanluliUtils.Locale

local CONFIG_ENABLE = "enable"
local CONFIG_METHOD = "method"
local CONFIG_METHOD_12_ITEMS = 1
local CONFIG_METHOD_ALL_ITEMS = 2
local CONFIG_METHOD_BLIZZARD = 3

local HAMMER_MERCHANTS = {
    ["100995"] = true,    -- 自动铁锤
    ["113831"] = true,    -- 自动铁锤(里弗斯)
}

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
            SanluliUtils:Print(L["automatic.autoSellJunk.message.sold"]:format(sold, "|cffffffff"..generateMoneyText(totalPrice).."|r"))
        end
    end
end

function Module:MERCHANT_SHOW()
    if (self:GetConfig(CONFIG_ENABLE)) then
        SellJunkItems(
            self:GetConfig(CONFIG_METHOD) == CONFIG_METHOD_BLIZZARD,
            self:GetConfig(CONFIG_METHOD) == CONFIG_METHOD_ALL_ITEMS or self:GetConfig(CONFIG_METHOD) == CONFIG_METHOD_BLIZZARD
        )
    end
end
Module:RegisterEvent("MERCHANT_SHOW")