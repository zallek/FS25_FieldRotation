FR_FSDensityMapUtil = {}

function FR_FSDensityMapUtil.cutFruitArea(fruitTypeIndex, superFunc, x, z, p14_, p15_, p16_, p17_, p18_, p19_, p20_, _, p21_)
    local result = superFunc(fruitTypeIndex, x, z, p14_, p15_, p16_, p17_, p18_, p19_, p20_, _, p21_)
    local farmland = g_farmlandManager:getFarmlandAtWorldPosition(x, y)
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
    return result * fieldRotationFactor
end

FSDensityMapUtil.cutFruitArea = Utils.overwrittenFunction(FSDensityMapUtil.cutFruitArea, FR_FSDensityMapUtil.cutFruitArea)

function FR_FSDensityMapUtil.updateMowerArea(fruitTypeIndex, superFunc, x, z, v69_, v70_, v71_, v72_, v73)
    local result = superFunc(fruitTypeIndex, x, z, v69_, v70_, v71_, v72_, v73)
    local farmland = g_farmlandManager:getFarmlandAtWorldPosition(x, z)
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
    return result * fieldRotationFactor
end

FSDensityMapUtil.updateMowerArea = Utils.overwrittenFunction(FSDensityMapUtil.updateMowerArea, FR_FSDensityMapUtil.updateMowerArea)
