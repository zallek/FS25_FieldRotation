CropRotationYield = {}

function CropRotationYield:loadMap(filename)
    self:registerXmlSchema()
end

function CropRotationYield:registerXmlSchema()
    CRY_FieldHistory:registerXmlSchema()
end

addModEventListener(CropRotationYield)
