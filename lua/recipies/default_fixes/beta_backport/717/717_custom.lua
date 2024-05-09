-- Copyright (c) Anatoly Raev, 2024. All right reserved
-- 
-- Unauthorized copying of any file in this repository, via any medium is strictly prohibited. 
-- All rights reserved by the Civil Code of the Russian Federation, Chapter 70.
-- Proprietary and confidential.
-- ------------
-- Авторские права принадлежат Раеву Анатолию Анатольевичу.
-- 
-- Копирование любого файла, через любой носитель абсолютно запрещено.
-- Все авторские права защищены на основании ГК РФ Глава 70.
-- Автор оставляет за собой право на защиту своих авторских прав согласно законам Российской Федерации.
MEL.DefineRecipe("717_custom", "gmod_subway_81-717_mvm_custom")
RECIPE.BackportPriority = 6

function RECIPE:Inject(ent, ent_class)
    MEL.FindSpawnerField(ent_class, "Scheme")[MEL.Constants.Spawner.List.ELEMENTS] = function()
        local Schemes = {}
        for k, v in pairs(Metrostroi.Skins["717_new_schemes"] or {}) do
            Schemes[k] = v.name or k
        end
        return Schemes
    end

    MEL.FindSpawnerField(ent_class, "Announcer")[MEL.Constants.Spawner.List.ELEMENTS] = function()
        local Announcer = {}
        for k, v in pairs(Metrostroi.AnnouncementsASNP or {}) do
            Announcer[k] = v.name or k
        end
        return Announcer
    end

    MEL.FindSpawnerField(ent, "SpawnMode")[MEL.Constants.Spawner.List.WAGON_CALLBACK] = function(wagon, val, rot, i, wagnum, rclk)
        if rclk then return end
        if wagon._SpawnerStarted ~= val then
            wagon.VB:TriggerInput("Set", val <= 2 and 1 or 0)
            wagon.ParkingBrake:TriggerInput("Set", val == 3 and 1 or 0)
            if wagon.AR63 then
                local first = i == 1 or _LastSpawner ~= CurTime()
                wagon.A53:TriggerInput("Set", val <= 2 and 1 or 0)
                wagon.A49:TriggerInput("Set", val <= 2 and 1 or 0)
                wagon.AR63:TriggerInput("Set", val <= 2 and 1 or 0)
                wagon.R_UNch:TriggerInput("Set", val == 1 and 1 or 0)
                wagon.R_Radio:TriggerInput("Set", val == 1 and 1 or 0)
                wagon.BPSNon:TriggerInput("Set", (val == 1 and first) and 1 or 0)
                wagon.VMK:TriggerInput("Set", (val == 1 and first) and 1 or 0)
                wagon.ARS:TriggerInput("Set", (wagon.Plombs.RC1 and val == 1 and first) and 1 or 0)
                wagon.ALS:TriggerInput("Set", val == 1 and 1 or 0)
                wagon.L_1:TriggerInput("Set", val == 1 and 1 or 0)
                wagon.L_4:TriggerInput("Set", val == 1 and 1 or 0)
                wagon.EPK:TriggerInput("Set", (wagon.Plombs.RC1 and val == 1) and 1 or 0)
                wagon.DriverValveDisconnect:TriggerInput("Set", (val == 4 and first) and 1 or 0)
                _LastSpawner = CurTime()
                wagon.CabinDoor = val == 4 and first
                wagon.PassengerDoor = val == 4
                wagon.RearDoor = val == 4
            else
                wagon.FrontDoor = val == 4
                wagon.RearDoor = val == 4
            end

            if val == 1 then
                timer.Simple(1, function()
                    if not IsValid(wagon) then return end
                    wagon.BV:TriggerInput("Enable", 1)
                end)
            end

            wagon.GV:TriggerInput("Set", val < 4 and 1 or 0)
            wagon._SpawnerStarted = val
        end

        wagon.Pneumatic.TrainLinePressure = val == 3 and math.random() * 4 or val == 2 and 4.5 + math.random() * 3 or 7.6 + math.random() * 0.6
        wagon.Pneumatic.BrakeLinePressure = val == 4 and 5.2 or val == 1 and 2.3 or math.min(wagon.Pneumatic.TrainLinePressure + 0.25, math.random() * 4)
        wagon.Pneumatic.WorkingChamberPressure = val == 3 and math.random() * 1.0 or val == 2 and 4.0 + math.random() * 1.0 or 5.2
    end
end

function RECIPE:InjectNeeded()
    if Metrostroi.Version > 1537278077 then return false end
    return true
end