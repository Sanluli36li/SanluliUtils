if not(GetLocale() == "zhTW") then
    return
end

local ADDON_NAME, SanluliUtils = ...

local L = SanluliUtils.Locale

L["addon.name"] = "SanluliUtils"
L["addon.test.title"] = "|cffff0000(測試)|r"
L["addon.test.tooltip"] = "|cffff0000此功能仍需要測試，無法保證正常運作|r"
L["addons.simulationcraft.title"] = "SimulationCraft"
L["addons.simulationcraft.forceHideMinimap.title"] = "總是隱藏Simc小地圖按鈕"
L["addons.title"] = "插件增強"
L["automatic.autoCombatlog.difficulty.all"] = "所有難度"
L["automatic.autoCombatlog.difficulty.heroic"] = "英雄及更高難度"
L["automatic.autoCombatlog.difficulty.mythic"] = "史詩及更高難度"
L["automatic.autoCombatlog.difficulty.mythicPlus"] = "傳奇鑰石"
L["automatic.autoCombatlog.difficulty.mythicRaid"] = "史詩團隊"
L["automatic.autoCombatlog.difficulty.normal"] = "普通及更高難度"
L["automatic.autoCombatlog.dungeon.title"] = "地城難度"
L["automatic.autoCombatlog.dungeon.tooltip"] = "需要自動開啟戰鬥紀錄的地城難度"
L["automatic.autoCombatlog.raid.title"] = "團隊副本難度"
L["automatic.autoCombatlog.raid.tooltip"] = "需要自動開啟戰鬥紀錄的團隊副本難度"
L["automatic.autoCombatlog.title"] = "自動戰鬥紀錄"
L["automatic.autoCombatlog.tooltip"] = "進入副本時自動開啟戰鬥紀錄\n\n紀錄將保存在\"Logs/WoWCombatLog\"\n|cffff0000僅在需要保存戰鬥紀錄時開啟（如提交至WarcraftLogs或raider.io）\n長期開啟會佔用硬碟空間，請定期清理|r\n|cffffffff經典分配規則的副本中無效|r"
L["automatic.autoInputConfirm.title"] = "自動輸入確認內容"
L["automatic.autoInputConfirm.tooltip"] = "在需要確認的提示框中自動填入文字\n（例如刪除物品時輸入\"DELETE\"）\n|cffff0000點擊\""..YES.."\"前請務必確認操作！|r"
L["automatic.autoRepair.funds.guild.title"] = "優先使用公會資金"
L["automatic.autoRepair.funds.guild.tooltip"] = "優先使用公會銀行資金修理，額度不足時使用個人金幣"
L["automatic.autoRepair.funds.personal.title"] = "自費修理"
L["automatic.autoRepair.funds.personal.tooltip"] = "始終使用個人金幣修理裝備"
L["automatic.autoRepair.message.guild"] = "公會"
L["automatic.autoRepair.message.guildExhausted"] = "公會修理額度已用盡"
L["automatic.autoRepair.message.oom"] = "修理資金不足，需要 %s"
L["automatic.autoRepair.message.repaired"] = "已自動修理，花費: %s"
L["automatic.autoRepair.title"] = "自動修理"
L["automatic.autoRepair.tooltip"] = "開啟商人介面時自動修理全部裝備"
L["automatic.autoRoll.message.greed"] = "已自動選擇貪婪: %s"
L["automatic.autoRoll.message.pass"] = "已自動選擇放棄: %s"
L["automatic.autoRoll.message.transmog"] = "已自動選擇塑形: %s"
L["automatic.autoRoll.method.greed.title"] = "自動貪婪"
L["automatic.autoRoll.method.greed.tooltip"] = "若無法需求：可塑形物品選擇塑形，否則選擇貪婪"
L["automatic.autoRoll.method.pass.title"] = "自動放棄"
L["automatic.autoRoll.method.pass.tooltip"] = "若無法需求：始終放棄該物品"
L["automatic.autoRoll.title"] = "自動貪婪"
L["automatic.autoRoll.tooltip"] = "當隊伍拾取物品需擲骰且你|cffff0000無法需求|r時自動選擇\n\n|cffff0000可需求的物品仍需手動選擇|r"
L["automatic.autoSellJunk.message.sold"] = "已出售 %s 件物品，共獲得 %s"
L["automatic.autoSellJunk.method.12Items.title"] = "每次僅出售12件垃圾"
L["automatic.autoSellJunk.method.12Items.tooltip"] = "出售後可買回（避免誤售特殊物品）"
L["automatic.autoSellJunk.method.allItems.title"] = "出售全部垃圾"
L["automatic.autoSellJunk.method.allItems.tooltip"] = "超出12件的物品將無法買回"
L["automatic.autoSellJunk.method.blizzard.title"] = "暴雪式出售（無法買回）"
L["automatic.autoSellJunk.method.blizzard.tooltip"] = "使用內建方法批量出售（等效點擊垃圾出售按鈕）"
L["automatic.autoSellJunk.title"] = "自動出售垃圾"
L["automatic.autoSellJunk.tooltip"] = "自動出售灰色物品\n忽略標記「不處理此背包」的容器"
L["automatic.fasterAutoLoot.title"] = "快速自動拾取"
L["automatic.fasterAutoLoot.tooltip"] = "加速拾取過程\n需開啟「控制->自動拾取」"
L["automatic.title"] = "常規選項"
L["blizzardui.actionBar.hideHotkey.title"] = "隱藏快捷鍵文字"
L["blizzardui.actionBar.hideHotkey.tooltip"] = "隱藏暴雪動作條上的快捷鍵提示"
L["blizzardui.actionBar.hideName.title"] = "隱藏按鈕名稱"
L["blizzardui.actionBar.hideName.tooltip"] = "隱藏巨集/裝備管理等按鈕的名稱"
L["blizzardui.actionBar.title"] = "動作條"
L["blizzardui.forceShowPowerBarAltStatus.title"] = "總是顯示能量條狀態"
L["blizzardui.forceShowPowerBarAltStatus.tooltip"] = "在恩佐斯等特殊戰鬥中強制顯示能量數值"
L["blizzardui.sync.actionBar.title"] = "同步動作條設定"
L["blizzardui.sync.actionBar.tooltip"] = "\""..SETTING_GROUP_GAMEPLAY.." -> "..ACTIONBARS_LABEL.."\"設定將跨角色同步\n|cffff0000注意：變更後可能需要/reload|r"
L["blizzardui.sync.raidFrame.title"] = "同步團隊框架設定"
L["blizzardui.sync.raidFrame.tooltip"] = "\""..SETTING_GROUP_GAMEPLAY.." -> "..INTERFACE_LABEL.." -> "..RAID_FRAMES_LABEL.."\"設定將跨角色同步"
L["blizzardui.title"] = "暴雪介面"
L["client.blzAddonProfiler.disable.title"] = "停用插件性能分析"
L["client.blzAddonProfiler.disable.tooltip"] = "停用11.1.0新增的可能導致卡頓的分析功能"
L["client.blzAddonProfiler.message.disabled"] = "已停用插件性能分析"
L["client.blzAddonProfiler.message.enabled"] = "已啟用插件性能分析"
L["client.disabledOverrideArchive.message.disabled"] = "反和諧已啟用，|cffff0000需重啟遊戲|r"
L["client.disabledOverrideArchive.message.enabled"] = "反和諧已停用，|cffff0000需重啟遊戲|r"
L["client.overrideArchive.disable.title"] = "反和諧|cffff0000(需重啟)|r"
L["client.overrideArchive.disable.tooltip"] = [[
還原簡體客戶端被修改的模型
（圖標需額外材質包）

|cffff0000需要重啟客戶端|r
]]
L["client.overrideArchive.enable.title"] = "啟用和諧版|cffff0000(需重啟)|r"
L["client.overrideArchive.enable.tooltip"] = [[
啟用官方和諧內容（簡體客戶端預設）

具體效果:
1) 復活時顯示墓碑而非骷髏
2) 亡靈種族完整皮膚
3) 血液效果替換為灰色
更多隱藏改動...

若未生效，請切換遊戲語言至簡體中文並下載完整資源後切回

|cffff0000需要重啟客戶端|r
]]
L["client.profanityFilter.title"] = "語言過濾器|cffff0000(強制修改)|r"
L["client.title"] = "客戶端"
L["social.chat.bnPlayerLink.title"] = "戰網名稱格式"
L["social.chat.bnPlayerLink.tooltip"] = "修改戰網好友的玩家連結顯示方式"
L["social.chat.hyperlinkEnhance.applyToGuildNews.title"] = "應用至公會新聞"
L["social.chat.hyperlinkEnhance.applyToGuildNews.tooltip"] = "同時修改公會新聞的物品連結"
L["social.chat.hyperlinkEnhance.displayIcon.title"] = "顯示圖示"
L["social.chat.hyperlinkEnhance.displayIcon.tooltip"] = "在連結前添加物品/法術圖示"
L["social.chat.hyperlinkEnhance.displayItemLevel.title"] = "顯示物品等級"
L["social.chat.hyperlinkEnhance.displayItemLevel.tooltip"] = "在物品連結前顯示裝等"
L["social.chat.hyperlinkEnhance.displayItemType.title"] = "顯示物品類型"
L["social.chat.hyperlinkEnhance.displayItemType.tooltip"] = "在物品連結前顯示分類"
L["social.chat.hyperlinkEnhance.displaySockets.title"] = "顯示插槽"
L["social.chat.hyperlinkEnhance.displaySockets.tooltip"] = "在物品連結後顯示鑲孔資訊"
L["social.chat.hyperlinkEnhance.title"] = "聊天連結增強"
L["social.chat.hyperlinkEnhance.tooltip"] = "為聊天連結添加額外資訊"
L["social.chat.tabSwitch.title"] = "Tab快速切換頻道"
L["social.chat.tabSwitch.tooltip"] = "用Tab鍵在|cffffffff說|r/|cffaaaaff隊伍|r/|cffff7f00團隊|r/|cffff7f00副本|r/|cff40ff40公會|r/|cff40c040幹部|r頻道間切換"
L["social.friendsList.characterNameClassColor.sameProjectId.title"] = "忽略其他版本"
L["social.friendsList.characterNameClassColor.sameProjectId.tooltip"] = "正在遊玩其他版本《魔獸世界》的好友角色名稱將使用預設的灰色"
L["social.friendsList.characterNameClassColor.title"] = "角色名職業染色"
L["social.friendsList.characterNameClassColor.tooltip"] = "好友列表的角色名稱顯示職業顏色"
L["social.friendsList.title"] = "好友列表"
L["social.privacyMode.hideBattleNetFriendsRealName.title"] = "隱藏實名好友姓名"
L["social.privacyMode.hideBattleNetFriendsRealName.tooltip"] = "顯示戰網暱稱而非真實姓名"
L["social.privacyMode.hideBattleNetTagSuffix.title"] = "隱藏戰網標籤後綴"
L["social.privacyMode.hideBattleNetTagSuffix.tooltip"] = "隱藏好友列表頂部的戰網標識"
L["social.title"] = "社交"
