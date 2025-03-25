FR_PlayerHUDUpdater = {}

function FR_PlayerHUDUpdater.new(self, superFunc, ...)
    local instance = superFunc(self, ...)
    local infoDisplay = g_currentMission.hud.infoDisplay
    if Platform.isMobile then
        instance.fieldRotationBox = infoDisplay:createBox(InfoDisplayKeyValueBoxMobile)
    else
        instance.fieldRotationBox = infoDisplay:createBox(InfoDisplayKeyValueBox)
    end
    return instance
end

PlayerHUDUpdater.new = Utils.overwrittenFunction(PlayerHUDUpdater.new, FR_PlayerHUDUpdater.new)

function FR_PlayerHUDUpdater.delete(self)
    local infoDisplay = g_currentMission.hud.infoDisplay
    infoDisplay:destroyBox(self.fieldRotationBox)
end

PlayerHUDUpdater.delete = Utils.appendedFunction(PlayerHUDUpdater.delete, FR_PlayerHUDUpdater.delete)

function FR_PlayerHUDUpdater.showFieldInfo(self, x, y, z)
    local fieldInfo = self.fieldInfo
    if fieldInfo.groundType ~= FieldGroundType.NONE then
        local fieldRotationBox = self.fieldRotationBox
        fieldRotationBox:clear()
        fieldRotationBox:setTitle(g_i18n:getText("ui_field_rotation_title"))
        self:fieldBoxAddPreviousHarvests(fieldInfo, fieldRotationBox)

        local fruit = g_fruitTypeManager:getFruitTypeByIndex(fieldInfo.fruitTypeIndex)
        local growthState = fieldInfo.growthState
        if fruit ~= nil and not fruit:getIsCut(growthState) then
            self:fieldBoxAddRotationMultiplier(fieldInfo, fieldRotationBox)
        else
            self:fieldBoxAddRotationRecommendations(fieldInfo, fieldRotationBox)
        end
        fieldRotationBox:showNextFrame()
    end
end

PlayerHUDUpdater.showFieldInfo = Utils.appendedFunction(PlayerHUDUpdater.showFieldInfo, FR_PlayerHUDUpdater.showFieldInfo)

function FR_PlayerHUDUpdater:fieldBoxAddPreviousHarvests(fieldInfo, box)
    -- Display previous harvests
    local harvestedEntriesByYear = {}
    for _, harvestedEntry in pairs(fieldInfo.history:getLatestHaverstedEntries(24)) do
        local yearsOld = harvestedEntry:getYearsOld()
        if harvestedEntriesByYear[yearsOld] == nil then
            harvestedEntriesByYear[yearsOld] = {}
        end
        if harvestedEntriesByYear[yearsOld][harvestedEntry.fruitTypeIndex] == nil then
            harvestedEntriesByYear[yearsOld][harvestedEntry.fruitTypeIndex] = {}
        end
        table.insert(harvestedEntriesByYear[yearsOld][harvestedEntry.fruitTypeIndex], harvestedEntry)
    end

    for yearsOld, fruitTypeEntries in pairs(harvestedEntriesByYear) do
        for fruitTypeIndex, entries in pairs(fruitTypeEntries) do
            local key = yearsOld == 0 and g_i18n:getText("ui_field_rotation_one_year_harvest") or g_i18n:getText("ui_field_rotation_two_year_harvest", yearsOld)

            local fruitTypeLabel = entries[1]:getFruitType().fillType.title
            local countText = #entries > 1 and " (x" .. #entries .. ")" or ""

            local rotationMultiplierText = ""
            if fieldInfo.fruitTypeIndex ~= FruitType.UNKNOWN then
                local rotationMultiplier = entries[1]:getRotationMultiplier(fieldInfo.fruitTypeIndex)
                rotationMultiplierText = " (" .. string.format("%+.1f", (rotationMultiplier * 100) * #entries) .. "%)"
            end
            box:addLine(key, fruitTypeLabel .. countText .. rotationMultiplierText)
        end
    end
end

PlayerHUDUpdater.fieldBoxAddPreviousHarvests = FR_PlayerHUDUpdater.fieldBoxAddPreviousHarvests

function FR_PlayerHUDUpdater:fieldBoxAddRotationMultiplier(fieldInfo, box)
    local fieldRotationMultiplier = fieldInfo:getFieldRotationMultiplier()
    box:addLine(g_i18n:getText("ui_field_rotation_multiplier"), string.format("%+.1f", fieldRotationMultiplier * 100) .. "%")
end

PlayerHUDUpdater.fieldBoxAddRotationMultiplier = FR_PlayerHUDUpdater.fieldBoxAddRotationMultiplier

function FR_PlayerHUDUpdater:fieldBoxAddRotationRecommendations(fieldInfo, box)
    -- Display up to 3 best next rotations on a single line
    box:addLine(g_i18n:getText("ui_field_rotation_next_recommendation"), "")
    local bestNextRotations = fieldInfo:getBestNextRotations()
    for i = 1, math.min(3, #bestNextRotations) do
        local fruitTypeLabel = g_fruitTypeManager:getFruitTypeByIndex(bestNextRotations[i].fruitTypeIndex).fillType.title
        local rotationMultiplierText = string.format("%+.1f", bestNextRotations[i].rotationMultiplier * 100) .. "%"
        box:addLine(fruitTypeLabel, rotationMultiplierText)
    end
end

PlayerHUDUpdater.fieldBoxAddRotationRecommendations = FR_PlayerHUDUpdater.fieldBoxAddRotationRecommendations
