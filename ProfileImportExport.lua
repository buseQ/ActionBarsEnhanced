local AddonName, Addon = ...

local LibDeflate = LibStub("LibDeflate")
local LibSerialize = LibStub("LibSerialize")

local L = Addon.L
Addon.P = {}

ActionBarsEnhancedProfilesMixin = {}
ActionBarsEnhancedImportDialogMixin = {}
ActionBarsEnhancedExportDialogMixin = {}

local DefaultProfiles = {
    ["ElvUI Style"] = "9z1sVTrvuyBgAPM2uIhBNqsALkkcHciefcTivPk3KqAgenfJDAvIuxCh75g7bp23RMzCCdRQyvflZpGkelZYivj21Q8l4QzfvcqvwuubXdjJG1CUVgpJDflQuZ5EoNVVZ35X4S3MoZQ92D3pPbP7AeINdPF3B7I7J9V)80sR9XBUwpFFC3WAH2nAhuH42nmhD6BfGHNQ13LIxJ4r8r0zu(PnVf(UH98X5GCe)W6on12NIMN7PiPxNaP39lXlsNgSTkyYXNqf596M2gM(znBM1SEw6csy1EuXURdUJBdfdMn9RR0Z3w9sH0ViTomHfo6gdadCvOITJJB3MzPftusXenQAV6UTF3Q4M98S9pIlqGlyFStlb9LE(z7UBaoCBdAjLsfhVe8d4Qrx76EyKqiQI7q2dZrFt7G2ObPjmIwuAGxtjf9IJNDEHGOMjnlPcAcYTJb98J3ERI9SdD3dRAZ5L5jHOKKTA5xAJ3BxXRV9(b1Ar63AWgEK62E1WHHqyb3FPOX7RwL)H3(WVjtMmqNL3F9ZgLw7oGJBTg2EyRY)9YlFTmzYsnFbtJhdSuikIINlDwKW2491AKkKBs87y7Pg)kihHvZ7sp55jgs0rjsIykSUHztyw0y0aDlCJ2yhvgNlf73j7bXuQg1mf2jsPQWfKr38LWhVpPLnvW5hYR2Kn2HI(UWsAXkkv5ju8F8lo8cWlJawJIg84T28PeAoeSZkOz6Li68)VZpQhLsjpjhl3E2e742RZXClwUo4BA3bQyE2VbHqHjN(QvuHdKWpfVF6sBOkXA3FVOuQNv5)87(8NcJwI1VjfFuKKrQjTZLjkfUYEJv5OQvr85ZMwL)97CN7X)V(gPcDNBKjIZrEbiq2GoRUMDB2Yd(xOc4feBtJuc5MQE4SsVGwXJslPlVk(KgCwn3G0X9gdJtLE7UGUpK(27TcD9Cd3F8d7SxkhZaXE5CStmf7KlYELu3zzNcXYHyVkIDAd2zYYMIDw2RHytBWYJyMiwbeRiIvcXMbXMfXEDd2C5yZJylGyNRfD21dcaI4A7nbQGdtIQEwuatmSaEalaWtIkGbGumQLe8akfa1s8VHTQT)yy(oaMFL6Ppu3x)5IfVGQV(0lEXRj7RXki)U7gkf8TeNs5DxWACxBO(6SVfM3HrXNLaRCN5E(TRFxQpoiaUiYovlnh(G4tjwLF2dF4JfyBv(VE0J4JRqLgjt8QBmAP9x)6dfJHXTNcALF(r7FYJ7H9cGGvKV0azUe30aEFjnjUSwiE(2BlMQ531Skp4OJ4854KL2s6ywow82Al0OyE2)8VWFKr71L0E9tp4bpwjX)YE7Dpvz(Bx5k8yzN8n1b8(j0dDMbhF(3)eEALFsxFft2bKlWJpXAkNBorYFgIoqXXRk0zMmxIUj7mtP)qxcXcMRkatKxo5pcOIR(k8PvslyrT2x4fK6ffFyuCZm2t0WXMMoVwk(OesXFC1RQLcvxr8ByseQsgkIIpYkz0g(K(W(yH)7",
    ["CooldownManager Style"] = "DjzWUnnmyCCh1dtJtBPWqG00oW1XPDgv0QyeeSr1YqIEI4M81uR4gB54qPCcXjo3hH9i0NauFekIha6lasHxaCSJDB6HCiF(V)()9)3N9ozZRPSryAiiLK80IFC(6lXXzjcgVpJYex5Jd69RFF3prip)rE(PE(cV1HsLMI3pECbi)O3I3eZYdJXuiOx14XrieI73VuiGCPr5agjxE46aMmdMBV2MpuaMkANI4pT1DUfOyj5ZG5U8JuQ7Zy0e2SCJ(LgD2XSJ)Oo(PD8fDwPK6gPOL74rlz8h14x)jqCgKCh8fzPaoRv6g6TiCgHdHKVcFspe1D(ACrMP78tAAILAnDPBLs6UnkQ6kMnAnS6FxCXlvyDDRyPb(Fqi1jihW)(Rss1Jqi)Hn(DdtmftBC7GnMqQTqj7mE3DWLTAe)4weUU(QBlhrYE(1qcPCQoFTw)r1S0bGTnyRD3BAWLkRwv)FajbUbpfIATThEosNFvT3cZ3l)TiAqV)(Gx8nv4RCppAa4svblhICCyqzXe3U7a(r7h6NvzfkyXQ36ZEIBLz91D5hBthjDcv9jBo5u(XUHzlmTpXRNj3EWT1n4ZA(7ymET5hY7AF0TZCUyafpxJq3XAMB76))d",
}

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
                for index, profileName in ipairs(Addon.P.profilesOrder) do
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

                for index, profileName in ipairs(Addon.P.profilesOrder) do
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

                for index, profileName in ipairs(Addon.P.profilesOrder) do
                    if profileName ~= currProfile and profileName ~= "Default" and not DefaultProfiles[profileName]  then
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

function ActionBarsEnhancedProfilesMixin:SetProfile(profileName, reload, config)
    local playerID = Addon:GetPlayerID()

    local currentProfile = profileName
    local profileData = Addon.P.profilesList[currentProfile]
    if not profileData then
        return
    end
    
    if profileData.FontHotKeyScale and profileData.FontHotKeyScale < 1.0 then
        profileData.FontHotKeyScale = 1.0
    end
    if profileData.FontStacksScale and profileData.FontStacksScale < 1.0 then
        profileData.FontStacksScale = 1.0
    end

    Addon.C["GlobalSettings"] = {}
    for key, defaultValue in pairs(Addon.Defaults) do
        if profileData["GlobalSettings"] and profileData["GlobalSettings"][key] ~= nil then
            Addon.C["GlobalSettings"][key] = profileData["GlobalSettings"][key]
        else
            Addon.C["GlobalSettings"][key] = type(defaultValue) == "table" and CopyTable(defaultValue) or defaultValue
        end
    end

    for catName, catData in pairs(profileData) do
        if catName ~= "GlobalSettings" then
            Addon.C[catName] = Addon.C[catName] or {}
            
            local targetCat = Addon.C[catName]

            for key, value in pairs(catData) do
                Addon.C[catName][key] = value
            end
        end
    end
    
    Addon.P.mapping[playerID] = currentProfile

    if reload then
        if not StaticPopup_Visible("ABE_RELOAD") then
            StaticPopup_Show("ABE_RELOAD")
        end
    end
end

function ActionBarsEnhancedProfilesMixin:InstallDefaultPresets()
    for profileName, profileString in pairs(DefaultProfiles) do
        if not Addon.P.profilesList[profileName] then
            ActionBarsEnhancedImportDialogMixin:AcceptImport(_, DefaultProfiles[profileName], profileName)
        end
    end
end

function ActionBarsEnhancedProfilesMixin:ResetProfile()
    local profileName = self:GetPlayerProfile()
    if DefaultProfiles[profileName] then
        self:DeleteProfile(profileName)
        ActionBarsEnhancedImportDialogMixin:AcceptImport(_, DefaultProfiles[profileName], profileName, true)
    else
        wipe(Addon.P.profilesList[profileName])
        self:SetProfile(profileName, true)
    end
end

function ActionBarsEnhancedProfilesMixin:CreateProfile(profileName)
    Addon.P.profilesList[profileName] = { ["GlobalSettings"] = {} }

    self:AddProfileOrder(profileName)
end

function ActionBarsEnhancedProfilesMixin:ResetCatOptions(catName)
    local profileName = self:GetPlayerProfile()
    if Addon.P.profilesList[profileName][catName] then
        Addon.P.profilesList[profileName][catName] = nil
        StaticPopup_Show("ABE_RELOAD")
    end
end

function ActionBarsEnhancedProfilesMixin:DeleteProfile(profileName)
    if Addon.P.profilesList[profileName] ~= nil then
        Addon.P.profilesList[profileName] = nil
        self:RemoveProfileOrder(profileName)
    end
end

function ActionBarsEnhancedProfilesMixin:CopyProfileCategory(fromCatName, toCatName, reload)
    local profileName = self:GetPlayerProfile()
    if Addon.P.profilesList[profileName][toCatName] == nil then
        Addon.P.profilesList[profileName][toCatName] = {}
    end
    wipe(Addon.P.profilesList[profileName][toCatName])
    Addon.P.profilesList[profileName][toCatName] = CopyTable(Addon.P.profilesList[profileName][fromCatName])
    if reload then
        if not StaticPopup_Visible("ABE_RELOAD") then
            StaticPopup_Show("ABE_RELOAD")
        end
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

function ActionBarsEnhancedProfilesMixin:CheckProfiles15()
    local anyMigrated = false
    for profileName, profileData in pairs(Addon.P.profilesList) do
        local needMigrate = self:NeedMigrateProfile15(profileName)
        if needMigrate then
            anyMigrated = true
            Addon.Print("Profile "..profileName.." need migrate to v2.0")
            self:MigrateProfile15(profileName)
        else
            --Addon.Print(profileName.." profile ready for v2.0")
        end
        self:CheckProfilesOrer(profileName)
    end
    if anyMigrated then
        table.sort(Addon.P.profilesOrder)
    end
end

function ActionBarsEnhancedProfilesMixin:NeedMigrateProfile15(profileName)
    return not Addon.P.profilesList[profileName]["GlobalSettings"]
end

function ActionBarsEnhancedProfilesMixin:MigrateProfile15(profileName)
    Addon.Print("Start migrating profie "..profileName.." to v2.0")
    if not Addon.P.profilesList[profileName]["GlobalSettings"] then
        Addon.P.profilesList[profileName]["GlobalSettings"] = {}
    end

    for key, value in pairs(Addon.P.profilesList[profileName]) do
        if key ~= "GlobalSettings" then
            Addon.P.profilesList[profileName]["GlobalSettings"][key] = value
            Addon.P.profilesList[profileName][key] = nil
        end
    end
    Addon.Print(profileName.." migrated to v2.0")
end

function ActionBarsEnhancedProfilesMixin:CheckProfilesOrer(profileName)
    if Addon.P.profilesOrder == nil then
        Addon.P.profilesOrder = {}
    end

    if Addon.P.profilesList[profileName] then
        tInsertUnique(Addon.P.profilesOrder, profileName)
    else
        tDeleteItem(Addon.P.profilesOrder, profileName)
    end
end

function ActionBarsEnhancedProfilesMixin:AddProfileOrder(profileName)
    table.insert(Addon.P.profilesOrder, profileName)
end
function ActionBarsEnhancedProfilesMixin:RemoveProfileOrder(profileName)
    tDeleteItem(Addon.P.profilesOrder, profileName)
end
function ActionBarsEnhancedProfilesMixin:GetProfileOrder(profileName)
    return tIndexOf(Addon.P.profilesOrder, profileName)
end

function ActionBarsEnhancedProfilesMixin:GetPlayerProfile()
    local playerID = Addon:GetPlayerID()
    if Addon.P.mapping == nil then
        Addon.P.mapping = {}
    end
    if Addon.P.profilesOrder == nil then
        Addon.P.profilesOrder = {}
    end
    if Addon.P.mapping[playerID] == nil then
        Addon.P.mapping[playerID] = "Default"
    end
    if Addon.P.profilesList == nil then
        Addon.P.profilesList = {}
    end
    if Addon.P.profilesList["Default"] == nil then
        Addon.P.profilesList["Default"] = { ["GlobalSettings"] = {} }
        self:AddProfileOrder("Default")
    end
    if Addon.P.mapping[playerID] ~= "Default" then
        if Addon.P.profilesList[Addon.P.mapping[playerID]] == nil then
            Addon.P.mapping[playerID] = "Default"
        end
    end
    
    return Addon.P.mapping[playerID]
end

function Addon.CompressData(data)
    local serialized = LibSerialize:Serialize(data)
    local compressed = LibDeflate:CompressDeflate(serialized)
    local encoded = LibDeflate:EncodeForPrint(compressed)
    return encoded
end

function Addon.DecompressData(data)
    local decoded = LibDeflate:DecodeForPrint(data)
    if not decoded then
        Addon.Print("Cant decode string")
    end
    local decompressed = LibDeflate:DecompressDeflate(decoded)
    if not decompressed then
        Addon.Print("Cant decompress string")
    end
    local success, deserialized = LibSerialize:Deserialize(decompressed)

    if success then
        return deserialized
    end
    return Addon.Print("Cant deserialize string")
end

function ActionBarsEnhancedProfilesMixin:SelfTest()
    local profileName = self:GetPlayerProfile()
    local profile = Addon.P.profilesList[profileName]
    local exportTbl = CopyTable(profile)
    local encoded = Addon.CompressData(exportTbl)
    local decoded = Addon.DecompressData(encoded)
    
    if decoded then
        Addon.Print("SELF TEST GOOD")
    else
        Addon.Print("SELF TEST BAD")
    end
end

function ActionBarsEnhancedProfilesMixin:ExportProfile()
    local profileName = self:GetPlayerProfile()
    if Addon.P.profilesList[profileName] then
        local exportTbl = CopyTable(Addon.P.profilesList[profileName])

        local exportString = Addon.CompressData(exportTbl)

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

function ActionBarsEnhancedImportDialogMixin:HasDefaultProfiles()
    if not Addon.P.profilesList then return false end
    
    local i = 0
    for profileName, data in pairs(DefaultProfiles) do
        i = i + 1
        if Addon.P.profilesList[profileName] then
            i = i - 1
        end
    end
    return i == 0
end

function ActionBarsEnhancedImportDialogMixin:AcceptImport(_, profileString, profileName, shouldSet)
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

                ActionBarsEnhancedProfilesMixin:AddProfileOrder(profileName)

                if shouldSet then
                    ActionBarsEnhancedProfilesMixin:SetProfile(profileName, true)
                end
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
    for index, profileName in ipairs(Addon.P.profilesOrder) do
        if Addon.P.profilesList[profileName] then
            table.insert(profileTbl, profileName)
        end
    end

    return profileTbl
end