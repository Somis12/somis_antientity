local RADIUS = 5.0
local entityWL = {}

exports('whitelist_entity', function(src, model, x, y, z)
    src = tonumber(src)
    if not src then return end

    local hash = type(model) == 'string' and GetHashKey(model) or model

    entityWL[src] = entityWL[src] or {}
    entityWL[src][hash] = entityWL[src][hash] or {}
    table.insert(entityWL[src][hash], vector3(x, y, z))
end)

exports('clear_player_whitelists', function(src)
    entityWL[src] = nil
end)

AddEventHandler('entityCreating', function(entity)
    if not DoesEntityExist(entity) then return end

    local owner = NetworkGetEntityOwner(entity)
    if not owner then return end

    local model     = GetEntityModel(entity)
    local entPos    = vector3(table.unpack(GetEntityCoords(entity)))
    local popType   = GetEntityPopulationType(entity)
    local entType   = GetEntityType(entity)

    local playerPed = GetPlayerPed(owner)
    local playerPos = vector3(0.0, 0.0, 0.0)
    if playerPed > 0 then
        playerPos = vector3(table.unpack(GetEntityCoords(playerPed)))
    end

    local distance = #(entPos - playerPos)

    if not config.npcs then
        if (entType == 1 or entType == 2) and popType == 5 then
            if distance > RADIUS then
                DropPlayer(owner, "cheating")
                return
            else
                DeleteEntity(entity)
                return
            end
        end
    else
        if (entType == 2 and (popType == 4 or popType == 5 or popType == 2)) or
           (entType == 1 and (popType == 4 or popType == 5 or popType == 0)) then
            return
        end
    end

    local allowed = false
    if entityWL[owner] and entityWL[owner][model] then
        for i = #entityWL[owner][model], 1, -1 do
            local wlPos = entityWL[owner][model][i]
            if #(wlPos - entPos) <= RADIUS then
                table.remove(entityWL[owner][model], i)
                if #entityWL[owner][model] == 0 then entityWL[owner][model] = nil end
                allowed = true
                break
            end
        end
    end

    if allowed then return end

    SetTimeout(100, function()
        if not DoesEntityExist(entity) then return end

        local script = GetEntityScript(entity) or "none"
        local name   = GetPlayerName(owner) or "Unknown"

        print(string.format(
            "^1[ANTICHEAT] Blocked spawn -> %s (ID:%d) | Model: %s (%d) | Type: %d | Pop: %d | Script: %s | Dist: %.1fm | Coords: %.2f %.2f %.2f^0",
            name, owner, model, model, entType, popType, script, distance, entPos.x, entPos.y, entPos.z
        ))

        DeleteEntity(entity)
    end)
end)