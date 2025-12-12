local AddonName, Addon = ...

local fadeBars = {
    "MultiActionBar",
	"StanceBar",
	"PetActionBar",
	"PossessActionBar",
	"BonusBar",
	"VehicleBar",
	"TempShapeshiftBar",
	"OverrideBar",
    "MainMenuBar",
    "MainActionBar",
    "MultiBarBottomLeft",
    "MultiBarBottomRight",
    "MultiBarLeft",
    "MultiBarRight",
    "MultiBar5",
    "MultiBar6",
    "MultiBar7",
    "BagsBar",
    "MicroMenu",
}

Addon.externalFadeBars = {}
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

local function IsFrameFocused(frame)
    local focusedFrames = GetMouseFoci()
    local focusedFrame
    if focusedFrames then
        if focusedFrames[1] then
            if focusedFrames[1]:GetParent() then
                focusedFrame = focusedFrames[1]:GetParent()
                if focusedFrame == frame then
                    return true
                else
                    focusedFrame = focusedFrames[1]:GetParent():GetParent()
                end
            end
        end
    end
    return focusedFrames and focusedFrame == frame
end

local function ShouldFadeIn(frame)

    if not frame then return false end

    return (Addon:GetValue("FadeInOnCombat", nil, frame:GetName()) and UnitAffectingCombat("player"))
    or (Addon:GetValue("FadeInOnTarget", nil, frame:GetName()) and UnitExists("target"))
    or (Addon:GetValue("FadeInOnCasting", nil, frame:GetName()) and UnitCastingInfo("player"))
    or (Addon:GetValue("FadeInOnHover", nil, frame:GetName()) and IsFrameFocused(frame))
end

local function ShouldFadeInExternal(frame, options)

    if not frame or not options then return false end

    return ( options.inCombat and UnitAffectingCombat("player") )
    or ( options.onTarget and UnitExists("target") )
    or ( options.onCasting and UnitCastingInfo("player") )
    or ( options.onHover and IsFrameFocused(frame) )
end

local function HoverHookExternal(frame)
    if not frame then return end

    local frameName = frame:GetName()

    if frame.fade and frameName then
        Addon:ExternalBarsFadeAnim(frame, Addon.externalFadeBars[frameName])
        return
    else
        frame = frame:GetParent()
        frameName = frame:GetName()
        if frame.fade and frameName then
            AAddon:ExternalBarsFadeAnim(frame, Addon.externalFadeBars[frameName])
            return
        end
    end
end

function Addon:SetFrameAlpha(frame, toAlpha)
    local frameName = frame:GetName()
    toAlpha = toAlpha or Addon:GetValue("FadeBarsAlpha", nil, frameName)

    if not toAlpha and Addon.externalFadeBars[frameName] then
        toAlpha = Addon.externalFadeBars[frameName].alpha
    end

    local currentAlpha = frame:GetAlpha()
    
    if toAlpha == currentAlpha then return end

    if toAlpha > currentAlpha then
        FrameFadeIn(frame, 0.25, currentAlpha, toAlpha)
    else
        FrameFadeOut(frame, 0.25, currentAlpha, toAlpha)
    end    
end

function Addon:BarsFadeAnim(frame)
    --if not Addon:GetValue("FadeBars") then return end
    if not frame then
        for _, barName in ipairs(fadeBars) do
            frame = _G[barName]
            if frame then
                if Addon:GetValue("FadeBars", nil, barName) and ShouldFadeIn(frame) then
                    Addon:SetFrameAlpha(frame, 1)
                else
                    Addon:SetFrameAlpha(frame)
                end
            end
        end
        Addon:ExternalBarsFadeAnim()
    else
        local frameName = frame:GetName()
        if not tContains(fadeBars, frameName) then return end

        if Addon:GetValue("FadeBars", nil, frameName) and ShouldFadeIn(frame) then
            Addon:SetFrameAlpha(frame, 1)
        else
            Addon:SetFrameAlpha(frame)
        end
    end
end

function Addon:ExternalBarsFadeAnim(frame, options)
    if not frame then
        for barName, options in pairs(Addon.externalFadeBars) do
            frame = _G[barName]
            if frame and ShouldFadeInExternal(frame, options) then
                Addon:SetFrameAlpha(frame, options.alpha)
            else
                Addon:SetFrameAlpha(frame)
            end
        end
    else
        if ShouldFadeInExternal(frame, options) then
            Addon:SetFrameAlpha(frame, options.alpha)
        else
            Addon:SetFrameAlpha(frame)
        end
    end
end

--/run ABE_RegisterFrameForFading("Minimap", { alpha = 0 })

function ABE_RegisterFrameForFading(frame, options)
    if not frame then return end
    local frameName
    if type(frame) == "string" then
        frameName = frame
        frame = _G[frame]
    else
        frameName = frame:GetName()
    end

    if not frameName then return end

    options = options or {}

    if not Addon.externalFadeBars[frameName] then
        Addon.externalFadeBars[frameName] = {
            alpha = options.alpha or 1,
            inCombat = options.inCombat or false,
            onTarget = options.onTarget or false,
            onCasting = options.onCasting or false,
            onHover = options.onHover or true,
        }
    end

    if frame and Addon.externalFadeBars[frameName].onHover then
        Addon:HookExternalFrameForHover(frame)
    end
    Addon.Print("Frame "..frameName.." registered for fading")
    Addon:ExternalBarsFadeAnim(frame, Addon.externalFadeBars[frameName])
end

function Addon:HookExternalFrameForHover(frame)
    if not frame or frame.__hookedFade then return end

    if frame.OnEnter and frame.OnLeave then
        frame:HookScript("OnEnter", HoverHookExternal)
        frame:HookScript("OnLeave", HoverHookExternal)
    else
        local numChildren = frame:GetNumChildren()
        local children = {frame:GetChildren()}
        if numChildren then
            for i=1, numChildren do
                local child = children[i]
                if child and (child.OnEnter and child.OnLeave) and not child.__hookedFade then
                    child:HookScript("OnEnter", HoverHookExternal)
                    child:HookScript("OnLeave", HoverHookExternal)
                    child.__hookedFade = true
                end
            end
        end
    end
    frame.__hookedFade = true
end

