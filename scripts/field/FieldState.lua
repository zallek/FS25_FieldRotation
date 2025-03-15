CRY_FieldState = {}

function CRY_FieldState:new(superFunc, ...)
    local fieldState = superFunc(...)
    fieldState.history = CRY_FieldHistory.new()
    return fieldState
end

FieldState.new = Utils.overwrittenFunction(FieldState.new, CRY_FieldState.new)

function CRY_FieldState:update()
    self.history:update(self)
end

FieldState.update = Utils.appendedFunction(FieldState.update, CRY_FieldState.update)

function CRY_FieldState:loadFromXMLFile(superFunc, xmlFile, key)
    local loaded = superFunc(self, xmlFile, key)
    if not loaded then
        return false
    end

    self.history:loadFromXMLFile(xmlFile, key)
    self.history:update(self)
    return true
end

FieldState.loadFromXMLFile = Utils.overwrittenFunction(FieldState.loadFromXMLFile, CRY_FieldState.loadFromXMLFile)

function CRY_FieldState:saveToXMLFile(xmlFile, key)
    if self.isValid then
        self.history:saveToXMLFile(xmlFile, key)
    end
end

FieldState.saveToXMLFile = Utils.appendedFunction(FieldState.saveToXMLFile, CRY_FieldState.saveToXMLFile)
