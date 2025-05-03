local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("social.chat.tabSwitch")
local L = SanluliUtils.Locale

local CONFIG_ENABLE = "enable"

local CHAT_TYPE_ID = {
    SAY = 1,
    PARTY = 2,
    RAID = 3,
    INSTANCE_CHAT = 4,
    GUILD = 5,
    OFFICER = 6
}

local CHAT_TYPES = {
    [CHAT_TYPE_ID.SAY] = {              -- 说 (总是使用)
        type = "SAY"
    },
    [CHAT_TYPE_ID.PARTY] = {            -- 小队 (在小队中，且不在团队中(非随机副本队伍))
        type = "PARTY",
        isEnable = function() return IsInGroup(LE_PARTY_CATEGORY_HOME) and not IsInRaid(LE_PARTY_CATEGORY_HOME) end
    },
    [CHAT_TYPE_ID.RAID] = {             -- 团队 (在团队中(非随机副本队伍))
        type = "RAID",
        isEnable = function()
            return IsInRaid(LE_PARTY_CATEGORY_HOME)
        end
    },
    [CHAT_TYPE_ID.INSTANCE_CHAT] = {    -- 副本 (在副本队伍中)
        type = "INSTANCE_CHAT",
        isEnable = function ()
            return IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
        end
    },
    [CHAT_TYPE_ID.GUILD] = {            -- 公会 (在公会中)
        type = "GUILD",
        isEnable = function()
            return IsInGuild()
        end
    },
    [CHAT_TYPE_ID.OFFICER] = {          -- 官员 (是公会官员)
        type = "OFFICER",
        isEnable = function ()
            return C_GuildInfo.IsGuildOfficer()
        end
    }
}

local function TrySetChatType(editBox, id)
    if CHAT_TYPES[id] and (CHAT_TYPES[id].isEnable and CHAT_TYPES[id].isEnable()) or not CHAT_TYPES[id].isEnable then
        editBox:SetAttribute("chatType", CHAT_TYPES[id].type)
        ChatEdit_UpdateHeader(editBox)
        return true
    else
        return false
    end
end

local lastChatType = 1

hooksecurefunc("ChatEdit_OnTabPressed", function(editBox)
    if Module:GetConfig(CONFIG_ENABLE) and editBox == ChatFrame1EditBox then
        if not (strsub(editBox:GetText(), 1, 1) == "/") then    -- "/"开头命令自动补全时不执行
            -- print("Current: ", editBox:GetAttribute("chatType"), CHAT_TYPE_ID[editBox:GetAttribute("chatType")])
            local currentId = CHAT_TYPE_ID[editBox:GetAttribute("chatType")] or 0

            if currentId == 0 then  -- 非循环表中的情况 切换上次TAB切换到的频道, 或切换为“说”
                return TrySetChatType(editBox, lastChatType) or TrySetChatType(editBox, 1)
            else
                local nextId = ((currentId >= #CHAT_TYPES) and 1) or currentId + 1
                while true do
                    if nextId == currentId then -- 循环一圈没有找到下一个, 跳出
                        break
                    elseif TrySetChatType(editBox, nextId) then -- 尝试设置下一个
                        lastChatType = nextId
                        return
                    else                                        -- 下一个不满足条件
                        nextId = ((nextId >= #CHAT_TYPES) and 1) or (nextId + 1)
                    end
                end
            end
        end
    end
end)