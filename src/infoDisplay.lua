--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 09/11/2020

InfoDisplay = {}
InfoDisplay.name = "InfoDisplay"
InfoDisplay.debug = r_debug_r
InfoDisplay.fieldInfoDisplay = nil

if g_screenHeight >= 2160 then
    InfoDisplay.hudAtlasPath = Utils.getFilename("huds/hud_atlas_2048.dds", g_currentModDirectory)
elseif g_screenHeight >= 1080 then
    InfoDisplay.hudAtlasPath = Utils.getFilename("huds/hud_atlas_1024.dds", g_currentModDirectory)
else
    InfoDisplay.hudAtlasPath = Utils.getFilename("huds/hud_atlas_512.dds", g_currentModDirectory)
end

InitRoyalUtility(Utils.getFilename("lib/utility/", g_currentModDirectory))
InitRoyalHud(Utils.getFilename("lib/hud/", g_currentModDirectory))

function InfoDisplay:loadMap()
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
    PlayerExtension.huds["BALE"] = BaleHud:new()
    PlayerExtension.huds["TREE"] = TreeHud:new()
    PlayerExtension.huds["TRUNK"] = TrunkHud:new()
    PlayerExtension.huds["PALLET"] = PalletHud:new()
    PlayerExtension.huds["VEHICLE"] = VehicleHud:new()
end

function InfoDisplay:loadSavegame()
end

function InfoDisplay:saveSavegame()
end

function InfoDisplay:update(dt)
end

function InfoDisplay:mouseEvent(posX, posY, isDown, isUp, button)
end

function InfoDisplay:keyEvent(unicode, sym, modifier, isDown)
end

function InfoDisplay:draw()
end

function InfoDisplay:delete()
end

function InfoDisplay:deleteMap()
end

addModEventListener(InfoDisplay)
