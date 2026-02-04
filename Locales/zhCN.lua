if not(GetLocale() == "zhCN") then
    return
end

local ADDON_NAME, SanluliUtils = ...

local L = SanluliUtils.Locale

L["addon.name"] = "SanluliUtils"
L["addon.test.title"] = "|cffff0000(测试)|r"
L["addon.test.tooltip"] = "|cffff0000此功能仍然需要测试, 无法保证它能按预期效果运作|r"
L["addons.simulationcraft.title"] = "SimulationCraft"
L["addons.simulationcraft.forceHideMinimap.title"] = "总是隐藏Simc小地图按钮"
L["addons.title"] = "插件增强"
L["automatic.autoCombatlog.difficulty.all"] = "所有难度"
L["automatic.autoCombatlog.difficulty.heroic"] = "英雄及更高难度"
L["automatic.autoCombatlog.difficulty.mythic"] = "史诗及更高难度"
L["automatic.autoCombatlog.difficulty.mythicPlus"] = "史诗钥石"
L["automatic.autoCombatlog.difficulty.mythicRaid"] = "史诗难度"
L["automatic.autoCombatlog.difficulty.normal"] = "普通及更高难度"
L["automatic.autoCombatlog.dungeon.title"] = "地下城难度"
L["automatic.autoCombatlog.dungeon.tooltip"] = "需要自动开启战斗日志的地下城难度"
L["automatic.autoCombatlog.raid.title"] = "团队副本难度"
L["automatic.autoCombatlog.raid.tooltip"] = "需要自动开启战斗日志的团队副本难度"
L["automatic.autoCombatlog.title"] = "自动战斗日志"
L["automatic.autoCombatlog.tooltip"] = "进入副本时自动开启战斗日志\n\n战斗日志将保存在\"Logs/WoWCombatLog\"中\n|cffff0000只有当你需要保存战斗日志才应该开启此功能(比如上传到WarcraftLogs或raider.io等)\n战斗日志会占用硬盘空间, 请定期清理|r\n|cffffffff在激活了经典分配规则的副本中不会生效|r"
L["automatic.autoInputConfirm.title"] = "自动输入确认内容"
L["automatic.autoInputConfirm.tooltip"] = "在一些需要确认的提示框中自动输入确认内容\n(例如: 删除物品时输入\"DELETE\")\n|cffff0000请在按下\""..YES.."\"按钮前再三确认你在做什么！|r"
L["automatic.autoRepair.funds.guild.title"] = "优先使用公会资金"
L["automatic.autoRepair.funds.guild.tooltip"] = "优先使用公会银行的资金修理装备，额度不足时使用你自己的金币"
L["automatic.autoRepair.funds.personal.title"] = "自费维修"
L["automatic.autoRepair.funds.personal.tooltip"] = "总是使用你自己的金币修理装备"
L["automatic.autoRepair.message.guild"] = "公会"
L["automatic.autoRepair.message.guildExhausted"] = "公会修理额度已用尽"
L["automatic.autoRepair.message.oom"] = "修理费不足, 需要 %s"
L["automatic.autoRepair.message.repaired"] = "已自动修理, 花费: %s"
L["automatic.autoRepair.title"] = "自动修理"
L["automatic.autoRepair.tooltip"] = "当打开商人界面时, 自动修理所有装备"
L["automatic.autoRoll.message.greed"] = "已自动选择贪婪: %s"
L["automatic.autoRoll.message.pass"] = "已自动选择放弃: %s"
L["automatic.autoRoll.message.transmog"] = "已自动选择幻化: %s"
L["automatic.autoRoll.method.greed.title"] = "自动贪婪"
L["automatic.autoRoll.method.greed.tooltip"] = "若你不能需求: 若该物品能够幻化, 选择幻化取向; 否则选择贪婪取向"
L["automatic.autoRoll.method.pass.title"] = "自动放弃"
L["automatic.autoRoll.method.pass.tooltip"] = "若你不能需求: 则总是放弃该物品"
L["automatic.autoRoll.title"] = "自动贪婪"
L["automatic.autoRoll.tooltip"] = "当你的队伍拾取一件物品等待Roll点, 且你|cffff0000不能需求|r该物品时, 自动投掷骰子\n\n|cffff0000对于你能够需求的物品, 你仍然需要自行决定如何投掷骰子|r"
L["automatic.autoSellJunk.message.sold"] = "已出售 %s件物品, 总价 %s"
L["automatic.autoSellJunk.method.12Items.title"] = "每次仅出售12件垃圾"
L["automatic.autoSellJunk.method.12Items.tooltip"] = "打开商人界面时将出售12件垃圾, 它们可以被购回(避免出售掉一些具有特殊意义的物品)"
L["automatic.autoSellJunk.method.allItems.title"] = "出售所有垃圾"
L["automatic.autoSellJunk.method.allItems.tooltip"] = "打开商人界面时将出售所有垃圾, 超出12件物品的部分将无法购回"
L["automatic.autoSellJunk.method.blizzard.title"] = "出售所有垃圾(不可购回)"
L["automatic.autoSellJunk.method.blizzard.tooltip"] = "打开商人界面时将出售所有垃圾, 一次出售超过1件垃圾时, 这些垃圾都无法购回(使用暴雪内置的方法, 等效于点击出售垃圾按钮并确认)"
L["automatic.autoSellJunk.title"] = "自动出售垃圾"
L["automatic.unequipTeleportEquipment.message"] = "已自动换下传送装备: %s"
L["automatic.unequipTeleportEquipment.message.noPrevious"] = "你现在装备着传送物品%s, 请注意更换"
L["automatic.unequipTeleportEquipment.title"] = "自动脱下传送装备"
L["automatic.unequipTeleportEquipment.tooltip"] = "在传送后，自动脱下身上的传送装备"
L["automatic.autoSellJunk.tooltip"] = "打开商人界面时自动出售灰色品质的物品\n标记为\"忽略此背包->出售垃圾\"的背包将被忽略"
L["automatic.fasterAutoLoot.title"] = "更快的自动拾取"
L["automatic.fasterAutoLoot.tooltip"] = "自动拾取将更快地拾取所有物品\n需要开启\"控制->自动拾取\"或使用自动拾取键"
L["automatic.title"] = "常规选项"
L["blizzardui.actionBar.hideHotkey.title"] = "隐藏动作条快捷键"
L["blizzardui.actionBar.hideHotkey.tooltip"] = "隐藏暴雪动作条上的快捷键"
L["blizzardui.actionBar.hideName.title"] = "隐藏动作条按钮名称"
L["blizzardui.actionBar.hideName.tooltip"] = "隐藏暴雪动作条上的宏、装备方案等按钮的名称"
L["blizzardui.actionBar.title"] = "动作条"
L["blizzardui.forceShowPowerBarAltStatus.title"] = "总是显示额外能量条状态"
L["blizzardui.forceShowPowerBarAltStatus.tooltip"] = "在额外能量条的Boss战(例如: 恩佐斯)或区域中, 总是显示能量数值"
L["blizzardui.sync.actionBar.dialogs.noTaint"] = "动作条配置已变更, 建议|cffff0000重新加载界面|r, 否则有可能导致动作条污染\n单击\""..YES.."\"重新加载界面"
L["blizzardui.sync.actionBar.title"] = "同步动作条配置"
L["blizzardui.sync.actionBar.tooltip"] = "\""..SETTING_GROUP_GAMEPLAY.." -> "..ACTIONBARS_LABEL.."\"分页的选项将同步到你的其他角色上\n|cffff0000注意: 插件污染可能会在你更改动作条开关设置并同步到其他角色后出现, 只要在被同步的角色登录后/reload一次便不再发生|r"
L["blizzardui.sync.raidFrame.title"] = "同步团队框体配置"
L["blizzardui.sync.raidFrame.tooltip"] = "\""..SETTING_GROUP_GAMEPLAY.." -> "..INTERFACE_LABEL.." -> "..RAID_FRAMES_LABEL.."\"分组的选项将同步到你的其他角色上"
L["blizzardui.title"] = "暴雪界面"
L["client.blzAddonProfiler.disable.title"] = "禁用暴雪插件性能分析"
L["client.blzAddonProfiler.disable.tooltip"] = "禁用暴雪在11.1.0中引入的新的可能导致掉帧的插件性能分析功能"
L["client.blzAddonProfiler.message.disabled"] = "已禁用插件性能分析"
L["client.blzAddonProfiler.message.enabled"] = "已启用插件性能分析"
L["client.disabledOverrideArchive.message.disabled"] = "已启用反和谐, |cffff0000重启游戏|r后生效"
L["client.disabledOverrideArchive.message.enabled"] = "已禁用反和谐, |cffff0000重启游戏|r后生效"
L["client.overrideArchive.disable.title"] = "反和谐|cffff0000(需要重启游戏)|r"
L["client.overrideArchive.disable.tooltip"] = [[
因为一些众所周知的原因, 简体中文的客户端的一部分模型被和谐了, 该选项能够将这些被替换掉的模型变回它们原有的样子
被和谐的图标不受影响, 如果你想反和谐这些图标, 请下载材质包

|cffff0000这个选项需要重启客户端|r
]]
L["client.overrideArchive.enable.title"] = "减轻暴力表现|cffff0000(需要重启游戏)|r"
L["client.overrideArchive.enable.tooltip"] = [[
启用游戏内建的替换模型包 (默认情况下, 它应该被应用于简体中文语言)

具体效果:
1) 当玩家被复活时，原本遗留的骷髅骨架将被替换为坟墓模型
2) 亡灵种族模型将拥有完整皮肤外观
3) 血液效果将被替换为灰色
以及更多未提及的改动...

如果该选项未生效，您可能需要将游戏语言切换为简体中文，等待完成数据下载后，再切换回您原来的语言版本。

|cffff0000这个选项需要重启客户端|r
]]
L["client.profanityFilter.title"] = "语言过滤器|cffff0000(强制修改)|r"
L["client.title"] = "客户端"
L["social.chat.bnPlayerLink.title"] = "战网聊天名称格式"
L["social.chat.bnPlayerLink.tooltip"] = "与战网好友聊天时, 修改玩家链接的格式"
L["social.chat.hyperlinkEnhance.applyToGuildNews.title"] = "应用于公会新闻"
L["social.chat.hyperlinkEnhance.applyToGuildNews.tooltip"] = "公会新闻的物品链接也会被替换"
L["social.chat.hyperlinkEnhance.displayIcon.title"] = "显示图标"
L["social.chat.hyperlinkEnhance.displayIcon.tooltip"] = "在物品、法术、坐骑链接前加入它们的图标"
L["social.chat.hyperlinkEnhance.displayItemLevel.title"] = "显示物品等级"
L["social.chat.hyperlinkEnhance.displayItemLevel.tooltip"] = "在物品链接前显示其物品等级"
L["social.chat.hyperlinkEnhance.displayItemType.title"] = "显示物品分类"
L["social.chat.hyperlinkEnhance.displayItemType.tooltip"] = "在物品链接前显示其分类"
L["social.chat.hyperlinkEnhance.displaySockets.title"] = "显示插槽"
L["social.chat.hyperlinkEnhance.displaySockets.tooltip"] = "在物品链接后显示插槽信息"
L["social.chat.hyperlinkEnhance.title"] = "聊天链接增强"
L["social.chat.hyperlinkEnhance.tooltip"] = "在聊天信息中的链接里添加更多信息"
L["social.chat.tabSwitch.title"] = "Tab快速切换聊天频道"
L["social.chat.tabSwitch.tooltip"] = "在聊天框中按Tab键快速在\"|cffffffff说|r\"、\"|cffaaaaff小队|r\"、\"|cffff7f00团队|r\"、\"|cffff7f00副本|r\"、\"|cff40ff40公会|r\"、\"|cff40c040官员|r\"频道中切换(只对你加入的频道有效)"
L["social.friendsList.characterNameClassColor.sameProjectId.title"] = "忽略其他版本"
L["social.friendsList.characterNameClassColor.sameProjectId.tooltip"] = "正在游玩其他版本《魔兽世界》的好友角色名使用默认的灰色"
L["social.friendsList.characterNameClassColor.title"] = "角色名职业染色"
L["social.friendsList.characterNameClassColor.tooltip"] = "好友列表的角色名将显示为职业颜色"
L["social.friendsList.title"] = "好友列表"
L["social.privacyMode.hideBattleNetFriendsRealName.title"] = "隐藏好友真实姓名"
L["social.privacyMode.hideBattleNetFriendsRealName.tooltip"] = "你的战网实名好友在好友列表及一些其他地方将显示战网昵称而不是真实姓名, 这可以以避免在直播等场合中泄露隐私信息\n这同时也能解决好友列表部分好友显示为数字(例如：1、2、3)的问题"
L["social.privacyMode.hideBattleNetTagSuffix.title"] = "隐藏战网昵称后缀"
L["social.privacyMode.hideBattleNetTagSuffix.tooltip"] = "好友列表顶部的战网昵称将被隐藏, 以避免在直播等场合中泄露隐私信息"
L["social.title"] = SOCIAL_LABEL
