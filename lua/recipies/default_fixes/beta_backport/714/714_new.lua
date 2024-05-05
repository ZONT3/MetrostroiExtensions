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
MEL.DefineRecipe("714_new", "gmod_subway_81-714_mvm")
RECIPE.BackportPriority = true
local Cpos = {0, 0.2, 0.4, 0.5, 0.6, 0.8, 1}
function RECIPE:Inject(ent)
    function ent.InitializeSystems(wagon)
        -- Электросистема 81-710
        wagon:LoadSystem("Electric", "81_714_Electric_EXT")
        -- Токоприёмник
        wagon:LoadSystem("TR", "TR_3B")
        -- Электротяговые двигатели
        wagon:LoadSystem("Engines", "DK_117DM")
        -- Резисторы для реостата/пусковых сопротивлений
        wagon:LoadSystem("KF_47A", "KF_47A1")
        -- Резисторы для ослабления возбуждения
        wagon:LoadSystem("KF_50A")
        -- Ящик с предохранителями
        wagon:LoadSystem("YAP_57")
        -- Реостатный контроллер для управления пусковыми сопротивления
        wagon:LoadSystem("Reverser", "PR_722D")
        wagon:LoadSystem("RheostatController", "EKG_17B")
        -- Групповой переключатель положений
        wagon:LoadSystem("PositionSwitch", "PKG_761")
        -- Ящики с реле и контакторами
        wagon:LoadSystem("BV", "BV_630")
        wagon:LoadSystem("LK_755A")
        wagon:LoadSystem("YAR_13B")
        wagon:LoadSystem("YAR_27_EXT", nil, "MSK")
        wagon:LoadSystem("YAK_36")
        wagon:LoadSystem("YAK_37E")
        wagon:LoadSystem("YAS_44V")
        wagon:LoadSystem("YARD_2")
        wagon:LoadSystem("Horn")
        wagon:LoadSystem("IGLA_PCBK")
        -- Панель управления 81-710
        wagon:LoadSystem("Panel", "81_714_Panel")
        -- Пневмосистема 81-710
        wagon:LoadSystem("Pneumatic", "81_717_Pneumatic_EXT", {
            br013_1 = true
        })

        -- Everything else
        wagon:LoadSystem("Battery")
        wagon:LoadSystem("PowerSupply", "BPSN_EXT")
        wagon:LoadSystem("Announcer", "81_71_Announcer")
    end

    if CLIENT then
        ent.Lights = {
            -- Interior
            [11] = {
                "dynamiclight",
                Vector(200, 0, 0),
                Angle(0, 0, 0),
                Color(255, 245, 245),
                brightness = 3,
                distance = 400,
                fov = 180,
                farz = 128,
                changable = true
            },
            [12] = {
                "dynamiclight",
                Vector(0, 0, 0),
                Angle(0, 0, 0),
                Color(255, 245, 245),
                brightness = 3,
                distance = 400,
                fov = 180,
                farz = 128,
                changable = true
            },
            [13] = {
                "dynamiclight",
                Vector(-200, 0, 0),
                Angle(0, 0, 0),
                Color(255, 245, 245),
                brightness = 3,
                distance = 400,
                fov = 180,
                farz = 128,
                changable = true
            },
            -- Side lights
            [15] = {
                "light",
                Vector(-52, 67, 45.5) + Vector(0, 0.9, 3.25),
                Angle(0, 0, 0),
                Color(254, 254, 254),
                brightness = 0.1,
                scale = 0.2,
                texture = "sprites/light_glow02",
                size = 1.5
            },
            [16] = {
                "light",
                Vector(-52, 67, 45.5) + Vector(0, 0.9, -0.02),
                Angle(0, 0, 0),
                Color(40, 240, 122),
                brightness = 0.1,
                scale = 0.2,
                texture = "sprites/light_glow02",
                size = 1.5
            },
            [17] = {
                "light",
                Vector(-52, 67, 45.5) + Vector(0, 0.9, -3.3),
                Angle(0, 0, 0),
                Color(254, 210, 18),
                brightness = 0.1,
                scale = 0.2,
                texture = "sprites/light_glow02",
                size = 1.5
            },
            [18] = {
                "light",
                Vector(39, -67, 45.5) + Vector(0, -0.9, 3.25),
                Angle(0, 0, 0),
                Color(254, 254, 254),
                brightness = 0.1,
                scale = 0.2,
                texture = "sprites/light_glow02",
                size = 1.5
            },
            [19] = {
                "light",
                Vector(39, -67, 45.5) + Vector(0, -0.9, -0.02),
                Angle(0, 0, 0),
                Color(40, 240, 122),
                brightness = 0.1,
                scale = 0.2,
                texture = "sprites/light_glow02",
                size = 1.5
            },
            [20] = {
                "light",
                Vector(39, -67, 45.5) + Vector(0, -0.9, -3.3),
                Angle(0, 0, 0),
                Color(254, 210, 18),
                brightness = 0.1,
                scale = 0.2,
                texture = "sprites/light_glow02",
                size = 1.5
            },
            [21] = {
                "light",
                Vector(-6.5, 67, 51.2) + Vector(3.25, 0.9, -0.02),
                Angle(0, 0, 0),
                Color(254, 254, 254),
                brightness = 0.1,
                scale = 0.2,
                texture = "sprites/light_glow02",
                size = 1.5
            },
            [22] = {
                "light",
                Vector(-6.5, 67, 51.2) + Vector(-0.06, 0.9, -0.02),
                Angle(0, 0, 0),
                Color(40, 240, 122),
                brightness = 0.1,
                scale = 0.2,
                texture = "sprites/light_glow02",
                size = 1.5
            },
            [23] = {
                "light",
                Vector(-6.5, 67, 51.2) + Vector(-3.33, 0.9, -0.02),
                Angle(0, 0, 0),
                Color(254, 210, 18),
                brightness = 0.1,
                scale = 0.2,
                texture = "sprites/light_glow02",
                size = 1.5
            },
            [24] = {
                "light",
                Vector(-6.5, -67, 51.2) + Vector(3.33, -0.9, -0.02),
                Angle(0, 0, 0),
                Color(254, 254, 254),
                brightness = 0.1,
                scale = 0.2,
                texture = "sprites/light_glow02",
                size = 1.5
            },
            [25] = {
                "light",
                Vector(-6.5, -67, 51.2) + Vector(0.06, -0.9, -0.02),
                Angle(0, 0, 0),
                Color(40, 240, 122),
                brightness = 0.1,
                scale = 0.2,
                texture = "sprites/light_glow02",
                size = 1.5
            },
            [26] = {
                "light",
                Vector(-6.5, -67, 51.2) + Vector(-3.28, -0.9, -0.02),
                Angle(0, 0, 0),
                Color(254, 210, 18),
                brightness = 0.1,
                scale = 0.2,
                texture = "sprites/light_glow02",
                size = 1.5
            },
        }

        function ent.Initialize(wagon)
            wagon.BaseClass.Initialize(wagon)
            wagon.CraneRamp = 0
            wagon.CraneLRamp = 0
            wagon.CraneRRamp = 0
            wagon.EmergencyBrakeValveRamp = 0
            wagon.ReleasedPdT = 0
            wagon.FrontLeak = 0
            wagon.RearLeak = 0
            wagon.VentG1 = 0
            wagon.VentG2 = 0
            wagon.Door1 = false
            wagon.Door2 = false
            wagon.ParkingBrake1 = true
            wagon.ParkingBrake2 = true
            wagon.DoorStates = {}
            wagon.DoorLoopStates = {}
            for i = 0, 3 do
                for k = 0, 1 do
                    wagon.DoorStates[(k == 1 and "DoorL" or "DoorR") .. i + 1] = false
                end
            end
        end

        function ent.Think(wagon)
            wagon.BaseClass.Think(wagon)
            if wagon.FirstTick ~= false and (not wagon.RenderClientEnts or wagon.CreatingCSEnts) then
                wagon.RKTimer = nil
                wagon.OldBPSNType = nil
                return
            end

            if wagon.Scheme ~= wagon:GetNW2Int("Scheme", 1) then
                wagon.PassSchemesDone = false
                wagon.Scheme = wagon:GetNW2Int("Scheme", 1)
            end

            if not wagon.PassSchemesDone and IsValid(wagon.ClientEnts.schemes) then
                local scheme = Metrostroi.Skins["717_new_schemes"] and Metrostroi.Skins["717_new_schemes"][wagon.Scheme]
                wagon.ClientEnts.schemes:SetSubMaterial(1, scheme and scheme[1])
                wagon.PassSchemesDone = true
            end

            local Bortlamp_w = wagon:Animate("Bortlamp_w", wagon:GetPackedBool("DoorsW") and 1 or 0, 0, 1, 16, false)
            local Bortlamp_g = wagon:Animate("Bortlamp_g", wagon:GetPackedBool("GRP") and 1 or 0, 0, 1, 16, false)
            local Bortlamp_y = wagon:Animate("Bortlamp_y", wagon:GetPackedBool("BrW") and 1 or 0, 0, 1, 16, false)
            wagon:ShowHideSmooth("bortlamp1_w", Bortlamp_w)
            wagon:ShowHideSmooth("bortlamp1_g", Bortlamp_g)
            wagon:ShowHideSmooth("bortlamp1_y", Bortlamp_y)
            wagon:ShowHideSmooth("bortlamp2_w", Bortlamp_w)
            wagon:ShowHideSmooth("bortlamp2_g", Bortlamp_g)
            wagon:ShowHideSmooth("bortlamp2_y", Bortlamp_y)
            wagon:ShowHideSmooth("bortlamp3_w", Bortlamp_w)
            wagon:ShowHideSmooth("bortlamp3_g", Bortlamp_g)
            wagon:ShowHideSmooth("bortlamp3_y", Bortlamp_y)
            wagon:ShowHideSmooth("bortlamp4_w", Bortlamp_w)
            wagon:ShowHideSmooth("bortlamp4_g", Bortlamp_g)
            wagon:ShowHideSmooth("bortlamp4_y", Bortlamp_y)
            wagon:SetLightPower(15, Bortlamp_w > 0, Bortlamp_w)
            wagon:SetLightPower(18, Bortlamp_w > 0, Bortlamp_w)
            wagon:SetLightPower(16, Bortlamp_g > 0, Bortlamp_g)
            wagon:SetLightPower(19, Bortlamp_g > 0, Bortlamp_g)
            wagon:SetLightPower(17, Bortlamp_y > 0, Bortlamp_y)
            wagon:SetLightPower(20, Bortlamp_y > 0, Bortlamp_y)
            local dot5 = wagon:GetNW2Bool("Dot5")
            local lvz = wagon:GetNW2Bool("LVZ")
            local custom = wagon:GetNW2Bool("Custom")
            local newSeats = wagon:GetNW2Bool("NewSeats")
            wagon:ShowHide("handrails_old", not dot5)
            wagon:ShowHide("handrails_new", dot5)
            wagon:ShowHide("seats_old", not newSeats)
            wagon:ShowHide("seats_new", newSeats)
            local capOpened = wagon:GetPackedBool("CouchCap")
            local c013 = wagon:GetPackedBool("Crane013")
            wagon:ShowHide("seats_old_cap_o", capOpened and not newSeats)
            wagon:ShowHide("seats_old_cap", not capOpened and not newSeats)
            wagon:ShowHide("seats_new_cap_o", capOpened and newSeats)
            wagon:ShowHide("seats_new_cap", not capOpened and newSeats)
            wagon:HidePanel("couch_cap", capOpened)
            wagon:HidePanel("couch_cap_o", not capOpened)
            wagon:HidePanel("AV_S", not capOpened)
            wagon:HidePanel("AV_T", not capOpened)
            -- wagon:HidePanel("Stopkran",not capOpened)
            wagon:ShowHide("otsek_cap_r", not capOpened)
            wagon:ShowHide("brake334", capOpened and not c013)
            wagon:ShowHide("brake013", capOpened and c013)
            wagon:ShowHide("brake_disconnect", capOpened)
            wagon:ShowHide("train_disconnect", capOpened)
            wagon:HidePanel("DriverValveBLTLDisconnect", not capOpened)
            wagon:HidePanel("Shunt", not capOpened)
            wagon:HidePanel("VU", not capOpened)
            wagon:Animate("brake_disconnect", wagon:GetPackedBool("DriverValveBLDisconnect") and 1 or 0, 0.25, 0, 4, false)
            wagon:Animate("train_disconnect", wagon:GetPackedBool("DriverValveTLDisconnect") and 1 or 0, 0.25, 0, 4, false)
            wagon:Animate("brake334", wagon:GetPackedRatio("CranePosition") / 5, 0.35, 0.65, 256, 24)
            wagon:Animate("brake013", Cpos[wagon:GetPackedRatio("CranePosition")] or 0, 0.03, 0.458, 256, 24)
            wagon:Animate("brake_line", wagon:GetPackedRatio("BLPressure"), 0.14, 0.875, 256, 2) --,,0.01)
            wagon:Animate("train_line", wagon:GetPackedRatio("TLPressure"), 0.14, 0.875, 256, 2) --,,0.01)
            wagon:Animate("brake_cylinder", wagon:GetPackedRatio("BCPressure"), 0.14, 0.875, 256, 2) --,,0.03)
            wagon:Animate("voltmeter", wagon:GetPackedRatio("BatteryVoltage"), 0.601, 0.400)
            wagon:Animate("ampermeter", 0.5 + wagon:GetPackedRatio("BatteryCurrent"), 0.604, 0.398)
            local typ = wagon:GetNW2Int("LampType", 1)
            if wagon.LampType ~= typ then
                wagon.LampType = typ
                for i = 1, 27 do
                    if i <= 13 then wagon:ShowHide("lamp1_" .. i, typ == 1) end
                    wagon:ShowHide("lamp2_" .. i, typ == 2)
                end

                wagon:ShowHide("lamps1", typ == 1)
                wagon:ShowHide("lamps2", typ == 2)
            end

            local activeLights = 0
            local maxLights
            if typ == 1 then
                for i = 1, 13 do
                    local colV = wagon:GetNW2Vector("lamp" .. i)
                    local col = Color(colV.x, colV.y, colV.z)
                    local state = wagon:Animate("Lamp1_" .. i, wagon:GetPackedBool("lightsActive" .. i) and 1 or 0, 0, 1, 6, false)
                    wagon:ShowHideSmooth("lamp1_" .. i, state, col)
                    activeLights = activeLights + state
                end

                maxLights = 13
            else
                for i = 1, 27 do
                    local colV = wagon:GetNW2Vector("lamp" .. i)
                    local col = Color(colV.x, colV.y, colV.z)
                    local state = wagon:Animate("Lamp2_" .. i, wagon:GetPackedBool("lightsActive" .. i) and 1 or 0, 0, 1, 6, false)
                    wagon:ShowHideSmooth("lamp2_" .. i, state, col)
                    activeLights = activeLights + state
                end

                maxLights = 27
            end

            for i = 11, 13 do
                local col = wagon:GetNW2Vector("lampD" .. i)
                if wagon.LightsOverride[i].vec ~= col then
                    wagon.LightsOverride[i].vec = col
                    wagon.LightsOverride[i][4] = Color(col.x, col.y, col.z)
                    wagon:SetLightPower(i, false)
                else
                    wagon:SetLightPower(i, activeLights > 0, activeLights / maxLights)
                end
            end

            local door1 = wagon:Animate("door1", wagon:GetPackedBool("FrontDoor") and 0.99 or 0, 0, 0.25, 4, 0.5)
            local door2 = wagon:Animate("door2", wagon:GetPackedBool("RearDoor") and (capOpened and 0.25 or 0.99) or 0, 0, 0.25, 4, 0.5)
            if wagon.Door1 ~= door1 > 0 then
                wagon.Door1 = door1 > 0
                wagon:PlayOnce("door1", "bass", wagon.Door1 and 1 or 0)
            end

            if wagon.Door2 ~= door2 > 0 then
                wagon.Door2 = door2 > 0
                wagon:PlayOnce("door2", "bass", wagon.Door2 and 1 or 0)
            end

            wagon:Animate("FrontBrake", wagon:GetNW2Bool("FbI") and 0 or 1, 0, 1, 3, false)
            wagon:Animate("FrontTrain", wagon:GetNW2Bool("FtI") and 1 or 0, 0, 1, 3, false)
            wagon:Animate("RearBrake", wagon:GetNW2Bool("RbI") and 0 or 1, 0, 1, 3, false)
            wagon:Animate("RearTrain", wagon:GetNW2Bool("RtI") and 1 or 0, 0, 1, 3, false)
            wagon:Animate("ParkingBrake", wagon:GetPackedBool("ParkingBrake") and 1 or 0, 1, 0, 3, false)
            -- Main switch
            if wagon.LastGVValue ~= wagon:GetPackedBool("GV") then
                wagon.ResetTime = CurTime() + 1.5
                wagon.LastGVValue = wagon:GetPackedBool("GV")
            end

            wagon:Animate("gv_wrench", wagon.LastGVValue and 1 or 0, 0.5, 0.9, 128, 1, false)
            wagon:ShowHideSmooth("gv_wrench", CurTime() < wagon.ResetTime and 1 or 0.1)
            if not wagon.DoorStates then wagon.DoorStates = {} end
            if not wagon.DoorLoopStates then wagon.DoorLoopStates = {} end
            for i = 0, 3 do
                for k = 0, 1 do
                    local st = k == 1 and "DoorL" or "DoorR"
                    local doorstate = wagon:GetPackedBool(st)
                    local id, sid = st .. i + 1, "door" .. i .. "x" .. k
                    local state = wagon:GetPackedRatio(id)
                    --print(state,wagon.DoorStates[state])
                    if (state ~= 1 and state ~= 0) ~= wagon.DoorStates[id] then
                        if doorstate and state < 1 or not doorstate and state > 0 then
                        else
                            if state > 0 then
                                wagon:PlayOnce(sid .. "o", "", 1, math.Rand(0.8, 1.2))
                            else
                                wagon:PlayOnce(sid .. "c", "", 1, math.Rand(0.8, 1.2))
                            end
                        end

                        wagon.DoorStates[id] = state ~= 1 and state ~= 0
                    end

                    if state ~= 1 and state ~= 0 then
                        wagon.DoorLoopStates[id] = math.Clamp((wagon.DoorLoopStates[id] or 0) + 2 * wagon.DeltaTime, 0, 1)
                    else
                        wagon.DoorLoopStates[id] = math.Clamp((wagon.DoorLoopStates[id] or 0) - 6 * wagon.DeltaTime, 0, 1)
                    end

                    wagon:SetSoundState(sid .. "r", wagon.DoorLoopStates[id], 0.8 + wagon.DoorLoopStates[id] * 0.2)
                    local n_l = "door" .. i .. "x" .. k --.."a"
                    --local n_r = "door"..i.."x"..k.."b"
                    local dlo = 1
                    --local dro = 1
                    if wagon.Anims[n_l] then
                        dlo = math.abs(state - (wagon.Anims[n_l] and wagon.Anims[n_l].oldival or 0))
                        if dlo <= 0 and wagon.Anims[n_l].oldspeed then dlo = wagon.Anims[n_l].oldspeed / 14 end
                    end

                    wagon:Animate(n_l, state, 0, 0.95, dlo * 14, false) --0.8 + (-0.2+0.4*math.random()),0)
                    --wagon:Animate(n_r,state,0,1, dlo*14,false)--0.8 + (-0.2+0.4*math.random()),0)
                end
            end

            local dT = wagon.DeltaTime
            local rollingi = math.min(1, wagon.TunnelCoeff + math.Clamp((wagon.StreetCoeff - 0.82) / 0.3, 0, 1))
            local rollings = math.max(wagon.TunnelCoeff * 0.6, wagon.StreetCoeff)
            local speed = wagon:GetPackedRatio("Speed") * 100.0
            local rol5 = math.Clamp(speed / 1, 0, 1) * (1 - math.Clamp((speed - 3) / 8, 0, 1))
            local rol10 = math.Clamp(speed / 12, 0, 1) * (1 - math.Clamp((speed - 25) / 8, 0, 1))
            local rol40p = Lerp((speed - 25) / 12, 0.6, 1)
            local rol40 = math.Clamp((speed - 23) / 8, 0, 1) * (1 - math.Clamp((speed - 55) / 8, 0, 1))
            local rol40p = Lerp((speed - 23) / 50, 0.6, 1)
            local rol70 = math.Clamp((speed - 50) / 8, 0, 1) * (1 - math.Clamp((speed - 72) / 5, 0, 1))
            local rol70p = Lerp(0.8 + (speed - 65) / 25 * 0.2, 0.8, 1.2)
            local rol80 = math.Clamp((speed - 70) / 5, 0, 1)
            local rol80p = Lerp(0.8 + (speed - 72) / 15 * 0.2, 0.8, 1.2)
            wagon:SetSoundState("rolling_5", math.min(1, rollingi * (1 - rollings) + rollings * 0.8) * rol5, 1)
            wagon:SetSoundState("rolling_10", rollingi * rol10, 1)
            wagon:SetSoundState("rolling_40", rollingi * rol40, rol40p)
            wagon:SetSoundState("rolling_70", rollingi * rol70, rol70p)
            wagon:SetSoundState("rolling_80", rollingi * rol80, rol80p)
            local rol10 = math.Clamp(speed / 15, 0, 1) * (1 - math.Clamp((speed - 18) / 35, 0, 1))
            local rol10p = Lerp((speed - 15) / 14, 0.6, 0.78)
            local rol40 = math.Clamp((speed - 18) / 35, 0, 1) * (1 - math.Clamp((speed - 55) / 40, 0, 1))
            local rol40p = Lerp((speed - 15) / 66, 0.6, 1.3)
            local rol70 = math.Clamp((speed - 55) / 20, 0, 1) --*(1-math.Clamp((speed-72)/5,0,1))
            local rol70p = Lerp((speed - 55) / 27, 0.78, 1.15)
            --local rol80 = math.Clamp((speed-70)/5,0,1)
            --local rol80p = Lerp(0.8+(speed-72)/15*0.2,0.8,1.2)
            wagon:SetSoundState("rolling_low", rol10 * rollings, rol10p) --15
            wagon:SetSoundState("rolling_medium2", rol40 * rollings, rol40p) --57
            --wagon:SetSoundState("rolling_medium1",0 or rol40*rollings,rol40p) --57
            wagon:SetSoundState("rolling_high2", rol70 * rollings, rol70p) --70
            wagon.ReleasedPdT = math.Clamp(wagon.ReleasedPdT + 2 * (-wagon:GetPackedRatio("BrakeCylinderPressure_dPdT", 0) - wagon.ReleasedPdT) * dT, 0, 1)
            local release1 = math.Clamp((wagon.ReleasedPdT - 0.1) / 0.8, 0, 1) ^ 2
            wagon:SetSoundState("release1", release1, 1)
            wagon:SetSoundState("release2", math.Clamp(0.3 - release1, 0, 0.3) / 0.3 * release1 / 0.3, 1.0)
            local parking_brake = wagon:GetPackedRatio("ParkingBrakePressure_dPdT", 0)
            local parking_brake_abs = math.Clamp(math.abs(parking_brake) - 0.3, 0, 1)
            if wagon.ParkingBrake1 ~= parking_brake < 1 then
                wagon.ParkingBrake1 = parking_brake < 1
                if wagon.ParkingBrake1 then wagon:PlayOnce("parking_brake_en", "bass", 1, 1) end
            end

            if wagon.ParkingBrake2 ~= parking_brake > -0.8 then
                wagon.ParkingBrake2 = parking_brake > -0.8
                if wagon.ParkingBrake2 then wagon:PlayOnce("parking_brake_rel", "bass", 0.6, 1) end
            end

            wagon:SetSoundState("parking_brake", parking_brake_abs, 1)
            wagon.FrontLeak = math.Clamp(wagon.FrontLeak + 10 * (-wagon:GetPackedRatio("FrontLeak") - wagon.FrontLeak) * dT, 0, 1)
            wagon.RearLeak = math.Clamp(wagon.RearLeak + 10 * (-wagon:GetPackedRatio("RearLeak") - wagon.RearLeak) * dT, 0, 1)
            wagon:SetSoundState("front_isolation", wagon.FrontLeak, 0.9 + 0.2 * wagon.FrontLeak)
            wagon:SetSoundState("rear_isolation", wagon.RearLeak, 0.9 + 0.2 * wagon.RearLeak)
            local ramp = wagon:GetPackedRatio("Crane_dPdT", 0)
            if c013 then
                if ramp > 0 then
                    wagon.CraneRamp = wagon.CraneRamp + (0.2 * ramp - wagon.CraneRamp) * dT
                else
                    wagon.CraneRamp = wagon.CraneRamp + (0.9 * ramp - wagon.CraneRamp) * dT
                end

                wagon.CraneRRamp = math.Clamp(wagon.CraneRRamp + 1.0 * (1 * ramp - wagon.CraneRRamp) * dT, 0, 1)
                wagon:SetSoundState("crane334_brake", 0, 1.0)
                wagon:SetSoundState("crane334_brake_reflection", 0, 1.0)
                wagon:SetSoundState("crane334_brake_slow", 0, 1.0)
                wagon:SetSoundState("crane334_release", 0, 1.0)
                wagon:SetSoundState("crane013_release", wagon.CraneRRamp ^ 1.5, 1.0)
                wagon:SetSoundState("crane013_brake", math.Clamp(-wagon.CraneRamp * 1.5 - 0.1, 0, 1) ^ 1.3, 1.0)
                local loudV = wagon:GetNW2Float("Crane013Loud", 0)
                if loudV > 0 then
                    if ramp > 0 then
                        wagon.CraneLRamp = wagon.CraneLRamp + (math.min(ramp, 0) - wagon.CraneLRamp) * dT * 0.5
                    else
                        wagon.CraneLRamp = wagon.CraneLRamp + (math.min(ramp, 0) - wagon.CraneLRamp) * dT * 1
                    end

                    wagon:SetSoundState("crane013_brake_l", math.Clamp(-wagon.CraneRamp * 2.5 - 0.1, 0, 1) ^ 1.3 * (1 - math.Clamp((-wagon.CraneLRamp - loudV) * 3, 0, 1)), 1.12 - math.Clamp((-wagon.CraneLRamp - 0.15) * 2, 0, 1) * 0.12)
                else
                    wagon:SetSoundState("crane013_brake_l", 0, 1)
                end

                wagon:SetSoundState("crane013_brake2", math.Clamp(-wagon.CraneRamp * 1.5 - 0.95, 0, 1.5) ^ 2, 1.0)
            else
                wagon:SetSoundState("crane013_brake", 0, 1.0)
                wagon:SetSoundState("crane013_release", 0, 1.0)
                --wagon:SetSoundState("crane013_brake2",0,1.0)
                wagon.CraneRamp = math.Clamp(wagon.CraneRamp + 8.0 * (1 * wagon:GetPackedRatio("Crane_dPdT", 0) - wagon.CraneRamp) * dT, -1, 1)
                wagon:SetSoundState("crane334_brake_low", math.Clamp(-wagon.CraneRamp * 2, 0, 1) ^ 2, 1)
                local high = math.Clamp((-wagon.CraneRamp - 0.5) / 0.5, 0, 1) ^ 1
                wagon:SetSoundState("crane334_brake_high", high, 1.0)
                wagon:SetSoundState("crane013_brake2", high * 2, 1.0)
                wagon:SetSoundState("crane334_brake_eq_high", --[[ math.Clamp(-wagon.CraneRamp*0,0,1)---]]
                    math.Clamp(-wagon:GetPackedRatio("ReservoirPressure_dPdT") - 0.2, 0, 1) ^ 0.8 * 1, 1)

                wagon:SetSoundState("crane334_brake_eq_low", --[[ math.Clamp(-wagon.CraneRamp*0,0,1)---]]
                    math.Clamp(-wagon:GetPackedRatio("ReservoirPressure_dPdT") - 0.4, 0, 1) ^ 0.8 * 1.3, 1)

                wagon:SetSoundState("crane334_release", math.Clamp(wagon.CraneRamp, 0, 1) ^ 2, 1.0)
            end

            local emergencyBrakeValve = wagon:GetPackedRatio("EmergencyBrakeValve_dPdT", 0)
            wagon.EmergencyBrakeValveRamp = math.Clamp(wagon.EmergencyBrakeValveRamp + (emergencyBrakeValve - wagon.EmergencyBrakeValveRamp) * dT * 8, 0, 1)
            wagon:SetSoundState("valve_brake", wagon.EmergencyBrakeValveRamp, 0.8 + math.min(0.4, wagon.EmergencyBrakeValveRamp * 0.8))
            -- Compressor
            wagon:SetSoundState("compressor", wagon:GetPackedBool("Compressor") and 0.6 or 0, 1)
            wagon:SetSoundState("compressor2", wagon:GetPackedBool("Compressor") and 0.8 or 0, 1)
            local v1state = wagon:GetPackedBool("M1_3") and 1 or 0
            local v2state = wagon:GetPackedBool("M4_7") and 1 or 0
            wagon.VentG1 = math.Clamp(wagon.VentG1 + dT / 2.7 * (v1state * 2 - 1), 0, 1)
            wagon.VentG2 = math.Clamp(wagon.VentG2 + dT / 2.7 * (v2state * 2 - 1), 0, 1)
            for i = 1, 8 do
                if i < 4 or i == 8 then
                    wagon:SetSoundState("vent" .. i, wagon.VentG1, 1)
                else
                    wagon:SetSoundState("vent" .. i, wagon.VentG2, 1)
                end
            end

            -- RK rotation
            if wagon:GetPackedBool("RK") then wagon.RKTimer = CurTime() end
            wagon:SetSoundState("rk", wagon.RKTimer and CurTime() - wagon.RKTimer < 0.2 and 0.7 or 0, 1)
            -- BPSN sound
            wagon.BPSNType = wagon:GetNW2Int("BPSNType", 13)
            if not wagon.OldBPSNType then wagon.OldBPSNType = wagon.BPSNType end
            if wagon.BPSNType ~= wagon.OldBPSNType then
                for i = 1, 12 do
                    wagon:SetSoundState("bpsn" .. i, 0, 1.0)
                end
            end

            wagon.OldBPSNType = wagon.BPSNType
            if wagon.BPSNType < 13 then
                wagon:SetSoundState("bpsn" .. wagon.BPSNType, wagon:GetPackedBool("BPSN") and 1 or 0, 1) --FIXME громкость по другому
            end

            local work = wagon:GetPackedBool("AnnPlay")
            local buzz = wagon:GetPackedBool("AnnBuzz") and wagon:GetNW2Int("AnnouncerBuzz", -1) > 0
            local buzz_old = wagon:GetNW2Int("AnnouncerBuzz", -1) == 2
            for k in ipairs(wagon.AnnouncerPositions) do
                wagon:SetSoundState("announcer_buzz" .. k, buzz and work and not buzz_old and 1 or 0, 1)
                wagon:SetSoundState("announcer_buzz_o" .. k, buzz and work and buzz_old and 1 or 0, 1)
            end

            for k, v in ipairs(wagon.AnnouncerPositions) do
                if IsValid(wagon.Sounds["announcer" .. k]) then wagon.Sounds["announcer" .. k]:SetVolume(work and (v[3] or 1) or 0) end
            end
        end

        function ent.OnAnnouncer(wagon, volume)
            return wagon:GetPackedBool("AnnPlay") and volume or 0
        end

        function ent.OnPlay(wagon, soundid, location, range, pitch)
            if location == "stop" then
                if IsValid(wagon.Sounds[soundid]) then
                    wagon.Sounds[soundid]:Pause()
                    wagon.Sounds[soundid]:SetTime(0)
                end
                return
            end

            if soundid == "pkg" then return end
            if location == "bass" then
                if soundid == "VDOL" then return range > 0 and "vdol_on" or "vdol_off", location, 1, pitch end
                if soundid == "VDOP" then return range > 0 and "vdor_on" or "vdor_off", location, 1, pitch end
                if soundid == "VDZ" then return range > 0 and "vdz_on" or "vdz_off", location, 1, pitch end
                if soundid:sub(1, 4) == "IGLA" then return range > 0 and "igla_on" or "igla_off", location, 1, pitch end
                if soundid == "lk2c" then
                    local speed = wagon:GetPackedRatio("Speed")
                    wagon.SoundPositions[soundid][1] = 350 - Lerp(speed / 0.1, 0, 250)
                    return soundid, location, 1 - Lerp(speed / 10, 0.2, 0.8), pitch
                end

                if soundid == "LK2" then
                    local speed = wagon:GetPackedRatio("Speed")
                    if range == 0 and speed < 20 and wagon:GetPackedRatio("EnginesCurrent") > 0.55 then wagon:PlayOnce("lk2c", "bass", 1, pitch) end
                    local id = range > 0 and "lk2_on" or "lk2_off"
                    wagon.SoundPositions[id][1] = 350 - Lerp(speed / 0.1, 0, 250)
                    return id, location, 1 - Lerp(speed / 10, 0.2, 0.8), pitch
                end

                if soundid == "LK3" then
                    local speed = wagon:GetPackedRatio("Speed")
                    local id = range > 0 and "lk3_on" or "lk3_off"
                    wagon.SoundPositions[id][1] = 350 - Lerp(speed / 0.1, 0, 250)
                    return id, location, 1 - Lerp(speed / 10, 0.2, 0.8), pitch
                end

                if soundid == "LK5" and range > 0 then
                    local speed = wagon:GetPackedRatio("Speed")
                    wagon.SoundPositions["lk5_on"][1] = 440 - Lerp(speed / 0.1, 0, 330)
                    return "lk5_on", location, 1 - Lerp(speed / 10, 0.2, 0.8), pitch
                end

                if soundid == "brake" then
                    wagon:PlayOnce("brake_f", location, range, pitch)
                    wagon:PlayOnce("brake_b", location, range, pitch)
                    return
                end

                if soundid == "KK" then return range > 0 and "kk_on" or "kk_off", location, 1, 0.8 end
            end
            return soundid, location, range, pitch
        end
    end

    if SERVER then
        table.insert(ent.SyncTable, "EmergencyBrakeValve")
        function ent.Initialize(wagon)
            wagon.Plombs = {
                A84 = true,
                Init = true,
            }

            wagon.LampType = 1
            -- Set model and initialize
            wagon:SetModel("models/metrostroi_train/81-717/81-717_mvm_int.mdl")
            wagon.BaseClass.Initialize(wagon)
            wagon:SetPos(wagon:GetPos() + Vector(0, 0, 140))
            -- Create seat entities
            wagon.DriverSeat = wagon:CreateSeat("driver", Vector(-415 - 16, 0, -48 + 2.5 + 6), Angle(0, -90, 0), "models/vehicles/prisoner_pod_inner.mdl")
            --wagon.InstructorsSeat = wagon:CreateSeat("instructor",Vector(430,47,-27+2.5),Angle(0,-90,0))
            -- Hide seats
            wagon.DriverSeat:SetColor(Color(0, 0, 0, 0))
            wagon.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
            --wagon.InstructorsSeat:SetColor(Color(0,0,0,0))
            --wagon.InstructorsSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
            -- Create bogeys
            if Metrostroi.BogeyOldMap then
                wagon.FrontBogey = wagon:CreateBogey(Vector(317 - 5, 0, -84), Angle(0, 180, 0), true, "717")
                wagon.RearBogey = wagon:CreateBogey(Vector(-317 + 0, 0, -84), Angle(0, 0, 0), false, "717")
                wagon.FrontCouple = wagon:CreateCouple(Vector(420.54, 0, -62), Angle(0, 0, 0), true, "717")
                wagon.RearCouple = wagon:CreateCouple(Vector(-426.04, 0, -62), Angle(0, 180, 0), false, "717")
            else
                wagon.FrontBogey = wagon:CreateBogey(Vector(317 - 11, 0, -80), Angle(0, 180, 0), true, "717")
                wagon.RearBogey = wagon:CreateBogey(Vector(-317 + 0, 0, -80), Angle(0, 0, 0), false, "717")
                wagon.FrontCouple = wagon:CreateCouple(Vector(408, 0, -66), Angle(0, 0, 0), true, "717")
                wagon.RearCouple = wagon:CreateCouple(Vector(-421, 0, -66), Angle(0, 180, 0), false, "717")
            end

            local pneumoPow = 0.8 + math.random() ^ 1.55 * 0.4
            wagon.FrontBogey.PneumaticPow = pneumoPow
            wagon.RearBogey.PneumaticPow = pneumoPow
            -- Initialize key mapping
            wagon.KeyMap = {
                [KEY_1] = "StartSet",
                [KEY_8] = "StartSet",
                [KEY_W] = "StartSet",
                [KEY_PAD_DIVIDE] = "StartSet",
                [KEY_0] = "RV+",
                [KEY_9] = "RV-",
                [KEY_PAD_PLUS] = "RV+",
                [KEY_PAD_MINUS] = "RV-",
                [KEY_G] = "VozvratRPSet",
                [KEY_L] = "HornEngage",
                [KEY_F] = "PneumaticBrakeUp",
                [KEY_R] = "PneumaticBrakeDown",
                [KEY_PAD_1] = "PneumaticBrakeSet1",
                [KEY_PAD_2] = "PneumaticBrakeSet2",
                [KEY_PAD_3] = "PneumaticBrakeSet3",
                [KEY_PAD_4] = "PneumaticBrakeSet4",
                [KEY_PAD_5] = "PneumaticBrakeSet5",
                [KEY_PAD_6] = "PneumaticBrakeSet6",
                [KEY_PAD_7] = "PneumaticBrakeSet7",
                [KEY_PAD_0] = "DriverValveDisconnect",
                [KEY_BACKSPACE] = "EmergencyBrakeValveToggle",
                [KEY_LSHIFT] = {
                    [KEY_L] = "DriverValveDisconnect",
                },
                [KEY_RSHIFT] = {
                    [KEY_L] = "DriverValveDisconnect",
                },
            }

            wagon.InteractionZones = {
                {
                    ID = "FrontBrakeLineIsolationToggle",
                    Pos = Vector(461.5, -34, -53),
                    Radius = 8,
                },
                {
                    ID = "FrontTrainLineIsolationToggle",
                    Pos = Vector(461.5, 33, -53),
                    Radius = 8,
                },
                {
                    ID = "RearBrakeLineIsolationToggle",
                    Pos = Vector(-474.5, 33, -53),
                    Radius = 8,
                },
                {
                    ID = "RearTrainLineIsolationToggle",
                    Pos = Vector(-474.5, -34, -53),
                    Radius = 8,
                },
                {
                    ID = "ParkingBrakeToggle",
                    Pos = Vector(-469, -54.5, -53),
                    Radius = 8,
                },
                {
                    ID = "FrontDoor",
                    Pos = Vector(451.5, 35, 4),
                    Radius = 20,
                },
                {
                    ID = "RearDoor",
                    Pos = Vector(-464.8, -35, 4),
                    Radius = 20,
                },
                {
                    ID = "GVToggle",
                    Pos = Vector(140.50, 62, -64),
                    Radius = 10,
                },
                {
                    ID = "VBToggle",
                    Pos = Vector(-470 - 15, 53),
                    Radius = 20,
                },
                {
                    ID = "AirDistributorDisconnectToggle",
                    Pos = Vector(-177, -66, -50),
                    Radius = 20,
                },
            }

            -- Cross connections in train wires
            wagon.TrainWireInverts = {
                [28] = true,
                [34] = true,
            }

            wagon.TrainWireCrossConnections = {
                [5] = 4, -- Reverser F<->B
                [31] = 32, -- Doors L<->R
            }

            wagon.Lamps = {
                broken = {},
            }

            local rand = math.random() > 0.8 and 1 or math.random(0.95, 0.99)
            for i = 1, 27 do
                if math.random() > rand then wagon.Lamps.broken[i] = math.random() > 0.5 end
            end

            wagon:SetNW2Int("Type", wagon:GetNW2Int("Type", 2))
            wagon:TrainSpawnerUpdate()
        end

        function ent.UpdateLampsColors(wagon)
            local lCol, lCount = Vector(), 0
            local rand = math.random() > 0.8 and 1 or math.random(0.95, 0.99)
            if wagon.LampType == 1 then
                local r, g, col = 15, 15
                local typ = math.Round(math.random())
                local rnd = 0.5 + math.random() * 0.5
                for i = 1, 13 do
                    local chtp = math.random() > rnd
                    if typ == 0 and not chtp or typ == 1 and chtp then
                        g = math.random() * 15
                        col = Vector(240 + g, 240 + g, 255)
                    else
                        b = -5 + math.random() * 20
                        col = Vector(255, 255, 235 + b)
                    end

                    lCol = lCol + col
                    lCount = lCount + 1
                    if i % 4 == 0 then
                        local id = 10 + math.ceil(i / 4)
                        local tcol = (lCol / lCount) / 255
                        --wagon.Lights[id][4] = Vector(tcol.r,tcol.g^3,tcol.b^3)*255
                        wagon:SetNW2Vector("lampD" .. id, Vector(tcol.r, tcol.g ^ 3, tcol.b ^ 3) * 255)
                        lCol = Vector()
                        lCount = 0
                    end

                    wagon:SetNW2Vector("lamp" .. i, col)
                    wagon.Lamps.broken[i] = math.random() > rand and math.random() > 0.7
                end
            else
                local rnd1, rnd2, col = 0.7 + math.random() * 0.3, math.random()
                local typ = math.Round(math.random())
                local r, g = 15, 15
                for i = 1, 27 do
                    local chtp = math.random() > rnd1
                    if typ == 0 and not chtp or typ == 1 and chtp then
                        if math.random() > rnd2 then
                            r = -20 + math.random() * 25
                            g = 0
                        else
                            g = -5 + math.random() * 15
                            r = g
                        end

                        col = Vector(245 + r, 228 + g, 189)
                    else
                        if math.random() > rnd2 then
                            g = math.random() * 15
                            b = g
                        else
                            g = 15
                            b = -10 + math.random() * 25
                        end

                        col = Vector(255, 235 + g, 235 + b)
                    end

                    lCol = lCol + col
                    lCount = lCount + 1
                    if i % 8.3 < 1 then
                        local id = 9 + math.ceil(i / 8.3)
                        local tcol = (lCol / lCount) / 255
                        --wagon.Lights[id][4] = Vector(tcol.r,tcol.g^3,tcol.b^3)*255
                        wagon:SetNW2Vector("lampD" .. id, Vector(tcol.r, tcol.g ^ 3, tcol.b ^ 3) * 255)
                        lCol = Vector()
                        lCount = 0
                    end

                    wagon:SetNW2Vector("lamp" .. i, col)
                    wagon.Lamps.broken[i] = math.random() > rand and math.random() > 0.7
                end
            end
        end

        function ent.TrainSpawnerUpdate(wagon)
            wagon:SetNW2Bool("Custom", wagon.CustomSettings)
            local num = wagon.WagonNumber
            math.randomseed(num + 817171)
            if wagon.CustomSettings then
                local dot5 = wagon:GetNW2Int("Type") == 2
                local typ = wagon:GetNW2Int("BodyType")
                wagon:SetNW2Int("Crane", wagon:GetNW2Int("Cran"))
                local lampType = wagon:GetNW2Int("LampType")
                local BPSNType = wagon:GetNW2Int("BPSNType")
                local SeatType = wagon:GetNW2Int("SeatType")
                wagon:SetNW2Bool("Dot5", dot5)
                wagon:SetNW2Int("LampType", lampType == 1 and (math.random() > 0.5 and 2 or 1) or lampType - 1)
                wagon:SetNW2Int("BPSNType", BPSNType == 1 and math.ceil(math.random() * 12 + 0.5) or BPSNType - 1)
                if SeatType == 1 then
                    wagon:SetNW2Bool("NewSeats", math.random() > 0.5)
                else
                    wagon:SetNW2Bool("NewSeats", SeatType == 3)
                end
            else
                local num = wagon.WagonNumber
                local typ = wagon.WagonNumberConf or {}
                local lvz = typ[1]
                wagon.Dot5 = typ[2]
                wagon.NewBortlamps = typ[4]
                if lvz then
                    --wagon:SetModel("models/metrostroi_train/81-717/81-717_lvz.mdl")
                    wagon:SetModel("models/metrostroi_train/81-717/81-717_mvm_int.mdl")
                else
                    wagon:SetModel("models/metrostroi_train/81-717/81-717_mvm_int.mdl")
                end

                wagon:SetNW2Bool("Dot5", wagon.Dot5)
                wagon:SetNW2Bool("LVZ", lvz)
                wagon:SetNW2Bool("NewSeats", typ[3])
                wagon:SetNW2Bool("NewBortlamps", wagon.NewBortlamps)
                wagon:SetNW2Int("LampType", math.random() > 0.5 and 2 or 1)
                local tex = typ[5] and typ[5][math.random(1, #typ[5])] or "Def_717MSKWhite"
                wagon:SetNW2String("PassTexture", tex)
                local oldType = not wagon.Dot5 and not typ[3] and not lvz
                wagon:SetNW2Int("BPSNType", oldType and (math.random() > 0.7 and 2 or 1) or 2 + math.Clamp(math.floor(math.random() * 11) + 1, 1, 11))
                wagon:SetNW2Int("Crane", not wagon.Dot5 and 2 or 1)
                if wagon.Dot5 then
                    wagon.FrontCouple.CoupleType = "717"
                else
                    wagon.FrontCouple.CoupleType = "702"
                end

                wagon.RearCouple.CoupleType = wagon.FrontCouple.CoupleType
                wagon.FrontCouple:SetParameters()
                wagon.RearCouple:SetParameters()
                wagon:SetNW2String("Texture", "Def_717MSKClassic1")
                --wagon.ARSType = wagon:GetNW2Int("ARSType",1)
            end

            wagon.LampType = wagon:GetNW2Int("LampType", 1)
            wagon.Pneumatic.ValveType = wagon:GetNW2Int("Crane", 1)
            wagon.Announcer.AnnouncerType = wagon:GetNW2Int("Announcer", 1)
            wagon.WorkingLights = 6
            wagon:SetPackedBool("Crane013", wagon.Pneumatic.ValveType == 2)
            wagon:UpdateTextures()
            wagon:UpdateLampsColors()
            local pneumoPow = 0.8 + math.random() ^ 1.55 * 0.4
            if IsValid(wagon.FrontBogey) then wagon.FrontBogey.PneumaticPow = pneumoPow end
            if IsValid(wagon.RearBogey) then wagon.RearBogey.PneumaticPow = pneumoPow end
            wagon.Pneumatic.VDLoud = math.random() < 0.06 and 0.9 + math.random() * 0.2
            if wagon.Pneumatic.VDLoud then wagon.Pneumatic.VDLoudID = math.random(1, 5) end
            math.randomseed(os.time())
        end

        function ent.Think(wagon)
            local retVal = wagon.BaseClass.Think(wagon)
            local Panel = wagon.Panel
            local Pneumatic = wagon.Pneumatic
            local lightsActive1 = Panel.EmergencyLights > 0
            local lightsActive2 = Panel.MainLights > 0.0
            local LampCount = wagon.LampType == 2 and 27 or 13
            local Ip = wagon.LampType == 2 and 7 or 3.6
            local Im = wagon.LampType == 2 and 2 or 1
            for i = 1, LampCount do
                if lightsActive2 or lightsActive1 and math.ceil((i + Ip - Im) % Ip) == 1 then
                    if not wagon.Lamps[i] and not wagon.Lamps.broken[i] then wagon.Lamps[i] = CurTime() + math.Rand(0.1, math.Rand(0.5, 2)) end
                else
                    wagon.Lamps[i] = nil
                end

                if wagon.Lamps[i] and CurTime() - wagon.Lamps[i] > 0 then
                    wagon:SetPackedBool("lightsActive" .. i, true)
                else
                    wagon:SetPackedBool("lightsActive" .. i, false)
                end
            end

            wagon:SetPackedBool("DoorsW", Panel.DoorsW > 0)
            wagon:SetPackedBool("GRP", Panel.GreenRP > 0)
            wagon:SetPackedBool("BrW", Panel.BrW > 0)
            wagon:SetPackedBool("M1_3", Panel.M1_3 > 0)
            wagon:SetPackedBool("M4_7", Panel.M4_7 > 0)
            -- Signal if doors are open or no to platform simulation
            wagon.LeftDoorsOpen = Pneumatic.LeftDoorState[1] > 0.5 or Pneumatic.LeftDoorState[2] > 0.5 or Pneumatic.LeftDoorState[3] > 0.5 or Pneumatic.LeftDoorState[4] > 0.5
            wagon.RightDoorsOpen = Pneumatic.RightDoorState[1] > 0.5 or Pneumatic.RightDoorState[2] > 0.5 or Pneumatic.RightDoorState[3] > 0.5 or Pneumatic.RightDoorState[4] > 0.5
            --wagon:SetPackedRatio("Crane", Pneumatic.RealDriverValvePosition)
            --wagon:SetPackedRatio("Controller", (wagon.KV.ControllerPosition+3)/7)
            if Pneumatic.ValveType == 1 then
                wagon:SetPackedRatio("BLPressure", Pneumatic.ReservoirPressure / 16.0)
            else
                wagon:SetPackedRatio("BLPressure", Pneumatic.BrakeLinePressure / 16.0)
            end

            wagon:SetPackedRatio("TLPressure", Pneumatic.TrainLinePressure / 16.0)
            wagon:SetPackedRatio("BCPressure", Pneumatic.BrakeCylinderPressure / 6.0)
            ----------------------------------*****************************--------------------------------
            --10th wire voltage readout imitation depending on the BPSNs and EKK state, not on the wagon battery switch state
            local hvcounter = 0
            local hvcar = nil
            local vdrop = 1.125 * #wagon.WagonList
            for k, v in ipairs(wagon.WagonList) do
                if v.PowerSupply.X2_2 > 0 and v.A24.Value > 0 then
                    hvcounter = hvcounter + 1
                    hvcar = hvcar or v
                    vdrop = vdrop - 1.125
                else
                    vdrop = vdrop - ((v.A56.Value == 0 and 0.4 or v.VB.Value == 0 and 0.4 or 0) + (v.LK4.Value == 0 and 0.725 or 0))
                end
            end

            local PCV_o = hvcounter > 0 and math.Clamp(76 + (hvcar.Electric.Aux750V - 600) * 8 / 375, 76, 84) - vdrop or wagon.WagonList[1].Battery.Voltage
            --imitating converter overload protection only when control circuits are energized and at least one PC on the train is off; pretty useless btw (but fun)
            local pcloadratio = #wagon.WagonList / (hvcounter > 0 and hvcounter or 0.5)
            local _A = 25 * (6 - 6 / 5.01) --assuming one PC on 6 cars can work for 25 secs while the cars' CCs are energized
            if pcloadratio > 1 and pcloadratio <= #wagon.WagonList and wagon.LK4.Value > 0 and wagon.PowerSupply.X2_2 > 0 and not wagon.pcrlxtimer then
                wagon.pcprotimer = wagon.pcprotimer or CurTime()
                --hyperbolic function of PC operating time depending on load coeff
                if CurTime() - wagon.pcprotimer > _A / (pcloadratio - 6 / 5.01) then wagon.pcrlxtimer = CurTime() end
            else
                if wagon.pcrlxtimer then
                    if CurTime() - wagon.pcrlxtimer < 30 then --30 seconds relaxation time before PC overload protecion can be reset
                        wagon.RZP:TriggerInput("Close", 1)
                    else
                        wagon.pcrlxtimer = nil
                    end
                else
                    wagon.pcprotimer = nil
                end
            end

            wagon.PowerSupply:TriggerInput("3x2", wagon.pcrlxtimer and 1 or 0) --BPSN overheat protection in case of RZP button is being pressed constantly
            ----------------------------------*****************************--------------------------------
            wagon:SetPackedRatio("BatteryVoltage", Panel["V1"] * PCV_o / 150.0)
            wagon:SetPackedRatio("BatteryCurrent", Panel["V1"] * math.Clamp((wagon.Battery.Voltage - 75) * 0.01, -0.01, 1))
            wagon:SetPackedRatio("EnginesCurrent", 0.5 + 0.5 * wagon.Electric.I24 / 500.0)
            wagon:SetPackedBool("Compressor", Pneumatic.Compressor > 0)
            wagon:SetPackedBool("RK", wagon.RheostatController.Velocity ~= 0.0)
            wagon:SetPackedBool("BPSN", wagon.PowerSupply.X2_2 > 0)
            wagon:SetPackedRatio("RV", wagon.RV.Value / 2)
            wagon:SetPackedRatio("CranePosition", Pneumatic.RealDriverValvePosition)
            wagon:SetPackedBool("RZP", Panel.RZP > 0)
            wagon:SetPackedBool("FrontDoor", wagon.FrontDoor)
            wagon:SetPackedBool("RearDoor", wagon.RearDoor)
            wagon:SetPackedBool("CouchCap", wagon.CouchCap)
            wagon:SetPackedBool("AnnBuzz", Panel.AnnouncerBuzz > 0)
            wagon:SetPackedBool("AnnPlay", Panel.AnnouncerPlaying > 0)
            -- Exchange some parameters between engines, pneumatic system, and real world
            wagon.Engines:TriggerInput("Speed", wagon.Speed)
            if IsValid(wagon.FrontBogey) and IsValid(wagon.RearBogey) and not wagon.IgnoreEngine then
                local A = 2 * wagon.Engines.BogeyMoment
                --wagon.FrontBogey.MotorForce = 27000+1000*(A < 0 and 1 or 0)
                --wagon.RearBogey.MotorForce  = 27000+1000*(A < 0 and 1 or 0)
                wagon.FrontBogey.MotorForce = 22500 + 5500 * (A < 0 and 1 or 0)
                wagon.RearBogey.MotorForce = 22500 + 5500 * (A < 0 and 1 or 0)
                wagon.FrontBogey.Reversed = wagon.Reverser.NZ > 0.5
                wagon.RearBogey.Reversed = wagon.Reverser.VP > 0.5
                -- These corrections are required to beat source engine friction at very low values of motor power
                local P = math.max(0, 0.04449 + 1.06879 * math.abs(A) - 0.465729 * A ^ 2)
                if math.abs(A) > 0.4 then P = math.abs(A) end
                if math.abs(A) < 0.05 then P = 0 end
                if wagon.Speed < 10 then P = P * (1.0 + 0.5 * (10.0 - wagon.Speed) / 10.0) end
                wagon.RearBogey.MotorPower = P * 0.5 * (A > 0 and 1 or -1)
                wagon.FrontBogey.MotorPower = P * 0.5 * (A > 0 and 1 or -1)
                --wagon.RearBogey.MotorPower  = P*0.5
                --wagon.FrontBogey.MotorPower = P*0.5
                --wagon.Acc = (wagon.Acc or 0)*0.95 + wagon.Acceleration*0.05
                --print(wagon.Acc)
                -- Apply brakes
                wagon.FrontBogey.PneumaticBrakeForce = 50000.0 - 2000
                wagon.FrontBogey.BrakeCylinderPressure = Pneumatic.BrakeCylinderPressure
                wagon.FrontBogey.ParkingBrakePressure = math.max(0, (2.6 - Pneumatic.ParkingBrakePressure) / 2.6) / 2
                wagon.FrontBogey.BrakeCylinderPressure_dPdT = -Pneumatic.BrakeCylinderPressure_dPdT
                wagon.RearBogey.PneumaticBrakeForce = 50000.0 - 2000
                wagon.RearBogey.BrakeCylinderPressure = Pneumatic.BrakeCylinderPressure
                wagon.RearBogey.BrakeCylinderPressure_dPdT = -Pneumatic.BrakeCylinderPressure_dPdT
                wagon.RearBogey.ParkingBrakePressure = math.max(0, (2.6 - Pneumatic.ParkingBrakePressure) / 2.6) / 2
                --wagon.RearBogey.ParkingBrake = wagon.ParkingBrake.Value > 0.5
            end

            wagon:GenerateJerks()
            -- Send networked variables
            --wagon:SendPackedData()
            return retVal
        end
    end
end

function RECIPE:InjectNeeded()
    if Metrostroi.Version > 1537278077 then return false end
    return true
end