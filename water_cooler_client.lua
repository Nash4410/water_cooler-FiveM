local IsAnimated = false
local Cooldown = false

Citizen.CreateThread(function()
    while true do
        local Timer = 750

        for k,v in pairs(cfg_water_cooler.props) do
            local objectId = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 0.7, GetHashKey(v), false)
            local waterCoolerPos = GetEntityCoords(objectId)
            
            if DoesEntityExist(objectId) and not IsDead then
                Timer = 1   

                local onScreen, _x, _y = World3dToScreen2d(waterCoolerPos.x, waterCoolerPos.y, waterCoolerPos.z + 0.9)
                
                if not onScreen then return end

                local px, py, pz = table.unpack(GetGameplayCamCoord())
                local scale = ((1 / GetDistanceBetweenCoords(px, py, pz, waterCoolerPos.x, waterCoolerPos.y, waterCoolerPos.z + 0.9, 1)) * 2) * (1 / GetGameplayCamFov()) * 100

                SetTextScale(0.0 * scale, 0.5 * scale)
                SetTextFont(1)
                SetTextCentre(true)

                local height = GetTextScaleHeight(0.55 * scale, 4)
                local width = EndTextCommandGetWidth(4)

                SetTextEntry("STRING")
                AddTextComponentString("Appuyez sur ~b~E~s~ pour interagir")
                EndTextCommandDisplayText(_x, _y)
                
                if IsControlJustPressed(1,51) then
                    if not IsAnimated then
                        if(not Cooldown)then
                            IsAnimated = true
                            TriggerEvent('esx_basicneeds:onDrink', 'prop_cs_paper_cup', 0.10, -0.02, 0.03, -100.0, 0.0, -30.0)
                            Wait(1500)
                            TriggerEvent('esx_status:add', 'thirst', 80000)
                            Wait(1600)
                            IsAnimated = false
                            Cooldown = true
                            Citizen.SetTimeout(120000, function()
                                Cooldown = false
                            end)
                        else
                            ESX.ShowNotification("~r~Vous devez patienter avant de pouvoir réutiliser la machine")
                        end
                    end

                end   
            end
        end
       Citizen.Wait(Timer)
    end
end)

print("Script water cooler par Nash44 :)")
