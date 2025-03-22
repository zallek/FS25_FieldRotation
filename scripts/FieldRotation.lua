FieldRotation = {}
FieldRotation.path = g_currentModDirectory
FieldRotation.settingsFile = "modSettings/FieldRotation.xml"

function FieldRotation:loadMap(filename)
    self:registerXmlSchema()
    self:loadUserSettings()
end

function FieldRotation:registerXmlSchema()
    self.xmlSchema = XMLSchema.new("FieldRotation")
    FR_FieldRotationSystem:registerXmlSchema()
    FR_FieldHistory:registerXmlSchema()
end

function FieldRotation:loadUserSettings()
    local userSettingsFilePath = Utils.getFilename(FieldRotation.settingsFile, getUserProfileAppPath())

    if not fileExists(userSettingsFilePath) then
        local defaultSettingsFilePath = Utils.getFilename("data/FieldRotation.xml", FieldRotation.path)
        copyFile(defaultSettingsFilePath, userSettingsFilePath, true)
    end

    local xmlFile = XMLFile.loadIfExists("FieldRotation", userSettingsFilePath, self.xmlSchema)
    if xmlFile then
        self.fieldRotationSystem = FR_FieldRotationSystem.new()
        self.fieldRotationSystem:loadFromXMLFile(xmlFile)
        xmlFile:delete()
    end
end

addModEventListener(FieldRotation)
