local AddonName, Addon = ...

local L = Addon.L
Addon.P = {}

ActionBarsEnhancedProfilesMixin = {}
ActionBarsEnhancedImportDialogMixin = {}
ActionBarsEnhancedExportDialogMixin = {}

function NewProfile_OnTextChanged(self)
    if not self:HasFocus() and self:GetText() == "" then
        self.AcceptButton:Hide()
    else
        self.AcceptButton:Show()
    end
end
function NewProfile_OnEditFocusLost(self)
    if self:GetText() == "" then
        self.AcceptButton:Hide()
    end
end
function NewProfile_OnAcceptClick(self)
    local editBox = self:GetParent()
    local profileName = editBox:GetText()

    if Addon.P.profilesList == nil then
        Addon.P.profilesList = {}
    end
    if not Addon.P.profilesList[profileName] then
        ActionBarsEnhancedProfilesMixin:CreateProfile(profileName)
        ActionBarsEnhancedProfilesMixin:SetProfile(profileName, true)
        editBox:SetText("")
        editBox:ClearFocus()
    else
        Addon.Print("Profile name already exists")
    end
end
function ActionBarsEnhancedProfilesMixin:Init()
    if not ActionBarEnhancedProfilesFrame then
        local profilesFrame = CreateFrame("Frame", "ActionBarEnhancedProfilesFrame", UIParent, "ActionBarsEnhancedProfilesTemplate")
        profilesFrame:SetParent(UIParent)
        profilesFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        profilesFrame:SetMovable(true)
        profilesFrame:EnableMouse(true)
        profilesFrame:EnableMouseWheel(true)
        profilesFrame:RegisterForDrag("LeftButton")
        profilesFrame:SetScript("OnDragStart", function(self, button)
            self:StartMoving()
        end)
        profilesFrame:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
        end)
        profilesFrame:SetUserPlaced(true)

        profilesFrame.Content.Header.HeaderText:SetText(L.ProfilesHeaderText)
        profilesFrame.Content.CopyProfileFrame.CopyText:SetText(L.ProfilesCopyText)
        profilesFrame.Content.DeleteProfileFrame.DeleteText:SetText(L.ProfilesDeleteText)
        profilesFrame.Content.ImportExportFrame.ImportExportText:SetText(L.ProfilesImportText)

        profilesFrame.Content.Header.CurrentProfile:SetText(self:GetPlayerProfile())
        

        local function SelectProfileSetup()
            local frame = profilesFrame.Content.NewProfileFrame.ProfileSelect
            local IsSelected = function(id)
                return id == ActionBarsEnhancedProfilesMixin:GetPlayerProfile()
            end

            local OnSelect = function(id)
                ActionBarsEnhancedProfilesMixin:SetProfile(id, true)
                profilesFrame.Content.Header.CurrentProfile:SetText(id)
            end

            local menuGenerator = function(_, rootDescription)
                rootDescription:CreateTitle("Select Profile")
                for profileName, data in pairs(Addon.P.profilesList) do
                    local categoryID = profileName
                    local categoryName = profileName
                    rootDescription:CreateRadio(categoryName, IsSelected, OnSelect, categoryID)
                end
            end
            frame.Dropdown:SetupMenu(menuGenerator)
        end

        local function CopyProfileSetup()
            local frame = profilesFrame.Content.CopyProfileFrame

            local menuGenerator = function(_, rootDescription)
                rootDescription:CreateTitle("Copy Profile")
                local currProfile = ActionBarsEnhancedProfilesMixin:GetPlayerProfile()

                for profileName, data in pairs(Addon.P.profilesList) do
                    if profileName ~= currProfile then
                        rootDescription:CreateButton(profileName, function()
                            ActionBarsEnhancedProfilesMixin:CopyProfile(profileName, currProfile)
                            ActionBarsEnhancedProfilesMixin:SetProfile(currProfile, true)
                        end)
                    end
                end
            end
            frame.Dropdown:SetupMenu(menuGenerator)
        end
        local function DeleteProfileSetup()
            local frame = profilesFrame.Content.DeleteProfileFrame

            local menuGenerator = function(_, rootDescription)
                rootDescription:CreateTitle("Delete Profile")
                local currProfile = ActionBarsEnhancedProfilesMixin:GetPlayerProfile()

                for profileName, data in pairs(Addon.P.profilesList) do
                    if profileName ~= currProfile and profileName ~= "Default" then
                        rootDescription:CreateButton(profileName, function()
                            ActionBarsEnhancedProfilesMixin:DeleteProfile(profileName)
                        end)
                    end
                end
            end
            frame.Dropdown:SetupMenu(menuGenerator)
        end

        SelectProfileSetup()
        CopyProfileSetup()
        DeleteProfileSetup()
    else
        ActionBarEnhancedProfilesFrame:Show()
    end
    
end

function Addon:GetPlayerID()
    local name, server = UnitFullName("player")
    local playerID = name.."-"..server
    return playerID
end

function ActionBarsEnhancedProfilesMixin:SetProfile(profileName, reload)
    local playerID = Addon:GetPlayerID()

    local currentProfile = profileName

    if Addon.P.profilesList[currentProfile] then
        for key, defaultValue in pairs(Addon.Defaults) do
            if Addon.P.profilesList[currentProfile][key] ~= nil then
                Addon.C[key] = Addon.P.profilesList[currentProfile][key]
            else
                Addon.C[key] = type(Addon.C[key]) == "table" and CopyTable(defaultValue) or defaultValue
            end
        end
    else
        return
    end
    Addon.P.mapping[playerID] = currentProfile
    if reload then
        StaticPopup_Show("ABE_RELOAD")
    end
end

function ActionBarsEnhancedProfilesMixin:ResetProfile()
    local profileName = self:GetPlayerProfile()
    wipe(Addon.P.profilesList[profileName])
    self:SetProfile(profileName, true)
end

function ActionBarsEnhancedProfilesMixin:CreateProfile(profileName)
    Addon.P.profilesList[profileName] = {}
    for key, defaultValue in pairs(Addon.Defaults) do
        if Addon.C[key] ~= defaultValue then
            Addon.P.profilesList[profileName][key] = Addon.C[key]
        end
    end
end

function ActionBarsEnhancedProfilesMixin:DeleteProfile(profileName)
    if Addon.P.profilesList[profileName] ~= nil then
        Addon.P.profilesList[profileName] = nil
    end
end

function ActionBarsEnhancedProfilesMixin:CopyProfile(fromProfileName, toProfileName)
    if Addon.P.profilesList[fromProfileName] ~= nil then
        wipe(Addon.P.profilesList[toProfileName])
        for key, value in pairs(Addon.P.profilesList[fromProfileName]) do
            Addon.P.profilesList[toProfileName][key] = type(value) == "table" and CopyTable(value) or value
        end
        StaticPopup_Show("ABE_RELOAD")
    end
end

function ActionBarsEnhancedProfilesMixin:NeedMigrateProfile()
    local playerID = Addon:GetPlayerID()

    local migrate = false
    local tmp = {}
    for key, defaulValue in pairs(Addon.Defaults) do
        if ABDB[key] ~= nil then
            migrate = true
            tmp[key] = type(ABDB[key]) == "table" and CopyTable(ABDB[key]) or ABDB[key]
            ABDB[key] = nil
        end
    end
    if migrate then
        return true, tmp
    end
    return false
end

function ActionBarsEnhancedProfilesMixin:GetPlayerProfile()
    local playerID = Addon:GetPlayerID()
    if Addon.P.mapping == nil then
        Addon.P.mapping = {}
    end
    if Addon.P.mapping[playerID] == nil then
        Addon.P.mapping[playerID] = "Default"
    end
    if Addon.P.profilesList == nil then
        Addon.P.profilesList = {}
    end
    if Addon.P.profilesList["Default"] == nil then
        Addon.P.profilesList["Default"] = {}
    end
    if Addon.P.mapping[playerID] ~= "Default" then
        if Addon.P.profilesList[Addon.P.mapping[playerID]] == nil then
            Addon.P.mapping[playerID] = "Default"
        end
    end
    
    return Addon.P.mapping[playerID]
end

function Addon.CompressData(data, options)
    if C_EncodingUtil then
        local dataSerialized = C_EncodingUtil.SerializeCBOR(data)
        if dataSerialized then
            local dataCompressed = C_EncodingUtil.CompressString(dataSerialized, Enum.CompressionMethod.Deflate, Enum.CompressionLevel.OptimizeForSize)
            if dataCompressed then
                local dataEncoded = C_EncodingUtil.EncodeBase64(dataCompressed)
                return dataEncoded
            end
        end
    end
end

function Addon.DecompressData(data, options)
    if C_EncodingUtil then
        local dataCompressed = C_EncodingUtil.DecodeBase64(data)
        if dataCompressed then
            local dataSerialized = C_EncodingUtil.DecompressString(dataCompressed)
            if dataSerialized then
                local dataDecompressed = C_EncodingUtil.DeserializeCBOR(dataSerialized)
                return dataDecompressed
            end
        end
    end
    return Addon.Print("Cant decompress string")
end

function ActionBarsEnhancedProfilesMixin:ExportProfile()
    local profileName = self:GetPlayerProfile()
    if Addon.P.profilesList[profileName] then
        local exportString = Addon.CompressData(Addon.P.profilesList[profileName])

        
        if not ActionBarEnhancedExportProfile then
            local ExportProfile = CreateFrame("Frame", "ActionBarEnhancedExportProfile", ActionBarEnhancedProfilesFrame, "ActionBarsEnhancedExportDialog")
            ExportProfile:SetParent(ActionBarEnhancedProfilesFrame)
            ExportProfile:SetPoint("CENTER", ActionBarEnhancedProfilesFrame, "CENTER", 0, 0)
            ExportProfile.ExportControl.ExportContainer.EditBox:SetText(exportString)
            ExportProfile.ExportControl.ExportContainer.EditBox:HighlightText()
            ExportProfile.ExportControl.ExportContainer.EditBox:SetAutoFocus(true)
            ExportProfile:Show()
        else
            ActionBarEnhancedExportProfile.ExportControl.ExportContainer.EditBox:SetText(exportString)
            ActionBarEnhancedExportProfile.ExportControl.ExportContainer.EditBox:HighlightText()
            ActionBarEnhancedExportProfile.ExportControl.ExportContainer.EditBox:SetAutoFocus(true)
            ActionBarEnhancedExportProfile:Show()
        end


    end
end

function ActionBarsEnhancedImportDialogMixin:AcceptImport(profileString, profileName)
    if not profileString then
        profileString = ActionBarEnhancedImportProfile.ImportControl.InputContainer.EditBox:GetText()
    end
    if not profileName then
        profileName = ActionBarEnhancedImportProfile.NameControl.EditBox:GetText()
    end
    if profileString ~= "" and profileName ~= "" then
        if Addon.P.profilesList[profileName] ~= nil then
            Addon.Print("Profile with this name already exists")
            return false
        else
            local profileTable = Addon.DecompressData(profileString)
            if profileTable then
                Addon.P.profilesList[profileName] = CopyTable(profileTable)
                if ActionBarEnhancedImportProfile and ActionBarEnhancedImportProfile:IsVisible() then
                    ActionBarEnhancedImportProfile:Hide()
                end
                ActionBarsEnhancedProfilesMixin:SetProfile(profileName, true)
                return true
            end
        end
    end
end

function ActionBarsEnhancedProfilesMixin:ImportProfile()
    if not ActionBarEnhancedImportProfile then
        local ImportProfile = CreateFrame("Frame", "ActionBarEnhancedImportProfile", ActionBarEnhancedProfilesFrame, "ActionBarsEnhancedImportDialog")
        ImportProfile:SetParent(ActionBarEnhancedProfilesFrame)
        ImportProfile:SetPoint("CENTER", ActionBarEnhancedProfilesFrame, "CENTER", 0, 0)
    else
        ActionBarEnhancedImportProfile:Show()
    end
end

function ActionBarsEnhancedProfilesMixin:GetProfiles()
    local profileTbl = {}
    for profileName, data in pairs(Addon.P.profilesList) do
        table.insert(profileTbl, profileName)
    end
    return profileTbl
end