---${title}

---@author ${author}
---@version r_version_r
---@date 09/11/2020

InitRoyalUtility(Utils.getFilename("lib/utility/", g_currentModDirectory))
InitRoyalHud(Utils.getFilename("lib/hud/", g_currentModDirectory))
InitRoyalMod(Utils.getFilename("lib/rmod/", g_currentModDirectory))

---@class InfoDisplay : RoyalMod
InfoDisplay = RoyalMod.new(r_debug_r, false)
InfoDisplay.fieldInfoDisplay = nil

function InfoDisplay:initialize()
    if g_screenHeight >= 2160 then
        InfoDisplay.hudAtlasPath = Utils.getFilename("huds/hud_atlas_2048.dds", self.directory)
    elseif g_screenHeight >= 1080 then
        InfoDisplay.hudAtlasPath = Utils.getFilename("huds/hud_atlas_1024.dds", self.directory)
    else
        InfoDisplay.hudAtlasPath = Utils.getFilename("huds/hud_atlas_512.dds", self.directory)
    end
end

function InfoDisplay:onValidateVehicleTypes(vehicleTypeManager, addSpecialization, addSpecializationBySpecialization, addSpecializationByVehicleType, addSpecializationByFunction)
end

function InfoDisplay:onMissionInitialize(baseDirectory, missionCollaborators)
end

function InfoDisplay:onSetMissionInfo(missionInfo, missionDynamicInfo)
end

function InfoDisplay:onLoad()
end

function InfoDisplay:onPreLoadMap(mapFile)
end

function InfoDisplay:onCreateStartPoint(startPointNode)
end

function InfoDisplay:onLoadMap(mapNode, mapFile)
    if Player.update ~= nil then
        Player.update = Utils.overwrittenFunction(Player.update, PlayerExtension.update)
    end
    if Player.draw ~= nil then
        Player.draw = Utils.overwrittenFunction(Player.draw, PlayerExtension.draw)
    end
    if Player.updateTick ~= nil then
        Player.updateTick = Utils.overwrittenFunction(Player.updateTick, PlayerExtension.updateTick)
    end
    if Player.infoObjectRaycastCallback == nil then
        Player.infoObjectRaycastCallback = PlayerExtension.infoObjectRaycastCallback
    end

    ---@type BaleHud
    PlayerExtension.huds["BALE"] = BaleHud:new()
    ---@type TreeHud
    PlayerExtension.huds["TREE"] = TreeHud:new()
    ---@type TrunkHud
    PlayerExtension.huds["TRUNK"] = TrunkHud:new()
    ---@type PalletHud
    PlayerExtension.huds["PALLET"] = PalletHud:new()
    ---@type VehicleHud
    PlayerExtension.huds["VEHICLE"] = VehicleHud:new()
end

function InfoDisplay:onPostLoadMap(mapNode, mapFile)
end

function InfoDisplay:onLoadSavegame(savegameDirectory, savegameIndex)
end

function InfoDisplay:onPreLoadVehicles(xmlFile, resetVehicles)
end

function InfoDisplay:onPreLoadItems(xmlFile)
end

function InfoDisplay:onPreLoadOnCreateLoadedObjects(xmlFile)
end

function InfoDisplay:onLoadFinished()
end

function InfoDisplay:onStartMission()
    PlayerExtension.huds["BALE"]:loadFillIcons()
    PlayerExtension.huds["PALLET"]:loadFillIcons()
end

function InfoDisplay:onMissionStarted()
end

function InfoDisplay:onWriteStream(streamId)
end

function InfoDisplay:onReadStream(streamId)
end

function InfoDisplay:onUpdate(dt)
end

function InfoDisplay:onUpdateTick(dt)
end

function InfoDisplay:onWriteUpdateStream(streamId, connection, dirtyMask)
end

function InfoDisplay:onReadUpdateStream(streamId, timestamp, connection)
end

function InfoDisplay:onMouseEvent(posX, posY, isDown, isUp, button)
end

function InfoDisplay:onKeyEvent(unicode, sym, modifier, isDown)
end

function InfoDisplay:onDraw()
end

function InfoDisplay:onPreSaveSavegame(savegameDirectory, savegameIndex)
end

function InfoDisplay:onPostSaveSavegame(savegameDirectory, savegameIndex)
end

function InfoDisplay:onPreDeleteMap()
end

function InfoDisplay:onDeleteMap()
end

function InfoDisplay:onLoadHelpLine()
    --return self.directory .. "gui/helpLine.xml"
end
