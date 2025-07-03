local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("social.friendsList")
local L = SanluliUtils.Locale

local CONFIG_FRIEND_LIST_CHARACTER_NAME_CLASS_COLOR = "characterNameClassColor.enable"
local CONFIG_FRIEND_LIST_CHARACTER_NAME_CLASS_COLOR_SAME_PROJECT_ID = "characterNameClassColor.sameProjectId"

local CLASSES_COLORS = {}   -- 职业颜色表

for i = 1, GetNumClasses(), 1 do
    local classNameLocalization, className, classId = GetClassInfo(i)
    CLASSES_COLORS[classNameLocalization] = "|c"..C_ClassColor.GetClassColor(className):GenerateHexColor()
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

        if withRealmName and accountInfo.gameAccountInfo.realmID and accountInfo.gameAccountInfo.realmID ~= GetRealmID() and accountInfo.gameAccountInfo.realmName then
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

                if Module:GetConfig(CONFIG_FRIEND_LIST_CHARACTER_NAME_CLASS_COLOR) and (not Module:GetConfig(CONFIG_FRIEND_LIST_CHARACTER_NAME_CLASS_COLOR_SAME_PROJECT_ID) or (accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.wowProjectID == WOW_PROJECT_ID)) then
                    characterName = GetCharacterName(accountInfo, false, "(%s)", true)
                else
                    local name = GetCharacterName(accountInfo, false, "(%s)", false)
                    if name then
                        characterName = FRIENDS_OTHER_NAME_COLOR_CODE..name..FONT_COLOR_CODE_CLOSE
                    end
                    
                end

                if characterName then
                    button.name:SetText(nameText.." "..characterName)
                end
            end
        end
    end
end)
