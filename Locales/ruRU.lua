if not(GetLocale() == "ruRU") then
    return
end

local ADDON_NAME, SanluliUtils = ...

local L = SanluliUtils.Locale
--Translator ZamestoTV
L["addon.name"] = "SanluliUtils"
L["addon.test.title"] = "|cffff0000(Тест)|r"
L["addon.test.tooltip"] = "|cffff0000Эта функция экспериментальная и может работать не так, как ожидалось|r"
L["addons.simulationcraft.title"] = "SimulationCraft"
L["addons.simulationcraft.forceHideMinimap.title"] = "Всегда скрывать кнопку миникарты Simc"
L["addons.title"] = "Улучшения аддонов"
L["automatic.autoCombatlog.difficulty.all"] = "Все сложности"
L["automatic.autoCombatlog.difficulty.heroic"] = "Героическая+"
L["automatic.autoCombatlog.difficulty.mythic"] = "Эпохальная+"
L["automatic.autoCombatlog.difficulty.mythicPlus"] = "Эпохальный ключ"
L["automatic.autoCombatlog.difficulty.mythicRaid"] = "Эпохальный рейд"
L["automatic.autoCombatlog.difficulty.normal"] = "Обычная+"
L["automatic.autoCombatlog.dungeon.title"] = "Сложность подземелий"
L["automatic.autoCombatlog.dungeon.tooltip"] = "Сложности подземелий для автоматического включения журнала боя"
L["automatic.autoCombatlog.raid.title"] = "Сложность рейдов"
L["automatic.autoCombatlog.raid.tooltip"] = "Сложности рейдов для автоматического включения журнала боя"
L["automatic.autoCombatlog.title"] = "Автоматический журнал боя"
L["automatic.autoCombatlog.tooltip"] = "Автоматически включать журнал боя в инстансах\n\nЖурналы сохраняются в \"Logs/WoWCombatLog\"\n|cffff0000Включайте только при необходимости (например, для WarcraftLogs/raider.io)\nЖурналы занимают место на диске, регулярно очищайте|r\n|cffffffffОтключено для классических правил добычи|r"
L["automatic.autoInputConfirm.title"] = "Автоматическое подтверждение ввода"
L["automatic.autoInputConfirm.tooltip"] = "Автоматически заполнять текст подтверждения\n(например, ввод \"DELETE\" при уничтожении предметов)\n|cffff0000Дважды проверяйте перед нажатием \""..YES.."\"!|r"
L["automatic.autoRepair.funds.guild.title"] = "Предпочитать средства гильдии"
L["automatic.autoRepair.funds.guild.tooltip"] = "Сначала использовать средства гильдии, личное золото при недостатке"
L["automatic.autoRepair.funds.personal.title"] = "Только личные средства"
L["automatic.autoRepair.funds.personal.tooltip"] = "Всегда использовать личное золото для ремонта"
L["automatic.autoRepair.message.guild"] = "Гильдия"
L["automatic.autoRepair.message.guildExhausted"] = "Средства гильдии для ремонта исчерпаны"
L["automatic.autoRepair.message.oom"] = "Стоимость ремонта превышает доступное золото на %s"
L["automatic.autoRepair.message.repaired"] = "Автоматический ремонт за %s"
L["automatic.autoRepair.title"] = "Автоматический ремонт"
L["automatic.autoRepair.tooltip"] = "Автоматически ремонтировать снаряжение при открытии интерфейса торговца"
L["automatic.autoRoll.message.greed"] = "Автоматически выбрано Жадность: %s"
L["automatic.autoRoll.message.pass"] = "Автоматически выбрано Пропустить: %s"
L["automatic.autoRoll.message.transmog"] = "Автоматически выбрано Трансмог: %s"
L["automatic.autoRoll.method.greed.title"] = "Автоматическая жадность"
L["automatic.autoRoll.method.greed.tooltip"] = "Если нельзя выбрать Нуждаться: выбрать Трансмог, если доступно, иначе Жадность"
L["automatic.autoRoll.method.pass.title"] = "Автоматический пропуск"
L["automatic.autoRoll.method.pass.tooltip"] = "Всегда Пропустить, если нельзя Нуждаться"
L["automatic.autoRoll.title"] = "Автоматическая жадность"
L["automatic.autoRoll.tooltip"] = "Автоматически бросать кубик, когда вы |cffff0000не можете выбрать Нуждаться|r\n\n|cffff0000Для предметов, где можно выбрать Нуждаться, решение принимается вручную|r"
L["automatic.autoSellJunk.message.sold"] = "Продано %s предметов за %s"
L["automatic.autoSellJunk.method.12Items.title"] = "Продавать только 12 предметов"
L["automatic.autoSellJunk.method.12Items.tooltip"] = "Сохранять последние 12 проданных предметов для возможности выкупа"
L["automatic.autoSellJunk.method.allItems.title"] = "Продавать весь хлам"
L["automatic.autoSellJunk.method.allItems.tooltip"] = "Предметы сверх 12 становятся недоступными для выкупа"
L["automatic.autoSellJunk.method.blizzard.title"] = "Метод Blizzard (без выкупа)"
L["automatic.autoSellJunk.method.blizzard.tooltip"] = "Использовать стандартное поведение кнопки продажи хлама"
L["automatic.autoSellJunk.title"] = "Автоматическая продажа хлама"
L["automatic.autoSellJunk.tooltip"] = "Автоматически продавать серые предметы торговцам\nИгнорирует сумки с меткой \"Игнорировать эту сумку\""
L["automatic.fasterAutoLoot.title"] = "Ускоренный автолут"
L["automatic.fasterAutoLoot.tooltip"] = "Ускорить процесс сбора добычи\nТребуется включенный \"Автолут\" в настройках управления"
L["automatic.title"] = "Общие"
L["blizzardui.actionBar.hideHotkey.title"] = "Скрыть текст горячих клавиш"
L["blizzardui.actionBar.hideHotkey.tooltip"] = "Скрыть метки горячих клавиш на кнопках действий"
L["blizzardui.actionBar.hideName.title"] = "Скрыть названия кнопок"
L["blizzardui.actionBar.hideName.tooltip"] = "Скрыть названия на кнопках макросов/наборов экипировки"
L["blizzardui.actionBar.title"] = "Панели действий"
L["blizzardui.forceShowPowerBarAltStatus.title"] = "Всегда показывать альтернативную силу"
L["blizzardui.forceShowPowerBarAltStatus.tooltip"] = "Отображать числовые значения на специальных панелях силы (например, в сражениях с Н'Зотом)"
L["blizzardui.sync.actionBar.title"] = "Синхронизировать настройки панели действий"
L["blizzardui.sync.actionBar.tooltip"] = "Настройки \""..SETTING_GROUP_GAMEPLAY.." -> "..ACTIONBARS_LABEL.."\" будут синхронизированы между персонажами\n|cffff0000Может потребоваться /reload после изменений|r"
L["blizzardui.sync.raidFrame.title"] = "Синхронизировать настройки рейдовых рамок"
L["blizzardui.sync.raidFrame.tooltip"] = "Настройки \""..SETTING_GROUP_GAMEPLAY.." -> "..INTERFACE_LABEL.." -> "..RAID_FRAMES_LABEL.."\" будут синхронизированы между персонажами"
L["blizzardui.title"] = "Интерфейс Blizzard"
L["client.blzAddonProfiler.disable.title"] = "Отключить профилировщик аддонов"
L["client.blzAddonProfiler.disable.tooltip"] = "Отключить профилирование аддонов версии 11.1.0, вызывающее падение FPS"
L["client.blzAddonProfiler.message.disabled"] = "Профилирование аддонов отключено"
L["client.blzAddonProfiler.message.enabled"] = "Профилирование аддонов включено"
L["client.disabledOverrideArchive.message.disabled"] = "Цензура отключена, |cffff0000требуется перезапуск|r"
L["client.disabledOverrideArchive.message.enabled"] = "Цензура включена, |cffff0000требуется перезапуск|r"
L["client.overrideArchive.disable.title"] = "Отключить цензуру|cffff0000(Требуется перезапуск)|r"
L["client.overrideArchive.disable.tooltip"] = [[
Восстановить оригинальные модели, замененные в клиенте CN
(Иконки требуют отдельных текстурных пакетов)

|cffff0000Требуется перезапуск клиента|r
]]
L["client.overrideArchive.enable.title"] = "Включить цензуру|cffff0000(Требуется перезапуск)|r"
L["client.overrideArchive.enable.tooltip"] = [[
Использовать официальный цензурированный контент (по умолчанию для клиента CN)

Эффекты включают:
1) Могилы вместо скелетов при воскрешении
2) Модели нежити с полной кожей
3) Серые эффекты крови
Плюс другие скрытые изменения...

Если не работает, переключите язык клиента на упрощенный китайский для загрузки активов

|cffff0000Требуется перезапуск клиента|r
]]
L["client.profanityFilter.title"] = "Фильтр нецензурной лексики|cffff0000(Принудительное переопределение)|r"
L["client.title"] = "Клиент"
L["social.chat.bnPlayerLink.title"] = "Формат имени BNet"
L["social.chat.bnPlayerLink.tooltip"] = "Изменить форматирование ссылок на друзей battle.net"
L["social.chat.hyperlinkEnhance.applyToGuildNews.title"] = "Применить к новостям гильдии"
L["social.chat.hyperlinkEnhance.applyToGuildNews.tooltip"] = "Также улучшать ссылки на предметы в новостях гильдии"
L["social.chat.hyperlinkEnhance.displayIcon.title"] = "Показывать иконки"
L["social.chat.hyperlinkEnhance.displayIcon.tooltip"] = "Добавлять иконки предметов/заклинаний перед ссылками"
L["social.chat.hyperlinkEnhance.displayItemLevel.title"] = "Показывать уровень предмета"
L["social.chat.hyperlinkEnhance.displayItemLevel.tooltip"] = "Отображать уровень предмета перед ссылками"
L["social.chat.hyperlinkEnhance.displayItemType.title"] = "Показывать тип предмета"
L["social.chat.hyperlinkEnhance.displayItemType.tooltip"] = "Отображать категорию предмета перед ссылками"
L["social.chat.hyperlinkEnhance.displaySockets.title"] = "Показывать гнезда"
L["social.chat.hyperlinkEnhance.displaySockets.tooltip"] = "Отображать информацию о гнездах после ссылок на предметы"
L["social.chat.hyperlinkEnhance.title"] = "Улучшение ссылок в чате"
L["social.chat.hyperlinkEnhance.tooltip"] = "Улучшать ссылки на предметы в чате дополнительной информацией"
L["social.chat.tabSwitch.title"] = "Циклическое переключение каналов"
L["social.chat.tabSwitch.tooltip"] = "Переключаться между |cffffffffСказать|r/|cffaaaaffГруппа|r/|cffff7f00Рейд|r/|cffff7f00Инстанс|r/|cff40ff40Гильдия|r/|cff40c040Офицер|r с помощью Tab"
L["social.friendsList.characterNameClassColor.title"] = "Имена по цвету класса"
L["social.friendsList.characterNameClassColor.tooltip"] = "Окрашивать имена персонажей по цвету класса в списке друзей"
L["social.friendsList.title"] = "Список друзей"
L["social.privacyMode.hideBattleNetFriendsRealName.title"] = "Скрыть реальные ID"
L["social.privacyMode.hideBattleNetFriendsRealName.tooltip"] = "Отображать теги BNet вместо реальных имен"
L["social.privacyMode.hideBattleNetTagSuffix.title"] = "Скрыть теги BNet"
L["social.privacyMode.hideBattleNetTagSuffix.tooltip"] = "Удалить теги battle.net из заголовка списка друзей"
L["social.title"] = SOCIAL_LABEL
