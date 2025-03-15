local modName = CRY_FieldHistory and CRY_FieldHistory.MOD_NAME -- for reload
CRY_FieldHistory = {}
CRY_FieldHistory.MOD_NAME = g_currentModName or modName
CRY_FieldHistory.GAMESAVE_PATH = "." .. CRY_FieldHistory.MOD_NAME .. ".history.entry"
CRY_FieldHistory.FULL_GAMESAVE_PATH = "fields.field(?)" .. CRY_FieldHistory.GAMESAVE_PATH .. "(?)"

local fieldHistoryClass = Class(CRY_FieldHistory)

function CRY_FieldHistory.new(o)
    local class = o or fieldHistoryClass
    local instance = setmetatable({}, class)
    instance.historyEntries = {}
    return instance
end

function CRY_FieldHistory:registerXmlSchema()
    local xmlSchemaSavegame = FieldManager.xmlSchemaSavegame

    xmlSchemaSavegame:register(XMLValueType.INT, CRY_FieldHistory.FULL_GAMESAVE_PATH .. "#monotonicDay", "Monotonic day", nil, false)
    xmlSchemaSavegame:register(XMLValueType.FLOAT, CRY_FieldHistory.FULL_GAMESAVE_PATH .. "#dayTime", "Day time", nil, false)
    xmlSchemaSavegame:register(XMLValueType.STRING, CRY_FieldHistory.FULL_GAMESAVE_PATH .. "#fruitType", "Name of the fruit type", nil, false)
    xmlSchemaSavegame:register(XMLValueType.INT, CRY_FieldHistory.FULL_GAMESAVE_PATH .. "#growthState", "Growthstate of the fruit type", nil, false)
end

function CRY_FieldHistory:loadFromXMLFile(xmlFile, key)
    print("CRY_FieldHistory.loadFromXMLFile " .. key)
    for _, entryKey in xmlFile:iterator(key .. CRY_FieldHistory.GAMESAVE_PATH) do
        local monotonicDay = xmlFile:getValue(entryKey .. "#monotonicDay")
        local dayTime = xmlFile:getValue(entryKey .. "#dayTime") * 60000
        local fruitTypeName = xmlFile:getValue(entryKey .. "#fruitType")
        local growthState = xmlFile:getValue(entryKey .. "#growthState")
        local fruitType = g_fruitTypeManager:getFruitTypeByName(fruitTypeName)
        local fruitTypeIndex = fruitType and fruitType.index or 0
        self:addHistoryEntry(monotonicDay, dayTime, fruitTypeIndex, growthState)
    end
end

function CRY_FieldHistory:saveToXMLFile(xmlFile, key)
    print("CRY_FieldHistory.saveToXMLFile " .. key)
    for entryIndex, entry in ipairs(self.historyEntries) do
        local entryKey = string.format("%s(%d)", key .. CRY_FieldHistory.GAMESAVE_PATH, entryIndex - 1)
        local fruitTypeName = g_fruitTypeManager:getFruitTypeNameByIndex(entry.fruitTypeIndex)
        xmlFile:setValue(entryKey .. "#monotonicDay", entry.monotonicDay)
        xmlFile:setValue(entryKey .. "#dayTime", entry.dayTime / 60000)
        xmlFile:setValue(entryKey .. "#fruitType", fruitTypeName)
        xmlFile:setValue(entryKey .. "#growthState", entry.growthState)
    end
end

function CRY_FieldHistory:update(fieldState)
    if fieldState.farmlandId ~= 1 then
        local currentMonotonicDay = g_currentMission.environment.currentMonotonicDay
        local currentDayTime = g_currentMission.environment.dayTime -- TODO: check if it correctly allows to order entries when several days by period
        local fruitTypeIndex = fieldState.fruitTypeIndex
        local growthState = fieldState.growthState
        local lastEntry = self.historyEntries[#self.historyEntries]

        if lastEntry == nil or lastEntry.monotonicDay ~= currentMonotonicDay or lastEntry.fruitTypeIndex ~= fruitTypeIndex or lastEntry.growthState ~= growthState then
            self:addHistoryEntry(currentMonotonicDay, currentDayTime, fruitTypeIndex, growthState)
        end
    end
end

function CRY_FieldHistory:addHistoryEntry(monotonicDay, dayTime, fruitTypeIndex, growthState)
    local entry = {
        monotonicDay = monotonicDay,
        dayTime = dayTime,
        fruitTypeIndex = fruitTypeIndex,
        growthState = growthState,
    }
    table.insert(self.historyEntries, entry)
end
