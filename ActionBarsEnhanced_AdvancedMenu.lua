local AddonName, Addon = ...

local L = Addon.L
local T = Addon.Templates

local RightClickAtlasMarkup = CreateAtlasMarkup('NPE_RightClick', 18, 18);
local LeftClickAtlasMarkup = CreateAtlasMarkup('NPE_LeftClick', 18, 18);

local ActionBarNames = {
    "GlobalSettings",
    "MainActionBar",
    "MultiBarBottomLeft",
    "MultiBarBottomRight",
    "MultiBarRight",
    "MultiBarLeft",
    "MultiBar5",
    "MultiBar6",
    "MultiBar7",
    "PetActionBar",
    "StanceBar",
    "BagsBar",
    "MicroMenu",
}
local miniBars = {
    "PetActionBar",
    "StanceBar",
}
local microBars = {
    "BagsBar",
    "MicroMenu",
}
local CDMFrames = {
    "EssentialCooldownViewer",
    "UtilityCooldownViewer",
    "BuffIconCooldownViewer",
    "BuffBarCooldownViewer",
}

local menuList = {
    {
        name = "Quick Presets",
        buttons = {
            {
                name = "Presets",
                layout = "layoutPresets",
            },
        },
    },
    {
        name = "Cooldown Manager",
        buttons = {},
    },
    {
        name = "Action Bars",
        buttons = {},
    },
    {
        name = "Something Else",
        buttons = {},
    },
}

for _, element in ipairs(menuList) do
    if element.name == "Action Bars" then
        for _, bar in ipairs(ActionBarNames) do
            table.insert(element.buttons, { 
                label = bar,
                name = L[bar] or bar,
                category = 2,
                layout = (tContains(miniBars, bar) and "layoutMini")
                        or (tContains(microBars, bar) and "layoutMicro")
                        or "layout"
            })
        end
    elseif element.name == "Cooldown Manager" then
        for _, frame in ipairs(CDMFrames) do
            table.insert(element.buttons, { 
                label = frame,
                name = L[frame] or frame,
                category = 1,
                layout = frame == "BuffBarCooldownViewer" and "BuffBarCooldownViewer" or "EssentialCooldownViewer"
            })
        end
    elseif element.name == "Something Else" then
        table.insert(element.buttons, {
            label = "AddNewGroup",
            name = "",
        })
    end
end

ABE_BarsFrameMixin = {}

function ABE_BarsFrameMixin:OnClick()
    ABE_BarsFrameMixin:Toggle()
end
function ABE_BarsFrameMixin:OnLoad()
    ABE_BarsFrameMixin:Collapse()

    if not ABE_BarsFrameMixin.selection then
        ABE_BarsFrameMixin.selection = CreateFrame("Frame", nil, UIParent, "ABE_BarsHighlightTemplate")
    end
end
function ABE_BarsFrameMixin:Toggle()
	if ABE_BarsFrameMixin.collapsed then
		ABE_BarsFrameMixin:Expand()
	else
		ABE_BarsFrameMixin:Collapse()
	end
end
function ABE_BarsFrameMixin:Expand()
    ABE_BarsFrameMixin.collapsed = false
    ActionBarEnhancedOptionsAdvancedFrame:SetPoint("LEFT", ActionBarEnhancedOptionsFrame, "RIGHT", -5, 0)
end
function ABE_BarsFrameMixin:Collapse()
    ABE_BarsFrameMixin.collapsed = true
    ActionBarEnhancedOptionsAdvancedFrame:SetPoint("LEFT", ActionBarEnhancedOptionsFrame, "RIGHT", -205, 0)
end
function ABE_BarsFrameMixin:Init()
    local optionsFrame = ActionBarEnhancedOptionsFrame
    optionsFrame.advanced = CreateFrame("Frame", "ActionBarEnhancedOptionsAdvancedFrame", optionsFrame, "ABE_BarsFrameTemplate")
    optionsFrame.advanced:ClearAllPoints()
    optionsFrame.advanced:SetParent(ActionBarEnhancedOptionsFrame)
    optionsFrame.advanced:SetPoint("LEFT", optionsFrame, "RIGHT", -205, 0)
    optionsFrame.advanced.NineSlice.Title:SetRotation(1.5708)

   local listFrame = CreateFrame("Frame", "ABE_ListFrame", optionsFrame.advanced, "ABE_BarsListTemplate")
   listFrame:SetParent(optionsFrame.advanced)
   listFrame:SetPoint("TOPLEFT", 5, -5)
   listFrame:SetPoint("BOTTOMRIGHT", -5, 5)

   ABE_BarsListMixin:Init()
end

ABE_BarsListMixin = {}

function ABE_BarsListMixin:OnLoad()
    
end
function ABE_BarsFrameMixin:OnHide()
    if ABE_BarsFrameMixin.selection then
        ABE_BarsFrameMixin.selection:Hide()
        if ABE_BarsListMixin.bar then
            Addon:SetFrameAlpha(ABE_BarsListMixin.bar)
            if ABE_BarsListMixin.bar.ShouldHide then
                ABE_BarsListMixin.bar:Hide()
            end
        end
    end
end

ABE_BarsButtonMixin = {}

function ABE_BarsButtonMixin:SetSelected(selected)
    local bar = ABE_BarsListMixin.label ~= "GlobalSettings" and _G[ABE_BarsListMixin.label] or nil
    --local cdm = tContains(CDMFrames, ABE_BarsListMixin.label)

    if selected then
		self.Texture:Show()
        --[[ if cdm then
            bar:SetIsEditing(not bar:IsEditing())
        end ]]
        if bar then
            ABE_BarsFrameMixin.selection:SetParent(bar)
            ABE_BarsFrameMixin.selection:SetPoint("TOPLEFT", bar, "TOPLEFT", -4, 4)
            ABE_BarsFrameMixin.selection:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 4, -4)
            ABE_BarsFrameMixin.selection:SetFrameLevel(bar:GetFrameLevel()-1)
            ABE_BarsFrameMixin.selection:Show()
            ABE_BarsFrameMixin.selection.PulseAnim:Play()
        else
            ABE_BarsFrameMixin.selection:Hide()
            ABE_BarsFrameMixin.selection.PulseAnim:Stop()
        end
	else
        if bar then
            ABE_BarsFrameMixin.selection:Hide()
            ABE_BarsFrameMixin.selection.PulseAnim:Stop()
        end
        --[[ if cdm then
            bar:SetIsEditing(not bar:IsEditing())
            bar:Layout()
        end ]]
		self.Texture:Hide()
	end
end

function ABE_BarsListMixin:ResetBarSettings(barName)
    ActionBarsEnhancedProfilesMixin:ResetCatOptions(barName)
end

function ABE_BarsListMixin:InitButtons(buttons, frame)
    local currentProfile = Addon:GetCurrentProfile()

    local frames = {}
    for i, buttonData in ipairs(buttons) do
        local template = "ABE_BarsListButtonTemplate"

        if buttonData.label == "AddNewGroup" then
            template = "ABE_BarsListCreateGroupButtonTemplate"
        end

        local button = CreateFrame("Button", nil, frame, template)
        table.insert(frames, button)
        if i == 1 then
            button:SetPoint("TOP", frame.Background, "BOTTOM", 0, -1)
        else
            button:SetPoint("TOP", frames[i-1], "BOTTOM", 0, -1)
        end
        if button.Label then
            button.Label:SetText(buttonData.name or "Button")
        end

        local hasConfig = Addon.P.profilesList[currentProfile][buttonData.label] and next(Addon.P.profilesList[currentProfile][buttonData.label])

        button:SetScript("OnEnter", function(self)
            if buttonData.label == "AddNewGroup" then
                return
            end

            if ABE_BarsListMixin.hoveredButton and ABE_BarsListMixin.hoveredButton ~= self then
                local prev = ABE_BarsListMixin.hoveredButton
                prev.Copy:Hide()
                prev.Paste:Hide()
            end

            ABE_BarsListMixin.hoveredButton = self

            local inCopypasteMode = ABE_BarsListMixin.copypaste

            if hasConfig and buttonData.label ~= "GlobalSettings" and buttonData.label ~= "BuffBarCooldownViewer" then
                if not inCopypasteMode then
                    self.Copy:Show()
                    self.Paste:Hide()
                elseif inCopypasteMode ~= buttonData.label and ABE_BarsListMixin.layout == buttonData.layout then
                    self.Copy:Hide()
                    self.Paste:Show()
                end
            elseif buttonData.label ~= "BuffBarCooldownViewer" then
                self.Copy:Hide()
                if inCopypasteMode and inCopypasteMode ~= buttonData.label and ABE_BarsListMixin.layout == buttonData.layout then
                    self.Paste:Show()
                else
                    self.Paste:Hide()
                end
            end

        end)

        button:SetScript("OnLeave", function(self)
            if buttonData.label == "AddNewGroup" then
                return
            end

            local focusedFrames = GetMouseFoci()
            if focusedFrames and focusedFrames[1] then
                local focus = focusedFrames[1]
                if focus == self or focus == self.Copy or focus == self.Paste then
                    return
                end
            end
            button.Copy:Hide()
            button.Paste:Hide()
        end)

        button:SetScript("OnClick", function(self, button, down)
            if buttonData.label == "AddNewGroup" then
                Addon.Print("New feature soon.")
                return
            end

            if ABE_BarsListMixin.selected then
                if ABE_BarsListMixin.selected.label == buttonData.label then
                    return
                end
                ABE_BarsListMixin.selected:SetSelected(false)
                ABE_BarsListMixin.selected = nil
            end
            
            ABE_BarsListMixin.label = buttonData.label
            if ABE_BarsListMixin.bar then
                if ABE_BarsListMixin.bar.ShouldHide then
                    if not InCombatLockdown() then
                        ABE_BarsListMixin.bar:Hide()
                    end
                end
                Addon:SetFrameAlpha(ABE_BarsListMixin.bar)
            end

            ABE_BarsListMixin.bar = (buttonData.label ~= "GlobalSettings" and not tContains(CDMFrames, buttonData.label)) and _G[buttonData.label] or nil
            if ABE_BarsListMixin.bar then
                ABE_BarsListMixin.bar.ShouldHide = not ABE_BarsListMixin.bar:IsVisible()
                if not InCombatLockdown() then
                    ABE_BarsListMixin.bar:Show()
                end
                Addon:SetFrameAlpha(ABE_BarsListMixin.bar, 1)
            end

            ABE_BarsListMixin.selected = self
            ABE_BarsListMixin.selected.label = buttonData.label
            self:SetSelected(true)
            ActionBarEnhancedMixin:InitData(Addon[buttonData.layout])
        end)

        if not button.Copy and not button.Paste and not button.Reset then
            return
        end

        if buttonData.label ~= "Presets" and hasConfig then
            button.Reset:Show()
        else
            button.Reset:Hide()
        end

        if buttonData.label ~= "Presets" then
            button.Reset:SetScript("OnClick", function(self, button, down)
                local barName = buttonData.label
                if not StaticPopup_Visible("ABE_RESET_CAT") then
                    StaticPopup_Show("ABE_RESET_CAT", nil, nil, barName)
                end
            end)
        end

        button.Copy:SetScript("OnClick", function(self)
            if hasConfig then
                ABE_BarsListMixin.copypaste = buttonData.label
                ABE_BarsListMixin.layout = buttonData.layout
                local panelName = ABE_BarsListMixin.copypaste
                Addon.Print(string.format(L["Copied: %s"], L[panelName]))
                self:Hide()
            end
        end)
        button.Copy:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip_AddColoredLine(GameTooltip, LeftClickAtlasMarkup .. L.CopyText, LIGHTYELLOW_FONT_COLOR)
            GameTooltip:SetScale(0.82)
            GameTooltip:Show()
        end)
        button.Copy:SetScript("OnLeave",function(self)
            GameTooltip:Hide()
        end)

        button.Paste:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        button.Paste:SetScript("OnClick", function(self, pressed)
            if pressed == "RightButton" then
                ABE_BarsListMixin.copypaste = nil
                self:Hide()
                return
            elseif pressed == "LeftButton" then
                local fromCat = ABE_BarsListMixin.copypaste
                local toCat = buttonData.label
                Addon.Print(string.format(L["Pasted: %s → %s"], L[fromCat], L[toCat]))
                ActionBarsEnhancedProfilesMixin:CopyProfileCategory(fromCat, toCat, true)
                --ABE_BarsListMixin.copypaste = nil
                self:Hide()
            end
        end)
        button.Paste:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip_AddColoredLine(GameTooltip, LeftClickAtlasMarkup .. L.PasteText, NECROLORD_GREEN_COLOR)
            GameTooltip_AddColoredLine(GameTooltip, RightClickAtlasMarkup .. L.CancelText, WARNING_FONT_COLOR)
            GameTooltip:SetScale(0.82)
            GameTooltip:Show()
        end)
        button.Paste:SetScript("OnLeave",function(self)
            GameTooltip:Hide()
        end)
        
    end
end

function ABE_BarsListMixin:GetActionBar()
    return ABE_BarsListMixin.label
end

function ABE_BarsListMixin:Init()
    if not self.dataProvider then
        self.dataProvider = CreateDataProvider()

        self.scrollBox = ABE_ListFrame.ScrollBox
        self.scrollBar = ABE_ListFrame.ScrollBar

        function self:ElementInitializer(frame, elementData)
            local containerName = elementData.name
            local buttons = elementData.buttons

            frame.Label:SetText(containerName)
            frame:Show()

            ABE_BarsListMixin:InitButtons(buttons, frame)
        end
    end

    for _, element in ipairs(menuList) do
        self.dataProvider:Insert(
            {
                name = element.name,
                buttons = element.buttons,
            }
        )
    end

    if not self.view then
        self.view = CreateScrollBoxListLinearView()
        self.view:SetPadding(0, 0, 0, 0, 10) --top, bottom, left, right, spacing
        --view:SetElementExtent(200)
        self.view:SetElementExtentCalculator(function(dataIndex, elementData)
            local height = #elementData.buttons * 21
            return height + 31
        end)

        self.view:SetElementResetter(function(frame, elementData)
            local existing = { frame:GetChildren() }
            for _, child in ipairs(existing) do
                if child ~= frame.Label then
                    child:Hide()
                end
            end
        end)

        self.view:SetElementInitializer("ABE_BarsListHeaderTemplate", function(frame, elementData)
            self:ElementInitializer(frame, elementData)
        end)
        ScrollUtil.InitScrollBoxListWithScrollBar(self.scrollBox, self.scrollBar, self.view)
        self.scrollBox:Init(self.view)
        self.scrollBox:SetInterpolateScroll(true)
        self.scrollBox:SetDataProvider(self.dataProvider)
        --self.scrollBox:SetPanExtent(20)
        self.scrollBar:Hide()
    end
end

ABE_BarsListHeaderMixin = {}

ABE_BarsGroupButtonMixin = {}