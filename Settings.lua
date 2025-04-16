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
    name = ADDON_NAME,
    database = "SanluliUtilsDB",
    settings = {
        {
            -- 自动修理
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
            -- 自动出售垃圾
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
            -- 自动输入确认内容
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["general.autoInputConfirm.title"],
            tooltip = L["general.autoInputConfirm.tooltip"],
            key = "general.autoInputConfirm.enable",
            default = true
        },
        {
            -- 自动贪婪
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
            -- 更快的自动拾取
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["general.fasterAutoLoot.title"],
            tooltip = L["general.fasterAutoLoot.tooltip"],
            key = "general.fasterAutoLoot.enable",
            default = true
        },
        {
            -- 自动战斗日志
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["general.autoCombatlog.title"],
            tooltip = L["general.autoCombatlog.tooltip"],
            key = "general.autoCombatlog.enable",
            default = false,
            subSettings = {
                {
                    -- 团队副本难度
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
                    -- 地下城难度
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
            -- 自动取消队伍申请
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = "自动取消队伍申请|cffff0000测试|r",
            tooltip = "在预创建队伍/集合石插件中，自动取消你选定的职责都已满员的申请\n\n只对史诗钥石地下城生效\n\n受限于暴雪API，满员时申请不会立刻被取消，而是在你选择下一个队伍时取消\n\n|cffff0000这是一个测试功能, 不保证其稳定性|r\n|cffff0000This is a testing feature, its stability is not guaranteed|r",
            key = "general.autoCancelLFGApplication.enable.test",
            default = false
        },
        {
            controlType = CONTROL_TYPE.SECTION_HEADER,
            name = L["blizzardui.title"]
        },
        {
            -- 同步动作条设置
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["blizzardui.sync.actionBar.title"],
            tooltip = L["blizzardui.sync.actionBar.tooltip"],
            key = "blizzardui.sync.actionBar.enable",
            default = false,
            onValueChanged = function (value)
                if value then
                    SanluliUtils.Modules.blizzardui:SaveActionBarCVars()
                end
            end
        },
        {
            -- 同步团队框体配置
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["blizzardui.sync.raidFrame.title"],
            tooltip = L["blizzardui.sync.raidFrame.tooltip"],
            key = "blizzardui.sync.raidFrame.enable",
            default = false,
            onValueChanged = function (value)
                if value then
                    SanluliUtils.Modules.blizzardui:SaveRaidFrameCVars()
                end
            end
        },
        {
            -- 总是显示额外能量条状态
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
            -- 隐藏动作条按钮名称
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["blizzardui.actionBar.hideName.title"],
            tooltip = L["blizzardui.actionBar.hideName.tooltip"],
            key = "blizzardui.actionBar.hideName",
            default = false,
            onValueChanged = function (value)
                SanluliUtils.Modules.blizzardui:SetActionBarNameDisplay(not value)
            end,
        },
        {
            -- 隐藏动作条快捷键
            controlType = CONTROL_TYPE.CHECKBOX,
            settingType = SETTING_TYPE.ADDON_VARIABLE,
            name = L["blizzardui.actionBar.hideHotkey.title"],
            tooltip = L["blizzardui.actionBar.hideHotkey.tooltip"] ,
            key = "blizzardui.actionBar.hideHotkey",
            default = false,
            onValueChanged = function (value)
                SanluliUtils.Modules.blizzardui:SetActionBarHotKeyDisplay(not value)
            end,
        }
    },
    subCategorys = {
        {
            name = L["social.title"],
            settings = {
                {
                    -- 聊天链接增强
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["social.chat.hyperlinkEnhance.title"],
                    tooltip = L["social.chat.hyperlinkEnhance.tooltip"],
                    key = "social.chat.hyperlinkEnhance.enable",
                    default = true,
                    subSettings = {
                        {
                            -- 显示图标
                            controlType = CONTROL_TYPE.CHECKBOX,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["social.chat.hyperlinkEnhance.displayIcon.title"],
                            tooltip = L["social.chat.hyperlinkEnhance.displayIcon.tooltip"],
                            key = "social.chat.hyperlinkEnhance.displayIcon",
                            default = true
                        },
                        {
                            -- 显示物品等级
                            controlType = CONTROL_TYPE.CHECKBOX,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["social.chat.hyperlinkEnhance.displayItemLevel.title"],
                            tooltip = L["social.chat.hyperlinkEnhance.displayItemLevel.tooltip"],
                            key = "social.chat.hyperlinkEnhance.displayItemLevel",
                            default = true
                        },
                        {
                            -- 显示物品分类
                            controlType = CONTROL_TYPE.CHECKBOX,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["social.chat.hyperlinkEnhance.displayItemType.title"],
                            tooltip = L["social.chat.hyperlinkEnhance.displayItemType.tooltip"],
                            key = "social.chat.hyperlinkEnhance.displayItemType",
                            default = true
                        },
                        {
                            -- 显示插槽
                            controlType = CONTROL_TYPE.CHECKBOX,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["social.chat.hyperlinkEnhance.displaySockets.title"],
                            tooltip = L["social.chat.hyperlinkEnhance.displaySockets.tooltip"],
                            key = "social.chat.hyperlinkEnhance.displaySockets",
                            default = false
                        },
                        {
                            -- 应用于公会新闻
                            controlType = CONTROL_TYPE.CHECKBOX,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["social.chat.hyperlinkEnhance.applyToGuildNews.title"],
                            tooltip = L["social.chat.hyperlinkEnhance.applyToGuildNews.tooltip"],
                            key = "social.chat.hyperlinkEnhance.applyToGuildNews",
                            default = true,
                            isVisiable = function ()
                                return not SanluliUtils
                            end
                        },
                    }
                },
                {
                    -- Tab快速切换聊天频道
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["social.chatTypeTabSwitch.title"],
                    tooltip = L["social.chatTypeTabSwitch.tooltip"],
                    key = "social.chatTypeTabSwitch.enable",
                    default = true
                },
                {
                    -- 战网聊天名称格式
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
                    -- 角色名职业染色
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["social.friendsList.characterNameClassColor.title"],
                    tooltip = L["social.friendsList.characterNameClassColor.tooltip"],
                    key = "social.friendsList.characterNameClassColor.enable",
                    default = true
                },
                {
                    -- 隐藏好友真实姓名
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["social.friendsList.hideBattleNetFriendsRealName.title"],
                    tooltip = L["social.friendsList.hideBattleNetFriendsRealName.tooltip"],
                    key = "social.friendsList.hideBattleNetFriendsRealName.enable",
                    default = false
                },
                {
                    -- 隐藏战网昵称后缀
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
                            SanluliUtils.Modules.social:SetBattleTagHideStatus(value)
                        end
                    },
                    onValueChanged = function (value)
                        if value then
                            SanluliUtils.Modules.social:SetBattleTagHideStatus(SanluliUtils.social:GetConfig("friendsList.hideBattleNetTagSuffix.method"))
                        else
                            SanluliUtils.Modules.social:SetBattleTagHideStatus(0)
                        end
                    end
                }
            }
        },
        {
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
                        SanluliUtils.Modules.addons.SetSimulationCraftMinimap(not value)
                    end,
                    isVisible = function ()
                        return true -- GetAddOnEnableState(nil, "SimulationCraft") >= 1
                    end
                }
            }
        },
        {
            name = L["client.title"],
            settings = {
                {
                    -- 反和谐 (仅简体中文客户端)
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.PROXY,
                    name = L["client.overrideArchive.disable.title"],
                    tooltip = L["client.overrideArchive.disable.tooltip"],
                    key = "client.overrideArchive.disable",
                    getValue = function()
                        return not GetCVarBool("overrideArchive")
                    end,
                    setValue = function(value)
                        SanluliUtils.Modules.client:SetOverrideArchive(not value, true)
                    end,
                    isVisible = function()
                        return GetLocale() == "zhCN"
                    end
                },
                {
                    -- 降低暴力表现 (除简体中文外的客户端)
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.PROXY,
                    name = L["client.overrideArchive.enable.title"],
                    tooltip = L["client.overrideArchive.enable.tooltip"],
                    key = "client.overrideArchive.enable",
                    getValue = function()
                        return GetCVarBool("overrideArchive")
                    end,
                    setValue = function(value)
                        SanluliUtils.Modules.client:SetOverrideArchive(value, true)
                    end,
                    isVisible = function()
                        return GetLocale() ~= "zhCN"
                    end
                },
                {
                    -- 禁用暴雪插件性能分析 https://x.com/Luckyone961/status/1843256715917050331
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["client.blzAddonProfiler.disable.title"],
                    tooltip = L["client.blzAddonProfiler.disable.tooltip"],
                    key = "client.blzAddonProfiler.disable",
                    default = false,
                    onValueChanged = function(value)
                        SanluliUtils.Modules.client:SetAddOnsProfiler(not value, true)
                    end,
                },
                --[[
                {
                    -- 区域误导
                    -- 2025/03/18: 此功能疑似在11.1.0版本失效，需要观察
                    -- 2025/03/26: 目前无法通过ConsoleExec("portal US")修改客户端地区了，此功能已经失效，移除
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["client.regionDeceive.title"],
                    tooltip = L["client.regionDeceive.tooltip"],
                    key = "client.regionDeceive.enable",
                    default = false,
                    onValueChanged = function(value)
                        SanluliUtils.Modules.client:SetRegionDeceive(value, true)
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
                            default = true
                        },
                        {
                            controlType = CONTROL_TYPE.CHECKBOX,
                            settingType = SETTING_TYPE.ADDON_VARIABLE,
                            name = L["client.profanityFilter.title"],
                            tooltip = L["client.profanityFilter.tooltip"],
                            key = "client.profanityFilter",
                            default = false,
                            onValueChanged = function(value)
                                SanluliUtils.Modules.client:SetProfanityFilter(value, true)
                            end
                        }
                    }
                },
                ]]
                {
                    -- 语言过滤器 (因简体中文客户端无法修改此选项, 提供一个修改按钮 (因为国服解锁了也改不了, 所以此选项仅在中国大陆地区以外生效))
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
                        return GetCVar("portal") ~= "CN" and GetLocale() == "zhCN"
                    end
                },
                {
                    -- 成就屏蔽修复 (针对国服回归后的新语言过滤器, 部分日期有些获得的成就发不出去, 尝试修复)
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["client.profanityFilter.achievementDataInject.title"],
                    tooltip = L["client.profanityFilter.achievementDataInject.tooltip"],
                    key = "client.profanityFilter.achievementDataInject",
                    default = true,
                    isVisible = function()
                        return SanluliUtils.Modules.client.PORTAL_CURRENT == "CN"
                    end
                },
                --[[
                {
                    -- 坐骑链接修复 https://github.com/Stanzilla/WoWUIBugs/issues/699
                    -- 2025/03/17: 暴雪已于11.1.0.58819中修复此bug, 故移除此功能
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["client.mountLinkFix.title"],
                    tooltip = L["client.mountLinkFix.tooltip"],
                    key = "client.mountLinkFix",
                    default = true,
                },
                ]]
                --[[
                {
                    -- 公会卡顿修复 https://github.com/Stanzilla/WoWUIBugs/issues/683
                    -- 2025/03/17: 暴雪于11.0.7.57637已修复此bug, 故移除此功能
                    controlType = CONTROL_TYPE.CHECKBOX,
                    settingType = SETTING_TYPE.ADDON_VARIABLE,
                    name = L["client.guildNewsFilter.title"],
                    tooltip = L["client.guildNewsFilter.tooltip"],
                    key = "client.guildNewsFix",
                    default = true,
                },
                ]]
            }
        }
    }
}

local function Register()
    local category, layout = libSettings:RegisterVerticalSettingsTable(ADDON_NAME, settingsData)
end


function Module:OnLoad()
    Register()
end
