if not(GetLocale() == "zhTW") then
    return
end

local ADDON_NAME, SanluliUtils = ...

local L = SanluliUtils.Locale

L["addon.name"] = "SanluliUtils"
L["addon.test.title"] = "|cffff0000(測試)|r"
L["addon.test.tooltip"] = "\n|cffff0000此功能仍在測試, 無法保證它能按預期效果工作|r"
L["addons.simulationcraft.title"] = "SimulationCraft"
L["addons.simulationcraft.forceHideMinimap.title"] = "始終隱藏Simc小地圖按鈕"
L["addons.title"] = "插件增强"
L["blizzardui.actionBar.hideName.title"] = "隱藏動作條按鈕名稱"
L["blizzardui.actionBar.hideName.tooltip"] = "隱藏暴雪動作條上的宏、裝備管理員等按鈕的名稱"
L["blizzardui.actionBar.title"] = "動作條"
L["blizzardui.forceShowPowerBarAltStatus.title"] = "總是顯示額外能量條文本"
L["blizzardui.forceShowPowerBarAltStatus.tooltip"] = "在有額外能量條的首領戰鬥(例如: 恩佐斯)或區域中時, 總是顯示能量數值"
L["blizzardui.sync.actionBar.title"] = "同步动作条配置"
L["blizzardui.sync.actionBar.tooltip"] = "\""..SETTING_GROUP_GAMEPLAY.." -> "..ACTIONBARS_LABEL.."\"頁面的選項將被同步到你的其他角色上"
L["blizzardui.sync.raidFrame.title"] = "同步團隊框體配置"
L["blizzardui.sync.raidFrame.tooltip"] = "\""..SETTING_GROUP_GAMEPLAY.." -> "..INTERFACE_LABEL.." -> "..RAID_FRAMES_LABEL.."\"分組的選項將被同步到你的其他角色上"
L["blizzardui.title"] = "暴雪界面"
L["client.overrideArchive.message.disabled"] = "已開啓反和谐, |cffff0000重新啓動游戲軟體|r后生效"
L["client.overrideArchive.message.enabled"] = "已關閉反和谐, |cffff0000重新啓動游戲軟體|r后生效"
L["client.overrideArchive.disable.title"] = "反和谐|cffff0000(需要重启游戏)|r"
L["client.overrideArchive.disable.tooltip"] = "等等, 你爲什麽能看見這個選項?!"
L["client.overrideArchive.enable.title"] = "減輕暴力表現|cffff0000(需要重启游戏)|r"
L["client.overrideArchive.enable.tooltip"] = [[
使用一套暴雪内置的替換模型包 (默認情況下，它被應用於簡體中文語言客戶端)

具體效果:
1) 儅玩家復活后, 留下的骷髏將被替換爲墓碑
2) 亡靈類生物將擁有完整的皮膚
3) 鮮血將被替換爲灰色
以及還有一些我沒有提到的...

如果這個選項不起作用, 你可能需要在戰網中將游戲語言修改爲"简体中文", 然後等待游戲資源下載完成后改回來
        
|cffff0000這個選項需要重啓客戶端|r
]]
L["client.profanityFilter.message.disabled"] = "已關閉不當言詞過濾器"
L["client.profanityFilter.message.enabled"] = "已開啓不當言詞過濾器"
L["client.profanityFilter.title"] = "不當言詞過濾器|cffff0000(强制更改)|r"
L["client.profanityFilter.tooltip"] = "|cffff0000注: 中國大陸區伺服器语鎖定開啓不當言詞過濾器, 這個功能要配合地區誤導使用|r\n强制修改 \"社交 -> 不當言詞過濾器\" 选项"
L["client.regionDeceive.differentRegionFix.message.fixed"] = "已修復好友列表\"不同的地區\"Bug"
L["client.regionDeceive.differentRegionFix.message.restored"] = "已恢復好友列表"
L["client.regionDeceive.differentRegionFix.title"] = "修復\"不同的地區\"Bug"
L["client.regionDeceive.differentRegionFix.tooltip"] = "修復儅客戶端地區與伺服器實際地區不同時, 好友列表提示\"不同的地區\"而無法組隊的問題"
L["client.regionDeceive.message.disabled"] = "已關閉客戶端地區誤導"
L["client.regionDeceive.message.enabled"] = "已開啓客戶端地區誤導"
-- L["client.regionDeceive.temporarilyDisabled.dialogs.onshow"] = "警告: 客戶端地區誤導功能可能導致"..HELP_FRAME_TITLE.."界面無法正常使用(黑屏或一直轉圈), 若你需要幫助, 點擊\""..YES.."\"暫時關閉此功能並重載界面。"
-- L["client.regionDeceive.temporarilyDisabled.dialogs.onhide"] = "你已經關閉了"..HELP_FRAME_TITLE.."界面, 你想恢復地區誤導功能嗎?"
-- L["client.regionDeceive.temporarilyDisabled.message.enabled"] = "已臨時關閉客戶端地區誤導功能，下次重載/登錄時恢復"
L["client.regionDeceive.title"] = "客戶端地區誤導"
L["client.regionDeceive.tooltip"] = "|cffff0000僅限中國大陸地區|r\n將客戶端区域設爲其他地區, 從而解鎖部分中國大陸地區伺服器鎖定的選項。\n使用此功能時, 請開啓下方\"修復'不同的地區'Bug\"選項, 否則可能導致好友列表出現Bug。"
L["client.title"] = "客戶端"
L["general.autoInputConfirm.title"] = "自動輸入確認内容"
L["general.autoInputConfirm.tooltip"] = "在一些需要輸入確認信息的對話框中自動輸入\n(例如: 刪除物品時輸入\"DELETE\")\n|cffff0000請在點擊\""..YES.."\"前再三確認你在做什麽。|r"
L["general.autoRepair.funds.guild.title"] = "優先使用公會資金"
L["general.autoRepair.funds.guild.tooltip"] = "優先使用公會銀行的資金修理裝備，額度不足時才使用你自己的錢"
L["general.autoRepair.funds.personal.title"] = "自費維修"
L["general.autoRepair.funds.personal.tooltip"] = "總是使用你自己的錢修理裝備"
L["general.autoRepair.message.guild"] = "公會"
L["general.autoRepair.message.guildExhausted"] = "公會修理額度已用完"
L["general.autoRepair.message.oom"] = "修理費用不足, 需要 %s"
L["general.autoRepair.message.repaired"] = "已自動修理, 費用: %s"
L["general.autoRepair.title"] = "自動修理"
L["general.autoRepair.tooltip"] = "當你打開商人界面時, 自動修理所有物品"
L["general.autoRoll.message.greed"] = "已自動選擇貪婪: %s"
L["general.autoRoll.message.pass"] = "已自動選擇放棄: %s"
L["general.autoRoll.message.transmog"] = "已自動選擇幻化: %s"
L["general.autoRoll.method.greed.title"] = "自動貪婪"
L["general.autoRoll.method.greed.tooltip"] = "若你不能需求: 若該物品能夠幻化, 選擇幻化取向; 否則選擇貪婪取向"
L["general.autoRoll.method.pass.title"] = "自動放棄"
L["general.autoRoll.method.pass.tooltip"] = "若你不能需求: 則總是放棄該物品"
L["general.autoRoll.title"] = "自動貪婪"
L["general.autoRoll.tooltip"] = "當你的隊伍拾取了一件物品等待Roll點分配, 且你|cffff0000無法需求|r該物品, 自動投擲骰子\n\n|cffff0000對於你能夠需求的物品, 你仍然需要自行決定如何投擲投資|r"
L["general.autoSellJunk.message.sold"] = "已出售 %s個物品, 縂價值 %s"
L["general.autoSellJunk.method.12Items.title"] = "每次僅出售12件垃圾"
L["general.autoSellJunk.method.12Items.tooltip"] = "打開商人界面時僅出售12件垃圾, 以確保它們能夠被購回(避免出售掉一些具有特殊意義的物品)"
L["general.autoSellJunk.method.allItems.title"] = "出售所有垃圾"
L["general.autoSellJunk.method.allItems.tooltip"] = "打開商人界面時將出售所有垃圾, 超出12件物品的部分將無法被購回"
L["general.autoSellJunk.method.blizzard.title"] = "出售所有垃圾(不可购回)"
L["general.autoSellJunk.method.blizzard.tooltip"] = "打開商人界面時將出售所有垃圾, 且當你一次出售至少兩堆垃圾時, 它們都不會出現在購回界面中(使用暴雪内置的方法, 等效於點擊出售所有垃圾按鈕)"
L["general.autoSellJunk.title"] = "自動出售垃圾"
L["general.autoSellJunk.tooltip"] = "自動出售灰色品質的物品\n(由於購回界面只能保存12件物品, 故一次只出售12件垃圾以保證不會出售重要物品)"
L["general.fasterAutoLoot.title"] = "更快的自動拾取"
L["general.fasterAutoLoot.tooltip"] = "自動拾取將更快的拾取所有物品\n需要開啓\"控制->自動拾取\"或使用自動拾取鍵"
L["general.title"] = "常規選項"
L["social.chatTypeTabSwitch.title"] = "Tab快速切換聊天頻道"
L["social.chatTypeTabSwitch.tooltip"] = "在聊天框中按下\"Tab\"鍵來快速的在\"|cffffffff說|r\"、\"|cffaaaaff小隊|r\"、\"|cffff7f00團隊|r\"、\"|cffff7f00副本|r\"、\"|cff40ff40公會|r\"、\"|cff40c040官員|r\"頻道中切換(僅對你已加入的頻道有效)"
L["social.friendsList.title"] = "好友列表"
L["social.friendsList.characterNameClassColor.title"] = "角色名職業染色"
L["social.friendsList.characterNameClassColor.tooltip"] = "好友列表裏的角色名稱將顯示為職業顔色"
L["social.title"] = SOCIAL_LABEL
