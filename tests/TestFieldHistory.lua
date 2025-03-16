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
        growthState = 10,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }

    local fieldHistory = CRY_FieldHistory.new()
    local result = fieldHistory:generateBackwardHistoryOfFruitEntry(entry)
    local expected = { {
        monotonicDay = 10,
        dayTime = 0,
        growthState = 10,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 9,
        dayTime = 1,
        growthState = 10, -- 10 = harvested
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 9,
        dayTime = 0,
        growthState = 8,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 8,
        dayTime = 0,
        growthState = 7,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 7,
        dayTime = 0,
        growthState = 6,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 6,
        dayTime = 0,
        growthState = 5,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 5,
        dayTime = 0,
        growthState = 4,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 4,
        dayTime = 0,
        growthState = 3,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 3,
        dayTime = 0,
        growthState = 2,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 2,
        dayTime = 1,
        growthState = 1,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 2,
        dayTime = 0,
        growthState = 0,
        fruitTypeIndex = FruitType.UNKNOWN,
    } }
    luaunit.assertEquals(result, expected)
end

function TestFieldHistory:testGenerateBackwardHistoryOfHarvestedTodayFruitEntry()
    local entry = {
        monotonicDay = 9,
        dayTime = 1,
        growthState = 10, -- 10 = harvested
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }

    local fieldHistory = CRY_FieldHistory.new()
    local result = fieldHistory:generateBackwardHistoryOfFruitEntry(entry)
    local expected = { {
        monotonicDay = 9,
        dayTime = 0,
        growthState = 8,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 8,
        dayTime = 0,
        growthState = 7,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 7,
        dayTime = 0,
        growthState = 6,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 6,
        dayTime = 0,
        growthState = 5,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 5,
        dayTime = 0,
        growthState = 4,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 4,
        dayTime = 0,
        growthState = 3,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 3,
        dayTime = 0,
        growthState = 2,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 2,
        dayTime = 1,
        growthState = 1,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 2,
        dayTime = 0,
        growthState = 0,
        fruitTypeIndex = FruitType.UNKNOWN,
    } }
    luaunit.assertEquals(result, expected)
end

function TestFieldHistory:testGenerateBackwardHistoryOfHarvableFruitEntry()
    local entry = {
        monotonicDay = 9,
        dayTime = 0,
        growthState = 8,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }

    local fieldHistory = CRY_FieldHistory.new()
    local result = fieldHistory:generateBackwardHistoryOfFruitEntry(entry)
    local expected = { {
        monotonicDay = 8,
        dayTime = 0,
        growthState = 7,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 7,
        dayTime = 0,
        growthState = 6,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 6,
        dayTime = 0,
        growthState = 5,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 5,
        dayTime = 0,
        growthState = 4,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 4,
        dayTime = 0,
        growthState = 3,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 3,
        dayTime = 0,
        growthState = 2,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 2,
        dayTime = 1,
        growthState = 1,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 2,
        dayTime = 0,
        growthState = 0,
        fruitTypeIndex = FruitType.UNKNOWN,
    } }
    luaunit.assertEquals(result, expected)
end

function TestFieldHistory:testGenerateBackwardHistoryOfGrowingFruitEntry()
    local entry = {
        monotonicDay = 5,
        dayTime = 0,
        growthState = 4,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }

    local fieldHistory = CRY_FieldHistory.new()
    local result = fieldHistory:generateBackwardHistoryOfFruitEntry(entry)
    local expected = { {
        monotonicDay = 4,
        dayTime = 0,
        growthState = 3,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 3,
        dayTime = 0,
        growthState = 2,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 2,
        dayTime = 1,
        growthState = 1,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 2,
        dayTime = 0,
        growthState = 0,
        fruitTypeIndex = FruitType.UNKNOWN,
    } }
    luaunit.assertEquals(result, expected)
end

function TestFieldHistory:testGenerateBackwardHistoryOfPlantedFruitEntry()
    local entry = {
        monotonicDay = 2,
        dayTime = 1,
        growthState = 1,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }

    local fieldHistory = CRY_FieldHistory.new()
    local result = fieldHistory:generateBackwardHistoryOfFruitEntry(entry)
    local expected = { {
        monotonicDay = 2,
        dayTime = 0,
        growthState = 0,
        fruitTypeIndex = FruitType.UNKNOWN,
    } }
    luaunit.assertEquals(result, expected)
end

function TestFieldHistory:testGenerateBackwardHistoryOfFirstDayFruitEntry()
    local entry = {
        monotonicDay = 1,
        dayTime = 0,
        growthState = 3,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }

    local fieldHistory = CRY_FieldHistory.new()
    local result = fieldHistory:generateBackwardHistoryOfFruitEntry(entry)
    local expected = {}
    luaunit.assertEquals(result, expected)
end

function TestFieldHistory:testGenerateBackwardHistoryWithFruitTypes()
    local entry = {
        monotonicDay = 15,
        dayTime = 0,
        growthState = 2,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }

    local fieldHistory = CRY_FieldHistory.new()
    local result = fieldHistory:generateBackwardHistoryWithFruitTypes(entry, { SUNFLOWER_FRUIT_TYPE.index, SUNFLOWER_FRUIT_TYPE.index })
    local expected = { {
        monotonicDay = 14,
        dayTime = 1,
        growthState = 1,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 14,
        dayTime = 0,
        growthState = 0,
        fruitTypeIndex = FruitType.UNKNOWN,
    }, {
        monotonicDay = 13,
        dayTime = 0,
        growthState = 0,
        fruitTypeIndex = FruitType.UNKNOWN,
    }, {
        monotonicDay = 12,
        dayTime = 0,
        growthState = 0,
        fruitTypeIndex = FruitType.UNKNOWN,
    }, {
        monotonicDay = 11,
        dayTime = 0,
        growthState = 0,
        fruitTypeIndex = FruitType.UNKNOWN,
    }, {
        monotonicDay = 10,
        dayTime = 0,
        growthState = 0,
        fruitTypeIndex = FruitType.UNKNOWN,
    }, {
        monotonicDay = 9,
        dayTime = 1,
        growthState = 10, -- 10 = harvested
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 9,
        dayTime = 0,
        growthState = 8,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 8,
        dayTime = 0,
        growthState = 7,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 7,
        dayTime = 0,
        growthState = 6,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 6,
        dayTime = 0,
        growthState = 5,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 5,
        dayTime = 0,
        growthState = 4,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 4,
        dayTime = 0,
        growthState = 3,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 3,
        dayTime = 0,
        growthState = 2,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 2,
        dayTime = 1,
        growthState = 1,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 2,
        dayTime = 0,
        growthState = 0,
        fruitTypeIndex = FruitType.UNKNOWN,
    }, {
        monotonicDay = 1,
        dayTime = 0,
        growthState = 0,
        fruitTypeIndex = FruitType.UNKNOWN,
    } }

    luaunit.assertEquals(result, expected)
end

function TestFieldHistory:testGenerateBackwardHistoryWithZeroFruitTypes()
    local entry = {
        monotonicDay = 15,
        dayTime = 0,
        growthState = 2,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }

    local fieldHistory = CRY_FieldHistory.new()
    local result = fieldHistory:generateBackwardHistoryWithFruitTypes(entry, {})
    local expected = { {
        monotonicDay = 14,
        dayTime = 1,
        growthState = 1,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 14,
        dayTime = 0,
        growthState = 0,
        fruitTypeIndex = FruitType.UNKNOWN,
    } }

    luaunit.assertEquals(result, expected)
end

os.exit(luaunit.run())
