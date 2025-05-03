local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("automatic.autoCancelLFGApplication")
local L = SanluliUtils.Locale

local CONFIG_ENABLE = "enable"

local function LFGCancelInvaildApplications()
    local apps = C_LFGList.GetApplications()
    for i, resultID in ipairs(apps) do
        local resultData = C_LFGList.GetSearchResultInfo(resultID)
    
        if resultData.activityIDs and resultData.activityIDs[1] then
            local activityInfo = C_LFGList.GetActivityInfoTable(resultData.activityIDs[1])
            local _, appStatus, pendingStatus, appDuration = C_LFGList.GetApplicationInfo(resultID)
            if activityInfo.isMythicPlusActivity and appStatus == "applied" then
                local memberCount = C_LFGList.GetSearchResultMemberCounts(resultID)
                local _, tank, healer, dps = GetLFGRoles()
                -- print(resultID, activityInfo.fullName, memberCount.TANK_REMAINING, memberCount.HEALER_REMAINING, memberCount.DAMAGER_REMAINING)
                if not (
                    (tank and memberCount.TANK_REMAINING ~= 0) or
                    (healer and memberCount.HEALER_REMAINING ~= 0)or
                    (dps and memberCount.DAMAGER_REMAINING ~= 0)
                )
                then
                    SanluliUtils:Print(string.format("已取消申请%s, 因为已选择的职责已满", activityInfo.fullName))
                    C_LFGList.CancelApplication(resultID)
                end
            end
        end
    end
end

function Module:AfterLogin()
    if C_AddOns.IsAddOnLoaded("MeetingStone") then
        -- 集合石插件 单击队伍条目
        LibStub('AceAddon-3.0'):GetAddon("MeetingStone"):GetModule("BrowsePanel").ActivityList:SetCallback("OnItemClick", function()
            if Module:GetConfig(CONFIG_ENABLE) then
                LFGCancelInvaildApplications()
            end
        end)
    end
end