if (GAME_LOCALE or GetLocale()) ~= "ruRU" then return end

local AddonName, Addon = ...

local L = {}

Addon.L = L

L.GlowTypeTitle = "Свечение прока"
L.GlowTypeDesc = "Выбрать тип и цвет цикличного свечения прока"
L.GlowType = "Тип цикличного свечения"

L.UseCustomColor = "Использовать свой цвет"

L.Desaturate = "Обесцветить"

L.ProcStartTitle = "Стартовое свечение прока"
L.ProcStartDesc = "Отключить или изменить тип и цвет стартовой анимации прока"
L.HideProcAnim = "Скрыть начальную анимацию прока"
L.StartProcType = "Тип начальной анимации прока"

L.AssistTitle = "Свечение Боевого Помощника"
L.AssistDesc = "Выбрать тип и цвет основного и дополнительного свечения"
L.AssistType = "Тип основного свечения"
L.AssistAltType = "Тип второстепенного свечения"

L.FadeTitle = "Скрытие панелей"
L.FadeDesc = "Активировать скрытие панелей и настроить условия отображения."
L.FadeOutBars = "Использовать прозрачность панелей"
L.FadeInOnCombat = "Показывать в бою"
L.FadeInOnTarget = "Показывать при наличии цели"
L.FadeInOnCasting = "Показывать во время каста"
L.FadeInOnHover = "Показывать при наведении мыши"

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

L.CooldownTitle = "Кастомизация Кулдауна"
L.CooldownDesc = "Изменить внешний вид кулдауна."
L.SwipeTextureType = "Текстура Swipe"
L.SwipeSize = "Размер текстуры Swipe"
L.CustomSwipeColor = "Свой цвет Swipe"

L.EdgeTextureType = "Текстура Edge"
L.EdgeSize = "Размер текстуры Edge"
L.CustomEdgeColor = "Свой цвет Edge"
L.EdgeAlwaysShow = "Всегда показывать Edge"

L.CooldownFont = "Шрифт Кулдауна"
L.CooldownFontSize = "Размер шрифта"
L.CooldownFontColor = "Цвет шрифта"

L.ColorOverrideTitle = "Цвет статуса кнопки"
L.ColorOverrideDesc = "Выбрать цвет для некоторых статусов кнопки."
L.CustomColorCooldownSwipe = "Использовать свой цвет для кудлауна"
L.CustomColorOOR = "Свой цвет Out Of Range"
L.CustomColorOOM = "Свой цвет Out Of Mana"
L.CustomColorNoUse = "Свой цвет если кнопка недоступна"

L.HideFrameTitle = "Скрытие панелей и анимаций"
L.HideFrameDesc = "Отключить отображение панелей и раздражающих анимаций на панели способностей."
L.HideBagsBar = "Скрывать панель сумок"
L.HideMicroMenuBar = "Скрывать микроменю"
L.HideStanceBar = "Скрывать панель стоек"
L.HideTalkingHead = "Скрывать Говорящую Голову"
L.HideInterrupt = "Скрывать анимацию прерывания"
L.HideCasting = "Скрывать анимацию каста на кнопке"
L.HideReticle = "Скрывать анимацию АОЕ на кнопке"

L.FontTitle = "Настройки шрифтов"
L.FontDesc = "Кастомизация шрифтов кнопок."
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

L.welcomeMessage1 = "Спасибо за использование |cff1df2a8ActionBars Enhanced|r"
L.welcomeMessage2 = "Вы можете открыть настройки командой |cff1df2a8/"

L.ProfilesHeaderText = "Вы можете изменить активный профиль, чтобы иметь разные настройки для каждого персонажа.\nСбросьте текущий профиль к значениям по умолчанию на случай, если ваша конфигурация повреждена или вы просто хотите начать заново."
L.ProfilesCopyText = "Скопируйте настройки из одного существующего профиля в текущий активный профиль."
L.ProfilesDeleteText = "Удалите существующие и неиспользуемые профили из базы данных для экономии места и очистки файла SavedVariables."
L.ProfilesImportText = "Поделитесь своим профилем или импортируйте чужой с помощью простой строки."

L.WAIntTitle = "WeakAuras Интеграция"
L.WAIntDesc = "Изменить тип начальной и цикличной анимации свечения WA.\nИзменит только те ауры, которые имеют свечение 'Свечение при активации'"
L.ModifyWAGlow = "Включить модификацию свечения WA"
L.WAProcType = "Тип начальной анимации свечения WA"
L.WALoopType = "Тип цикличной анимации свечения WA"
L.AddWAMask = "Добавить маску для иконок WA"