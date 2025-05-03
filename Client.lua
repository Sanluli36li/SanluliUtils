local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("client")
local L = SanluliUtils.Locale


local CONFIG_PROFANITY_FILTER = "profanityFilter"
-- local CONFIG_REGION_DECEIVE = "regionDeceive.enable"
-- local CONFIG_REGION_DECEIVE_DIFFERENT_REGION_FIX = "regionDeceive.differentRegionFix"
-- local CONFIG_REGION_DECEIVE_TEMPORARILY_DISABLED = "regionDeceive.temporarilyDisabled"
local CONFIG_ACHIEVEMENTS_DATA_INJECT = "profanityFilter.achievementDataInject"
-- local CONFIG_MOUNT_LINK_FIX = "mountLinkFix"
-- local CONFIG_GUILD_NEWS_FIX = "guildNewsFix"

-- local CVAR_PORTAL = "portal"
local CVAR_PROFANITY_FILTER = "profanityFilter"
local CVAR_OVERRIDE_ARCHIVE = "overrideArchive"

-- local PORTAL_COMMAND = "portal %s"
-- local PORTAL_US = "US"
-- local PROTAL_CN = "CN"
-- local PORTAL_TEST = "test"

--[[
local REGION_IDS = {
    US = 1,
    KR = 2,
    EU = 3,
    TW = 4,
    CN = 5
}
]]

local BlizzardFunction = {
    -- C_BattleNet_GetFriendAccountInfo = C_BattleNet.GetFriendGameAccountInfo,
    -- CommunitiesGuildNewsFrame_OnEvent = CommunitiesGuildNewsFrame_OnEvent,
    -- GetCurrentRegion = GetCurrentRegion,
    -- GetCurrentRegionName = GetCurrentRegionName,
    -- C_MountJournal_GetMountLink = C_MountJournal.GetMountLink
}

--[[

Module.PORTAL_CURRENT = GetCVar(CVAR_PORTAL)

-- 记录客户端的真实地区
Module.REAL_REGION_ID = REGION_IDS[Module.PORTAL_CURRENT] or 1

function Module:IsSameRegion()
    if self.PORTAL_CURRENT == PORTAL_TEST then
        return true
    end
    return GetCurrentRegionName() == self.PORTAL_CURRENT
end
]]
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

--[[
-- 设置: 区域误导选项
-- 2025/03/26: 目前无法通过ConsoleExec("portal US")修改客户端地区了，此功能已经失效，移除
function Module:SetRegionDeceive(value, printToChatFrame)
    if self.PORTAL_CURRENT ~= PROTAL_CN then
        return
    elseif value then
        ConsoleExec(PORTAL_COMMAND:format(PORTAL_US))

        if printToChatFrame then
            SanluliUtils:Print(L["client.regionDeceive.message.enabled"])
        end

        -- 重新设置语言过滤器
        self:SetProfanityFilter(self:GetConfig(CONFIG_PROFANITY_FILTER), false)
    else
        ConsoleExec(PORTAL_COMMAND:format(self.PORTAL_CURRENT))

        if printToChatFrame then
            SanluliUtils:Print(L["client.regionDeceive.message.disabled"])
        end
    end
end
]]

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


-- 设置: 插件性能分析
-- https://x.com/Luckyone961/status/1901392733790494908
-- 2025/05/04: 由于暴雪在11.1.5中强制启用性能分析, 故已失效 https://x.com/Luckyone961/status/1914795096324907492
--[[
function Module:SetAddOnsProfiler(value, printToChatFrame)
    if not GetCVar("addonProfilerEnabled") then
        C_CVar.RegisterCVar("addonProfilerEnabled", "1")
    end

    if value then
        C_CVar.SetCVar("addonProfilerEnabled", "1")
        if printToChatFrame then
            SanluliUtils:Print(L["client.blzAddonProfiler.message.enabled"])
        end
    else
        C_CVar.SetCVar("addonProfilerEnabled", "0")
        if printToChatFrame then
            SanluliUtils:Print(L["client.blzAddonProfiler.message.disabled"])
        end
    end
end
]]

-- 开启地区误导导致的支持界面无限转圈圈，提示用户临时关闭地区误导选项
-- 2024/08/01: 此问题已解决，故移除此功能
-- 2024/11/01: 发现只是网页能打开了而已，仍然无法登录账号填写表单，故恢复此功能
-- 2025/03/26: 目前无法通过ConsoleExec("portal US")修改客户端地区了，此功能已经失效，移除
--[[
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
]]

--------------------
-- 暴雪函数安全钩子
--------------------
---
--[[
-- 支持界面
-- 2025/03/26: 目前无法通过ConsoleExec("portal US")修改客户端地区了，此功能已经失效，移除

hooksecurefunc(HelpFrame, "Show", function(self)
    if not Module:IsSameRegion() then
        StaticPopup_Show("SANLULIUTILS_REGION_DECEIVE_HELP_SHOW")
        HelpFrame:ClearPoint("TOP")
        HelpFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end
end)

hooksecurefunc(HelpFrame, "Hide", function(self)
    if Module:IsSameRegion() and (Module.PORTAL_CURRENT == "CN") and Module:GetConfig(CONFIG_REGION_DECEIVE) then
        StaticPopup_Show("SANLULIUTILS_REGION_DECEIVE_HELP_HIDE")
    elseif StaticPopup_Visible("SANLULIUTILS_REGION_DECEIVE_HELP_SHOW") then
        StaticPopup_Hide("SANLULIUTILS_REGION_DECEIVE_HELP_SHOW")
    end
end)
]]

-- 发送聊天信息
--[[
hooksecurefunc("SendChatMessage", function (msg, chatType, languageID, target)
    if GetCVar("portal") == "CN" and Module:GetConfig(CONFIG_ACHIEVEMENTS_DATA_INJECT) then
        -- 替换被异常屏蔽的成就
        if string.find(msg, ":9:18:") then
            local str = string.gsub(msg, ":9:18:", ":009:018:")
            -- 重新发送
            SendChatMessage(str, chatType, languageID, target)
        end
    end
end)
]]

--------------------
-- 替换暴雪方法
--------------------

--[[
-- 2025/03/26: 目前无法通过ConsoleExec("portal US")修改客户端地区了，此功能已经失效，移除

C_BattleNet.GetFriendGameAccountInfo = function(...)
    if Module:GetConfig(CONFIG_REGION_DECEIVE) and Module:GetConfig(CONFIG_REGION_DECEIVE_DIFFERENT_REGION_FIX) then
        local gameAccountInfo = BlizzardFunction.C_BattleNet_GetFriendAccountInfo(...)

        if gameAccountInfo.regionID == Module.REAL_REGION_ID then
            gameAccountInfo.isInCurrentRegion = true
        else
            gameAccountInfo.isInCurrentRegion = false
        end

        return gameAccountInfo
    else
        return BlizzardFunction.C_BattleNet_GetFriendAccountInfo(...)
    end
end

GetCurrentRegion = function(...)
    if Module:GetConfig(CONFIG_REGION_DECEIVE) and Module:GetConfig(CONFIG_REGION_DECEIVE_DIFFERENT_REGION_FIX) then
        return REGION_IDS[GetCVar(CVAR_PORTAL)] or 1
    else
        return BlizzardFunction.GetCurrentRegion()
    end
end

GetCurrentRegionName = function(...)
    if Module:GetConfig(CONFIG_REGION_DECEIVE) and Module:GetConfig(CONFIG_REGION_DECEIVE_DIFFERENT_REGION_FIX) then
       return GetCVar(CVAR_PORTAL)
    else
        return BlizzardFunction.GetCurrentRegionName()
    end
end
]]

--[[
-- 2025/03/17: 暴雪已于11.1.0.58819中修复此bug, 故移除此功能 https://github.com/Stanzilla/WoWUIBugs/issues/699

C_MountJournal.GetMountLink = function(spellID)
    local link = BlizzardFunction.C_MountJournal_GetMountLink(spellID)
    if link then
        return link
    elseif Module:GetConfig(CONFIG_MOUNT_LINK_FIX) then
        local mountID = C_MountJournal.GetMountFromSpell(spellID)
        if mountID then
            local name = C_MountJournal.GetMountInfoByID(mountID)
            local creatureDisplayInfoID = C_MountJournal.GetMountInfoExtraByID(mountID)

            link = "|cff71d5ff".."|H".."mount:"..spellID..":"..(creatureDisplayInfoID or "0")..":".."|h".."["..name.."]".."|h".."|r"
            return link
        end
    end
end
]]


--[[
-- 2025/03/17: 暴雪于11.0.7.57637已修复此bug, 故移除此功能 https://github.com/Stanzilla/WoWUIBugs/issues/683

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
                newsRequireUpdate = false
                newsTimer = nil
            end)
        end
    else
        BlizzardFunction.CommunitiesGuildNewsFrame_OnEvent(frame, event)
    end
end)
]]

--------------------
-- 事件处理
--------------------

function Module:Startup()
    --[[
    -- 启用客户端地区误导选项
    -- 2025/03/26: 目前无法通过ConsoleExec("portal US")修改客户端地区了，此功能已经失效，移除
    if (self.PORTAL_CURRENT == PROTAL_CN) and Module:GetConfig(CONFIG_REGION_DECEIVE) then
        if Module:GetConfig(CONFIG_REGION_DECEIVE_TEMPORARILY_DISABLED) then
            SanluliUtils:Print(L["client.regionDeceive.temporarilyDisabled.message.enabled"])
            self:SetConfig(CONFIG_REGION_DECEIVE_TEMPORARILY_DISABLED, false)
        else
            self:SetRegionDeceive(true, false)
        end
    end
    ]]

    -- 设置语言过滤器
    if GetCurrentRegionName() ~= 5 then
        self:SetProfanityFilter(Module:GetConfig(CONFIG_PROFANITY_FILTER), false)
    end

    -- 插件性能分析
    -- self:SetAddOnsProfiler(not Module:GetConfig("blzAddonProfiler.disable"), false)
end
