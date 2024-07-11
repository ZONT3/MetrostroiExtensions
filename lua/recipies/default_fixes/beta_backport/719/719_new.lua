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
MEL.DefineRecipe("719_new", "gmod_subway_81-719")
RECIPE.BackportPriority = 15
function RECIPE:Inject(ent)
    if CLIENT then
        ent.AutoAnimNames = {}
        ent.Lights = {
            [11] = {
                "dynamiclight",
                Vector(200, 0, -20),
                Angle(0, 0, 0),
                Color(255, 175, 50),
                brightness = 3,
                distance = 400,
                fov = 180,
                farz = 128,
                changable = true
            },
            [12] = {
                "dynamiclight",
                Vector(0, 0, -20),
                Angle(0, 0, 0),
                Color(255, 175, 50),
                brightness = 3,
                distance = 400,
                fov = 180,
                farz = 128,
                changable = true
            },
            [13] = {
                "dynamiclight",
                Vector(-200, 0, -20),
                Angle(0, 0, 0),
                Color(255, 175, 50),
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
        }

        local Cpos = {0, 0.22, 0.429, 0.513, 0.597, 0.825, 1}
        local tbl = {
            [0] = -0.25,
            0.00,
            0.04,
            0.09,
            0.13,
            0.17,
            0.20,
            0.27,
            0.33,
            0.42,
            0.56,
            0.73,
            1.00
        }

        function ent.Think(wagon)
            --if LocalPlayer():SteamID() == "STEAM_0:0:48355213" then return end
            wagon.BaseClass.Think(wagon)
            local dT = wagon.DeltaTime
            if not wagon.RenderClientEnts or wagon.CreatingCSEnts then
                wagon.TISUFreq = 13
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
            wagon:SetLightPower(15, Bortlamp_w > 0.5)
            wagon:SetLightPower(18, Bortlamp_w > 0.5)
            wagon:SetLightPower(16, Bortlamp_g > 0.5)
            wagon:SetLightPower(19, Bortlamp_g > 0.5)
            wagon:SetLightPower(17, Bortlamp_y > 0.5)
            wagon:SetLightPower(20, Bortlamp_y > 0.5)
            local activeLights = 0
            for i = 1, 30 do
                local colV = wagon:GetNW2Vector("lamp" .. i)
                local col = Color(colV.x, colV.y, colV.z)
                local state = wagon:Animate("Lamp1_" .. i, wagon:GetPackedBool("lightsActive" .. i) and 1 or 0, 0, 1, 6, false)
                wagon:ShowHideSmooth("lamp1_" .. i, state, col)
                activeLights = activeLights + state
            end

            for i = 11, 13 do
                local col = wagon:GetNW2Vector("lampD" .. i)
                if wagon.LightsOverride[i].vec ~= col then
                    wagon.LightsOverride[i].vec = col
                    wagon.LightsOverride[i][4] = Color(col.x, col.y, col.z)
                    wagon:SetLightPower(i, false)
                else
                    wagon:SetLightPower(i, activeLights > 0, activeLights / 30)
                end
            end

            wagon:Animate("brake_line", wagon:GetPackedRatio("BLPressure"), 0.14, 0.875, 256, 2) --,,0.01)
            wagon:Animate("train_line", wagon:GetPackedRatio("TLPressure"), 0.14, 0.875, 256, 2) --,,0.01)
            wagon:Animate("brake_cylinder", wagon:GetPackedRatio("BCPressure"), 0.14, 0.875, 256, 2) --,,0.03)
            wagon:Animate("voltmeter", wagon:GetPackedRatio("BatteryVoltage"), 0.601, 0.400)
            wagon:Animate("ampermeter", 0.5 + wagon:GetPackedRatio("BatteryCurrent"), 0.604, 0.398)
            local capOpened = wagon:GetPackedBool("CouchCap")
            wagon:ShowHide("seats_old_cap_o", capOpened)
            wagon:ShowHide("seats_old_cap", not capOpened)
            wagon:HidePanel("couch_cap", capOpened)
            wagon:HidePanel("couch_cap_o", not capOpened)
            wagon:HidePanel("PVZ", not capOpened)
            wagon:ShowHide("otsek_cap_r", not capOpened)
            wagon:HidePanel("BUV_MPS", not capOpened)
            wagon:HidePanel("BUV_MVD", not capOpened)
            wagon:HidePanel("BUV_MALP1", not capOpened)
            wagon:HidePanel("BUV_MALP2", not capOpened)
            wagon:HidePanel("BUV_MIV", not capOpened)
            wagon:HidePanel("BUV_MGR", not capOpened)
            wagon:HidePanel("BUV_MLUA", not capOpened)
            wagon:HidePanel("BUV_MUVK1", not capOpened)
            wagon:HidePanel("BUV_MUVK2", not capOpened)
            --wagon:Animate("Autodrive",     wagon:GetPackedBool(132) and 1 or 0, 0,1, 16, false)
            local door1 = wagon:Animate("door1", wagon:GetPackedBool("FrontDoor") and 1 or 0, 0, 0.25, 4, 0.5)
            local door2 = wagon:Animate("door2", wagon:GetPackedBool("RearDoor") and (capOpened and 0.25 or 1) or 0, 0, 0.25, 4, 0.5)
            if wagon.Door1 ~= (door1 > 0) then
                wagon.Door1 = door1 > 0
                wagon:PlayOnce("door1", "bass", wagon.Door1 and 1 or 0)
            end

            if wagon.Door2 ~= (door2 > 0) then
                wagon.Door2 = door2 > 0
                wagon:PlayOnce("door2", "bass", wagon.Door2 and 1 or 0)
            end

            wagon:Animate("FrontBrake", wagon:GetNW2Bool("FbI") and 0 or 1, 0, 1, 3, false)
            wagon:Animate("FrontTrain", wagon:GetNW2Bool("FtI") and 1 or 0, 0, 1, 3, false)
            wagon:Animate("RearBrake", wagon:GetNW2Bool("RbI") and 0 or 1, 0, 1, 3, false)
            wagon:Animate("RearTrain", wagon:GetNW2Bool("RtI") and 1 or 0, 0, 1, 3, false)
            wagon:Animate("ParkingBrake", wagon:GetPackedBool("ParkingBrake") and 1 or 0, 1, 0, 3, false)
            --print(wagon.ClientProps["a0"])
            -- Main switch
            if wagon.LastGVValue ~= wagon:GetPackedBool("GV") then
                wagon.ResetTime = CurTime() + 1.5
                wagon.LastGVValue = wagon:GetPackedBool("GV")
            end

            wagon:Animate("gv_wrench", wagon.LastGVValue and 1 or 0, 0.5, 0.9, 128, 1, false)
            wagon:ShowHideSmooth("gv_wrench", CurTime() < wagon.ResetTime and 1 or 0.1)
            --wagon:InitializeSounds()
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
                    if wagon.Anims[n_l] then
                        dlo = math.abs(state - (wagon.Anims[n_l] and wagon.Anims[n_l].oldival or 0))
                        if dlo <= 0 and wagon.Anims[n_l].oldspeed then dlo = wagon.Anims[n_l].oldspeed / 14 end
                    end

                    wagon:Animate(n_l, state, 0, 1, dlo * 14, false) --0.8 + (-0.2+0.4*math.random()),0)
                    --wagon:Animate(n_r,state,0,1, dlo*14,false)--0.8 + (-0.2+0.4*math.random()),0)
                end
            end

            local speed = wagon:GetPackedRatio("Speed", 0) * 100
            local ventSpeedAdd = math.Clamp(speed / 30, 0, 1)
            local v1state = wagon:GetPackedBool("Vent1Work")
            local v2state = wagon:GetPackedBool("Vent2Work")
            for i = 1, 8 do
                local rand = wagon.VentRand[i]
                local vol = wagon.VentVol[i]
                local even = i % 2 == 0
                local work = even and v1state or not even and v2state
                local target = math.min(1, (work and 1 or 0) + ventSpeedAdd * rand * 0.4) * 2
                if wagon.VentVol[i] < target then
                    wagon.VentVol[i] = math.min(target, vol + dT / 1.5 * rand)
                elseif wagon.VentVol[i] > target then
                    wagon.VentVol[i] = math.max(0, vol - dT / 8 * rand * (vol * 0.3))
                end

                wagon.VentState[i] = (wagon.VentState[i] + 10 * (wagon.VentVol[i] / 2) ^ 3 * dT) % 1
                local vol1 = math.max(0, wagon.VentVol[i] - 1)
                local vol2 = math.max(0, (wagon.VentVol[i - 1] or wagon.VentVol[i + 1]) - 1)
                wagon:SetSoundState("vent" .. i, vol1 * (0.7 + vol2 * 0.3), 0.5 + 0.5 * vol1 + math.Rand(-0.01, 0.01))
                if IsValid(wagon.ClientEnts["vent" .. i]) then wagon.ClientEnts["vent" .. i]:SetPoseParameter("position", wagon.VentState[i]) end
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
            wagon:SetSoundState("release2", (math.Clamp(0.3 - release1, 0, 0.3) / 0.3) * (release1 / 0.3), 1.0)
            local parking_brake = wagon:GetPackedRatio("ParkingBrakePressure_dPdT", 0)
            local parking_brake_abs = math.Clamp(math.abs(parking_brake) - 0.3, 0, 1)
            if wagon.ParkingBrake1 ~= (parking_brake < 1) then
                wagon.ParkingBrake1 = parking_brake < 1
                if wagon.ParkingBrake1 then wagon:PlayOnce("parking_brake_en", "bass", 1, 1) end
            end

            if wagon.ParkingBrake2 ~= (parking_brake > -0.8) then
                wagon.ParkingBrake2 = parking_brake > -0.8
                if wagon.ParkingBrake2 then wagon:PlayOnce("parking_brake_rel", "bass", 0.6, 1) end
            end

            wagon:SetSoundState("parking_brake", parking_brake_abs, 1)
            wagon.FrontLeak = math.Clamp(wagon.FrontLeak + 10 * (-wagon:GetPackedRatio("FrontLeak") - wagon.FrontLeak) * dT, 0, 1)
            wagon.RearLeak = math.Clamp(wagon.RearLeak + 10 * (-wagon:GetPackedRatio("RearLeak") - wagon.RearLeak) * dT, 0, 1)
            wagon:SetSoundState("front_isolation", wagon.FrontLeak, 0.9 + 0.2 * wagon.FrontLeak)
            wagon:SetSoundState("rear_isolation", wagon.RearLeak, 0.9 + 0.2 * wagon.RearLeak)
            wagon:SetSoundState("compressor", wagon:GetPackedBool("Compressor") and 0.6 or 0, 1)
            wagon:SetSoundState("compressor2", wagon:GetPackedBool("Compressor") and 0.8 or 0, 1)
            local state = wagon:GetPackedRatio("RNState")
            local freq = math.max(1, wagon:GetNW2Int("RNFreq", 0))
            wagon.TISUVol = math.Clamp(wagon.TISUVol + (state - wagon.TISUVol) * dT * 8, 0, 1)
            if freq > 12 then
                wagon.TISUFreq = 12
            elseif freq > wagon.TISUFreq then
                wagon.TISUFreq = math.min(wagon.TISUFreq + dT / 2 * 12, 12)
            elseif freq < wagon.TISUFreq then
                wagon.TISUFreq = freq --math.max(wagon.TISUFreq-dT/2*12,0)
            end

            local fq = 0.25 + tbl[math.Round(wagon.TISUFreq)] * 0.75
            wagon:SetSoundState("tisu", wagon.TISUVol, fq) --]]
            wagon:SetSoundState("bpsn", wagon:GetPackedBool("BBE") and 1 or 0, 1.0) --FIXME громкость по другому
            local work = wagon:GetPackedBool("AnnPlay")
            local buzz = wagon:GetPackedBool("AnnBuzz") and wagon:GetNW2Int("AnnouncerBuzz", -1) > 0
            for k in ipairs(wagon.AnnouncerPositions) do
                wagon:SetSoundState("announcer_buzz" .. k, (buzz and work) and 1 or 0, 1)
            end

            for k, v in ipairs(wagon.AnnouncerPositions) do
                if IsValid(wagon.Sounds["announcer" .. k]) then wagon.Sounds["announcer" .. k]:SetVolume(work and (v[3] or 1) or 0) end
            end
        end
    end

    if SERVER then
        function ent.Initialize(wagon)
            wagon.Plombs = {
                Init = true,
            }

            wagon:SetModel("models/metrostroi_train/81-718/81-718_int.mdl")
            wagon.BaseClass.Initialize(wagon)
            wagon:SetPos(wagon:GetPos() + Vector(0, 0, 140))
            -- Create seat entities
            wagon.DriverSeat = wagon:CreateSeat("driver", Vector(-415 - 16, 0, -48 + 2.5 + 6), Angle(0, -90, 0), "models/vehicles/prisoner_pod_inner.mdl")
            -- Hide seats
            wagon.DriverSeat:SetColor(Color(0, 0, 0, 0))
            wagon.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
            -- Create bogeys
            if Metrostroi.BogeyOldMap then
                wagon.FrontBogey = wagon:CreateBogey(Vector(317 - 5, 0, -84), Angle(0, 180, 0), true, "717")
                wagon.RearBogey = wagon:CreateBogey(Vector(-317 + 0, 0, -84), Angle(0, 0, 0), false, "717")
                wagon.FrontCouple = wagon:CreateCouple(Vector(414 + 6.545, 0, -62), Angle(0, 0, 0), true, "717")
                wagon.RearCouple = wagon:CreateCouple(Vector(-419.5 - 6.545, 0, -62), Angle(0, 180, 0), false, "717")
            else
                wagon.FrontBogey = wagon:CreateBogey(Vector(317 - 11, 0, -80), Angle(0, 180, 0), true, "717")
                wagon.RearBogey = wagon:CreateBogey(Vector(-317 + 0, 0, -80), Angle(0, 0, 0), false, "717")
                wagon.FrontCouple = wagon:CreateCouple(Vector(410 - 2, 0, -66), Angle(0, 0, 0), true, "717")
                wagon.RearCouple = wagon:CreateCouple(Vector(-423 + 2, 0, -66), Angle(0, 180, 0), false, "717")
            end

            local pneumoPow = 1.0 + math.random() ^ 0.4 * 0.3
            wagon.FrontBogey.PneumaticPow = pneumoPow
            wagon.RearBogey.PneumaticPow = pneumoPow
            -- Initialize key mapping
            wagon.KeyMap = {
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
                [KEY_LSHIFT] = {
                    [KEY_L] = "DriverValveDisconnectToggle",
                },
                [KEY_RSHIFT] = {
                    [KEY_L] = "DriverValveDisconnectToggle",
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
                    Pos = Vector(-469, 54.5, -53),
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
                    Pos = Vector(162.50, 62, -59),
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
                [11] = true,
                [34] = true,
            }

            wagon.TrainWireCrossConnections = {
                [5] = 6, -- Reverser F<->B
                [24] = 25, --VTP
                [36] = 37, -- Doors L<->R
                [57] = 58, -- ReverserR F<->B
            }

            -- KV wrench mode
            wagon.KVWrenchMode = 0
            wagon.RearDoor = false
            wagon.FrontDoor = false
            wagon.Lamps = {
                broken = {},
            }

            local rand = math.random() > 0.8 and 1 or math.random(0.95, 0.99)
            for i = 1, 30 do
                if math.random() > rand then wagon.Lamps.broken[i] = math.random() > 0.5 end
            end

            wagon.WrenchMode = 0
            wagon:TrainSpawnerUpdate()
        end

        function ent.UpdateLampsColors(wagon)
            wagon.LampType = math.Round(math.random() ^ 0.5) + 1
            wagon:SetNW2Int("LampType", wagon.LampType)
            local lCol, lCount = Vector(), 0
            local rnd1, rnd2, col = 0.7 + math.random() * 0.3, math.random()
            local typ = math.Round(math.random())
            local r, g = 15, 15
            for i = 1, 30 do
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
                if i % 9.3 < 1 then
                    local id = 9 + math.ceil(i / 9.3)
                    local tcol = (lCol / lCount) / 255
                    --wagon.Lights[id][4] = Vector(tcol.r,tcol.g^3,tcol.b^3)*255
                    wagon:SetNW2Vector("lampD" .. id, Vector(tcol.r, tcol.g ^ 3, tcol.b ^ 3) * 255)
                    lCol = Vector()
                    lCount = 0
                end

                wagon:SetNW2Vector("lamp" .. i, col)
            end
        end

        function ent.TrainSpawnerUpdate(wagon)
            wagon:UpdateLampsColors()
            wagon.Pneumatic.VDLoud = math.random() < 0.06 and 0.9 + math.random() * 0.2
            if wagon.Pneumatic.VDLoud then wagon.Pneumatic.VDLoudID = math.random(1, 5) end
        end

        function ent.Think(wagon)
            local Panel = wagon.Panel
            -- Initialize key mapping
            wagon.RetVal = wagon.BaseClass.Think(wagon)
            wagon:SetNW2Int("Wrench", wagon.WrenchMode)
            local lightsActive1 = wagon.Panel.EL3_6 > 0
            local lightsActive2 = wagon.Panel.EL7_30 > 0
            for i = 1, 30 do
                if lightsActive2 or lightsActive1 and math.ceil((i + 5) % 8) == math.ceil(i / 7) % 2 then
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

            wagon:SetPackedBool("AnnBuzz", Panel.AnnouncerBuzz > 0)
            wagon:SetPackedBool("AnnPlay", Panel.AnnouncerPlaying > 0)
            wagon:SetPackedBool("BBE", wagon.BBE.KM1 > 0)
            wagon:SetPackedBool("Compressor", wagon.KK.Value)
            if wagon.PTTI.State < 0 then
                wagon:SetPackedRatio("RNState", (wagon.PTTI.RNState - 0.25) * math.Clamp((math.abs(wagon.Electric.Itotal / 2) - 30 - wagon.Speed * 2) / 20, 0, 1))
                wagon:SetNW2Int("RNFreq", 13)
            else
                wagon:SetPackedRatio("RNState", (0.75 - wagon.PTTI.RNState) * math.Clamp((math.abs(wagon.Electric.Itotal / 2) - 30 - wagon.Speed * 2) / 20, 0, 1))
                wagon:SetNW2Int("RNFreq", ((wagon.PTTI.FreqState or 0) - 1 / 3) / (2 / 3) * 12)
            end

            local power = false --wagon.Panel.V1 > 0.5
            wagon:SetNW2Bool("ASNPPlay", power and wagon:ReadTrainWire(47) > 0)
            if wagon.CouchCap then
                --Лампы БУВ
                --МВД
                wagon:SetPackedBool("VOTK", wagon.BUV.OTK > 0)
                wagon:SetPackedBool("VRP", wagon.BUV.RP > 0)
                --МАЛП1,2
                wagon:SetPackedBool("VFM", wagon.BUV.FM > 0)
                wagon:SetPackedBool("VU400", wagon.BUV.U400 > 0)
                wagon:SetPackedBool("VE1350", wagon.BUV.E1350 > 0)
                wagon:SetPackedBool("VDIF", wagon.BUV.DIF > 0)
                wagon:SetPackedBool("VE13650", wagon.BUV.E13650 > 0)
                wagon:SetPackedBool("VE130", wagon.BUV.E130 > 0)
                wagon:SetPackedBool("VSN", wagon.BUV.SN > 0)
                wagon:SetPackedBool("VU800", wagon.BUV.U800 > 0)
                wagon:SetPackedBool("VU975", wagon.BUV.U975 > 0)
                wagon:SetPackedBool("VE2450", wagon.BUV.E2450 > 0)
                wagon:SetPackedBool("VE24650", wagon.BUV.E24650 > 0)
                wagon:SetPackedBool("VE240", wagon.BUV.E240 > 0)
                wagon:SetPackedBool("VBV", wagon.BUV.BV > 0)
                wagon:SetPackedBool("VMSU", wagon.BUV.MSU > 0)
                wagon:SetPackedBool("VMZK", wagon.BUV.MZK > 0)
                --МИВ
                wagon:SetPackedBool("VZZ", wagon.BUV.ZZ > 0)
                wagon:SetPackedBool("VV1", wagon.BUV.V1 > 0)
                wagon:SetPackedBool("VSMA", wagon.BUV.SMA > 0)
                wagon:SetPackedBool("VSMB", wagon.BUV.SMB > 0)
                wagon:SetPackedBool("VIVP", wagon.BUV.IVP > 0)
                wagon:SetPackedBool("VINZ", wagon.BUV.INZ > 0)
                wagon:SetPackedBool("VIVR", wagon.BUV.IVR > 0)
                wagon:SetPackedBool("VINR", wagon.BUV.INR > 0)
                wagon:SetPackedBool("VIX", wagon.BUV.IX > 0)
                wagon:SetPackedBool("VIT", wagon.BUV.IT > 0)
                wagon:SetPackedBool("VIU1", wagon.BUV.IU1 > 0)
                wagon:SetPackedBool("VIU2", wagon.BUV.IU2 > 0)
                wagon:SetPackedBool("VIM", wagon.BUV.IM > 0)
                wagon:SetPackedBool("VIXP", wagon.BUV.IXP > 0)
                wagon:SetPackedBool("VIU1R", wagon.BUV.IU1R > 0)
                wagon:SetPackedBool("VITARS", wagon.BUV.ITARS > 0)
                wagon:SetPackedBool("VITEM", wagon.BUV.ITEM > 0)
                wagon:SetPackedBool("VIAVR", wagon.BUV.IAVR > 0)
                wagon:SetPackedBool("VIPROV", wagon.BUV.IPROV > 0)
                wagon:SetPackedBool("VIPROV0", wagon.BUV.IPROV0 > 0)
                wagon:SetPackedBool("VIVZ", wagon.BUV.IVZ > 0)
                wagon:SetPackedBool("VITP1", wagon.BUV.ITP1 > 0)
                wagon:SetPackedBool("VITP2", wagon.BUV.ITP2 > 0)
                wagon:SetPackedBool("VITP3", wagon.BUV.ITP3 > 0)
                wagon:SetPackedBool("VITP4", wagon.BUV.ITP4 > 0)
                wagon:SetPackedBool("VIKX", wagon.BUV.IKX > 0)
                wagon:SetPackedBool("VIKT", wagon.BUV.IKT > 0)
                wagon:SetPackedBool("VILT", wagon.BUV.ILT > 0)
                wagon:SetPackedBool("VIRV", wagon.BUV.IRV > 0)
                wagon:SetPackedBool("VIRN", wagon.BUV.IRN > 0)
                wagon:SetPackedBool("VIBV", wagon.BUV.IBV > 0)
                wagon:SetPackedBool("VOVP", wagon.BUV.OVP > 0)
                wagon:SetPackedBool("VONZ", wagon.BUV.ONZ > 0)
                wagon:SetPackedBool("VOLK", wagon.BUV.OLK > 0)
                wagon:SetPackedBool("VOKX", wagon.BUV.OKX > 0)
                wagon:SetPackedBool("VOKT", wagon.BUV.OKT > 0)
                wagon:SetPackedBool("VOPV", wagon.BUV.OPV > 0)
                wagon:SetPackedBool("VOSN", wagon.BUV.OSN > 0)
                wagon:SetPackedBool("VOOIZ", wagon.BUV.OIZ > 0)
                wagon:SetPackedBool("VORP", wagon.BUV.ORP > 0)
                wagon:SetPackedBool("VOV1", wagon.BUV.OV1 > 0)
                wagon:SetPackedBool("VORKT", wagon.BUV.ORKT > 0)
                wagon:SetPackedBool("VORMT", wagon.BUV.ORMT > 0)
                wagon:SetPackedBool("VO75V", wagon.BUV.O75V > 0)
                wagon:SetPackedBool("VSS", wagon.BUV.SS > 0)
            end

            wagon:SetPackedBool("DoorsW", wagon.Panel.HL13 > 0)
            wagon:SetPackedBool("GRP", wagon.Panel.HL25 > 0)
            wagon:SetPackedBool("BrW", wagon.Panel.HL46 > 0)
            wagon:SetPackedBool("RearDoor", wagon.RearDoor)
            wagon:SetPackedBool("FrontDoor", wagon.FrontDoor)
            wagon:SetPackedBool("CouchCap", wagon.CouchCap)
            wagon:SetPackedRatio("Speed", wagon.Speed / 100)
            wagon:SetPackedBool("Vent1Work", wagon.BUVS.KV1 > 0)
            wagon:SetPackedBool("Vent2Work", wagon.BUVS.KV2 > 0)
            wagon:SetPackedRatio("BLPressure", wagon.Pneumatic.BrakeLinePressure / 16.0)
            wagon:SetPackedRatio("TLPressure", wagon.Pneumatic.TrainLinePressure / 16.0)
            wagon:SetPackedRatio("BCPressure", math.min(3.2, wagon.Pneumatic.BrakeCylinderPressure) / 6.0)
            wagon:SetPackedRatio("BatteryVoltage", Panel["V1"] * wagon.Battery.Voltage / 150.0)
            wagon:SetPackedRatio("BatteryCurrent", Panel["V1"] * math.Clamp((wagon.Battery.Voltage - 75) * 0.01, -0.01, 1))
            -- Exchange some parameters between engines, pneumatic system, and real world
            wagon.Engines:TriggerInput("Speed", wagon.Speed)
            if IsValid(wagon.FrontBogey) and IsValid(wagon.RearBogey) and not wagon.IgnoreEngine then
                local A = 2 * wagon.Engines.BogeyMoment
                --wagon.FrontBogey.MotorForce = 27000+1000*(A < 0 and 1 or 0)
                --wagon.RearBogey.MotorForce  = 27000+1000*(A < 0 and 1 or 0)
                wagon.FrontBogey.MotorForce = 22500 + 5000 * (A < 0 and 1 or 0) * math.max(wagon.KMR1.Value, wagon.KMR2.Value)
                wagon.RearBogey.MotorForce = 22500 + 5000 * (A < 0 and 1 or 0) * math.max(wagon.KMR1.Value, wagon.KMR2.Value)
                wagon.FrontBogey.Reversed = wagon.KMR2.Value > 0.5
                wagon.RearBogey.Reversed = wagon.KMR1.Value > 0.5
                -- These corrections are required to beat source engine friction at very low values of motor power
                local P = math.max(0, 0.04449 + 1.06879 * math.abs(A) - 0.465729 * A ^ 2)
                if math.abs(A) > 0.4 then P = math.abs(A) end
                --if math.abs(A) < 0.05 then P = 0 end
                if wagon.Speed < 10 and A > 0 then P = P * (1.0 + 2.5 * (10.0 - wagon.Speed) / 10.0) end
                wagon.RearBogey.MotorPower = P * 0.5 * (A > 0 and 1 or -1)
                wagon.FrontBogey.MotorPower = P * 0.5 * (A > 0 and 1 or -1)
                --wagon.RearBogey.MotorPower  = P*0.5
                --wagon.FrontBogey.MotorPower = P*0.5
                --wagon.Acc = (wagon.Acc or 0)*0.95 + wagon.Acceleration*0.05
                --print(wagon.Acc)
                -- Apply brakes
                wagon.FrontBogey.PneumaticBrakeForce = 50000.0 - 2000
                wagon.FrontBogey.BrakeCylinderPressure = wagon.Pneumatic.BrakeCylinderPressure
                wagon.FrontBogey.ParkingBrakePressure = math.max(0, (2.6 - wagon.Pneumatic.ParkingBrakePressure) / 2.6) / 2
                wagon.FrontBogey.BrakeCylinderPressure_dPdT = -wagon.Pneumatic.BrakeCylinderPressure_dPdT
                wagon.FrontBogey.DisableContacts = wagon.U5.Value > 0
                wagon.RearBogey.PneumaticBrakeForce = 50000.0 - 2000
                wagon.RearBogey.BrakeCylinderPressure = wagon.Pneumatic.BrakeCylinderPressure
                wagon.RearBogey.BrakeCylinderPressure_dPdT = -wagon.Pneumatic.BrakeCylinderPressure_dPdT
                wagon.RearBogey.ParkingBrakePressure = math.max(0, (2.6 - wagon.Pneumatic.ParkingBrakePressure) / 2.6) / 2
                wagon.RearBogey.DisableContacts = wagon.U5.Value > 0
                --wagon.RearBogey.ParkingBrake = wagon.ParkingBrake.Value > 0.5
            end

            wagon:GenerateJerks()
            return wagon.RetVal
        end
    end
end

function RECIPE:InjectNeeded()
    if Metrostroi.Version > 1537278077 then return false end
    return true
end
