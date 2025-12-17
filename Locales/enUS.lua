local AddonName, Addon = ...

local L = {}

Addon.L = L

-- ==========================================
-- Welcome Messages
-- ==========================================
L.welcomeMessage1 = "Thank you for using |cff1df2a8ActionBars Enhanced|r"
L.welcomeMessage2 = "You may access options by using |cff1df2a8/"

-- ==========================================
-- General Settings
-- ==========================================
L.Enable = "Enable"
L.GlobalSettings = "Global Settings"

-- ==========================================
-- Action Bars
-- ==========================================
L.MainActionBar = "Action Bar 1"
L.MultiBarBottomLeft = "Action Bar 2"
L.MultiBarBottomRight = "Action Bar 3"
L.MultiBarRight = "Action Bar 4"
L.MultiBarLeft = "Action Bar 5"
L.MultiBar5 = "Action Bar 6"
L.MultiBar6 = "Action Bar 7"
L.MultiBar7 = "Action Bar 8"
L.PetActionBar = "Pet Bar"
L.StanceBar = "Stance Bar"
L.BagsBar = "Bags Bar"
L.MicroMenu = "Micro Menu"

-- ==========================================
-- Action Bars Settings
-- ==========================================
L.ActionBarSettingTitle = "Action Bar Extra Settings"
L.ActionBarSettingDesc = "Choose the growth direction, button padding, and layout style (centered or default) for action bar."

-- ==========================================
-- Proc Glow Effects
-- ==========================================
L.GlowTypeTitle = "Proc Loop Glow"
L.GlowTypeDesc = "Choose the proc loop animation"
L.GlowType = "Proc Loop Glow Type"

L.ProcStartTitle = "Proc Start Glow"
L.ProcStartDesc = "Choose or hide the start of proc animation"
L.HideProcAnim = "Hide Start Proc Animation"
L.StartProcType = "Start Proc Animation Type"

L.AssistTitle = "Assisted Highlight Glow"
L.AssistDesc = "Choose the Combat Assisted Highlight animation"
L.AssistType = "Assisted Highlight type"
L.AssistAltType = "Assisted secondary Highlight type"

L.UseCustomColor = "Use custom color"
L.Desaturate = "Desaturate"

-- ==========================================
-- Fade Bars
-- ==========================================
L.FadeTitle = "Fade Bars"
L.FadeDesc = "Enable fade out for bars and configure when they fade in."
L.FadeOutBars = "Enable FadeIn/FadeOut for bars"
L.FadeInOnCombat = "Fade In during combat"
L.FadeInOnTarget = "Fade In when target exists"
L.FadeInOnCasting = "Fade In when casting"
L.FadeInOnHover = "Fade In on mouse hover"

-- ==========================================
-- Button Textures
-- ==========================================
L.NormalTitle = "Border Texture Style"
L.NormalDesc = "Border texture for button."
L.NormalTextureType = "Border Texture Type"

L.BackdropTitle = "Backdrop Texture Style"
L.BackdropDesc = "Backdrop texture for button."
L.BackdropTextureType = "Backdrop Texture Type"

L.IconTitle = "Spell Icon Mask Style"
L.IconDesc = "Choose mask texture and adjust mask and icon scale"
L.IconMaskTextureType = "Icon Mask Texture Type"
L.IconMaskScale = "Modify Icon Mask Scale"
L.IconScale = "Modify Icon Scale"

L.PushedTitle = "Pushed Texture Style"
L.PushedDesc = "Texture that appears when you press a button."
L.PushedTextureType = "Pushed Texture Type"

L.HighlightTitle = "Highlight Texture Style"
L.HighlightDesc = "Texture that appears when you hover over a button."
L.HighliteTextureType = "Highlight Texture Type (mouseover)"

L.CheckedTitle = "Checked Texture Style"
L.CheckedDesc = "Texture that appears when you successfully use a skill or it's in the spell queue."
L.CheckedTextureType = "Checked Texture Type"

-- ==========================================
-- Cooldown Settings
-- ==========================================
L.CooldownTitle = "Cooldown Customization"
L.CooldownDesc = "Adjust cooldown Font, Swipe and Edge"
L.SwipeTextureType = "Cooldown Swipe Texture Type"
L.SwipeSize = "Cooldown Swipe texture Size"
L.CustomSwipeColor = "Use custom color for Cooldown Swipe"

L.EdgeTextureType = "Cooldown Edge Texture Type"
L.EdgeSize = "Cooldown Edge texture Size"
L.CustomEdgeColor = "Use custom color for Cooldown Edge"
L.EdgeAlwaysShow = "Always show Cooldown Edge"

L.CooldownFont = "Choose Font for Cooldown"
L.CooldownFontSize = "Cooldown font Size"
L.FontColor = "Font Color"

-- ==========================================
-- Color Override
-- ==========================================
L.ColorOverrideTitle = "Button Status Color Override"
L.ColorOverrideDesc = "Customize colors for different button states."
L.CustomColorOOR = "Custom color for Out Of Range"
L.CustomColorOOM = "Custom color for Out Of Mana"
L.CustomColorNoUse = "Custom color for Not Usable spells"

L.CustomColorGCD = "Custom color for icon On GCD"
L.CustomColorCD = "Custom color for icon On CD"
L.CustomColorNormal = "Custom color for Normal state"

L.RemoveOORColor = "Remove OOR Color"
L.RemoveOOMColor = "Remove OOM Color" 
L.RemoveNUColor = "Remove NU Color"
L.RemoveDesaturation = "Remove Desaturation"

-- ==========================================
-- Hide Frames and Animations
-- ==========================================
L.HideFrameTitle = "Hide Frames and Animations"
L.HideFrameDesc = "Hide various frames and annoying animations on the Action Bar."
L.HideBagsBar = "Hide Bags Bar"
L.HideMicroMenuBar = "Hide MicroMenu Bar"
L.HideStanceBar = "Hide Stance Bar"
L.HideTalkingHead = "Hide Talking Head"
L.HideInterrupt = "Hide Interrupt Animation on buttons"
L.HideCasting = "Hide Casting Animation on buttons"
L.HideReticle = "Hide AoE Targeting Animation on buttons"

-- ==========================================
-- Font Options
-- ==========================================
L.FontTitle = "Font Options"
L.FontDesc = "Customize the Font for Hotkey and Stack text."
L.FontHotKeyScale = "Modify Hotkey scale (for small buttons)"
L.FontStacksScale = "Modify Stacks scale (for small buttons)"
L.FontHideName = "Hide button (macro) Name"
L.FontNameScale = "Modify Name scale (for small buttons)"

L.HotKeyFont = "Choose Font for Hotkey"
L.HotkeyOutline = "Outline type for Hotkey"
L.HotkeyShadowColor = "Hotkey Font Shadow"
L.HotkeyShadowOffset = "Hotkey Font Shadow Offset"
L.FontHotkeySize = "Choose Hotkey font Size"
L.HotkeyAttachPoint = "Choose Attach Point for Hotkey"
L.HotkeyOffset = "Choose Hotkey Offset"
L.HotkeyCustomColor = "Custom color for Hotkey"

L.StacksFont = "Choose Font for Stacks"
L.StacksOutline = "Outline type for Stacks"
L.StacksShadowColor = "Stacks Font Shadow"
L.StacksShadowOffset = "Stacks Font Shadow Offset"
L.FontStacksSize = "Choose Stacks font Size"
L.StacksAttachPoint = "Choose Attach Point for Stacks"
L.StacksOffset = "Choose Stacks Offset"
L.StacksCustomColor = "Custom color for Stacks"

-- ==========================================
-- Profiles
-- ==========================================
L.ProfilesHeaderText = "You can change the active database profile, so you can have different settings for every character.\nReset the current profile back to its default values, in case your configuration is broken, or you simply want to start over."
L.ProfilesCopyText = "Copy the settings frome one existing profile into the currently active profile."
L.ProfilesDeleteText = "Delete existing and unused profiles from the database to save space, and cleanup the SavedVariables file."
L.ProfilesImportText = "Share your profile or import someone else's with a simple string."

-- ==========================================
-- WeakAuras Integration
-- ==========================================
L.WAIntTitle = "WeakAuras Integration"
L.WAIntDesc = "Choose the Proc and Loop override for WA's Glow effect.\nThis will affect the aura glow effect with type 'Proc Glow'"
L.ModifyWAGlow = "Mody WA Glow"
L.WAProcType = "WA Proc Type"
L.WALoopType = "WA Loop Type"
L.AddWAMask = "Add mask to WA icons"

-- ==========================================
-- Quick Presets
-- ==========================================
L.PresetActive = "Active"
L.PresetSelect = "Select"

-- ==========================================
-- Copy/Paste Functions
-- ==========================================
L["Copied: %s"] = "Copied: %s"
L["Pasted: %s → %s"] = "Pasted: %s → %s"
L.CopyText = "Click to Copy"
L.PasteText = "Click to Paste"
L.CancelText = "Click to Cancel"

-- ==========================================
-- Cooldown Manager Viewer Types
-- ==========================================
L.EssentialCooldownViewer   = "Essential Frame"
L.UtilityCooldownViewer     = "Utility Frame"
L.BuffIconCooldownViewer    = "Buff Icons"
L.BuffBarCooldownViewer     = "Buff Bars"

-- ==========================================
-- Cooldown Manager Basic Settings
-- ==========================================
L.IconPadding = "Icon Padding"
L.CDMBackdrop = "Icon Border (creates new frame)"
L.CDMCenteredGrid = "Center Icons"
L.CDMRemoveIconMask = "Remove Icon Mask"
L.CDMRemovePandemic = "Remove Pandemic Animation"
L.CDMSwipeColor = "Cooldown Swipe Color"
L.CDMAuraSwipeColor = "Aura Swipe Color"
L.CDMBackdropColor = "Border Color"
L.CDMBackdropAuraColor = "Aura Border Color"
L.CDMBackdropPandemicColor = "Pandemic Border Color"
L.CDMReverseSwipe = "Reverse Cooldown Fill"
L.CDMRemoveAuraTypeBorder = "Remove Aura type border"

-- ==========================================
-- Status Bar Settings
-- ==========================================
L.CDMBarContainerTitle = "Status Bar Settings"
L.CDMBarContainerDesc = "Customize the appearance and layout of status bars."
L.StatusBarTextures = "Status Bar Texture"
L.FontNameSize = "Name Font Size"
L.StatusBarBGTextures = "Background Texture"

-- ==========================================
-- Bar Layout Settings
-- ==========================================
L.BarGrow = "Growth Direction"
L.NameFont = "Name Font"
L.IconSize = "Icon Size"
L.BarHeight = "Bar Height"
L.BarPipSize = "Spark Size"
L.BarPipTexture = "Spark Texture"
L.BarOffset = "Bar Attach Offset"

-- ==========================================
-- CDM Additional Settings
-- ==========================================
L.CDMItemSize = "Item Size"
L.CDMRemoveGCDSwipe = "Remove GCD Swipe Animation"
L.CDMAuraReverseSwipe = "Reverse Aura Fill"

L.CDMCooldownTitle = "Cooldown Customization"
L.CDMCooldownDesc = "Modify cooldown appearance for CDM"

L.IconBorderTitle = "Icon Frame"
L.IconBorderDesc = "Create and configure new frame for rendering icon border"

L.CDMOptionsTitle = "Additional CDM Options"
L.CDMOptionsDesc = "Global enable additional settings that override standard CDM parameters"
