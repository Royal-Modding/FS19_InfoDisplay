--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 25/11/2020

PalletHud = {}
PalletHud_mt = Class(PalletHud, RoyalHudControl)

function PalletHud:new()
    ---@type RoyalHudControl
    local width, height = 340, 54
    local style = RoyalHudStyles.getStyle(InfoDisplayStyle, FS19Style)

    local hud = RoyalHudControl:new("PalletHud", 1 - g_safeFrameOffsetX, 0 + g_safeFrameOffsetY, width, height, style, nil, PalletHud_mt)
    hud:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_RIGHT)
    hud.panel = RoyalHudPanel:new("PalletHudPanel", 0.5, 0.5, width, height, style, hud)
    hud.title = RoyalHudText:new("title", string.upper(g_i18n:getText("id_palletHudTitle")), 20, true, 0, height - 2, hud)
    hud.title:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)

    hud.secondRow = RoyalHud:new("sr", 0, height, width, 50, hud)
    hud.secondRow:setAlignment(RoyalHud.ALIGNS_VERTICAL_TOP, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    hud.fillTypesIcons = {}
    for i, fillType in ipairs(g_fillTypeManager:getFillTypes()) do
        local iconFilename = fillType.hudOverlayFilename
        if g_screenHeight <= g_referenceScreenHeight then
            iconFilename = fillType.hudOverlayFilenameSmall
        end
        if iconFilename ~= "dataS2/menu/hud/fillTypes/hud_fill_fuel.png" and iconFilename ~= "" then
            local fillIcon = RoyalHudImage:new("fti_" .. i, iconFilename, 5, 5, 40, 40, hud.secondRow)
            fillIcon:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
            fillIcon:setIsVisible(false)
            hud.fillTypesIcons[fillType.index] = fillIcon
        end
    end
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
    return hud
end

function PalletHud:setData(data)
    if data ~= nil then
        self.massText:setText(string.format("%d kg", data.mass))
        self.ownerIcon:setColor(Utility.getFarmColor(data.ownerFarmId))
        self.fillLevelText:setText(string.format("%d l", data.fillLevel))
        self:setFillTypeIconsVisibility(false)
        local fillTypeIcon = self.fillTypesIcons[data.fillType]
        if fillTypeIcon ~= nil then
            fillTypeIcon:setIsVisible(true)
        end
    end
end

function PalletHud:setFillTypeIconsVisibility(visible)
    for _, icon in pairs(self.fillTypesIcons) do
        icon:setIsVisible(visible)
    end
end

function PalletHud:getRenderPosition()
    local x, y = PalletHud:superClass().getRenderPosition(self)

    -- hud offset to prevent overlap with FieldInfoDisplay
    if InfoDisplay.fieldInfoDisplay ~= nil and InfoDisplay.fieldInfoDisplay.isEnabled and InfoDisplay.fieldInfoDisplay:getVisible() then
        local _, fidY = InfoDisplay.fieldInfoDisplay:getPosition()
        local fidH = InfoDisplay.fieldInfoDisplay:getHeight()
        y = y + fidY + fidH + InfoDisplay.fieldInfoDisplay.labelTextOffsetY + InfoDisplay.fieldInfoDisplay.labelTextSize
    end

    return x, y
end
