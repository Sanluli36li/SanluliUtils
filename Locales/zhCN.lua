if not(GetLocale() == "zhCN") then
    return
end

local ADDON_NAME, SanluliUtils = ...

local L = SanluliUtils.Locale

L["addon.name"] = "SanluliUtils"
L["addon.test.title"] = "|cffff0000(测试)|r"
L["addon.test.tooltip"] = "\n|cffff0000测试功能, 无法保证它能按预期效果运作|r"
L["addons.simulationcraft.title"] = "SimulationCraft"
L["addons.simulationcraft.forceHideMinimap.title"] = "总是隐藏Simc小地图按钮"
L["addons.title"] = "插件增强"
L["blizzardui.actionBar.hideName.title"] = "隐藏动作条按钮名称"
L["blizzardui.actionBar.hideName.tooltip"] = "隐藏暴雪动作条上的宏、装备方案等按钮的名称"
L["blizzardui.actionBar.title"] = "动作条"
L["blizzardui.forceShowPowerBarAltStatus.title"] = "总是显示额外能量条状态"
L["blizzardui.forceShowPowerBarAltStatus.tooltip"] = "在额外能量条的Boss战(例如: 恩佐斯)或区域中, 总是显示能量数值"
L["blizzardui.sync.actionBar.title"] = "同步动作条配置"
L["blizzardui.sync.actionBar.tooltip"] = "\""..SETTING_GROUP_GAMEPLAY.." -> "..ACTIONBARS_LABEL.."\"分页的选项将同步到你的其他角色上"
L["blizzardui.sync.raidFrame.title"] = "同步团队框体配置"
L["blizzardui.sync.raidFrame.tooltip"] = "\""..SETTING_GROUP_GAMEPLAY.." -> "..INTERFACE_LABEL.." -> "..RAID_FRAMES_LABEL.."\"分组的选项将同步到你的其他角色上"
L["blizzardui.title"] = "暴雪界面"
L["client.disabledOverrideArchive.message.disabled"] = "已启用反和谐, |cffff0000重启游戏|r后生效"
L["client.disabledOverrideArchive.message.enabled"] = "已禁用反和谐, |cffff0000重启游戏|r后生效"
L["client.overrideArchive.disable.title"] = "反和谐|cffff0000(需要重启游戏)|r"
L["client.overrideArchive.disable.tooltip"] = [[
因为一些众所周知的原因, 简体中文的客户端的一部分模型被和谐了, 该选项能够将这些被替换掉的模型变回它们原有的样子
被和谐的图标不受影响, 如果你想反和谐这些图标, 请下载材质包

|cffff0000这个选项需要重启客户端|r
]]
L["client.overrideArchive.enable.title"] = "减轻暴力表现|cffff0000(需要重启游戏)|r"
L["client.overrideArchive.enable.tooltip"] = "通常情况下, 你应该看不见这个选项"
L["client.profanityFilter.message.disabled"] = "已禁用语言过滤器"
L["client.profanityFilter.message.enabled"] = "已启用语言过滤器"
L["client.profanityFilter.title"] = "语言过滤器|cffff0000(强制更改)|r"
L["client.profanityFilter.tooltip"] = "|cffff0000注: 因国服将语言过滤器选项强制开启, 此功能需要配合地区误导使用|r\n强制修改 \"游戏功能 -> "..SOCIAL_LABEL.." -> "..PROFANITY_FILTER.."\" 选项"
L["client.regionDeceive.differentRegionFix.message.fixed"] = "已修复好友列表\"不同的地区\"Bug"
L["client.regionDeceive.differentRegionFix.message.restored"] = "已恢复好友列表"
L["client.regionDeceive.differentRegionFix.title"] = "修复好友列表\"不同的地区\"Bug"
L["client.regionDeceive.differentRegionFix.tooltip"] = "修复客户端地区与实际服务器所在地区不同, 好友列表提示\"不同的地区\", 从而无法组队的问题"
L["client.regionDeceive.message.disabled"] = "已禁用客户端区域误导"
L["client.regionDeceive.message.enabled"] = "已启用客户端区域误导"
-- L["client.regionDeceive.temporarilyDisabled.dialogs.onshow"] = "警告: 客户端区域误导功能可能导致"..HELP_FRAME_TITLE.."界面无法使用(黑屏或一直转圈), 若你需要客服支持, 单击\""..YES.."\"暂时禁用此功能并重载界面。"
-- L["client.regionDeceive.temporarilyDisabled.dialogs.onhide"] = "你已经关闭了"..HELP_FRAME_TITLE.."界面, 你想恢复地区误导功能和语言过滤器功能吗?"
-- L["client.regionDeceive.temporarilyDisabled.message.enabled"] = "已临时禁用客户端区域误导功能，下次重载/登录时恢复"
L["client.regionDeceive.title"] = "客户端地区误导"
L["client.regionDeceive.tooltip"] = "|cffff0000仅中国大陆服务器可用|r\n将客户端区域设置为其他地区, 从而解锁部分国服锁定的选项。\n使用此功能时, 请开启下方的\"修复'不同的地区'Bug\"选项, 否则可能导致好友列表出现Bug。"
L["client.title"] = "客户端"
L["general.autoInputConfirm.title"] = "自动输入确认内容"
L["general.autoInputConfirm.tooltip"] = "在一些需要确认的提示框中自动输入确认内容\n(例如: 删除物品时输入\"DELETE\")\n|cffff0000请在按下\""..YES.."\"按钮前再三确认你在做什么！|r"
L["general.autoRepair.funds.guild.title"] = "优先使用公会资金"
L["general.autoRepair.funds.guild.tooltip"] = "优先使用公会银行的资金修理装备，额度不足时使用你自己的金币"
L["general.autoRepair.funds.personal.title"] = "自费维修"
L["general.autoRepair.funds.personal.tooltip"] = "总是使用你自己的金币修理装备"
L["general.autoRepair.message.guild"] = "公会"
L["general.autoRepair.message.guildExhausted"] = "公会修理额度已用尽"
L["general.autoRepair.message.oom"] = "修理费不足, 需要 %s"
L["general.autoRepair.message.repaired"] = "已自动修理, 花费: %s"
L["general.autoRepair.title"] = "自动修理"
L["general.autoRepair.tooltip"] = "当打开商人界面时, 自动修理所有装备"
L["general.autoSellJunk.message.sold"] = "已出售 %s件物品, 总价 %s"
L["general.autoSellJunk.method.12Items.title"] = "每次仅出售12件垃圾"
L["general.autoSellJunk.method.12Items.tooltip"] = "打开商人界面时将出售12件垃圾, 它们可以被购回(避免出售掉一些具有特殊意义的物品)"
L["general.autoSellJunk.method.allItems.title"] = "出售所有垃圾"
L["general.autoSellJunk.method.allItems.tooltip"] = "打开商人界面时将出售所有垃圾, 超出12件物品的部分将无法购回"
L["general.autoSellJunk.method.blizzard.title"] = "出售所有垃圾(不可购回)"
L["general.autoSellJunk.method.blizzard.tooltip"] = "打开商人界面时将出售所有垃圾, 一次出售超过1件垃圾时, 这些垃圾都无法购回(使用暴雪内置的方法, 等效于点击出售垃圾按钮并确认)"
L["general.autoSellJunk.title"] = "自动出售垃圾"
L["general.autoSellJunk.tooltip"] = "打开商人界面时自动出售灰色品质的物品\n标记为\"忽略此背包->出售垃圾\"的背包将被忽略"
L["general.fasterAutoLoot.title"] = "更快的自动拾取"
L["general.fasterAutoLoot.tooltip"] = "自动拾取将更快地拾取所有物品\n需要开启\"控制->自动拾取\"或使用自动拾取键"
L["general.title"] = "常规选项"