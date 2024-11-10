local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("blizzardui")
local L = SanluliUtils.Locale

local CONFIG_HIDE_ACTION_BAR_NAME = "actionBar.hideName"
local CONFIG_HIDE_ACTION_BAR_HOTKEY = "actionBar.hideHotkey"
local CONFIG_FORCE_SHOW_POWER_BAR_ALT_STATUS = "forceShowPowerBarAltStatus"
local CONFIG_SYNC_RAID_FRAME_ENABLE = "sync.raidFrame.enable"
local CONFIG_SYNC_RAID_FRAME_CVARS = "sync.raidFrame.cvars"
local CONFIG_SYNC_ACTION_BAR_ENABLE = "sync.actionBar.enable"
local CONFIG_SYNC_ACTION_BAR_CVARS = "sync.actionBar.cvars"

local RAID_FRAME_CVARS = {
    raidFramesDisplayIncomingHeals = true,      -- 显示预计治疗
    raidFramesDisplayPowerBars = true,          -- 显示能量条
    raidFramesDisplayOnlyHealerPowerBars = true,    -- 只显示治疗者能量条
    raidFramesDisplayAggroHighlight = true,     -- 高亮显示仇恨目标
    raidFramesDisplayClassColor = true,         -- 显示职业颜色
    raidOptionDisplayPets = true,               -- 显示宠物
    raidOptionDisplayMainTankAndAssist = true,  -- 显示主坦克和主助理
    raidFramesDisplayDebuffs = true,            -- 显示负面效果
    raidFramesDisplayOnlyDispellableDebuffs = true, -- 只显示可供驱散的负面效果
    raidFramesHealthText = true                 -- 显示生命值数值
}
local ACTION_BAR_CVARS = {
    enableMultiActionBars = true,               -- 动作条开关状态
    lockActionBars = true,                      -- 锁定动作条
    countdownForCooldowns = true                -- 显示冷却时间
}

local ACTION_BARS = {
    "Action",               -- 主动作条
    "MultiBarBottomLeft",   -- 动作条2 (原左下动作条)
    "MultiBarBottomRight",  -- 动作条3 (原右下动作条)
    "MultiBarRight",        -- 动作条4 (原右侧动作条)
    "MultiBarLeft",         -- 动作条5 (原右侧动作条2)
    "MultiBar5",            -- 动作条6 (巨龙时代新增)
    "MultiBar6",            -- 动作条7 (巨龙时代新增)
    "MultiBar7",            -- 动作条8 (巨龙时代新增)
    "PetAction"             -- 宠物动作条
}

StaticPopupDialogs["SANLULIUTILS_SYNC_ACTIONBAR_TAINT"] = {
    preferredIndex = 3,
    text = L["blizzardui.sync.actionBar.dialogs.noTaint"],
    button1 = YES,
    button2 = CANCEL,
    OnAccept = function(self, data)
        ReloadUI()
    end,
    OnCancel = function(self, data)
    end,
    hideOnEscape = 1,
    timeout = 0,
    exclusive = 1,
    whileDead = 1,
}

local shouldSaveCVar = false

function Module:SetActionBarNameDisplay(value)
    local alpha = (value and 1) or 0

    for i = 1, #ACTION_BARS do
        for j = 1, 12 do
            if _G[ACTION_BARS[i].."Button"..j.."Name"] then
                _G[ACTION_BARS[i].."Button"..j.."Name"]:SetAlpha(alpha)
            end
        end
    end
end

function Module:SetActionBarHotKeyDisplay(value)
    local alpha = (value and 1) or 0

    for i = 1, #ACTION_BARS do
        for j = 1, 12 do
            if _G[ACTION_BARS[i].."Button"..j.."HotKey"] then
                _G[ACTION_BARS[i].."Button"..j.."HotKey"]:SetAlpha(alpha)
            end
        end
    end
end

function Module:SaveRaidFrameCVars()
    local cvars = {}
    for k, v in pairs(RAID_FRAME_CVARS) do
        cvars[k] = GetCVar(k)
    end
    self:SetConfig(CONFIG_SYNC_RAID_FRAME_CVARS, cvars)
end

function Module:LoadRaidFrameCVars()
    local cvars = self:GetConfig(CONFIG_SYNC_RAID_FRAME_CVARS)
    if cvars then
        for k, v in pairs(cvars) do
            if GetCVar(k) ~= v then
                SetCVar(k, v)
            end
        end
    else
        self:SaveRaidFrameCVars()
    end
end

function Module:SaveActionBarCVars()
    local cvars = {}
    for k, v in pairs(ACTION_BAR_CVARS) do
        cvars[k] = GetCVar(k)
    end
    self:SetConfig(CONFIG_SYNC_ACTION_BAR_CVARS, cvars)
end

function Module:LoadActionBarCVars()
    local cvars = self:GetConfig(CONFIG_SYNC_ACTION_BAR_CVARS)
    if cvars then
        for k, v in pairs(cvars) do
            if GetCVar(k) ~= v then
                SetCVar(k, v)
                if k == "enableMultiActionBars" then
                    MultiActionBar_Update()
                    StaticPopup_Show("SANLULIUTILS_SYNC_ACTIONBAR_TAINT")
                    SanluliUtils:Print("检测到动作条变更, 建议使用 /reload 避免污染")
                end
            end
        end
    else
        self:SaveActionBarCVars()
    end
    
end

--------------------
-- 暴雪函数安全钩子
--------------------

-- 总是显示额外能量条状态
hooksecurefunc(PlayerPowerBarAltStatusFrame, "Hide", function(self)
    if Module:GetConfig(CONFIG_FORCE_SHOW_POWER_BAR_ALT_STATUS) then
        self:Show()
    end
end)

--------------------
-- 事件处理
--------------------

function Module:CVAR_UPDATE(name, value)
    if not shouldSaveCVar then
        return
    elseif self:GetConfig(CONFIG_SYNC_RAID_FRAME_ENABLE) and RAID_FRAME_CVARS[name] then
        local cvars = self:GetConfig(CONFIG_SYNC_RAID_FRAME_CVARS)
        if cvars then
            cvars[name] = value
        else
            self:SaveRaidFrameCVars()
        end
    elseif self:GetConfig(CONFIG_SYNC_ACTION_BAR_ENABLE) and ACTION_BAR_CVARS[name] then
        local cvars = self:GetConfig(CONFIG_SYNC_ACTION_BAR_CVARS)
        if cvars then
            cvars[name] = value
        else
            self:SaveActionBarCVars()
        end
    end
end
Module:RegisterEvent("CVAR_UPDATE")

function Module:AfterStartup()
    shouldSaveCVar = true
    if self:GetConfig(CONFIG_HIDE_ACTION_BAR_NAME) then
        self:SetActionBarNameDisplay(false)
    end
    if self:GetConfig(CONFIG_HIDE_ACTION_BAR_HOTKEY) then
        self:SetActionBarHotKeyDisplay(false)
    end
    if self:GetConfig(CONFIG_SYNC_RAID_FRAME_ENABLE) then
        self:LoadRaidFrameCVars()
    end
    if self:GetConfig(CONFIG_SYNC_ACTION_BAR_ENABLE) then
        self:LoadActionBarCVars()
    end
end
