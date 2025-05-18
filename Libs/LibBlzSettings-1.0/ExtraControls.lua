--[[
    This is an extension of LibBlzSettings that provides some common controls that Blizzard does not use in the settings interface (and naturally does not implement).
]]

local LibBlzSettings = LibStub("LibBlzSettings-1.0")

local CONTROL_TYPE = LibBlzSettings.CONTROL_TYPE

----------------------------------------
--- Editbox Control
--- Author: KeiraMetz88, Sanluli36li
--- 
--- To use this control, define an XML template in your addon that inherits from "SettingsListElementTemplate" and set the mixin to "LibBlzSettingsEditboxControlMixin", for example:
--- "_____" should be changed to a unique prefix (such as your addon name) to prevent conflicts with other addons
--[[

<Frame name="_____EditboxControlTemplate" inherits="SettingsListElementTemplate" mixin="LibBlzSettingsEditboxControlMixin" virtual="true">
    <Size x="280" y="26"/>
    <Scripts>
        <OnLoad method="OnLoad"/>
    </Scripts>
</Frame>

]]
--- Then define your settings in the settings table:
--[[

{
    controlType = CONTROL_TYPE.EDITBOX,
    settingType = SETTING_TYPE.ADDON_VARIABLE,
    name = "This is a Editbox",
    tooltip = "This is Editbox Tooltip",
    key = "settingsKey",
    default = "Default Value",
    template = "_____EditboxControlTemplate"
},

]]
----------------------------------------
CONTROL_TYPE.EDITBOX = 4

LibBlzSettingsEditboxControlMixin = CreateFromMixins(SettingsControlMixin)

function LibBlzSettingsEditboxControlMixin:OnLoad()
    SettingsControlMixin.OnLoad(self)

    self.Editbox = CreateFrame("EditBox", nil, self, "InputBoxTemplate")

    Mixin(self.Editbox, DefaultTooltipMixin)
    DefaultTooltipMixin.OnLoad(self.Editbox)
    self.tooltipXOffset = 0

    self.Editbox:SetPoint("LEFT", self, "CENTER", -72, 0)
    self.Editbox:SetSize(280, 26)
    self.Editbox:SetAutoFocus(false)

    self.Editbox.Left:SetHeight(26)
    self.Editbox.Right:SetHeight(26)
    self.Editbox.Middle:SetHeight(26)

    self.Editbox:SetScript("OnEnable", function (editbox)
        editbox:SetTextColor(1, 1, 1)
    end)

    self.Editbox:SetScript("OnDisable", function (editbox)
        editbox:SetTextColor(0.5, 0.5, 0.5)
    end)

    self.Editbox:SetScript("OnEnterPressed", EditBox_ClearFocus)    -- 回车清楚焦点
    self.Editbox:SetScript("OnEscapePressed", EditBox_ClearFocus)   -- ESC清除焦点
end

function LibBlzSettingsEditboxControlMixin:Init(initializer)
    SettingsControlMixin.Init(self, initializer)

    local setting = self:GetSetting()
    local initTooltip = GenerateClosure(Settings.InitTooltip, initializer:GetName(), initializer:GetTooltip())

    -- self.Editbox:Init(setting:GetValue(), initTooltip)

    self.Editbox:SetText(setting:GetValue())
    self.Editbox:SetTooltipFunc(initTooltip)
    self.Editbox:SetScript("OnTextChanged", function(editbox, userInput)
        if userInput and not IMECandidatesFrame:IsShown() then  -- 限制: 用户输入/输入法框体未显示
            self:OnEditboxValueChanged(editbox:GetText())
        end
    end)

    self:EvaluateState()
end

function LibBlzSettingsEditboxControlMixin:OnSettingValueChanged(setting, value)
    SettingsControlMixin.OnSettingValueChanged(self, setting, value)
    self.Editbox:SetText(value)
end

function LibBlzSettingsEditboxControlMixin:OnEditboxValueChanged(value)
    self:GetSetting():SetValue(value)
end

function LibBlzSettingsEditboxControlMixin:EvaluateState()
    SettingsListElementMixin.EvaluateState(self)
    local enabled = SettingsControlMixin.IsEnabled(self)
    self.Editbox:SetEnabled(enabled)
    self:DisplayEnabled(enabled)
end

function LibBlzSettingsEditboxControlMixin:Release()
    self.Editbox:SetScript("OnTextChanged", nil)
    SettingsControlMixin.Release(self)
end

LibBlzSettings.RegisterControl(
    CONTROL_TYPE.EDITBOX,
    function (addOnName, category, layout, dataTbl, database)
        local template
        if dataTbl.template and C_XMLUtil.GetTemplateInfo(dataTbl.template) then
            template = dataTbl.template
        elseif C_XMLUtil.GetTemplateInfo("LibBlzSettingsEditboxControlTemplate") then
            template = "LibBlzSettingsEditboxControlTemplate"
        end

        if not template then
            return
        end

        local setting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.String)

        local data = {
            name = dataTbl.name,
            tooltip = dataTbl.tooltip,
            setting = setting,
            options = {},
        }

        local initializer = Settings.CreateSettingInitializer(template, data)

        if dataTbl.canSearch or dataTbl.canSearch == nil then
            initializer:AddSearchTags(dataTbl.name)
        end

        layout:AddInitializer(initializer)

        return setting, initializer
    end,
    {},
    {}
)

----------------------------------------
--- Checkbox and Editbox Control
--- Author: KeiraMetz88, Sanluli36li
--- 
--- To use this control, define an XML template in your addon that inherits from "SettingsListElementTemplate" and set the mixin to "LibBlzSettingsCheckboxEditboxControlMixin", for example:
--- "_____" should be changed to a unique prefix (such as your addon name) to prevent conflicts with other addons
--[[

<Frame name="_____CheckboxEditboxControlTemplate" inherits="SettingsListElementTemplate" mixin="LibBlzSettingsCheckboxEditboxControlMixin" virtual="true">
    <Size x="280" y="26"/>
    <Scripts>
        <OnLoad method="OnLoad"/>
    </Scripts>
</Frame>

]]
--- Then define your settings in the settings table:
--[[

{
    controlType = CONTROL_TYPE.CHECKBOX_AND_EDITBOX,
    settingType = SETTING_TYPE.ADDON_VARIABLE,
    name = "Checkbox and Editbox",
    tooltip = "Tooltip",
    key = "checkboxSettingsKey",
    default = true,
    editbox = {
        settingType = SETTING_TYPE.ADDON_VARIABLE,
        key = "editboxSettingsKey",
        default = "Default Value",
    }
    template = "_____CheckboxEditboxControlTemplate"
},

]]
----------------------------------------
CONTROL_TYPE.CHECKBOX_AND_EDITBOX = 24

LibBlzSettingsCheckboxEditboxControlMixin = CreateFromMixins(SettingsListElementMixin)

function LibBlzSettingsCheckboxEditboxControlMixin:OnLoad()
    SettingsListElementMixin.OnLoad(self)

    self.Checkbox = CreateFrame("CheckButton", nil, self, "SettingsCheckboxTemplate")
    self.Checkbox:SetPoint("LEFT", self, "CENTER", -80, 0)

    self.Editbox = CreateFrame("EditBox", nil, self, "InputBoxTemplate")

    Mixin(self.Editbox, DefaultTooltipMixin)
    DefaultTooltipMixin.OnLoad(self.Editbox)
    self.tooltipXOffset = 0

    self.Editbox:SetPoint("LEFT", self.Checkbox, "RIGHT", 10, 0)
    self.Editbox:SetSize(280, 26)
    self.Editbox:SetAutoFocus(false)

    self.Editbox.Left:SetHeight(26)
    self.Editbox.Right:SetHeight(26)
    self.Editbox.Middle:SetHeight(26)

    self.Editbox:SetScript("OnEnable", function (editbox)
        editbox:SetTextColor(1, 1, 1)
    end)

    self.Editbox:SetScript("OnDisable", function (editbox)
        editbox:SetTextColor(0.5, 0.5, 0.5)
    end)

    self.Editbox:SetScript("OnEnterPressed", EditBox_ClearFocus)    -- 回车清楚焦点
    self.Editbox:SetScript("OnEscapePressed", EditBox_ClearFocus)   -- ESC清除焦点

    Mixin(self.Editbox, DefaultTooltipMixin)

    self.Tooltip:SetScript("OnMouseUp", function()
        if self.Checkbox:IsEnabled() then
            self.Checkbox:Click()
        end
    end)
end

function LibBlzSettingsCheckboxEditboxControlMixin:Init(initializer)
    SettingsListElementMixin.Init(self, initializer)

    local cbSetting = initializer.data.cbSetting
    local cbLabel = initializer.data.cbLabel
    local cbTooltip = initializer.data.cbTooltip
    local editboxSetting = initializer.data.editboxSetting
    local editboxLabel = initializer.data.editboxLabel
    local editboxTooltip = initializer.data.editboxTooltip

    local initCheckboxTooltip = GenerateClosure(Settings.InitTooltip, cbLabel, cbTooltip)
    self:SetTooltipFunc(initCheckboxTooltip)

    self.Checkbox:Init(cbSetting:GetValue(), initCheckboxTooltip)
    self.cbrHandles:RegisterCallback(self.Checkbox, SettingsCheckboxMixin.Event.OnValueChanged, self.OnCheckboxValueChanged, self)

    local initEditboxTooltip = GenerateClosure(Settings.InitTooltip, editboxLabel, editboxTooltip)
    self.Editbox:SetTooltipFunc(initEditboxTooltip)
    self.Editbox:SetText(editboxSetting:GetValue())
    self.Editbox:SetScript("OnTextChanged", function(editbox, userInput)
        if userInput and not IMECandidatesFrame:IsShown() then  -- 限制: 用户输入/输入法框体未显示
            self:OnEditboxValueChanged(editbox:GetText())
        end
    end)

    self.Editbox:SetEnabled(cbSetting:GetValue())

    -- Defaults...
    local function OnCheckboxSettingValueChanged(o, setting, value)
		self.Checkbox:SetValue(value)
		self:EvaluateState()
	end
	self.cbrHandles:SetOnValueChangedCallback(cbSetting:GetVariable(), OnCheckboxSettingValueChanged)

	local function OnEditboxSettingValueChanged(o, setting, value)
		self.Editbox:SetText(value)
	end
	self.cbrHandles:SetOnValueChangedCallback(editboxSetting:GetVariable(), OnEditboxSettingValueChanged)

    self:EvaluateState()
end

function LibBlzSettingsCheckboxEditboxControlMixin:OnCheckboxValueChanged(value)
    local initializer = self:GetElementData()
    local cbSetting = initializer.data.cbSetting
    cbSetting:SetValue(value)
    if value then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    end

    self.Editbox:SetEnabled(value)
end

function LibBlzSettingsCheckboxEditboxControlMixin:OnEditboxValueChanged(value)
    local initializer = self:GetElementData()
    local editboxSetting = initializer.data.editboxSetting
    editboxSetting:SetValue(value)
end

function LibBlzSettingsCheckboxEditboxControlMixin:EvaluateState()
	SettingsListElementMixin.EvaluateState(self)
	local enabled = SettingsControlMixin.IsEnabled(self)
	self.Checkbox:SetEnabled(enabled)
	self.Editbox:SetEnabled(enabled and self.Checkbox:GetChecked())
	self:DisplayEnabled(enabled)
end

function LibBlzSettingsCheckboxEditboxControlMixin:Release()
	self.Checkbox:Release()
	self.Editbox:SetScript("OnTextChanged", nil)

	SettingsListElementMixin.Release(self)
end

LibBlzSettings.RegisterControl(
    CONTROL_TYPE.CHECKBOX_AND_EDITBOX,
    function (addOnName, category, layout, dataTbl, database)
        local template
        if dataTbl.template and C_XMLUtil.GetTemplateInfo(dataTbl.template) then
            template = dataTbl.template
        elseif C_XMLUtil.GetTemplateInfo("LibBlzSettingsCheckboxEditboxControlTemplate") then
            template = "LibBlzSettingsCheckboxEditboxControlTemplate"
        end

        if not template then
            return
        end

        local checkboxSetting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.Boolean)
        local editboxSetting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl.editbox, database, Settings.VarType.String)

        local data = {
            name = dataTbl.name,
            tooltip = dataTbl.tooltip,
            setting = checkboxSetting,
            cbSetting = checkboxSetting,
            cbLabel = dataTbl.name,
            cbTooltip = dataTbl.tooltip,
            editboxSetting = editboxSetting,
            editboxLabel = dataTbl.editbox.name or dataTbl.name,
            editboxTooltip = dataTbl.editbox.tooltip or dataTbl.tooltip
        }

        local initializer = Settings.CreateSettingInitializer(template, data)

        if dataTbl.canSearch or dataTbl.canSearch == nil then
            initializer:AddSearchTags(dataTbl.name)
        end

        layout:AddInitializer(initializer)

        return setting, initializer
    end,
    { editbox = CONTROL_TYPE.EDITBOX },
    { inherits = CONTROL_TYPE.CHECKBOX }
)

----------------------------------------
--- Color Control
--- Author: Sanluli36li
--- 
--- To use this control, define an XML template in your addon that inherits from "SettingsListElementTemplate" and set the mixin to LibBlzSettingsColorControlMixin, for example:
--- "_____" should be changed to a unique prefix (such as your addon name) to prevent conflicts with other addons
--[[

<Frame name="_____ColorControlTemplate" inherits="SettingsListElementTemplate" mixin=LibBlzSettingsColorControlMixin virtual="true">
    <Size x="280" y="26"/>
    <Scripts>
        <OnLoad method="OnLoad"/>
    </Scripts>
</Frame>

]]
--- Then define your settings in the settings table:
--[[

{
    controlType = 5,
    settingType = SETTING_TYPE.ADDON_VARIABLE,
    name = "Select your Color",
    tooltip = "Tooltip",
    key = "color",
    default = "#7f7f7f",
    hasOpacity = true,      -- If true, the color picker can select the transparent channel
    template = "_____ColorControlTemplate"
},

]]
----------------------------------------
CONTROL_TYPE.COLOR = 5

LibBlzSettingsColorControlMixin = CreateFromMixins(SettingsControlMixin)

local function GetHexColorFromRGBA(r, g, b, a)
    if a and a >= 1 then
        return string.format("#%02x%02x%02x", r * 255, g * 255, b * 255)
    else
        return string.format("#%02x%02x%02x%02x", r * 255, g * 255, b * 255, a * 255)
    end
end

local function GetRGBAFromHexColor(hex)
    if strsub(hex, 1, 1) ~= "#" then
        return 1, 1, 1, 1
    end

    local len = string.len(hex)
    local r, g, b, a = 1, 1, 1, 1
    if len == 7 then
        r = (tonumber(strsub(hex, 2, 3), 16) or 255) / 255
        g = (tonumber(strsub(hex, 4, 5), 16) or 255) / 255
        b = (tonumber(strsub(hex, 6, 7), 16) or 255) / 255
    elseif len == 9 then
        r = (tonumber(strsub(hex, 2, 3), 16) or 255) / 255
        g = (tonumber(strsub(hex, 4, 5), 16) or 255) / 255
        b = (tonumber(strsub(hex, 6, 7), 16) or 255) / 255
        a = (tonumber(strsub(hex, 8, 9), 16) or 255) / 255
    end

    return r, g, b, a
end

function LibBlzSettingsColorControlMixin:OnLoad()
	SettingsControlMixin.OnLoad(self)

	self.ColorSwatch = CreateFrame("Button", nil, self, "ColorSwatchTemplate")
	self.ColorSwatch:SetPoint("TOPLEFT", self.Text, "TOPLEFT", 192, 0)

    self.ColorSwatch:SetScript("OnClick", function(button, buttonName, down)
        self:OpenColorPicker()
	end)
end

function LibBlzSettingsColorControlMixin:OpenColorPicker()
    local info = UIDropDownMenu_CreateInfo()

	info.r, info.g, info.b, info.opacity = GetRGBAFromHexColor(self:GetSetting():GetValue())
    info.hasOpacity = self.hasOpacity
	info.extraInfo = nil
	info.swatchFunc = function ()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		local a = ColorPickerFrame:GetColorAlpha()

		self.ColorSwatch.Color:SetVertexColor(r,g,b, a)

		self:GetSetting():SetValue(GetHexColorFromRGBA(r, g, b, a))
	end

	info.cancelFunc = function ()
		local r, g, b, a = ColorPickerFrame:GetPreviousValues()

		self.ColorSwatch.Color:SetVertexColor(r,g,b, a)

		self:GetSetting():SetValue(GetHexColorFromRGBA(r, g, b, a))
	end

	ColorPickerFrame:SetupColorPickerAndShow(info)
end

function LibBlzSettingsColorControlMixin:Init(initializer)
    SettingsControlMixin.Init(self, initializer)

    local setting = self:GetSetting()

    local initTooltip = GenerateClosure(Settings.InitTooltip, initializer:GetName(), initializer:GetTooltip())

    local r, g, b, a = GetRGBAFromHexColor(setting:GetValue())

    self.hasOpacity = initializer.data.hasOpacity
    self.ColorSwatch.Color:SetVertexColor(r, g, b, a)

	self:EvaluateState()
end

function LibBlzSettingsColorControlMixin:OnSettingValueChanged(setting, value)
	SettingsControlMixin.OnSettingValueChanged(self, setting, value)

    self.ColorSwatch.Color:SetVertexColor(GetRGBAFromHexColor(setting:GetValue()))
end

function LibBlzSettingsColorControlMixin:EvaluateState()
	SettingsListElementMixin.EvaluateState(self)
    local enabled = SettingsControlMixin.IsEnabled(self)
	self.ColorSwatch:SetEnabled(enabled)
	self:DisplayEnabled(enabled)
end

function LibBlzSettingsColorControlMixin:Release()
	SettingsControlMixin.Release(self)
end

LibBlzSettings.RegisterControl(
    CONTROL_TYPE.COLOR,
    function (addOnName, category, layout, dataTbl, database)
        local template
        if dataTbl.template and C_XMLUtil.GetTemplateInfo(dataTbl.template) then
            template = dataTbl.template
        elseif C_XMLUtil.GetTemplateInfo("LibBlzSettingsColorControlTemplate") then
            template = "LibBlzSettingsColorControlTemplate"
        end

        if not template then
            return
        end

        local setting = LibBlzSettings.RegisterSetting(addOnName, category, dataTbl, database, Settings.VarType.String)

        local data = {
            name = dataTbl.name,
            tooltip = dataTbl.tooltip,
            setting = setting,
            hasOpacity = dataTbl.hasOpacity,
            options = {},
        }
        local initializer = Settings.CreateSettingInitializer(template, data)

        if dataTbl.canSearch or dataTbl.canSearch == nil then
            initializer:AddSearchTags(dataTbl.name)
        end

        layout:AddInitializer(initializer)

        return setting, initializer
    end,
    {},
    {}
)
