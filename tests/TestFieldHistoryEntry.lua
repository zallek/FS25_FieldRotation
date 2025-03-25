-- Add paths relative to the test directory
package.path = package.path .. ";../scripts/?.lua;../scripts/field/?.lua;./?.lua"

local luaunit = require("luaunit")
require("./mocks/Class")
require("./mocks/Globals")
-- Load the module
-- require("FieldRotation")
require("FieldHistory")
require("FieldHistoryEntry")

g_currentMission = {
    environment = { currentMonotonicDay = 30 },
}

TestFieldHistoryEntry = {} -- Create a test suite
function TestFieldHistoryEntry:testGetDaysOldYieldFactor()
    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 30 })
    luaunit.assertEquals(entry:getYearsOldFactor(), 1)

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 19 })
    luaunit.assertEquals(entry:getYearsOldFactor(1), 1)

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 18 })
    luaunit.assertEquals(entry:getYearsOldFactor(1), 2)

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 7 })
    luaunit.assertEquals(entry:getYearsOldFactor(1), 2)

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 6 })
    luaunit.assertEquals(entry:getYearsOldFactor(1), 4)
end

function TestFieldHistoryEntry:testGetRotationMultiplier0()
    FieldRotation = {
        fieldRotationSystem = { getRotationMultiplier = function(currentFruitTypeIndex, fruitTypeIndex)
            return 0
        end },
    }

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 30 })
    luaunit.assertEquals(entry:getRotationMultiplier(1), 0)

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 19 })
    luaunit.assertEquals(entry:getRotationMultiplier(1), 0)

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 18 })
    luaunit.assertEquals(entry:getRotationMultiplier(1), 0)

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 7 })
    luaunit.assertEquals(entry:getRotationMultiplier(1), 0)

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 6 })
    luaunit.assertEquals(entry:getRotationMultiplier(1), 0)
end

function TestFieldHistoryEntry:testGetRotationMultiplierPlus20()
    FieldRotation = {
        fieldRotationSystem = { getRotationMultiplier = function(currentFruitTypeIndex, fruitTypeIndex)
            return 0.20
        end },
    }

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 30 })
    luaunit.assertEquals(entry:getRotationMultiplier(1), 0.20)

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 19 })
    luaunit.assertEquals(entry:getRotationMultiplier(1), 0.20)

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 18 })
    luaunit.assertEquals(entry:getRotationMultiplier(1), 0.10)

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 7 })
    luaunit.assertEquals(entry:getRotationMultiplier(1), 0.10)

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 6 })
    luaunit.assertEquals(entry:getRotationMultiplier(1), 0.05)
end

function TestFieldHistoryEntry:testGetRotationMultiplierMinus20()
    FieldRotation = {
        fieldRotationSystem = { getRotationMultiplier = function(currentFruitTypeIndex, fruitTypeIndex)
            return -0.20
        end },
    }

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 30 })
    luaunit.assertEquals(entry:getRotationMultiplier(1), -0.20)

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 19 })
    luaunit.assertEquals(entry:getRotationMultiplier(1), -0.20)

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 18 })
    luaunit.assertEquals(entry:getRotationMultiplier(1), -0.10)

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 7 })
    luaunit.assertEquals(entry:getRotationMultiplier(1), -0.10)

    local entry = FR_FieldHistoryEntry.new():init({ monotonicDay = 6 })
    luaunit.assertEquals(entry:getRotationMultiplier(1), -0.05)
end

os.exit(luaunit.run())
