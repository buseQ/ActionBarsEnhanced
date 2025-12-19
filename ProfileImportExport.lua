local AddonName, Addon = ...

local LibDeflate = LibStub("LibDeflate")
local LibSerialize = LibStub("LibSerialize")

local L = Addon.L
Addon.P = {}

ActionBarsEnhancedProfilesMixin = {}
ActionBarsEnhancedImportDialogMixin = {}
ActionBarsEnhancedExportDialogMixin = {}

local DefaultProfiles = {
    ["ElvUI Style"] = "9z13pXrvu4DDe1vefMLfeOu2gIXungRIvtAczBbPmglfCxSbs6d3z39YUJmSZnZmlBXNi9PgFR8hqTXh5rsAIV1k)fCZ(KMOMMnwt14pswJ(kEU)AM7my8bsyp375C(oFFNZ5ozVbzSfAV1wFunVwl655w3RtRB4G7G9VZmKrw8dxPmEhVDXRz3QoEhNAiYWFAagmxPJdbVONRNpIm2IT99XTcvMxhFRW2(4ChWcALA2UyRs9NN8LNCYjKrfUFL2(2AHONW6c212UUVhbrgvlKHG1GR61kSB52vD2(TkJB0212Nui(olvVHkRdXrDStvC(C8SrqKHOvSd2wbrYWAPLJLRAABy6N1SrwZQzpcoDrWnSpUEtY4jrjRgKmq(KNiS2xZcdfg8Kjq2QBTvaoCddYuj9uXZsAboHH41SRx3PvJShdxoItrKcsPiQwfEDaJqAzxLDLyfuv5GnHBAbgrMMvOckseUYyx7qhq49CAfMtjBjPveXu3SOMqNQk30aKQuHxg2HLfedyIIQBIFAWlaM6Ef3o27fuPPxNM9w21RQTBfCyiG9G78MDtlGwL((34W7NjtgqczcPF2UjPD6awL(R5M7YzYKLy(FaSUwEHBJ3tE9ZKH1FkmjfCv)51983X2v2nLxmCiNIe382mWZiRk0cOJ0IbVpRQHzdOBZiUxUjU2246YaorcyVz2d4Jm8OrmtKATqkRy6mXdMk(rE5r6dWmHM1NlPClY5vj70nr1WP2F4ZoSiCsuIit()04qFPCGeQFoltuHYNECrCT189QbkCNjugUMNhHz4TpM5RLtD81T3bl2ePotgc(f8c)y8EjlJimiea21owSmzfCDN27qlAv6p(6p5XqldFQ60CBSKVw7GMrk057MabcfWQu3YLrS2VgwL(TBEZ9z)RVrIMQnVwMUmyWkfzR(4km60OPl8xOmhtXNyJroF0RFKjPeY2ne1EGoc(LQZd1lPVNJKxPi6BRHcp0X1jCV0pdqFge1arF2CSPg5EC6ZHOppI(c0C0xCi6GZc6mDOeRoPVmI(ki6Wi6igutdAEeD0SWmaDmeDCe9vr0jq0jZrNcrpdIoTb9S5GwwArd65GnTlfea4ZX2nfykcG52RUAzTv1wL6zAwuY2FZDVldEmn44doawbKvcDi6tWH8KNcXrtmPqmR4sbzOQH6icYaybiRXka0lWEnDbB)uaFogWLh9EQ2KFA0rva)Xx4cxw0MePoSNfwwQoVoFvlRzbSMOjG)4HVfM1WGIwMbwzxMDZVAPBr8XbbW(tA(Mkm8Ur7FSk9Kh8GhXZTvP)8HpKneavCxrGxy54j)F5loK3vhjXaJuOPKogWqf65IkV1xxmfWvPN83)tgwONPjDY89erFnh(lJBoB0aQW(Y(EDm0)UcfBY3Eur6n)PqW9lQY87RY8t3yJ9JZCVJoIvFhRtvNpATL41QW2bWzs2UaObQ9EX09SQ0CrvA(X7DVhj1VFE3D3xYH)6LUeRSjJP)yGMQrh81yRfh)0hl20KAqsL13rtXumlKTN(TFhNwzTTdaTP8NF5lxvSlm4neRv9S5vp9RXDj(ulWbjdmOMaX3oLuW2q8vwXPH)2D)u9NtRG(hOb9FF(5vqxQl8VEsZvjlWxVmpm1(V)",
    ["CooldownManager Style"] = "Lr1spnruu4PoO1YQA5v0edM4wyHIk6cz0wEmgTucfiYkNPT32zsh69M5H16gmSY1nedln(pGMWEclmU8sjMWsO(yPO1Fa69XCVmJ2KMmZz((oNVZ39CUjwdnA2GQvFszyJCqOtfyZgRzdAcCFx3cfwEwGNPFGRPpWQnfsXYMoa1U0hZB6vN)A7CZMFUgMLCag9xeUQhicl0O5cCDbn8fuwb8kYNi5OqH8rXLMWlwAToimc)TEl4alz6ue47B3OM3BNOBwZY1R4cr5Goq35ZyQRD0NxzFfLezCtKPwImLs0TOpbJxHQv9a(ppbwvxRF1QgkkkOmHYIJyjODd)uD1H(1bTeW7rQppcRcgORfJZYahtF7xc4Cz6xyGC8D44eYtnJRAMAQzkPIh0OtKeh7BOrclsolq56GkH214XAL1t0UytBeOO9RbVaNYqAYcljK1q9jIkkrJ(Zdf6NzR6A)EQPEeXZ6gt7m38uffYxuKUjAir)tRDyjskJksaTcTxYXS1Kzjb6h(1NbHiYjyZuOHIyum1qAcd0vI5T04hSCqj76tMhuXoydM9g7a3OV84jS36jBwoGdOzr3UcyrZnOvqIxwvMBqI9uqR4UHuoNt4dC5q7j8a6ANn4dFdXCWjtk6WLCHLPD4vrP)327MOHfGc8SKhQj7qK0CvQb4wWyIAAxZYH83pe21JnxU(eNp8s5kYfDBrouy0lENoUualcD3W0rqAlr1lIgzvFBhB)wXVe4J4lWxnjR4SSZTw8aQ4lAGVKvhs8CK0cCbvmWjjJ2w4lBHtzHgMt6XK17OevvrJnNNhHITPZ)xl89nOPGLB80SmskflJ4hWypc92QSMUX5(9TcdFh(2KU2j)8xk0P3A6AFD7TFp9rYMNQQa49KRD6A40PVbdGU23ccONRYbaslqaVGlSjRJh0sW)wr4)JzMXiKFVoDixbPiqD7iO(YrhDIOk7T3(SPhPCMwQBmMHIEBGU2XhF8Fi)eOURa1P7U7(NJ6Sn3K2GutAazgNsG9t7Sd7wrIeo9Wd5sq9Vd",
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

function ABE_ImportProfile(profileName, profileString, shouldSet)
    return ActionBarsEnhancedImportDialogMixin:AcceptImport(_, profileString, profileName, shouldSet)
end

function ABE_GetProfiles()
    return ActionBarsEnhancedProfilesMixin:GetProfiles()
end