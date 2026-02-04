local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("automatic.unequipTeleportEquipment")
local L = SanluliUtils.Locale

local CONFIG_ENABLE = "enable"

local TELEPORT_EQUIPMENTS = {
    [11] = {    -- 手指
        -- 达拉然(晶歌森林) 30min
        [40585] = true,     -- 肯瑞托徽记
        [40586] = true,     -- 肯瑞托指环
        [44934] = true,     -- 肯瑞托指箍
        [44935] = true,     -- 肯瑞托戒指
        [45688] = true,     -- 肯瑞托铭文指环
        [45689] = true,     -- 肯瑞托铭文指箍
        [45690] = true,     -- 肯瑞托铭文戒指
        [45691] = true,     -- 肯瑞托铭文徽记
        [48954] = true,     -- 肯瑞托铭刻指环
        [48955] = true,     -- 肯瑞托铭刻指箍
        [48956] = true,     -- 肯瑞托铭刻戒指
        [48957] = true,     -- 肯瑞托铭刻徽记
        [51557] = true,     -- 肯瑞托符文徽记
        [51558] = true,     -- 肯瑞托符文戒指
        [51559] = true,     -- 肯瑞托符文佩戒
        [51560] = true,     -- 肯瑞托符文指环
        -- 达拉然(破碎群岛) 30min
        [139599] = true,    -- 肯瑞托强化指环
        -- 比兹莫搏击俱乐部 联盟 1h
        [95051] = true,     -- 黄铜指虎
        [118907] = true,    -- 格斗士的重击指环
        [144391] = true,    -- 拳手的重击指环
        -- 比兹莫搏击俱乐部 部落 1h
        [95050] = true,     -- 黄铜指虎
        [118908] = true,    -- 格斗士的重击指环
        [144392] = true,    -- 拳手的重击指环
        -- 其他
        [142469] = true,    -- 魔导大师的紫罗兰印戒 (卡拉赞, 4h)
        [166559] = true,    -- 指挥官的战斗玺戒 (达萨罗, 30min)
        [166560] = true,    -- 船长的指挥玺戒 (伯拉勒斯, 30min)
    },
    [15] = {    -- 披风
        [63206] = true, -- 协和披风 (暴风城, 4h)
        [63207] = true, -- 协和披风 (奥格瑞玛, 4h)
        [65274] = true, -- 协同披风 (奥格瑞玛, 2h)
        [63352] = true, -- 协作披风 (暴风城, 8h)
        [63353] = true, -- 协作披风 (奥格瑞玛, 8h)
        [65360] = true, -- 协同披风 (暴风城, 2h)
    }
}

TELEPORT_EQUIPMENTS[12] = TELEPORT_EQUIPMENTS[11]

local equipmentItems = {}
local waitingCombatLockdown = false

local function CheckTeleportEquipment()
    for i = 1, 17 do
        if TELEPORT_EQUIPMENTS[i] and TELEPORT_EQUIPMENTS[i][GetInventoryItemID("player", i)] then
            local itemLink = GetInventoryItemLink("player", i)

            if not equipmentItems[i] then
                SanluliUtils:Print(L["automatic.unequipTeleportEquipment.message.noPrevious"]:format(itemLink))
            else
                SanluliUtils:Print(L["automatic.unequipTeleportEquipment.message"]:format(itemLink))
                C_Item.EquipItemByName(equipmentItems[i], i)
            end
        end
    end
end

function Module:ITEM_LOCK_CHANGED(slotIndex, slotIndex2)
    if slotIndex and not slotIndex2 then
        local itemId = GetInventoryItemID("player", slotIndex)

        if TELEPORT_EQUIPMENTS[slotIndex] then
            if TELEPORT_EQUIPMENTS[slotIndex][itemId] then
                -- 换上传送物品时忽略
            else
                -- 记录每次更换的装备
                equipmentItems[slotIndex] = GetInventoryItemLink("player", slotIndex)
            end
        end
    end
end
Module:RegisterEvent("ITEM_LOCK_CHANGED")

function Module:PLAYER_ENTERING_WORLD()
    if self:GetConfig(CONFIG_ENABLE) then
        if InCombatLockdown() then
            waitingCombatLockdown = true
            return
        else
            CheckTeleportEquipment()
        end
    end
end
Module:RegisterEvent("PLAYER_ENTERING_WORLD")

function Module:PLAYER_REGEN_ENABLED()
    if self:GetConfig(CONFIG_ENABLE) and waitingCombatLockdown then
        waitingCombatLockdown = false
        CheckTeleportEquipment()
    end
end
Module:RegisterEvent("PLAYER_REGEN_ENABLED")