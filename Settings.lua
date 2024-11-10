local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("settings")
local L = SanluliUtils.Locale

local BATTLE_TAG = (IsBNLogin() and BNet_GetTruncatedBattleTag(select(2, BNGetInfo()))) or "BattleTag"
local CHARACTER_NAME = UnitName("player")
local REALM_NAME = GetRealmName()
local PLAYER_CLASS_COLOR = "|c"..C_ClassColor.GetClassColor(select(2, UnitClass("player"))):GenerateHexColor()

local libSettings = LibStub("LibBlzSettings-1.0")

local CONTROL_TYPE = libSettings.CONTROL_TYPE

local SETTING_TYPE = libSettings.SETTING_TYPE

local settingsData = {
    module = "general",
    name = ADDON_NAME,
    settings = {
        {
            controlType = CONTROL_TYPE.CHECKBOX_AND_DROPDOWN,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["general.autoRepair.title"],
            tooltip = L["general.autoRepair.tooltip"],
            key = "general.autoRepair.enable",
            default = true,
            dropdown = {
                settingType = SETTING_TYPE.ADDON_VARIABLE,
                key = "general.autoRepair.funds",
                default = 2,
                options = {
                    { L["general.autoRepair.funds.personal.title"], L["general.autoRepair.funds.personal.tooltip"] },
                    { L["general.autoRepair.funds.guild.title"], L["general.autoRepair.funds.guild.tooltip"] },
                }
            }
        },
        {
            controlType = CONTROL_TYPE.CHECKBOX_AND_DROPDOWN,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["general.autoSellJunk.title"],
            tooltip = L["general.autoSellJunk.tooltip"],
            key = "general.autoSellJunk.enable",
            default = true,
            dropdown = {
                settingType = SETTING_TYPE.ADDON_VARIABLE,
                key = "general.autoSellJunk.method",
                default = 1,
                options = {
                    { L["general.autoSellJunk.method.12Items.title"], L["general.autoSellJunk.method.12Items.tooltip"] },
                    { L["general.autoSellJunk.method.allItems.title"], L["general.autoSellJunk.method.allItems.tooltip"] },
                    { L["general.autoSellJunk.method.blizzard.title"], L["general.autoSellJunk.method.blizzard.tooltip"] }
                }
            }
        },
        {
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["general.autoInputConfirm.title"],
            tooltip = L["general.autoInputConfirm.tooltip"],
            key = "general.autoInputConfirm.enable",
            default = true
        },
        {
            controlType = CONTROL_TYPE.CHECKBOX_AND_DROPDOWN,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["general.autoRoll.title"],
            tooltip = L["general.autoRoll.tooltip"],
            key = "general.autoRoll.enable",
            default = false,
            dropdown = {
                settingType = SETTING_TYPE.ADDON_VARIABLE,
                key = "general.autoRoll.method",
                default = 1,
                options = {
                    { L["general.autoRoll.method.greed.title"], L["general.autoRoll.method.greed.tooltip"] },
                    { L["general.autoRoll.method.pass.title"], L["general.autoRoll.method.pass.tooltip"] }
                }
            },
        },
        {
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["general.fasterAutoLoot.title"],
            tooltip = L["general.fasterAutoLoot.tooltip"],
            key = "general.fasterAutoLoot.enable",
            default = true
        },
        {
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["general.autoCombatlog.title"],
            tooltip = L["general.autoCombatlog.tooltip"],
            key = "general.autoCombatlog.enable",
            default = false,
            subSettings = {
                {
                    controlType = CONTROL_TYPE.CHECKBOX_AND_DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["general.autoCombatlog.raid.title"],
                    tooltip = L["general.autoCombatlog.raid.tooltip"],
                    key = "general.autoCombatlog.raid",
                    default = true,
                    dropdown = {
                        settingType = SETTING_TYPE.ADDON_VARIABLE,
                        key = "general.autoCombatlog.raid.difficulty",
                        default = 4,
                        options = {
                            { L["general.autoCombatlog.difficulty.all"] },
                            { L["general.autoCombatlog.difficulty.normal"] },
                            { L["general.autoCombatlog.difficulty.heroic"] },
                            { L["general.autoCombatlog.difficulty.mythicRaid"] },
                        }
                    }
                    
                },
                {
                    controlType = CONTROL_TYPE.CHECKBOX_AND_DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["general.autoCombatlog.dungeon.title"],
                    tooltip = L["general.autoCombatlog.dungeon.tooltip"],
                    key = "general.autoCombatlog.dungeon",
                    default = false,
                    dropdown = {
                        settingType = SETTING_TYPE.ADDON_VARIABLE,
                        key = "general.autoCombatlog.dungeon.difficulty",
                        default = 4,
                        options = {
                            { L["general.autoCombatlog.difficulty.all"] },
                            { L["general.autoCombatlog.difficulty.heroic"] },
                            { L["general.autoCombatlog.difficulty.mythic"] },
                            { L["general.autoCombatlog.difficulty.mythicPlus"] },
                        }
                    }
                    
                }
            }
        },
        {
            controlType = CONTROL_TYPE.SECTION_HEADER,
            name = L["blizzardui.title"]
        },
        {
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["blizzardui.sync.actionBar.title"],
            tooltip = L["blizzardui.sync.actionBar.tooltip"],
            key = "blizzardui.sync.actionBar.enable",
            default = false,
            onValueChanged = function (value)
                if value then
                    SanluliUtils.blizzardui:SaveActionBarCVars()
                end
            end
        },
        {
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["blizzardui.sync.raidFrame.title"],
            tooltip = L["blizzardui.sync.raidFrame.tooltip"],
            key = "blizzardui.sync.raidFrame.enable",
            default = false,
            onValueChanged = function (value)
                if value then
                    SanluliUtils.blizzardui:SaveRaidFrameCVars()
                end
            end
        },
        {
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["blizzardui.forceShowPowerBarAltStatus.title"],
            tooltip = L["blizzardui.forceShowPowerBarAltStatus.tooltip"],
            key = "blizzardui.forceShowPowerBarAltStatus",
            default = true
        },
        {
            controlType = CONTROL_TYPE.SECTION_HEADER,
            name = L["blizzardui.actionBar.title"]
        },
        {
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["blizzardui.actionBar.hideName.title"],
            tooltip = L["blizzardui.actionBar.hideName.tooltip"],
            key = "blizzardui.actionBar.hideName",
            default = false,
            onValueChanged = function (value)
                SanluliUtils.blizzardui:SetActionBarNameDisplay(not value)
            end,
        },
        {
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["blizzardui.actionBar.hideHotkey.title"],
            tooltip = L["blizzardui.actionBar.hideHotkey.tooltip"] ,
            key = "blizzardui.actionBar.hideHotkey",
            default = false,
            onValueChanged = function (value)
                SanluliUtils.blizzardui:SetActionBarHotKeyDisplay(not value)
            end,
        }
    },
    subCategorys = {
        {
            module = "social",
            name = L["social.title"],
            settings = {
                {
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["social.chatTypeTabSwitch.title"],
                    tooltip = L["social.chatTypeTabSwitch.tooltip"],
                    key = "social.chatTypeTabSwitch.enable",
                    default = true
                },
                {
                    controlType = CONTROL_TYPE.CHECKBOX_AND_DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["social.chat.bnPlayerLink.title"],
                    tooltip = L["social.chat.bnPlayerLink.tooltip"],
                    key = "social.chat.bnPlayerLink.enable",
                    default = true,
                    dropdown = {
                        settingType = SETTING_TYPE.ADDON_VARIABLE,
                        key = "social.chat.bnPlayerLink.format",
                        default = 3,
                        options = {
                            { BATTLE_TAG },
                            { PLAYER_CLASS_COLOR..BATTLE_TAG..FONT_COLOR_CODE_CLOSE },
                            { BATTLE_TAG..PLAYER_CLASS_COLOR.."("..CHARACTER_NAME..")"..FONT_COLOR_CODE_CLOSE },
                            { BATTLE_TAG..PLAYER_CLASS_COLOR.."("..CHARACTER_NAME.."-"..REALM_NAME..")"..FONT_COLOR_CODE_CLOSE },
                            { PLAYER_CLASS_COLOR..CHARACTER_NAME..FONT_COLOR_CODE_CLOSE},
                            { PLAYER_CLASS_COLOR..CHARACTER_NAME.."-"..REALM_NAME..FONT_COLOR_CODE_CLOSE}
                        }
                    }
                },
                {
                    controlType = CONTROL_TYPE.SECTION_HEADER,
                    name = L["social.friendsList.title"],
                },
                {
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["social.friendsList.characterNameClassColor.title"],
                    tooltip = L["social.friendsList.characterNameClassColor.tooltip"],
                    key = "social.friendsList.characterNameClassColor.enable",
                    default = true
                },
                {
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["social.friendsList.hideBattleNetFriendsRealName.title"],
                    tooltip = L["social.friendsList.hideBattleNetFriendsRealName.tooltip"],
                    key = "social.friendsList.hideBattleNetFriendsRealName.enable",
                    default = false
                },
                {
                    controlType = CONTROL_TYPE.CHECKBOX_AND_DROPDOWN,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["social.friendsList.hideBattleNetTagSuffix.title"],
                    tooltip = L["social.friendsList.hideBattleNetTagSuffix.tooltip"],
                    key = "social.friendsList.hideBattleNetTagSuffix.enable",
                    default = false,
                    dropdown = {
                        settingType = SETTING_TYPE.ADDON_VARIABLE,
                        key = "social.friendsList.hideBattleNetTagSuffix.method",
                        default = 1,
                        options = {
                            { BATTLE_TAG },
                            { BATTLE_TAG.."#0000" }
                        },
                        onValueChanged = function (value)
                            SanluliUtils.social:SetBattleTagHideStatus(value)
                        end
                    },
                    onValueChanged = function (value)
                        if value then
                            SanluliUtils.social:SetBattleTagHideStatus(SanluliUtils.social:GetConfig("friendsList.hideBattleNetTagSuffix.method"))
                        else
                            SanluliUtils.social:SetBattleTagHideStatus(0)
                        end
                    end
                }
            }
        },
        {
            module = "addons",
            name = L["addons.title"],
            settings = {
                {
                    controlType = CONTROL_TYPE.SECTION_HEADER,
                    name = L["addons.simulationcraft.title"],
                    isVisible = function ()
                        return true -- GetAddOnEnableState(nil, "SimulationCraft") >= 1
                    end
                },
                {
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["addons.simulationcraft.forceHideMinimap.title"],
                    key = "addons.simulationcraft.forceHideMinimap",
                    default = true,
                    onValueChanged = function (value)
                        SanluliUtils.addons.SetSimulationCraftMinimap(not value)
                    end,
                    isVisible = function ()
                        return true -- GetAddOnEnableState(nil, "SimulationCraft") >= 1
                    end
                }
            }
        },
        {
            module = "client",
            name = L["client.title"],
            settings = {
                {
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.PROXY,
                    name = L["client.overrideArchive.disable.title"],
                    tooltip = L["client.overrideArchive.disable.tooltip"],
                    key = "client.overrideArchive.disable",
                    getValue = function()
                        return not GetCVarBool("overrideArchive")
                    end,
                    setValue = function(value)
                        SanluliUtils.client:SetOverrideArchive(not value, true)
                    end,
                    isVisible = function()
                        return GetLocale() == "zhCN"
                    end
                },
                {
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.PROXY,
                    name = L["client.overrideArchive.enable.title"],
                    tooltip = L["client.overrideArchive.enable.tooltip"],
                    key = "client.overrideArchive.enable",
                    getValue = function()
                        return GetCVarBool("overrideArchive")
                    end,
                    setValue = function(value)
                        SanluliUtils.client:SetOverrideArchive(value, true)
                    end,
                    isVisible = function()
                        return GetLocale() ~= "zhCN"
                    end
                },
                {
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["client.regionDeceive.title"],
                    tooltip = L["client.regionDeceive.tooltip"],
                    key = "client.regionDeceive.enable",
                    default = false,
                    onValueChanged = function(value)
                        SanluliUtils.client:SetRegionDeceive(value, true)
                    end,
                    isVisible = function()
                        return SanluliUtils.client.PORTAL_CURRENT == "CN"
                    end,
                    subSettings = {
                        {
                            controlType = CONTROL_TYPE.CHECKBOX,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["client.regionDeceive.differentRegionFix.title"],
                            tooltip = L["client.regionDeceive.differentRegionFix.tooltip"],
                            key = "client.regionDeceive.differentRegionFix",
                            default = true,
                            onValueChanged = function (value)
                                SanluliUtils.client:SetDifferentRegionFix(value, true)
                            end
                        },
                        {
                            controlType = CONTROL_TYPE.CHECKBOX,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["client.profanityFilter.title"],
                            tooltip = L["client.profanityFilter.tooltip"],
                            key = "client.profanityFilter",
                            default = false,
                            onValueChanged = function(value)
                                SanluliUtils.client:SetProfanityFilter(value, true)
                            end
                        }
                    }
                },
                {
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.PROXY,
                    name = L["client.profanityFilter.title"],
                    tooltip = OPTION_TOOLTIP_PROFANITY_FILTER,
                    key = "client.profanityFilter",
                    getValue = function()
                        return GetCVarBool("profanityFilter")
                    end,
                    setValue = function(value)
                        if value then
                            SetCVar("profanityFilter", 1)
                        else
                            SetCVar("profanityFilter", 0)
                        end
                    end,
                    isVisible = function()
                        return SanluliUtils.client.PORTAL_CURRENT ~= "CN" and GetLocale() == "zhCN"
                    end
                },
                {
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["client.profanityFilter.achievementDataInject.title"],
                    tooltip = L["client.profanityFilter.achievementDataInject.tooltip"],
                    key = "client.profanityFilter.achievementDataInject",
                    default = true,
                    isVisible = function()
                        return SanluliUtils.client.PORTAL_CURRENT == "CN"
                    end
                },
                {
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["client.guildNewsFilter.title"],
                    tooltip = L["client.guildNewsFilter.tooltip"],
                    key = "client.guildNewsFix",
                    default = true,
                },
            }
        }
    }
}

local function Register()
    local category, layout = libSettings:RegisterVerticalSettingsTable(ADDON_NAME, settingsData, SanluliUtilsDB, true)
end


function Module:BeforeStartup()
    Register()
end
