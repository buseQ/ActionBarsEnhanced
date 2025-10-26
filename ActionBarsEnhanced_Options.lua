local AddonName, Addon = ...

local L = Addon.L
local T = Addon.Templates

function Addon:GetFontsList()
    local fontList = {"Default"}
    local LSMFonts = LibStub("LibSharedMedia-3.0"):List("font")
    for _, fontName in ipairs(LSMFonts) do
        table.insert(fontList, fontName)
    end
    return fontList
end
function Addon:GetFontObject(fontName, outline, color, size, isStanceBar)
    if fontName == "Default" then
        fontName = "Fonts\\ARIALN.TTF"
    end
    outline = outline or ""
    color = color or {r = 1.0, g = 1.0, b = 1.0, a = 1.0}
    size = (size or 17) * (isStanceBar and 0.69 or 1.0)
    local fontNameKey = (isStanceBar and "ABECD_Small_" or "ABECD_") .. fontName
    if not Addon.CooldownFont[fontNameKey] then
        Addon.CooldownFont[fontNameKey] = CreateFont(fontNameKey)
    end
    local fontObject = Addon.CooldownFont[fontNameKey]

    local fontPath = LibStub("LibSharedMedia-3.0"):Fetch("font", fontName)
    fontObject:SetFont(fontPath, size, outline)
    fontObject:SetTextColor(color.r, color.g, color.b, color.a)

    return fontObject, fontNameKey
end

local function LightenHexColor(hex, factor)
    factor = factor or 1.3

    local r = tonumber(hex:sub(1, 2), 16) or 255
    local g = tonumber(hex:sub(3, 4), 16) or 255
    local b = tonumber(hex:sub(5, 6), 16) or 255

    r = math.min(255, math.floor(r * factor + 0.5))
    g = math.min(255, math.floor(g * factor + 0.5))
    b = math.min(255, math.floor(b * factor + 0.5))

    return string.format("%02X%02X%02X", r, g, b)
end
local function GetGradientTextUTF8(text, startHex, endHex)
    if not text or text == "" then return "" end

    if not startHex then
        local classColorHex
        if PlayerUtil and PlayerUtil.GetClassColor then
            classColorHex = PlayerUtil.GetClassColor():GenerateHexColorNoAlpha()
        end
        classColorHex = classColorHex or "d1d1d1"

        startHex = startHex or classColorHex
    end
    endHex = endHex or LightenHexColor(startHex)

    local len = strlenutf8(text)
    if not len or len == 0 then return "" end

    local r1 = tonumber(startHex:sub(1, 2), 16) or 255
    local g1 = tonumber(startHex:sub(3, 4), 16) or 255
    local b1 = tonumber(startHex:sub(5, 6), 16) or 255

    local r2 = tonumber(endHex:sub(1, 2), 16) or 255
    local g2 = tonumber(endHex:sub(3, 4), 16) or 255
    local b2 = tonumber(endHex:sub(5, 6), 16) or 255

    local parts = {}
    local denom = len > 1 and (len - 1) or 1

    for i = 1, len do
        local t = (i - 1) / denom
        local r = r1 + (r2 - r1) * t
        local g = g1 + (g2 - g1) * t
        local b = b1 + (b2 - b1) * t

        r = math.min(255, math.max(0, math.floor(r + 0.5)))
        g = math.min(255, math.max(0, math.floor(g + 0.5)))
        b = math.min(255, math.max(0, math.floor(b + 0.5)))

        local hex = string.format("%02X%02X%02X", r, g, b)
        local char = string.utf8sub(text, i, i)
        parts[i] = "|cff" .. hex .. char .. "|r"
    end

    return table.concat(parts)
end

Addon.Fonts = {}
Addon.FontObjects = {}
Addon.CooldownFont = {}

StaticPopupDialogs["ABE_RELOAD"] = {
    text = "You have made changes to your profile settings that require a UI Reload.",
    button1 = "Reload now",
    button2 = "Later",
    OnAccept = function()
        ReloadUI();
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
}

ActionBarEnhancedMixin = {}
ActionBarEnhancedDropdownMixin = {}
ActionBarEnhancedCheckboxMixin = {}
ActionBarColorMixin = {}
ActionBarEnhancedButtonPreviewMixin = {}
ActionBarEnhancedContainerMixin = {}
ActionBarEnhancedOptionsContentMixin = {}
ActionBarEnhancedCheckboxSliderMixin = {}

function Addon:Welcome()
    print(L.welcomeMessage1)
    print(L.welcomeMessage2..Addon.shortCommand)
end

function Addon.Print(...)
    print("|cffedc99eActionBarsEnhanced:|r",...)
end

function ActionBarEnhanced_UpdateScrollFrame(self, delta)
    local newValue = self:GetVerticalScroll() - (delta * 20);

    if (newValue < 0) then
        newValue = 0;
    elseif (newValue > self:GetVerticalScrollRange()) then
        newValue = self:GetVerticalScrollRange();
    end
    self:SetVerticalScroll(newValue);
end

function Addon:GetRGB(settingName)
    local color = Addon.C[settingName]

    if color == "CLASS_COLOR" then
        local r,g,b,a = PlayerUtil.GetClassColor():GetRGB()
        return r, g, b
    elseif type(color) == "table" then
        return color.r, color.g, color.b
    else
        return 1.0, 1.0, 1.0
    end
end
function Addon:GetRGBA(settingName)
    local color = Addon.C[settingName]

    if color == "CLASS_COLOR" then
        local r,g,b,a = PlayerUtil.GetClassColor():GetRGB()
        return r, g, b, a or 1.0
    elseif type(color) == "table" then
        return color.r, color.g, color.b, color.a
    else
        return 1.0, 1.0, 1.0, 1.0
    end
end
local toReload = {
    ["FadeBars"] = true,
    ["CurrentNormalTexture"] = true,
    ["DesaturateNormal"] = true,
    ["UseNormalTextureColor"] = true,
    ["NormalTextureColor"] = true,
    ["CurrentBackdropTexture"] = true,
    ["DesaturateBackdrop"] = true,
    ["UseBackdropColor"] = true,
    ["BackdropColor"] = true,
    ["UseIconMaskScale"] = true,
    ["IconMaskScale"] = true,
    ["CurrentIconMaskTexture"] = true,
    ["UseIconScale"] = true,
    ["IconScale"] = true,
    ["CurrentPushedTexture"] = true,
    ["DesaturatePushed"] = true,
    ["UsePushedColor"] = true,
    ["PushedColor"] = true,
    ["CurrentHighlightTexture"] = true,
    ["DesaturateHighlight"] = true,
    ["UseHighlightColor"] = true,
    ["HighlightColor"] = true,
    ["CurrentCheckedTexture"] = true,
    ["DesaturateChecked"] = true,
    ["UseCheckedColor"] = true,
    ["CheckedColor"] = true,
    ["UseCooldownColor"] = true,
    ["UseOORColor"] = true,
    ["UseOOMColor"] = true,
    ["UseNoUseColor"] = true,
    ["HideInterrupt"] = true,
    ["HideCasting"] = true,
    ["HideReticle"] = true,
    ["FontHotKey"] = true,
    ["FontStacks"] = true,
    ["FontHideName"] = true,
    ["FontName"] = true,
    ["FontNameScale"] = true,
    ["ModifyWAGlow"] = true,
    ["CurrentWAProcGlow"] = true,
    ["WAProcColor"] = true,
    ["UseWAProcColor"] = true,
    ["DesaturateWAProc"] = true,
    ["CurrentWALoopGlow"] = true,
    ["WALoopColor"] = true,
    ["UseWALoopColor"] = true,
    ["DesaturateWALoop"] = true,
    ["AddWAMask"] = true,

    ["FontHotKeyScale"] = true,
    ["CurrentHotkeyFont"] = true,
    ["CurrentHotkeyOutline"] = true,
    ["UseHotkeyFontSize"] = true,
    ["HotkeyFontSize"] = true,
    ["UseHotkeyOffset"] = true,
    ["HotkeyOffsetX"] = true,
    ["HotkeyOffsetY"] = true,
    ["UseHotkeyColor"] = true,
    ["HotkeyColor"] = true,
    ["CurrentHotkeyPoint"] = true,
    ["CurrentHotkeyRelativePoint"] = true,
    ["UseHotkeyShadow"] = true,
    ["HotkeyShadow"] = true,
    ["UseHotkeyShadowOffset"] = true,
    ["HotkeyShadowOffsetX"] = true,
    ["HotkeyShadowOffsetY"] = true,

    ["FontStacksScale"] = true,
    ["CurrentStacksFont"] = true,
    ["CurrentStacksOutline"] = true,
    ["UseStacksFontSize"] = true,
    ["StacksFontSize"] = true,
    ["UseStacksOffset"] = true,
    ["StacksOffsetX"] = true,
    ["StacksOffsetY"] = true,
    ["UseStacksColor"] = true,
    ["StacksColor"] = true,
    ["CurrentStacksPoint"] = true,
    ["CurrentStacksRelativePoint"] = true,
    ["UseStacksShadow"] = true,
    ["StacksShadow"] = true,
    ["UseStacksShadowOffset"] = true,
    ["StacksShadowOffsetX"] = true,
    ["StacksShadowOffsetY"] = true,

    ["UseSwipeSize"] = true,
    ["SwipeSize"] = true,
    ["UseEdgeSize"] = true,
    ["EdgeSize"] = true,
    ["CurrentCooldownFont"] = true,
    ["UseCooldownFontSize"] = true,
    ["CooldownFontSize"] = true,
}

function Addon:SaveSetting(key, value)
    local currentProfile = ActionBarsEnhancedProfilesMixin:GetPlayerProfile()
    Addon.C[key] = value
    ABDB.Profiles.profilesList[currentProfile][key] = value
    if toReload[key] then
        if not StaticPopup_Visible("ABE_RELOAD") then
            StaticPopup_Show("ABE_RELOAD")
        end
    end
end

function Addon:HideBars(barName)
    local bar = _G[barName]
    if bar then
        if Addon.C["Hide"..barName] then
            if barName == "StanceBar" and InCombatLockdown() then return end
            bar:Hide()
        else
            if barName == "StanceBar" and not StanceBar:ShouldShow() then return end
            bar:Show()
        end
    end
end
function ActionBarEnhancedMixin:Reset()
    if ABDB then
        wipe(ABDB)
    end
end

function ActionBarEnhancedMixin:OpenProfileFrame()
    ActionBarsEnhancedProfilesMixin:Init()
end

function ActionBarEnhancedMixin:InitOptions()

    if ActionBarEnhancedOptionsFrame then
        ActionBarEnhancedOptionsFrame:Show(not ActionBarEnhancedOptionsFrame:IsVisible())
        return
    end

    local optionsFrame = CreateFrame("Frame", "ActionBarEnhancedOptionsFrame", UIParent, "ActionBarEnhancedOptionsFrameTemplate")
    optionsFrame:SetParent(UIParent)
    optionsFrame:SetPoint("LEFT", UIParent, "LEFT", 0, 0)
    optionsFrame:SetMovable(true)
    optionsFrame:EnableMouse(true)
    optionsFrame:EnableMouseWheel(true)
    optionsFrame:RegisterForDrag("LeftButton")
    optionsFrame:SetScript("OnDragStart", function(self, button)
        self:StartMoving()
    end)
    optionsFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)
    optionsFrame:SetUserPlaced(true)
    optionsFrame.TitleContainer.TitleText:SetText("Options")
    --optionsFrame.Inset.Bg:SetAtlas("auctionhouse-background-auctions", true)
    optionsFrame.Inset.Bg:SetAtlas("auctionhouse-background-index", true)
    optionsFrame.Inset.Bg:SetHorizTile(false)
    optionsFrame.Inset.Bg:SetVertTile(false)
    optionsFrame.Inset.Bg:SetAllPoints()
    ActionBarEnhancedOptionsFramePortrait:SetTexture("interface/AddOns/ActionBarsEnhanced/assets/icon2.tga")

    optionsFrame.CloseButton:SetScript("OnClick", function()
        optionsFrame:Hide()
    end)
    

    local function RefreshProcLoop(button, value)
        local loopAnim = value and T.LoopGlow[value] or (T.LoopGlow[Addon.C.CurrentLoopGlow] or nil)
        local region = button.ProcGlow
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
    local function RefreshProcStart(button, value)
        local function GetFlipBook(...)
            local Animations = {...}

            for _, Animation in ipairs(Animations) do
                if Animation:GetObjectType() == "FlipBook" then
                    Animation:SetParentKey("FlipAnim")
                    return Animation
                end
            end
        end
        local procAnim = value and T.ProcGlow[value] or (T.ProcGlow[Addon.C.CurrentProcGlow] or nil)
        local region = button.ProcGlow
        local startProc = region.ProcStartAnim.FlipAnim or GetFlipBook(region.ProcStartAnim:GetAnimations())
            
        if startProc and region.ProcStartFlipbook:IsVisible() then
            
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
    end
    local function RefreshAltGlow(button, value)
        local altGlowAtlas = value and T.PushedTextures[value] or (T.PushedTextures[Addon.C.CurrentAssistAltType] or nil)
        local region = button.ProcGlow
        if altGlowAtlas then
            region.ProcAltGlow:SetAtlas(altGlowAtlas.atlas)
        end
        region.ProcAltGlow:SetDesaturated(Addon.C.DesaturateAssistAlt)
        if Addon.C.UseAssistAltColor then
            region.ProcAltGlow:SetVertexColor(Addon:GetRGB("AssistAltColor"))
        else
            region.ProcAltGlow:SetVertexColor(1.0, 1.0, 1.0)
        end
    end
    local function RefreshNormalTexture(button, value)
        local normalAtlas = value and T.NormalTextures[value] or (T.NormalTextures[Addon.C.CurrentNormalTexture] or nil)
        if normalAtlas then
            if normalAtlas.hide then
                button.NormalTexture:Hide()
            else
                if normalAtlas.atlas then
                    button:SetNormalAtlas(normalAtlas.atlas)
                end
                if normalAtlas.texture then
                    button.NormalTexture:SetTexture(normalAtlas.texture)
                end
                if normalAtlas.point then
                    button.NormalTexture:ClearAllPoints()
                    button.NormalTexture:SetPoint(normalAtlas.point, button, normalAtlas.point)
                else
                    button.NormalTexture:SetPoint("TOPLEFT")
                end
                if normalAtlas.padding then
                    button.NormalTexture:AdjustPointsOffset(normalAtlas.padding[1], normalAtlas.padding[2])
                else
                    button.NormalTexture:AdjustPointsOffset(0,0)
                end
                if normalAtlas.size then
                    button.NormalTexture:SetSize(normalAtlas.size[1], normalAtlas.size[2])
                end
                if normalAtlas.coords then
                    button.NormalTexture:SetTexCoord(normalAtlas.coords[1], normalAtlas.coords[2], normalAtlas.coords[3], normalAtlas.coords[4])
                end
                button.NormalTexture:SetDrawLayer("OVERLAY")
            end
        end
        button.NormalTexture:SetDesaturated(Addon.C.DesaturateNormal)
        if Addon.C.UseNormalTextureColor then
            button.NormalTexture:SetVertexColor(Addon:GetRGBA("NormalTextureColor"))
        end
    end
    local function RefreshBackdropTexture(button, value)
        button.icon:Hide()
        local backdropAtlas = value and T.BackdropTextures[value] or (T.BackdropTextures[Addon.C.CurrentBackdropTexture] or nil)
        if button.SlotBackground then
            if backdropAtlas then
                if backdropAtlas.hide then
                    button.SlotBackground:Hide()
                else
                    if backdropAtlas.atlas then
                        button.SlotBackground:SetAtlas(backdropAtlas.atlas)
                    end
                    if backdropAtlas.texture then
                        button.SlotBackground:SetTexture(backdropAtlas.texture)
                    end
                    if backdropAtlas.point then
                        button.SlotBackground:ClearAllPoints()
                        button.SlotBackground:SetPoint(backdropAtlas.point, button, backdropAtlas.point)
                    else
                        button.SlotBackground:SetPoint("TOPLEFT")
                    end
                    if backdropAtlas.padding then
                        button.SlotBackground:AdjustPointsOffset(backdropAtlas.padding[1], backdropAtlas.padding[2])
                    else
                        button.SlotBackground:AdjustPointsOffset(0,0)
                    end
                    if backdropAtlas.size then
                        button.SlotBackground:SetSize(backdropAtlas.size[1], backdropAtlas.size[2])
                    end
                    if backdropAtlas.coords then
                        button.SlotBackground:SetTexCoord(backdropAtlas.coords[1], backdropAtlas.coords[2], backdropAtlas.coords[3], backdropAtlas.coords[4])
                    end
                end
            end
            button.SlotBackground:SetDesaturated(Addon.C.DesaturateBackdrop)
            if Addon.C.UseBackdropColor then
                button.SlotBackground:SetVertexColor(Addon:GetRGBA("BackdropColor"))
            end
        end
    end
    local defaultSizes = {}
    local function RefreshPushedTexture(button, value)
        local pushedAtlas = value and T.PushedTextures[value] or (T.PushedTextures[Addon.C.CurrentPushedTexture] or nil)
        if pushedAtlas then
            if pushedAtlas.atlas then
                button:SetPushedAtlas(pushedAtlas.atlas)
            elseif pushedAtlas.texture then
                button.PushedTexture:SetTexture(pushedAtlas.texture)
            end
            if pushedAtlas.point then
                button.PushedTexture:ClearAllPoints()
                button.PushedTexture:SetPoint("CENTER", button, "CENTER")
            end
            if pushedAtlas.size then
                defaultSizes.PushedTexture = {button.PushedTexture:GetSize()}
                button.PushedTexture:SetSize(pushedAtlas.size[1], pushedAtlas.size[2])
            elseif defaultSizes.PushedTexture then
                button.PushedTexture:SetSize(defaultSizes.PushedTexture[1], defaultSizes.PushedTexture[2])
            end
        end
        button.PushedTexture:SetDesaturated(Addon.C.DesaturatePushed)
        if Addon.C.UsePushedColor then
            button.PushedTexture:SetVertexColor(Addon:GetRGBA("PushedColor"))
        end
    end
    local function RefreshHighlightTexture(button, value)
        local highlightAtlas = value and T.HighlightTextures[value] or (T.HighlightTextures[Addon.C.CurrentHighlightTexture] or nil)
        if highlightAtlas and highlightAtlas.hide then
            button.HighlightTexture:SetAtlas("")
            button.HighlightTexture:Hide()
        else
            button.HighlightTexture:Show()
            if highlightAtlas then
                if highlightAtlas.atlas then
                    button.HighlightTexture:SetAtlas(highlightAtlas.atlas)
                elseif highlightAtlas.texture then
                    button.HighlightTexture:SetTexture(highlightAtlas.texture)
                end
                if highlightAtlas.point then
                    button.HighlightTexture:ClearAllPoints()
                    button.HighlightTexture:SetPoint("CENTER", button, "CENTER", -0.5, 0.5)
                end
                if highlightAtlas.size then
                    defaultSizes.HighlightTexture = {button.HighlightTexture:GetSize()}
                    button.HighlightTexture:SetSize(highlightAtlas.size[1], highlightAtlas.size[2])
                elseif defaultSizes.HighlightTexture then
                    button.HighlightTexture:SetSize(defaultSizes.HighlightTexture[1], defaultSizes.HighlightTexture[2])
                end
            end

            button.HighlightTexture:SetDesaturated(Addon.C.DesaturateHighlight)
            if Addon.C.UseHighlightColor then
                button.HighlightTexture:SetVertexColor(Addon:GetRGBA("HighlightColor"))
            end
        end
    end
    local function RefreshCheckedTexture(button, value)
        local checkedAtlas = value and T.HighlightTextures[value] or (T.HighlightTextures[Addon.C.CurrentCheckedTexture] or nil)
        if checkedAtlas and checkedAtlas.hide then
            button.CheckedTexture:SetAtlas("")
        else
            if checkedAtlas then
                if checkedAtlas.atlas then
                    button.CheckedTexture:SetAtlas(checkedAtlas.atlas)
                elseif checkedAtlas.texture then
                    button.CheckedTexture:SetTexture(checkedAtlas.texture)
                end
                if checkedAtlas.point then
                    button.CheckedTexture:ClearAllPoints()
                    button.CheckedTexture:SetPoint("CENTER", button, "CENTER")
                end
                if checkedAtlas.size then
                    defaultSizes.CheckedTexture = {button.CheckedTexture:GetSize()}
                    button.CheckedTexture:SetSize(checkedAtlas.size[1], checkedAtlas.size[2])
                elseif defaultSizes.CheckedTexture then
                    button.CheckedTexture:SetSize(defaultSizes.CheckedTexture[1], defaultSizes.CheckedTexture[2])
                end
            end

            button.CheckedTexture:SetDesaturated(Addon.C.DesaturateChecked)
            if Addon.C.UseCheckedColor then
                button.CheckedTexture:SetVertexColor(Addon:GetRGBA("CheckedColor"))
            end
        end
    end
    local function RefreshIconMaskTexture(button, value)
        local iconMaskAtlas = value and T.IconMaskTextures[value] or (T.IconMaskTextures[Addon.C.CurrentIconMaskTexture] or nil)
        if iconMaskAtlas then
            if Addon.C.CurrentIconMaskTexture > 1 then
                button.IconMask:SetHorizTile(false)
	            button.IconMask:SetVertTile(false)
                if iconMaskAtlas.atlas then
                    button.IconMask:SetAtlas(iconMaskAtlas.atlas)
                elseif iconMaskAtlas.texture then
                    button.IconMask:SetTexture(iconMaskAtlas.texture)
                end
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
    local function RefreshHotkeyFont(button, value)
        local font = value or Addon.C.CurrentHotkeyFont
        button.TextOverlayContainer.HotKey:SetFont(
            font ~= "Default" and LibStub("LibSharedMedia-3.0"):Fetch("font", font) or "Fonts\\ARIALN.TTF",
            (Addon.C.UseHotkeyFontSize and Addon.C.HotkeyFontSize or 11),
            Addon.C.CurrentHotkeyOutline > 1 and Addon.FontOutlines[Addon.C.CurrentHotkeyOutline] or ""
        )

        button.TextOverlayContainer.HotKey:ClearAllPoints()
        local fontSize = Addon.C.UseHotkeyFontSize and Addon.C.HotkeyFontSize or 11
        button.TextOverlayContainer.HotKey:SetFontHeight(fontSize)
        button.TextOverlayContainer.HotKey:SetWidth(0)
        button.TextOverlayContainer.HotKey:SetPoint(
            Addon.AttachPoints[Addon.C.CurrentHotkeyPoint],
            button.TextOverlayContainer,
            Addon.AttachPoints[Addon.C.CurrentHotkeyRelativePoint],
            Addon.C.UseHotkeyOffset and Addon.C.HotkeyOffsetX or -5,
            Addon.C.UseHotkeyOffset and Addon.C.HotkeyOffsetY or -5
        )
        if Addon.C.UseHotkeyColor then
            button.TextOverlayContainer.HotKey:SetVertexColor(Addon:GetRGBA("HotkeyColor"))
        end
        if Addon.C.UseHotkeyShadow then
            button.TextOverlayContainer.HotKey:SetShadowColor(Addon:GetRGBA("HotkeyShadow"))
        else
            button.TextOverlayContainer.HotKey:SetShadowColor(0,0,0,0)
        end
        if Addon.C.UseHotkeyShadowOffset then
            button.TextOverlayContainer.HotKey:SetShadowOffset(Addon.C.HotkeyShadowOffsetX, Addon.C.HotkeyShadowOffsetY)
        else
            button.TextOverlayContainer.HotKey:SetShadowOffset(0,0)
        end
    end
    local function RefreshStacksFont(button, value)
        local font = value or Addon.C.CurrentStacksFont
        button.TextOverlayContainer.Count:SetFont(
            font ~= "Default" and LibStub("LibSharedMedia-3.0"):Fetch("font", font) or "Fonts\\ARIALN.TTF",
            (Addon.C.UseStacksFontSize and Addon.C.StacksFontSize or 16),
            Addon.C.CurrentStacksOutline > 1 and Addon.FontOutlines[Addon.C.CurrentStacksOutline] or ""
        )
        button.TextOverlayContainer.Count:ClearAllPoints()
        local fontSize = Addon.C.UseStacksFontSize and Addon.C.StacksFontSize or 16
        button.TextOverlayContainer.Count:SetFontHeight(fontSize)
        button.TextOverlayContainer.Count:SetPoint(
            Addon.AttachPoints[Addon.C.CurrentStacksPoint],
            button.TextOverlayContainer,
            Addon.AttachPoints[Addon.C.CurrentStacksRelativePoint],
            Addon.C.UseStacksOffset and Addon.C.StacksOffsetX or -5,
            Addon.C.UseStacksOffset and Addon.C.StacksOffsetY or 5
        )
        if Addon.C.UseStacksColor then
            button.TextOverlayContainer.Count:SetVertexColor(Addon:GetRGBA("StacksColor"))
        end
        if Addon.C.UseStacksShadow then
            button.TextOverlayContainer.Count:SetShadowColor(Addon:GetRGBA("StacksShadow"))
        else
            button.TextOverlayContainer.Count:SetShadowColor(0,0,0,0)
        end
        if Addon.C.UseStacksShadowOffset then
            button.TextOverlayContainer.Count:SetShadowOffset(Addon.C.StacksShadowOffsetX, Addon.C.StacksShadowOffsetY)
        else
            button.TextOverlayContainer.Count:SetShadowOffset(0,0)
        end
    end
    local function RefreshSwipeTexture(button, value)
        value = value or Addon.C.CurrentSwipeTexture
        local textureSet = T.SwipeTextures[value]
        if value > 1 then
            button.cooldown:SetSwipeTexture(textureSet.texture)
        end
        if Addon.C.UseSwipeSize then
            button.cooldown:ClearAllPoints()
            button.cooldown:SetPoint("CENTER", button.icon, "CENTER", 0, 0)
            button.cooldown:SetSize(Addon.C.SwipeSize, Addon.C.SwipeSize)
        end

        if Addon.C.UseCooldownColor then
            button.cooldown:SetSwipeColor(Addon:GetRGBA("CooldownColor"))
        end
    end
    local function RefreshEdgeTexture(button, value)
        value = value or Addon.C.CurrentEdgeTexture
        local textureSet = T.EdgeTextures[value]
        button.cooldownEdge:SetEdgeTexture(textureSet.texture)
        if Addon.C.UseEdgeSize then
            button.cooldownEdge:ClearAllPoints()
            button.cooldownEdge:SetPoint("CENTER", button.icon, "CENTER", 0, 0)
            button.cooldownEdge:SetSize(Addon.C.EdgeSize, Addon.C.EdgeSize)
        end

        if Addon.C.UseEdgeColor then
            button.cooldownEdge:SetEdgeColor(Addon:GetRGBA("EdgeColor"))
        end
    end
    local function RefreshCooldownFont(button, value)
        local font = value or Addon.C.CurrentCooldownFont
        local color = {r = 1.0, g = 1.0, b = 1.0, a = 1.0}
        if Addon.C.UseCooldownFontColor then
            color.r,color.g,color.b,color.a = Addon:GetRGBA("CooldownFontColor")
        end
        local _, fontName = Addon:GetFontObject(
            font,
            "OUTLINE",
            color,
            Addon.C.UseCooldownFontSize and Addon.C.CooldownFontSize or 17
        )
        button.cooldown:SetCountdownFont(fontName)
    end

    function ActionBarEnhancedDropdownMixin:RefreshPreview(button, value)

        if not button then return end

        local region = button.ProcGlow
        if region then                
            RefreshProcStart(button)

            RefreshProcLoop(button)

            RefreshAltGlow(button)
        end

        if button.NormalTexture then
            RefreshNormalTexture(button)
        end

        if button.backdropPreview then
            RefreshBackdropTexture(button)
        end

        RefreshPushedTexture(button)

        RefreshHighlightTexture(button)
        if button.CheckedTexture then
            RefreshCheckedTexture(button)
        end
        if button.IconMask then
            RefreshIconMaskTexture(button)
        end

        if button.icon then
            button.icon:ClearAllPoints()
            button.icon:SetPoint("CENTER", button, "CENTER", -0.5, 0.5)
            if isStanceBar then
                button.icon:SetSize(31,31)
                button.icon:SetScale(Addon.C.UseIconScale and Addon.C.IconScale * 0.69 or 1.0)
            else
                button.icon:SetSize(46,45)
                button.icon:SetScale(Addon.C.UseIconScale and Addon.C.IconScale or 1.0)
            end
        end

        if button.Name then
            if Addon.C.FontHideName then
                button.Name:Hide()
            else
                button.Name:Show()
            end
        end
        local textScaleMult = button:GetScale()
        if textScaleMult < 1 then
            button.Name:SetScale(Addon.C.FontName and (textScaleMult + Addon.C.FontNameScale) or 1.0)
            button.TextOverlayContainer.HotKey:SetScale(Addon.C.FontHotKey and Addon.C.FontHotKeyScale or 1.0)
            button.TextOverlayContainer.Count:SetScale(Addon.C.FontStacks and Addon.C.FontStacksScale or 1.0)
        end

        
        if button.TextOverlayContainer then
            RefreshHotkeyFont(button)

            RefreshStacksFont(button)
        end

        if button.cooldown then
            RefreshSwipeTexture(button)
            RefreshCooldownFont(button)
            if not button.cooldownEdge then
                button.cooldown:SetDrawEdge(Addon.C.EdgeAlwaysShow)
            end
        end
        if button.cooldownEdge then
            RefreshEdgeTexture(button)
        end
    end

    function ActionBarEnhancedDropdownMixin:SetupDropdown(control, setting, name, IsSelected, OnSelect, showNew, OnEnter, OnClose)
        local frame = control:GetParent()
        local menuGenerator = function(_, rootDescription)
            rootDescription:CreateTitle(name)
            local extent = 20
			local maxEntrys = 25
			local maxScrollExtent = extent * maxEntrys
			rootDescription:SetScrollMode(maxScrollExtent)
            
            for i = 1, #setting do
                local categoryName = setting[i].name or setting[i]
                local categoryID = frame.isFontOption and categoryName or i
                local radio = rootDescription:CreateRadio(categoryName, IsSelected, OnSelect, categoryID)
                if frame.isFontOption then
                    if i > 1 then
                        if not Addon.FontObjects["ABE_"..categoryName] then
                            local fontObject = CreateFont("ABE_"..categoryName)
                            local fontPath = LibStub("LibSharedMedia-3.0"):Fetch("font", categoryName)
                            fontObject:SetFont(fontPath, 11, "")
                            Addon.FontObjects["ABE_"..categoryName] = fontObject
                        end
                        radio:AddInitializer(function(button, description, menu)
                            button.fontString:SetFontObject(Addon.FontObjects["ABE_"..categoryName])
                        end)
                    end
                end
                if OnEnter then
                    radio:SetOnEnter(function(button)
                        OnEnter(categoryID)
                    end)
                end
            end
        end
        if showNew then
            frame.NewFeature:Show()
        else
            frame.NewFeature:Hide()
        end
        if OnClose then
            control.Dropdown:RegisterCallback(DropdownButtonMixin.Event.OnMenuClose, OnClose)
        end

        frame.Text:SetText(name)
        control.Dropdown:SetupMenu(menuGenerator)
        control.Dropdown:SetWidth(300)
        control.IncrementButton:Hide()
        control.DecrementButton:Hide()
    end

    function ActionBarEnhancedDropdownMixin:SetupCheckbox(checkboxFrame, name, value, callback)
        if checkboxFrame.new then
            checkboxFrame.NewFeature:Show()
        else
            checkboxFrame.NewFeature:Hide()
        end
        checkboxFrame.Text:SetText(name)
        checkboxFrame.Checkbox:SetChecked(Addon.C[value])
        checkboxFrame.Checkbox:SetScript("OnClick",
            function()
                Addon:SaveSetting(value, not Addon.C[value])
                if callback and type(callback) == "function" then
                    callback(Addon.C[value])
                end
            end
        )
    end

    function ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(slider, name, checkboxValue, sliderValue, min, max, step, sliderName, callback)
        local checkboxFrame = slider:GetParent()
        checkboxFrame.Text:SetText(name)
        local options = Settings.CreateSliderOptions(min or 0, max or 1, step or 0.1)
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Top, function(value) return sliderName.top and sliderName.top..": |cffcccccc"..RoundToSignificantDigits(value, 2) or "" end)
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value) return sliderName.right and RoundToSignificantDigits(value, 2) or "" end)
        slider:Init(Addon.C[sliderValue], options.minValue, options.maxValue, options.steps, options.formatters)
        slider:RegisterCallback("OnValueChanged",
            function(self, value)
                Addon:SaveSetting(sliderValue, value)
                if callback and type(callback) == "function" then
                    callback()
                end
            end,
            slider
        )
        slider:SetEnabled(Addon.C[checkboxValue])
        checkboxFrame.Checkbox:SetChecked(Addon.C[checkboxValue])
        checkboxFrame.Checkbox:SetScript("OnClick",
            function()
                Addon:SaveSetting(checkboxValue, not Addon.C[checkboxValue])
                if checkboxFrame.SliderWithSteppers then
                    checkboxFrame.SliderWithSteppers:SetEnabled(Addon.C[checkboxValue])
                end
                if checkboxFrame.SliderWithSteppers1 then
                    checkboxFrame.SliderWithSteppers1:SetEnabled(Addon.C[checkboxValue])
                end
                if checkboxFrame.SliderWithSteppers2 then
                    checkboxFrame.SliderWithSteppers2:SetEnabled(Addon.C[checkboxValue])
                end

            end
        )
    end

    function ActionBarEnhancedDropdownMixin:SetupColorSwatch(frame, name, value, checkboxValues, alpha)
        frame.Text:SetText(name)
        if checkboxValues then
            for k, checkValue in pairs(checkboxValues) do
                local frameName = "Checkbox"..k
                if k == 2 then
                    frame[frameName].text:SetText(L.Desaturate)
                end
                frame[frameName]:Show()
                frame[frameName]:SetChecked(Addon.C[checkValue])
                frame[frameName]:SetScript("OnClick",
                    function()
                        Addon:SaveSetting(checkValue, not Addon.C[checkValue])
                    end
                )
            end
        end

        frame.ColorSwatch.Color:SetVertexColor(Addon:GetRGBA(value))
        
        frame.ColorSwatch:SetScript("OnClick", function(button, buttonName, down)
            self:OpenColorPicker(frame, value, alpha)
        end)
    end

    function ActionBarEnhancedDropdownMixin:OpenColorPicker(frame, value, alpha)

        local info = UIDropDownMenu_CreateInfo()

        info.r, info.g, info.b, info.opacity = Addon:GetRGBA(value)

        info.hasOpacity = alpha

        if ColorPickerFrame then
            if not ColorPickerFrame.classButton then
                local button = CreateFrame("Button", nil, ColorPickerFrame, "UIPanelButtonTemplate")
                button:SetPoint("RIGHT", -20, 0)
                button:SetSize(90, 25)
                button:SetText("Class")
                button:Show()
                ColorPickerFrame.classButton = button
            end
            ColorPickerFrame.classButton:SetScript("OnClick", function()
                info.r, info.g, info.b = PlayerUtil.GetClassColor():GetRGB()
                info.a = 1.0
                ColorPickerFrame:SetupColorPickerAndShow(info)
            end)
        end

        info.swatchFunc = function ()
            local r,g,b = ColorPickerFrame:GetColorRGB()
            local a = ColorPickerFrame:GetColorAlpha()
            frame.ColorSwatch.Color:SetVertexColor(r,g,b)
            Addon:SaveSetting(value, { r=r, g=g, b=b, a=a })
        end

        info.cancelFunc = function ()
            local r,g,b,a = ColorPickerFrame:GetPreviousValues()
            frame.ColorSwatch.Color:SetVertexColor(r,g,b)

            Addon:SaveSetting(value, { r=r, g=g, b=b, a=a })
        end

        ColorPickerFrame:SetupColorPickerAndShow(info)
    end

    ---------------------------------------------
    local loopContainer = optionsFrame.ScrollFrame.ScrollChild.GlowOptionsContainer
    local procContainer = optionsFrame.ScrollFrame.ScrollChild.ProcOptionsContainer
    local normalContainer = optionsFrame.ScrollFrame.ScrollChild.NormalOptionsContainer
    local backdropContainer = optionsFrame.ScrollFrame.ScrollChild.BackdropOptionsContainer
    local iconContaiter = optionsFrame.ScrollFrame.ScrollChild.IconOptionsContainer
    local pushedContainer = optionsFrame.ScrollFrame.ScrollChild.PushedOptionsContainer
    local highlightContainer = optionsFrame.ScrollFrame.ScrollChild.HighlightOptionsContainer
    local checkedContainer = optionsFrame.ScrollFrame.ScrollChild.CheckedOptionsContainer
    local cooldownContainer = optionsFrame.ScrollFrame.ScrollChild.CooldownOptionsContaier
    local hideContainer = optionsFrame.ScrollFrame.ScrollChild.HideFramesOptionsContainer
    local fontContainer = optionsFrame.ScrollFrame.ScrollChild.FontOptionsContainer
    local fadeContainer = optionsFrame.ScrollFrame.ScrollChild.FadeOptionsContainer

    --[[ local content = optionsFrame.ScrollFrame.ScrollChild
    local containers = {
        loopContainer = content.GlowOptionsContainer
        procContainer = content.ProcOptionsContainer
        normalContainer = content.NormalOptionsContainer
        backdropContainer = content.BackdropOptionsContainer
        iconContaiter = content.IconOptionsContainer
        pushedContainer = content.PushedOptionsContainer
        highlightContainer = content.HighlightOptionsContainer
        checkedContainer = content.CheckedOptionsContainer
        cooldownContainer = content.CooldownOptionsContaier
        hideContainer = content.HideFramesOptionsContainer
        fontContainer = content.FontOptionsContainer
        fadeContainer = content.FadeOptionsContainer
    }
    local previews = {
        ProcLoopPreview = content.GlowOptionsContainer.ProcLoopPreview
        ProcStartPreview = content.ProcOptionsContainer.ProcStartPreview
        PreviewNormal = content.NormalOptionsContainer.PreviewNormal
        PreviewBackdrop = content.BackdropOptionsContainerPreviewBackdrop
        PreviewIcon = content.IconOptionsContainer.PreviewIcon
        PreviewPushed = content.PushedOptionsContainer.PreviewPushed
        PreviewHighlight = content.HighlightOptionsContainer.PreviewHighlight
        PreviewChecked = content.CheckedOptionsContainer.PreviewChecked
        PreviewSwipe = content.CooldownOptionsContaier.PreviewSwipe
        PreviewInterrupt = content.HideFramesOptionsContainer.PreviewInterrupt
        PreviewCasting = content.HideFramesOptionsContainer.PreviewCasting
        PreviewReticle = content.HideFramesOptionsContainer.PreviewReticle
        PreviewFont05 = content.FontOptionsContainer.PreviewFont05
        PreviewFont075 = content.FontOptionsContainer.PreviewFont075
        PreviewFont1 = content.FontOptionsContainer.PreviewFont1
        PreviewFont15 = content.FontOptionsContainer.PreviewFont15
        PreviewFont2 = content.FontOptionsContainer.PreviewFont2
    } ]]

    ---------------------------------------------
    -----------------GLOW OPTIONS----------------
    ---------------------------------------------
    loopContainer.Title:SetText(GetGradientTextUTF8(L.GlowTypeTitle, "ffb536", "ffd68f"))
    loopContainer.Desc:SetText(L.GlowTypeDesc)
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        loopContainer.GlowOptions.Control,
        T.LoopGlow,
        L.GlowType,
        function(id) return id == Addon.C.CurrentLoopGlow end,
        function(id)
            Addon:SaveSetting("CurrentLoopGlow", id)
        end,
        true,
        function(id)
            RefreshProcLoop(loopContainer.ProcLoopPreview, id)
        end,
        function()
            ActionBarEnhancedDropdownMixin:RefreshPreview(loopContainer.ProcLoopPreview)
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        loopContainer.CustomColorGlow,
        L.UseCustomColor,
        "LoopGlowColor",
        {"UseLoopGlowColor", "DesaturateGlow"}
    )

    ---------------------------------------------
    -----------------PROC OPTIONS----------------
    ---------------------------------------------
    procContainer.Title:SetText(GetGradientTextUTF8(L.ProcStartTitle, "ffb536", "ffd68f"))
    procContainer.Desc:SetText(L.ProcStartDesc)
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        procContainer.HideProc,
        L.HideProcAnim,
        "HideProc"
    )
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        procContainer.ProcOptions.Control,
        T.ProcGlow,
        L.StartProcType,
        function(id) return id == Addon.C.CurrentProcGlow end,
        function(id) 
            Addon:SaveSetting("CurrentProcGlow", id)
            ActionBarEnhancedDropdownMixin:RefreshPreview(procContainer.ProcStartPreview)
        end,
        false,
        function(id)
            RefreshProcStart(procContainer.ProcStartPreview, id)
        end,
        function()
            ActionBarEnhancedDropdownMixin:RefreshPreview(procContainer.ProcStartPreview)
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        procContainer.CustomColorProc,
        L.UseCustomColor,
        "ProcColor",
        {"UseProcColor", "DesaturateProc"}
    )

    ---------------------------------------------
    ----------------ASSIST OPTIONS---------------
    ---------------------------------------------
    optionsFrame.ScrollFrame.ScrollChild.AssistLoopOptionsContainer.Title:SetText(GetGradientTextUTF8(L.AssistTitle, "ffb536", "ffd68f"))
    optionsFrame.ScrollFrame.ScrollChild.AssistLoopOptionsContainer.Desc:SetText(L.AssistDesc)
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        optionsFrame.ScrollFrame.ScrollChild.AssistLoopOptionsContainer.AssistLoopType.Control,
        T.LoopGlow,
        L.AssistType,
        function(id) return id == Addon.C.CurrentAssistType end,
        function(id)
            Addon:SaveSetting("CurrentAssistType", id)
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        optionsFrame.ScrollFrame.ScrollChild.AssistLoopOptionsContainer.CustomColorAssistLoop,
        L.UseCustomColor,
        "AssistGlowColor",
        {"UseAssistGlowColor", "DesaturateAssist"}
    )
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        optionsFrame.ScrollFrame.ScrollChild.AssistLoopOptionsContainer.AssistAltGlowType.Control,
        T.PushedTextures,
        L.AssistAltType,
        function(id) return id == Addon.C.CurrentAssistAltType end,
        function(id)
            Addon:SaveSetting("CurrentAssistAltType", id)
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        optionsFrame.ScrollFrame.ScrollChild.AssistLoopOptionsContainer.CustomColorAltGlow,
        L.UseCustomColor,
        "AssistAltColor",
        {"UseAssistAltColor", "DesaturateAssistAlt"},
        true
    )

    ---------------------------------------------
    ------------WA INTEGRATION OPTIONS-----------
    ---------------------------------------------
    local WAIntegrationContainer = optionsFrame.ScrollFrame.ScrollChild.WAIntegrationContainer
    WAIntegrationContainer.Title:SetText(GetGradientTextUTF8(L.WAIntTitle, "ffb536", "ffd68f"))
    WAIntegrationContainer.Desc:SetText(L.WAIntDesc)
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        WAIntegrationContainer.ModifyWAGlow,
        L.ModifyWAGlow,
        "ModifyWAGlow"
    )
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        WAIntegrationContainer.WAProcType.Control,
        T.ProcGlow,
        L.WAProcType,
        function(id) return id == Addon.C.CurrentWAProcGlow end,
        function(id) 
            Addon:SaveSetting("CurrentWAProcGlow", id)
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        WAIntegrationContainer.WACustomColorProc,
        L.UseCustomColor,
        "WAProcColor",
        {"UseWAProcColor", "DesaturateWAProc"}
    )

    ActionBarEnhancedDropdownMixin:SetupDropdown(
        WAIntegrationContainer.WALoopType.Control,
        T.LoopGlow,
        L.WALoopType,
        function(id) return id == Addon.C.CurrentWALoopGlow end,
        function(id) 
            Addon:SaveSetting("CurrentWALoopGlow", id)
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        WAIntegrationContainer.WACustomColorLoop,
        L.UseCustomColor,
        "WALoopColor",
        {"UseWALoopColor", "DesaturateWALoop"}
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        WAIntegrationContainer.AddWAMask,
        L.AddWAMask,
        "AddWAMask"
    )

    local stateWA = C_AddOns.GetAddOnEnableState("WeakAuras", UnitName("player"))
    if stateWA < 1 then
        WAIntegrationContainer.ModifyWAGlow.Checkbox:SetEnabled(false)
        WAIntegrationContainer.ModifyWAGlow.Text:SetVertexColor(0.6,0.6,0.6,1)
    else
        WAIntegrationContainer.ModifyWAGlow.Checkbox:SetEnabled(true)
    end
    ---------------------------------------------
    -----------------FADE OPTIONS----------------
    ---------------------------------------------
    fadeContainer.Title:SetText(GetGradientTextUTF8(L.FadeTitle, "ffb536", "ffd68f"))
    fadeContainer.Desc:SetText(L.FadeDesc)

    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fadeContainer.FadeOutBars.SliderWithSteppers,
        L.FadeOutBars,
        "FadeBars",
        "FadeBarsAlpha",
        0, 1, 0.1, {top = "Fade Alpha"}
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        fadeContainer.FadeInOnCombat,
        L.FadeInOnCombat,
        "FadeInOnCombat"
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        fadeContainer.FadeInOnTarget,
        L.FadeInOnTarget,
        "FadeInOnTarget"
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        fadeContainer.FadeInOnCasting,
        L.FadeInOnCasting,
        "FadeInOnCasting"
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        fadeContainer.FadeInOnHover,
        L.FadeInOnHover,
        "FadeInOnHover"
    )

    ---------------------------------------------
    ------------NORMAL TEXTURE OPTIONS-----------
    ---------------------------------------------
    normalContainer.Title:SetText(GetGradientTextUTF8(L.NormalTitle, "ffb536", "ffd68f"))
    normalContainer.Desc:SetText(L.NormalDesc)
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        normalContainer.NormalTextureOptions.Control,
        T.NormalTextures,
        L.NormalTextureType,
        function(id) return id == Addon.C.CurrentNormalTexture end,
        function(id)
            Addon:SaveSetting("CurrentNormalTexture", id)
        end,
        false,
        function(id)
            RefreshNormalTexture(normalContainer.PreviewNormal, id)
        end,
        function()
            ActionBarEnhancedDropdownMixin:RefreshAllPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        normalContainer.CustomColorNormal,
        L.UseCustomColor,
        "NormalTextureColor",
        {"UseNormalTextureColor", "DesaturateNormal"},
        true
    )

    ---------------------------------------------
    -----------BACKDROP TEXTURE OPTIONS----------
    ---------------------------------------------
    backdropContainer.Title:SetText(GetGradientTextUTF8(L.BackdropTitle, "ffb536", "ffd68f"))
    backdropContainer.Desc:SetText(L.BackdropDesc)
    backdropContainer.PreviewBackdrop.backdropPreview = true
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        backdropContainer.BackdropTextureOptions.Control,
        T.BackdropTextures,
        L.BackdropTextureType,
        function(id) return id == Addon.C.CurrentBackdropTexture end,
        function(id)
            Addon:SaveSetting("CurrentBackdropTexture", id)
        end,
        false,
        function(id)
            RefreshBackdropTexture(backdropContainer.PreviewBackdrop, id)
        end,
        function()
            ActionBarEnhancedDropdownMixin:RefreshAllPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        backdropContainer.CustomColorBackdrop,
        L.UseCustomColor,
        "BackdropColor",
        {"UseBackdropColor", "DesaturateBackdrop"},
        true
    )

    ---------------------------------------------
    -----------------ICON OPTIONS----------------
    ---------------------------------------------
    iconContaiter.Title:SetText(GetGradientTextUTF8(L.IconTitle, "ffb536", "ffd68f"))
    iconContaiter.Desc:SetText(L.IconDesc)
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        iconContaiter.IconMaskTextureOptions.Control,
        T.IconMaskTextures,
        L.IconMaskTextureType,
        function(id) return id == Addon.C.CurrentIconMaskTexture end,
        function(id)
            Addon:SaveSetting("CurrentIconMaskTexture", id)
        end,
        false,
        function(id)
            RefreshIconMaskTexture(iconContaiter.PreviewIcon, id)
        end,
        function()
            ActionBarEnhancedDropdownMixin:RefreshAllPreview()
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        iconContaiter.MaskScale.SliderWithSteppers,
        L.IconMaskScale,
        "UseIconMaskScale",
        "IconMaskScale",
        0.5, 1.5, 0.01, {top="Mask Scale"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshPreview(iconContaiter.PreviewIcon)
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        iconContaiter.IconScale.SliderWithSteppers,
        L.IconScale,
        "UseIconScale",
        "IconScale",
        0.5, 1.5, 0.01, {top="Icon Scale"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshPreview(iconContaiter.PreviewIcon)
        end
    )

    ---------------------------------------------
    ------------PUSHED TEXTURE OPTIONS-----------
    ---------------------------------------------
    pushedContainer.Title:SetText(GetGradientTextUTF8(L.PushedTitle, "ffb536", "ffd68f"))
    pushedContainer.Desc:SetText(L.PushedDesc)
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        pushedContainer.PushedTextureOptions.Control,
        T.PushedTextures,
        L.PushedTextureType,
        function(id) return id == Addon.C.CurrentPushedTexture end,
        function(id)
            Addon:SaveSetting("CurrentPushedTexture", id)
        end,
        false,
        function(id)
            pushedContainer.PreviewPushed.NormalTexture:Hide()
            RefreshPushedTexture(pushedContainer.PreviewPushed, id)
            pushedContainer.PreviewPushed.PushedTexture:Show()
        end,
        function()
            pushedContainer.PreviewPushed.PushedTexture:Hide()
            pushedContainer.PreviewPushed.NormalTexture:Show()
            ActionBarEnhancedDropdownMixin:RefreshAllPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        pushedContainer.CustomColorPushed,
        L.UseCustomColor,
        "PushedColor",
        {"UsePushedColor", "DesaturatePushed"}
    )
    ---------------------------------------------
    ----------HIGHLIGHT TEXTURE OPTIONS----------
    ---------------------------------------------
    highlightContainer.Title:SetText(GetGradientTextUTF8(L.HighlightTitle, "ffb536", "ffd68f"))
    highlightContainer.Desc:SetText(L.HighlightDesc)
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        highlightContainer.HighlightTextureOptions.Control,
        T.HighlightTextures,
        L.HighliteTextureType,
        function(id) return id == Addon.C.CurrentHighlightTexture end,
        function(id)
            Addon:SaveSetting("CurrentHighlightTexture", id)
        end,
        false,
        function(id)
            RefreshHighlightTexture(highlightContainer.PreviewHighlight, id)
            highlightContainer.PreviewHighlight:LockHighlight()
        end,
        function()
            highlightContainer.PreviewHighlight:UnlockHighlight()
            ActionBarEnhancedDropdownMixin:RefreshAllPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        highlightContainer.CustomColorHighlight,
        L.UseCustomColor,
        "HighlightColor",
        {"UseHighlightColor", "DesaturateHighlight"},
        true
    )
    ---------------------------------------------
    -----------CHECKED TEXTURE OPTIONS-----------
    ---------------------------------------------
    checkedContainer.Title:SetText(GetGradientTextUTF8(L.CheckedTitle, "ffb536", "ffd68f"))
    checkedContainer.Desc:SetText(L.CheckedDesc)
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        checkedContainer.CheckedTextureOptions.Control,
        T.HighlightTextures,
        L.CheckedTextureType,
        function(id) return id == Addon.C.CurrentCheckedTexture end,
        function(id)
            Addon:SaveSetting("CurrentCheckedTexture", id)
        end,
        false,
        function(id)
            RefreshCheckedTexture(checkedContainer.PreviewChecked, id)
            checkedContainer.PreviewChecked.CheckedTexture:Show()
        end,
        function()
            checkedContainer.PreviewChecked.CheckedTexture:Hide()
            ActionBarEnhancedDropdownMixin:RefreshAllPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        checkedContainer.CustomColorChecked,
        L.UseCustomColor,
        "CheckedColor",
        {"UseCheckedColor","DesaturateChecked"},
        true
    )
    ---------------------------------------------
    ------------COOLDOWN SWIPE OPTIONS-----------
    ---------------------------------------------
    cooldownContainer.NewFeature:Show()
    cooldownContainer.Title:SetText(GetGradientTextUTF8(L.CooldownTitle, "84faea", "d8e4ed"))
    cooldownContainer.Desc:SetText(L.CooldownDesc)
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        cooldownContainer.SwipeTexture.Control,
        T.SwipeTextures,
        L.SwipeTextureType,
        function(id) return id == Addon.C.CurrentSwipeTexture end,
        function(id)
            Addon:SaveSetting("CurrentSwipeTexture", id)
        end,
        false,
        function(id)
            RefreshSwipeTexture(cooldownContainer.PreviewSwipe, id)
        end,
        function()
            ActionBarEnhancedDropdownMixin:RefreshCooldownPreview()
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        cooldownContainer.SwipeSize.SliderWithSteppers,
        L.SwipeSize,
        "UseSwipeSize",
        "SwipeSize",
        10, 50, 1, {top="Size"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshCooldownPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        cooldownContainer.SwipeColor,
        L.CustomSwipeColor,
        "CooldownColor",
        {"UseCooldownColor"},
        true
    )

    ActionBarEnhancedDropdownMixin:SetupDropdown(
        cooldownContainer.EdgeTexture.Control,
        T.EdgeTextures,
        L.EdgeTextureType,
        function(id) return id == Addon.C.CurrentEdgeTexture end,
        function(id)
            Addon:SaveSetting("CurrentEdgeTexture", id)
        end,
        false,
        function(id)
            RefreshEdgeTexture(cooldownContainer.PreviewEdge, id)
        end,
        function()
            ActionBarEnhancedDropdownMixin:RefreshCooldownPreview()
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        cooldownContainer.EdgeSize.SliderWithSteppers,
        L.EdgeSize,
        "UseEdgeSize",
        "EdgeSize",
        10, 50, 1, {top="Size"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshCooldownPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        cooldownContainer.EdgeColor,
        L.CustomEdgeColor,
        "EdgeColor",
        {"UseEdgeColor"},
        true
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        cooldownContainer.EdgeAlwaysShow,
        L.EdgeAlwaysShow,
        "EdgeAlwaysShow",
        function()
            ActionBarEnhancedDropdownMixin:RefreshCooldownPreview()
        end
    )

    cooldownContainer.CooldownFont.isFontOption = true
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        cooldownContainer.CooldownFont.Control,
        Addon.Fonts,
        L.CooldownFont,
        function(id) return id == Addon.C.CurrentCooldownFont end,
        function(id)
            Addon:SaveSetting("CurrentCooldownFont", id)
        end,
        false,
        function(id)
            RefreshCooldownFont(cooldownContainer.PreviewCooldownFont, id)
        end,
        function()
            ActionBarEnhancedDropdownMixin:RefreshCooldownPreview()
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        cooldownContainer.CooldownFontSize.SliderWithSteppers,
        L.CooldownFontSize,
        "UseCooldownFontSize",
        "CooldownFontSize",
        5, 40, 1, {top="Font Size"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshCooldownPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        cooldownContainer.CooldownFontColor,
        L.CooldownFontColor,
        "CooldownFontColor",
        {"UseCooldownFontColor"},
        true
    )

    ---------------------------------------------
    ------------COLOR OVERRIDE OPTIONS-----------
    ---------------------------------------------
    optionsFrame.ScrollFrame.ScrollChild.ColorOverrideOptionsContainer.Title:SetText(GetGradientTextUTF8(L.ColorOverrideTitle, "ffb536", "ffd68f"))
    optionsFrame.ScrollFrame.ScrollChild.ColorOverrideOptionsContainer.Desc:SetText(L.ColorOverrideDesc)

    ---------------------------------------------
    -------------SPELL USABLE OPTIONS------------
    ---------------------------------------------
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        optionsFrame.ScrollFrame.ScrollChild.ColorOverrideOptionsContainer.CustomColorOOR,
        L.CustomColorOOR,
        "OORColor",
        {"UseOORColor", "OORDesaturate"}
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        optionsFrame.ScrollFrame.ScrollChild.ColorOverrideOptionsContainer.CustomColorOOM,
        L.CustomColorOOM,
        "OOMColor",
        {"UseOOMColor", "OOMDesaturate"}
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        optionsFrame.ScrollFrame.ScrollChild.ColorOverrideOptionsContainer.CustomColorNotUsable,
        L.CustomColorNoUse,
        "NoUseColor",
        {"UseNoUseColor", "NoUseDesaturate"}
    )

    ---------------------------------------------
    --------------HIDE FRAMES OPTIONS------------
    ---------------------------------------------
    hideContainer.Title:SetText(GetGradientTextUTF8(L.HideFrameTitle, "ffb536", "ffd68f"))
    hideContainer.Desc:SetText(L.HideFrameDesc)
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        hideContainer.HideBagBars,
        L.HideBagsBar,
        "HideBagsBar",
        function() Addon:HideBars("BagsBar") end
        
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        hideContainer.HideMicroMenu,
        L.HideMicroMenuBar,
        "HideMicroMenu",
        function() Addon:HideBars("MicroMenu") end
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        hideContainer.HideStanceBar,
        L.HideStanceBar,
        "HideStanceBar",
        function() Addon:HideBars("StanceBar") end
    )
    hideContainer.HideTalkingHead.new = true
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        hideContainer.HideTalkingHead,
        L.HideTalkingHead,
        "HideTalkingHead",
        function(checked) 
            if checked then
                Addon.eventHandlerFrame:RegisterEvent("TALKINGHEAD_REQUESTED")
            else
                Addon.eventHandlerFrame:UnregisterEvent("TALKINGHEAD_REQUESTED")
            end
        end
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        hideContainer.HideInterrupt,
        L.HideInterrupt,
        "HideInterrupt"
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        hideContainer.HideCasting,
        L.HideCasting,
        "HideCasting"
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        hideContainer.HideReticle,
        L.HideReticle,
        "HideReticle"
    )

    ---------------------------------------------
    -----------------FONT OPTIONS----------------
    ---------------------------------------------
    fontContainer.NewFeature:Show()
    fontContainer.Title:SetText(GetGradientTextUTF8(L.FontTitle, "84faea", "d8e4ed"))
    fontContainer.Desc:SetText(L.FontDesc)
    fontContainer.HotkeyPoint.Control1.Dropdown.Background:SetParent(fontContainer.HotkeyPoint.Control1)
    fontContainer.HotkeyPoint.Control1.Dropdown.Background:SetAllPoints()
    fontContainer.HotkeyPoint.Control1.Dropdown:SetAllPoints()
    fontContainer.HotkeyPoint.Control2.Dropdown.Background:SetParent(fontContainer.HotkeyPoint.Control2)
    fontContainer.HotkeyPoint.Control2.Dropdown.Background:SetAllPoints()
    fontContainer.HotkeyPoint.Control2.Dropdown:SetAllPoints()

    fontContainer.StacksPoint.Control1.Dropdown.Background:SetParent(fontContainer.StacksPoint.Control1)
    fontContainer.StacksPoint.Control1.Dropdown.Background:SetAllPoints()
    fontContainer.StacksPoint.Control1.Dropdown:SetAllPoints()
    fontContainer.StacksPoint.Control2.Dropdown.Background:SetParent(fontContainer.StacksPoint.Control2)
    fontContainer.StacksPoint.Control2.Dropdown.Background:SetAllPoints()
    fontContainer.StacksPoint.Control2.Dropdown:SetAllPoints()
    fontContainer.HotkeyFont.isFontOption = true
    fontContainer.StacksFont.isFontOption = true

    ActionBarEnhancedDropdownMixin:SetupDropdown(
        fontContainer.HotkeyFont.Control,
        Addon.Fonts,
        L.HotKeyFont,
        function(id) return id == Addon.C.CurrentHotkeyFont end,
        function(id)
            Addon:SaveSetting("CurrentHotkeyFont", id)
        end,
        false,
        function(id)
            RefreshHotkeyFont(fontContainer.PreviewFont05, id)
            RefreshHotkeyFont(fontContainer.PreviewFont075, id)
            RefreshHotkeyFont(fontContainer.PreviewFont1, id)
            RefreshHotkeyFont(fontContainer.PreviewFont15, id)
            RefreshHotkeyFont(fontContainer.PreviewFont2, id)
        end,
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        fontContainer.HotkeyOutline.Control,
        Addon.FontOutlines,
        L.HotkeyOutline,
        function(id) return id == Addon.C.CurrentHotkeyOutline end,
        function(id)
            Addon:SaveSetting("CurrentHotkeyOutline", id)
        end,
        false,
        function(id)
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end,
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        fontContainer.HotkeyShadow,
        GetGradientTextUTF8(L.HotkeyShadowColor, "ebba05", "bf7900"),
        "HotkeyShadow",
        {"UseHotkeyShadow"},
        true
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fontContainer.HotkeyShadowOffset.SliderWithSteppers1,
        GetGradientTextUTF8(L.HotkeyShadowOffset, "ebba05", "bf7900"),
        "UseHotkeyShadowOffset",
        "HotkeyShadowOffsetX",
        -6, 6, 1, {top="offset X"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fontContainer.HotkeyShadowOffset.SliderWithSteppers2,
        GetGradientTextUTF8(L.HotkeyShadowOffset, "ebba05", "bf7900"),
        "UseHotkeyShadowOffset",
        "HotkeyShadowOffsetY",
        -6, 6, 1, {top="offset Y"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )

    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fontContainer.HotkeySize.SliderWithSteppers,
        L.FontHotkeySize,
        "UseHotkeyFontSize",
        "HotkeyFontSize",
        1, 40, 1, {top="Font Size"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        fontContainer.HotkeyPoint.Control1,
        Addon.AttachPoints,
        L.HotkeyAttachPoint,
        function(id) return id == Addon.C.CurrentHotkeyPoint end,
        function(id)
            Addon:SaveSetting("CurrentHotkeyPoint", id)
        end,
        false,
        function(id)
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end,
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        fontContainer.HotkeyPoint.Control2,
        Addon.AttachPoints,
        L.HotkeyAttachPoint,
        function(id) return id == Addon.C.CurrentHotkeyRelativePoint end,
        function(id)
            Addon:SaveSetting("CurrentHotkeyRelativePoint", id)
        end,
        false,
        function(id)
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end,
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fontContainer.HotkeyOffset.SliderWithSteppers1,
        L.HotkeyOffset,
        "UseHotkeyOffset",
        "HotkeyOffsetX",
        -40, 40, 1, {top="offset X"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fontContainer.HotkeyOffset.SliderWithSteppers2,
        L.HotkeyOffset,
        "UseHotkeyOffset",
        "HotkeyOffsetY",
        -40, 40, 1, {top="offset Y"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        fontContainer.HotkeyColor,
        L.HotkeyCustomColor,
        "HotkeyColor",
        {"UseHotkeyColor"},
        true
    )


    ActionBarEnhancedDropdownMixin:SetupDropdown(
        fontContainer.StacksFont.Control,
        Addon.Fonts,
        L.StacksFont,
        function(id) return id == Addon.C.CurrentStacksFont end,
        function(id)
            Addon:SaveSetting("CurrentStacksFont", id)
        end,
        false,
        function(id)
            RefreshStacksFont(fontContainer.PreviewFont05, id)
            RefreshStacksFont(fontContainer.PreviewFont075, id)
            RefreshStacksFont(fontContainer.PreviewFont1, id)
            RefreshStacksFont(fontContainer.PreviewFont15, id)
            RefreshStacksFont(fontContainer.PreviewFont2, id)
        end,
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        fontContainer.StacksOutline.Control,
        Addon.FontOutlines,
        L.StacksOutline,
        function(id) return id == Addon.C.CurrentStacksOutline end,
        function(id)
            Addon:SaveSetting("CurrentStacksOutline", id)
        end,
        false,
        function(id)
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end,
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        fontContainer.StacksShadow,
        GetGradientTextUTF8(L.StacksShadowColor, "ebba05", "bf7900"),
        "StacksShadow",
        {"UseStacksShadow"},
        true
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fontContainer.StacksShadowOffset.SliderWithSteppers1,
        GetGradientTextUTF8(L.StacksShadowOffset, "ebba05", "bf7900"),
        "UseStacksShadowOffset",
        "StacksShadowOffsetX",
        -6, 6, 1, {top="offset X"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fontContainer.StacksShadowOffset.SliderWithSteppers2,
        GetGradientTextUTF8(L.StacksShadowOffset, "ebba05", "bf7900"),
        "UseStacksShadowOffset",
        "StacksShadowOffsetY",
        -6, 6, 1, {top="offset Y"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )

    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fontContainer.StacksSize.SliderWithSteppers,
        L.FontStacksSize,
        "UseStacksFontSize",
        "StacksFontSize",
        1, 40, 1, {top="Font Size"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        fontContainer.StacksPoint.Control1,
        Addon.AttachPoints,
        L.StacksAttachPoint,
        function(id) return id == Addon.C.CurrentStacksPoint end,
        function(id)
            Addon:SaveSetting("CurrentStacksPoint", id)
        end,
        false,
        function(id)
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end,
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        fontContainer.StacksPoint.Control2,
        Addon.AttachPoints,
        L.StacksAttachPoint,
        function(id) return id == Addon.C.CurrentStacksRelativePoint end,
        function(id)
            Addon:SaveSetting("CurrentStacksRelativePoint", id)
        end,
        false,
        function(id)
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end,
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fontContainer.StacksOffset.SliderWithSteppers1,
        L.StacksOffset,
        "UseStacksOffset",
        "StacksOffsetX",
        -40, 40, 1, {top="offset X"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fontContainer.StacksOffset.SliderWithSteppers2,
        L.StacksOffset,
        "UseStacksOffset",
        "StacksOffsetY",
        -40, 40, 1, {top="offset Y"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        fontContainer.StacksColor,
        L.StacksCustomColor,
        "StacksColor",
        {"UseStacksColor"},
        true
    )

    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fontContainer.HotkeyScale.SliderWithSteppers,
        L.FontHotKeyScale,
        "FontHotKey",
        "FontHotKeyScale",
        1, 2, 0.1, {top="Font Scale"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fontContainer.StacksScale.SliderWithSteppers,
        L.FontStacksScale,
        "FontStacks",
        "FontStacksScale",
        1, 2, 0.1, {top="Font Scale"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end        
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        fontContainer.NameHide,
        L.FontHideName,
        "FontHideName",
        function() 
            fontContainer.NameScale.Checkbox:SetEnabled(not Addon.C.FontHideName)
            fontContainer.NameScale.SliderWithSteppers:SetEnabled(not Addon.C.FontHideName)
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fontContainer.NameScale.SliderWithSteppers,
        L.FontNameScale,
        "FontName",
        "FontNameScale",
        1, 2, 0.1, {top="Font Scale"},
        function()
            ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        end
    )
    fontContainer.NameScale.Checkbox:SetEnabled(not Addon.C.FontHideName)
    fontContainer.NameScale.SliderWithSteppers:SetEnabled(not Addon.C.FontHideName)

    function ActionBarEnhancedDropdownMixin:InitPreview()
        local function GetRandomClassSpellIcon()
            local rotationSpells = C_AssistedCombat.GetRotationSpells()
            local spellID = 1160
            if #rotationSpells > 0 then
                local rnd = math.random(1, #rotationSpells)
                spellID = rotationSpells[rnd]
                spellID = C_Spell.GetOverrideSpell(spellID)
            end
            local spellInfo = C_Spell.GetSpellInfo(spellID)

            return spellInfo.iconID 
        end

        --preview for proc loop
        loopContainer.ProcLoopPreview.icon:SetTexture(GetRandomClassSpellIcon())
        loopContainer.ProcLoopPreview.ProcGlow.ProcStartFlipbook:Hide()
        loopContainer.ProcLoopPreview.ProcGlow.ProcAltGlow:Hide()
        loopContainer.ProcLoopPreview.ProcGlow.ProcLoop:Play()

        --preview for proc start
        procContainer.ProcStartPreview.icon:SetTexture(GetRandomClassSpellIcon())
        procContainer.ProcStartPreview.ProcGlow.ProcLoopFlipbook:Hide()
        procContainer.ProcStartPreview.ProcGlow.ProcAltGlow:Hide()
        procContainer.ProcStartPreview.ProcGlow.ProcStartAnim:Play()

        --preview for normal texture
        normalContainer.PreviewNormal.icon:SetTexture(GetRandomClassSpellIcon())

        --preview for backdrop
        backdropContainer.PreviewBackdrop.icon:SetTexture(GetRandomClassSpellIcon())

        --preview for iconmask
        iconContaiter.PreviewIcon.icon:SetTexture(GetRandomClassSpellIcon())

        --preview for pushed texture
        pushedContainer.PreviewPushed.icon:SetTexture(GetRandomClassSpellIcon())

        --preview for highlight texture
        highlightContainer.PreviewHighlight.icon:SetTexture(GetRandomClassSpellIcon())

        --preview for checked texture
        checkedContainer.PreviewChecked.icon:SetTexture(GetRandomClassSpellIcon())
        
        --preview for cooldown swipe
        cooldownContainer.PreviewSwipe.icon:SetTexture(GetRandomClassSpellIcon())
        CooldownFrame_Set(cooldownContainer.PreviewSwipe.cooldown, GetTime(), math.random(10,120), true, false, 1)
        cooldownContainer.PreviewSwipe.cooldown:SetScript("OnCooldownDone", function()
            CooldownFrame_Set(cooldownContainer.PreviewSwipe.cooldown, GetTime(), math.random(10,120), true, false, 1)
        end)

        --preview for cooldown edge
        cooldownContainer.PreviewEdge.icon:SetTexture(GetRandomClassSpellIcon())
        cooldownContainer.PreviewEdge.cooldownEdge = cooldownContainer.PreviewEdge.cooldown
        cooldownContainer.PreviewEdge.cooldownEdge:SetHideCountdownNumbers(true)
        cooldownContainer.PreviewEdge.cooldownEdge:SetDrawSwipe(false)
        CooldownFrame_Set(cooldownContainer.PreviewEdge.cooldownEdge, GetTime(), math.random(2,15), true, true, 1)
        cooldownContainer.PreviewEdge.cooldownEdge:SetScript("OnCooldownDone", function()
            CooldownFrame_Set(cooldownContainer.PreviewEdge.cooldownEdge, GetTime(), math.random(2,15), true, true, 1)
        end)

        --preview for cooldown font
        cooldownContainer.PreviewCooldownFont.icon:SetTexture(GetRandomClassSpellIcon())
        CooldownFrame_Set(cooldownContainer.PreviewCooldownFont.cooldown, GetTime(), math.random(10,120), true, false, 1)
        cooldownContainer.PreviewCooldownFont.cooldown:SetScript("OnCooldownDone", function()
            CooldownFrame_Set(cooldownContainer.PreviewCooldownFont.cooldown, GetTime(), math.random(10,120), true, false, 1)
        end)

        --preview for hide animations
        hideContainer.PreviewInterrupt.icon:SetTexture(GetRandomClassSpellIcon())
        hideContainer.PreviewInterrupt.InterruptDisplay:Show()
        hideContainer.PreviewInterrupt.InterruptDisplay.Base.AnimIn:SetLooping("REPEAT")
        hideContainer.PreviewInterrupt.InterruptDisplay.Highlight.AnimIn:SetLooping("REPEAT")
        hideContainer.PreviewInterrupt.InterruptDisplay.Base.AnimIn:Play()
        hideContainer.PreviewInterrupt.InterruptDisplay.Highlight.AnimIn:Play()
        hideContainer.PreviewInterrupt.Title.TitleText:SetText("Interrupt")

        hideContainer.PreviewCasting.icon:SetTexture(GetRandomClassSpellIcon())
        hideContainer.PreviewCasting.SpellCastAnimFrame:Show()
        hideContainer.PreviewCasting.SpellCastAnimFrame.Fill.CastingAnim:SetLooping("REPEAT")
        hideContainer.PreviewCasting.SpellCastAnimFrame.EndBurst.FinishCastAnim:SetLooping("REPEAT")
        hideContainer.PreviewCasting.SpellCastAnimFrame.Fill.CastingAnim:Play()
        hideContainer.PreviewCasting.SpellCastAnimFrame.EndBurst.FinishCastAnim:Play()
        hideContainer.PreviewCasting.Title.TitleText:SetText("Casting")

        hideContainer.PreviewReticle.icon:SetTexture(GetRandomClassSpellIcon())
        hideContainer.PreviewReticle.TargetReticleAnimFrame:Show()
        hideContainer.PreviewReticle.TargetReticleAnimFrame.HighlightAnim:SetLooping("REPEAT")
        hideContainer.PreviewReticle.TargetReticleAnimFrame.HighlightAnim:Play()
        hideContainer.PreviewReticle.Title.TitleText:SetText("Reticle")

        ---preview for font options
        fontContainer.PreviewFont05.icon:SetTexture(GetRandomClassSpellIcon())
        fontContainer.PreviewFont075.icon:SetTexture(GetRandomClassSpellIcon())
        fontContainer.PreviewFont1.icon:SetTexture(GetRandomClassSpellIcon())
        fontContainer.PreviewFont15.icon:SetTexture(GetRandomClassSpellIcon())
        fontContainer.PreviewFont2.icon:SetTexture(GetRandomClassSpellIcon())

        fontContainer.PreviewFont05.TextOverlayContainer.HotKey:SetText("1")
        fontContainer.PreviewFont075.TextOverlayContainer.HotKey:SetText("2")
        fontContainer.PreviewFont1.TextOverlayContainer.HotKey:SetText("3")
        fontContainer.PreviewFont15.TextOverlayContainer.HotKey:SetText("sR")
        fontContainer.PreviewFont2.TextOverlayContainer.HotKey:SetText("sM4")

        fontContainer.PreviewFont05.TextOverlayContainer.Count:SetText("99")
        fontContainer.PreviewFont075.TextOverlayContainer.Count:SetText("99")
        fontContainer.PreviewFont1.TextOverlayContainer.Count:SetText("99")
        fontContainer.PreviewFont15.TextOverlayContainer.Count:SetText("99")
        fontContainer.PreviewFont2.TextOverlayContainer.Count:SetText("99")

        fontContainer.PreviewFont05.Name:SetText("Name")
        fontContainer.PreviewFont075.Name:SetText("Name")
        fontContainer.PreviewFont1.Name:SetText("Name")
        fontContainer.PreviewFont15.Name:SetText("Name")
        fontContainer.PreviewFont2.Name:SetText("Name")

        ActionBarEnhancedDropdownMixin:RefreshAllPreview()
    end

    function ActionBarEnhancedDropdownMixin:RefreshFontPreview()
        ActionBarEnhancedDropdownMixin:RefreshPreview(fontContainer.PreviewFont05)
        ActionBarEnhancedDropdownMixin:RefreshPreview(fontContainer.PreviewFont075)
        ActionBarEnhancedDropdownMixin:RefreshPreview(fontContainer.PreviewFont1)
        ActionBarEnhancedDropdownMixin:RefreshPreview(fontContainer.PreviewFont15)
        ActionBarEnhancedDropdownMixin:RefreshPreview(fontContainer.PreviewFont2)
    end
    function ActionBarEnhancedDropdownMixin:RefreshCooldownPreview()
        ActionBarEnhancedDropdownMixin:RefreshPreview(cooldownContainer.PreviewSwipe)
        ActionBarEnhancedDropdownMixin:RefreshPreview(cooldownContainer.PreviewEdge)
        ActionBarEnhancedDropdownMixin:RefreshPreview(cooldownContainer.PreviewCooldownFont)
    end

    function ActionBarEnhancedDropdownMixin:RefreshAllPreview()
        ActionBarEnhancedDropdownMixin:RefreshPreview(loopContainer.ProcLoopPreview)
        ActionBarEnhancedDropdownMixin:RefreshPreview(procContainer.ProcStartPreview)
        ActionBarEnhancedDropdownMixin:RefreshPreview(normalContainer.PreviewNormal)
        ActionBarEnhancedDropdownMixin:RefreshPreview(backdropContainer.PreviewBackdrop)
        ActionBarEnhancedDropdownMixin:RefreshPreview(iconContaiter.PreviewIcon)
        ActionBarEnhancedDropdownMixin:RefreshPreview(pushedContainer.PreviewPushed)
        ActionBarEnhancedDropdownMixin:RefreshPreview(highlightContainer.PreviewHighlight)
        ActionBarEnhancedDropdownMixin:RefreshPreview(checkedContainer.PreviewChecked)
        ActionBarEnhancedDropdownMixin:RefreshPreview(cooldownContainer.PreviewSwipe)
        ActionBarEnhancedDropdownMixin:RefreshPreview(cooldownContainer.PreviewEdge)
        ActionBarEnhancedDropdownMixin:RefreshPreview(cooldownContainer.PreviewCooldownFont)
        ActionBarEnhancedDropdownMixin:RefreshPreview(hideContainer.PreviewInterrupt)
        ActionBarEnhancedDropdownMixin:RefreshPreview(hideContainer.PreviewCasting)
        ActionBarEnhancedDropdownMixin:RefreshPreview(hideContainer.PreviewReticle)
        self:RefreshFontPreview()
    end

    ActionBarEnhancedDropdownMixin:InitPreview()

    optionsFrame:Show()
    optionsFrame.ScrollFrame.ScrollChild:SetWidth(optionsFrame.ScrollFrame:GetWidth())
end

RegisterNewSlashCommand(ActionBarEnhancedMixin.InitOptions, Addon.command, Addon.shortCommand)