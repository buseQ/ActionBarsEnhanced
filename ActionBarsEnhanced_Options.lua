local AddonName, Addon = ...

local L = Addon.L
local T = Addon.Templates

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
    

    local defaultSizes = {}
    function ActionBarEnhancedDropdownMixin:RefreshPreview(button)
        local function GetFlipBook(...)
            local Animations = {...}

            for _, Animation in ipairs(Animations) do
                if Animation:GetObjectType() == "FlipBook" then
                    Animation:SetParentKey("FlipAnim")
                    return Animation
                end
            end
        end

        if not button then return end

        local loopAnim = T.LoopGlow[Addon.C.CurrentLoopGlow] or nil
        local procAnim = T.ProcGlow[Addon.C.CurrentProcGlow] or nil
        local altGlowAtlas = T.PushedTextures[Addon.C.CurrentAssistAltType] or nil
        local region = button.ProcGlow
        if region then
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

        local normalAtlas = T.NormalTextures[Addon.C.CurrentNormalTexture] or nil
        if button.NormalTexture then
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

        if button.backdropPreview then
            button.icon:Hide()
            local backdropAtlas = T.BackdropTextures[Addon.C.CurrentBackdropTexture] or nil
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

        local pushedAtlas = T.PushedTextures[Addon.C.CurrentPushedTexture] or nil
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
        local highlightAtlas = T.HighlightTextures[Addon.C.CurrentHighlightTexture] or nil
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
                    button.HighlightTexture:SetPoint("CENTER", button, "CENTER")
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
        if button.CheckedTexture then
            local checkedAtlas = T.HighlightTextures[Addon.C.CurrentCheckedTexture] or nil
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
                button.icon:SetScale(Addon.C.UseIconScale and Addon.C.IconScale * 0.69 or 1.0)
            else
                button.icon:SetSize(45,45)
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
            button.TextOverlayContainer.HotKey:SetScale(Addon.C.FontHotKey and textScaleMult + Addon.C.FontHotKeyScale or 1.0)
            button.TextOverlayContainer.Count:SetScale(Addon.C.FontStacks and textScaleMult + Addon.C.FontStacksScale or 1.0)
        end
    end

    function ActionBarEnhancedDropdownMixin:SetupDropdown(frame, setting, name, IsSelected, OnSelect, showNew)
        local menuGenerator = function(_, rootDescription)
            rootDescription:CreateTitle(name)
            
            for i = 1, #setting do
                local categoryID = i
                local categoryName = setting[i].name
                rootDescription:CreateRadio(categoryName, IsSelected, OnSelect, categoryID)
            end
        end
        if showNew then
            frame.NewFeature:Show()
        else
            frame.NewFeature:Hide()
        end

        frame.Text:SetText(name)
        frame.Control.Dropdown:SetupMenu(menuGenerator)
        frame.Control.Dropdown:SetWidth(300)
        frame.Control.IncrementButton:Hide()
        frame.Control.DecrementButton:Hide()
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
                    callback()
                end
            end
        )
    end

    function ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(checkboxFrame, name, checkboxValue, sliderValue, min, max, step, sliderName, callback)
        checkboxFrame.Text:SetText(name)
        local options = Settings.CreateSliderOptions(min or 0, max or 1, step or 0.1)
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Top, function(value) return sliderName or "" end);
        checkboxFrame.SliderWithSteppers:Init(Addon.C[sliderValue], options.minValue, options.maxValue, options.steps, options.formatters)
        checkboxFrame.SliderWithSteppers:RegisterCallback("OnValueChanged",
            function(self, value)
                Addon:SaveSetting(sliderValue, value)
                if callback and type(callback) == "function" then
                    callback()
                end
            end,
            checkboxFrame.SliderWithSteppers
        )
        checkboxFrame.SliderWithSteppers:SetEnabled(Addon.C[checkboxValue])
        checkboxFrame.Checkbox:SetChecked(Addon.C[checkboxValue])
        checkboxFrame.Checkbox:SetScript("OnClick",
            function()
                Addon:SaveSetting(checkboxValue, not Addon.C[checkboxValue])
                checkboxFrame.SliderWithSteppers:SetEnabled(Addon.C[checkboxValue])
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
    local hideContainer = optionsFrame.ScrollFrame.ScrollChild.HideFramesOptionsContainer
    local fontContainer = optionsFrame.ScrollFrame.ScrollChild.FontOptionsContainer

    ---------------------------------------------
    -----------------GLOW OPTIONS----------------
    ---------------------------------------------
    optionsFrame.ScrollFrame.ScrollChild.GlowOptionsContainer.Title:SetText(L.GlowTypeTitle)
    optionsFrame.ScrollFrame.ScrollChild.GlowOptionsContainer.Desc:SetText(L.GlowTypeDesc)
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        optionsFrame.ScrollFrame.ScrollChild.GlowOptionsContainer.GlowOptions,
        T.LoopGlow,
        L.GlowType,
        function(id) return id == Addon.C.CurrentLoopGlow end,
        function(id)
            Addon:SaveSetting("CurrentLoopGlow", id)
            ActionBarEnhancedDropdownMixin:RefreshPreview(loopContainer.ProcLoopPreview)
        end,
        true
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        optionsFrame.ScrollFrame.ScrollChild.GlowOptionsContainer.CustomColorGlow,
        L.UseCustomColor,
        "LoopGlowColor",
        {"UseLoopGlowColor", "DesaturateGlow"}
    )

    ---------------------------------------------
    -----------------PROC OPTIONS----------------
    ---------------------------------------------
    optionsFrame.ScrollFrame.ScrollChild.ProcOptionsContainer.Title:SetText(L.ProcStartTitle)
    optionsFrame.ScrollFrame.ScrollChild.ProcOptionsContainer.Desc:SetText(L.ProcStartDesc)
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        optionsFrame.ScrollFrame.ScrollChild.ProcOptionsContainer.HideProc,
        L.HideProcAnim,
        "HideProc"
    )
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        optionsFrame.ScrollFrame.ScrollChild.ProcOptionsContainer.ProcOptions,
        T.ProcGlow,
        L.StartProcType,
        function(id) return id == Addon.C.CurrentProcGlow end,
        function(id) 
            Addon:SaveSetting("CurrentProcGlow", id)
            ActionBarEnhancedDropdownMixin:RefreshPreview(procContainer.ProcStartPreview)
        end
    )
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        optionsFrame.ScrollFrame.ScrollChild.ProcOptionsContainer.CustomColorProc,
        L.UseCustomColor,
        "ProcColor",
        {"UseProcColor", "DesaturateProc"}
    )

    ---------------------------------------------
    ----------------ASSIST OPTIONS---------------
    ---------------------------------------------
    optionsFrame.ScrollFrame.ScrollChild.AssistLoopOptionsContainer.Title:SetText(L.AssistTitle)
    optionsFrame.ScrollFrame.ScrollChild.AssistLoopOptionsContainer.Desc:SetText(L.AssistDesc)
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        optionsFrame.ScrollFrame.ScrollChild.AssistLoopOptionsContainer.AssistLoopType,
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
        optionsFrame.ScrollFrame.ScrollChild.AssistLoopOptionsContainer.AssistAltGlowType,
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
    WAIntegrationContainer.Title:SetText(L.WAIntTitle)
    WAIntegrationContainer.Desc:SetText(L.WAIntDesc)
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        WAIntegrationContainer.ModifyWAGlow,
        L.ModifyWAGlow,
        "ModifyWAGlow"
    )
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        WAIntegrationContainer.WAProcType,
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
        WAIntegrationContainer.WALoopType,
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
    optionsFrame.ScrollFrame.ScrollChild.FadeOptionsContainer.Title:SetText(L.FadeTitle)
    optionsFrame.ScrollFrame.ScrollChild.FadeOptionsContainer.Desc:SetText(L.FadeDesc)

    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        optionsFrame.ScrollFrame.ScrollChild.FadeOptionsContainer.FadeOutBars,
        L.FadeOutBars,
        "FadeBars",
        "FadeBarsAlpha",
        0, 1, 0.1, "Fade Alpha"
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        optionsFrame.ScrollFrame.ScrollChild.FadeOptionsContainer.FadeInOnCombat,
        L.FadeInOnCombat,
        "FadeInOnCombat"
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        optionsFrame.ScrollFrame.ScrollChild.FadeOptionsContainer.FadeInOnTarget,
        L.FadeInOnTarget,
        "FadeInOnTarget"
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        optionsFrame.ScrollFrame.ScrollChild.FadeOptionsContainer.FadeInOnCasting,
        L.FadeInOnCasting,
        "FadeInOnCasting"
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        optionsFrame.ScrollFrame.ScrollChild.FadeOptionsContainer.FadeInOnHover,
        L.FadeInOnHover,
        "FadeInOnHover"
    )

    ---------------------------------------------
    ------------NORMAL TEXTURE OPTIONS-----------
    ---------------------------------------------
    normalContainer.NewFeature:Show()
    normalContainer.Title:SetText(L.NormalTitle)
    normalContainer.Desc:SetText(L.NormalDesc)
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        normalContainer.NormalTextureOptions,
        T.NormalTextures,
        L.NormalTextureType,
        function(id) return id == Addon.C.CurrentNormalTexture end,
        function(id)
            Addon:SaveSetting("CurrentNormalTexture", id)
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
    backdropContainer.NewFeature:Show()
    backdropContainer.Title:SetText(L.BackdropTitle)
    backdropContainer.Desc:SetText(L.BackdropDesc)
    backdropContainer.PreviewBackdrop.backdropPreview = true
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        backdropContainer.BackdropTextureOptions,
        T.BackdropTextures,
        L.BackdropTextureType,
        function(id) return id == Addon.C.CurrentBackdropTexture end,
        function(id)
            Addon:SaveSetting("CurrentBackdropTexture", id)
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
    iconContaiter.NewFeature:Show()
    iconContaiter.Title:SetText(L.IconTitle)
    iconContaiter.Desc:SetText(L.IconDesc)
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        iconContaiter.IconMaskTextureOptions,
        T.IconMaskTextures,
        L.IconMaskTextureType,
        function(id) return id == Addon.C.CurrentIconMaskTexture end,
        function(id)
            Addon:SaveSetting("CurrentIconMaskTexture", id)
            ActionBarEnhancedDropdownMixin:RefreshAllPreview()
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        iconContaiter.MaskScale,
        L.IconMaskScale,
        "UseIconMaskScale",
        "IconMaskScale",
        0.5, 1.5, 0.05, "Mask Scale",
        function()
            ActionBarEnhancedDropdownMixin:RefreshPreview(iconContaiter.PreviewIcon)
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        iconContaiter.IconScale,
        L.IconScale,
        "UseIconScale",
        "IconScale",
        0.5, 1.5, 0.05, "Icon Scale",
        function()
            ActionBarEnhancedDropdownMixin:RefreshPreview(iconContaiter.PreviewIcon)
        end
    )

    ---------------------------------------------
    ------------PUSHED TEXTURE OPTIONS-----------
    ---------------------------------------------
    pushedContainer.Title:SetText(L.PushedTitle)
    pushedContainer.Desc:SetText(L.PushedDesc)
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        pushedContainer.PushedTextureOptions,
        T.PushedTextures,
        L.PushedTextureType,
        function(id) return id == Addon.C.CurrentPushedTexture end,
        function(id)
            Addon:SaveSetting("CurrentPushedTexture", id)
            ActionBarEnhancedDropdownMixin:RefreshAllPreview()
        end,
        true
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
    highlightContainer.Title:SetText(L.HighlightTitle)
    highlightContainer.Desc:SetText(L.HighlightDesc)
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        highlightContainer.HighlightTextureOptions,
        T.HighlightTextures,
        L.HighliteTextureType,
        function(id) return id == Addon.C.CurrentHighlightTexture end,
        function(id)
            Addon:SaveSetting("CurrentHighlightTexture", id)
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
    checkedContainer.Title:SetText(L.CheckedTitle)
    checkedContainer.Desc:SetText(L.CheckedDesc)
    ActionBarEnhancedDropdownMixin:SetupDropdown(
        checkedContainer.CheckedTextureOptions,
        T.HighlightTextures,
        L.CheckedTextureType,
        function(id) return id == Addon.C.CurrentCheckedTexture end,
        function(id)
            Addon:SaveSetting("CurrentCheckedTexture", id)
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
    optionsFrame.ScrollFrame.ScrollChild.ColorOverrideOptionsContainer.Title:SetText(L.ColorOverrideTitle)
    optionsFrame.ScrollFrame.ScrollChild.ColorOverrideOptionsContainer.Desc:SetText(L.ColorOverrideDesc)
    ActionBarEnhancedDropdownMixin:SetupColorSwatch(
        optionsFrame.ScrollFrame.ScrollChild.ColorOverrideOptionsContainer.CustomColorCooldown,
        L.CustomColorCooldownSwipe,
        "CooldownColor",
        {"UseCooldownColor"},
        true
    )

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
    hideContainer.Title:SetText(L.HideFrameTitle)
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
    hideContainer.HideStanceBar.new = true
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        hideContainer.HideStanceBar,
        L.HideStanceBar,
        "HideStanceBar",
        function() Addon:HideBars("StanceBar") end
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
    fontContainer.Title:SetText(L.FontTitle)
    fontContainer.Desc:SetText(L.FontDesc)

    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fontContainer.HotkeyScale,
        L.FontHotKeyScale,
        "FontHotKey",
        "FontHotKeyScale",
        0, 2, 0.1, "Font Scale",
        function()
            ActionBarEnhancedDropdownMixin:RefreshAllPreview()
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fontContainer.StacksScale,
        L.FontStacksScale,
        "FontStacks",
        "FontStacksScale",
        0, 2, 0.1, "Font Scale",
        function()
            ActionBarEnhancedDropdownMixin:RefreshAllPreview()
        end        
    )
    ActionBarEnhancedDropdownMixin:SetupCheckbox(
        fontContainer.NameHide,
        L.FontHideName,
        "FontHideName",
        function() 
            fontContainer.NameScale.Checkbox:SetEnabled(not Addon.C.FontHideName)
            fontContainer.NameScale.SliderWithSteppers:SetEnabled(not Addon.C.FontHideName)
            ActionBarEnhancedDropdownMixin:RefreshAllPreview()
        end
    )
    ActionBarEnhancedCheckboxSliderMixin:SetupCheckboxSlider(
        fontContainer.NameScale,
        L.FontNameScale,
        "FontName",
        "FontNameScale",
        0, 2, 0.1, "Font Scale",
        function()
            ActionBarEnhancedDropdownMixin:RefreshAllPreview()
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
        fontContainer.PreviewFont15.TextOverlayContainer.HotKey:SetText("4")
        fontContainer.PreviewFont2.TextOverlayContainer.HotKey:SetText("4")

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

    function ActionBarEnhancedDropdownMixin:RefreshAllPreview()
        ActionBarEnhancedDropdownMixin:RefreshPreview(loopContainer.ProcLoopPreview)
        ActionBarEnhancedDropdownMixin:RefreshPreview(procContainer.ProcStartPreview)
        ActionBarEnhancedDropdownMixin:RefreshPreview(normalContainer.PreviewNormal)
        ActionBarEnhancedDropdownMixin:RefreshPreview(backdropContainer.PreviewBackdrop)
        ActionBarEnhancedDropdownMixin:RefreshPreview(iconContaiter.PreviewIcon)
        ActionBarEnhancedDropdownMixin:RefreshPreview(pushedContainer.PreviewPushed)
        ActionBarEnhancedDropdownMixin:RefreshPreview(highlightContainer.PreviewHighlight)
        ActionBarEnhancedDropdownMixin:RefreshPreview(checkedContainer.PreviewChecked)
        ActionBarEnhancedDropdownMixin:RefreshPreview(hideContainer.PreviewInterrupt)
        ActionBarEnhancedDropdownMixin:RefreshPreview(hideContainer.PreviewCasting)
        ActionBarEnhancedDropdownMixin:RefreshPreview(hideContainer.PreviewReticle)
        ActionBarEnhancedDropdownMixin:RefreshPreview(fontContainer.PreviewFont05)
        ActionBarEnhancedDropdownMixin:RefreshPreview(fontContainer.PreviewFont075)
        ActionBarEnhancedDropdownMixin:RefreshPreview(fontContainer.PreviewFont1)
        ActionBarEnhancedDropdownMixin:RefreshPreview(fontContainer.PreviewFont15)
        ActionBarEnhancedDropdownMixin:RefreshPreview(fontContainer.PreviewFont2)
    end

    ActionBarEnhancedDropdownMixin:InitPreview()

    optionsFrame:Show()
    optionsFrame.ScrollFrame.ScrollChild:SetWidth(optionsFrame.ScrollFrame:GetWidth())
end

RegisterNewSlashCommand(ActionBarEnhancedMixin.InitOptions, Addon.command, Addon.shortCommand)