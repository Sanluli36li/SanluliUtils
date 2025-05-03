local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("social.privacyMode")
local L = SanluliUtils.Locale

local CONFIG_HIDE_BATTLE_NET_TAG_SUFFIX = "hideBattleNetTagSuffix.enable"
local CONFIG_HIDE_BATTLE_NET_TAG_SUFFIX_METHOD = "hideBattleNetTagSuffix.method"
local CONFIG_HIDE_BATTLE_NET_FRIENDS_REAL_NAME = "hideBattleNetFriendsRealName.enable"

local BlizzardFunction = {  -- 暴雪原方法备份
    BNet_GetBNetAccountName = _G["BNet_GetBNetAccountName"]
}

function Module:SetBattleTagHideStatus(value)
    if value == 0 then
        local _, battleTag = BNGetInfo();
        if battleTag then
            local symbol = string.find(battleTag, "#")
            if symbol  then
                local suffix = string.sub(battleTag, symbol);
                battleTag = string.sub(battleTag, 1, symbol - 1).."|cff416380"..suffix.."|r";
            end
            FriendsFrameBattlenetFrame.Tag:SetText(battleTag)
        end
    elseif value == 1 then
        local _, battleTag = BNGetInfo();
        if battleTag then
            local symbol = string.find(battleTag, "#")
            if symbol then
                battleTag = string.sub(battleTag, 1, symbol - 1)
            end
            FriendsFrameBattlenetFrame.Tag:SetText(battleTag)
        end
    elseif value == 2 then
        local _, battleTag = BNGetInfo();
        if battleTag then
            local symbol = string.find(battleTag, "#")
            if symbol then
                battleTag = string.sub(battleTag, 1, symbol - 1).."|cff416380#0000|r"
            end
            FriendsFrameBattlenetFrame.Tag:SetText(battleTag)
        end
    end
end

-- 隐藏战网昵称后缀
hooksecurefunc("FriendsFrame_CheckBattlenetStatus", function(self)
    if Module:GetConfig(CONFIG_HIDE_BATTLE_NET_TAG_SUFFIX) then
        Module:SetBattleTagHideStatus(Module:GetConfig(CONFIG_HIDE_BATTLE_NET_TAG_SUFFIX_METHOD))
    end
end)

-- 
BNet_GetBNetAccountName = function(accountInfo)
    if Module:GetConfig(CONFIG_HIDE_BATTLE_NET_FRIENDS_REAL_NAME) then
        return (accountInfo and BNet_GetTruncatedBattleTag(accountInfo.battleTag)) or nil
    else
        return BlizzardFunction.BNet_GetBNetAccountName(accountInfo)
    end
end