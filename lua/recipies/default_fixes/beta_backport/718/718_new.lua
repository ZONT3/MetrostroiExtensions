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
MEL.DefineRecipe("718_new", "gmod_subway_81-718")
RECIPE.BackportPriority = 13
function RECIPE:Inject(ent)
    if SERVER then return end
    ent.AutoAnimNames = {}
    ent.Lights = {
        [40] = {
            "headlight",
            Vector(456.94, 7.668623, -1.99856),
            Angle(124.000000, 180.000000, 0.000000),
            Color(54, 135, 0),
            farz = 9,
            nearz = 1,
            shadows = 0,
            brightness = 4,
            fov = 80,
            hidden = "volt1"
        },
        [41] = {
            "headlight",
            Vector(459.34, -28.504929, 4.271693),
            Angle(122.713928, 210.196899, 45.703571),
            Color(255, 130, 25),
            farz = 9,
            nearz = 1,
            shadows = 1,
            brightness = 2,
            fov = 110,
            hidden = "brake_line"
        },
        [42] = {
            "headlight",
            Vector(457.08, -34.343376, 4.464308),
            Angle(122.713928, 210.196899, 45.703571),
            Color(255, 130, 25),
            farz = 9,
            nearz = 1,
            shadows = 1,
            brightness = 2,
            fov = 110,
            hidden = "brake_line"
        },
        [43] = {
            "headlight",
            Vector(428.88, -62.986473, -4.12),
            Angle(96.323837, 89.479485, -2.365463),
            Color(0, 187, 20),
            farz = 9,
            nearz = 1,
            shadows = 0,
            brightness = 2,
            fov = 80,
            hidden = "ampermeter1"
        },
        [44] = {
            "headlight",
            Vector(425.71, -62.986473, -4.12),
            Angle(96.323837, 89.479485, -2.365463),
            Color(0, 187, 20),
            farz = 9,
            nearz = 1,
            shadows = 0,
            brightness = 2,
            fov = 80,
            hidden = "ampermeter2"
        },
        [45] = {
            "headlight",
            Vector(422.32, -62.986473, -4.12),
            Angle(96.323837, 89.479485, -2.365463),
            Color(110, 162, 222),
            farz = 9,
            nearz = 1,
            shadows = 0,
            brightness = 2,
            fov = 80,
            hidden = "ampermeter3"
        },
        [46] = {
            "headlight",
            Vector(418.89, -62.986473, -4.12),
            Angle(96.323837, 89.479485, -2.365463),
            Color(110, 162, 222),
            farz = 9,
            nearz = 1,
            shadows = 0,
            brightness = 2,
            fov = 80,
            hidden = "voltmeter"
        },
        -- Headlight glow
        [1] = {
            "headlight",
            Vector(460, 0, -40),
            Angle(0, 0, 0),
            Color(216, 161, 92),
            fov = 90,
            farz = 5144,
            brightness = 4,
            texture = "models/metrostroi_train/equipment/headlight",
            shadows = 1,
            headlight = true
        },
        [2] = {
            "headlight",
            Vector(460, 0, 50),
            Angle(-20, 0, 0),
            Color(255, 0, 0),
            fov = 160,
            brightness = 0.3,
            farz = 450,
            texture = "models/metrostroi_train/equipment/headlight2",
            shadows = 0,
            backlight = true
        },
        [3] = {
            "headlight",
            Vector(365, -9, 50),
            Angle(50, 40, -0),
            Color(206, 135, 80),
            hfov = 80,
            vfov = 80,
            farz = 100,
            brightness = 6,
            shadows = 1
        },
        [4] = {
            "headlight",
            Vector(365, -51, 50),
            Angle(50, 40, -0),
            Color(206, 135, 80),
            hfov = 80,
            vfov = 80,
            farz = 100,
            brightness = 6,
            shadows = 1
        },
        -- Reverse
        [8] = {
            "light",
            Vector(465, -46.8, 52.8),
            Angle(0, 0, 0),
            Color(255, 50, 50),
            brightness = 0.2,
            scale = 2.5,
            texture = "sprites/light_glow02",
            size = 2
        },
        [9] = {
            "light",
            Vector(465, 47, 52.8),
            Angle(0, 0, 0),
            Color(255, 50, 50),
            brightness = 0.2,
            scale = 2.5,
            texture = "sprites/light_glow02",
            size = 2
        },
        [11] = {
            "dynamiclight",
            Vector(200, 0, -0),
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
            Vector(0, 0, -0),
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
            Vector(-200, 0, -0),
            Angle(0, 0, 0),
            Color(255, 175, 50),
            brightness = 3,
            distance = 400,
            fov = 180,
            farz = 128,
            changable = true
        },
        [10] = {
            "dynamiclight",
            Vector(435, 0, 20),
            Angle(0, 0, 0),
            Color(216, 161, 92),
            distance = 550,
            brightness = 0.3,
            hidden = "Cabine"
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
        [30] = {
            "light",
            Vector(465, -16, -29),
            Angle(0, 0, 0),
            Color(255, 220, 180),
            brightness = 0.2,
            scale = 2.5,
            texture = "sprites/light_glow02",
            size = 2
        },
        [31] = {
            "light",
            Vector(465, 16, -29),
            Angle(0, 0, 0),
            Color(255, 220, 180),
            brightness = 0.2,
            scale = 2.5,
            texture = "sprites/light_glow02",
            size = 2
        },
        Lamp_RTM = {
            "light",
            Vector(408.6, -51.3, 10.7),
            Angle(0, 0, 0),
            Color(255, 180, 60),
            brightness = 0.4,
            scale = 0.03,
            texture = "sprites/light_glow02",
            hidden = "Lamp_RTM"
        },
    }

    function ent.OnPlay(wagon, soundid, location, range, pitch)
        if location == "stop" then
            if IsValid(wagon.Sounds[soundid]) then
                wagon.Sounds[soundid]:Pause()
                wagon.Sounds[soundid]:SetTime(0)
            end
            return
        end

        if location == "bass" then
            if soundid == "K1" then
                local id = range > 0 and "k1_on" or "k1_off"
                local speed = wagon:GetPackedRatio("Speed")
                wagon.SoundPositions["k1_on"][1] = 440 - Lerp(speed / 0.1, 0, 330)
                return id, location, 1 - Lerp(speed / 10, 0.2, 0.8), pitch
            end

            if soundid == "K2" then
                local id = range > 0 and "k2_on" or "k2_off"
                local speed = wagon:GetPackedRatio("Speed")
                wagon.SoundPositions["k2_on"][1] = 440 - Lerp(speed / 0.1, 0, 330)
                return id, location, 1 - Lerp(speed / 10, 0.2, 0.8), pitch
            end

            if soundid == "K3" then
                local id = range > 0 and "k3_on" or "k3_off"
                local speed = wagon:GetPackedRatio("Speed")
                wagon.SoundPositions["k3_on"][1] = 440 - Lerp(speed / 0.1, 0, 330)
                return id, location, 1 - Lerp(speed / 10, 0.2, 0.8), pitch
            end

            if soundid == "KMR1" then
                local id = range > 0 and "kmr1_on" or "kmr1_off"
                local speed = wagon:GetPackedRatio("Speed")
                wagon.SoundPositions["kmr1_on"][1] = 440 - Lerp(speed / 0.1, 0, 330)
                return id, location, 1 - Lerp(speed / 10, 0.2, 0.8), pitch
            end

            if soundid == "KMR2" then
                local id = range > 0 and "kmr2_on" or "kmr2_off"
                local speed = wagon:GetPackedRatio("Speed")
                wagon.SoundPositions["kmr2_on"][1] = 440 - Lerp(speed / 0.1, 0, 330)
                return id, location, 1 - Lerp(speed / 10, 0.2, 0.8), pitch
            end

            if soundid == "brake" then
                wagon:PlayOnce("brake_f", location, range, pitch)
                wagon:PlayOnce("brake_b", location, range, pitch)
                return
            end

            if soundid == "QF1" then
                local id = range > 0 and "qf1_on" or "qf1_off"
                local speed = wagon:GetPackedRatio("Speed")
                wagon.SoundPositions["qf1_on"][1] = 440 - Lerp(speed / 0.1, 0, 330)
                return id, location, 1 - Lerp(speed / 10, 0.2, 0.8), pitch
            end

            if soundid == "UAVAC" then return "uava_reset", location, range, pitch end
        end
        return soundid, location, range, pitch
    end

    function ent.DrawPost(wagon)
        wagon.RTMaterial:SetTexture("$basetexture", wagon.RRIScreen)
        wagon:DrawOnPanel("RRIScreen", function(...)
            surface.SetMaterial(wagon.RTMaterial)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRectRotated(64, 64, 128, 128, 0)
        end)
    end

    function ent.OnAnnouncer(wagon, volume, id)
        local cabspeaker = wagon:GetPackedBool("AnnCab")
        local work = wagon:GetPackedBool("AnnPlay")
        return (id ~= 1 and work or id == 1 and cabspeaker) and volume or 0
    end

    local Cpos = {0, 0.22, 0.429, 0.513, 0.597, 0.825, 1}
    local tbl = {[0]=-0.25,0.00,0.04,0.09,0.13,0.17,0.20,0.27,0.33,0.42,0.56,0.73,1.00}
    ent.Think = function(wagon)
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

        wagon:SetLightPower(40, wagon:GetPackedBool("PanelLights"))
        wagon:SetLightPower(41, wagon:GetPackedBool("PanelLights"))
        wagon:SetLightPower(42, wagon:GetPackedBool("PanelLights"))
        wagon:SetLightPower(43, wagon:GetPackedBool("PanelLights"))
        wagon:SetLightPower(44, wagon:GetPackedBool("PanelLights"))
        wagon:SetLightPower(45, wagon:GetPackedBool("PanelLights"))
        wagon:SetLightPower(46, wagon:GetPackedBool("PanelLights"))
        local EL1 = wagon:Animate("Cablights1", wagon:GetPackedBool("Cablights1") and 1 or 0, 0, 1, 6, false)
        local EL2 = wagon:Animate("Cablights2", wagon:GetPackedBool("Cablights2") and 1 or 0, 0, 1, 6, false)
        wagon:ShowHideSmooth("lampcab1", EL1)
        wagon:ShowHideSmooth("lampcab2", EL2)
        local cabStrength = EL1 * 0.5 + EL2 * 0.5
        wagon:SetLightPower(10, cabStrength > 0, cabStrength)
        local HL1 = wagon:Animate("Headlights1", wagon:GetPackedBool("Headlights1") and 1 or 0, 0, 1, 6, false)
        local HL2 = wagon:Animate("Headlights2", wagon:GetPackedBool("Headlights2") and 1 or 0, 0, 1, 6, false)
        local RL = wagon:Animate("RedLights_a", wagon:GetPackedBool("RedLights") and 1 or 0, 0, 1, 6, false)
        wagon:ShowHideSmooth("Headlights_1", HL1)
        wagon:ShowHideSmooth("Headlights_2", HL2)
        local bright = HL1 * 0.5 + HL2 * 0.5
        wagon:SetLightPower(30, bright > 0, bright)
        wagon:SetLightPower(31, bright > 0, bright)
        wagon:ShowHideSmooth("RedLights", RL)
        wagon:SetLightPower(8, RL > 0, RL)
        wagon:SetLightPower(9, RL > 0, RL)
        local headlight = HL1 * 0.6 + HL2 * 0.4
        wagon:SetLightPower(1, headlight > 0, headlight)
        wagon:SetLightPower(2, wagon:GetPackedBool("RedLights"), RL)
        if IsValid(wagon.GlowingLights[1]) then
            if wagon:GetPackedRatio("Headlight") < 0.5 and wagon.GlowingLights[1]:GetFarZ() ~= 3144 then wagon.GlowingLights[1]:SetFarZ(3144) end
            if wagon:GetPackedRatio("Headlight") > 0.5 and wagon.GlowingLights[1]:GetFarZ() ~= 5144 then wagon.GlowingLights[1]:SetFarZ(5144) end
        end

        local RN = wagon:GetPackedBool("RouteNumberWork", false)
        wagon:ShowHide("route1", RN)
        wagon:ShowHide("route2", RN)
        wagon:ShowHide("route1_r", RN)
        wagon:ShowHide("route2_r", RN)
        wagon:ShowHide("route1_s", RN)
        wagon:ShowHide("route2_s", RN)
        local lamps_rtm = wagon:Animate("lamps_rtm", wagon:GetPackedBool("VPR") and 1 or 0, 0, 1, 8, false)
        wagon:SetSoundState("vpr", lamps_rtm > 0 and 1 or 0, 1)
        wagon:ShowHideSmooth("Lamp_RTM", lamps_rtm or 0)
        wagon:SetLightPower("Lamp_RTM", lamps_rtm > 0, lamps_rtm)
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
        for i = 1, 28 do
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
                wagon:SetLightPower(i, activeLights > 0, activeLights / 28)
            end
        end

        wagon:Animate("brake_line", wagon:GetPackedRatio("BLPressure"), 0.14, 0.873, 64, 12) --256,2)
        wagon:Animate("train_line", wagon:GetPackedRatio("TLPressure"), 0.145, 0.876, 64, 12) --4096,2)
        wagon:Animate("brake_cylinder", wagon:GetPackedRatio("BCPressure"), 0.142, 0.874, 64, 12) --64,12)
        wagon:Animate("brake013", Cpos[wagon:GetPackedRatio("B013")] or 0, 0.03, 0.458, 256, 24)
        wagon:Animate("controller", (wagon:GetPackedRatio("Controller") + 3) / 6, 0.05, 0.33, 3, false)
        wagon:Animate("kr_wrench", wagon:GetPackedRatio("KR", 0), 0.3 + 0.05, 0.8 - 0.05, 3, false)
        wagon:Animate("kru_wrench", wagon:GetPackedRatio("KRU", 0), 0.3 + 0.05, 0.8 - 0.05, 3, false)
        wagon:ShowHide("kr_wrench", wagon:GetNW2Int("Wrench", 0) == 1)
        wagon:ShowHide("kru_wrench", wagon:GetNW2Int("Wrench", 0) == 2)
        wagon:Animate("volt1", wagon:GetPackedRatio("BatteryVoltage"), 0.867, 0.626, 45, 2)
        wagon:Animate("voltmeter", wagon:GetPackedRatio("EnginesVoltage"), 0.866, 0.621 - 0.008, nil, nil)
        wagon:Animate("ampermeter1", wagon:GetPackedRatio("EnginesCurrent13"), 0.859 + 0.003, 0.625 - 0.003, nil, nil)
        wagon:Animate("ampermeter2", wagon:GetPackedRatio("EnginesCurrent24"), 0.859 + 0.003, 0.625 - 0.003, nil, nil)
        wagon:Animate("ampermeter3", wagon:GetPackedRatio("BatteryCurrent"), 0.859 + 0.01, 0.625 - 0.01, nil, nil)
        wagon:Animate("UAVALever", wagon:GetPackedBool("UAVA") and 1 or 0, 0, 0.6, 128, 3, false)
        wagon:Animate("PB", wagon:GetPackedBool("PB") and 1 or 0, 0, 0.2, 12, false)
        wagon:Animate("stopkran", wagon:GetPackedBool("EmergencyBrakeValve") and 0 or 1, 0.25, 0, 128, 3, false)
        --wagon:Animate("Autodrive",     wagon:GetPackedBool(132) and 1 or 0, 0,1, 16, false)
        local otsek1 = wagon:Animate("door_otsek1", wagon:GetPackedBool("OtsekDoor1") and 1 or 0, 0, 0.25, 4, 0.5)
        local otsek2 = wagon:Animate("door_otsek2", (wagon:GetPackedBool("OtsekDoor2") or wagon.CurrentCamera == 9) and 1 or 0, 0, 0.25, 4, 0.5)
        wagon:HidePanel("PVZ", otsek2 <= 0)
        wagon:HidePanel("BUV_MPS", otsek2 <= 0)
        wagon:HidePanel("BUV_MVD", otsek2 <= 0)
        wagon:HidePanel("BUV_MALP1", otsek2 <= 0)
        wagon:HidePanel("BUV_MALP2", otsek2 <= 0)
        wagon:HidePanel("BUV_MIV", otsek2 <= 0)
        wagon:HidePanel("BUV_MGR", otsek2 <= 0)
        wagon:HidePanel("BUV_MLUA", otsek2 <= 0)
        wagon:HidePanel("BUV_MUVK1", otsek2 <= 0)
        wagon:HidePanel("BUV_MUVK2", otsek2 <= 0)
        wagon:HidePanel("RRI", otsek2 <= 0)
        wagon:HidePanel("RRIScreen", otsek2 <= 0)
        wagon:ShowHide("E_informator", otsek2 > 0)
        local door1 = wagon:Animate("door1", wagon:GetPackedBool("RearDoor") and 1 or 0, 0, 0.25, 4, 0.5)
        local door2 = wagon:Animate("door2", wagon:GetPackedBool("PassengerDoor") and 1 or 0, 1, 0.8, 4, 0.5)
        local door3 = wagon:Animate("door3", wagon:GetPackedBool("CabinDoor") and 1 or 0, 0, 0.25, 4, 0.5)
        if wagon.Door1 ~= (door1 > 0) then
            wagon.Door1 = door1 > 0
            wagon:PlayOnce("door1", "bass", wagon.Door1 and 1 or 0)
        end

        if wagon.Door2 ~= (door2 < 1) then
            wagon.Door2 = door2 < 1
            wagon:PlayOnce("door2", "bass", wagon.Door2 and 1 or 0)
        end

        if wagon.Door3 ~= (door3 > 0) then
            wagon.Door3 = door3 > 0
            wagon:PlayOnce("door3", "bass", wagon.Door3 and 1 or 0)
        end

        if wagon.Otsek1 ~= (otsek1 > 0) then
            wagon.Otsek1 = otsek1 > 0
            if not wagon.Otsek1 then wagon:PlayOnce("door_otsek1", "bass", 1) end
        end

        if wagon.Otsek2 ~= (otsek2 > 0) then
            wagon.Otsek2 = otsek2 > 0
            if not wagon.Otsek2 then wagon:PlayOnce("door_otsek2", "bass", 1) end
        end

        wagon:SetLightPower(3, wagon.Otsek1 and wagon:GetPackedBool("AppLights"))
        wagon:SetLightPower(4, wagon.Otsek2 and wagon:GetPackedBool("AppLights"))
        wagon:Animate("FrontBrake", wagon:GetNW2Bool("FbI") and 0 or 1, 0, 1, 3, false)
        wagon:Animate("FrontTrain", wagon:GetNW2Bool("FtI") and 1 or 0, 0, 1, 3, false)
        wagon:Animate("RearBrake", wagon:GetNW2Bool("RbI") and 0 or 1, 0, 1, 3, false)
        wagon:Animate("RearTrain", wagon:GetNW2Bool("RtI") and 1 or 0, 0, 1, 3, false)
        wagon:ShowHide("SPU_Speed1", wagon:GetPackedBool("Speedometer"))
        wagon:ShowHide("SPU_Speed2", wagon:GetPackedBool("Speedometer"))
        if wagon:GetPackedBool("Speedometer") then
            local speed = wagon:GetPackedRatio("Speed") * 100.0
            if IsValid(wagon.ClientEnts["SPU_Speed1"]) then wagon.ClientEnts["SPU_Speed1"]:SetSkin(math.floor(speed) % 10) end
            if IsValid(wagon.ClientEnts["SPU_Speed2"]) then wagon.ClientEnts["SPU_Speed2"]:SetSkin(math.floor(speed / 10)) end
        end

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
        for i = 1, 7 do
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

        --[[local dT = wagon.DeltaTime
        --wagon.TunnelCoeff = 0.8
        --wagon.StreetCoeff = 0
        local rollingi = math.min(1,wagon.TunnelCoeff+math.Clamp((wagon.StreetCoeff-0.82)/0.3,0,1))
        local rollings = math.max(wagon.TunnelCoeff*0.6,wagon.StreetCoeff)
        --if wagon:EntIndex() == 3239 then LocalPlayer():ChatPrint(Format("T: %.2f, S: %.2f",rollingi,rollings)) end
        -- Brake-related sounds
        local dT = wagon.DeltaTime
        local speed = wagon:GetPackedRatio("Speed")*100.0
        local rol5 = math.Clamp(speed/1,0,1)*(1-math.Clamp((speed-3)/8,0,1))
        local rol10 = math.Clamp(speed/12,0,1)*(1-math.Clamp((speed-25)/8,0,1))
        local rol40p = Lerp((speed-25)/12,0.6,1)
        local rol40 = math.Clamp((speed-23)/8,0,1)*(1-math.Clamp((speed-55)/8,0,1))
        local rol40p = Lerp((speed-23)/50,0.6,1)
        local rol70 = math.Clamp((speed-50)/8,0,1)*(1-math.Clamp((speed-72)/5,0,1))
        local rol70p = Lerp(0.8+(speed-65)/25*0.2,0.8,1.2)
        local rol80 = math.Clamp((speed-70)/5,0,1)
        local rol80p = Lerp(0.8+(speed-72)/15*0.2,0.8,1.2)
        wagon:SetSoundState("rolling_5",math.min(1,rollingi*(1-rollings)+rollings*0.8)*rol5,1)
        wagon:SetSoundState("rolling_10",rollingi*rol10,1)
        wagon:SetSoundState("rolling_40",rollingi*rol40,rol40p)
        wagon:SetSoundState("rolling_70",rollingi*rol70,rol70p)
        wagon:SetSoundState("rolling_80",rollingi*rol80,rol80p)]]
        local dT = wagon.DeltaTime
        local rollingi = math.min(1, wagon.TunnelCoeff + math.Clamp((wagon.StreetCoeff - 0.82) / 0.3, 0, 1))
        local rollings = math.max(wagon.TunnelCoeff * 0.6, wagon.StreetCoeff)
        local speed = wagon:GetPackedRatio("Speed") * 100.0
        local rol5 = math.Clamp(speed / 1, 0, 1) * (1 - math.Clamp((speed - 3) / 8, 0, 1))
        local rol10 = math.Clamp(speed / 12, 0, 1) * (1 - math.Clamp((speed - 25) / 8, 0, 1))
        local rol40p = Lerp((speed - 25) / 12, 0.6, 1)
        --local rol40 = math.Clamp((speed-23)/8,0,1)*(1-math.Clamp((speed-55)/8,0,1))
        --local rol40p = Lerp((speed-23)/50,0.6,1)
        --local rol70 = math.Clamp((speed-50)/8,0,1)*(1-math.Clamp((speed-72)/5,0,1))
        --local rol70p = Lerp(0.8+(speed-65)/25*0.2,0.8,1.2)
        --local rol80 = math.Clamp((speed-70)/5,0,1)
        --local rol80p = Lerp(0.8+(speed-72)/15*0.2,0.8,1.2)
        wagon:SetSoundState("rolling_5", math.min(1, rollingi * (1 - rollings) + rollings * 0.8) * rol5, 1)
        wagon:SetSoundState("rolling_10", rollingi * rol10, 1)
        --wagon:SetSoundState("rolling_40",0*rollingi*rol40,rol40p)
        --wagon:SetSoundState("rolling_70",0*rollingi*rol70,rol70p)
        --wagon:SetSoundState("rolling_80",0*rollingi*rol80,rol80p)
        local rol32 = math.Clamp((speed - 25) / 13, 0, 1) * (1 - math.Clamp((speed - 40) / 10, 0, 1))
        local rol32p = Lerp((speed - 20) / 50, 0.8, 1.2)
        local rol68 = math.Clamp((speed - 40) / 10, 0, 1) * (1 - math.Clamp((speed - 50) / 20, 0, 1))
        local rol68p = Lerp(0.6 + (speed - 68) / 26 * 0.2, 0.6, 1.4)
        local rol75 = math.Clamp((speed - 55) / 20, 0, 1)
        local rol75p = Lerp(0.8 + (speed - 75) / 15 * 0.2, 0.6, 1.2)
        wagon:SetSoundState("rolling_32", rollingi * rol32, rol32p)
        wagon:SetSoundState("rolling_68", rollingi * rol68, rol68p)
        wagon:SetSoundState("rolling_75", rollingi * rol75, rol75p)
        --[[
        local rol_motors = math.Clamp((speed-55)/10,0,1) ---ANY IDEAS?? MOTORS BACKGROUND SOUNDS AT HISPEED
        local rol_motorsp = Lerp((speed-72)/25*0.2,0.85,1.1)
        wagon:SetSoundState("rolling_motors",rol_motors,rol_motorsp) ---ANY IDEAS??--]]
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
        local ramp = wagon:GetPackedRatio("Crane_dPdT", 0)
        if ramp > 0 then
            wagon.CraneRamp = wagon.CraneRamp + (0.2 * ramp - wagon.CraneRamp) * dT
        else
            wagon.CraneRamp = wagon.CraneRamp + (0.9 * ramp - wagon.CraneRamp) * dT
        end

        wagon.CraneRRamp = math.Clamp(wagon.CraneRRamp + 1.0 * (1 * ramp - wagon.CraneRRamp) * dT, 0, 1)
        wagon:SetSoundState("crane013_release", wagon.CraneRRamp ^ 1.5, 1.0)
        wagon:SetSoundState("crane013_brake", math.Clamp(-wagon.CraneRamp * 1.5, 0, 1) ^ 1.3, 1.0)
        wagon:SetSoundState("crane013_brake2", math.Clamp(-wagon.CraneRamp * 1.5 - 0.95, 0, 1.5) ^ 2, 1.0)
        local emergencyValveEPK = wagon:GetPackedRatio("EmergencyValveEPK_dPdT", 0)
        wagon.EmergencyValveEPKRamp = math.Clamp(wagon.EmergencyValveEPKRamp + 1.0 * (0.5 * emergencyValveEPK - wagon.EmergencyValveEPKRamp) * dT, 0, 1)
        if wagon.EmergencyValveEPKRamp < 0.01 then wagon.EmergencyValveEPKRamp = 0 end
        wagon:SetSoundState("epk_brake", wagon.EmergencyValveEPKRamp, 1.0)
        local emergencyBrakeValve = wagon:GetPackedRatio("EmergencyBrakeValve_dPdT", 0)
        wagon.EmergencyBrakeValveRamp = math.Clamp(wagon.EmergencyBrakeValveRamp + (emergencyBrakeValve - wagon.EmergencyBrakeValveRamp) * dT * 8, 0, 1)
        wagon:SetSoundState("valve_brake", wagon.EmergencyBrakeValveRamp, 0.8 + math.min(0.4, wagon.EmergencyBrakeValveRamp * 0.8))
        local emergencyValve = wagon:GetPackedRatio("EmergencyValve_dPdT", 0) ^ 0.4 * 1.2
        wagon.EmergencyValveRamp = math.Clamp(wagon.EmergencyValveRamp + (emergencyValve - wagon.EmergencyValveRamp) * dT * 16, 0, 1)
        local emer_brake = math.Clamp((wagon.EmergencyValveRamp - 0.9) / 0.05, 0, 1)
        local emer_brake2 = math.Clamp((wagon.EmergencyValveRamp - 0.2) / 0.4, 0, 1) * (1 - math.Clamp((wagon.EmergencyValveRamp - 0.9) / 0.1, 0, 1))
        wagon:SetSoundState("emer_brake", emer_brake, 1)
        wagon:SetSoundState("emer_brake2", emer_brake2, math.min(1, 0.8 + 0.2 * emer_brake2))
        --wagon:SetSoundState("emer_brake",wagon.EmergencyValveRamp*0.8,1)
        --wagon:SetSoundState("emer_brake",wagon.EmergencyValveRamp*0.8,1)
        -- Compressor
        wagon:SetSoundState("compressor", wagon:GetPackedBool("Compressor") and 0.6 or 0, 1)
        wagon:SetSoundState("compressor2", wagon:GetPackedBool("Compressor") and 0.8 or 0, 1)
        local vCstate = wagon:GetPackedRatio("M1") / 2
        if wagon.VentCab < vCstate then
            wagon.VentCab = math.min(1, wagon.VentCab + dT / 2.7)
        elseif wagon.VentCab > vCstate then
            wagon.VentCab = math.max(0, wagon.VentCab - dT / 2.7)
        end

        wagon:SetSoundState("vent_cabl", math.Clamp(wagon.VentCab * 2, 0, 1), 1)
        wagon:SetSoundState("vent_cabh", math.Clamp((wagon.VentCab - 0.5) * 2, 0, 1), 1)
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
        wagon:SetSoundState("ring", (wagon:GetPackedBool("Ring") or wagon:GetPackedBool("RingBZOS") and RealTime() % 0.8 < 0.35) and 1 or 0, 0.95)
        wagon:SetSoundState("bpsn", wagon:GetPackedBool("BBE") and 1 or 0, 1.0) --FIXME громкость по другому
        local cabspeaker = wagon:GetPackedBool("AnnCab")
        local work = wagon:GetPackedBool("AnnPlay")
        local buzz = wagon:GetPackedBool("AnnBuzz") and wagon:GetNW2Int("AnnouncerBuzz", -1) > 0
        for k in ipairs(wagon.AnnouncerPositions) do
            wagon:SetSoundState("announcer_buzz" .. k, (buzz and (k ~= 1 and work or k == 1 and cabspeaker)) and 1 or 0, 1)
        end

        for k, v in ipairs(wagon.AnnouncerPositions) do
            if IsValid(wagon.Sounds["announcer" .. k]) then wagon.Sounds["announcer" .. k]:SetVolume((k ~= 1 and work or k == 1 and cabspeaker) and (v[3] or 1) or 0) end
        end
    end
end

function RECIPE:InjectNeeded()
    if Metrostroi.Version > 1537278077 then return false end
    return true
end
