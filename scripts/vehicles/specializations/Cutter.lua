FR_Cutter = {}

function FR_Cutter:processCutterArea(superFunc, workArea, dT)
    local spec = self.spec_cutter

    local initialMultiplierArea = spec.workAreaParameters.lastMultiplierArea
    local lastArea, lastTotalArea = superFunc(self, workArea, dT)
    local afterMultiplierArea = spec.workAreaParameters.lastMultiplierArea

    local addedMultiplierArea = afterMultiplierArea - initialMultiplierArea

    -- It would be better to leverage density maps to get the field rotation factor at this exact point, but this is easier for now
    local xs, _, zs = getWorldTranslation(workArea.start)
    local farmland = g_farmlandManager:getFarmlandAtWorldPosition(xs, zs)
    local fieldRotationFactor = 1
    if farmland ~= nil then
        local fieldId = farmland:getId()
        if fieldId ~= nil then
            local field = g_fieldManager:getFieldById(fieldId)
            if field ~= nil and field.fieldState ~= nil then
                fieldRotationFactor = field.fieldState:getFieldRotationFactor()
            end
        end
    end

    spec.workAreaParameters.lastMultiplierArea = initialMultiplierArea + addedMultiplierArea * fieldRotationFactor

    return lastArea, lastTotalArea
end

Cutter.processCutterArea = Utils.overwrittenFunction(Cutter.processCutterArea, FR_Cutter.processCutterArea)
