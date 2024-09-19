local ADDON_NAME, SanluliUtils = ...

local Module = SanluliUtils:NewModule("settings")
local L = SanluliUtils.Locale

local ControlType = {
    SECTION_HEADER = 1,         -- 标题
    CHECKBOX = 2,               -- 选择框
    DROPDOWN = 3,               -- 下拉菜单
    CHECKBOX_AND_DROPDOWN = 4,  -- 选择框和下拉菜单
}

local SettingType = {
    ADDON_VAR = 1,              -- 插件变量
    PROXY = 2                   -- 代理选项
}

--[[
    module          string      模块名称
    title           string      选项中显示的模块标题
    settings        table[]     当前分类的选项列表   
        controlType     number      控制器类型 (必须)
        settingType     number      选项类型 (必须)
        title           string      选项标题 (必须)
        tooltip         string      鼠标提示信息
        default                     默认值 (必须)
        key             string      储存在插件配置文件中的配置键名 (必须)
        getValue        function    如果选项类型是PROXY, 必须
        setValue        function    如果选项类型是PROXY, 必须
        onValueChanged  function    当该选项值被改变时调用此函数, 新的值将作为参数传递
        dropdown        table       下拉菜单 如果选项类型是CHECK_AND_DROPDOWN, 必须
            settingType     number      选项类型 (必须)
            key             string      下拉菜单的选项配置键名 (必须)
            default                     默认值 (必须)
            options         table[]
                1               string      下拉菜单项目标题 (必须)
                2               string      下拉菜单项目鼠标提示信息
        subSettings     table[]     该选项的子选项列表, 具体表现标题缩进
    subCategorys    table[]     子分类列表

]]


local settingsData = {
    module = "general",
    title = L["general.title"],
    settings = {
        {
            controlType = ControlType.CHECKBOX_AND_DROPDOWN,
            settingType = SettingType.ADDON_VAR,
            title = L["general.autoRepair.title"],
            tooltip = L["general.autoRepair.tooltip"],
            key = "general.autoRepair.enable",
            default = true,
            dropdown = {
                settingType = SettingType.ADDON_VAR,
                key = "general.autoRepair.funds",
                default = 2,
                options = {
                    { L["general.autoRepair.funds.personal.title"], L["general.autoRepair.funds.personal.tooltip"] },
                    { L["general.autoRepair.funds.guild.title"], L["general.autoRepair.funds.guild.tooltip"] },
                }
            }
        },
        {
            controlType = ControlType.CHECKBOX_AND_DROPDOWN,
            settingType = SettingType.ADDON_VAR,
            title = L["general.autoSellJunk.title"],
            tooltip = L["general.autoSellJunk.tooltip"],
            key = "general.autoSellJunk.enable",
            default = true,
            dropdown = {
                settingType = SettingType.ADDON_VAR,
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
            controlType = ControlType.CHECKBOX,
            settingType = SettingType.ADDON_VAR,
            title = L["general.autoInputConfirm.title"],
            tooltip = L["general.autoInputConfirm.tooltip"],
            key = "general.autoInputConfirm.enable",
            default = true
        },
        {
            controlType = ControlType.CHECKBOX_AND_DROPDOWN,
            settingType = SettingType.ADDON_VAR,
            title = L["general.autoRoll.title"],
            tooltip = L["general.autoRoll.tooltip"],
            key = "general.autoRoll.enable",
            default = false,
            dropdown = {
                settingType = SettingType.ADDON_VAR,
                key = "general.autoRoll.method",
                default = 1,
                options = {
                    { L["general.autoRoll.method.greed.title"], L["general.autoRoll.method.greed.tooltip"] },
                    { L["general.autoRoll.method.pass.title"], L["general.autoRoll.method.pass.tooltip"] }
                }
            },
            testing = true
        },
        {
            controlType = ControlType.CHECKBOX,
            settingType = SettingType.ADDON_VAR,
            title = L["general.fasterAutoLoot.title"],
            tooltip = L["general.fasterAutoLoot.tooltip"],
            key = "general.fasterAutoLoot.enable",
            default = true
        },
        {
            controlType = ControlType.SECTION_HEADER,
            title = L["blizzardui.title"]
        },
        {
            controlType = ControlType.CHECKBOX,
            settingType = SettingType.ADDON_VAR,
            title = L["blizzardui.sync.actionBar.title"],
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
            controlType = ControlType.CHECKBOX,
            settingType = SettingType.ADDON_VAR,
            title = L["blizzardui.sync.raidFrame.title"],
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
            controlType = ControlType.CHECKBOX,
            settingType = SettingType.ADDON_VAR,
            title = L["blizzardui.forceShowPowerBarAltStatus.title"],
            tooltip = L["blizzardui.forceShowPowerBarAltStatus.tooltip"],
            key = "blizzardui.forceShowPowerBarAltStatus",
            default = true
        },
        {
            controlType = ControlType.SECTION_HEADER,
            title = L["blizzardui.actionBar.title"]
        },
        {
            controlType = ControlType.CHECKBOX,
            settingType = SettingType.ADDON_VAR,
            title = L["blizzardui.actionBar.hideName.title"],
            tooltip = L["blizzardui.actionBar.hideName.tooltip"],
            key = "blizzardui.actionBar.hideName",
            default = false,
            onValueChanged = function (value)
                SanluliUtils.blizzardui:SetActionBarNameDisplay(not value)
            end,
        }
    },
    subCategorys = {
        {
            module = "social",
            title = L["social.title"],
            settings = {
                {
                    controlType = ControlType.CHECKBOX,
                    settingType = SettingType.ADDON_VAR,
                    title = L["social.chatTypeTabSwitch.title"],
                    tooltip = L["social.chatTypeTabSwitch.tooltip"],
                    key = "social.chatTypeTabSwitch.enable",
                    default = true
                },
                {
                    controlType = ControlType.SECTION_HEADER,
                    title = L["social.friendsList.title"],
                },
                {
                    controlType = ControlType.CHECKBOX,
                    settingType = SettingType.ADDON_VAR,
                    title = L["social.friendsList.characterNameClassColor.title"],
                    tooltip = L["social.friendsList.characterNameClassColor.tooltip"],
                    key = "social.friendsList.characterNameClassColor.enable",
                    default = true
                },
                {
                    controlType = ControlType.CHECKBOX,
                    settingType = SettingType.ADDON_VAR,
                    title = L["social.friendsList.hideBattleNetFriendsRealName.title"],
                    tooltip = L["social.friendsList.hideBattleNetFriendsRealName.tooltip"],
                    key = "social.friendsList.hideBattleNetFriendsRealName.enable",
                    default = false
                },
                {
                    controlType = ControlType.CHECKBOX_AND_DROPDOWN,
                    settingType = SettingType.ADDON_VAR,
                    title = L["social.friendsList.hideBattleNetTagSuffix.title"],
                    tooltip = L["social.friendsList.hideBattleNetTagSuffix.tooltip"],
                    key = "social.friendsList.hideBattleNetTagSuffix.enable",
                    default = false,
                    dropdown = {
                        settingType = SettingType.ADDON_VAR,
                        key = "social.friendsList.hideBattleNetTagSuffix.method",
                        default = 1,
                        options = {
                            { L["social.friendsList.hideBattleNetTagSuffix.method.hide.title"] },
                            { L["social.friendsList.hideBattleNetTagSuffix.method.replace.title"] }
                        },
                        onValueChanged = function (value)
                            SanluliUtils.social:SetBattleTagHideStatus(value)
                        end
                    },
                    onValueChanged = function (value)
                        if value then
                            print(SanluliUtils.social:GetConfig("friendsList.hideBattleNetTagSuffix.method"))
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
            title = L["addons.title"],
            settings = {
                {
                    controlType = ControlType.SECTION_HEADER,
                    title = L["addons.simulationcraft.title"],
                    isVisible = function ()
                        return true -- GetAddOnEnableState(nil, "SimulationCraft") >= 1
                    end
                },
                {
                    controlType = ControlType.CHECKBOX,
                    settingType = SettingType.ADDON_VAR,
                    title = L["addons.simulationcraft.forceHideMinimap.title"],
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
            title = L["client.title"],
            settings = {
                {
                    controlType = ControlType.CHECKBOX,
                    settingType = SettingType.PROXY,
                    title = L["client.overrideArchive.disable.title"],
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
                    controlType = ControlType.CHECKBOX,
                    settingType = SettingType.PROXY,
                    title = L["client.overrideArchive.enable.title"],
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
                    controlType = ControlType.CHECKBOX,
                    settingType = SettingType.ADDON_VAR,
                    title = L["client.regionDeceive.title"],
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
                            controlType = ControlType.CHECKBOX,
                            settingType = SettingType.ADDON_VAR,
                            title = L["client.regionDeceive.differentRegionFix.title"],
                            tooltip = L["client.regionDeceive.differentRegionFix.tooltip"],
                            key = "client.regionDeceive.differentRegionFix",
                            default = true,
                            onValueChanged = function (value)
                                SanluliUtils.client:SetDifferentRegionFix(value, true)
                            end
                        },
                        {
                            controlType = ControlType.CHECKBOX,
                            settingType = SettingType.ADDON_VAR,
                            title = L["client.profanityFilter.title"],
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
                    controlType = ControlType.CHECKBOX,
                    settingType = SettingType.PROXY,
                    title = L["client.profanityFilter.title"],
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
            }
        }
    }
}

local function RegisterSetting(category, data, varType, name)
    if not data.key then
        return nil
    end

    local default = data.default
    if varType ~= type(data.default) then
        if varType == Settings.VarType.Boolean then
            default = false
        elseif varType == Settings.VarType.Number then
            default = 1
        elseif varType == Settings.VarType.String then
            default = ""
        end
    end

    local setting

    if data.settingType == SettingType.ADDON_VAR then
        setting = Settings.RegisterAddOnSetting(category, ADDON_NAME.."."..data.key, data.key, SanluliUtilsDB, varType, name or data.title, default)
    elseif data.settingType == SettingType.PROXY then
        if not (data.getValue and data.setValue) then
            return nil
        end
        setting = Settings.RegisterProxySetting(category, ADDON_NAME.."."..data.key, varType, name or data.title, default, data.getValue, data.setValue)
    end

    if type(data.onValueChanged) == "function" then
        local function OnValueChanged(o, setting, value)
            data.onValueChanged(value)
        end

        Settings.SetOnValueChangedCallback(ADDON_NAME.."."..data.key, OnValueChanged)
    end

    return setting
end

local Setup

local function SetupCheckbox(category, layout, data)
    if data.isVisible and not data.isVisible() then
        return
    end
    if not data.key then
        return
    end

    local setting = RegisterSetting(category, data, Settings.VarType.Boolean)

    local initializer = Settings.CreateCheckbox(category, setting, data.tooltip)

    if data.isModifiable then
        initializer:AddModifyPredicate(data.isModifiable)
    end

    -- 注册子设置项
    if data.subSettings then
        local function IsModifiable()
			return Settings.GetValue(ADDON_NAME.."."..data.key)
		end

        for _, data2 in ipairs(data.subSettings) do
            local _, subInitializer = Setup(category, layout, data2)
            if subInitializer then
                subInitializer:SetParentInitializer(initializer, IsModifiable)
            end
        end
    end

    return setting, initializer
end

local function SetupCheckboxAndDropdown(category, layout, data)
    if not (data.dropdown and data.dropdown.key and data.dropdown.options) then
        return SetupCheckbox(category, layout, data)
    end
    if not data.key then
        return
    end

    local cbSetting = RegisterSetting(category, data, Settings.VarType.Boolean)

    local function GetOptions()
        local container = Settings.CreateControlTextContainer()

        for k, v in ipairs(data.dropdown.options) do
            container:Add(k, unpack(v))
        end
        return container:GetData()
    end

    local dropdownSetting = RegisterSetting(category, data.dropdown, Settings.VarType.Number, data.dropdown.title or data.title)

    local initializer = CreateSettingsCheckboxDropdownInitializer(
        cbSetting, data.title, data.tooltip,
        dropdownSetting, GetOptions, data.dropdown.title or data.title, data.dropdown.tooltip or data.tooltip
    )

    initializer:AddSearchTags(data.title)
    layout:AddInitializer(initializer)

    if data.isModifiable then
        initializer:AddModifyPredicate(data.isModifiable)
    end

    -- 注册子设置项
    if data.subSettings then
        local function IsModifiable()
			return Settings.GetValue(ADDON_NAME.."."..data.key)
		end

        for _, data2 in ipairs(data.subSettings) do
            local _, subInitializer = Setup(category, layout, data2)
            if subInitializer then
                subInitializer:SetParentInitializer(initializer, IsModifiable)
            end
        end
    end

    return cbSetting, initializer
end

Setup = function (category, layout, data)
    if data.testing then
        data.title = L["addon.test.title"]..data.title
        data.tooltip = data.tooltip.."\n\n"..L["addon.test.tooltip"]
    end
    if data.controlType == ControlType.SECTION_HEADER then
        layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(data.title));
        if data.subSettings then
            for _, data2 in ipairs(data.subSettings) do
                local _, subInitializer = Setup(category, layout, data2)
            end
        end
    elseif data.controlType == ControlType.CHECKBOX then
        return SetupCheckbox(category, layout, data)
    elseif data.controlType == ControlType.CHECKBOX_AND_DROPDOWN then
        return SetupCheckboxAndDropdown(category, layout, data)
    end
end

local function buildCategory(data, parentCategory)
    if not data.module then
        return
    end

    local category, layout
    if parentCategory then
        category, layout = Settings.RegisterVerticalLayoutSubcategory(parentCategory, data.title)
    else
        category, layout = Settings.RegisterVerticalLayoutCategory(L["addon.name"])
    end

    category.data = data

    if data.settings then
        for _, data2 in ipairs(data.settings) do
            Setup(category, layout, data2)
        end
    end
    if data.subCategorys then
        for _, data2 in ipairs(data.subCategorys) do
            buildCategory(data2, category)
        end
    end
    return category, layout
end

local function Register()
    local category, layout = buildCategory(settingsData)
    Settings.RegisterAddOnCategory(category);
end


function Module:BeforeStartup()
    Register()
end
