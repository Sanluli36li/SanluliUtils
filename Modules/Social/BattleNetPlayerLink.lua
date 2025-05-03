local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("social.chat.bnPlayerLink")
local L = SanluliUtils.Locale

local CONFIG_ENABLE = "enable"
local CONFIG_FORMAT = "format"

local BlizzardFunction = {  -- 暴雪原方法备份
    -- Interface\\AddOns\\Blizzard_ChatFrameBase\\Mainline\\ChatFrame.lua
    GetBNPlayerLink = _G["GetBNPlayerLink"]
}

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

GetBNPlayerLink = function(name, linkDisplayText, bnetIDAccount, lineID, chatType, chatTarget)
    if Module:GetConfig(CONFIG_ENABLE) then
        local accountInfo = C_BattleNet.GetAccountInfoByID(bnetIDAccount)
        local displayName

        if accountInfo then
            if Module:GetConfig(CONFIG_FORMAT) == 1 then
                displayName = (BNet_GetBNetAccountName(accountInfo) or "")
            elseif Module:GetConfig(CONFIG_FORMAT) == 2 then
                displayName = ClassColoredText((BNet_GetBNetAccountName(accountInfo) or ""), accountInfo.gameAccountInfo.realmName)
            elseif Module:GetConfig(CONFIG_FORMAT) == 3 then
                displayName = (BNet_GetBNetAccountName(accountInfo) or "")..(GetCharacterName(accountInfo, false, "(%s)", true) or "")
            elseif Module:GetConfig(CONFIG_FORMAT) == 4 then
                displayName = (BNet_GetBNetAccountName(accountInfo) or "")..(GetCharacterName(accountInfo, true, "(%s)", true) or "")
            elseif Module:GetConfig(CONFIG_FORMAT) == 5 then
                displayName = (GetCharacterName(accountInfo, false, "%s", true) or (BNet_GetBNetAccountName(accountInfo) or ""))
            elseif Module:GetConfig(CONFIG_FORMAT) == 6 then
                displayName = (GetCharacterName(accountInfo, true, "%s", true) or (BNet_GetBNetAccountName(accountInfo) or ""))
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