local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("blizzardui.sync")
local L = SanluliUtils.Locale

local CONFIG_SYNC_RAID_FRAME_ENABLE = "raidFrame.enable"
local CONFIG_SYNC_RAID_FRAME_CVARS = "raidFrame.cvars"
local CONFIG_SYNC_ACTION_BAR_ENABLE = "actionBar.enable"
local CONFIG_SYNC_ACTION_BAR_CVARS = "actionBar.cvars"

local RAID_FRAME_CVARS = {
    -- 至暗之夜新增:
    raidFramesCenterBigDefensive = true,            -- 重要防御技能居中
    raidFramesDispelIndicatorOverlay = true,        -- 可驱散减益指示器
    raidFramesDispelIndicatorType = true,           -- 可驱散减益颜色
    raidFramesDisplayLargerRoleSpecificDebuffs = true,  -- 放大职责减益
    raidFramesHealthBarColor = true,                -- 团队框架颜色 (仅不使用职业颜色时)
    -- 旧版
    raidFramesDisplayAggroHighlight = true,         -- 高亮显示仇恨目标
    raidFramesDisplayClassColor = true,             -- 显示职业颜色
    raidFramesDisplayDebuffs = true,                -- 显示负面效果
    raidFramesDisplayIncomingHeals = true,          -- 显示预计治疗
    raidFramesDisplayOnlyDispellableDebuffs = true, -- 只显示可供驱散的负面效果
    raidFramesDisplayOnlyHealerPowerBars = true,    -- 只显示治疗者能量条
    raidFramesDisplayPowerBars = true,              -- 显示能量条
    raidFramesHealthText = true,                    -- 显示生命值数值
    raidOptionDisplayPets = true,                   -- 显示宠物
    raidOptionDisplayMainTankAndAssist = true,      -- 显示主坦克和主助理
}

local ACTION_BAR_CVARS = {
    enableMultiActionBars = true,               -- 动作条开关状态
    lockActionBars = true,                      -- 锁定动作条
    countdownForCooldowns = true                -- 显示冷却时间
}

-- 动作条污染 重新载入提示
StaticPopupDialogs["SANLULIUTILS_SYNC_ACTIONBAR_TAINT"] = {
    preferredIndex = 3,
    text = L["blizzardui.sync.actionBar.dialogs.noTaint"],
    button1 = YES,
    button2 = CANCEL,
    OnAccept = function(self, data)
        ReloadUI()
    end,
    OnCancel = function(self, data) end,
    hideOnEscape = 1,
    timeout = 0,
    exclusive = 1,
    whileDead = 1,
}

local shouldSaveCVar = false

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
                    -- SanluliUtils:Print("检测到动作条变更, 建议使用 /reload 避免污染")
                end
            end
        end
    else
        self:SaveActionBarCVars()
    end
end

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

function Module:AfterLogin()
    shouldSaveCVar = true

    if self:GetConfig(CONFIG_SYNC_RAID_FRAME_ENABLE) then
        self:LoadRaidFrameCVars()
    end
    if self:GetConfig(CONFIG_SYNC_ACTION_BAR_ENABLE) then
        self:LoadActionBarCVars()
    end
end
