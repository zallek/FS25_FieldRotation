FR_PlayerHUDUpdater = {}

function FR_PlayerHUDUpdater.new(self, superFunc, ...)
    local instance = superFunc(self, ...)
    local infoDisplay = g_currentMission.hud.infoDisplay
    if Platform.isMobile then
        instance.fieldRotationBox = infoDisplay:createBox(InfoDisplayKeyValueBoxMobile)
        instance.fieldRotationRecommendedBox = infoDisplay:createBox(InfoDisplayKeyValueBoxMobile)
    else
        instance.fieldRotationBox = infoDisplay:createBox(InfoDisplayKeyValueBox)
        instance.fieldRotationRecommendedBox = infoDisplay:createBox(InfoDisplayKeyValueBox)
    end
    return instance
end

PlayerHUDUpdater.new = Utils.overwrittenFunction(PlayerHUDUpdater.new, FR_PlayerHUDUpdater.new)

function FR_PlayerHUDUpdater.delete(self)
    local infoDisplay = g_currentMission.hud.infoDisplay
    infoDisplay:destroyBox(self.fieldRotationBox)
    infoDisplay:destroyBox(self.fieldRotationRecommendedBox)
end

PlayerHUDUpdater.delete = Utils.appendedFunction(PlayerHUDUpdater.delete, FR_PlayerHUDUpdater.delete)

function FR_PlayerHUDUpdater.showFieldInfo(self, x, y, z)
    local fieldInfo = self.fieldInfo
    if fieldInfo.groundType ~= FieldGroundType.NONE then
        local harvestedEntries = fieldInfo.history:getLatestHaverstedEntries(24)
        self:showFieldRotationInfo(fieldInfo, harvestedEntries)
        self:showFieldRotationRecommendedInfo(fieldInfo, harvestedEntries)
    end
end

PlayerHUDUpdater.showFieldInfo = Utils.appendedFunction(PlayerHUDUpdater.showFieldInfo, FR_PlayerHUDUpdater.showFieldInfo)

function FR_PlayerHUDUpdater:showFieldRotationInfo(fieldInfo, harvestedEntries)
    local box = self.fieldRotationBox
    box:clear()

    if #harvestedEntries > 0 then
        box:setTitle(g_i18n:getText("ui_field_rotation_title"))

        local fruit = g_fruitTypeManager:getFruitTypeByIndex(fieldInfo.fruitTypeIndex)
        local growthState = fieldInfo.growthState

        -- Display last 2 years of previous harvests
        for _, entry in pairs(harvestedEntries) do
            local fruitTypeLabel = entry:getFruitType().fillType.title
            local yearsOldText = entry:getYearsOld() == 0 and g_i18n:getText("ui_field_rotation_harvest_this_year") or g_i18n:getText("ui_field_rotation_harvest_last_year")

            local rotationMultiplierText = ""
            if fruit ~= nil and not fruit:getIsCut(growthState) then
                local rotationMultiplier = entry:getRotationMultiplier(fieldInfo.fruitTypeIndex)
                rotationMultiplierText = string.format("%+.1f", rotationMultiplier * 100) .. " %"
            end
            box:addLine(fruitTypeLabel .. " " .. yearsOldText, rotationMultiplierText)
        end

        if fruit ~= nil and not fruit:getIsCut(growthState) then
            local fieldRotationMultiplier = fieldInfo:getFieldRotationMultiplier()
            box:addLine(g_i18n:getText("ui_field_rotation_bonus"), string.format("%+.1f", fieldRotationMultiplier * 100) .. " %")
        end

        box:showNextFrame()
    end
end

PlayerHUDUpdater.showFieldRotationInfo = FR_PlayerHUDUpdater.showFieldRotationInfo

function FR_PlayerHUDUpdater:showFieldRotationRecommendedInfo(fieldInfo, harvestedEntries)
    local box = self.fieldRotationRecommendedBox
    box:clear()

    if #harvestedEntries > 0 then
        local fruit = g_fruitTypeManager:getFruitTypeByIndex(fieldInfo.fruitTypeIndex)
        local growthState = fieldInfo.growthState

        if fruit == nil or fruit:getIsCut(growthState) then
            -- Display up to 5 best next rotations
            box:setTitle(g_i18n:getText("ui_field_rotation_recommendation_title"))
            local bestNextRotations = fieldInfo:getBestNextRotations()
            for i = 1, math.min(5, #bestNextRotations) do
                local fruitTypeLabel = g_fruitTypeManager:getFruitTypeByIndex(bestNextRotations[i].fruitTypeIndex).fillType.title
                local rotationMultiplierText = string.format("%+.1f", bestNextRotations[i].rotationMultiplier * 100) .. " %"
                box:addLine(fruitTypeLabel, rotationMultiplierText)
            end
            box:showNextFrame()
        end
    end
end

PlayerHUDUpdater.showFieldRotationRecommendedInfo = FR_PlayerHUDUpdater.showFieldRotationRecommendedInfo
