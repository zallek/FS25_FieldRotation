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
    instance.rotationFactors = {}
    return instance
end

function FR_FieldRotationSystem:registerXmlSchema()
    local xmlSchema = FieldRotation.xmlSchema
    xmlSchema:register(XMLValueType.STRING, FR_FieldRotationSystem.SETTINGS_ROTATION_FULL_PATH .. "#fruitType", "Name of the fruit type", nil, false)
    xmlSchema:register(XMLValueType.STRING, FR_FieldRotationSystem.SETTINGS_ROTATION_PREDECESSOR_FULL_PATH .. "#fruitType", "Name of the predecessor fruit type", nil, false)
    xmlSchema:register(XMLValueType.FLOAT, FR_FieldRotationSystem.SETTINGS_ROTATION_PREDECESSOR_FULL_PATH .. "#factor", "Factor of the predecessor fruit type", nil, false)
end

function FR_FieldRotationSystem:loadFromXMLFile(xmlFile)
    for _, entryKey in xmlFile:iterator(FR_FieldRotationSystem.SETTINGS_ROTATION_PATH) do
        local fruitTypeName = xmlFile:getValue(entryKey .. "#fruitType")
        self.rotationFactors[fruitTypeName] = {}
        for _, predecessorEntryKey in xmlFile:iterator(entryKey .. FR_FieldRotationSystem.SETTINGS_ROTATION_PREDECESSOR_PATH) do
            local predecessorFruitTypeName = xmlFile:getValue(predecessorEntryKey .. "#fruitType")
            local predecessorFactor = xmlFile:getValue(predecessorEntryKey .. "#factor")
            self.rotationFactors[fruitTypeName][predecessorFruitTypeName] = predecessorFactor
        end
    end
end
