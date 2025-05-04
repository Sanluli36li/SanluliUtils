local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("social.privacyMode")
local L = SanluliUtils.Locale

local CONFIG_HIDE_BATTLE_NET_TAG_SUFFIX = "hideBattleNetTagSuffix.enable"
local CONFIG_HIDE_BATTLE_NET_TAG_SUFFIX_METHOD = "hideBattleNetTagSuffix.method"
local CONFIG_HIDE_BATTLE_NET_FRIENDS_REAL_NAME = "hideBattleNetFriendsRealName.enable"

local BlizzardFunction = {  -- 暴雪原方法备份
    -- Interface\\AddOns\\Blizzard_SharedXML\\AccountUtil.lua
    BNet_GetBNetAccountName = _G["BNet_GetBNetAccountName"],
    -- Interface\\AddOns\\Blizzard_FriendsFrame\\Mainline\\FriendsFrame.lua
    FriendsFrame_ShowBNDropdown = _G["FriendsFrame_ShowBNDropdown"],
    -- Interface\\AddOns\\Blizzard_UIPanels_Game\\Shared\\SocialQueue.lua
    SocialQueueUtil_GetRelationshipInfo = _G["SocialQueueUtil_GetRelationshipInfo"]
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

-- 隐藏真实姓名: 好友列表/好友招募
BNet_GetBNetAccountName = function(accountInfo)
    if Module:GetConfig(CONFIG_HIDE_BATTLE_NET_FRIENDS_REAL_NAME) then
        return (accountInfo and BNet_GetTruncatedBattleTag(accountInfo.battleTag)) or nil
    else
        return BlizzardFunction.BNet_GetBNetAccountName(accountInfo)
    end
end

-- 隐藏真实姓名: 好友列表右键菜单
FriendsFrame_ShowBNDropdown = function(name, connected, lineID, chatType, chatFrame, friendsList, bnetIDAccount, communityClubID, communityStreamID, communityEpoch, communityPosition, battleTag)
    if Module:GetConfig(CONFIG_HIDE_BATTLE_NET_FRIENDS_REAL_NAME) then
        return BlizzardFunction.FriendsFrame_ShowBNDropdown(BNet_GetTruncatedBattleTag(battleTag), connected, lineID, chatType, chatFrame, friendsList, bnetIDAccount, communityClubID, communityStreamID, communityEpoch, communityPosition, battleTag)
    else
        return BlizzardFunction.FriendsFrame_ShowBNDropdown(name, connected, lineID, chatType, chatFrame, friendsList, bnetIDAccount, communityClubID, communityStreamID, communityEpoch, communityPosition, battleTag)
    end
    
end

-- 隐藏真实姓名: 好友列表/快速加入
SocialQueueUtil_GetRelationshipInfo = function(guid, missingNameFallback, clubId)
    if Module:GetConfig(CONFIG_HIDE_BATTLE_NET_FRIENDS_REAL_NAME) then
        local name, color, type, link = BlizzardFunction.SocialQueueUtil_GetRelationshipInfo(guid, missingNameFallback, clubId)
        if type == "bnfriend" then
            local accountInfo = C_BattleNet.GetAccountInfoByGUID(guid)
            if accountInfo then
                return BNet_GetTruncatedBattleTag(accountInfo.battleTag), color, type, link
            end
        end
        return name, color, type, link
    else
        return BlizzardFunction.SocialQueueUtil_GetRelationshipInfo(guid, missingNameFallback, clubId)
    end
end

-- 隐藏真实姓名: 聊天框表头
hooksecurefunc("ChatEdit_UpdateHeader", function(editBox)
    if Module:GetConfig(CONFIG_HIDE_BATTLE_NET_FRIENDS_REAL_NAME) then
        if editBox:GetAttribute("chatType") == "BN_WHISPER" then
            local tellTarget = editBox:GetAttribute("tellTarget")
            if tellTarget then
                local bnetIDAccount = BNet_GetBNetIDAccount(tellTarget)
                if bnetIDAccount then
                    local accountInfo = C_BattleNet.GetAccountInfoByID(bnetIDAccount)
                    if accountInfo then
                        local header = _G[editBox:GetName().."Header"]
                        local headerSuffix = _G[editBox:GetName().."HeaderSuffix"]
                        if not header then
                            return
                        end

                        header:SetFormattedText(CHAT_BN_WHISPER_SEND, BNet_GetTruncatedBattleTag(accountInfo.battleTag))

                        editBox:SetTextInsets(15 + header:GetWidth() + (headerSuffix:IsShown() and headerSuffix:GetWidth() or 0), 13, 0, 0)
                    end
                end
            end
        end
    end
end)

-- 隐藏战网昵称后缀
hooksecurefunc("FriendsFrame_CheckBattlenetStatus", function(self)
    if Module:GetConfig(CONFIG_HIDE_BATTLE_NET_TAG_SUFFIX) then
        Module:SetBattleTagHideStatus(Module:GetConfig(CONFIG_HIDE_BATTLE_NET_TAG_SUFFIX_METHOD))
    end
end)