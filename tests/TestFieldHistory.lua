-- Add paths relative to the test directory
package.path = package.path .. ";../scripts/?.lua;../scripts/field/?.lua;./?.lua"

local luaunit = require("luaunit")
require("./mocks/Class")
require("./mocks/FruitTypes")
require("./mocks/Globals")
-- Load the module
require("FieldHistory")

TestFieldHistory = {} -- Create a test suite
function TestFieldHistory:testGenerateBackwardHistoryOfHarvestedFruitEntry()
    local entry = {
        monotonicDay = 11,
        dayTime = 0,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
        growthState = 10,
    }

    local fieldHistory = CRY_FieldHistory.new()
    local result = fieldHistory:generateBackwardHistoryOfFruitEntry(entry)
    local expected = { {
        monotonicDay = 10,
        dayTime = 0,
        growthState = 10, -- 10 = harvested
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 9,
        dayTime = 0,
        growthState = 8,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 8,
        dayTime = 0,
        growthState = 7,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 7,
        dayTime = 0,
        growthState = 6,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 6,
        dayTime = 0,
        growthState = 5,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 5,
        dayTime = 0,
        growthState = 4,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 4,
        dayTime = 0,
        growthState = 3,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 3,
        dayTime = 0,
        growthState = 2,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 2,
        dayTime = 0,
        growthState = 1,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    } }
    luaunit.assertEquals(result, expected)
end

function TestFieldHistory:testGenerateBackwardHistoryOfHarvableFruitEntry()
    local entry = {
        monotonicDay = 9,
        dayTime = 0,
        growthState = 8,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }

    local fieldHistory = CRY_FieldHistory.new()
    local result = fieldHistory:generateBackwardHistoryOfFruitEntry(entry)
    local expected = { {
        monotonicDay = 8,
        dayTime = 0,
        growthState = 7,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 7,
        dayTime = 0,
        growthState = 6,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 6,
        dayTime = 0,
        growthState = 5,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 5,
        dayTime = 0,
        growthState = 4,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 4,
        dayTime = 0,
        growthState = 3,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 3,
        dayTime = 0,
        growthState = 2,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 2,
        dayTime = 0,
        growthState = 1,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    } }
    luaunit.assertEquals(result, expected)
end

function TestFieldHistory:testGenerateBackwardHistoryOfGrowingFruitEntry()
    local entry = {
        monotonicDay = 5,
        dayTime = 0,
        growthState = 4,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }

    local fieldHistory = CRY_FieldHistory.new()
    local result = fieldHistory:generateBackwardHistoryOfFruitEntry(entry)
    local expected = { {
        monotonicDay = 4,
        dayTime = 0,
        growthState = 3,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 3,
        dayTime = 0,
        growthState = 2,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 2,
        dayTime = 0,
        growthState = 1,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    } }
    luaunit.assertEquals(result, expected)
end

function TestFieldHistory:testGenerateBackwardHistoryOfPlantedFruitEntry()
    local entry = {
        monotonicDay = 2,
        dayTime = 0,
        growthState = 1,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }

    local fieldHistory = CRY_FieldHistory.new()
    local result = fieldHistory:generateBackwardHistoryOfFruitEntry(entry)
    local expected = {}
    luaunit.assertEquals(result, expected)
end

function TestFieldHistory:testGenerateBackwardHistoryOfFirstDayFruitEntry()
    local entry = {
        monotonicDay = 1,
        dayTime = 0,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
        growthState = 3,
    }

    local fieldHistory = CRY_FieldHistory.new()
    local result = fieldHistory:generateBackwardHistoryOfFruitEntry(entry)
    local expected = {}
    luaunit.assertEquals(result, expected)
end

function TestFieldHistory:testGenerateHistoryNoFallow()
    local entry = {
        monotonicDay = 15,
        dayTime = 0,
        growthState = 2,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }

    local fieldHistory = CRY_FieldHistory.new()
    local result = fieldHistory:generateHistory(entry, 2, false)
    local expected = { {
        monotonicDay = 14,
        dayTime = 0,
        growthState = 1,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 13,
        dayTime = 0,
        growthState = 0,
        fruitType = FruitType.UNKNOWN,
    }, {
        monotonicDay = 12,
        dayTime = 0,
        growthState = 0,
        fruitType = FruitType.UNKNOWN,
    }, {
        monotonicDay = 11,
        dayTime = 0,
        growthState = 0,
        fruitType = FruitType.UNKNOWN,
    }, {
        monotonicDay = 10,
        dayTime = 0,
        growthState = 0,
        fruitType = FruitType.UNKNOWN,
    }, {
        monotonicDay = 9,
        dayTime = 0,
        growthState = 8,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 8,
        dayTime = 0,
        growthState = 7,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 7,
        dayTime = 0,
        growthState = 6,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 6,
        dayTime = 0,
        growthState = 5,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 5,
        dayTime = 0,
        growthState = 4,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 4,
        dayTime = 0,
        growthState = 3,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 3,
        dayTime = 0,
        growthState = 2,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 2,
        dayTime = 0,
        growthState = 1,
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 1,
        dayTime = 0,
        growthState = 0,
        fruitType = FruitType.UNKNOWN,
    } }

    luaunit.assertEquals(result, expected)
end

os.exit(luaunit.run())
