---${title}

---@author ${author}
---@version r_version_r
---@date 25/11/2020

---@class TrunkHud : RoyalHudControl
TrunkHud = {}
TrunkHud_mt = Class(TrunkHud, RoyalHudControl)

---@return TrunkHud
function TrunkHud:new()
    local width, height = 340, (28 * 5) + 24
    local rowWidth, rowHeight = width - 48, 28
    local rowContainerWidth, rowContainerHeight = rowWidth, height - 24
    local style = RoyalHudStyles.getStyle(InfoDisplayStyle, FS19Style)
    
    ---@type TrunkHud
    local hud = RoyalHudControl:new("TrunkHud", 1 - g_safeFrameOffsetX, 0 + g_safeFrameOffsetY, width, height, style, nil, TrunkHud_mt)
    hud:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_RIGHT)
    hud.panel = RoyalHudPanel:new("TrunkHudPanel", 0.5, 0.5, width, height, style, hud)
    hud.title = RoyalHudText:new("title", string.upper(g_i18n:getText("id_trunkHudTitle")), 20, true, 0, height - 2, hud)
    hud.title:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)

    hud.rowContainer = RoyalHud:new("rc", 0.5, 0.5, rowContainerWidth, rowContainerHeight, hud)

    hud.row1 = hud:createRow(rowContainerHeight - (rowHeight * 0), rowWidth, rowHeight, g_i18n:getText("id_name"), hud.rowContainer)
    hud:createSeparator(rowWidth, hud.row1)
    hud.row2 = hud:createRow(rowContainerHeight - (rowHeight * 1), rowWidth, rowHeight, g_i18n:getText("id_size"), hud.rowContainer)
    hud:createSeparator(rowWidth, hud.row2)
    hud.row3 = hud:createRow(rowContainerHeight - (rowHeight * 2), rowWidth, rowHeight, g_i18n:getText("id_price"), hud.rowContainer)
    hud:createSeparator(rowWidth, hud.row3)
    hud.row4 = hud:createRow(rowContainerHeight - (rowHeight * 3), rowWidth, rowHeight, g_i18n:getText("id_woodChips"), hud.rowContainer)
    hud:createSeparator(rowWidth, hud.row4)
    hud.row5 = hud:createRow(rowContainerHeight - (rowHeight * 4), rowWidth, rowHeight, g_i18n:getText("id_mass"), hud.rowContainer)

    return hud
end

function TrunkHud:createRow(y, width, height, title, parent)
    local row = RoyalHud:new("row", 0, y, width, height, parent)
    row:setAlignment(RoyalHud.ALIGNS_VERTICAL_TOP, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    row.title = RoyalHudText:new("row_title", title, 17, true, 0, 0, row)
    row.title:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    row.title:setOffset(1, 1)
    row.text = RoyalHudText:new("row_text", "N/D", 16, false, 1, 0, row)
    row.text:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_RIGHT)
    row.text:setOffset(-1, 1)
    return row
end

function TrunkHud:createSeparator(width, parent)
    local separator = RoyalHudOverlay:new("row_separator", 0, 0, width, 1, parent)
    separator:setColor({1, 1, 1, 0.3})
    separator:setAlignment(RoyalHud.ALIGNS_VERTICAL_MIDDLE, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    separator:setOffset(nil, -1)
    return separator
end

function TrunkHud:setData(data)
    if data ~= nil then
        self.row1.text:setText(data.localizedName)
        self.row2.text:setText(string.format("%.1fm %.1fm %.1fm", data.x, data.y, data.z))
        self.row3.text:setText(string.format("%.0f €", data.price))
        self.row4.text:setText(string.format("%.0f l", data.woodChips))
        self.row5.text:setText(string.format("%.1f kg", data.mass))
    end
end

function TrunkHud:getRenderPosition()
    local x, y = TrunkHud:superClass().getRenderPosition(self)

    -- hud offset to prevent overlap with FieldInfoDisplay
    if InfoDisplay.fieldInfoDisplay ~= nil and InfoDisplay.fieldInfoDisplay.isEnabled and InfoDisplay.fieldInfoDisplay:getVisible() then
        local _, fidY = InfoDisplay.fieldInfoDisplay:getPosition()
        local fidH = InfoDisplay.fieldInfoDisplay:getHeight()
        y = y + fidY + fidH + InfoDisplay.fieldInfoDisplay.labelTextOffsetY + InfoDisplay.fieldInfoDisplay.labelTextSize
    end

    return x, y
end
