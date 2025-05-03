local ADDON_NAME, SanluliUtils = ...

local L = SanluliUtils.Locale

L["addon.name"] = "SanluliUtils"
L["addon.test.title"] = "|cffff0000(Test)|r"
L["addon.test.tooltip"] = "|cffff0000This feature is experimental and may not work as expected|r"
L["addons.simulationcraft.title"] = "SimulationCraft"
L["addons.simulationcraft.forceHideMinimap.title"] = "Always Hide Simc Minimap Button"
L["addons.title"] = "Addon Enhancements"
L["automatic.autoCombatlog.difficulty.all"] = "All Difficulties"
L["automatic.autoCombatlog.difficulty.heroic"] = "Heroic+"
L["automatic.autoCombatlog.difficulty.mythic"] = "Mythic+"
L["automatic.autoCombatlog.difficulty.mythicPlus"] = "Mythic Keystone"
L["automatic.autoCombatlog.difficulty.mythicRaid"] = "Mythic Raid"
L["automatic.autoCombatlog.difficulty.normal"] = "Normal+"
L["automatic.autoCombatlog.dungeon.title"] = "Dungeon Difficulty"
L["automatic.autoCombatlog.dungeon.tooltip"] = "Dungeon difficulties to auto-enable combat logging"
L["automatic.autoCombatlog.raid.title"] = "Raid Difficulty"
L["automatic.autoCombatlog.raid.tooltip"] = "Raid difficulties to auto-enable combat logging"
L["automatic.autoCombatlog.title"] = "Auto Combat Log"
L["automatic.autoCombatlog.tooltip"] = "Automatically enable combat logging in instances\n\nLogs saved in \"Logs/WoWCombatLog\"\n|cffff0000Enable only when needed (e.g. for WarcraftLogs/raider.io)\nLogs consume disk space, clean regularly|r\n|cffffffffDisabled for classic loot rules|r"
L["automatic.autoInputConfirm.title"] = "Auto Input Confirmation"
L["automatic.autoInputConfirm.tooltip"] = "Automatically fill confirmation text\n(e.g. input \"DELETE\" when destroying items)\n|cffff0000Double-check before clicking \""..YES.."\"!|r"
L["automatic.autoRepair.funds.guild.title"] = "Prefer Guild Funds"
L["automatic.autoRepair.funds.guild.tooltip"] = "Use guild bank funds first, personal gold if insufficient"
L["automatic.autoRepair.funds.personal.title"] = "Personal Funds Only"
L["automatic.autoRepair.funds.personal.tooltip"] = "Always use personal gold for repairs"
L["automatic.autoRepair.message.guild"] = "Guild"
L["automatic.autoRepair.message.guildExhausted"] = "Guild repair funds exhausted"
L["automatic.autoRepair.message.oom"] = "Repair cost exceeds available gold by %s"
L["automatic.autoRepair.message.repaired"] = "Auto-repaired for %s"
L["automatic.autoRepair.title"] = "Auto Repair"
L["automatic.autoRepair.tooltip"] = "Automatically repair gear when opening vendor UI"
L["automatic.autoRoll.message.greed"] = "Auto selected Greed: %s"
L["automatic.autoRoll.message.pass"] = "Auto selected Pass: %s"
L["automatic.autoRoll.message.transmog"] = "Auto selected Transmog: %s"
L["automatic.autoRoll.method.greed.title"] = "Auto Greed"
L["automatic.autoRoll.method.greed.tooltip"] = "If cannot Need: select Transmog if available, otherwise Greed"
L["automatic.autoRoll.method.pass.title"] = "Auto Pass"
L["automatic.autoRoll.method.pass.tooltip"] = "Always Pass when cannot Need"
L["automatic.autoRoll.title"] = "Auto Greed"
L["automatic.autoRoll.tooltip"] = "Automatically roll when you|cffff0000 cannot Need|r an item\n\n|cffff0000You must manually decide for Need-eligible items|r"
L["automatic.autoSellJunk.message.sold"] = "Sold %s items for %s"
L["automatic.autoSellJunk.method.12Items.title"] = "Sell 12 Items Only"
L["automatic.autoSellJunk.method.12Items.tooltip"] = "Keep last 12 sold items buybackable"
L["automatic.autoSellJunk.method.allItems.title"] = "Sell All Junk"
L["automatic.autoSellJunk.method.allItems.tooltip"] = "Items beyond 12 become non-buybackable"
L["automatic.autoSellJunk.method.blizzard.title"] = "Blizzard Method (No Buyback)"
L["automatic.autoSellJunk.method.blizzard.tooltip"] = "Use default sell junk button behavior"
L["automatic.autoSellJunk.title"] = "Auto Sell Junk"
L["automatic.autoSellJunk.tooltip"] = "Automatically sell gray items to vendors\nIgnores bags marked \"Ignore this bag\""
L["automatic.fasterAutoLoot.title"] = "Faster Auto Loot"
L["automatic.fasterAutoLoot.tooltip"] = "Speed up looting process\nRequires \"Auto Loot\" enabled in controls"
L["automatic.title"] = "General"
L["blizzardui.actionBar.hideHotkey.title"] = "Hide Hotkey Text"
L["blizzardui.actionBar.hideHotkey.tooltip"] = "Hide hotkey labels on action buttons"
L["blizzardui.actionBar.hideName.title"] = "Hide Button Names"
L["blizzardui.actionBar.hideName.tooltip"] = "Hide names on macro/equipment set buttons"
L["blizzardui.actionBar.title"] = "Action Bars"
L["blizzardui.forceShowPowerBarAltStatus.title"] = "Always Show Alt Power"
L["blizzardui.forceShowPowerBarAltStatus.tooltip"] = "Display numeric values on special power bars (e.g. N'Zoth encounters)"
L["blizzardui.sync.actionBar.title"] = "Sync Action Bar Settings"
L["blizzardui.sync.actionBar.tooltip"] = "\""..SETTING_GROUP_GAMEPLAY.." -> "..ACTIONBARS_LABEL.."\" settings will sync across characters\n|cffff0000May require /reload after changes|r"
L["blizzardui.sync.raidFrame.title"] = "Sync Raid Frame Settings"
L["blizzardui.sync.raidFrame.tooltip"] = "\""..SETTING_GROUP_GAMEPLAY.." -> "..INTERFACE_LABEL.." -> "..RAID_FRAMES_LABEL.."\" settings will sync across characters"
L["blizzardui.title"] = "Blizzard UI"
L["client.blzAddonProfiler.disable.title"] = "Disable Addon Profiler"
L["client.blzAddonProfiler.disable.tooltip"] = "Disable 11.1.0's frame-drop-prone profiling"
L["client.blzAddonProfiler.message.disabled"] = "Addon profiling disabled"
L["client.blzAddonProfiler.message.enabled"] = "Addon profiling enabled"
L["client.disabledOverrideArchive.message.disabled"] = "Censorship disabled, |cffff0000restart required|r"
L["client.disabledOverrideArchive.message.enabled"] = "Censorship enabled, |cffff0000restart required|r"
L["client.overrideArchive.disable.title"] = "Disable Censorship|cffff0000(Requires Restart)|r"
L["client.overrideArchive.disable.tooltip"] = [[
Restore original models replaced in CN client
(Icons require separate texture packs)

|cffff0000Client restart required|r
]]
L["client.overrideArchive.enable.title"] = "Enable Censorship|cffff0000(Requires Restart)|r"
L["client.overrideArchive.enable.tooltip"] = [[
Use official censored content (CN client default)

Effects include:
1) Graves instead of skeletons on resurrection
2) Undead models with full skin
3) Grey blood effects
Plus other hidden changes...

If ineffective, switch client language to Simplified Chinese to download assets

|cffff0000Client restart required|r
]]
L["client.profanityFilter.title"] = "Profanity Filter|cffff0000(Forced Override)|r"
L["client.title"] = "Client"
L["social.chat.bnPlayerLink.title"] = "BNet Name Format"
L["social.chat.bnPlayerLink.tooltip"] = "Modify battle.net friend link formatting"
L["social.chat.hyperlinkEnhance.applyToGuildNews.title"] = "Apply to Guild News"
L["social.chat.hyperlinkEnhance.applyToGuildNews.tooltip"] = "Also enhance item links in guild news"
L["social.chat.hyperlinkEnhance.displayIcon.title"] = "Show Icons"
L["social.chat.hyperlinkEnhance.displayIcon.tooltip"] = "Prepend item/spell icons to links"
L["social.chat.hyperlinkEnhance.displayItemLevel.title"] = "Show Item Level"
L["social.chat.hyperlinkEnhance.displayItemLevel.tooltip"] = "Display ilvl before item links"
L["social.chat.hyperlinkEnhance.displayItemType.title"] = "Show Item Type"
L["social.chat.hyperlinkEnhance.displayItemType.tooltip"] = "Display item category before links"
L["social.chat.hyperlinkEnhance.displaySockets.title"] = "Show Sockets"
L["social.chat.hyperlinkEnhance.displaySockets.tooltip"] = "Display socket info after item links"
L["social.chat.hyperlinkEnhance.title"] = "Chat Link Enhancements"
L["social.chat.hyperlinkEnhance.tooltip"] = "Enhance item links in chat with extra info"
L["social.chat.tabSwitch.title"] = "Tab Channel Cycling"
L["social.chat.tabSwitch.tooltip"] = "Cycle through |cffffffffSay|r/|cffaaaaffParty|r/|cffff7f00Raid|r/|cffff7f00Instance|r/|cff40ff40Guild|r/|cff40c040Officer|r with Tab"
L["social.friendsList.characterNameClassColor.title"] = "Class-colored Names"
L["social.friendsList.characterNameClassColor.tooltip"] = "Color character names by class in friends list"
L["social.friendsList.title"] = "Friends List"
L["social.privacyMode.hideBattleNetFriendsRealName.title"] = "Hide Real IDs"
L["social.privacyMode.hideBattleNetFriendsRealName.tooltip"] = "Display BNet tags instead of real names"
L["social.privacyMode.hideBattleNetTagSuffix.title"] = "Hide BNet Tags"
L["social.privacyMode.hideBattleNetTagSuffix.tooltip"] = "Remove battle.net tags from friends list header"
L["social.title"] = SOCIAL_LABEL
