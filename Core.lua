local ADDON_NAME, AddOn = ...

_G[ADDON_NAME] = AddOn

AddOn.Locale = {}	-- 本地化表
AddOn.Modules = {}	-- 模块表

local ADDON_DATABASE = ADDON_NAME.."DB"

local Listener = CreateFrame('Frame')
local EventListeners = {}

Listener:SetScript("OnEvent", function(frame, event, ...)
	if EventListeners[event] then
		for callback, func in pairs(EventListeners[event]) do
			if func == 0 then
				callback[event](callback, ...)
			else
				callback[func](callback, event, ...)
			end
		end
	end
end)

-- 注册事件
function AddOn:RegisterEvent(event, callback, func)
    if func == nil then func = 0 end
	if EventListeners[event] == nil then
		Listener:RegisterEvent(event)
		EventListeners[event] = { [callback]=func }
	else
		EventListeners[event][callback] = func
	end
end

-- 取消注册事件
function AddOn:UnregisterEvent(event, callback)
	local listeners = EventListeners[event]
	if listeners then
		local count = 0
		for index,_ in pairs(listeners) do
			if index == callback then
				listeners[index] = nil
			else
				count = count + 1
			end
		end
		if count == 0 then
			EventListeners[event] = nil
			Listener:UnregisterEvent(event)
		end
	end
end

-- 获取配置项
function AddOn:GetConfig(module, key)
	if self.Database then
		if key then
			return self.Database[module..'.'..key]
		else
			return self.Database[module]
		end
	end
end

-- 设置配置项
function AddOn:SetConfig(module, key, value)
	if self.Database then
    	self.Database[module..'.'..key] = value
	end
end

-- 插件消息输出
function AddOn:Print(text, r, g, b, ...)
    r, g, b = r or 1, g or 1, b or 0
    DEFAULT_CHAT_FRAME:AddMessage("|cffffffff"..(AddOn.Locale["addon.name"] or ADDON_NAME)..": |r".. tostring(text), r, g, b, ...)
end

-- 模块类
local ModulePrototype = {
	RegisterEvent = function (self, event, func)
		AddOn:RegisterEvent(event, self, func)
	end,

	UnregisterEvent = function (self, event)
		AddOn:UnregisterEvent(event, self)
	end,

	GetConfig = function(self, key)
		return AddOn:GetConfig(self.name, key)
	end,

	SetConfig = function(self, key, value)
		return AddOn:SetConfig(self.name, key, value)
	end
}

-- 新建模块
function AddOn:NewModule(name)
	local module = {}
	self.Modules[name] = module
	setmetatable(module, {__index = ModulePrototype})
	module.name = name

	return module
end

function AddOn:GetModule(name)
	if self.Modules[name] then
		return self.Modules[name]
	end
end

-- setmetatable(AddOn, {__index = AddOn.Modules})

function AddOn:ForAllModules(event, ...)
	for _, module in pairs(AddOn.Modules) do
		if type(module) == 'table' and module[event] then
			module[event](module, ...)
		end
	end
end



function AddOn:ADDON_LOADED(addOnName, containsBindings)
	if addOnName == ADDON_NAME then
		_G[ADDON_DATABASE] = (type(_G[ADDON_DATABASE]) == "table" and _G[ADDON_DATABASE]) or {}
		self.Database = _G[ADDON_DATABASE]

		self:ForAllModules("OnLoad")
		self:ForAllModules("Startup")
	end
end
AddOn:RegisterEvent("ADDON_LOADED", AddOn)


function AddOn:PLAYER_LOGIN()
	self:ForAllModules("OnLogin")
end
AddOn:RegisterEvent("PLAYER_LOGIN", AddOn)


function AddOn:PLAYER_ENTERING_WORLD()
	self:ForAllModules('AfterLogin')

	self:UnregisterEvent("PLAYER_ENTERING_WORLD", AddOn)
end
AddOn:RegisterEvent("PLAYER_ENTERING_WORLD", AddOn)


function AddOn:PLAYER_LOGOUT()
	self:ForAllModules("OnLogout")
end
AddOn:RegisterEvent("PLAYER_LOGOUT", AddOn)
