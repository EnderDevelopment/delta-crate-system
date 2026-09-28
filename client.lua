local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while true do
        Citizen.Wait(1000)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, crateModel in ipairs(Config.CrateModels) do
            if math.random() < Config.CrateSpawnChance then
                local spawnCoords = GetOffsetFromEntityInWorldCoords(playerPed, math.random(-50, 50), math.random(-50, 50), 0)
                local crate = CreateObject(GetHashKey(crateModel), spawnCoords.x, spawnCoords.y, spawnCoords.z, true, true, true)
                SetEntityAsMissionEntity(crate, true, true)
                TriggerServerEvent('delta:registerCrate', crateModel, spawnCoords.x, spawnCoords.y, spawnCoords.z)

                if math.random() < Config.AISpawnChance then
                    local aiModel = Config.AIModels[math.random(#Config.AIModels)]
                    RequestModel(GetHashKey(aiModel))
                    while not HasModelLoaded(GetHashKey(aiModel)) do
                        Citizen.Wait(0)
                    end
                    local aiPed = CreatePed(4, GetHashKey(aiModel), spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, true)
                    SetPedCombatAttributes(aiPed, 46, true)
                    SetPedFleeAttributes(aiPed, 0, false)
                    SetPedAsEnemy(aiPed, true)
                    SetPedCombatAbility(aiPed, 100)
                    SetPedCombatRange(aiPed, 2)
                    SetPedCombatMovement(aiPed, 3)
                    SetPedCombatAttributes(aiPed, 5, true)
                    SetPedSeeingRange(aiPed, 100.0)
                    SetPedHearingRange(aiPed, 100.0)
                    SetPedAlertness(aiPed, 3)
                    SetPedAccuracy(aiPed, 100)
                    SetPedDropsWeaponsWhenDead(aiPed, false)
                    SetPedFleeAttributes(aiPed, 0, false)
                    SetPedRelationshipGroupHash(aiPed, GetHashKey('HATES_PLAYER'))
                    SetRelationshipBetweenGroups(5, GetHashKey('HATES_PLAYER'), GetHashKey('PLAYER'))
                    SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'), GetHashKey('HATES_PLAYER'))
                    TriggerServerEvent('delta:registerAI', aiModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, crate)
                end
            end
        end
    end
end)

RegisterNetEvent('delta:removeCrate')
AddEventHandler('delta:removeCrate', function(crate)
    DeleteEntity(crate)
end)

RegisterNetEvent('delta:removeAI')
AddEventHandler('delta:removeAI', function(aiPed)
    DeleteEntity(aiPed)
end)