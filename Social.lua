local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("social")
local L = SanluliUtils.Locale

-- 配置项目键名
local CONFIG_CHAT_TYPE_TAB_SWITCH = "chatTypeTabSwitch.enable"
local CONFIG_FRIEND_LIST_CHARACTER_NAME_CLASS_COLOR = "friendsList.characterNameClassColor.enable"
local CONFIG_FRIEND_LIST_HIDE_BATTLE_NET_TAG_SUFFIX = "friendsList.hideBattleNetTagSuffix.enable"
local CONFIG_FRIEND_LIST_HIDE_BATTLE_NET_TAG_SUFFIX_METHOD = "friendsList.hideBattleNetTagSuffix.method"
local CONFIG_FRIEND_LIST_HIDE_BATTLE_NET_FRIENDS_REAL_NAME = "friendsList.hideBattleNetFriendsRealName.enable"
local CONFIG_CHAT_BN_WHISPER_LINK = "chat.bnPlayerLink.enable"
local CONFIG_CHAT_BN_WHISPER_LINK_FORMAT = "chat.bnPlayerLink.format"

local BlizzardFunction = {  -- 暴雪原方法备份
    BNet_GetBNetAccountName = _G["BNet_GetBNetAccountName"],
    GetBNPlayerLink = _G["GetBNPlayerLink"]
}

local CLASSES_COLORS = {}   -- 职业颜色表

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

for i = 1, GetNumClasses(), 1 do
    local classNameLocalization, className, classId = GetClassInfo(i)
    CLASSES_COLORS[classNameLocalization] = "|c"..C_ClassColor.GetClassColor(className):GenerateHexColor()
end

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

local function GetAccountName(accountInfo, realName)
    if not accountInfo then
        return nil
    elseif realName then
        return BNet_GetBNetAccountName(accountInfo)
    else
        return BNet_GetTruncatedBattleTag(accountInfo.battleTag)
    end
end

local function ClassColoredText(text, className)
    if className and CLASSES_COLORS[className] then
        return CLASSES_COLORS[className]..text..FONT_COLOR_CODE_CLOSE
    else
        return text
    end
end

local function GetCharacterName(accountInfo, withRealmName, format, useClassColor)
    if not format then
        format = "%s"
    end
    if accountInfo then
        local characterName = BNet_GetValidatedCharacterName(accountInfo.gameAccountInfo.characterName, nil, accountInfo.gameAccountInfo.clientProgram)

        if withRealmName and accountInfo.gameAccountInfo.realmID and accountInfo.gameAccountInfo.realmID ~= GetRealmID() then
            characterName = characterName.."-"..accountInfo.gameAccountInfo.realmName
        end

        if characterName ~= "" then
            if useClassColor and accountInfo.gameAccountInfo.className and accountInfo.gameAccountInfo.clientProgram == BNET_CLIENT_WOW then
                return ClassColoredText(string.format(format, characterName), accountInfo.gameAccountInfo.className)
            else
                return string.format(format, characterName)
            end
        end
    end
end

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

--------------------
-- 暴雪函数安全钩子
--------------------

-- 聊天框体 Tab按钮按下
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

-- 好友列表 更新好友按钮
hooksecurefunc("FriendsFrame_UpdateFriendButton", function(button, elementData)
    if Module:GetConfig(CONFIG_FRIEND_LIST_CHARACTER_NAME_CLASS_COLOR) then
        local id = button.id
        if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
            -- 游戏好友
            local info = C_FriendList.GetFriendInfoByIndex(id)
            if info and info.name and info.className and info.level then
                button.name:SetText(ClassColoredText(info.name, info.className)..", "..format(FRIENDS_LEVEL_TEMPLATE, info.level, info.className))
            end
        elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET then
            -- 战网好友
            local accountInfo = C_BattleNet.GetFriendAccountInfo(id)
            if accountInfo then
                local nameText = BNet_GetBNetAccountName(accountInfo)
                local characterName

                if Module:GetConfig(CONFIG_FRIEND_LIST_CHARACTER_NAME_CLASS_COLOR) then
                    characterName = GetCharacterName(accountInfo, false, "(%s)", true)
                else
                    characterName = FRIENDS_OTHER_NAME_COLOR_CODE..GetCharacterName(accountInfo, false, "(%s)", false)..FONT_COLOR_CODE_CLOSE
                end

                if characterName then
                    button.name:SetText(nameText.." "..characterName)
                end
            end
        end
    end
end)

-- 好友列表 检查战网连接状态
hooksecurefunc("FriendsFrame_CheckBattlenetStatus", function(self)
    if Module:GetConfig(CONFIG_FRIEND_LIST_HIDE_BATTLE_NET_TAG_SUFFIX) then
        Module:SetBattleTagHideStatus(Module:GetConfig(CONFIG_FRIEND_LIST_HIDE_BATTLE_NET_TAG_SUFFIX_METHOD))
    end
end)

--------------------
-- 替换暴雪方法
--------------------

BNet_GetBNetAccountName = function(accountInfo)
    if Module:GetConfig(CONFIG_FRIEND_LIST_HIDE_BATTLE_NET_FRIENDS_REAL_NAME) then
        return (accountInfo and BNet_GetTruncatedBattleTag(accountInfo.battleTag)) or nil
    else
        return BlizzardFunction.BNet_GetBNetAccountName(accountInfo)
    end
end

GetBNPlayerLink = function(name, linkDisplayText, bnetIDAccount, lineID, chatType, chatTarget)
    if Module:GetConfig(CONFIG_CHAT_BN_WHISPER_LINK) then
        local accountInfo = C_BattleNet.GetAccountInfoByID(bnetIDAccount)
        local displayName

        if accountInfo then
            if Module:GetConfig(CONFIG_CHAT_BN_WHISPER_LINK_FORMAT) == 1 then
                displayName = GetAccountName(accountInfo, false)
            elseif Module:GetConfig(CONFIG_CHAT_BN_WHISPER_LINK_FORMAT) == 2 then
                displayName = ClassColoredText(GetAccountName(accountInfo, false), accountInfo.gameAccountInfo.realmName)
            elseif Module:GetConfig(CONFIG_CHAT_BN_WHISPER_LINK_FORMAT) == 3 then
                displayName = GetAccountName(accountInfo, false)..(GetCharacterName(accountInfo, false, "(%s)", true) or "")
            elseif Module:GetConfig(CONFIG_CHAT_BN_WHISPER_LINK_FORMAT) == 4 then
                displayName = GetAccountName(accountInfo, false)..(GetCharacterName(accountInfo, true, "(%s)", true) or "")
            elseif Module:GetConfig(CONFIG_CHAT_BN_WHISPER_LINK_FORMAT) == 5 then
                displayName = (GetCharacterName(accountInfo, false, "%s", true) or GetAccountName(accountInfo, false))
            elseif Module:GetConfig(CONFIG_CHAT_BN_WHISPER_LINK_FORMAT) == 6 then
                displayName = (GetCharacterName(accountInfo, true, "%s", true) or GetAccountName(accountInfo, false))
            end
    
            if displayName then
                linkDisplayText = string.gsub(linkDisplayText, name, displayName)
            end
        end
        
        return LinkUtil.FormatLink("BNplayer", linkDisplayText, name, bnetIDAccount, lineID or 0, chatType, chatTarget)
    else
        return BlizzardFunction.GetBNPlayerLink(name, linkDisplayText, bnetIDAccount, lineID, chatType, chatTarget)
    end
end

