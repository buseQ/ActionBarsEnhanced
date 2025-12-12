local AddonName, Addon = ...

local LibDeflate = LibStub("LibDeflate")
local LibSerialize = LibStub("LibSerialize")

local L = Addon.L
Addon.P = {}

ActionBarsEnhancedProfilesMixin = {}
ActionBarsEnhancedImportDialogMixin = {}
ActionBarsEnhancedExportDialogMixin = {}

local DefaultProfiles = {
    ["ElvUI Style"] = "9zvZVTrruC7U0cMIlXFftsALkkcHcsafcfKQuKBtAAwenfJDAvIupmR9oXEXR9oA31XnCkItvCm)buH4yogPkXTwL)cgTNksaQYIIki(qYi4mZB(y9S2ioeP4zM373hV38Mn9DiZUA)D39JB61BnppxBVb9UJdEa2)(ZtkT213CT(((4EH1dTA2jOQNtVWmKzUDaMTv9boe8AEUE(iYSYZPwEl89c77JZWYr8gRB3sTEwso4K8KEdpw6D(c8IKzyRTkBjBFpcpV3iVLrE)05BLoFJ0KIAyehzuT(nC6821WT67A5tklOMklxRVVLKHfsUJy1rARaCWyiBbWlQAzB70RvAYcjdRQvpBCxNMIWpgmigJW(y72C6li2NU7Ub4WTniLKovmDfXDi4g9SA4IrCJOgUR3Eya3nTc6GgMetePOybqn6MEXjZoibejV(YcQGMIC7yqUWKL3AyxRqN9WYYCorE0SdD2QCcXAqT9AUdS2pOEBVbThUHRxdl364Wqwyb3FPOjRRMv((36OVovQuSkluF9thL07oeWTEtlxSzL)A5LVAQuPj5)p6gpHXsUPWfpyDMEHDW7l9O5))uiVrw21lopKTyGrhRLkEVydJ8TyDKgJBRBJB2bBlBRNlHg2j9HXeRoj)T887A5kpPwkLYNtgvlGa(4BvkZtgCUrGM1lVJ4vF(kjTSOeYJ77)WNF0fz7mgyfkkWJV7MlH3bqqfEwYlrXxmtOWcrcZtwppFQtGey6yJVLvxM2G8CtppcRtzG8Yi)aEHFcE)KIyKm)QJ)Urj8jZk)X3(zpL1kXVUnTnJIfIGramNigBSj22PF3Oe8quvmRevRgc6pBzw53U7Dpa(xFJeIANBMkcsgiiotmiLvi50QTl7VqjrwGFBAm(IBQkJRA)G2XnrlPKBvFVMaRMByY4E9rXPsD7UGQsLC27TdDCDc3FYb70tLHAGOVqg6PZspZI0xmXCw6lrZqFze9Si6RyqZMMEoe9vr0zmO5q08iAbeTiIwcrNfrlJOVMbDUm05r0fq0Z3MuE9GagrCSCNcv2bMgvvxiGsmOm4asWWwhvggmKIrTeNhmPWqTe8g2Qw(tG57WW8lLB9bQ66pvS4fL11NEPlDvrDn2bH5UBiDW3Kp1K3V7x1H)abAKA2SVjgQVO4HsSvHgbOk9nRFpIpoiGnpKEU2kg8(XJqmR8Sh(WhZr2SYF(OhbnVmDg3NkaydFVbgGWfsE(XdZeZYd7hWoLKRLuOSCSo3Alr)RbGYZ(7)H9JudfPMpIJjNlRI6dvr98T3(GXrn84JbAEIUIxsfZLvX8Jp4bpw6O)8E7DGux)6vUcGFKi2v3y8eOF5RoIZS4x2NvFo813C8fKYtVH4kn9mVH(3COodFgv1jAOv89908FL5W45ZFY3bodRdyAgSiVH80Sgq(RQq9vNF0SzznQRqpvb1JLAEls)dwyTpYc1zLLaOHIpZq73SO2w8PrJB64VemAcKVGstFKMM(9vwrPjzDJ)rpAHk9o21M5kKe2Dw8F)d",
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