FR_PlayerHUDUpdater = {}

function FR_PlayerHUDUpdater.new(self, superFunc, ...)
    local instance = superFunc(self, ...)
    local infoDisplay = g_currentMission.hud.infoDisplay
    if Platform.isMobile then
        instance.fieldPreviousHarvestsBox = infoDisplay:createBox(InfoDisplayKeyValueBoxMobile)
        instance.fieldRotationBox = infoDisplay:createBox(InfoDisplayKeyValueBoxMobile)
    else
        instance.fieldPreviousHarvestsBox = infoDisplay:createBox(InfoDisplayKeyValueBox)
        instance.fieldRotationBox = infoDisplay:createBox(InfoDisplayKeyValueBox)
    end
    return instance
end

PlayerHUDUpdater.new = Utils.overwrittenFunction(PlayerHUDUpdater.new, FR_PlayerHUDUpdater.new)

function FR_PlayerHUDUpdater.delete(self)
    local infoDisplay = g_currentMission.hud.infoDisplay
    infoDisplay:destroyBox(self.fieldPreviousHarvestsBox)
    infoDisplay:destroyBox(self.fieldRotationBox)
end

PlayerHUDUpdater.delete = Utils.appendedFunction(PlayerHUDUpdater.delete, FR_PlayerHUDUpdater.delete)

function FR_PlayerHUDUpdater.showFieldInfo(self, x, y, z)
    local fieldInfo = self.fieldInfo
    if fieldInfo.groundType ~= FieldGroundType.NONE then
        self:showFieldPreviousHarvestsInfo(fieldInfo)
        self:showFieldRotationInfo(fieldInfo)
    end
end

PlayerHUDUpdater.showFieldInfo = Utils.appendedFunction(PlayerHUDUpdater.showFieldInfo, FR_PlayerHUDUpdater.showFieldInfo)

function FR_PlayerHUDUpdater:showFieldPreviousHarvestsInfo(fieldInfo)
    local box = self.fieldPreviousHarvestsBox
    box:clear()

    local harvestedEntries = fieldInfo.history:getLatestHaverstedEntries(24)
    if #harvestedEntries > 0 then
        box:setTitle(g_i18n:getText("ui_field_previous_harvests_title"))
        -- Display last 2 years of previous harvests

        for _, entry in pairs(harvestedEntries) do
            local fruitTypeLabel = entry:getFruitType().fillType.title
            local yearsOldText = entry:getYearsOld() == 0 and g_i18n:getText("ui_field_previous_harvests_one_year") or g_i18n:getText("ui_field_previous_harvests_two_year")

            local rotationMultiplierText = ""
            if fieldInfo.fruitTypeIndex ~= FruitType.UNKNOWN then
                local rotationMultiplier = entry:getRotationMultiplier(fieldInfo.fruitTypeIndex)
                rotationMultiplierText = string.format("%+.1f", rotationMultiplier * 100) .. " %"
            end
            box:addLine(fruitTypeLabel .. " " .. yearsOldText, rotationMultiplierText)
        end

        box:showNextFrame()
    end
end

PlayerHUDUpdater.showFieldPreviousHarvestsInfo = FR_PlayerHUDUpdater.showFieldPreviousHarvestsInfo

function FR_PlayerHUDUpdater:showFieldRotationInfo(fieldInfo)
    local box = self.fieldRotationBox
    box:clear()

    local fruit = g_fruitTypeManager:getFruitTypeByIndex(fieldInfo.fruitTypeIndex)
    local growthState = fieldInfo.growthState

    if fruit ~= nil and not fruit:getIsCut(growthState) then
        box:setTitle(g_i18n:getText("ui_field_rotation_title"))
        local fieldRotationMultiplier = fieldInfo:getFieldRotationMultiplier()
        box:addLine(g_i18n:getText("ui_field_rotation_multiplier"), string.format("%+.1f", fieldRotationMultiplier * 100) .. " %")
    else
        -- Display up to 5 best next rotations
        box:setTitle(g_i18n:getText("ui_field_rotation_recommendation"))
        local bestNextRotations = fieldInfo:getBestNextRotations()
        for i = 1, math.min(5, #bestNextRotations) do
            local fruitTypeLabel = g_fruitTypeManager:getFruitTypeByIndex(bestNextRotations[i].fruitTypeIndex).fillType.title
            local rotationMultiplierText = string.format("%+.1f", bestNextRotations[i].rotationMultiplier * 100) .. " %"
            box:addLine(fruitTypeLabel, rotationMultiplierText)
        end
    end
    box:showNextFrame()
end

PlayerHUDUpdater.showFieldRotationInfo = FR_PlayerHUDUpdater.showFieldRotationInfo
