---${title}

---@author ${author}
---@version r_version_r
---@date 09/11/2020

PlayerExtension = {}
PlayerExtension.huds = {}

function PlayerExtension:update(superFunc, dt)
    superFunc(self, dt)
    if self.isEntered then
        self.renderInfo = self.foundInfoObject and self.raycastHitted
    end
end

function PlayerExtension:draw(superFunc)
    superFunc(self)
    if self.isEntered then
        if self.renderInfo then
            if InfoDisplay.debug then
                Utility.renderTable(0.1, 0.95, 0.009, self.infoObject, 3, false)
            end
            if PlayerExtension.huds[self.infoObject.type] ~= nil then
                PlayerExtension.huds[self.infoObject.type]:render()
            end
        else
            if InfoDisplay.debug and self.raycastHitted then
                Utility.renderTable(0.1, 0.95, 0.009, self.objectToDebug, 1, false)
            end
        end
    end
end

function PlayerExtension:updateTick(superFunc, dt)
    superFunc(self, dt)
    if self.isEntered then
        local x, y, z = localToWorld(self.cameraNode, 0, 0, 1.0)
        local dx, dy, dz = localDirectionToWorld(self.cameraNode, 0, 0, -1)
        self.raycastHitted = false
        self.foundInfoObject = false
        self.objectToDebug = nil
        raycastAll(x, y, z, dx, dy, dz, "infoObjectRaycastCallback", 6, self)
    end
end

function PlayerExtension:infoObjectRaycastCallback(hitObjectId, _, _, _, _)
    if hitObjectId ~= self.rootNode then
        local id, _ = Utility.getObjectClass(hitObjectId)
        if id == ClassIds.SHAPE then
            self.raycastHitted = true
            if self.objectToDebug == nil and InfoDisplay.debug then
                self.objectToDebug = PlayerExtension.getInfoObjectDebug(hitObjectId)
            end

            if hitObjectId ~= self.lastValidInfoObjectId then
                local infoObject = PlayerExtension.getInfoObject(hitObjectId)
                if infoObject ~= nil then
                    -- valid info object found
                    if PlayerExtension.huds[infoObject.type] ~= nil then
                        PlayerExtension.huds[infoObject.type]:setData(infoObject)
                    end
                    self.infoObject = infoObject
                    self.lastValidInfoObjectId = hitObjectId
                    self.foundInfoObject = true
                    return false -- stop raycast
                end
            else
                -- valid info object found previously
                self.foundInfoObject = true
                return false -- stop raycast
            end
        end
    end
    return true -- continue raycast
end

function PlayerExtension.getInfoObject(objectId)
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
        local vehicleInfo = PlayerExtension.getVehicleInfo(object, objectId)
        if vehicleInfo ~= nil then
            return vehicleInfo
        end
    else
        local treeInfo = PlayerExtension.getTreeInfo(objectId)
        if treeInfo ~= nil then
            return treeInfo
        end
    end
    return nil
end

function PlayerExtension.getInfoObjectDebug(objectId)
    local object = g_currentMission:getNodeObject(objectId)
    if object ~= nil then
        return object
    else
        return {objectId = objectId}
    end
end

function PlayerExtension.getBaleInfo(object, objectId)
    if object["baleValueScale"] ~= nil then
        local info = {}
        info.type = "BALE"
        info.mass = PlayerExtension.getMass(objectId)
        if info.mass <= 0 then
            return nil
        end
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

function PlayerExtension.getPalletInfo(object, _)
    if object["typeName"] ~= nil and string.find(string.lower(object.typeName), "pallet") and object.spec_fillUnit ~= nil then
        local info = {}
        info.type = "PALLET"
        info.mass = PlayerExtension.getMass(object)
        local fillUnit = object.spec_fillUnit.fillUnits[1]
        info.fillType = fillUnit.fillType
        info.fillLevel = fillUnit.fillLevel
        info.ownerFarmId = object:getOwnerFarmId()
        return info
    end
    return nil
end

function PlayerExtension.getVehicleInfo(object, _)
    if object["typeName"] ~= nil and object.spec_wearable ~= nil then
        local info = {}
        info.type = "VEHICLE"
        info.mass = PlayerExtension.getMass(object)
        info.condition = (1 - object:getWearTotalAmount()) * 100
        info.damage = object:getVehicleDamage() * 100
        info.ownerFarmId = object:getOwnerFarmId()
        info.name = object:getName()
        local storeItem = g_storeManager:getItemByXMLFilename(object.configFileName)
        if storeItem ~= nil then
            local brand = g_brandManager:getBrandByIndex(storeItem.brandIndex)
            if brand ~= nil then
                info.name = string.format("%s %s", brand.title, info.name)
            end
        end
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
            info.x, info.y, info.z, info.numConvexes, info.numAttachments = getSplitShapeStats(objectId)
            if info.numAttachments >= 10 then
                info.type = "TREE"
                info.growth = 100
                -- they doesn't save the "collision" id ç_ç
                local searchNode = objectId - 2
                local searchOrigSplitShape = objectId - 1
                local gi =
                    TableUtility.f_find(
                    g_treePlantManager.treesData.growingTrees,
                    function(e)
                        return e.node == searchNode and e.origSplitShape == searchOrigSplitShape
                    end
                )
                if gi ~= nil then
                    info.growth = gi.growthState * 100
                end
            else
                info.type = "TRUNK"
                info.mass = PlayerExtension.getMass(objectId)
                if info.mass <= 0 then
                    return nil
                end
                info.volume = getVolume(objectId) * 1000
                info.pricePerLiter = splitType.pricePerLiter
                info.woodChipsPerLiter = splitType.pricePerLiter
                info.woodChips = info.volume * info.woodChipsPerLiter
                info.price, info.qualityScale, info.defoliageScale, info.lengthScale = Utility.getTrunkValue(objectId, splitType)
                if g_firewood ~= nil then
                    info.firewood = g_firewood.FirewoodTool.getChoppingVolume(info.volume) or -1
                end
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

function PlayerExtension.getMass(object)
    if type(object) == "number" then
        if g_server ~= nil then
            return getMass(object) * 1000
        else
            if g_currentMission.player ~= nil then
                return (g_currentMission.player.lastFoundObjectMass or 0) * 1000
            end
        end
    else
        if object.getTotalMass ~= nil then
            if g_server ~= nil then
                return object:getTotalMass(true) * 1000
            else
                return (object:getTotalMass(true) + object.serverMass) * 1000
            end
            return 0
        end
    end
end
