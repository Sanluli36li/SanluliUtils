local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("social")
local L = SanluliUtils.Locale

local CONFIG_CHAT_TYPE_TAB_SWITCH = "chatTypeTabSwitch.enable"
local CONFIG_FRIEND_LIST_CHARACTER_NAME_CLASS_COLOR = "friendsList.characterNameClassColor.enable"
local CONFIG_FRIEND_LIST_HIDE_BATTLE_NET_TAG_SUFFIX = "friendsList.hideBattleNetTagSuffix.enable"
local CONFIG_FRIEND_LIST_HIDE_BATTLE_NET_TAG_SUFFIX_METHOD = "friendsList.hideBattleNetTagSuffix.method"
local CONFIG_FRIEND_LIST_HIDE_BATTLE_NET_FRIENDS_REAL_NAME = "friendsList.hideBattleNetFriendsRealName.enable"

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

local CLASSES_COLORS = {}

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

hooksecurefunc("FriendsFrame_UpdateFriendButton", function(button, elementData)
    if Module:GetConfig(CONFIG_FRIEND_LIST_CHARACTER_NAME_CLASS_COLOR) then
        local id = button.id
        if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
            local info = C_FriendList.GetFriendInfoByIndex(id)
            if info and info.name and info.className and CLASSES_COLORS[info.className] and info.level then
                button.name:SetText(CLASSES_COLORS[info.className]..info.name.."|r"..", "..format(FRIENDS_LEVEL_TEMPLATE, info.level, info.className))
            end
        elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET then
            local accountInfo = C_BattleNet.GetFriendAccountInfo(id)
            if accountInfo then
                local nameText = BNet_GetBNetAccountName(accountInfo)
                local characterName = FriendsFrame_GetFormattedCharacterName(accountInfo.gameAccountInfo.characterName, nil, accountInfo.gameAccountInfo.clientProgram, accountInfo.gameAccountInfo.timerunningSeasonID)

                if characterName ~= "" and accountInfo.gameAccountInfo.className then
                    local classColor = accountInfo.gameAccountInfo.className and CLASSES_COLORS[accountInfo.gameAccountInfo.className]

                    if accountInfo.gameAccountInfo.clientProgram == BNET_CLIENT_WOW and classColor then
                        button.name:SetText(nameText.." "..classColor.."("..characterName..")"..FONT_COLOR_CODE_CLOSE)
                    end
                end
            end
        end
    end
end)

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

hooksecurefunc("FriendsFrame_CheckBattlenetStatus", function(self)
    if Module:GetConfig(CONFIG_FRIEND_LIST_HIDE_BATTLE_NET_TAG_SUFFIX) then
        Module:SetBattleTagHideStatus(Module:GetConfig(CONFIG_FRIEND_LIST_HIDE_BATTLE_NET_TAG_SUFFIX_METHOD))
    end
end)

local Old_BNet_GetBNetAccountName = BNet_GetBNetAccountName
BNet_GetBNetAccountName = function(accountInfo)
    if Module:GetConfig(CONFIG_FRIEND_LIST_HIDE_BATTLE_NET_FRIENDS_REAL_NAME) then
        return (accountInfo and BNet_GetTruncatedBattleTag(accountInfo.battleTag)) or nil
    else
        return Old_BNet_GetBNetAccountName(accountInfo)
    end
end
