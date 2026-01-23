local AddonName, Addon = ...

local function OnBreakFrameSnap(self, deltaX, deltaY)
    if not self:CanChangeProtectedState() then return end

    local point = "CENTER"

    local layoutFramesGoingRight
    if self.__layoutFramesGoingRight ~= nil then
        layoutFramesGoingRight = self.__layoutFramesGoingRight == 1
    else
        layoutFramesGoingRight = self.layoutFramesGoingRight
    end
    local layoutFramesGoingUp
    if self.__layoutFramesGoingUp ~= nil then
        layoutFramesGoingUp = self.__layoutFramesGoingUp == 1
    else
        layoutFramesGoingUp = self.layoutFramesGoingUp
    end

    local isCentered = false
    if self.gridLayoutType then
        isCentered = self.gridLayoutType == 1
    end

    local centerX, centerY = self:GetCenter()
    local left, bottom, width, height = self:GetScaledRect()

    if isCentered then
        if layoutFramesGoingUp then
            point = "BOTTOM"
        else
            point = "TOP"
            centerX, centerY = self:GetTop()
        end
    else
        if layoutFramesGoingRight then
            point = "LEFT"
            centerX, centerY = self:GetLeft()
        else
            point = "RIGHT"
            centerX, centerY = self:GetRight()
        end
    end

    if not centerX or not centerY then return end

    local uiCenterX, uiCenterY = UIParent:GetCenter()
    local offsetX = centerX - uiCenterX
    local offsetY = centerY - uiCenterY

    if deltaX then offsetX = offsetX + deltaX end
    if deltaY then offsetY = offsetY + deltaY end

    self:ClearAllPoints()
    self:SetPoint("CENTER", UIParent, "CENTER", offsetX, offsetY)

    if self.systemInfo then
        self.systemInfo.anchorInfo = {
            point = "CENTER",
            relativeTo = "UIParent",
            relativePoint = "CENTER",
            offsetX = offsetX,
            offsetY = offsetY,
        }
        self.systemInfo.isInDefaultPosition = false
    end
    EditModeManagerFrame:OnSystemPositionChange(self)
end

local function OnEditModeEnter()
    if EditModeManagerFrame.registeredSystemFrames then
        for index, systemFrame in ipairs(EditModeManagerFrame.registeredSystemFrames) do
            local frameName = systemFrame:GetName()
            if frameName == "PlayerCastingBarFrame" or tContains(Addon.CDMFrames, frameName) then
                if systemFrame.BreakFrameSnap and not systemFrame.__breakHooked then
                    hooksecurefunc(systemFrame, "BreakFrameSnap", OnBreakFrameSnap)
                    systemFrame.__breakHooked = true
                end
            end
        end
    end
end

local function ProcessEvent(self, event, ...)
    if event == "PLAYER_LOGIN" then
        self:AddDynamicEventMethod(EventRegistry, "EditMode.Enter", OnEditModeEnter)
    end
end

local eventHandlerFrame = CreateFrame('Frame', nil, nil, "CallbackRegistrantTemplate")
eventHandlerFrame:SetScript('OnEvent', ProcessEvent)
eventHandlerFrame:RegisterEvent('PLAYER_LOGIN')