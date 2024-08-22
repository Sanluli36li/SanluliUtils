local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("blizzardui")
local L = SanluliUtils.Locale

local CONFIG_HIDE_ACTION_BAR_NAME = "actionBar.hideName"
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

hooksecurefunc(PlayerPowerBarAltStatusFrame, "Hide", function(self)
    if Module:GetConfig(CONFIG_FORCE_SHOW_POWER_BAR_ALT_STATUS) then
        self:Show()
    end
end)

function Module:SetActionBarNameDisplay(value)
    local actionBars = {
        "Action",               -- 主动作条
        "MultiBarBottomLeft",   -- 动作条2 (原左下动作条)
        "MultiBarBottomRight",  -- 动作条3 (原右下动作条)
        "MultiBarRight",        -- 动作条4 (原右侧动作条)
        "MultiBarLeft",         -- 动作条5 (原右侧动作条2)
        "MultiBar5",            -- 动作条6 (巨龙时代新增)
        "MultiBar6",            -- 动作条7 (巨龙时代新增)
        "MultiBar7"             -- 动作条8 (巨龙时代新增)
    }
    local alpha = (value and 1) or 0

    for i = 1, #actionBars do
        for j = 1, 12 do
            if _G[actionBars[i].."Button"..j.."Name"] then
                _G[actionBars[i].."Button"..j.."Name"]:SetAlpha(alpha)
            end
        end
    end
end

function Module:SaveRaidFrameCVars()
    local cvars = {}
    for k, v in pairs(RAID_FRAME_CVARS) do
        cvars[k] = GetCVar(k)
    end
    SanluliUtils:SetConfig(Module.name, CONFIG_SYNC_RAID_FRAME_CVARS, cvars)
end

function Module:SaveActionBarCVars()
    local cvars = {}
    for k, v in pairs(ACTION_BAR_CVARS) do
        cvars[k] = GetCVar(k)
    end
    self:SetConfig(Module.name, CONFIG_SYNC_ACTION_BAR_CVARS, cvars)
end

function Module:CVAR_UPDATE(name, value)
    if Module:GetConfig(CONFIG_SYNC_RAID_FRAME_ENABLE) and RAID_FRAME_CVARS[name] then
        local cvars = Module:GetConfig(CONFIG_SYNC_RAID_FRAME_CVARS)
        if cvars then
            cvars[name] = value
        else
            self:SaveRaidFrameCVars()
        end
    elseif Module:GetConfig(CONFIG_SYNC_ACTION_BAR_ENABLE) and ACTION_BAR_CVARS[name] then
        local cvars = Module:GetConfig(CONFIG_SYNC_ACTION_BAR_CVARS)
        if cvars then
            cvars[name] = value
        else
            self:SaveActionBarCVars()
        end
    end
end
Module:RegisterEvent("CVAR_UPDATE")

function Module:Startup()
    if Module:GetConfig(CONFIG_HIDE_ACTION_BAR_NAME) then
        self:SetActionBarNameDisplay(false)
    end
    if Module:GetConfig(CONFIG_SYNC_RAID_FRAME_ENABLE) then
        local cvars = Module:GetConfig(CONFIG_SYNC_RAID_FRAME_CVARS)
        if cvars then
            for k, v in pairs(cvars) do
                SetCVar(k, v)
            end
        else
            self:SaveRaidFrameCVars()
        end
    end
    if Module:GetConfig(CONFIG_SYNC_ACTION_BAR_ENABLE) then
        local cvars = Module:GetConfig(CONFIG_SYNC_ACTION_BAR_CVARS)
        if cvars then
            for k, v in pairs(cvars) do
                SetCVar(k, v)
            end
        else
            self:SaveActionBarCVars()
        end
    end
end