local AddonName, Addon = ...

local L = {}

Addon.L = L

L.GlowTypeTitle = "Proc Loop Glow"
L.GlowTypeDesc = "Choose the proc loop animation"
L.GlowType = "Proc Loop Glow Type"

L.UseCustomColor = "Use custom color"

L.Desaturate = "Desaturate"

L.ProcStartTitle = "Proc Start Glow"
L.ProcStartDesc = "Choose or hide the start of proc animation"
L.HideProcAnim = "Hide Start Proc Animation"
L.StartProcType = "Start Proc Animation Type"

L.AssistTitle = "Assisted Highlight Glow"
L.AssistDesc = "Choose the Combat Assisted Highlight animation"
L.AssistType = "Assisted Highlight type"
L.AssistAltType = "Assisted secondary Highlight type"

L.FadeTitle = "Fade Bars"
L.FadeDesc = "Enable fade out for bars and configure when they fade in."
L.FadeOutBars = "Enable FadeIn/FadeOut for bars"
L.FadeInOnCombat = "Fade In during combat"
L.FadeInOnTarget = "Fade In when target exists"
L.FadeInOnCasting = "Fade In when casting"
L.FadeInOnHover = "Fade In on mouse hover"

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

L.ColorOverrideTitle = "Button Status Color Override"
L.ColorOverrideDesc = "Customize colors for different button states."
L.CustomColorCooldownSwipe = "Use custom color for Cooldown Swipe"
L.CustomColorOOR = "Custom color for Out Of Range"
L.CustomColorOOM = "Custom color for Out Of Mana"
L.CustomColorNoUse = "Custom color for Not Usable spells"

L.HideFrameTitle = "Hide Frames and Animations"
L.HideFrameDesc = "Hide various frames and annoying animations on the Action Bar."
L.HideBagsBar = "Hide Bags Bar"
L.HideMicroMenuBar = "Hide MicroMenu Bar"
L.HideStanceBar = "Hide Stance Bar"
L.HideInterrupt = "Hide Interrupt Animation on buttons"
L.HideCasting = "Hide Casting Animation on buttons"
L.HideReticle = "Hide AoE Targeting Animation on buttons"

L.FontTitle = "Font Options"
L.FontDesc = "Choose scale of Fonts on small Buttons. Will only affect buttons with scale <100%"
L.FontHotKeyScale = "Modify scale of HotKey font"
L.FontStacksScale = "Modify scale of Stacks font"
L.FontHideName = "Hide button (macro) Name"
L.FontNameScale = "Modify scale of Name font"

L.welcomeMessage1 = "Thank you for using |cff1df2a8ActionBars Enhanced|r"
L.welcomeMessage2 = "You may access options by using |cff1df2a8/"

L.ProfilesHeaderText = "You can change the active database profile, so you can have different settings for every character.\nReset the current profile back to its default values, in case your configuration is broken, or you simply want to start over."
L.ProfilesCopyText = "Copy the settings frome one existing profile into the currently active profile."
L.ProfilesDeleteText = "Delete existing and unused profiles from the database to save space, and cleanup the SavedVariables file."
L.ProfilesImportText = "Share your profile or import someone else's with a simple string."

L.WAIntTitle = "WeakAuras Integration"
L.WAIntDesc = "Choose the Proc and Loop override for WA's Glow effect.\nThis will affect the aura glow effect with type 'Proc Glow'"
L.ModifyWAGlow = "Mody WA Glow"
L.WAProcType = "WA Proc Type"
L.WALoopType = "WA Loop Type"
L.AddWAMask = "Add mask to WA icons"