local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("blizzardui.actionBar")
local L = SanluliUtils.Locale

local CONFIG_HIDE_ACTION_BAR_NAME = "hideName"
local CONFIG_HIDE_ACTION_BAR_HOTKEY = "hideHotkey"

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

function Module:AfterLogin()
    if self:GetConfig(CONFIG_HIDE_ACTION_BAR_NAME) then
        self:SetActionBarNameDisplay(false)
    end
    if self:GetConfig(CONFIG_HIDE_ACTION_BAR_HOTKEY) then
        self:SetActionBarHotKeyDisplay(false)
    end
end