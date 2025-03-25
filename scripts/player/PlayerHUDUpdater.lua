FR_PlayerHUDUpdater = {}

function FR_PlayerHUDUpdater:fieldAddField(fieldInfo, box)
    local fruit = g_fruitTypeManager:getFruitTypeByIndex(fieldInfo.fruitTypeIndex)
    local growthState = fieldInfo.growthState

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

    if fruit ~= nil and not fruit:getIsCut(growthState) then
        -- Display field rotation factor
        local fieldRotationMultiplier = fieldInfo:getFieldRotationMultiplier()
        box:addLine(g_i18n:getText("ui_field_rotation_factor"), string.format("%+.1f", fieldRotationMultiplier * 100) .. "%")
    else
        -- Rotation recommendations
        -- Display up to 3 best next rotations on a single line
        local bestNextRotations = fieldInfo:getBestNextRotations()
        for i = 1, math.min(3, #bestNextRotations) do
            local fruitTypeLabel = g_fruitTypeManager:getFruitTypeByIndex(bestNextRotations[i].fruitTypeIndex).fillType.title
            local recommendation = fruitTypeLabel .. " (" .. string.format("%+.1f", bestNextRotations[i].rotationMultiplier * 100) .. "%)"
            box:addLine(g_i18n:getText("ui_field_rotation_next_recommendation") .. " " .. i, recommendation)
        end
    end
end

PlayerHUDUpdater.fieldAddField = Utils.appendedFunction(PlayerHUDUpdater.fieldAddField, FR_PlayerHUDUpdater.fieldAddField)
