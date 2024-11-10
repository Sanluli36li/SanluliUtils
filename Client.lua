local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("client")
local L = SanluliUtils.Locale


local CONFIG_PROFANITY_FILTER = "profanityFilter"
local CONFIG_REGION_DECEIVE = "regionDeceive.enable"
local CONFIG_REGION_DECEIVE_DIFFERENT_REGION_FIX = "regionDeceive.differentRegionFix"
local CONFIG_ACHIEVEMENTS_DATA_INJECT = "profanityFilter.achievementDataInject"
local CONFIG_REGION_DECEIVE_TEMPORARILY_DISABLED = "regionDeceive.temporarilyDisabled"
local CONFIG_GUILD_NEWS_FIX = "guildNewsFix"

local CVAR_PORTAL = "portal"
local CVAR_PROFANITY_FILTER = "profanityFilter"
local CVAR_OVERRIDE_ARCHIVE = "overrideArchive"

local PORTAL_COMMAND = "portal %s"
local PORTAL_US = "US"
local PROTAL_CN = "CN"
local PORTAL_TEST = "test"

local REGION_IDS = {
    US = 1,
    KR = 2,
    EU = 3,
    TW = 4,
    CN = 5
}

local BlizzardFunction = {
    C_BattleNetGetFriendAccountInfo = C_BattleNet.GetFriendGameAccountInfo,
    CommunitiesGuildNewsFrame_OnEvent = CommunitiesGuildNewsFrame_OnEvent
}

Module.PORTAL_CURRENT = GetCVar(CVAR_PORTAL)

-- 记录客户端的真实地区
Module.REAL_REGION_ID = REGION_IDS[Module.PORTAL_CURRENT] or 1
-- 留存原有的获取好友信息方法
-- Module.BattleNetGetFriendGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo
Module.FixedDifferentRegion = false


function Module:IsSameRegion()
    if self.PORTAL_CURRENT == PORTAL_TEST then
        return true
    end
    return GetCurrentRegionName() == self.PORTAL_CURRENT
end

-- 设置: 反和谐
function Module:SetOverrideArchive(value, printToChatFrame)
    if value then
        SetCVar(CVAR_OVERRIDE_ARCHIVE, "1")
        if printToChatFrame then
            SanluliUtils:Print(L["client.disabledOverrideArchive.message.enabled"])
        end
    else
        SetCVar(CVAR_OVERRIDE_ARCHIVE, "0")
        if printToChatFrame then
            SanluliUtils:Print(L["client.disabledOverrideArchive.message.disabled"])
        end
    end
end

-- 设置: 区域误导选项
function Module:SetRegionDeceive(value, printToChatFrame)
    if Module.PORTAL_CURRENT ~= PROTAL_CN then
        return
    elseif value then
        ConsoleExec(PORTAL_COMMAND:format(PORTAL_US))

        if printToChatFrame then
            SanluliUtils:Print(L["client.regionDeceive.message.enabled"])
        end

        -- 重新设置语言过滤器
        Module:SetProfanityFilter(Module:GetConfig(CONFIG_PROFANITY_FILTER), false)
    else
        ConsoleExec(PORTAL_COMMAND:format(Module.PORTAL_CURRENT))

        if printToChatFrame then
            SanluliUtils:Print(L["client.regionDeceive.message.disabled"])
        end
    end
end

-- 设置: 语言过滤器
function Module:SetProfanityFilter(value, printToChatFrame)
    if GetCVarBool(CVAR_PROFANITY_FILTER) == value then
        return
    elseif value then
        SetCVar(CVAR_PROFANITY_FILTER, "1")
        if printToChatFrame then
            SanluliUtils:Print(L["client.profanityFilter.message.enabled"])
        end
    else
        SetCVar(CVAR_PROFANITY_FILTER, "0")
        if printToChatFrame then
            SanluliUtils:Print(L["client.profanityFilter.message.disabled"])
        end
    end
    
end

-- 开启地区误导导致的支持界面无限转圈圈，提示用户临时关闭地区误导选项
-- 2024/08/01: 此问题已解决，故移除此功能
-- 2024/11/01: 发现只是网页能打开了而已，仍然无法登录账号填写表单，故恢复此功能

-- 帮助界面提示
StaticPopupDialogs["SANLULIUTILS_REGION_DECEIVE_HELP_SHOW"] = {
    preferredIndex = 3,
    text = L["client.regionDeceive.temporarilyDisabled.dialogs.onshow"],
    button1 = YES,
    button2 = CANCEL,
    OnAccept = function(self, data)
        HideUIPanel(HelpFrame)
        Module:SetRegionDeceive(false, false)
        SanluliUtils:SetConfig("client", CONFIG_REGION_DECEIVE_TEMPORARILY_DISABLED, true)
        ReloadUI()
    end,
    OnCancel = function(self, data)
    end,
    hideOnEscape = 1,
    timeout = 0,
    exclusive = 1,
    whileDead = 1,
}
StaticPopupDialogs["SANLULIUTILS_REGION_DECEIVE_HELP_HIDE"] = {
    preferredIndex = 3,
    text = L["client.regionDeceive.temporarilyDisabled.dialogs.onhide"],
    button1 = YES,
    button2 = CANCEL,
    OnAccept = function(self, data)
        Module:SetRegionDeceive(true, true)
    end,
    OnCancel = function(self, data)
    end,
    hideOnEscape = 1,
    timeout = 0,
    exclusive = 1,
    whileDead = 1,
}


--------------------
-- 暴雪函数安全钩子
--------------------

-- 支持界面 显示
hooksecurefunc(HelpFrame, "Show", function(self)
    if not Module:IsSameRegion() then
        StaticPopup_Show("SANLULIUTILS_REGION_DECEIVE_HELP_SHOW")
        HelpFrame:ClearPoint("TOP")
        HelpFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end
end)

-- 支持界面 隐藏
hooksecurefunc(HelpFrame, "Hide", function(self)
    if Module:IsSameRegion() and (Module.PORTAL_CURRENT == "CN") and Module:GetConfig(CONFIG_REGION_DECEIVE) then
        StaticPopup_Show("SANLULIUTILS_REGION_DECEIVE_HELP_HIDE")
    end
end)

-- 发送聊天信息
hooksecurefunc("SendChatMessage", function (msg, chatType, languageID, target)
    if chatType == "SAY" or chatType == "YELL" or chatType == "CHANNEL" then
        -- 说/喊在副本外、向频道发送消息必须有硬件事件, 考虑到需要在这些地方发送成就的情况比较少, 跳过
        return
    end
    if Module.PORTAL_CURRENT == "CN" and Module:GetConfig(CONFIG_ACHIEVEMENTS_DATA_INJECT) then
        -- 替换被异常屏蔽的成就
        if string.find(msg, ":9:18:") then
            local str = string.gsub(msg, ":9:18:", ":009:018:")
            -- 重新发送
            SendChatMessage(str, chatType, languageID, target)
        end
    end
end)

--------------------
-- 替换暴雪方法
--------------------

C_BattleNet.GetFriendGameAccountInfo = function(...)
    if Module:GetConfig(CONFIG_REGION_DECEIVE) and Module:GetConfig(CONFIG_REGION_DECEIVE_DIFFERENT_REGION_FIX) then
        local gameAccountInfo = BlizzardFunction.C_BattleNetGetFriendAccountInfo(...)

        if gameAccountInfo.regionID == Module.REAL_REGION_ID then
            gameAccountInfo.isInCurrentRegion = true
        else
            gameAccountInfo.isInCurrentRegion = false
        end

        return gameAccountInfo
    else
        return BlizzardFunction.C_BattleNetGetFriendAccountInfo(...)
    end
end

local newsRequireUpdate, newsTimer
CommunitiesFrameGuildDetailsFrameNews:SetScript("OnEvent", function(frame, event)
    if Module:GetConfig(CONFIG_GUILD_NEWS_FIX) and event == "GUILD_NEWS_UPDATE" then
        if newsTimer then
            newsRequireUpdate = true
        else
            BlizzardFunction.CommunitiesGuildNewsFrame_OnEvent(frame, event)
            
            -- 1秒后, 如果还需要更新公会新闻, 再次更新
            newsTimer = C_Timer.NewTimer(1, function()
                if newsRequireUpdate then
                    BlizzardFunction.CommunitiesGuildNewsFrame_OnEvent(frame, event)
                end
                newsTimer = nil
            end)
        end
    else
        BlizzardFunction.CommunitiesGuildNewsFrame_OnEvent(frame, event)
    end
end)

--------------------
-- 事件处理
--------------------

function Module:Startup()
    -- 启用客户端地区误导选项
    if (self.PORTAL_CURRENT == PROTAL_CN) and Module:GetConfig(CONFIG_REGION_DECEIVE) then
        if Module:GetConfig(CONFIG_REGION_DECEIVE_TEMPORARILY_DISABLED) then
            SanluliUtils:Print(L["client.regionDeceive.temporarilyDisabled.message.enabled"])
            self:SetConfig(CONFIG_REGION_DECEIVE_TEMPORARILY_DISABLED, false)
        else
            self:SetRegionDeceive(true, false)
        end
    end

    if GetCurrentRegionName() ~= 5 then
        self:SetProfanityFilter(Module:GetConfig(CONFIG_PROFANITY_FILTER), false)
    end
end
