--[[
    Name: LibBlzSettings
    Author: Sanluli36li (Olddruid@CN-Galakrond)

    This library is based on the Blizzard Settings API and is used to quickly serialize tables into Blizzard Vertical Settings Categories.
]]

local MAJOR, MINOR = "LibBlzSettings-1.0", 110103

local LibBlzSettings = LibStub:NewLibrary(MAJOR, MINOR)

if not LibBlzSettings then return end

LibBlzSettings.SETTING_TYPE = {
    ADDON_VARIABLE = 1,
    CONSOLE_VARIABLE = -1,
    PROXY = 2,
}

LibBlzSettings.CONTROL_TYPE = {
    -- Single Control                   单一控件
    CHECKBOX = 1,                       -- 选择框
    SLIDER = 2,                         -- 滑动条
    DROPDOWN = 3,                       -- 下拉菜单
    -- EDITBOX = 4,                        -- 输入框(预留)
    -- COLOR = 5,                          -- 颜色选择
    -- UI Element                       界面元素
    BUTTON = 9,                         -- 按钮
    SECTION_HEADER = 10,                -- 表头文字
    -- KEY_BINDING = 11,                -- 按键绑定(预留)
    -- Compound Control                 复合控件
    CHECKBOX_AND_SLIDER = 22,           -- 选择框和滑动条
    CHECKBOX_AND_DROPDOWN = 23,         -- 选择框和下拉菜单
    -- CHECKBOX_AND_EDITBOX = 24,          -- 选择框和输入框(预留)
    -- CHECKBOX_AND_COLOR = 25,            -- 选择框和颜色选择(预留)
    CHECKBOX_AND_BUTTON = 29,           -- 选择框和按钮
    -- Custom                           自定义
    CUSTOM_SETTINGS_CONTROL = 51,       -- 自定义控件
    CUSTOM_FRAME = 52,                  -- 自定义框体 (非控制器 例如: 预览、表头等...)
    LIB_SHARED_MEDIA_DROPDOWN = 101,    -- 下拉菜单用以选择一种LibSharedMedia素材类型, 需要LibSharedMedia-3.0库(这应当在你的插件中包含), 否则不会显示
}

local SETTING_TYPE = LibBlzSettings.SETTING_TYPE
local CONTROL_TYPE = LibBlzSettings.CONTROL_TYPE
local Utils = {}

local SETTING_TYPE_REQUIRE = {
    [SETTING_TYPE.ADDON_VARIABLE] = {},
    [SETTING_TYPE.PROXY] = {
        getValue = "function",
        setValue = "function"
    }
}

local CONTROL_TYPE_METADATA = {
    [CONTROL_TYPE.CHECKBOX] = {                 -- 选择框
        setting = {
            varType = Settings.VarType.Boolean
        },
        requireArguments = {},
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local setting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.Boolean)

            local data = {
                name = dataTbl.name,
                tooltip = dataTbl.tooltip,
                setting = setting,
                options = {}
            }

            local initializer = Settings.CreateSettingInitializer("SettingsCheckboxControlTemplate", data)

            if dataTbl.canSearch or dataTbl.canSearch == nil then
                initializer:AddSearchTags(dataTbl.name)
            end

            layout:AddInitializer(initializer)

            return setting, initializer
        end
    },
    [CONTROL_TYPE.SLIDER] = {                   -- 滑动条
        setting = {
            varType = Settings.VarType.Number
        },
        requireArguments = {
            minValue = "number",
            maxValue = "number",
            step = "number"
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local setting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.Number)

            local options = Settings.CreateSliderOptions(dataTbl.minValue, dataTbl.maxValue, dataTbl.step)

            if type(dataTbl.format) == "function" then
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, dataTbl.format)
            else
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function (value)
                    return value
                end)
            end

            local data = {
                name = dataTbl.name,
                tooltip = dataTbl.tooltip,
                setting = setting,
                options = options,
            }

            local initializer = Settings.CreateSettingInitializer("SettingsSliderControlTemplate", data)

            if dataTbl.canSearch or dataTbl.canSearch == nil then
                initializer:AddSearchTags(dataTbl.name)
            end

            layout:AddInitializer(initializer)

            return setting, initializer
        end
    },
    [CONTROL_TYPE.DROPDOWN] = {                 -- 下拉菜单
        setting = {},
        requireArguments = {
            options = function (data)
                if type(data) == "table" and #data >= 1 then
                    local vaildOption = 0
                    for i, option in pairs(data) do
                        if not (type(option) == "string" or (type(option) == "table")) then
                            return false
                        else
                            vaildOption = vaildOption + 1
                        end
                    end
                    return vaildOption > 0
                else
                    return false
                end
            end
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local options, varType = Utils.CreateOptions(dataTbl.options)
            local setting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl, database, varType)

            local data = {
                name = dataTbl.name,
                tooltip = dataTbl.tooltip,
                setting = setting,
                options = options,
            }

            local initializer = Settings.CreateSettingInitializer("SettingsDropdownControlTemplate", data)

            if dataTbl.canSearch or dataTbl.canSearch == nil then
                initializer:AddSearchTags(dataTbl.name)
            end

            layout:AddInitializer(initializer)

            return setting, initializer
        end
    },
    [CONTROL_TYPE.BUTTON] = {                   -- 按钮
        requireArguments = {
            execute = "function"
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local checkboxSetting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.Boolean)

            local data = {
                name = dataTbl.name,
                tooltip = dataTbl.tooltip,
                setting = checkboxSetting,
                buttonText = dataTbl.buttonText,
                buttonClick = dataTbl.execute,
            }
	
            local initializer = Settings.CreateElementInitializer("SettingButtonControlTemplate", data)

            if dataTbl.canSearch or dataTbl.canSearch == nil then
                initializer:AddSearchTags(dataTbl.name)
                initializer:AddSearchTags(dataTbl.buttonText)
            end

            layout:AddInitializer(initializer)

            return nil, initializer
        end
    },
    [CONTROL_TYPE.SECTION_HEADER] = {           -- 表头文字
        requireArguments = {
            name = "string",
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local data = {
                name = dataTbl.name,
                tooltip = dataTbl.tooltip,
            }

            local initializer = Settings.CreateElementInitializer("SettingsListSectionHeaderTemplate", data)

            layout:AddInitializer(initializer)

            return nil, initializer
        end
    },
    [CONTROL_TYPE.CHECKBOX_AND_SLIDER] = {      -- 选择框和滑动条
        setting = {
            inherits = CONTROL_TYPE.CHECKBOX
        },
        requireArguments = {
            slider = CONTROL_TYPE.SLIDER
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local checkboxSetting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.Boolean)
            local sliderSetting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl.slider, database, Settings.VarType.Number, dataTbl.slider.name or dataTbl.name)

            local options = Settings.CreateSliderOptions(dataTbl.slider.minValue, dataTbl.slider.maxValue, dataTbl.slider.step)

            if type(dataTbl.slider.format) == "function" then
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, dataTbl.slider.format)
            else
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function (value)
                    return value
                end)
            end
            
            local data = {
                name = dataTbl.name,
                tooltip = dataTbl.tooltip,
                setting = checkboxSetting,  -- 把选择框的设置项单独加进去 子选项才会跟着该选项锁定
                cbSetting = checkboxSetting,
                cbLabel = dataTbl.name,
                cbTooltip = dataTbl.tooltip,
                sliderSetting = sliderSetting,
                sliderOptions = options,
                sliderLabel = dataTbl.slider.name or dataTbl.name,
                sliderTooltip = dataTbl.slider.tooltip or dataTbl.tooltip,
            }
            local initializer = Settings.CreateSettingInitializer("SettingsCheckboxSliderControlTemplate", data)

            if dataTbl.canSearch or dataTbl.canSearch == nil then
                initializer:AddSearchTags(dataTbl.name)
            end

            layout:AddInitializer(initializer)

            return checkboxSetting, initializer
        end
    },
    [CONTROL_TYPE.CHECKBOX_AND_DROPDOWN] = {    -- 选择框和下拉菜单
        setting = {
            inherits = CONTROL_TYPE.CHECKBOX,
        },
        requireArguments = {
            dropdown = CONTROL_TYPE.DROPDOWN
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local dropdownOptions, dropdownVarType = Utils.CreateOptions(dataTbl.dropdown.options)
            local checkboxSetting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.Boolean)
            local dropdownSetting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl.dropdown, database, dropdownVarType, dataTbl.dropdown.name or dataTbl.name)

            local data = {
                name = dataTbl.name,
                tooltip = dataTbl.tooltip,
                setting = checkboxSetting,  -- 把选择框的设置项单独加进去 子选项才会跟着该选项锁定
                cbSetting = checkboxSetting,
                cbLabel = dataTbl.name,
                cbTooltip = dataTbl.tooltip,
                dropdownSetting = dropdownSetting,
                dropdownOptions = dropdownOptions,
                dropDownLabel = dataTbl.dropdown.name or dataTbl.name,
                dropDownTooltip = dataTbl.dropdown.tooltip or dataTbl.tooltip,
            }
            local initializer = Settings.CreateSettingInitializer("SettingsCheckboxDropdownControlTemplate", data)

            if dataTbl.canSearch or dataTbl.canSearch == nil then
                initializer:AddSearchTags(dataTbl.name)
            end

            layout:AddInitializer(initializer)

            return checkboxSetting, initializer
        end
    },
    [CONTROL_TYPE.CHECKBOX_AND_BUTTON] = {      -- 选择框和按钮
        setting = {
            inherits = CONTROL_TYPE.CHECKBOX
        },
        requireArguments = {
            button = CONTROL_TYPE.BUTTON
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local checkboxSetting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.Boolean)

            local data = {
                name = dataTbl.name,
                tooltip = dataTbl.tooltip,
                setting = checkboxSetting,
                options = {},
                buttonText = dataTbl.button.buttonText,
                OnButtonClick = dataTbl.button.execute,
                clickRequiresSet = dataTbl.button.requireSet,
            }

            local initializer = Settings.CreateSettingInitializer("SettingsCheckboxWithButtonControlTemplate", data)

            if dataTbl.canSearch or dataTbl.canSearch == nil then
                initializer:AddSearchTags(dataTbl.name)
            end

            layout:AddInitializer(initializer)

            return checkboxSetting, initializer
        end
    },
    [CONTROL_TYPE.CUSTOM_SETTINGS_CONTROL] = {  -- 自定义控件
        setting = {},
        requireArguments = {
            varType = function(data)
                if Settings.VarType[data] then
                    return true
                end
            end,
            template = "string",
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local setting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl, database, dataTbl.varType)

            local data = {
                name = dataTbl.name,
                tooltip = dataTbl.tooltip,
                setting = setting,
                options = {}
            }

            local initializer = Settings.CreateSettingInitializer(dataTbl.template, data)

            if dataTbl.canSearch or dataTbl.canSearch == nil then
                initializer:AddSearchTags(dataTbl.name)
            end

            layout:AddInitializer(initializer)

            return setting, initializer
        end
    },
    [CONTROL_TYPE.CUSTOM_FRAME] = {             -- 自定义框体
        requireArguments = {
            template = "string",
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local initializer = Settings.CreatePanelInitializer(dataTbl.template, dataTbl)
            layout:AddInitializer(initializer)
            return nil, initializer
        end
    },
    [CONTROL_TYPE.LIB_SHARED_MEDIA_DROPDOWN] = {
        setting = {
            require = function ()
                if LibStub("LibSharedMedia-3.0") then
                    return true
                else
                    return false
                end
            end
        },
        requireArguments = {
            mediaType = function (data)
                for _, type in pairs(LibStub("LibSharedMedia-3.0").MediaType) do
                    if data == type then
                        return true
                    end
                end
            end
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local lib = LibStub("LibSharedMedia-3.0")

            local setting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.String)

            local function OnOptionEnter(data)
                if dataTbl.mediaType == lib.MediaType.FONT and LibBlzSettings.SharedMediaPreview.Font then
                    LibBlzSettings.SharedMediaPreview.Font:SetFont(data.value, "40", "OUTLINE")
                    LibBlzSettings.SharedMediaPreview.Font:SetText((PREVIEW == " Priview" and PREVIEW) or (PREVIEW.." Priview"))
                end
            end

            local function GetOptions()
                local container = Settings.CreateControlTextContainer()

                for _, name in ipairs(lib:List(dataTbl.mediaType)) do
                    local source = lib:Fetch(dataTbl.mediaType, name)
                    container:Add(source, name)
                end

                local data = container:GetData()
				for index, optionData in ipairs(data) do
					optionData.onEnter = OnOptionEnter
				end

                return data
            end

            local function OnShow()
                if not LibBlzSettings.SharedMediaPreview then
                    LibBlzSettings.SharedMediaPreview = CreateFrame("Frame", nil, SettingsPanel)
                    LibBlzSettings.SharedMediaPreview:SetPoint("CENTER", SettingsPanel, "RIGHT")
                    LibBlzSettings.SharedMediaPreview:SetFrameStrata("TOOLTIP")
                end

                if dataTbl.mediaType == lib.MediaType.FONT then
                    if not LibBlzSettings.SharedMediaPreview.Font then
                        LibBlzSettings.SharedMediaPreview.Font = LibBlzSettings.SharedMediaPreview:CreateFontString()
                        LibBlzSettings.SharedMediaPreview.Font:SetParent(LibBlzSettings.SharedMediaPreview)
                        LibBlzSettings.SharedMediaPreview.Font:SetPoint("CENTER", SettingsPanel, "RIGHT")
                    end

                    LibBlzSettings.SharedMediaPreview.Font:SetFont(setting:GetValue(), "40", "OUTLINE")
                    LibBlzSettings.SharedMediaPreview.Font:SetText((PREVIEW == " Priview" and PREVIEW) or (PREVIEW.." Priview"))
                    LibBlzSettings.SharedMediaPreview.Font:Show()
                end

                LibBlzSettings.SharedMediaPreview:Show()
            end

            local function OnHide()
                if LibBlzSettings.SharedMediaPreview.Font then
                    LibBlzSettings.SharedMediaPreview.Font:Hide()
                end

                LibBlzSettings.SharedMediaPreview:Hide()
            end

            local initializer = Settings.CreateDropdown(category, setting, GetOptions, dataTbl.tooltip)

            initializer.OnShow = OnShow
            initializer.OnHide = OnHide

            return setting, initializer
        end,

        onControlInit = function (frame, dataTbl)
            --[[
            local source = {}
            --
            frame.Control.Dropdown:RegisterCallback(DropdownButtonMixin.Event.OnUpdate, function (...)
                local lib = LibStub("LibSharedMedia-3.0")

                if dataTbl.mediaType == lib.MediaType.FONT then
                    source.font, source.fontSize = frame.Control.Dropdown.Text:GetFont()
                    frame.Control.Dropdown.Text:SetFont(frame:GetSetting():GetValue(), source.fontSize)
                end
                
            end)

            frame.Control.Dropdown:RegisterCallback(DropdownButtonMixin.Event.OnMenuOpen, function (...)
                if frame.Control.Dropdown.menu then
                end
            end)
            frame.Release = function()
                frame.Control.Dropdown.Text:SetFont(source.font, source.fontSize)
                frame.Release = SettingsDropdownControlMixin.Release
                SettingsDropdownControlMixin.Release(frame)
            end
            ]]
        end
    }
}

function LibBlzSettings.RegisterSetting(addOnName, category, dataTbl, database, varType, name)

    local default = dataTbl.default
    if varType ~= type(dataTbl.default) then
        if varType == Settings.VarType.Boolean then
            default = false
        elseif varType == Settings.VarType.Number then
            default = 1
        elseif varType == Settings.VarType.String then
            default = ""
        end
    end

    local setting

    if dataTbl.settingType == SETTING_TYPE.ADDON_VARIABLE then
        setting = Settings.RegisterAddOnSetting(category, addOnName.."."..dataTbl.key, dataTbl.key, database, varType, dataTbl.name or name, default)
    elseif dataTbl.settingType == SETTING_TYPE.PROXY then
        setting = Settings.RegisterProxySetting(category, addOnName.."."..dataTbl.key, varType, dataTbl.name or name, default, dataTbl.getValue, dataTbl.setValue)
    end

    -- 当值改变时调用回调函数
    if type(dataTbl.onValueChanged) == "function" then
        local function OnValueChanged(_, value)
            dataTbl.onValueChanged(value)
        end
        setting:SetValueChangedCallback(OnValueChanged)
    end

    return setting
end

function Utils.CreateOptions(options)
    local varType = Settings.VarType.Number
    local entrys = {}
    if options then
        for i, option in ipairs(options) do
            if type(option) == "string" then
                tinsert(entrys, {i, option})
            elseif type(option) == "table" then
                if #option == 0 and option.name then
                    tinsert(entrys, {option.value or i, option.name, option.tooltip})
                    if option.value and type(option.value) ~= "number" then
                        varType = Settings.VarType.String
                    end
                elseif #option == 1 then
                    tinsert(entrys, {i, option[1]})
                elseif #option == 2 then
                    tinsert(entrys, {i, option[1], option[2]})
                elseif #option == 3 then
                    tinsert(entrys, {option[1], option[2], option[3]})
                    if type(option[1]) ~= "number" then
                        varType = Settings.VarType.String
                    end
                end
            end
        end
    end

    local function GetOptions ()
        local container = Settings.CreateControlTextContainer()

        for _, entry in ipairs(entrys) do
            if varType == Settings.VarType.String then
                container:Add(tostring(entry[1]), entry[2], entry[3])
            else
                container:Add(entry[1], entry[2], entry[3])
            end
        end

        return container:GetData()
    end

    return GetOptions, varType
end

function Utils.CheckControl(dataTbl, controlType)
    controlType = controlType or dataTbl.controlType

    if CONTROL_TYPE_METADATA[controlType] then
        if CONTROL_TYPE_METADATA[controlType].setting then
            -- 检查设置键名
            if type(dataTbl.key) ~= "string" then
                return false
            end
            -- 检查要求
            if type(CONTROL_TYPE_METADATA[controlType].setting.require) == "function" and not CONTROL_TYPE_METADATA[controlType].setting.require() then
                return false
            end
            -- 检查继承类型
            if CONTROL_TYPE_METADATA[controlType].setting.inherits and not Utils.CheckControl(dataTbl, CONTROL_TYPE_METADATA[controlType].setting.inherits) then
                return false
            end
            -- 检查选项类型
            if type(SETTING_TYPE_REQUIRE[dataTbl.settingType]) == "table" then
                for k, varType in pairs(SETTING_TYPE_REQUIRE[dataTbl.settingType]) do
                    if not (dataTbl[k] and (
                        (type(varType) == "string" and type(dataTbl[k]) == varType) or
                        (type(varType) == "function" and varType(dataTbl[k]))
                    )) then
                        return false
                    end
                end
            else
                return false
            end
        end
        -- 检查必要参数完整性
        if CONTROL_TYPE_METADATA[controlType].requireArguments then
            for k, varType in pairs(CONTROL_TYPE_METADATA[controlType].requireArguments) do
                -- 检查必要参数是否完整
                if not (dataTbl[k] and (
                    (CONTROL_TYPE_METADATA[varType] and Utils.CheckControl(dataTbl[k], varType)) or -- 子选项
                    (type(varType) == "string" and type(dataTbl[k]) == varType) or                  -- 对应类型
                    (type(varType) == "function" and varType(dataTbl[k]))                           -- 检查函数
                )) then
                    return false
                end
            end
        end
    end
    return true
end

local function SetupControl(addOnName, category, layout, dataTbl, database)
    if CONTROL_TYPE_METADATA[dataTbl.controlType] and Utils.CheckControl(dataTbl) then
        --[[
        if type(dataTbl.isVisible) == "function" and not dataTbl.isVisible() then
            return
        end
        ]]
        if type(CONTROL_TYPE_METADATA[dataTbl.controlType].buildFunction) == "function" then
            -- 指定额外的表 (而不是分类使用的表) 来储存数据
            if type(dataTbl.database) == "table" then
                database = dataTbl.database
            elseif type(dataTbl.database) == "string" and type(_G[dataTbl.database]) == "table" then
                database = _G[dataTbl.database]
            end

            local setting, initializer = CONTROL_TYPE_METADATA[dataTbl.controlType].buildFunction(addOnName, category, layout, dataTbl, database)

            if not initializer then
                return
            end

            initializer.LibBlzSettingsData = dataTbl

            if dataTbl.newFeature then
                function initializer:IsNewTagShown()
                    return true
                end
            end

            if CONTROL_TYPE_METADATA[dataTbl.controlType].setting then
                -- 添加可更改标记
                if type(dataTbl.isModifiable) == "function" then
                    initializer:AddModifyPredicate(dataTbl.isModifiable)
                end

                -- 构建子配置项
                if dataTbl.subSettings then
                    local isModifiable
                    if type(dataTbl.subSettingsModifiable) == "function" then
                        isModifiable = dataTbl.subSettingsModifiable
                    elseif setting then
                        isModifiable = function()
                            return setting:GetValue()
                        end
                    end

                    for _, subDataTbl in ipairs(dataTbl.subSettings) do
                        local _, subInitializer = SetupControl(addOnName, category, layout, subDataTbl, database)
                        if subInitializer and isModifiable then
                            subInitializer:SetParentInitializer(initializer, isModifiable)
                        end
                    end
                end
            end

            return setting, initializer
        end
    end
end

local function BuildCategory(addOnName, dataTbl, database, parentCategory)
    local category, layout
    if parentCategory then
        if dataTbl.frame then
            -- 传统布局(使用框体)
            category, layout = Settings.RegisterCanvasLayoutSubcategory(parentCategory, dataTbl.frame, dataTbl.name)
        else
            -- 纵向布局
            category, layout = Settings.RegisterVerticalLayoutSubcategory(parentCategory, dataTbl.name)
        end
        
    else
        if dataTbl.frame then
            -- 传统布局(使用框体)
            category, layout = Settings.RegisterCanvasLayoutCategory(dataTbl.frame, dataTbl.name or addOnName)
        else
            -- 纵向布局
            category, layout = Settings.RegisterVerticalLayoutCategory(dataTbl.name or addOnName)
        end
        
    end

    -- 仅纵向布局才继续初始化
    if layout:IsVerticalLayout() then
        layout.displayInitializers = {}

        -- 每次重新判断是否显示
        function layout:GetInitializers()
            table.wipe(self.displayInitializers)
            for i, initializer in ipairs(self.initializers) do
                if initializer.LibBlzSettingsData then
                    if not (type(initializer.LibBlzSettingsData.isVisible) == "function" and not initializer.LibBlzSettingsData.isVisible()) then
                        tinsert(self.displayInitializers, initializer)
                    end
                end
            end

            return self.displayInitializers
        end

        function layout:Refresh()
            if SettingsPanel:GetCurrentLayout() == self then
                SettingsPanel:DisplayLayout(self)
            end
        end

        if type(database) == "table" then
            -- 提供了表类型作为数据库, 不做额外处理
        elseif type(database) == "string" and type(_G[database]) == "table" then
            -- 提供字符串类型, 且对应的全局变量为表类型: 将其作为数据库使用
            database = _G[database]
        else
            -- 如果未指定数据库, 变量将储存到这个空表
            -- 实际上这个表不会被游戏储存, Reload或登出后所有储存的变量都会丢失
            database = {}
        end

        -- 如果此选项分类指定了储存数据用的数据表 将覆盖指定的数据库(此数据库也将应用至子分类以及子选项中)
        if type(dataTbl.database) == "table" then
            database = dataTbl.database
        elseif type(dataTbl.database) == "string" and type(_G[dataTbl.database]) == "table" then
            database = _G[dataTbl.database]
        end


        -- 注册设置项目
        if type(dataTbl.settings) == "table" then
            for _, settingDataTbl in ipairs(dataTbl.settings) do
                SetupControl(addOnName, category, layout, settingDataTbl, database)
            end
        end

        -- 注册子选项菜单
        if not parentCategory and type(dataTbl.subCategorys) == "table" then
            for _, subDataTbl in ipairs(dataTbl.subCategorys) do
                BuildCategory(addOnName, subDataTbl, database, category)
            end
        end
    end

    return category, layout
end

----------------------------------------
---   Blizzard Function Secure Hook  ---
----------------------------------------

hooksecurefunc(SettingsControlMixin, "Init", function (self, initializer)
    if initializer and initializer.LibBlzSettingsData then
        local data = initializer.LibBlzSettingsData
        if type(CONTROL_TYPE_METADATA[data.controlType].onControlInit) == "function" then
            CONTROL_TYPE_METADATA[data.controlType].onControlInit(self, initializer.LibBlzSettingsData)
        end
    end
end)

hooksecurefunc(SettingsCheckboxDropdownControlMixin, "Init", function (self, initializer)
    if initializer and initializer.LibBlzSettingsData then
        -- Defaults...
        local function OnCheckboxSettingValueChanged(o, setting, value)
            self.Checkbox:SetValue(value)
            self:EvaluateState()
        end
        self.cbrHandles:SetOnValueChangedCallback(initializer.data.cbSetting:GetVariable(), OnCheckboxSettingValueChanged)

        local function OnDropdownSettingValueChanged(o, setting, value)
            local dropdownOptions = initializer.data.dropdownOptions
            local dropdownSetting = initializer.data.dropdownSetting

            local inserter = Settings.CreateDropdownOptionInserter(dropdownOptions);
	        local initDropdownTooltip = Settings.CreateOptionsInitTooltip(dropdownSetting, initializer:GetName(), initializer:GetTooltip(), dropdownOptions);
            Settings.InitDropdown(self.Control.Dropdown, dropdownSetting, inserter, initDropdownTooltip)
        end
        self.cbrHandles:SetOnValueChangedCallback(initializer.data.dropdownSetting:GetVariable(), OnDropdownSettingValueChanged);

        -- 暴雪自带的下拉菜单的选项不会跟随父选项更新禁用, 覆盖方法
        function self:EvaluateState()
            SettingsCheckboxDropdownControlMixin.EvaluateState(self)
            local enabled = SettingsControlMixin.IsEnabled(self)
            self.Control:SetEnabled(enabled and initializer.data.cbSetting:GetValue())
            self.Checkbox:SetEnabled(enabled)
	        self:DisplayEnabled(enabled)
        end
        -- 用完记得还回去
        function self:Release()
            -- 选择框不会自动重置 防止复用时被禁用
            self.Checkbox:SetEnabled(true)
	        self:DisplayEnabled(true)

            self.EvaluateState = SettingsCheckboxDropdownControlMixin.EvaluateState
            self.Release = SettingsCheckboxDropdownControlMixin.Release
            SettingsCheckboxDropdownControlMixin.Release(self)
        end

        self:EvaluateState()
    end
end)

--[[
    STATIC
    - mustChooseKey boolean 若为false, 可以选择不绑定任何按键
    - altTooltip    string  ALT键鼠标提示信息
    - ctrlTooltip   string  CTRL键鼠标提示信息
    - shiftTooltip  string  SHIFT键鼠标提示信息
    - noneTooltip   string  不绑定键位的鼠标提示信息
]]
function LibBlzSettings.ModifiedClickOptions(mustChooseKey, altTooltip, ctrlTooltip, shiftTooltip, noneTooltip)
    return {
        {value = "ALT", name = ALT_KEY, tooltip = altTooltip},
        {value = "CTRL", name = CTRL_KEY, tooltip = ctrlTooltip},
        {value = "SHIFT", name = SHIFT_KEY, tooltip = shiftTooltip},
        (mustChooseKey and {value = "NONE", name = NONE_KEY, tooltip = noneTooltip}) or nil
    }
end


function LibBlzSettings.RegisterControl(name, buildFunction, requireArguments, settingMeta)
    if not CONTROL_TYPE_METADATA[name] then
        CONTROL_TYPE_METADATA[name] = {
            setting = settingMeta,
            requireArguments = requireArguments,
            buildFunction = buildFunction,
        }
    end
end

--[[
    - addOnName     string  插件名称, 这个名称将作为Settings中设置项内部的键名前缀
    - dataTbl       table   选项数据表
    - database      table   储存数据的表, 它必须是一个table类型, 否则选项菜单能够正常工作, 但是你所有的选项都不会被保存
    - addToOptions  boolean 如果留空或为true, LibBlzSettings将会将此分类页面直接添加到选项菜单的插件页下
]]
function LibBlzSettings:RegisterVerticalSettingsTable(addOnName, dataTbl, database, addToOptions)
    if addToOptions == nil then
        addToOptions = true
    end

    if dataTbl and type(dataTbl) == "table" then
        local category, layout = BuildCategory(addOnName, dataTbl, database)
        if addToOptions then
            Settings.RegisterAddOnCategory(category)
        end
        return category, layout
    end
end
