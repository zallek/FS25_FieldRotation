local modName = FR_FieldRotationSystem and FR_FieldRotationSystem.MOD_NAME -- for reload
FR_FieldRotationSystem = {}
FR_FieldRotationSystem.MOD_NAME = g_currentModName or modName
FR_FieldRotationSystem.SETTINGS_BASE_PATH = FR_FieldRotationSystem.MOD_NAME
FR_FieldRotationSystem.SETTINGS_ROTATION_PATH = FR_FieldRotationSystem.SETTINGS_BASE_PATH .. ".rotations.rotation"
FR_FieldRotationSystem.SETTINGS_ROTATION_FULL_PATH = FR_FieldRotationSystem.SETTINGS_ROTATION_PATH .. "(?)"
FR_FieldRotationSystem.SETTINGS_ROTATION_PREDECESSOR_PATH = ".predecessor"
FR_FieldRotationSystem.SETTINGS_ROTATION_PREDECESSOR_FULL_PATH = FR_FieldRotationSystem.SETTINGS_ROTATION_FULL_PATH .. FR_FieldRotationSystem.SETTINGS_ROTATION_PREDECESSOR_PATH .. "(?)"

local fieldCropRotationSystemClass = Class(FR_FieldRotationSystem)

function FR_FieldRotationSystem.new(o)
    local class = o or fieldCropRotationSystemClass
    local instance = setmetatable({}, class)
    instance.rotationMultipliers = {}
    return instance
end

function FR_FieldRotationSystem:registerXmlSchema()
    local xmlSchema = FieldRotation.xmlSchema
    xmlSchema:register(XMLValueType.STRING, FR_FieldRotationSystem.SETTINGS_ROTATION_FULL_PATH .. "#fruitType", "Name of the fruit type", nil, false)
    xmlSchema:register(XMLValueType.STRING, FR_FieldRotationSystem.SETTINGS_ROTATION_PREDECESSOR_FULL_PATH .. "#fruitType", "Name of the predecessor fruit type", nil, false)
    xmlSchema:register(XMLValueType.FLOAT, FR_FieldRotationSystem.SETTINGS_ROTATION_PREDECESSOR_FULL_PATH .. "#multiplier", "Yield multiplier of the predecessor fruit type", nil, false)
end

function FR_FieldRotationSystem:loadFromXMLFile(xmlFile)
    for _, entryKey in xmlFile:iterator(FR_FieldRotationSystem.SETTINGS_ROTATION_PATH) do
        local fruitTypeName = xmlFile:getValue(entryKey .. "#fruitType")
        local fruitTypeIndex = g_fruitTypeManager:getFruitTypeByName(fruitTypeName).index
        self.rotationMultipliers[fruitTypeIndex] = {}
        for _, predecessorEntryKey in xmlFile:iterator(entryKey .. FR_FieldRotationSystem.SETTINGS_ROTATION_PREDECESSOR_PATH) do
            local predecessorFruitTypeName = xmlFile:getValue(predecessorEntryKey .. "#fruitType")
            local predecessorFruitTypeIndex = g_fruitTypeManager:getFruitTypeByName(predecessorFruitTypeName).index
            local predecessorMultiplier = xmlFile:getValue(predecessorEntryKey .. "#multiplier")
            self.rotationMultipliers[fruitTypeIndex][predecessorFruitTypeIndex] = predecessorMultiplier
        end
    end
end

function FR_FieldRotationSystem:getRotationMultiplier(fruitTypeIndex, predecessorFruitTypeIndex)
    if self.rotationMultipliers[fruitTypeIndex] == nil then
        return 0
    end
    return self.rotationMultipliers[fruitTypeIndex][predecessorFruitTypeIndex] or 0
end
