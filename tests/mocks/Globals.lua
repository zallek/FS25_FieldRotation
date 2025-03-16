g_currentModName = "FS25_CropRotationYield"
g_currentMission = {
    environment = { getPeriodFromDay = function(self, day)
        -- 1 -> 1
        -- 2 -> 2
        -- 12 -> 12
        -- 13 -> 1
        -- 14 -> 2
        -- 24 -> 12
        return (day - 1) % 12 + 1
    end },
}
g_fruitTypeManager = {
    getFruitTypeByIndex = function(self, index)
        if index == SUNFLOWER_FRUIT_TYPE.index then
            return SUNFLOWER_FRUIT_TYPE
        end
        return nil
    end,
    getFruitTypes = function(self)
        return { SUNFLOWER_FRUIT_TYPE }
    end,
}
