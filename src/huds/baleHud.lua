---${title}

---@author ${author}
---@version r_version_r
---@date 12/11/2020

---@class BaleHud : RoyalHudControl
BaleHud = {}
BaleHud_mt = Class(BaleHud, RoyalHudControl)

---@return BaleHud
function BaleHud:new()
    local width, height = 340, 104
    local style = RoyalHudStyles.getStyle(InfoDisplayStyle, FS19Style)

    ---@type BaleHud
    local hud = RoyalHudControl:new("baleHud", 1 - g_safeFrameOffsetX, 0 + g_safeFrameOffsetY, width, height, style, nil, BaleHud_mt)
    hud:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_RIGHT)
    hud.panel = RoyalHudPanel:new("baleHudPanel", 0.5, 0.5, width, height, style, hud)
    hud.title = RoyalHudText:new("title", string.upper(g_i18n:getText("id_baleHudTitle")), 20, true, 0, height - 2, hud)
    hud.title:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)

    hud.squareBaleRow = RoyalHud:new("sbr", 0, height - 6, width, 50, hud)
    hud.squareBaleRow:setAlignment(RoyalHud.ALIGNS_VERTICAL_TOP, RoyalHud.ALIGNS_HORIZONTAL_LEFT)

    hud.squareBaleIcon = RoyalHudImage:new("sbi", InfoDisplay.hudAtlasPath, 0, 0, 50, 50, hud.squareBaleRow)
    hud.squareBaleIcon:setUVs(0, 0, 256, 256, {2048, 2048})
    hud.squareBaleIcon:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    hud.squareBaleHeightIcon = RoyalHudImage:new("sbhi", InfoDisplay.hudAtlasPath, 58, 0, 50, 50, hud.squareBaleRow)
    hud.squareBaleHeightIcon:setUVs(768, 0, 256, 256, {2048, 2048})
    hud.squareBaleHeightIcon:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    hud.squareBaleHeightText = RoyalHudText:new("sbht", "", 18, false, 90, 10, hud.squareBaleRow)
    hud.squareBaleHeightText:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    hud.squareBaleWidthIcon = RoyalHudImage:new("sbwi", InfoDisplay.hudAtlasPath, 140, 0, 50, 50, hud.squareBaleRow)
    hud.squareBaleWidthIcon:setUVs(512, 0, 256, 256, {2048, 2048})
    hud.squareBaleWidthIcon:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    hud.squareBaleWidthText = RoyalHudText:new("sbwt", "", 18, false, 190, 10, hud.squareBaleRow)
    hud.squareBaleWidthText:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    hud.squareBaleLengthIcon = RoyalHudImage:new("sbli", InfoDisplay.hudAtlasPath, 240, 0, 50, 50, hud.squareBaleRow)
    hud.squareBaleLengthIcon:setUVs(1024, 0, 256, 256, {2048, 2048})
    hud.squareBaleLengthIcon:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    hud.squareBaleLengthText = RoyalHudText:new("sblt", "", 18, false, 285, 10, hud.squareBaleRow)
    hud.squareBaleLengthText:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)

    hud.roundBaleRow = RoyalHud:new("rbr", 0, height - 6, width, 50, hud)
    hud.roundBaleRow:setAlignment(RoyalHud.ALIGNS_VERTICAL_TOP, RoyalHud.ALIGNS_HORIZONTAL_LEFT)

    hud.roundBaleIcon = RoyalHudImage:new("rbi", InfoDisplay.hudAtlasPath, 0, 0, 50, 50, hud.roundBaleRow)
    hud.roundBaleIcon:setUVs(256, 0, 256, 256, {2048, 2048})
    hud.roundBaleIcon:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    hud.roundBaleDiameterIcon = RoyalHudImage:new("rbdi", InfoDisplay.hudAtlasPath, 50, 0, 50, 50, hud.roundBaleRow)
    hud.roundBaleDiameterIcon:setUVs(1280, 0, 256, 256, {2048, 2048})
    hud.roundBaleDiameterIcon:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    hud.roundBaleDiameterText = RoyalHudText:new("rbdt", "", 18, false, 100, 10, hud.roundBaleRow)
    hud.roundBaleDiameterText:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    hud.roundBaleWidthIcon = RoyalHudImage:new("rbwi", InfoDisplay.hudAtlasPath, 150, 0, 50, 50, hud.roundBaleRow)
    hud.roundBaleWidthIcon:setUVs(512, 0, 256, 256, {2048, 2048})
    hud.roundBaleWidthIcon:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    hud.roundBaleWidthText = RoyalHudText:new("rbwt", "", 18, false, 200, 10, hud.roundBaleRow)
    hud.roundBaleWidthText:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)

    hud.secondRow = RoyalHud:new("sr", 0, height - 50, width, 50, hud)
    hud.secondRow:setAlignment(RoyalHud.ALIGNS_VERTICAL_TOP, RoyalHud.ALIGNS_HORIZONTAL_LEFT)

    hud.fillLevelText = RoyalHudText:new("flt", "", 18, false, 56, 10, hud.secondRow)
    hud.fillLevelText:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    hud.massIcon = RoyalHudImage:new("mi", InfoDisplay.hudAtlasPath, 140, 0, 50, 50, hud.secondRow)
    hud.massIcon:setUVs(1536, 0, 256, 256, {2048, 2048})
    hud.massIcon:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    hud.massText = RoyalHudText:new("mt", "", 18, false, 195, 10, hud.secondRow)
    hud.massText:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    hud.ownerIcon = RoyalHudImage:new("oi", InfoDisplay.hudAtlasPath, 285, 0, 50, 50, hud.secondRow)
    hud.ownerIcon:setUVs(1792, 0, 256, 256, {2048, 2048})
    hud.ownerIcon:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)

    self.fillTypesIcons = {}
    return hud
end

function BaleHud:setData(data)
    if data ~= nil then
        if data.isRoundBale then
            self.squareBaleRow:setIsVisible(false)
            self.roundBaleRow:setIsVisible(true)
            self.roundBaleDiameterText:setText(string.format("%.1f m", data.baleDiameter))
            self.roundBaleWidthText:setText(string.format("%.1f m", data.baleWidth))
        else
            self.squareBaleRow:setIsVisible(true)
            self.roundBaleRow:setIsVisible(false)
            self.squareBaleHeightText:setText(string.format("%.1f m", data.baleHeight))
            self.squareBaleWidthText:setText(string.format("%.1f m", data.baleWidth))
            self.squareBaleLengthText:setText(string.format("%.1f m", data.baleLength))
        end
        self.massText:setText(string.format("%d kg", data.mass))
        self.ownerIcon:setColor(GameplayUtility.getFarmColor(data.ownerFarmId))
        self.fillLevelText:setText(string.format("%d l", data.fillLevel))
        self:setFillTypeIconsVisibility(false)
        local fillTypeIcon = self.fillTypesIcons[data.fillType]
        if fillTypeIcon ~= nil then
            fillTypeIcon:setIsVisible(true)
        end
    end
end

function BaleHud:setFillTypeIconsVisibility(visible)
    for _, icon in pairs(self.fillTypesIcons) do
        icon:setIsVisible(visible)
    end
end

function BaleHud:getRenderPosition()
    local x, y = BaleHud:superClass().getRenderPosition(self)

    -- hud offset to prevent overlap with FieldInfoDisplay
    if InfoDisplay.fieldInfoDisplay ~= nil and InfoDisplay.fieldInfoDisplay.isEnabled and InfoDisplay.fieldInfoDisplay:getVisible() then
        local _, fidY = InfoDisplay.fieldInfoDisplay:getPosition()
        local fidH = InfoDisplay.fieldInfoDisplay:getHeight()
        y = y + fidY + fidH + InfoDisplay.fieldInfoDisplay.labelTextOffsetY + InfoDisplay.fieldInfoDisplay.labelTextSize
    end

    return x, y
end

function BaleHud:loadFillIcons()
    for i, fillType in ipairs(g_fillTypeManager:getFillTypes()) do
        local iconFilename = fillType.hudOverlayFilename
        if g_screenHeight <= g_referenceScreenHeight then
            iconFilename = fillType.hudOverlayFilenameSmall
        end
        if iconFilename ~= "dataS2/menu/hud/fillTypes/hud_fill_fuel.png" and iconFilename ~= "" then
            local fillIcon = RoyalHudImage:new("fti_" .. i, iconFilename, 5, 5, 40, 40, self.secondRow)
            fillIcon:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
            fillIcon:setIsVisible(false)
            self.fillTypesIcons[fillType.index] = fillIcon
        end
    end
end
