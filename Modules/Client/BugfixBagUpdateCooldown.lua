local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("client.bugfix.bagUpdateCooldown")
local L = SanluliUtils.Locale

local updatedThisFrame = {}

-- 每一帧清除记录
local frame = CreateFrame("FRAME")
frame:SetScript("OnUpdate", function(self, elapsed)
    wipe(updatedThisFrame)
end)

local function ContainerFrame_OnEvent_Limited(self, event, ...)
    if event == "BAG_UPDATE_COOLDOWN" then
        if not updatedThisFrame[self] then
            ContainerFrame_OnEvent(self, event, ...)
            updatedThisFrame[self] = true
        end
    else
        ContainerFrame_OnEvent(self, event, ...)
    end
end

function Module:AfterLogin()
    if Module:GetConfig() then
        ContainerFrameCombinedBags:SetScript("OnEvent", ContainerFrame_OnEvent_Limited)
        ContainerFrame1:SetScript("OnEvent", ContainerFrame_OnEvent_Limited)
        ContainerFrame2:SetScript("OnEvent", ContainerFrame_OnEvent_Limited)
        ContainerFrame3:SetScript("OnEvent", ContainerFrame_OnEvent_Limited)
        ContainerFrame4:SetScript("OnEvent", ContainerFrame_OnEvent_Limited)
        ContainerFrame5:SetScript("OnEvent", ContainerFrame_OnEvent_Limited)
        ContainerFrame6:SetScript("OnEvent", ContainerFrame_OnEvent_Limited)
        -- ContainerFrame7:SetScript("OnEvent", ContainerFrame_OnEvent_Limited)
        -- ContainerFrame8:SetScript("OnEvent", ContainerFrame_OnEvent_Limited)
        -- ContainerFrame9:SetScript("OnEvent", ContainerFrame_OnEvent_Limited)
        -- ContainerFrame10:SetScript("OnEvent", ContainerFrame_OnEvent_Limited)
        -- ContainerFrame11:SetScript("OnEvent", ContainerFrame_OnEvent_Limited)
        -- ContainerFrame12:SetScript("OnEvent", ContainerFrame_OnEvent_Limited)
        -- ContainerFrame13:SetScript("OnEvent", ContainerFrame_OnEvent_Limited)
    end
end


