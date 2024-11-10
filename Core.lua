local ADDON_NAME, SanluliUtils = ...

_G[ADDON_NAME] = SanluliUtils

local ADDON_MESSAGE_AFFIX = "|cffffffffSanluliUtils: |r"
local ADDON_LISTENER_SUFFIX = "Listener"

SanluliUtils.Locale = {}					-- 本地化表
SanluliUtils.Modules = {}					-- 模块表

local Listener = CreateFrame('Frame', ADDON_NAME .. ADDON_LISTENER_SUFFIX)
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
function SanluliUtils:RegisterEvent(event, callback, func)
    if func == nil then func = 0 end
	if EventListeners[event] == nil then
		Listener:RegisterEvent(event)
		EventListeners[event] = { [callback]=func }
	else
		EventListeners[event][callback] = func
	end
end

-- 取消注册事件
function SanluliUtils:UnregisterEvent(event, callback)
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
function SanluliUtils:GetConfig(module, key)
	if self.Database then
		return self.Database[module..'.'..key]
	end
end

-- 设置配置项
function SanluliUtils:SetConfig(module, key, value)
	if self.Database then
    	self.Database[module..'.'..key] = value
	end
end

-- 插件消息输出
function SanluliUtils:Print(text, r, g, b, ...)
    r, g, b = r or 1, g or 1, b or 0
    DEFAULT_CHAT_FRAME:AddMessage("|cffffffff" .. self.Locale["addon.name"] .. ": |r" .. tostring(text), r, g, b, ...)
end

-- 模块类
local ModulePrototype = {
	RegisterEvent = function (self, event, func)
		SanluliUtils:RegisterEvent(event, self, func)
	end,

	UnregisterEvent = function (self, event)
		SanluliUtils:UnregisterEvent(event, self)
	end,

	GetConfig = function(self, key)
		return SanluliUtils:GetConfig(self.name, key)
	end,

	SetConfig = function(self, key, value)
		return SanluliUtils:SetConfig(self.name, key, value)
	end
}

-- 新建模块
function SanluliUtils:NewModule(name)
	local module = {}
	self.Modules[name] = module
	setmetatable(module, {__index = ModulePrototype})
	module.name = name

	return module
end

setmetatable(SanluliUtils, {__index = SanluliUtils.Modules})

function SanluliUtils:ForAllModules(event, ...)
	for _, module in pairs(SanluliUtils.Modules) do
		if type(module) == 'table' and module[event] then
			module[event](module, ...)
		end
	end
end

SanluliUtils:RegisterEvent("ADDON_LOADED", SanluliUtils)
function SanluliUtils:ADDON_LOADED(addOnName, containsBindings)
	if addOnName == ADDON_NAME then
		SanluliUtilsDB = (type(SanluliUtilsDB) == "table" and SanluliUtilsDB) or {}
		self.Database = SanluliUtilsDB

		self:ForAllModules('BeforeStartup')
		self:ForAllModules('Startup')
	end
end

SanluliUtils:RegisterEvent("PLAYER_ENTERING_WORLD", SanluliUtils)
function SanluliUtils:PLAYER_ENTERING_WORLD()
	self:ForAllModules('AfterStartup')

	self:UnregisterEvent("PLAYER_ENTERING_WORLD", SanluliUtils)
end
