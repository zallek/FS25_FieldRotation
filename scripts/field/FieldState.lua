FR_FieldState = {}

function FR_FieldState.new(self, superFunc, ...)
    local instance = superFunc(self)
    instance.history = FR_FieldHistory.new()
    instance.isRealField = false
    return instance
end

FieldState.new = Utils.overwrittenFunction(FieldState.new, FR_FieldState.new)

function FR_FieldState:update(x, z)
    --[[ 
    Annoyingly, FieldState is used for different purposes in the game
    1. Each Field has a FieldState to track the field's fruit, growth state, etc
       - These are flagged with isRealField = true
       - FieldManager updates these FieldStates when needed
       - These ones are loaded from the savegame
    2. PlayerHUDUpdater uses one FieldState to hold info about player position: farmland owner, fruit the player is standing on (!= field's fruit), etc
       - This one is flagged with isRealField = false
       - This weird field state is updated every frame
       - This one is not persistent
    We need to distinguish the two cases
    ]]
    if self.isRealField then
        -- update field'history
        self.history:update(self)
    else
        -- return the history of the farmland's field to use it in field info display
        local field = g_fieldManager:getFieldById(self.farmlandId)
        if field ~= nil then
            self.history = field.fieldState.history
        end
    end
end

FieldState.update = Utils.appendedFunction(FieldState.update, FR_FieldState.update)

function FR_FieldState:loadFromXMLFile(superFunc, xmlFile, key)
    local loaded = superFunc(self, xmlFile, key)
    if not loaded then
        return false
    end

    self.history:loadFromXMLFile(xmlFile, key)
    self.history:update(self)
    self.isRealField = true
    return true
end

FieldState.loadFromXMLFile = Utils.overwrittenFunction(FieldState.loadFromXMLFile, FR_FieldState.loadFromXMLFile)

function FR_FieldState:saveToXMLFile(xmlFile, key)
    if self.isValid then
        self.history:saveToXMLFile(xmlFile, key)
    end
end

FieldState.saveToXMLFile = Utils.appendedFunction(FieldState.saveToXMLFile, FR_FieldState.saveToXMLFile)

function FR_FieldState:getFieldRotationMultiplier()
    local currentFruitTypeIndex = self.fruitTypeIndex
    local latestHaverstedEntries = self.history:getLatestHaverstedEntries(24)
    local multiplier = 0
    for _, harvestedEntry in pairs(latestHaverstedEntries) do
        multiplier = multiplier + harvestedEntry:getRotationMultiplier(currentFruitTypeIndex)
    end
    return multiplier
end

FieldState.getFieldRotationMultiplier = FR_FieldState.getFieldRotationMultiplier

function FR_FieldState:getFieldRotationFactor()
    return 1 + self:getFieldRotationMultiplier()
end

FieldState.getFieldRotationFactor = FR_FieldState.getFieldRotationFactor


--[[ function FR_FieldState:getHarvestScaleMultiplier(superFunc, ...)
    local harvestScaleMultiplier = superFunc(self, ...)
    return harvestScaleMultiplier * self:getCropRotationFactor()
end

FieldState.getHarvestScaleMultiplier = Utils.overwrittenFunction(FieldState.getHarvestScaleMultiplier, FR_FieldState.getHarvestScaleMultiplier) ]]