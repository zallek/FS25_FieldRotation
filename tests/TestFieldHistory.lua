-- Add paths relative to the test directory
package.path = package.path .. ";../scripts/?.lua;../scripts/field/?.lua;./?.lua"

local luaunit = require("luaunit")
require("./mocks/Class")
require("./mocks/FruitTypes")
require("./mocks/Globals")
-- Load the module
require("FieldHistory")

TestFieldHistory = {} -- Create a test suite
function TestFieldHistory:testgenerateBackwardHistoryEntryFromHarvested()
    local untilEntry = {
        monotonicDay = 11,
        dayTime = 0,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
        growthState = 10,
    }

    local fieldHistory = CRY_FieldHistory.new()
    local result = fieldHistory:generateBackwardHistoryEntry(untilEntry)
    local expected = { {
        monotonicDay = 10,
        dayTime = 0,
        growthState = 10, -- 10 = harvested
        fruitType = SUNFLOWER_FRUIT_TYPE.index,
    }, {
        monotonicDay = 9,
        dayTime = 0,
        growthState = 8, -- 8 = harvestable. If the field is harvested, the growth state will become 10, if not it will become 9 next monotonicDay
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

function TestFieldHistory:testgenerateBackwardHistoryEntryFirstDay()
    local untilEntry = {
        monotonicDay = 1,
        dayTime = 0,
        fruitTypeIndex = SUNFLOWER_FRUIT_TYPE.index,
        growthState = 1,
    }

    local fieldHistory = CRY_FieldHistory.new()
    local result = fieldHistory:generateBackwardHistoryEntry(untilEntry)
    local expected = {}
    luaunit.assertEquals(result, expected)
end

os.exit(luaunit.run())
