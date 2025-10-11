local AddonName, Addon = ...

local T = Addon.Templates

local function GetFlipBook(...)
    local Animations = {...}

    for _, Animation in ipairs(Animations) do
        if Animation:GetObjectType() == "FlipBook" then
            Animation:SetParentKey("FlipAnim")
            return Animation
        end
    end
end

function Addon:UpdateAssistFlipbook(region)

    local loopAnim = T.LoopGlow[Addon.C.CurrentAssistType] or nil

    local flipAnim = GetFlipBook(region.Anim:GetAnimations())

    if loopAnim.atlas then
        region:SetAtlas(loopAnim.atlas)  
    elseif loopAnim.texture then
        region:SetTexture(loopAnim.texture)
    end

   if loopAnim then
        region:ClearAllPoints()
        region:SetSize(region:GetSize())
        region:SetPoint("CENTER", region:GetParent(), "CENTER", -1.5, 1)
        flipAnim:SetFlipBookRows(loopAnim.rows or 6)
        flipAnim:SetFlipBookColumns(loopAnim.columns or 5)
        flipAnim:SetFlipBookFrames(loopAnim.frames or 30)
        flipAnim:SetDuration(loopAnim.duration or 1.0)
        flipAnim:SetFlipBookFrameWidth(loopAnim.frameW or 0.0)
        flipAnim:SetFlipBookFrameHeight(loopAnim.frameH or 0.0)
        region:SetScale(loopAnim.scale or 1)
    end
    --region.ProcLoopFlipbook:SetTexCoords(333, 400, 0.412598, 0.575195, 0.393555, 0.78418, false, false)
    region:SetDesaturated(Addon.C.DesaturateAssist)
    if Addon.C.UseAssistGlowColor then
        region:SetVertexColor(Addon:GetRGB("AssistGlowColor"))
    else
        region:SetVertexColor(1.0, 1.0, 1.0)
    end
	region.Anim:Stop()
    region.Anim:Play()
end

function Addon:UpdateFlipbook(Button)
    if not Button:IsVisible() then return end
    
	local region = Button.SpellActivationAlert

	if (not region) or (not region.ProcStartAnim) then return end

    local loopAnim = T.LoopGlow[Addon.C.CurrentLoopGlow] or nil
    local procAnim = T.ProcGlow[Addon.C.CurrentProcGlow] or nil
    local altGlowAtlas = T.PushedTextures[Addon.C.CurrentAssistAltType] or nil

    if altGlowAtlas then
        region.ProcAltGlow:SetAtlas(altGlowAtlas.atlas)
    end
    region.ProcAltGlow:SetDesaturated(Addon.C.DesaturateAssistAlt)
    if Addon.C.UseAssistAltColor then
        region.ProcAltGlow:SetVertexColor(Addon:GetRGB("AssistAltColor"))
    else
        region.ProcAltGlow:SetVertexColor(1.0, 1.0, 1.0)
    end
        
    local startProc = region.ProcStartAnim.FlipAnim or GetFlipBook(region.ProcStartAnim:GetAnimations())
    
    if startProc then
        
        if Addon.C.HideProc then
            startProc:SetDuration(0)
            region.ProcStartFlipbook:Hide()
        else
            region.ProcStartFlipbook:Show()
            if procAnim.atlas then
                region.ProcStartFlipbook:SetAtlas(procAnim.atlas)
            elseif procAnim.texture then
                region.ProcStartFlipbook:SetTexture(procAnim.texture)
            end
            if procAnim then
                startProc:SetFlipBookRows(procAnim.rows or 6)
                startProc:SetFlipBookColumns(procAnim.columns or 5)
                startProc:SetFlipBookFrames(procAnim.frames or 30)
                startProc:SetDuration(procAnim.duration or 0.702)
                startProc:SetFlipBookFrameWidth(procAnim.frameW or 0.0)
                startProc:SetFlipBookFrameHeight(procAnim.frameH or 0.0)
                region.ProcStartFlipbook:SetScale(procAnim.scale or 1)
            end
            region.ProcStartFlipbook:SetDesaturated(Addon.C.DesaturateProc)

            if Addon.C.UseProcColor then
                region.ProcStartFlipbook:SetVertexColor(Addon:GetRGB("ProcColor"))
            else
                region.ProcStartFlipbook:SetVertexColor(1.0, 1.0, 1.0)
            end
        end
    end

    if loopAnim.atlas then
        region.ProcLoopFlipbook:SetAtlas(loopAnim.atlas)    
    elseif loopAnim.texture then
        region.ProcLoopFlipbook:SetTexture(loopAnim.texture)
    end
    if loopAnim then
        region.ProcLoopFlipbook:ClearAllPoints()
        region.ProcLoopFlipbook:SetSize(region:GetSize())
        region.ProcLoopFlipbook:SetPoint("CENTER", region, "CENTER", -1.5, 1)
        region.ProcLoop.FlipAnim:SetFlipBookRows(loopAnim.rows or 6)
        region.ProcLoop.FlipAnim:SetFlipBookColumns(loopAnim.columns or 5)
        region.ProcLoop.FlipAnim:SetFlipBookFrames(loopAnim.frames or 30)
        region.ProcLoop.FlipAnim:SetDuration(loopAnim.duration or 1.0)
        region.ProcLoop.FlipAnim:SetFlipBookFrameWidth(loopAnim.frameW or 0.0)
        region.ProcLoop.FlipAnim:SetFlipBookFrameHeight(loopAnim.frameH or 0.0)
        region.ProcLoopFlipbook:SetScale(loopAnim.scale or 1)
    end
    --region.ProcLoopFlipbook:SetTexCoords(333, 400, 0.412598, 0.575195, 0.393555, 0.78418, false, false)
    region.ProcLoopFlipbook:SetDesaturated(Addon.C.DesaturateGlow)
    if Addon.C.UseLoopGlowColor then
        region.ProcLoopFlipbook:SetVertexColor(Addon:GetRGB("LoopGlowColor"))
    else
        region.ProcLoopFlipbook:SetVertexColor(1.0, 1.0, 1.0)
    end
end

local function Hook_UpdateFlipbook(Frame, Button)
    if type(Button) ~= "table" then
		Button = Frame
	end

	Addon:UpdateFlipbook(Button)
end



-----------------------------------------
-- forked from ElvUI
-----------------------------------------

local Fader = CreateFrame('Frame')
Fader.Frames = {}
Fader.interval = 0.025

local function Fading(_, elapsed)
    Fader.timer = (Fader.timer or 0) + elapsed
    if Fader.timer > Fader.interval then
        Fader.timer = 0

        for frame, data in next, Fader.Frames do
            if frame:IsVisible() then
                data.fadeTimer = (data.fadeTimer or 0) + (elapsed + Fader.interval)
            else
                data.fadeTimer = (data.fadeTimer or 0) + 1
            end

            if data.fadeTimer < data.duration then
                if data.mode == "IN" then
                    frame:SetAlpha((data.fadeTimer / data.duration) * data.diffAlpha + data.fromAlpha)
                else
                    frame:SetAlpha(((data.duration - data.fadeTimer) / data.duration) * data.diffAlpha + data.toAlpha)
                end
            else
                frame:SetAlpha(data.toAlpha)
                if frame and Fader.Frames[frame] then
                    if frame.fade then
                        frame.fade.fadeTimer = nil
                    end
                    Fader.Frames[frame] = nil
                end
            end
        end
        if not next(Fader.Frames) then
            Fader:SetScript("OnUpdate", nil)
        end
    end
end

local function FrameFade(frame)
    local fade = frame.fade
    frame:SetAlpha(fade.fromAlpha)

    if not Fader.Frames[frame] then
        Fader.Frames[frame] = fade
        Fader:SetScript("OnUpdate", Fading)
    else
        Fader.Frames[frame] = fade
    end
end

local function FrameFadeIn(frame, duration, fromAlpha, toAlpha)
    if frame.fade then
        frame.fade.fadeTimer = nil
    else
        frame.fade = {}
    end

    frame.fade.mode = "IN"
    frame.fade.duration = duration
    frame.fade.fromAlpha = fromAlpha
    frame.fade.toAlpha = toAlpha
    frame.fade.diffAlpha = toAlpha - fromAlpha

    FrameFade(frame)
end

local function FrameFadeOut(frame, duration, fromAlpha, toAlpha)
    if frame.fade then
        frame.fade.fadeTimer = nil
    else
        frame.fade = {}
    end

    frame.fade.mode = "OUT"
    frame.fade.duration = duration
    frame.fade.fromAlpha = fromAlpha
    frame.fade.toAlpha = toAlpha
    frame.fade.diffAlpha = fromAlpha - toAlpha

    FrameFade(frame)
end

local bars = {
    
	"MultiActionBar",
	"StanceBar",
	"PetBar",
	"PossessActionBar",
	"BonusBar",
	"VehicleBar",
	"TempShapeshiftBar",
	"OverrideBar",
    "MainMenuBar",
    "MultiBarBottomLeft",
    "MultiBarBottomRight",
    "MultiBarLeft",
    "MultiBarRight",
    "MultiBar5",
    "MultiBar6",
    "MultiBar7",
}

local animBars = {}

local function IsFrameFocused(frame)
    local focusedFrames = GetMouseFoci()
    local focusedFrame
    if focusedFrames then
        if focusedFrames[1] then
            if focusedFrames[1]:GetParent() and focusedFrames[1]:GetParent():GetParent() then
                focusedFrame = focusedFrames[1]:GetParent():GetParent()
            end
        end
    end
    return focusedFrames and focusedFrame == frame
end

local function ShouldFadeIn(frame)
    return (Addon.C.FadeInOnCombat and UnitAffectingCombat("player"))
    or (Addon.C.FadeInOnTarget and UnitExists("target"))
    or (Addon.C.FadeInOnCasting and UnitCastingInfo("player"))
    or (Addon.C.FadeInOnHover and IsFrameFocused(frame))
end

local function FixKeyBindText(text)
    local function escapePattern(text)
        return text:gsub("([%-%.%+%*%?%^%$%(%)%[%]%%])", "%%%1")
    end
    if text and text ~= _G.RANGE_INDICATOR then
		text = gsub(text, KEY_BUTTON4, "M4")
		text = gsub(text, KEY_BUTTON5, "M5")
		text = gsub(text, KEY_BUTTON3, "MMB")
		text = gsub(text, KEY_NUMLOCK, "NL")
		text = gsub(text, KEY_PAGEUP, "PU")
		text = gsub(text, KEY_PAGEDOWN, "PD")
		text = gsub(text, KEY_SPACE, "SpB")
		text = gsub(text, KEY_INSERT, "Ins")
		text = gsub(text, KEY_HOME, "Hm")
		text = gsub(text, KEY_DELETE, "Del")
		text = gsub(text, escapePattern(KEY_NUMPAD0), "N0")
		text = gsub(text, escapePattern(KEY_NUMPAD1), "N1")
		text = gsub(text, escapePattern(KEY_NUMPAD2), "N2")
		text = gsub(text, escapePattern(KEY_NUMPAD3), "N3")
		text = gsub(text, escapePattern(KEY_NUMPAD4), "N4")
		text = gsub(text, escapePattern(KEY_NUMPAD5), "N5")
		text = gsub(text, escapePattern(KEY_NUMPAD6), "N6")
		text = gsub(text, escapePattern(KEY_NUMPAD7), "N7")
		text = gsub(text, escapePattern(KEY_NUMPAD8), "N8")
		text = gsub(text, escapePattern(KEY_NUMPAD9), "N9")
		text = gsub(text, escapePattern(KEY_NUMPADDIVIDE), "N/")
		text = gsub(text, escapePattern(KEY_NUMPADMULTIPLY), "N*")
		text = gsub(text, escapePattern(KEY_NUMPADMINUS), "N-")
		text = gsub(text, escapePattern(KEY_NUMPADPLUS), "N+")
		text = gsub(text, escapePattern(KEY_NUMPADDECIMAL), "N.")
    end
    return text or ""
end

local function Hook_UpdateHotkeys(self, actionButtonType)
    local hotKey = self.HotKey
	local text = hotKey:GetText()
    hotKey:SetText(FixKeyBindText(text))
    local mult = self:GetParent():GetScale()
    if mult < 1 then
        hotKey:SetScale(Addon.C.FontHotKey and mult + Addon.C.FontHotKeyScale or 1.0)
        hotKey:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    end
end

function Addon:BarsFadeAnim()
    if not Addon.C.FadeBars then return end
    for _, barName in ipairs(animBars) do
        local frame = _G[barName]
        if frame then
            if Addon.C.FadeBars and ShouldFadeIn(frame) then
                FrameFadeIn(frame, 0.25, frame:GetAlpha(), 1)
            else
                FrameFadeOut(frame, 0.25, frame:GetAlpha(), Addon.C.FadeBarsAlpha)
            end
        end
    end
end

function Addon:RefreshIconColor(button)
    local icon = button.icon
    local action = button.action
    local type, spellID = GetActionInfo(action)

    local isUsable, notEnoughMana = IsUsableAction(button.action)
    button.needsRangeCheck = spellID and C_Spell.SpellHasRange(spellID)
    button.spellOutOfRange = button.needsRangeCheck and C_Spell.IsSpellInRange(spellID) == false
    if (button.spellOutOfRange and Addon.C.UseOORColor) then
        icon:SetDesaturated(Addon.C.OORDesaturate)
        icon:SetVertexColor(Addon:GetRGBA("OORColor"))       
    elseif isUsable then
        icon:SetDesaturated(false)
        icon:SetVertexColor(1.0, 1.0, 1.0)
    elseif (notEnoughMana and Addon.C.UseOOMColor) then
        icon:SetDesaturated(Addon.C.OOMDesaturate)
        icon:SetVertexColor(Addon:GetRGBA("OOMColor"))
    elseif Addon.C.UseNoUseColor then
        icon:SetDesaturated(Addon.C.NoUseDesaturate)
        icon:SetVertexColor(Addon:GetRGBA("NoUseColor"))
    end
end

local function HoverHook(button)
    local frame = button:GetParent():GetParent()
    local fader = frame.fade
    if fader then
        Addon:BarsFadeAnim()
    end
end

local function Hook_Update(self)
    Addon:RefreshIconColor(self)
end
local function Hook_UpdateUsable(self, action, usable, noMana)
    Addon:RefreshIconColor(self)
end

local function Hook_UpdateButton(button, isStanceBar)
    if button == ExtraActionButton1 then return end

    local normalAtlas = T.NormalTextures[Addon.C.CurrentNormalTexture] or nil
    if button.NormalTexture then
        if normalAtlas then
            if normalAtlas.hide then
                button.NormalTexture:Hide()
            elseif Addon.C.CurrentNormalTexture > 1 then
                if normalAtlas.atlas then
                    button:SetNormalAtlas(normalAtlas.atlas)
                end
                if normalAtlas.texture then
                    button.NormalTexture:SetTexture(normalAtlas.texture)
                end
                if normalAtlas.point then
                    button.NormalTexture:ClearAllPoints()
                    button.NormalTexture:SetPoint(normalAtlas.point, button, normalAtlas.point)
                end
                if normalAtlas.padding then
                    button.NormalTexture:AdjustPointsOffset(normalAtlas.padding[1], normalAtlas.padding[2])
                end
                if normalAtlas.size then
                    button.NormalTexture:SetSize(normalAtlas.size[1], normalAtlas.size[2])
                end
                if normalAtlas.coords then
                    button.NormalTexture:SetTexCoord(normalAtlas.coords[1], normalAtlas.coords[2], normalAtlas.coords[3], normalAtlas.coords[4])
                end
                button.NormalTexture:SetDrawLayer("OVERLAY")
                button.NormalTexture:SetScale(isStanceBar and 0.69 or 1.0)
            end
        end
        button.NormalTexture:SetDesaturated(Addon.C.DesaturateNormal)
        if Addon.C.UseNormalTextureColor then
            button.NormalTexture:SetVertexColor(Addon:GetRGBA("NormalTextureColor"))
        end
    end

    local backdropAtlas = T.BackdropTextures[Addon.C.CurrentBackdropTexture] or nil
    if button.SlotBackground then
        if backdropAtlas and Addon.C.CurrentBackdropTexture > 1 then
            if backdropAtlas.atlas then
                button.SlotBackground:SetAtlas(backdropAtlas.atlas)
            end
            if backdropAtlas.texture then
                button.SlotBackground:SetTexture(backdropAtlas.texture)
            end
            if backdropAtlas.point then
                button.SlotBackground:ClearAllPoints()
                button.SlotBackground:SetPoint(backdropAtlas.point, button, backdropAtlas.point)
            end
            if backdropAtlas.padding then
                button.SlotBackground:AdjustPointsOffset(backdropAtlas.padding[1], backdropAtlas.padding[2])
            end
            if backdropAtlas.size then
                button.SlotBackground:SetSize(backdropAtlas.size[1], backdropAtlas.size[2])
            end
            if backdropAtlas.coords then
                button.SlotBackground:SetTexCoord(backdropAtlas.coords[1], backdropAtlas.coords[2], backdropAtlas.coords[3], backdropAtlas.coords[4])
            end
            button.SlotBackground:SetScale(isStanceBar and 0.69 or 1.0)
        end
        button.SlotBackground:SetDesaturated(Addon.C.DesaturateBackdrop)
        if Addon.C.UseBackdropColor then
            button.SlotBackground:SetVertexColor(Addon:GetRGBA("BackdropColor"))
        end
    end

    local pushedAtlas = T.PushedTextures[Addon.C.CurrentPushedTexture] or nil
    if button.PushedTexture then
        if pushedAtlas and Addon.C.CurrentPushedTexture > 1 then
            if pushedAtlas.atlas then
                button:SetPushedAtlas(pushedAtlas.atlas)
            elseif pushedAtlas.texture then
                button.PushedTexture:SetTexture(pushedAtlas.texture)
            end
            if pushedAtlas.point then
                button.PushedTexture:ClearAllPoints()
                button.PushedTexture:SetPoint(pushedAtlas.point, button, pushedAtlas.point)
            end
            if pushedAtlas.size then
                button.PushedTexture:SetSize(pushedAtlas.size[1], pushedAtlas.size[2])
            end
            if pushedAtlas.coords then
                button.PushedTexture:SetTexCoord(pushedAtlas.coords[1], pushedAtlas.coords[2], pushedAtlas.coords[3], pushedAtlas.coords[4])
            end
            button.PushedTexture:SetDrawLayer("OVERLAY")
            button.PushedTexture:SetScale(isStanceBar and 0.69 or 1.0)
        end

        button.PushedTexture:SetDesaturated(Addon.C.DesaturatePushed)
        if Addon.C.UsePushedColor then
            button.PushedTexture:SetVertexColor(Addon:GetRGBA("PushedColor"))
        end
    end

    --button.PushedTexture:SetDesaturated(true)
    --button.PushedTexture:SetVertexColor(r, g, b)

    local highlightAtlas = T.HighlightTextures[Addon.C.CurrentHighlightTexture] or nil
    if highlightAtlas and highlightAtlas.hide then
        button.HighlightTexture:Hide()
    else
        if highlightAtlas and Addon.C.CurrentHighlightTexture > 2 then
            if highlightAtlas.atlas then
                button.HighlightTexture:SetAtlas(highlightAtlas.atlas)
            elseif highlightAtlas.texture then
                button.HighlightTexture:SetTexture(highlightAtlas.texture)
            end
            if highlightAtlas.point then
                button.HighlightTexture:ClearAllPoints()
                button.HighlightTexture:SetPoint(highlightAtlas.point, button, highlightAtlas.point)
            end
            if highlightAtlas.size then
                button.HighlightTexture:SetSize(highlightAtlas.size[1], highlightAtlas.size[2])
            end
            if highlightAtlas.coords then
                button.HighlightTexture:SetTexCoord(highlightAtlas.coords[1], highlightAtlas.coords[2], highlightAtlas.coords[3], highlightAtlas.coords[4])
            end
            button.HighlightTexture:SetScale(isStanceBar and 0.69 or 1.0)
        end

        button.HighlightTexture:SetDesaturated(Addon.C.DesaturateHighlight)
        if Addon.C.UseHighlightColor then
            button.HighlightTexture:SetVertexColor(Addon:GetRGBA("HighlightColor"))
        end
    end

    if button.CheckedTexture then
        local checkedAtlas = T.HighlightTextures[Addon.C.CurrentCheckedTexture] or nil
        if checkedAtlas then
            if Addon.C.CurrentCheckedTexture > 2 then
                if checkedAtlas.atlas then
                    button.CheckedTexture:SetAtlas(checkedAtlas.atlas)
                elseif checkedAtlas.texture then
                    button.CheckedTexture:SetTexture(checkedAtlas.texture)
                end
                if checkedAtlas.point then
                    button.CheckedTexture:ClearAllPoints()
                    button.CheckedTexture:SetPoint(checkedAtlas.point, button, checkedAtlas.point)
                end
                if checkedAtlas.size then
                    button.CheckedTexture:SetSize(checkedAtlas.size[1], checkedAtlas.size[2])
                end
                if checkedAtlas.coords then
                    button.CheckedTexture:SetTexCoord(checkedAtlas.coords[1], checkedAtlas.coords[2], checkedAtlas.coords[3], checkedAtlas.coords[4])
                end
                button.CheckedTexture:SetScale(isStanceBar and 0.69 or 1.0)
            end

            button.CheckedTexture:SetDesaturated(Addon.C.DesaturateChecked)
            if Addon.C.UseCheckedColor then
                button.CheckedTexture:SetVertexColor(Addon:GetRGBA("CheckedColor"))
            end
        end
    end

    if button.IconMask then
        local iconMaskAtlas = T.IconMaskTextures[Addon.C.CurrentIconMaskTexture] or nil
        if iconMaskAtlas then
            if iconMaskAtlas.atlas and Addon.C.CurrentIconMaskTexture > 1 then
                button.IconMask:SetAtlas(iconMaskAtlas.atlas)
                if iconMaskAtlas.point then
                    button.IconMask:ClearAllPoints()
                    button.IconMask:SetPoint(iconMaskAtlas.point, button.icon, iconMaskAtlas.point)
                end
                if iconMaskAtlas.size then
                    button.IconMask:SetSize(iconMaskAtlas.size[1], iconMaskAtlas.size[2])
                end
                if iconMaskAtlas.coords then
                    button.IconMask:SetTexCoord(iconMaskAtlas.coords[1], iconMaskAtlas.coords[2], iconMaskAtlas.coords[3], iconMaskAtlas.coords[4])
                end
            end
            if isStanceBar then
                button.IconMask:SetScale(Addon.C.UseIconMaskScale and Addon.C.IconMaskScale * 0.69 or 1.0)
            else
                button.IconMask:SetScale(Addon.C.UseIconMaskScale and Addon.C.IconMaskScale or 1.0)
            end
        end
    end

    if button.icon then
        button.icon:ClearAllPoints()
        button.icon:SetPoint("CENTER", button, "CENTER", -0.5, 0.5)
        if isStanceBar then
            button.icon:SetSize(31,31)
        else
            button.icon:SetSize(45,45)
        end
        button.icon:SetScale(Addon.C.UseIconScale and Addon.C.IconScale or 1.0)
    end

    if not isStanceBar then
        if button.Name then
            if Addon.C.FontHideName then
                button.Name:Hide()
            else
                button.Name:Show()
            end
        end
        if button.TextOverlayContainer then
            local mult = button:GetParent():GetScale()
            if mult < 1 then
                button.TextOverlayContainer.HotKey:SetScale(Addon.C.FontHotKey and mult + Addon.C.FontHotKeyScale or 1.0)
                button.TextOverlayContainer.HotKey:SetPoint("TOPRIGHT", button.TextOverlayContainer, "TOPRIGHT", 0, 0)
                button.TextOverlayContainer.Count:SetScale(Addon.C.FontStacks and mult + Addon.C.FontStacksScale or 1.0)
                button.Name:SetScale(Addon.C.FontName and mult + Addon.C.FontNameScale or 1.0)
            end

            local hotKey = button.TextOverlayContainer.HotKey:GetText()
            if hotKey and hotKey ~= _G.RANGE_INDICATOR then
                button.TextOverlayContainer.HotKey:SetText(FixKeyBindText(hotKey))
            end
        end
        local eventFrame = ActionBarActionEventsFrame
        if Addon.C.HideInterrupt then
            eventFrame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
            eventFrame:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
        end
        if Addon.C.HideCasting then
            eventFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
            eventFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
            eventFrame:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_START")
            eventFrame:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
            eventFrame:UnregisterEvent("UNIT_SPELLCAST_START")
            eventFrame:UnregisterEvent("UNIT_SPELLCAST_STOP")
        end
        if Addon.C.HideReticle then
            eventFrame:UnregisterEvent("UNIT_SPELLCAST_FAILED")
            eventFrame:UnregisterEvent("UNIT_SPELLCAST_RETICLE_CLEAR")
            eventFrame:UnregisterEvent("UNIT_SPELLCAST_RETICLE_TARGET")
            eventFrame:UnregisterEvent("UNIT_SPELLCAST_SENT")
        end
        if Addon.C.FadeBars then
            button:HookScript("OnEnter", HoverHook)
            button:HookScript("OnLeave", HoverHook)
        end
        if button.Update then
            hooksecurefunc(button, "Update", Hook_Update)
        end
        if button.UpdateUsable then
            hooksecurefunc(button, "UpdateUsable", Hook_UpdateUsable)
        end
        if button.UpdateHotkeys then
            hooksecurefunc(button, "UpdateHotkeys", Hook_UpdateHotkeys)
        end
    end
end

local function Hook_RangeCheckButton(slot, inRange, checksRange)
    
    local buttons = ActionBarButtonRangeCheckFrame.actions[slot]
    if buttons then
        for _, button in pairs(buttons) do
            Addon:RefreshIconColor(button)
        end
    end
end
local function Hook_UpdateCooldown(self)
    local actionType, actionID
    if self.action then
        actionType, actionID = GetActionInfo(self.action)
    end

    --[[ if actionID then
        local spellCooldownInfo = C_Spell.GetSpellCooldown(actionID)
        if spellCooldownInfo then
            if spellCooldownInfo.activeCategory and spellCooldownInfo.activeCategory ~= Constants.SpellCooldownConsts.GLOBAL_RECOVERY_CATEGORY then
                self.icon:SetDesaturated(true)
            else
                self.icon:SetDesaturated(false)
            end

        end
    end ]]
    if self.cooldown and Addon.C.UseCooldownColor then
        self.cooldown:SetSwipeColor(Addon:GetRGBA("CooldownColor"))
        self.cooldown:SetSwipeTexture("Interface/HUD/UI-HUD-CoolDownManager-Icon-Swipe")
        self.cooldown:ClearAllPoints()
        self.cooldown:SetPoint("CENTER", self.icon, "CENTER")
        self.cooldown:SetSize(46,45)
    end
    
end

local function Hook_Assist(self, actionButton, shown)
    local highlightFrame = actionButton.AssistedCombatHighlightFrame
    if highlightFrame and highlightFrame:IsVisible() then
        if shown then
            Addon:UpdateAssistFlipbook(highlightFrame.Flipbook)
        end
    end
end

hooksecurefunc(ActionButtonSpellAlertManager, "ShowAlert", Hook_UpdateFlipbook)
hooksecurefunc("ActionButton_UpdateCooldown", Hook_UpdateCooldown)

hooksecurefunc(AssistedCombatManager, "SetAssistedHighlightFrameShown", Hook_Assist)

local function InitializeSavedVariables()
    ABDB = ABDB or {}

    for key, defaultValue in pairs(Addon.Defaults) do
        if ABDB[key] ~= nil then
            Addon.Options[key] = ABDB[key]
        else
            Addon.Options[key] = type(Addon.Options[key]) == "table" and CopyTable(defaultValue) or defaultValue
            ABDB[key] = Addon.Options[key]
        end
    end
end
local function ApplyProfile()
    ABDB = ABDB or {}
    ABDB.Profiles = ABDB.Profiles or {}
    Addon.P = ABDB.Profiles

    if next(ABDB) then
        local migrate, table = ActionBarsEnhancedProfilesMixin:NeedMigrateProfile()
        if migrate then
            local playerID = Addon:GetPlayerID()
            ABDB.Profiles.mapping = ABDB.Profiles.mapping or {}
            ABDB.Profiles.mapping[playerID] = "Default"
            ABDB.Profiles.profilesList = ABDB.Profiles.profilesList or {}
            ABDB.Profiles.profilesList["Default"] = CopyTable(table)
        end
    end

    local currentProfile = ActionBarsEnhancedProfilesMixin:GetPlayerProfile()

    ActionBarsEnhancedProfilesMixin:SetProfile(currentProfile)
end

local function UpdateStanceAndPetBars()
    if StanceBar then
        for i, button in pairs(StanceBar.actionButtons) do
            Hook_UpdateButton(button, true)
        end
    end
    if PetActionBar then
        for i, button in pairs(PetActionBar.actionButtons) do
            Hook_UpdateButton(button, true)
        end
    end
end
local function Hook_ShowStanceBar()
    if Addon.C.HideStanceBar then
        StanceBar:Hide()
    end
    StanceBar:HookScript("OnShow", function() 
        if Addon.C.HideStanceBar then
            if StanceBar:IsVisible() then
                StanceBar:Hide()
            end
        end
    end)
end

local function ProcessEvent(self, event, ...)
    if event == "PLAYER_LOGIN" then
        ApplyProfile()
        
        for _, barName in pairs(bars) do
            local frame = _G[barName]
            if frame then
                table.insert(animBars, barName)
            end
        end

        for _, barName in pairs(Addon.BarsToHide) do
            Addon:HideBars(barName)
        end

        Addon:BarsFadeAnim()

        Addon.ClassColor = {PlayerUtil.GetClassColor():GetRGB()}

        local f = EnumerateFrames()

		while f do
			if f.OnLoad == ActionBarActionButtonMixin.OnLoad then
				Hook_UpdateButton(f)
			end

			f = EnumerateFrames(f)
		end

        hooksecurefunc(ActionBarActionButtonMixin, "OnLoad", Hook_UpdateButton)
        hooksecurefunc(StanceBar, "Show", Hook_ShowStanceBar)
        UpdateStanceAndPetBars()

        Addon:Welcome()

        
    end
    if event == "PLAYER_ENTERING_WORLD" then
        local stateWA = C_AddOns.GetAddOnEnableState("WeakAuras", UnitName("player"))
        if stateWA > 0 then
            ABE_WAIntegrationParse()
        end
    end
    if event == "ACTION_RANGE_CHECK_UPDATE" then
        local slot, inRange, checksRange = ...
        if Addon.C.UseOORColor then
            Hook_RangeCheckButton(slot, inRange, checksRange)
        end
    end
    if event == "PLAYER_REGEN_DISABLED"
    or event == "PLAYER_REGEN_ENABLED"
    or event == "PLAYER_TARGET_CHANGED"
    or event == "UNIT_SPELLCAST_START"
    or event == "UNIT_SPELLCAST_STOP" then
        Addon:BarsFadeAnim()
    end
end

eventHandlerFrame = CreateFrame('Frame')
eventHandlerFrame:SetScript('OnEvent', ProcessEvent)
eventHandlerFrame:RegisterEvent('PLAYER_LOGIN')
eventHandlerFrame:RegisterEvent('ACTION_RANGE_CHECK_UPDATE')
eventHandlerFrame:RegisterEvent('PLAYER_REGEN_DISABLED')
eventHandlerFrame:RegisterEvent('PLAYER_REGEN_ENABLED')
eventHandlerFrame:RegisterEvent('PLAYER_TARGET_CHANGED')
eventHandlerFrame:RegisterEvent('UNIT_SPELLCAST_START')
eventHandlerFrame:RegisterEvent('UNIT_SPELLCAST_STOP')
eventHandlerFrame:RegisterEvent('PLAYER_ENTERING_WORLD')