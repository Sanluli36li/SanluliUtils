local MAJOR, MINOR = "LibBlzSettings-1.0", 1

local LibBlzSettings = LibStub:NewLibrary(MAJOR, MINOR)

if not LibBlzSettings then return end

local SETTING_TYPE = {
    ADDON_VARIABLE = 1,
    CONSOLE_VARIABLE = -1,
    PROXY = 2,
}

LibBlzSettings.SETTING_TYPE = SETTING_TYPE
SETTING_TYPE_REQUIRE = {
    [SETTING_TYPE.ADDON_VARIABLE] = {},
    [SETTING_TYPE.PROXY] = {
        getValue = "function",
        setValue = "function"
    }
}

local CheckSetting
local function Check(controlType)
    return function (data)
        return CheckSetting(data, controlType)
    end
end

local function RegisterSetting(addOnName, category, dataTbl, database, varType, name)

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

local CONTROL_TYPE_REQUIRE = {
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
        requireArguments = {
            
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local setting = RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.Boolean)
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
                    for i, data in ipairs(data) do

                    end
                    return true
                else
                    return false
                end
            end
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local function GetOptions()
                local container = Settings.CreateControlTextContainer()
                for k, v in ipairs(dataTbl.options) do
                    container:Add(k, unpack(v))
                end
                return container:GetData()
            end
            local setting = RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.Number)
            local initializer = Settings.CreateDropdown(category, setting, GetOptions, dataTbl.tooltip)
            return setting, initializer
        end
    },
    [CONTROL_TYPE.CHECKBOX_AND_DROPDOWN] = {
        setting = {
            inherits = CONTROL_TYPE.CHECKBOX,
        },
        requireArguments = {
            dropdown = Check(CONTROL_TYPE.DROPDOWN)
        },
        buildFunction = function (addOnName, category, layout, dataTbl, database)
            local checkboxSetting = RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.Boolean)

            local function GetOptions()
                local container = Settings.CreateControlTextContainer()
                for k, v in ipairs(dataTbl.dropdown.options) do
                    container:Add(k, unpack(v))
                end
                return container:GetData()
            end

            local dropdownSetting = RegisterSetting(addOnName, category, dataTbl.dropdown, database, Settings.VarType.Number, dataTbl.dropdown.name or dataTbl.name)

            local initializer = CreateSettingsCheckboxDropdownInitializer(
                checkboxSetting, dataTbl.name, dataTbl.tooltip,
                dropdownSetting, GetOptions, dataTbl.dropdown.name or dataTbl.name, dataTbl.dropdown.tooltip or dataTbl.tooltip
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
            local setting = RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.Number)

            local options = Settings.CreateSliderOptions(dataTbl.minValue, dataTbl.maxValue, dataTbl.step)

            -- if dataTbl.labelFormatter
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
        slider = Check(CONTROL_TYPE.SLIDER)
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

            local setting = RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.String)

            local initializer = Settings.CreateDropdown(category, setting, GetOptions, dataTbl.tooltip)

            return setting, initializer
        end
    }
}

CheckSetting = function (dataTbl, controlType)
    controlType = controlType or dataTbl.controlType

    if CONTROL_TYPE_REQUIRE[controlType] then
        if CONTROL_TYPE_REQUIRE[controlType].setting then
            -- 检查设置键名
            if type(dataTbl.key) ~= "string" then
                return false
            end
            -- 检查要求
            if type(CONTROL_TYPE_REQUIRE[controlType].setting.require) == "function" and not CONTROL_TYPE_REQUIRE[controlType].setting.require() then
                return false
            end
            -- 检查继承类型
            if CONTROL_TYPE_REQUIRE[controlType].setting.inherits and not CheckSetting(dataTbl, CONTROL_TYPE_REQUIRE[controlType].setting.inherits) then
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
        if CONTROL_TYPE_REQUIRE[controlType].requireArguments then
            for k, varType in pairs(CONTROL_TYPE_REQUIRE[controlType].requireArguments) do
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

local function SetupSetting(addOnName, category, layout, dataTbl, database)
    if CONTROL_TYPE_REQUIRE[dataTbl.controlType] and CheckSetting(dataTbl) then
        if type(dataTbl.isVisible) == "function" and not dataTbl.isVisible() then
            return
        end
        if type(CONTROL_TYPE_REQUIRE[dataTbl.controlType].buildFunction) == "function" then
            local setting, initializer = CONTROL_TYPE_REQUIRE[dataTbl.controlType].buildFunction(addOnName, category, layout, dataTbl, database)

            if CONTROL_TYPE_REQUIRE[dataTbl.controlType].setting then
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
                        local _, subInitializer = SetupSetting(addOnName, category, layout, subDataTbl, database)
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
        category, layout = Settings.RegisterVerticalLayoutCategory(dataTbl.name)
    end

    -- 注册设置项目
    if type(dataTbl.settings) == "table" then
        for _, settingDataTbl in ipairs(dataTbl.settings) do
            SetupSetting(addOnName, category, layout, settingDataTbl, database)
        end
    end

    -- 注册子选项菜单
    if type(dataTbl.subCategorys) == "table" then
        for _, subDataTbl in ipairs(dataTbl.subCategorys) do
            BuildCategory(addOnName, subDataTbl, database, category)
        end
    end

    return category, layout
end

--[[
    - dataTbl
    - database      储存数据的表, 它必须是一个table类型, 否则选项菜单能够正常工作, 但是你所有的选项都不会被保存
]]
function LibBlzSettings:RegisterBlizzardVerticalSettingsTable(addOnName, dataTbl, database)
    if not (database and type(database) == "table") then
        database = {}
    end

    if dataTbl and type(dataTbl) == "table" then
        return BuildCategory(addOnName, dataTbl, database)
    end
end
