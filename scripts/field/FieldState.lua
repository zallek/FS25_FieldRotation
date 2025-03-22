FR_FieldState = {}

function FR_FieldState:new(superFunc, ...)
    local fieldState = superFunc(...)
    fieldState.history = FR_FieldHistory.new()
    return fieldState
end

FieldState.new = Utils.overwrittenFunction(FieldState.new, FR_FieldState.new)

function FR_FieldState:update()
    self.history:update(self)
end

FieldState.update = Utils.appendedFunction(FieldState.update, FR_FieldState.update)

function FR_FieldState:loadFromXMLFile(superFunc, xmlFile, key)
    local loaded = superFunc(self, xmlFile, key)
    if not loaded then
        return false
    end

    self.history:loadFromXMLFile(xmlFile, key)
    self.history:update(self)
    return true
end

FieldState.loadFromXMLFile = Utils.overwrittenFunction(FieldState.loadFromXMLFile, FR_FieldState.loadFromXMLFile)

function FR_FieldState:saveToXMLFile(xmlFile, key)
    if self.isValid then
        self.history:saveToXMLFile(xmlFile, key)
    end
end

FieldState.saveToXMLFile = Utils.appendedFunction(FieldState.saveToXMLFile, FR_FieldState.saveToXMLFile)


--[[ function FR_FieldState:getCropRotationFactor()
    return 1
end

function FR_FieldState:getHarvestScaleMultiplier(superFunc, ...)
    local harvestScaleMultiplier = superFunc(self, ...)
    return harvestScaleMultiplier * self:getCropRotationFactor()
end

FieldState.getHarvestScaleMultiplier = Utils.overwrittenFunction(FieldState.getHarvestScaleMultiplier, FR_FieldState.getHarvestScaleMultiplier) ]]