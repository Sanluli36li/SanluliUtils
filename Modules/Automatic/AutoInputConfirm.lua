local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("automatic.autoInputConfirm")
local L = SanluliUtils.Locale

local CONFIG_ENABLE = "enable"

local CONFIRM_STRINGS = {
    ["CONFIRM_AZERITE_EMPOWERED_RESPEC_EXPENSIVE"] = CONFIRM_AZERITE_EMPOWERED_RESPEC_STRING,   -- BfA 特质装高价重铸
    ["DELETE_GOOD_ITEM"] = DELETE_ITEM_CONFIRM_STRING,                                          -- 删除物品
    ["DELETE_GOOD_QUEST_ITEM"] = DELETE_ITEM_CONFIRM_STRING,                                    -- 删除任务物品
    ["CONFIRM_DESTROY_COMMUNITY"] = COMMUNITIES_DELETE_CONFIRM_STRING,                          -- 删除社区
    ["UNLEARN_SKILL"] = UNLEARN_SKILL_CONFIRMATION,                                             -- 忘却专业
    ["CONFIRM_RAF_REMOVE_RECRUIT"] = REMOVE_RECRUIT_CONFIRM_STRING,                             -- 移除战友招募
}


for dialogName, confirmString in pairs(CONFIRM_STRINGS) do
    hooksecurefunc(StaticPopupDialogs[dialogName], "OnShow", function(self)
        if Module:GetConfig(CONFIG_ENABLE) then
            self.editBox:SetText(confirmString)
        end
    end)
end