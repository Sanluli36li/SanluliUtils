local MAJOR, MINOR = "LibBlzSettings-1.0", 1

local LibBlzSettings = LibStub:NewLibrary(MAJOR, MINOR)

if not LibBlzSettings then return end

local SETTING_TYPE = {
    ADDON_VARIABLE = 1,
    CONSOLE_VARIABLE = -1,
    PROXY = 2,
}
LibBlzSettings.SETTING_TYPE = SETTING_TYPE

local CONTROL_TYPE = {
    SECTION_HEADER = 1,                 -- 表头文字
    CHECKBOX = 2,                       -- 选择框
    DROPDOWN = 3,                       -- 下拉菜单
    CHECKBOX_AND_DROPDOWN = 4,          -- 选择框和下拉菜单
    SLIDER = 5,                         -- 滑动条
    CHECKBOX_AND_SLIDER = 6,            -- 选择框和滑动条
    BUTTON = 7,                         -- 按钮
    CHECKBOX_AND_BUTTON = 8,            -- 选择框和按钮

    LIB_SHARED_MEDIA_DROPDOWN = 101,    -- 下拉菜单用以选择一种LibSharedMedia素材类型, 需要LibSharedMedia-3.0库(这应当在你的插件中包含), 否则不会显示
}
LibBlzSettings.CONTROL_TYPE = CONTROL_TYPE

local Utils = {}

function Utils.RegisterSetting(addOnName, category, dataTbl, database, varType, name)

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
        local function OnValueChanged(o, setting, value)
            dataTbl.onValueChanged(value)
        end

        Settings.SetOnValueChangedCallback(addOnName.."."..dataTbl.key, OnValueChanged)
    end

    return setting
end

function Utils.CheckControlType(controlType)
    return function (data)
        return Utils.CheckControl(data, controlType)
    end
end

function Utils.CreateOptions(options)
    local varType
    if options and #options > 0 then
        varType = Settings.VarType.Number
    else
        varType = Settings.VarType.String
    end

    local function GetOptions ()
        local container = Settings.CreateControlTextContainer()

        if options then
            if varType == Settings.VarType.Number then
                for k, option in ipairs(options) do
                    if type(option) == "string" then
                        container:Add(k, option)
                    elseif type(option) == "table" then
                        container:Add(k, unpack(option))
                    end
                end
            else
                for k, option in pairs(options) do
                    if type(option) == "string" then
                        container:Add(tostring(k), option)
                    elseif type(option) == "table" then
                        container:Add(tostring(k), unpack(option))
                    end
                end
            end
        end

        return container:GetData()
    end

    return GetOptions
end

local SETTING_TYPE_REQUIRE = {
    [SETTING_TYPE.ADDON_VARIABLE] = {},
    [SETTING_TYPE.PROXY] = {
        getValue = "function",
        setValue = "function"
    }
}

local CONTROL_TYPE_METADATA = {
    [CONTROL_TYPE.SECTION_HEADER] = {
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local initializer = CreateSettingsListSectionHeaderInitializer(dataTbl.name)
            layout:AddInitializer(initializer)
            return nil, initializer
        end
    },
    [CONTROL_TYPE.CHECKBOX] = {
        setting = {
            varType = Settings.VarType.Boolean
        },
        requireArguments = {},
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local setting = Utils.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.Boolean)
            local initializer = Settings.CreateCheckbox(category, setting, dataTbl.tooltip)
            return setting, initializer
        end
    },
    [CONTROL_TYPE.DROPDOWN] = {
        setting = {

        },
        requireArguments = {
            options = function (data)
                if type(data) == "table" and #data >= 1 then
                    for i, option in pairs(data) do
                        if not (type(option) == "string" or (type(option) == "table" and type(option[1]) == "string")) then
                            return false
                        end
                    end
                    return true
                else
                    return false
                end
            end
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local setting = Utils.RegisterSetting(addOnName, category, dataTbl, database, varType)
            local initializer = Settings.CreateDropdown(category, setting, Utils.CreateOptions(dataTbl.options), dataTbl.tooltip)
            return setting, initializer
        end
    },
    [CONTROL_TYPE.CHECKBOX_AND_DROPDOWN] = {
        setting = {
            inherits = CONTROL_TYPE.CHECKBOX,
        },
        requireArguments = {
            dropdown = Utils.CheckControlType(CONTROL_TYPE.DROPDOWN)
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local checkboxSetting = Utils.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.Boolean)
            local dropdownSetting = Utils.RegisterSetting(addOnName, category, dataTbl.dropdown, database, Settings.VarType.Number, dataTbl.dropdown.name or dataTbl.name)

            local initializer = CreateSettingsCheckboxDropdownInitializer(
                checkboxSetting, dataTbl.name, dataTbl.tooltip,
                dropdownSetting, Utils.CreateOptions(dataTbl.dropdown.options), dataTbl.dropdown.name or dataTbl.name, dataTbl.dropdown.tooltip or dataTbl.tooltip
            )

            initializer:AddSearchTags(dataTbl.name)
            layout:AddInitializer(initializer)
            return checkboxSetting, initializer
        end
    },
    [CONTROL_TYPE.SLIDER] = {
        setting = {
            varType = Settings.VarType.Number
        },
        requireArguments = {
            minValue = "number",
            maxValue = "number",
            step = "number"
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local setting = Utils.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.Number)

            local options = Settings.CreateSliderOptions(dataTbl.minValue, dataTbl.maxValue, dataTbl.step)
            options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function (value)
                return value
            end)

            local initializer = Settings.CreateSlider(category, setting, options, dataTbl.tooltip);
            return setting, initializer
        end
    },
    [CONTROL_TYPE.CHECKBOX_AND_SLIDER] = {
        setting = {
            inherits = CONTROL_TYPE.CHECKBOX
        },
        requireArguments = {
            slider = Utils.CheckControlType(CONTROL_TYPE.SLIDER)
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            
        end
    },
    [CONTROL_TYPE.BUTTON] = {
        requireArguments = {
            execute = "function"
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            
        end
    },
    [CONTROL_TYPE.CHECKBOX_AND_BUTTON] = {
        setting = {
            inherits = CONTROL_TYPE.CHECKBOX
        },
        requireArguments = {
            button = Utils.CheckControlType(CONTROL_TYPE.BUTTON)
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            
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
            mediaType = "string"
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local lib = LibStub("LibSharedMedia-3.0")

            local function GetOptions()
                local container = Settings.CreateControlTextContainer()

                for k, v in ipairs(lib:List(dataTbl.mediaType)) do
                    local source = lib:Fetch(dataTbl.mediaType, v)
                    container:Add(source, v)
                end
                return container:GetData()
            end

            local setting = Utils.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.String)

            local initializer = Settings.CreateDropdown(category, setting, GetOptions, dataTbl.tooltip)

            return setting, initializer
        end,
        --[[
        onControlInit = function (frame, dataTbl)
            frame.Control.Dropdown:RegisterCallback(DropdownButtonMixin.Event.OnUpdate, function (...)
                local lib = LibStub("LibSharedMedia-3.0")

                if dataTbl.mediaType == lib.MediaType.FONT then
                    local font, fontSize = frame.Control.Dropdown.Text:GetFont()
                    frame.Control.Dropdown.Text:SetFont(frame:GetSetting():GetValue(), fontSize)
                end
                
            end)

            frame.Control.Dropdown:RegisterCallback(DropdownButtonMixin.Event.OnMenuOpen, function (...)
                if frame.Control.Dropdown.menu then
                end
            end)

        end
        ]]
    }
}

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
                    (type(varType) == "string" and type(dataTbl[k]) == varType) or
                    (type(varType) == "function" and varType(dataTbl[k]))
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
        if type(dataTbl.name) ~= "string" then
            return
        end

        if type(dataTbl.isVisible) == "function" and not dataTbl.isVisible() then
            return
        end
        if type(CONTROL_TYPE_METADATA[dataTbl.controlType].buildFunction) == "function" then
            local setting, initializer = CONTROL_TYPE_METADATA[dataTbl.controlType].buildFunction(addOnName, category, layout, dataTbl, database)

            initializer.LibBlzSettingsData = dataTbl

            if CONTROL_TYPE_METADATA[dataTbl.controlType].setting then
                -- 添加可更改标记
                if type(dataTbl.isModifiable) == "function" then
                    initializer:AddModifyPredicate(dataTbl.isModifiable)
                end

                -- 构建子配置项
                if dataTbl.subSettings then
                    local function IsModifiable()
                        return Settings.GetValue(addOnName.."."..dataTbl.key)
                    end

                    for _, subDataTbl in ipairs(dataTbl.subSettings) do
                        local _, subInitializer = SetupControl(addOnName, category, layout, subDataTbl, database)
                        if subInitializer then
                            subInitializer:SetParentInitializer(initializer, IsModifiable)
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
        category, layout = Settings.RegisterVerticalLayoutSubcategory(parentCategory, dataTbl.name)
    else
        category, layout = Settings.RegisterVerticalLayoutCategory(dataTbl.name or addOnName)
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

    return category, layout
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

    if not (database and type(database) == "table") then
        database = {}
    end

    if dataTbl and type(dataTbl) == "table" then
        local category, layout = BuildCategory(addOnName, dataTbl, database)
        if addToOptions then
            Settings.RegisterAddOnCategory(category)
        end
        return category, layout
    end
end

hooksecurefunc(SettingsControlMixin, "Init", function (self, initializer)
    if initializer and initializer.LibBlzSettingsData then
        local data = initializer.LibBlzSettingsData
        if type(CONTROL_TYPE_METADATA[data.controlType].onControlInit) == "function" then
            CONTROL_TYPE_METADATA[data.controlType].onControlInit(self, initializer.LibBlzSettingsData)
        end
    end
end)
