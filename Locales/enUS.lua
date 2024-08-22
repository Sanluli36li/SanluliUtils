local ADDON_NAME, SanluliUtils = ...

local L = SanluliUtils.Locale

L["addon.name"] = ADDON_NAME
L["addon.test.title"] = "|cffff0000(Test)|r"
L["addon.test.tooltip"] = "\n|cffff0000This is a testing feature and there is no guarantee that it will work as expected|r"
L["addons.simulationcraft.title"] = "SimulationCraft"
L["addons.simulationcraft.forceHideMinimap.title"] = "Force Hide Simc Minimap Icon"
L["addons.title"] = "AddOns"
L["blizzardui.actionBar.hideName.title"] = "Hide Action Bar Button Name"
L["blizzardui.actionBar.hideName.tooltip"] = "Hide the names of Macros, Equipment Sets, etc. on the Blizzard action bar."
L["blizzardui.actionBar.title"] = "Action Bar"
L["blizzardui.forceShowPowerBarAltStatus.title"] = "Force Show Extra-PowerBar Status."
L["blizzardui.forceShowPowerBarAltStatus.tooltip"] = "Always show the text above when in some Boss Encounters or Areas that have an Extra-PowerBar."
L["blizzardui.sync.actionBar.title"] = "Synchronize ActionBar Frame configuration"
L["blizzardui.sync.actionBar.tooltip"] = "The options of \""..SETTING_GROUP_GAMEPLAY.." -> "..ACTIONBARS_LABEL.."\" tab will be synced to your other characters."
L["blizzardui.sync.raidFrame.title"] = "Synchronize Raid Frame configuration"
L["blizzardui.sync.raidFrame.tooltip"] = "The options of \""..SETTING_GROUP_GAMEPLAY.." -> "..INTERFACE_LABEL.." -> "..RAID_FRAMES_LABEL.."\" group will be synced to your other characters."
L["blizzardui.title"] = "Blizzard UI"
L["client.overrideArchive.message.disabled"] = "Disabled Override Archive, |cffff0000please RESTART GAME|r"
L["client.overrideArchive.message.enabled"] = "Enabled Override Archive, |cffff0000please RESTART GAME|r"
L["client.overrideArchive.disable.title"] = "Disable Override Archive|cffff0000(REQUIRE RESTART GAME)|r"
L["client.overrideArchive.disable.tooltip"] = "Normally you shouldn't see this option."
L["client.overrideArchive.enable.title"] = "Reducing Violence|cffff0000(REQUIRE RESTART GAME)|r"
L["client.overrideArchive.enable.tooltip"] = [[
Enable the built-in override archive in the client (by default, it is used for the Simplified Chinese client)

Specific effect:
1) When the player is resurrected, the skeleton left behind will be replaced by a grave.
2) The undead model will have a complete skin
3) Blood will be replaced with gray
And many more I didn't mention...

If this option does not have an effect, you may need to change the game language to Simplified Chinese(简体中文) in BNET, then wait for the data to download and then change it back to your language
   
|cffff0000Changing this option requires a client restart|r
]]
L["client.profanityFilter.message.disabled"] = "Disabled Mature Language Filter"
L["client.profanityFilter.message.enabled"] = "Enabled Mature Language Filter"
L["client.profanityFilter.title"] = "Mature Language Filter"
L["client.profanityFilter.tooltip"] = "Forcibly modify the \""..SETTING_GROUP_GAMEPLAY.." -> "..SOCIAL_LABEL.." -> "..PROFANITY_FILTER.."\" option"
L["client.regionDeceive.differentRegionFix.message.fixed"] = "Fixed \"Different Region\" on Friend List"
L["client.regionDeceive.differentRegionFix.message.restored"] = "Friends list restored"
L["client.regionDeceive.differentRegionFix.title"] = "Fix Different Region"
L["client.regionDeceive.differentRegionFix.tooltip"] = "Fixed the bug that the friend list could not form a group when the region of the client is different from the region of the actual server.(\"Different Region\" Tip)"
L["client.regionDeceive.message.disabled"] = "Disabled Region Deceive"
L["client.regionDeceive.message.enabled"] = "Enabled Region Deceive"
-- L["client.regionDeceive.temporarilyDisabled.dialogs.onshow"] = "Warning: The Region Deceive feature may cause problems with the "..HELP_FRAME_TITLE.." window (black screen or keep loading). If you need help, click \""..YES.."\" to temporarily disable this feature and reload user interface."
-- L["client.regionDeceive.temporarilyDisabled.dialogs.onhide"] = "You have closed the "..HELP_FRAME_TITLE.." window, do you want to re-enable Region Receive?"
-- L["client.regionDeceive.temporarilyDisabled.message.enabled"] = "Region Deceive has been temporarily disabled, will be restored on next reload/login"
L["client.regionDeceive.title"] = "Region Deceive"
L["client.regionDeceive.tooltip"] = "Set client region to somewhere else to unlock some CN region locked options\nWhen using this feature, please enable the \"Fix Different Region\" option below, otherwise it will cause a bug in the friend list."
L["client.title"] = "Client"
L["general.autoInputConfirm.title"] = "Auto Input Confirm Text"
L["general.autoInputConfirm.tooltip"] = "Complete the input for you in some prompt boxes that need to enter the specified text.\n(Example: Enter \"DELETE\" to delete an item)\n|cffff0000Please understand what you are doing when you press the \""..YES.."\" button|r"
L["general.autoRepair.funds.guild.title"] = "Priority Use of Guild Funds"
L["general.autoRepair.funds.guild.tooltip"] = "Prioritize using the Guild Bank's funds to repair equipment. If funds are insufficient, use your own money."
L["general.autoRepair.funds.personal.title"] = "Use Your Funds"
L["general.autoRepair.funds.personal.tooltip"] = "Always use your money to repair your equipment."
L["general.autoRepair.message.guild"] = "Guild Bank"
L["general.autoRepair.message.guildExhausted"] = "Guild repair quota exhausted."
L["general.autoRepair.message.oom"] = "Not enough money to repair, Require %s."
L["general.autoRepair.message.repaired"] = "Auto Repaired, Cost: %s"
L["general.autoRepair.title"] = "Auto Repair"
L["general.autoRepair.tooltip"] = "When opening the merchant interface, automatically repair all equipment."
L["general.autoSellJunk.message.sold"] = "%s items sold, total price %s"
L["general.autoSellJunk.method.12Items.title"] = "Sell 12 items Per Time"
L["general.autoSellJunk.method.12Items.tooltip"] = "When you open the merchant interface, 12 junk will be sold, and they can be buyback."
L["general.autoSellJunk.method.allItems.title"] = "Sell all junk"
L["general.autoSellJunk.method.allItems.tooltip"] = "When you open the merchant interface, all junk will be sold. Items exceeding 12 can't be buyback."
L["general.autoSellJunk.method.blizzard.title"] = "Sell all junk (can't bought back)"
L["general.autoSellJunk.method.blizzard.tooltip"] = "When you open the merchant interface, all junk will be sold. When you sell at least two stacks of junk at a time, they will not appear in the buyback interface.(Using Blizzard's built-in method, it is equivalent to clicking the Sell All Junk button and confirming)"
L["general.autoSellJunk.title"] = "Auto Sell Junk"
L["general.autoSellJunk.tooltip"] = "Automatically sell items with poor quality\nContainers marked with \"Ignore this bag -> Sell junk\" will be ignored."
L["general.fasterAutoLoot.title"] = "Faster Auto Loot"
L["general.fasterAutoLoot.tooltip"] = "Auto loot will loot all items faster."
L["general.title"] = "General"