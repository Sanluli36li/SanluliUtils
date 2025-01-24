local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("social")
local L = SanluliUtils.Locale

-- 配置项目键名
local CONFIG_CHAT_HYPERLINK_ENHANCE = "chat.hyperlinkEnhance.enable"
local CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ICON = "chat.hyperlinkEnhance.displayIcon"
local CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ITEM_LEVEL = "chat.hyperlinkEnhance.displayItemLevel"
local CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ITEM_TYPE = "chat.hyperlinkEnhance.displayItemType"
local CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_SOCKETS = "chat.hyperlinkEnhance.displaySockets"
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

local chatFrameInfo

local function saveChatFrame()
    chatFrameInfo = {}

    
end

local function loadChatFrame()
    
end

local function chatFilter(chatFrame, event, message, ...)
    if not Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE) then return end
    local newMessage = message:gsub("(\124c([\\a-fA-F0-9]+)\124Hitem:([^\124]+)\124h(%b[])\124h\124r)", function(link, color, metaData, itemName)
        -- 物品
        local sourceItemName = strsub(itemName, 2, -2)
        local sourceItemNameWithoutIcon = sourceItemName:gsub("\124.*", "")
        local name, _, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, _, itemEquipLoc, itemTexture, _, classID, subclassID, bindType, expacID, setID, isCraftingReagent = GetItemInfo(link)
        local displayItemName = sourceItemNameWithoutIcon

        if not name then return end

        local bonding
        local canUse = true
        local sockets = ""

        local tooltipInfo = C_TooltipInfo.GetHyperlink(link)
        if tooltipInfo and tooltipInfo.type == Enum.TooltipDataType.Item and tooltipInfo.lines then
            for i, line in ipairs(tooltipInfo.lines) do
                if line.type == Enum.TooltipDataLineType.ItemBinding then
                    bonding = line.bonding
                elseif Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_SOCKETS) and line.type == Enum.TooltipDataLineType.GemSocket then
                    -- 插槽信息
                    if line.gemIcon then
                        sockets = sockets.."|T"..line.gemIcon..":12:12:0:-2|t"
                    elseif line.socketType then
                        sockets = sockets.."|T"..string.format("Interface\\ItemSocketingFrame\\UI-EmptySocket-%s", line.socketType)..":12:12:0:-2|t"
                    end
                elseif line.type == Enum.TooltipDataLineType.RestrictedRaceClass and line.leftColor and line.leftColor:GenerateHexColor() ~= "ffffffff" then
                    -- 职业限制不可用
                    canUse = false
                end
            end
            
        end

        if sockets ~= "" then
            sockets = sockets.." "
        end

        if bonding == 5 or bonding == 10 then
            -- 战团绑定 链接显示为传家宝颜色
            color = "ff00ccff"
        elseif not canUse then
            -- 不能使用的物品
            color = "ffff2020"
        end

        -- 物品分类
        if Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ITEM_TYPE) then
            local displayType
            if classID == Enum.ItemClass.Armor then
                -- 护甲
                if subclassID == Enum.ItemArmorSubclass.Generic or itemEquipLoc == "INVTYPE_CLOAK" then
                    -- 护甲->杂项/背部(所有披风都是布甲类型, 需要特判): 装备栏位
                    displayType = _G[itemEquipLoc]
                elseif subclassID == Enum.ItemArmorSubclass.Shield then
                    -- 护甲->盾牌: 盾牌
                    displayType = itemSubType
                else
                    -- 其他: 护甲类型和装备栏位
                    displayType = itemSubType.."||".._G[itemEquipLoc]
                end
            elseif classID == Enum.ItemClass.Tradegoods and subclassID == 11 then
                displayType = PROFESSIONS_MODIFIED_CRAFTING_REAGENT_BASIC
            elseif (
                (classID == Enum.ItemClass.Consumable and subclassID == Enum.ItemConsumableSubclass.Other) or                                           -- 消耗品->其他
                (classID == Enum.ItemClass.Gem and subclassID ~= Enum.ItemGemSubclass.Artifactrelic) or                                                 -- 宝石 (不包括军团神器圣物)
                classID == Enum.ItemClass.ItemEnhancement or                                                                                            -- 物品强化
                (classID == Enum.ItemClass.Miscellaneous and subclassID == Enum.ItemMiscellaneousSubclass.Junk and itemQuality > Enum.ItemQuality.Poor) -- 非破烂品质垃圾
            ) then
                displayType = itemType
            else
                displayType = itemSubType or itemType
            end

            if displayType and (
                classID == Enum.ItemClass.Weapon or
                classID == Enum.ItemClass.Armor or
                classID == Enum.ItemClass.Profession or
                (classID == Enum.ItemClass.Miscellaneous and Enum.ItemMiscellaneousSubclass.Junk and itemQuality >= Enum.ItemQuality.Epic)  -- 杂项->垃圾 (史诗品质以上) (套装兑换物)
            ) then
                if bonding == 7 then
                    -- 装备后绑定
                    displayType = "|cffffffffBoE|r||"..displayType
                elseif bonding == 10 then
                    -- 装备前战团绑定
                    -- displayType = "|cff00ccffWuE|r||"..displayType
                end
            end

            if displayType then
                displayItemName = "("..displayType..")"..displayItemName
            end
        end

        -- 重新格式化钥石物品
        --[[
            注: 
            物品格式的钥石链接仅在获得钥石时或与林多尔米对话更换或降低钥石时使用
            发送链接时通常使用单独的钥石格式而非物品格式
            此部分将统一两种链接的显示效果
        ]]
        if classID == Enum.ItemClass.Reagent and subclassID == Enum.ItemReagentSubclass.Keystone then
            local data = strsplittable(":", metaData)
                if data[16] and data[18] then
                local mapName = C_ChallengeMode.GetMapUIInfo(tonumber(data[16]))
                if mapName then
                    displayItemName = CHALLENGE_MODE_KEYSTONE_HYPERLINK:format(mapName, tonumber(data[18]))
                end
            end
        end

        -- 物品等级 (仅武器、护甲、专业装备展示物品等级)
        if Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ITEM_LEVEL) and (
            classID == Enum.ItemClass.Weapon or                                                                                         -- 武器
            classID == Enum.ItemClass.Armor or                                                                                          -- 护甲
            classID == Enum.ItemClass.Profession or                                                                                     -- 专业装备
            (classID == Enum.ItemClass.Gem and subclassID == Enum.ItemGemSubclass.Artifactrelic) or                                     -- 神器圣物
            (classID == Enum.ItemClass.Miscellaneous and Enum.ItemMiscellaneousSubclass.Junk and itemQuality >= Enum.ItemQuality.Epic)  -- 杂项->垃圾 (史诗品质以上) (套装兑换物)
        ) then
            displayItemName = itemLevel..":"..displayItemName
        end

        local newItemLink = "|c"..color.."|H".."item:"..metaData.."|h".."["..sourceItemName:gsub(sourceItemNameWithoutIcon:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1"), displayItemName).."]".."|h".."|r"

        -- 物品图标
        if Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ICON) and itemTexture then
            newItemLink = "|T"..itemTexture..":12:12:0:-2|t"..newItemLink
        end

        -- 插槽图标
        if Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_SOCKETS) then
            newItemLink = newItemLink..sockets
        end

        return newItemLink

    end):gsub("(\124Hkeystone:([0-9]+):[^\124]+\124h(%b[])\124h)", function(link, itemIDStr, keystoneName)
        -- 史诗钥石
        if Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ICON) then
            local itemID = tonumber(itemIDStr)
            local name, _, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, _, itemEquipLoc, itemTexture = GetItemInfo(itemID)

            if itemTexture then
                return "|T"..itemTexture..":12:12:1:-2|t"..link
            end
        end
    end):gsub("(\124Hcurrency:([0-9]+):[^\124]+\124h(%b[])\124h)", function(link, currencyIDLink, currencyName)
        -- 货币
        if Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ICON) then
            local info = C_CurrencyInfo.GetCurrencyInfoFromLink(link)

            if info and info.iconFileID then
                return "|T"..info.iconFileID..":12:12:1:-2|t"..link
            end
        end
    end):gsub("(\124Hspell:[^\124]+\124h(%b[])\124h)", function(link, spellName)
        -- 法术
        if Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ICON) then
            local info = C_Spell.GetSpellInfo(link)

            if info and info.iconID then
                return "|T"..info.iconID..":12:12:1:-2|t"..link
            end
        end
    end):gsub("(\124Hmount:([0-9]+):[^\124]+\124h(%b[])\124h)", function(link, spellIDStr, spellName)
        -- 坐骑
        if Module:GetConfig(CONFIG_CHAT_HYPERLINK_ENHANCE_DISPLAY_ICON) then
            local spellID = tonumber(spellIDStr)
            local spellInfo = C_Spell.GetSpellInfo(spellID)

            if spellInfo and spellInfo.iconID then
                return "|T"..spellInfo.iconID..":12:12:1:-2|t"..link
            end
        end
    end)

    return false, newMessage, ...
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", chatFilter)                     -- 说
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", chatFilter)                   -- 表情
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", chatFilter)                    -- 大喊
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", chatFilter)                   -- 公会聊天
-- ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", chatFilter)                 -- 官员聊天 (加密字符串 无法替换)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", chatFilter)                 -- 悄悄话
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", chatFilter)          -- 悄悄话
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", chatFilter)              -- 战网昵称密语
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", chatFilter)       -- 战网昵称密语
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", chatFilter)                   -- 小队
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", chatFilter)            -- 小队队长
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", chatFilter)                    -- 团队
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", chatFilter)             -- 团队领袖
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", chatFilter)           -- 副本
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", chatFilter)    -- 副本向导
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", chatFilter)                 -- 频道
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", chatFilter)                    -- 物品拾取
ChatFrame_AddMessageEventFilter("CHAT_MSG_CURRENCY", chatFilter)                -- 货币
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ITEM_LOOTED", chatFilter)       -- 公会物品拾取


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

