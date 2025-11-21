    No "5 entities per 10 seconds" garbage. No false positives. No bypasses.
    
    config = {}
    config.npcs = false   -- ONLY set true if you have real ambient walking/driving NPCs
                          -- Interactive/job peds are NOT affected by this setting

    Exports – Use these in ALL your scripts
    ────────────────────────────────────────────────────────────────────────
    exports['somis_antientity']:whitelist_entity(source, model, x, y, z)
    exports['somis_antientity']:clear_player_whitelists(source)

    Simple Examples (server-side)
    ────────────────────────────────────────────────────────────────────────

    -- 1. Spawn Adder on the player
    [ server ]  -
    local src  = source
    local ped  = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    exports['somis_antientity']:whitelist_entity(src, "adder", coords.x, coords.y, coords.z)
    
    [ client ]  -
    local veh = CreateVehicle(GetHashKey("adder"), coords.x, coords.y, coords.z + 1.0, GetEntityHeading(ped), true, false)

    -- 2. Spawn a cigarette / prop on the player
    [ server ]  -
    local src  = source
    local ped  = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    exports['somis_antientity']:whitelist_entity(src, "prop_cigar_01", coords.x, coords.y, coords.z + 0.1)
    
     [ client ]  -
    local cig = CreateObject(GetHashKey("prop_cigar_01"), coords.x, coords.y, coords.z + 0.1, true, true, false)
    AttachEntityToEntity(cig, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 2, true)

    -- 3. Clear whitelists on disconnect / job change
    AddEventHandler('playerDropped', function()
        exports['somis_antientity']:clear_player_whitelists(source)
    end)
