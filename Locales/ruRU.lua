if (GAME_LOCALE or GetLocale()) ~= "ruRU" then return end

local AddonName, Addon = ...

local L = {}

Addon.L = L

-- ==========================================
-- Welcome Messages
-- ==========================================
L.welcomeMessage1 = "Спасибо за использование |cff1df2a8ActionBars Enhanced|r"
L.welcomeMessage2 = "Вы можете открыть настройки командой |cff1df2a8/"

-- ==========================================
-- General Settings
-- ==========================================
L.Enable = "Использовать"
L.GlobalSettings = "Общие настройки"

-- ==========================================
-- Action Bars
-- ==========================================
L.MainActionBar = "Панель команд 1"
L.MultiBarBottomLeft = "Панель команд 2"
L.MultiBarBottomRight = "Панель команд 3"
L.MultiBarRight = "Панель команд 4"
L.MultiBarLeft = "Панель команд 5"
L.MultiBar5 = "Панель команд 6"
L.MultiBar6 = "Панель команд 7"
L.MultiBar7 = "Панель команд 8"
L.PetActionBar = "Панель пета"
L.StanceBar = "Панель стоек"
L.BagsBar = "Панель сумок"
L.MicroMenu = "Микроменю"

-- ==========================================
-- Proc Glow Effects
-- ==========================================
L.GlowTypeTitle = "Анимации прока"
L.GlowTypeDesc = "Настройка анимации прока"
L.GlowType = "Тип цикличного свечения"

L.ProcStartTitle = "Стартовое свечение прока"
L.ProcStartDesc = "Отключить или изменить тип и цвет стартовой анимации прока"
L.HideProcAnim = "Скрыть начальную анимацию прока"
L.StartProcType = "Тип начальной анимации прока"

L.AssistTitle = "Свечение Боевого Помощника"
L.AssistDesc = "Выбрать тип и цвет основного и дополнительного свечения"
L.AssistType = "Тип основного свечения"
L.AssistAltType = "Тип второстепенного свечения"

L.UseCustomColor = "Свой цвет"
L.Desaturate = "Обесцветить"

-- ==========================================
-- Fade Bars
-- ==========================================
L.FadeTitle = "Скрытие панелей"
L.FadeDesc = "Активировать скрытие панелей и настроить условия отображения."
L.FadeOutBars = "Использовать прозрачность панелей"
L.FadeInOnCombat = "Показывать в бою"
L.FadeInOnTarget = "Показывать при наличии цели"
L.FadeInOnCasting = "Показывать во время каста"
L.FadeInOnHover = "Показывать при наведении мыши"

-- ==========================================
-- Button Textures
-- ==========================================
L.NormalTitle = "Рамка кнопок"
L.NormalDesc = "Выбрать тип, цвет и прозрачность рамки кнопок."
L.NormalTextureType = "Тип рамки кнопок"

L.BackdropTitle = "Фон кнопок"
L.BackdropDesc = "Выбрать тип, цвет и прозрачность фона кнопок."
L.BackdropTextureType = "Тип фона кнопок"

L.IconTitle = "Маска иконок кнопок"
L.IconDesc = "Выбрать тип маски, настроить масштаб маски и иконок."
L.IconMaskTextureType = "Тип маски"
L.IconMaskScale = "Масштаб маски"
L.IconScale = "Масштаб иконок"

L.PushedTitle = "Стиль текстуры нажатой кнопки"
L.PushedDesc = "Эта текстура отображается в момент нажатия кнопки."
L.PushedTextureType = "Текстура нажатой кнопки"

L.HighlightTitle = "Стиль текстуры подсветки"
L.HighlightDesc = "Эта текстура отображается в момент наведения курсора на кнопку."
L.HighliteTextureType = "Текстура при наведении мыши"

L.CheckedTitle = "Стиль текстуры активной кнопки"
L.CheckedDesc = "Текстура примененного заклинания или если оно находится в очереди заклинаний."
L.CheckedTextureType = "Текстура активной кнопки"

-- ==========================================
-- Cooldown Settings
-- ==========================================
L.CooldownTitle = "Кастомизация Кулдауна"
L.CooldownDesc = "Изменить внешний вид кулдауна."
L.SwipeTextureType = "Текстура Swipe"
L.SwipeSize = "Размер текстуры Swipe"
L.CustomSwipeColor = "Свой цвет Swipe"

L.EdgeTextureType = "Текстура Edge"
L.EdgeSize = "Размер текстуры Edge"
L.CustomEdgeColor = "Свой цвет Edge"
L.EdgeAlwaysShow = "Всегда показывать Edge"

L.CooldownFont = "Шрифт Кулдауна/Ауры/Таймера"
L.CooldownFontSize = "Размер шрифта"
L.FontColor = "Цвет шрифта"

-- ==========================================
-- Color Override
-- ==========================================
L.ColorOverrideTitle = "Цвет статуса кнопки"
L.ColorOverrideDesc = "Выбрать цвет для некоторых статусов кнопки."
L.CustomColorCooldownSwipe = "Использовать свой цвет для кудлауна"
L.CustomColorOOR = "Свой цвет Out Of Range"
L.CustomColorOOM = "Свой цвет Out Of Mana"
L.CustomColorNoUse = "Свой цвет если кнопка недоступна"
L.CustomColorGCD = "Свой цвет если спелл на ГКД"
L.CustomColorCD = "Свой цвет если спелл на КД"
L.CustomColorNormal = "Свой цвет для обычного состояния"

L.RemoveOORColor = "Убрать цвет OOR"
L.RemoveOOMColor = "Убрать цвет OOM"
L.RemoveNUColor = "Убрать цвет NU"
L.RemoveDesaturation = "Убрать обесцвечивание"

-- ==========================================
-- Hide Frames and Animations
-- ==========================================
L.HideFrameTitle = "Скрытие панелей и анимаций"
L.HideFrameDesc = "Отключить отображение панелей и раздражающих анимаций на панели способностей."
L.HideBagsBar = "Скрывать панель сумок"
L.HideMicroMenuBar = "Скрывать микроменю"
L.HideStanceBar = "Скрывать панель стоек"
L.HideTalkingHead = "Скрывать Говорящую Голову"
L.HideInterrupt = "Скрывать анимацию прерывания"
L.HideCasting = "Скрывать анимацию каста на кнопке"
L.HideReticle = "Скрывать анимацию АОЕ на кнопке"

-- ==========================================
-- Font Options
-- ==========================================
L.FontTitle = "Настройки шрифтов"
L.FontDesc = "Кастомизация шрифтов кнопок/иконок."
L.FontHotKeyScale = "Масштаб текста Хоткея (мелкие кнопки)"
L.FontStacksScale = "Масштаб текста Стаков (мелкие кнопки)"
L.FontHideName = "Скрыть Название кнопки (макроса)"
L.FontNameScale = "Масштаб Названия (мелкие кнопки)"

L.HotKeyFont = "Шрифт Хоткея"
L.HotkeyOutline = "Обводка текста Хоткея"
L.HotkeyShadowColor = "Тень текста Хоткея"
L.HotkeyShadowOffset = "Смещение Тени текста Хоткея"
L.FontHotkeySize = "Размер Шрифта Хоткея"
L.HotkeyAttachPoint = "Точка крепления текста Хоткея"
L.HotkeyOffset = "Смещение крепления текста Хоткея"
L.HotkeyCustomColor = "Свой цвет текста Хоткея"

L.StacksFont = "Шрифт Стаков"
L.StacksOutline = "Обводка текста Стаков"
L.StacksShadowColor = "Тень текста Стаков"
L.StacksShadowOffset = "Смещение Тени текста Стаков"
L.FontStacksSize = "Размер Шрифта Стаков"
L.StacksAttachPoint = "Точка крепления текста Стаков"
L.StacksOffset = "Смещение крепления текста Стаков"
L.StacksCustomColor = "Свой цвет текста Стаков"

-- ==========================================
-- Profiles
-- ==========================================
L.ProfilesHeaderText = "Вы можете изменить активный профиль, чтобы иметь разные настройки для каждого персонажа.\nСбросьте текущий профиль к значениям по умолчанию на случай, если ваша конфигурация повреждена или вы просто хотите начать заново."
L.ProfilesCopyText = "Скопируйте настройки из одного существующего профиля в текущий активный профиль."
L.ProfilesDeleteText = "Удалите существующие и неиспользуемые профили из базы данных для экономии места и очистки файла SavedVariables."
L.ProfilesImportText = "Поделитесь своим профилем или импортируйте чужой с помощью простой строки."

-- ==========================================
-- WeakAuras Integration
-- ==========================================
L.WAIntTitle = "WeakAuras Интеграция"
L.WAIntDesc = "Изменить тип начальной и цикличной анимации свечения WA.\nИзменит только те ауры, которые имеют свечение 'Свечение при активации'"
L.ModifyWAGlow = "Включить модификацию свечения WA"
L.WAProcType = "Тип начальной анимации свечения WA"
L.WALoopType = "Тип цикличной анимации свечения WA"
L.AddWAMask = "Добавить маску для иконок WA"

-- ==========================================
-- Quick Presets
-- ==========================================
L.PresetActive = "Активно"
L.PresetSelect = "Выбрать"

-- ==========================================
-- Copy/Paste Functions
-- ==========================================
L["Copied: %s"] = "Скопировано: %s"
L["Pasted: %s → %s"] = "Вставлено: %s → %s"
L.CopyText = "Копировать"
L.PasteText = "Вставить"
L.CancelText = "Отменить"

-- ==========================================
-- Cooldown Manager Viewer Types
-- ==========================================
L.EssentialCooldownViewer   = "Основные"
L.UtilityCooldownViewer     = "Утилити"
L.BuffIconCooldownViewer    = "Баффы"
L.BuffBarCooldownViewer     = "Полоски"

-- ==========================================
-- Cooldown Manager Basic Settings
-- ==========================================
L.IconPadding = "Растояние между иконками"
L.CDMBackdrop = "Рамка иконки (создает новый фрейм)"
L.CDMCenteredGrid = "Центрировать иконки"
L.CDMRemoveIconMask = "Убрать маску иконки"
L.CDMRemovePandemic = "Убрать анимацию пандемика"
L.CDMSwipeColor = "Цвет Swipe анимации кулдауна"
L.CDMAuraSwipeColor = "Цвет Swipe анимации ауры"
L.CDMBackdropColor = "Цвет рамки"
L.CDMBackdropAuraColor = "Цвет рамки для ауры"
L.CDMBackdropPandemicColor = "Цвет рамки для пандемика"
L.CDMReverseSwipe = "Обратное заполнение кулдауна"
L.CDMRemoveAuraTypeBorder = "Убрать рамку типа Ауры"

-- ==========================================
-- Status Bar Settings
-- ==========================================
L.CDMBarContainerTitle = "Настройки полосок"
L.CDMBarContainerDesc = "Настройте внешний вид и расположение полосок."
L.StatusBarTextures = "Текстура статусбара"
L.FontNameSize = "Размер шрифта названия"
L.StatusBarBGTextures = "Текстура фона"

-- ==========================================
-- Bar Layout Settings
-- ==========================================
L.BarGrow = "Направление роста"
L.NameFont = "Шрифт названия"
L.IconSize = "Размер иконки"
L.BarHeight = "Высота полоски"
L.BarPipSize = "Размер искры"
L.BarPipTexture = "Текстура искры"
L.BarOffset = "Смещение крепления полоски"

-- ==========================================
-- CDM Additional Settings
-- ==========================================
L.CDMItemSize = "Размер элемента"
L.CDMRemoveGCDSwipe = "Убрать Swipe анимацию на ГКД"
L.CDMAuraReverseSwipe = "Обратное заполнение ауры"

L.CDMCooldownTitle = "Кастомизация кулдауна"
L.CDMCooldownDesc = "Изменить внешний вид кулдауна для CDM."

L.IconBorderTitle = "Рамка иконки"
L.IconBorderDesc = "Создание и настройка нового фрейма для отрисовки рамки вокруг иконки."

L.CDMOptionsTitle = "Дополнительные настройки CDM"
L.CDMOptionsDesc = "Глобальное включение дополнительных настроек, перезаписывающих стандартные параметры CDM."
