---${title}

---@author ${author}
---@version r_version_r
---@date 12/11/2020

FieldInfoDisplayExtension = {}

function FieldInfoDisplayExtension.new(superFunc, hudAtlasPath, l10n, fruitTypeManager, currentMission, farmManager, farmlandManager)
    local display = superFunc(hudAtlasPath, l10n, fruitTypeManager, currentMission, farmManager, farmlandManager)
    InfoDisplay.fieldInfoDisplay = display
    return display
end

Utility.overwrittenStaticFunction(FieldInfoDisplay, "new", FieldInfoDisplayExtension.new)
