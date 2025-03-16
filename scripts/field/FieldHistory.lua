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
    xmlSchemaSavegame:register(XMLValueType.FLOAT, CRY_FieldHistory.FULL_GAMESAVE_PATH .. "#dayTime", "Day time in minutes", nil, false)
    xmlSchemaSavegame:register(XMLValueType.STRING, CRY_FieldHistory.FULL_GAMESAVE_PATH .. "#fruitType", "Name of the fruit type", nil, false)
    xmlSchemaSavegame:register(XMLValueType.INT, CRY_FieldHistory.FULL_GAMESAVE_PATH .. "#growthState", "Growthstate of the fruit type", nil, false)
    xmlSchemaSavegame:register(XMLValueType.BOOL, CRY_FieldHistory.FULL_GAMESAVE_PATH .. "#generated", "Entry was generated by the mod")
end

function CRY_FieldHistory:loadFromXMLFile(xmlFile, key)
    print("CRY_FieldHistory.loadFromXMLFile " .. key)
    for _, entryKey in xmlFile:iterator(key .. CRY_FieldHistory.GAMESAVE_PATH) do
        local monotonicDay = xmlFile:getValue(entryKey .. "#monotonicDay")
        local dayTime = xmlFile:getValue(entryKey .. "#dayTime") * 60000
        local fruitTypeName = xmlFile:getValue(entryKey .. "#fruitType")
        local growthState = xmlFile:getValue(entryKey .. "#growthState")
        local generated = xmlFile:getValue(entryKey .. "#generated")
        local fruitType = g_fruitTypeManager:getFruitTypeByName(fruitTypeName)
        local fruitTypeIndex = fruitType and fruitType.index or 0

        self:appendHistoryEntry({
            monotonicDay = monotonicDay,
            dayTime = dayTime,
            fruitTypeIndex = fruitTypeIndex,
            growthState = growthState,
            generated = generated or false,
        })
    end
end

function CRY_FieldHistory:saveToXMLFile(xmlFile, key)
    print("CRY_FieldHistory.saveToXMLFile " .. key)
    for entryIndex, entry in ipairs(self.historyEntries) do
        local entryKey = string.format("%s(%d)", key .. CRY_FieldHistory.GAMESAVE_PATH, entryIndex - 1)
        local fruitTypeName = g_fruitTypeManager:getFruitTypeNameByIndex(entry.fruitTypeIndex)
        xmlFile:setValue(entryKey .. "#monotonicDay", entry.monotonicDay)
        xmlFile:setValue(entryKey .. "#dayTime", entry.dayTime / 60000)
        xmlFile:setValue(entryKey .. "#fruitType", fruitTypeName or "UNKNOWN")
        xmlFile:setValue(entryKey .. "#growthState", entry.growthState)
        xmlFile:setValue(entryKey .. "#generated", entry.generated or nil) -- Do not save generated boolean when not generated
    end
end

function CRY_FieldHistory:update(fieldState)
    if fieldState.farmlandId ~= 1 then -- TODO remove this?
        local currentMonotonicDay = g_currentMission.environment.currentMonotonicDay
        local currentDayTime = g_currentMission.environment.dayTime -- TODO: check if it correctly allows to order entries when several days by period
        local fruitTypeIndex = fieldState.fruitTypeIndex
        local growthState = fieldState.growthState
        local lastEntry = self.historyEntries[#self.historyEntries]

        if lastEntry == nil or lastEntry.monotonicDay ~= currentMonotonicDay or lastEntry.fruitTypeIndex ~= fruitTypeIndex or lastEntry.growthState ~= growthState then
            self:appendHistoryEntry({
                monotonicDay = currentMonotonicDay,
                dayTime = currentDayTime,
                fruitTypeIndex = fruitTypeIndex,
                growthState = growthState,
                generated = false,
            })
        end

        if #self.historyEntries < 24 then
            local success, backwardHistory = pcall(self.generateBackHistoryWithRandomFruitTypes, self, self.historyEntries[1], 2)
            if success then
                for _, entry in ipairs(backwardHistory) do
                    self:preppendHistoryEntry(entry)
                end
            else
                print("Error generating backward history")
            end
        end
    end
end

function CRY_FieldHistory:appendHistoryEntry(entry)
    table.insert(self.historyEntries, entry)
end

function CRY_FieldHistory:preppendHistoryEntry(entry)
    table.insert(self.historyEntries, 1, entry)
end

function CRY_FieldHistory:generateBackHistoryWithRandomFruitTypes(toEntry, nbFruitTypes)
    local fruitTypesIndices = { 0 }
    for _, fruitType in ipairs(g_fruitTypeManager:getFruitTypes()) do
        if fruitType.shownOnMap then -- ignore MEADOW
            table.insert(fruitTypesIndices, fruitType.index)
        end
    end

    local additionalFruitTypesIndex = {}
    for i = 1, nbFruitTypes do
        local fruitTypeIndex = fruitTypesIndices[math.random(1, #fruitTypesIndices)]
        table.insert(additionalFruitTypesIndex, fruitTypeIndex)
    end

    return self:generateBackwardHistoryWithFruitTypes(toEntry, additionalFruitTypesIndex)
end

function CRY_FieldHistory:generateBackwardHistoryWithFruitTypes(toEntry, additionalFruitTypesIndex)
    -- Generate realistic history based on fruit types seasonal growth data
    -- Useful for testing and for initializing the gameplay for players when the mod is newly installed
    local entries = self:generateBackwardHistoryOfFruitEntry(toEntry)
    print("generateBackwardHistoryWithFruitTypes: " .. #entries)

    for _, additionalFruitTypeIndex in ipairs(additionalFruitTypesIndex) do
        local nbTimes = 1
        if additionalFruitTypeIndex ~= FruitType.UNKNOWN and g_fruitTypeManager:getFruitTypeByIndex(additionalFruitTypeIndex).name == "GRASS" then
            nbTimes = 3
        end
        for i = 1, nbTimes do
            local fruitTypeEntries = self:generateBackwardHistoryWithFruitType(entries[#entries] or toEntry, additionalFruitTypeIndex)
            for _, entry in ipairs(fruitTypeEntries) do
                table.insert(entries, entry)
            end
        end
    end

    return entries
end

function CRY_FieldHistory:generateBackwardHistoryWithFruitType(entry, fruitTypeIndex)
    local entries = {}

    local fruitType = g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndex)
    local currentDay = entry.monotonicDay

    -- Generate fallow history entries
    while currentDay > 1 do
        -- Move backwards in time
        currentDay = currentDay - 1

        if fruitType ~= nil then
            local growthData = fruitType.growthDataSeasonal
            local period = g_currentMission.environment:getPeriodFromDay(currentDay)
            local periodData = growthData.periods[period]
            if periodData.isHarvestable then
                break
            end
        else
            -- Generate 8 FALLOW entries max
            if entry.monotonicDay - currentDay > 8 then
                break
            end
        end

        table.insert(entries, {
            monotonicDay = currentDay,
            dayTime = 0,
            growthState = 0,
            fruitTypeIndex = FruitType.UNKNOWN,
            generated = true,
        })
    end

    if currentDay == 1 or fruitType == nil then
        return entries
    end

    -- Generate an harvested (=cut) entry
    table.insert(entries, {
        monotonicDay = currentDay,
        dayTime = 1,
        growthState = getHighestKey(fruitType.cutStates),
        fruitTypeIndex = fruitTypeIndex,
        generated = true,
    })

    -- Generate the backward history of the harvestable entry
    local fruitEntries = self:generateBackwardHistoryOfFruitEntry(entries[#entries])
    for _, entry in ipairs(fruitEntries) do
        table.insert(entries, entry)
    end

    return entries
end

function CRY_FieldHistory:generateBackwardHistoryOfFruitEntry(entry)
    -- Generate realistic backward history of a fruit entry.
    local entries = {}

    local fruitType = g_fruitTypeManager:getFruitTypeByIndex(entry.fruitTypeIndex)
    if fruitType == nil then
        return entries
    end

    print("fruitType", fruitType.index)

    local growthData = fruitType.growthDataSeasonal
    local currentDay = entry.monotonicDay
    local currentGrowthState = entry.growthState

    -- Generate growing history entries from the current state backwards
    while true do
        -- Get the period data for the current day
        local period = g_currentMission.environment:getPeriodFromDay(currentDay)
        local periodData = growthData.periods[period]

        local isHarversted = fruitType.cutStates[currentGrowthState] == true
        local isPlanted = currentGrowthState == 1
        local isHarvestable = periodData.isHarvestable

        local dayTime = 0

        if isHarversted then
            if isHarvestable then
                -- Find the harvestable growth state that could have led to our current state
                for fromState, toState in pairs(fruitType.harvestReadyTransitions) do
                    if toState == currentGrowthState then
                        currentGrowthState = fromState
                        currentDay = currentDay
                        break
                    end
                end
            else
                -- Not harvestable, so we keep the current state
                currentDay = currentDay - 1
                currentGrowthState = currentGrowthState
                local previousPeriod = g_currentMission.environment:getPeriodFromDay(currentDay)
                local previousPeriodData = growthData.periods[previousPeriod]
                dayTime = previousPeriodData.isHarvestable and 1 or 0
            end
        elseif isPlanted then
            currentGrowthState = 0
            currentDay = currentDay
        else
            -- Find what growth state could have led to our current state
            -- We need to find the state that would growth transition TO our current state
            currentDay = currentDay - 1
            local previousPeriod = g_currentMission.environment:getPeriodFromDay(currentDay)
            local previousPeriodData = growthData.periods[previousPeriod]
            for fromState, toState in pairs(previousPeriodData.growthMapping) do
                if toState == currentGrowthState then
                    currentGrowthState = fromState
                    break
                end
            end

            if currentGrowthState == 1 then
                dayTime = 1
            end
        end

        if currentDay < 1 then
            break
        end

        -- Add current state
        table.insert(entries, {
            monotonicDay = currentDay,
            dayTime = dayTime,
            growthState = currentGrowthState,
            fruitTypeIndex = currentGrowthState == 0 and FruitType.UNKNOWN or fruitType.index,
            generated = true,
        })

        if currentGrowthState == 0 then
            break
        end
    end

    return entries
end

function getHighestKey(t)
    local highest = nil
    for k, _ in pairs(t) do
        if type(k) == "number" and (highest == nil or k > highest) then
            highest = k
        end
    end
    return highest
end
