
if not config.npcs then
AddEventHandler('populationPedCreating', function(px, py, pz, model, setters)
        CancelEvent()
end)

CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetVehiclePopulationBudget(0)
        SetPedPopulationBudget(0)
        SetGarbageTrucks(false)                                 
        SetRandomBoats(false)                                
        SetCreateRandomCops(false)                            
        SetCreateRandomCopsNotOnScenarios(false)                
        SetCreateRandomCopsOnScenarios(false) 
        SetParkedVehicleDensityMultiplierThisFrame(0.0)
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
        SetVehicleDensityMultiplierThisFrame(0.0)
        SetPedDensityMultiplierThisFrame(0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)                 
    end
end)

end
