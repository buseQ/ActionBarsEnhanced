local AddonName, Addon = ...

Addon.layouts = {
    "layout",
    "layoutPresets",
    "CDVSettings"
}
Addon.layoutMicro = {
    {
        name = "FadeOptionsContainer",
        childs = {
            {name = "FadeOutBars", template = "OptionsCheckboxSliderTemplate"},
            {name = "FadeInOnCombat", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnTarget", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnCasting", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnHover", template = "OptionsCheckboxTemplate"},
        }
    },
}
Addon.layoutMini = {
    {
        name = "FadeOptionsContainer",
        childs = {
            {name = "FadeOutBars", template = "OptionsCheckboxSliderTemplate"},
            {name = "FadeInOnCombat", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnTarget", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnCasting", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnHover", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "NormalOptionsContainer",
        childs = {
            {name = "NormalTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorNormal", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewNormal", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "BackdropOptionsContainer",
        childs = {
            {name = "BackdropTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorBackdrop", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewBackdrop", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "IconOptionsContainer",
        childs = {
            {name = "IconMaskTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "MaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "IconScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "PreviewIcon", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "PushedOptionsContainer",
        childs = {
            {name = "PushedTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorPushed", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewPushed", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "HighlightOptionsContainer",
        childs = {
            {name = "HighlightTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorHighlight", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewHighlight", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "CheckedOptionsContainer",
        childs = {
            {name = "CheckedTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorChecked", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewChecked", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "CooldownOptionsContainer",
        childs = {
            {name = "SwipeTexture", template = "OptionsDropdownTemplate"},
            {name = "SwipeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "SwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "EdgeTexture", template = "OptionsDropdownTemplate"},
            {name = "EdgeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "EdgeColor", template = "OptionsColorOverrideTemplate"},
            {name = "EdgeAlwaysShow", template = "OptionsCheckboxTemplate"},
            {name = "Divider2", template = "OptionsDividerTemplate"},
            {name = "CooldownFont", template = "OptionsDropdownTemplate"},
            {name = "CooldownFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CooldownFontColor", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewSwipe", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
            {name = "PreviewEdge", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -90}, scale="1.8"},
            {name = "PreviewCooldownFont", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -170}, scale="1.8"},
        }
    },
    {
        name = "ColorOverrideOptionsContainer",
        childs = {
            {name = "CustomColorOOR", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorOOM", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorNotUsable", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "FontOptionsContainer",
        childs = {
            {name = "HotkeyFont", template = "OptionsDropdownTemplate"},
            {name = "HotkeyOutline", template = "OptionsDropdownTemplate"},
            {name = "HotkeySize", template = "OptionsCheckboxSliderTemplate"},
            {name = "HotkeyColor", template = "OptionsColorOverrideTemplate"},
            {name = "HotkeyPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "HotkeyOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "HotkeyShadow", template = "OptionsColorOverrideTemplate"},
            {name = "HotkeyShadowOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "HotkeyScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "StacksFont", template = "OptionsDropdownTemplate"},
            {name = "StacksOutline", template = "OptionsDropdownTemplate"},
            {name = "StacksSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "StacksColor", template = "OptionsColorOverrideTemplate"},
            {name = "StacksPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "StacksOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "StacksShadow", template = "OptionsColorOverrideTemplate"},
            {name = "StacksShadowOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "StacksScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "Divider2", template = "OptionsDividerTemplate"},
            {name = "NameHide", template = "OptionsCheckboxTemplate"},
            {name = "NameScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "PreviewFont2", template = "OptionsButtonTextPreviewTemplate", point = {"RIGHT", "container", "RIGHT", 20, 80}, scale="2.0"},
            {name = "PreviewFont15", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont2", "BOTTOM", 0, -5}, scale="1.5"},
            {name = "PreviewFont1", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont15", "BOTTOM", 0, -5}, scale="1.0"},
            {name = "PreviewFont075", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont1", "BOTTOM", 0, -5}, scale="0.75"},
            {name = "PreviewFont05", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont075", "BOTTOM", 0, -5}, scale="0.5"},
        }
    },
}

Addon.layout = {
    {
        name = "GlowOptionsContainer",
        childs = {
            {name = "GlowOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorGlow", template = "OptionsColorOverrideTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "HideProc", template = "OptionsCheckboxTemplate",},
            {name = "ProcOptions", template = "OptionsDropdownTemplate",},
            {name = "CustomColorProc", template = "OptionsColorOverrideTemplate",},
            {name = "ProcLoopPreview", template = "OptionsButtonGlowPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, 4}, scale="1.8"},
            {name = "ProcStartPreview", template = "OptionsButtonGlowPreviewTemplate", point = {"TOP", "Divider", "BOTTOM", 180, -10}, scale="1.8"},
        
        }
    },
    {
        name = "AssistLoopOptionsContainer",
        childs = {
            {name = "AssistLoopType", template = "OptionsDropdownTemplate"},
            {name = "CustomColorAssistLoop", template = "OptionsColorOverrideTemplate"},
            {name = "AssistAltGlowType", template = "OptionsDropdownTemplate"},
            {name = "CustomColorAltGlow", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "FadeOptionsContainer",
        childs = {
            {name = "FadeOutBars", template = "OptionsCheckboxSliderTemplate"},
            {name = "FadeInOnCombat", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnTarget", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnCasting", template = "OptionsCheckboxTemplate"},
            {name = "FadeInOnHover", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "NormalOptionsContainer",
        childs = {
            {name = "NormalTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorNormal", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewNormal", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "BackdropOptionsContainer",
        childs = {
            {name = "BackdropTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorBackdrop", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewBackdrop", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "IconOptionsContainer",
        childs = {
            {name = "IconMaskTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "MaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "IconScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "PreviewIcon", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "PushedOptionsContainer",
        childs = {
            {name = "PushedTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorPushed", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewPushed", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "HighlightOptionsContainer",
        childs = {
            {name = "HighlightTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorHighlight", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewHighlight", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "CheckedOptionsContainer",
        childs = {
            {name = "CheckedTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorChecked", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewChecked", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
        }
    },
    {
        name = "CooldownOptionsContainer",
        childs = {
            {name = "SwipeTexture", template = "OptionsDropdownTemplate"},
            {name = "SwipeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "SwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "EdgeTexture", template = "OptionsDropdownTemplate"},
            {name = "EdgeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "EdgeColor", template = "OptionsColorOverrideTemplate"},
            {name = "EdgeAlwaysShow", template = "OptionsCheckboxTemplate"},
            {name = "Divider2", template = "OptionsDividerTemplate"},
            {name = "CooldownFont", template = "OptionsDropdownTemplate"},
            {name = "CooldownFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CooldownFontColor", template = "OptionsColorOverrideTemplate"},
            {name = "PreviewSwipe", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -10}, scale="1.8"},
            {name = "PreviewEdge", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -90}, scale="1.8"},
            {name = "PreviewCooldownFont", template = "OptionsButtonCooldownPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, -170}, scale="1.8"},
        }
    },
    {
        name = "ColorOverrideOptionsContainer",
        childs = {
            {name = "CustomColorOOR", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorOOM", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorNotUsable", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "HideFramesOptionsContainer",
        childs = {
            {name = "HideTalkingHead", template = "OptionsCheckboxTemplate"},
            {name = "HideInterrupt", template = "OptionsCheckboxTemplate"},
            {name = "HideCasting", template = "OptionsCheckboxTemplate"},
            {name = "HideReticle", template = "OptionsCheckboxTemplate"},
            {name = "PreviewInterrupt", template = "OptionsButtonPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 60, -50}, scale="1.5"},
            {name = "PreviewCasting", template = "OptionsButtonPreviewTemplate", point = {"LEFT", "PreviewInterrupt", "RIGHT", 5, 0}, scale="1.5"},
            {name = "PreviewReticle", template = "OptionsButtonPreviewTemplate", point = {"LEFT", "PreviewCasting", "RIGHT", 5, 0}, scale="1.5"},
        }
    },
    {
        name = "FontOptionsContainer",
        childs = {
            {name = "HotkeyFont", template = "OptionsDropdownTemplate"},
            {name = "HotkeyOutline", template = "OptionsDropdownTemplate"},
            {name = "HotkeySize", template = "OptionsCheckboxSliderTemplate"},
            {name = "HotkeyColor", template = "OptionsColorOverrideTemplate"},
            {name = "HotkeyPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "HotkeyOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "HotkeyShadow", template = "OptionsColorOverrideTemplate"},
            {name = "HotkeyShadowOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "HotkeyScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "StacksFont", template = "OptionsDropdownTemplate"},
            {name = "StacksOutline", template = "OptionsDropdownTemplate"},
            {name = "StacksSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "StacksColor", template = "OptionsColorOverrideTemplate"},
            {name = "StacksPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "StacksOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "StacksShadow", template = "OptionsColorOverrideTemplate"},
            {name = "StacksShadowOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "StacksScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "Divider2", template = "OptionsDividerTemplate"},
            {name = "NameHide", template = "OptionsCheckboxTemplate"},
            {name = "NameScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "PreviewFont2", template = "OptionsButtonTextPreviewTemplate", point = {"RIGHT", "container", "RIGHT", 20, 80}, scale="2.0"},
            {name = "PreviewFont15", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont2", "BOTTOM", 0, -5}, scale="1.5"},
            {name = "PreviewFont1", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont15", "BOTTOM", 0, -5}, scale="1.0"},
            {name = "PreviewFont075", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont1", "BOTTOM", 0, -5}, scale="0.75"},
            {name = "PreviewFont05", template = "OptionsButtonTextPreviewTemplate", point = {"TOP", "PreviewFont075", "BOTTOM", 0, -5}, scale="0.5"},
        }
    },
    --[[ {
        name = "BarsOptionsContainer",
        childs = {
            {name = "BarOrientation", template = "OptionsDropdownTemplate"},
            {name = "RowsNumber", template = "OptionsCheckboxSliderTemplate"},
            {name = "ColumnsNumber", template = "OptionsCheckboxSliderTemplate"},
            {name = "ButtonsNumber", template = "OptionsCheckboxSliderTemplate"},
            {name = "ButtonSize", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "BarsPadding", template = "OptionsCheckboxSliderTemplate"},
        }
    }, ]]
}


Addon.layoutPresets = {
    {
        name = "PresetsOptionsContainer",
        --template = "OptionsPresetsTemplate",
        childs = {}
    },
}

Addon.EssentialCooldownViewer = {
    {
        name = "CooldownViewerContainer",
        childs = {
            {name = "CDMEnable", template = "OptionsCheckboxTemplate"},
            {name = "IconPadding", template = "OptionsCheckboxSliderTemplate"},
            {name = "CenteredGrid", template = "OptionsCheckboxTemplate"},
            {name = "RemovePandemicAnims", template = "OptionsCheckboxTemplate"},
            {name = "RemoveDesaturation", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "GlowOptionsContainer",
        childs = {
            {name = "GlowOptions", template = "OptionsDropdownTemplate"},
            {name = "CustomColorGlow", template = "OptionsColorOverrideTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "HideProc", template = "OptionsCheckboxTemplate",},
            {name = "ProcOptions", template = "OptionsDropdownTemplate",},
            {name = "CustomColorProc", template = "OptionsColorOverrideTemplate",},
            {name = "ProcLoopPreview", template = "OptionsButtonGlowPreviewTemplate", point = {"TOP", "desc", "BOTTOM", 180, 4}, scale="1.8"},
            {name = "ProcStartPreview", template = "OptionsButtonGlowPreviewTemplate", point = {"TOP", "Divider", "BOTTOM", 180, -10}, scale="1.8"},
        
        }
    },
    {
        name = "CooldownViewerIconContainer",
        childs = {
            {name = "IconMaskTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "MaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "IconScale", template = "OptionsCheckboxSliderTemplate"},
        }
    },
    {
        name = "CooldownViewerCDContainer",
        childs = {
            {name = "CDMItemSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMSwipeTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMSwipeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMSwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMAuraSwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMReverseSwipe", template = "OptionsCheckboxTemplate"},
            {name = "CDMAuraReverseSwipe", template = "OptionsCheckboxTemplate"},
            {name = "CDMRemoveGCDSwipe", template = "OptionsCheckboxTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "CDMEdgeTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMEdgeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMEdgeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMEdgeAlwaysShow", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "CooldownViewerFontContainer",
        childs = {
            {name = "CDMCooldownFont", template = "OptionsDropdownTemplate"},
            {name = "CDMCooldownFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCooldownFontColor", template = "OptionsColorOverrideTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "CDMStacksFont", template = "OptionsDropdownTemplate"},
            {name = "CDMStacksPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMStacksOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CDMStacksFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMStacksFontColor", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "CooldownViewerBackdropContainer",
        childs = {
            {name = "BackdropSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "BackdropColor", template = "OptionsColorOverrideTemplate"},
            {name = "BackdropAuraColor", template = "OptionsColorOverrideTemplate"},
            {name = "BackdropPandemicColor", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "ColorOverrideOptionsContainer",
        childs = {
            {name = "CustomColorOOR", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorOOM", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorNotUsable", template = "OptionsColorOverrideTemplate"},
        }
    },
}
Addon.BuffIconCooldownViewer = {
    {
        name = "CooldownViewerContainer",
        childs = {
            {name = "CDMEnable", template = "OptionsCheckboxTemplate"},
            {name = "IconPadding", template = "OptionsCheckboxSliderTemplate"},
            {name = "CenteredGrid", template = "OptionsCheckboxTemplate"},
            {name = "RemovePandemicAnims", template = "OptionsCheckboxTemplate"},
            {name = "RemoveDesaturation", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "CooldownViewerIconContainer",
        childs = {
            {name = "IconMaskTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "MaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "IconScale", template = "OptionsCheckboxSliderTemplate"},
        }
    },
    {
        name = "CooldownViewerCDContainer",
        childs = {
            {name = "CDMItemSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMSwipeTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMSwipeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMSwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMAuraSwipeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMReverseSwipe", template = "OptionsCheckboxTemplate"},
            {name = "CDMAuraReverseSwipe", template = "OptionsCheckboxTemplate"},
            {name = "CDMRemoveGCDSwipe", template = "OptionsCheckboxTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "CDMEdgeTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMEdgeSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMEdgeColor", template = "OptionsColorOverrideTemplate"},
            {name = "CDMEdgeAlwaysShow", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "CooldownViewerFontContainer",
        childs = {
            {name = "CDMCooldownFont", template = "OptionsDropdownTemplate"},
            {name = "CDMCooldownFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCooldownFontColor", template = "OptionsColorOverrideTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "CDMStacksFont", template = "OptionsDropdownTemplate"},
            {name = "CDMStacksPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMStacksOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CDMStacksFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMStacksFontColor", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "CooldownViewerBackdropContainer",
        childs = {
            {name = "BackdropSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "BackdropColor", template = "OptionsColorOverrideTemplate"},
            {name = "BackdropAuraColor", template = "OptionsColorOverrideTemplate"},
            {name = "BackdropPandemicColor", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "ColorOverrideOptionsContainer",
        childs = {
            {name = "CustomColorOOR", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorOOM", template = "OptionsColorOverrideTemplate"},
            {name = "CustomColorNotUsable", template = "OptionsColorOverrideTemplate"},
        }
    },
}
Addon.BuffBarCooldownViewer = {
    {
        name = "CooldownViewerContainer",
        childs = {
            {name = "CDMEnable", template = "OptionsCheckboxTemplate"},
            {name = "IconPadding", template = "OptionsCheckboxSliderTemplate"},
            {name = "RemovePandemicAnims", template = "OptionsCheckboxTemplate"},
        }
    },
    {
        name = "CooldownViewerIconContainer",
        childs = {
            {name = "IconMaskTextureOptions", template = "OptionsDropdownTemplate"},
            {name = "MaskScale", template = "OptionsCheckboxSliderTemplate"},
            {name = "IconScale", template = "OptionsCheckboxSliderTemplate"},
        }
    },
    {
        name = "CooldownViewerBarContainer",
        childs = {
            {name = "CDMBarGrow", template = "OptionsDropdownTemplate"},
            {name = "IconSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "BarHeight", template = "OptionsCheckboxSliderTemplate"},
            {name = "BarOffset", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMBarTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMPipTexture", template = "OptionsDropdownTemplate"},
            {name = "PipSize", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "CDMBarBGTexture", template = "OptionsDropdownTemplate"},
            {name = "CDMBarBGColor", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "CooldownViewerFontContainer",
        childs = {
            {name = "CDMCooldownFont", template = "OptionsDropdownTemplate"},
            {name = "CDMCooldownFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMCooldownFontColor", template = "OptionsColorOverrideTemplate"},
            {name = "Divider", template = "OptionsDividerTemplate"},
            {name = "CDMStacksFont", template = "OptionsDropdownTemplate"},
            {name = "CDMStacksPoint", template = "OptionsDoubleDropdownTemplate"},
            {name = "CDMStacksOffset", template = "OptionsDoubleCheckboxSliderTemplate"},
            {name = "CDMStacksFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMStacksFontColor", template = "OptionsColorOverrideTemplate"},
            {name = "Divider2", template = "OptionsDividerTemplate"},
            {name = "CDMNameFont", template = "OptionsDropdownTemplate"},
            {name = "CDMNameFontSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "CDMNameFontColor", template = "OptionsColorOverrideTemplate"},
        }
    },
    {
        name = "CooldownViewerBackdropContainer",
        childs = {
            {name = "BackdropSize", template = "OptionsCheckboxSliderTemplate"},
            {name = "BackdropColor", template = "OptionsColorOverrideTemplate"},
            {name = "BackdropAuraColor", template = "OptionsColorOverrideTemplate"},
            {name = "BackdropPandemicColor", template = "OptionsColorOverrideTemplate"},
        }
    },
}