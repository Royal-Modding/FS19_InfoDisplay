--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 09/11/2020

PlayerExtension = {}
PlayerExtension.huds = {}

function PlayerExtension:update(superFunc, dt)
    superFunc(self, dt)
    if self.isEntered then
        self.renderInfo = self.foundInfo and self.infoObject ~= nil
        self.renderInfoDebug = self.foundInfo and PlayerExtension.infoObjectDebug ~= nil
    end
end

function PlayerExtension:draw(superFunc)
    superFunc(self)
    if self.isEntered then
        if self.renderInfo and self.infoObject ~= nil then
            if InfoDisplay.debug then
                Utility.renderTable(0.1, 0.95, 0.009, self.infoObject, 3, true)
            end
            if PlayerExtension.huds[self.infoObject.type] ~= nil then
                PlayerExtension.huds[self.infoObject.type]:render()
            end
        end
        if self.renderInfoDebug then
            Utility.renderTable(0.1, 0.95, 0.009, PlayerExtension.infoObjectDebug, 1, true)
        end
    end
end

function PlayerExtension:updateTick(superFunc, dt)
    superFunc(self, dt)
    if self.isEntered then
        local x, y, z = localToWorld(self.cameraNode, 0, 0, 1.0)
        local dx, dy, dz = localDirectionToWorld(self.cameraNode, 0, 0, -1)
        self.foundInfo = false
        raycastAll(x, y, z, dx, dy, dz, "infoObjectRaycastCallback", 5, self)
    end
end

function PlayerExtension:infoObjectRaycastCallback(hitObjectId, _, _, _, _)
    if hitObjectId ~= self.rootNode then
        local id, _ = Utility.getObjectClass(hitObjectId)
        if id == ClassIds.SHAPE then
            self.foundInfo = true
            if hitObjectId ~= self.lastFoundInfoObjectId then
                self.lastFoundInfoObjectId = hitObjectId
                self.infoObject = PlayerExtension.getInfoObject(hitObjectId)
                if self.infoObject ~= nil then
                    if PlayerExtension.huds[self.infoObject.type] ~= nil then
                        PlayerExtension.huds[self.infoObject.type]:setData(self.infoObject)
                    end
                end
            end
            return false
        end
    end
    return true
end

function PlayerExtension.getInfoObject(objectId)
    PlayerExtension.infoObjectDebug = nil

    local object = g_currentMission:getNodeObject(objectId)
    if object ~= nil then
        local baleInfo = PlayerExtension.getBaleInfo(object, objectId)
        if baleInfo ~= nil then
            return baleInfo
        end
        local palletInfo = PlayerExtension.getPalletInfo(object, objectId)
        if palletInfo ~= nil then
            return palletInfo
        end
        local treeInfo = PlayerExtension.getPlaceableTreeInfo(object, objectId)
        if treeInfo ~= nil then
            return treeInfo
        end
    else
        local treeInfo = PlayerExtension.getTreeInfo(objectId)
        if treeInfo ~= nil then
            return treeInfo
        end
    end

    if InfoDisplay.debug then
        if object ~= nil then
            PlayerExtension.infoObjectDebug = object
        else
            PlayerExtension.infoObjectDebug = {objectId = objectId}
        end
    end
    return nil
end

function PlayerExtension.getBaleInfo(object, objectId)
    if object["baleValueScale"] ~= nil then
        local info = {}
        info.type = "BALE"
        info.mass = getMass(objectId)
        info.mass = info.mass * 1000
        info.fillLevel = object.fillLevel
        info.fillType = object.fillType
        info.baleValueScale = object.baleValueScale
        info.ownerFarmId = object.ownerFarmId
        info.canBeSold = object.canBeSold
        info.baleWidth = object.baleWidth
        info.wrappingState = object.wrappingState
        info.supportsWrapping = object.supportsWrapping
        if object.baleDiameter ~= nil then
            info.isRoundBale = true
            info.baleDiameter = object.baleDiameter
        else
            info.isRoundBale = false
            info.baleLength = object.baleLength
            info.baleHeight = object.baleHeight
        end
        return info
    end
    return nil
end

function PlayerExtension.getPalletInfo(object, objectId)
    if object["typeName"] ~= nil and object.typeName == "pallet" and object.spec_fillUnit ~= nil then
        local info = {}
        info.type = "PALLET"
        info.mass = getMass(objectId)
        info.mass = info.mass * 1000
        local fillUnit = object.spec_fillUnit.fillUnits[1]
        info.fillType = fillUnit.fillType
        info.fillLevel = fillUnit.fillLevel
        info.ownerFarmId = object:getOwnerFarmId()
        return info
    end
    return nil
end

function PlayerExtension.getPlaceableTreeInfo(object, _)
    if object.splitShapeFileId ~= nil and object.attachments ~= nil then
        local treeId = getParent(object.attachments)
        if getHasClassId(treeId, ClassIds.SHAPE) then
            return PlayerExtension.getTreeInfo(treeId)
        end
    end
    return nil
end

function PlayerExtension.getTreeInfo(objectId)
    if getSplitType(objectId) ~= 0 then
        local splitType = g_splitTypeManager:getSplitTypeByIndex(getSplitType(objectId))
        if splitType ~= nil then
            local info = {}
            info.mass = getMass(objectId)
            if info.mass == 1 then
                info.type = "TREE"
                info.mass = nil
                info.x, _, _, _, _ = getSplitShapeStats(objectId)
            else
                info.type = "TRUNK"
                info.mass = info.mass * 1000
                info.x, info.y, info.z, _, _ = getSplitShapeStats(objectId)
                info.volume = getVolume(objectId) * 1000
                info.pricePerLiter = splitType.pricePerLiter
                info.woodChipsPerLiter = splitType.pricePerLiter
            end
            info.splitType = splitType.splitType
            info.name = splitType.name
            info.localizedName = info.name
            local i18nKey = string.format("id_treeName%s", info.splitType)
            if g_i18n:hasText(i18nKey) then
                info.localizedName = g_i18n:getText(i18nKey)
            end
            return info
        end
    end
    return nil
end
