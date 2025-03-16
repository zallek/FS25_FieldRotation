g_currentModName = "FS25_CropRotationYield"
g_currentMission = {
    environment = { getPeriodFromDay = function(self, day)
        return day % 12
    end },
}
g_fruitTypeManager = { getFruitTypeByIndex = function(self, index)
    if index == SUNFLOWER_FRUIT_TYPE.index then
        return SUNFLOWER_FRUIT_TYPE
    end
    return nil
end }
