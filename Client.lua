local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("client")
local L = SanluliUtils.Locale


local CONFIG_PROFANITY_FILTER = "profanityFilter"
local CONFIG_REGION_DECEIVE = "regionDeceive.enable"
local CONFIG_REGION_DECEIVE_DIFFERENT_REGION_FIX = "regionDeceive.differentRegionFix"
-- local CONFIG_REGION_DECEIVE_TEMPORARILY_DISABLED = "regionDeceive.temporarilyDisabled"

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

Module.PORTAL_CURRENT = GetCVar(CVAR_PORTAL)

-- 记录客户端的真实地区
Module.REAL_REGION_ID = REGION_IDS[Module.PORTAL_CURRENT] or 1
-- 留存原有的获取好友信息方法
Module.BattleNetGetFriendGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo
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
    if self.PORTAL_CURRENT ~= PROTAL_CN then
        return
    elseif value then
        ConsoleExec(PORTAL_COMMAND:format(PORTAL_US))

        if printToChatFrame then
            SanluliUtils:Print(L["client.regionDeceive.message.enabled"])
        end

        -- 重新设置语言过滤器
        Module:SetProfanityFilter(Module:GetConfig(CONFIG_PROFANITY_FILTER), false)
        -- 修改地区会导致“不同的地区”BUG，启用修复
        Module:SetDifferentRegionFix(Module:GetConfig(CONFIG_REGION_DECEIVE_DIFFERENT_REGION_FIX), printToChatFrame)
    else
        ConsoleExec(PORTAL_COMMAND:format(self.PORTAL_CURRENT))

        if printToChatFrame then
            SanluliUtils:Print(L["client.regionDeceive.message.disabled"])
        end
        if Module:GetConfig(CONFIG_REGION_DECEIVE_DIFFERENT_REGION_FIX) then
            Module:SetDifferentRegionFix(false, printToChatFrame)
        end
    end
end

-- 设置: 修复"不同的地区"问题
function Module:SetDifferentRegionFix(value, printToChatFrame)
    if self.FixedDifferentRegion == value then
        return
    elseif value then
        -- 替换获取好友信息的方法
        C_BattleNet.GetFriendGameAccountInfo = function(...)
            local gameAccountInfo = self.BattleNetGetFriendGameAccountInfo(...)

            if gameAccountInfo.regionID == self.REAL_REGION_ID then
                gameAccountInfo.isInCurrentRegion = true
            else
                gameAccountInfo.isInCurrentRegion = false
            end

            return gameAccountInfo
        end
        self.FixedDifferentRegion = true
        if printToChatFrame then
            SanluliUtils:Print(L["client.regionDeceive.differentRegionFix.message.fixed"])
        end
    else
        -- 恢复获取好友信息的方法
        C_BattleNet.GetFriendGameAccountInfo = self.BattleNetGetFriendGameAccountInfo
        self.FixedDifferentRegion = false
        if printToChatFrame then
            SanluliUtils:Print(L["client.regionDeceive.differentRegionFix.message.restored"])
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
--[[

-- 帮助界面提示
StaticPopupDialogs["SANLULIUTILS_REGION_DECEIVE_HELP_SHOW"] = {
    preferredIndex = 3,
    text = L["client.regionDeceive.temporarilyDisabled.dialogs.onshow"],
    button1 = YES,
    button2 = CANCEL,
    OnAccept = function(self, data)
        HideUIPanel(HelpFrame)
        Module.SetRegionDeceive(false, false)
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
        Module.SetRegionDeceive(true, true)
    end,
    OnCancel = function(self, data)
    end,
    hideOnEscape = 1,
    timeout = 0,
    exclusive = 1,
    whileDead = 1,
}

hooksecurefunc(HelpFrame, "ShowFrame", function(self)
    if not Module.IsSameRegion() then
        StaticPopup_Show("SANLULIUTILS_REGION_DECEIVE_HELP_SHOW")
    end
end)
hooksecurefunc(HelpFrame, "Hide", function(self)
    if Module.IsSameRegion() and (Module.PORTAL_CURRENT == "CN") and Module:GetConfig(CONFIG_REGION_DECEIVE) then
        StaticPopup_Show("SANLULIUTILS_REGION_DECEIVE_HELP_HIDE")
    end
end)
]]

function Module:Startup()
    -- 启用客户端地区误导选项
    if (self.PORTAL_CURRENT == PROTAL_CN) and Module:GetConfig(CONFIG_REGION_DECEIVE) then
        --[[
        if Module:GetConfig(CONFIG_REGION_DECEIVE_TEMPORARILY_DISABLED) then
            SanluliUtils:Print(L["client.regionDeceive.temporarilyDisabled.message.enabled"])
            SanluliUtils:SetConfig("client", CONFIG_REGION_DECEIVE_TEMPORARILY_DISABLED, false)
        else
            self.SetRegionDeceive(true, false)
        end
        ]]
        self:SetRegionDeceive(true, false)
    end

    if GetCurrentRegionName() ~= 5 then
        self:SetProfanityFilter(Module:GetConfig(CONFIG_PROFANITY_FILTER), false)
    end

end