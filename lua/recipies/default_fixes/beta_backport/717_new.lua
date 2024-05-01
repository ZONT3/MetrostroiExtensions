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
MEL.DefineRecipe("717_new", "gmod_subway_81-717_mvm")
function RECIPE:Inject(ent)
    -- Setup door positions
    local function GetDoorPosition(i, k)
        return Vector(359.0 - 35 / 2 - 229.5 * i, -65 * (1 - 2 * k), 7.5)
    end

    ent.LeftDoorPositions = {}
    ent.RightDoorPositions = {}
    for i = 1, 4 do
        table.insert(ent.LeftDoorPositions, GetDoorPosition(i - 1, 1))
        table.insert(ent.RightDoorPositions, GetDoorPosition(i - 1, 0))
    end

    MEL.InjectIntoSharedFunction(ent, "InitializeSounds", function(wagon)
        wagon.SoundPositions["rolling_5"] = {480, 1e12, Vector(0, 0, 0), 0.05}
        wagon.SoundPositions["rolling_10"] = {480, 1e12, Vector(0, 0, 0), 0.1}
        wagon.SoundNames["rolling_32"] = {
            loop = true,
            "subway_trains/717/rolling/rolling_32.wav"
        }

        wagon.SoundNames["rolling_68"] = {
            loop = true,
            "subway_trains/717/rolling/rolling_68.wav"
        }

        wagon.SoundNames["rolling_75"] = {
            loop = true,
            "subway_trains/717/rolling/rolling_75.wav"
        }

        wagon.SoundPositions["rolling_32"] = {480, 1e12, Vector(0, 0, 0), 0.2}
        wagon.SoundPositions["rolling_68"] = {480, 1e12, Vector(0, 0, 0), 0.4}
        wagon.SoundPositions["rolling_75"] = {480, 1e12, Vector(0, 0, 0), 0.8}
        wagon.SoundNames["lk2c"] = "subway_trains/717/pneumo/ksh1.mp3"
        wagon.SoundPositions["lk2c"] = {440, 1e9, Vector(-60, -40, -66), 0.6}
        wagon.SoundPositions["crane013_brake"] = {400, 1e9, Vector(431.5, -20.3, -12), 0.86}
        wagon.SoundPositions["crane013_brake2"] = {400, 1e9, Vector(431.5, -20.3, -12), 0.86}
        wagon.SoundPositions["crane013_brake_l"] = {400, 1e9, Vector(431.5, -20.3, -12), 0.7}
        wagon.SoundNames["IST"] = {
            loop = true,
            "subway_trains/717/ring/son17.wav"
        }

        wagon.SoundPositions["IST"] = {60, 1e9, Vector(443.8, 0, -3.2), 0.15}
        for i = 1, 5 do
            wagon.SoundNames["vdol_loud" .. i] = "subway_trains/common/pneumatic/door_valve/vdo" .. (2 + i) .. "_on.mp3"
            wagon.SoundNames["vdop_loud" .. i] = wagon.SoundNames["vdol_loud" .. i]
            wagon.SoundNames["vzd_loud" .. i] = wagon.SoundNames["vdol_loud" .. i]
            wagon.SoundPositions["vdol_loud" .. i] = {100, 1e9, Vector(-420, 45, -30), 1}
            wagon.SoundPositions["vdop_loud" .. i] = wagon.SoundPositions["vdol_loud" .. i]
            wagon.SoundPositions["vzd_loud" .. i] = wagon.SoundPositions["vdol_loud" .. i]
        end

        for k, v in ipairs(wagon.AnnouncerPositions) do
            wagon.SoundNames["announcer_buzz" .. k] = {
                loop = true,
                "subway_announcers/asnp/bpsn_ann.wav"
            }

            wagon.SoundPositions["announcer_buzz" .. k] = {v[2] or 600, 1e9, v[1], v[3] / 6}
            wagon.SoundNames["announcer_buzz_o" .. k] = {
                loop = true,
                "subway_announcers/upo/noiseT2.wav"
            }

            --self.SoundNames["announcer_buzz_o"..k] = {loop=true,"subway_announcers/riu/bpsn_ann.wav"}
            wagon.SoundPositions["announcer_buzz_o" .. k] = {v[2] or 600, 1e9, v[1], v[3] / 6}
        end
    end, 1)

    MEL.InjectIntoSharedFunction(ent, "PostInitializeSystems", function(wagon)
        if CLIENT then return MEL.Return end
        wagon.BIS200:TriggerInput("SpeedDec", 1)
    end)

    ent.NumberRanges = {
        --717 МВМ
        {true, {0001, 0002, 0003, 0004, 0007, 0008, 0009, 0010, 0011, 0012, 0013, 0014, 0015, 0015, 0016, 0017, 0018, 0019, 0020, 0021, 0022, 0023, 0044, 0045, 0046, 0047, 0048, 0049, 0050, 0051, 0052, 0053, 0054, 0055, 0056, 0066, 0068, 0069, 0070, 0071, 0072, 0073, 0078, 0080, 0084, 0085, 0086, 0123, 0124, 0125, 0126, 0127, 0128, 0130, 0131, 0132, 0133, 0134, 0135, 0136, 0137, 0138, 0139, 0140, 0141, 0142, 0143, 0144, 0145, 0146, 0147, 0148, 0149, 0150, 0151, 0152, 0153}, {false, false, true, true, {"Def_717MSKWhite", "Def_717MSKWood4"}, true}},
        {
            true,
            {9052, 9053, 9054, 9055, 9056, 9057, 9058, 9059, 9060, 9061, 9062, 9063, 9064, 9065, 9066, 9067, 9068, 9069, 9070, 9071, 9072, 9074, 9076, 9078, 9079, 9092, 9093, 9094, 9095, 9096, 9097, 9098, 9099, 9100, 9101, 9102, 9103, 9104, 9105, 9106, 9107, 9108, 9109, 9110, 9111, 9112, 9113, 9114, 9115, 9116, 9117, 9118, 9119, 9120, 9121, 9122, 9123, 9124, 9125, 9126, 9127, 9128, 9139, 9142, 9146, 9147, 9148, 9149, 9150, 9151, 9152, 9153, 9154, 9155, 9156, 9157, 9158, 9159, 9160, 9161, 9162, 9163, 9167, 9169, 9173, 9180, 9182, 9185, 9186, 9187, 9188, 9189, 9190, 9191, 9192, 9193, 9194, 9195, 9196, 9197, 9198, 9199, 9200, 9201, 9202, 9203, 9204, 9205, 9206, 9207, 9208, 9209, 9210, 9211, 9212, 9213, 9214, 9215, 9216, 9217, 9218, 9219, 9220, 9221, 9222, 9223, 9224, 9225, 9226, 9227, 9228, 9229, 9230, 9231, 9232, 9233, 9234, 9235, 9239, 9240, 9241, 9242, 9243, 9244, 9247, 9248, 9249, 9251, 9253, 9268, 9269, 9270, 9271, 9272, 9273, 9274, 9275, 9276, 9277, 9278, 9280, 9281, 9282, 9283, 9284, 9285, 9286, 9287, 9288, 9289, 9290, 9291, 9293, 9311, 9312, 9313, 9314, 9336, 9337, 9338, 9339, 9342, 9347, 9349},
            {
                false, --[[ "Def_717MSKWood",--]]
                false,
                false,
                true,
                {"Def_717MSKBlue", "Def_717MSKWhite", "Def_717MSKWood2"},
                function(id, tex) return tex == "Def_717MSKWhite" or math.random() > 0.5 end
            }
        },
        --717 ЛВЗ
        {true, {8400, 8401, 8411, 8412, 8413, 8414, 8415, 8416, 8417, 8418, 8419, 8420, 8421, 8422, 8423, 8424, 8425, 8426, 8427, 8428, 8429, 8459, 8460, 8461, 8462, 8465, 8466, 8499, 8500, 8501, 8502, 8503, 8504, 8505, 8506, 8507, 8508, 8509, 8510, 8511, 8512, 8513, 8514, 8515, 8516, 8517, 8518, 8519, 8520, 8521, 8522, 8523, 8524, 8525, 8526, 8527, 8528, 8529, 8530, 8531, 8532, 8533, 8534, 8535, 8536, 8537, 8538, 8539, 8547, 8548, 8549, 8550, 8551, 8552, 8553, 8554, 8555, 8556, 8557, 8558, 8559, 8560, 8561, 8586, 8587, 8596, 8597, 8611, 8612, 8613, 8614, 8615, 8616, 8617, 8618, 8619, 8620, 8621, 8705, 8706, 8707, 8708, 8709, 8710, 8711, 8712, 8713, 8714, 8715, 8716, 8717, 8718, 8719, 8720, 8721, 8722, 8723, 8724, 8725, 8726, 8727, 8728, 8730, 8731, 8732, 8733, 8734, 8745, 8746, 8753, 8760, 8791, 8792, 8802, 8803, 8804, 8816, 8828, 8829, 8831}, {true, false, false, false, {"Def_717MSKWhite"}, true}},
        --717.5 МВМ
        {true, {0154, 0155, 0156, 0157, 0158, 0159, 0160, 0161, 0162, 0163, 0164, 0165, 0166, 0167, 0168, 0169, 0170, 0172, 0173, 0174, 0175, 0176, 0177}, {false, true, false, true, {"Def_717MSKWhite", "Def_717MSKWood4"}, true, true}},
        {true, {0218, 0219, 0220, 0221, 0222, 0223, 0224, 0225, 0226, 0227, 0228, 0229, 0236, 0241, 0242, 0243, 0244, 0249, 0252, 0253, 0254, 0255, 0263, 0264, 0265, 0266, 0267, 0284, 0285, 0286, 0287, 0290, 0292, 0293, 0294, 0295, 0297, 0298, 0299, 0300, 0301, 0308, 0315, 0320, 0333, 0334}, {false, true, true, true, {"Def_717MSKWhite", "Def_717MSKWood4"}, true, true}},
        --717.5 ЛВЗ
        {true, {8876, 8877, 8881, 8882, 8883, 8884, 8885, 8886, 8891, 8892, 8893, 8894, 8931, 8932, 8933, 8934, 8935, 8936, 8937, 8938, 8939, 8940, 8941, 8941, 8942, 8943, 8944, 8945, 8946, 8947, 8965, 8966, 8967, 8968, 8969, 8970, 8983, 8984, 8985, 8986, 8987, 8988, 8989, 8995, 8996, 8997, 8998, 8999}, {true, true, false, true, {"Def_717MSKWhite", "Def_717MSKWood4"}, true, true}},
        {true, {10000, 10001, 10002, 10008, 10009, 10010, 10011, 10012, 10013, 10034, 10035, 10038, 10039, 10040, 10057, 10058, 10059, 10060, 10077, 10078, 10079, 10087, 10088, 10089, 10090, 10091, 10092, 10093, 10094, 10099, 10100, 10101, 10102, 10103, 10106, 10107, 10108, 10109, 10113, 10114, 10115, 10116, 10118, 10119, 10120, 10121, 10122, 10123, 10131, 10132, 10141, 10142, 10143, 10144, 10145, 10146, 10149, 10150, 10151, 10152, 10153, 10154, 10155, 10156, 10157, 10158, 10159, 10160, 10161, 10164, 10165, 10166, 10167, 10168, 10169, 10170, 10190, 10191, 10197, 10199, 10206, 10207}, {true, true, true, true, {"Def_717MSKWhite", "Def_717MSKWood4"}, function(id) return id <= 10010 end, true}},
    }

    MEL.NewButtonMapButton(ent, "Block2_1", {
        ID = "!LampLEKK",
        x = 215.5 - 0.4 * 1,
        y = 31.8 + 19.7 * 0,
        tooltip = "",
        radius = 3,
        model = {
            name = "RLEKK",
            lamp = {
                speed = 24,
                model = "models/metrostroi_train/81-502/lamps/svetodiod_small_502.mdl",
                color = Color(175, 250, 20),
                z = -3.5,
                var = "LN"
            },
            sprite = {
                bright = 0.5,
                size = 0.25,
                scale = 0.01,
                color = Color(175, 250, 20),
                z = -1,
            }
        }
    })

    MEL.NewButtonMapButton(ent, "Block7", {
        ID = "VKSTToggle",
        x = 28,
        y = 57,
        radius = 20,
        tooltip = "",
        model = {
            model = "models/metrostroi_train/81-717/udkst.mdl",
            ang = 180,
            z = -2.4,
            var = "VKST",
            speed = 16,
            sndvol = 1,
            snd = function(val) return val and "switch_on" or "switch_off" end,
            sndmin = 90,
            sndmax = 1e3,
            sndang = Angle(-90, 0, 0),
        }
    })

    MEL.NewButtonMapButton(ent, "Block7", {
        ID = "!IST",
        x = 43,
        y = 57,
        radius = 8,
        tooltip = "",
        model = {
            lamp = {
                model = "models/metrostroi_train/81-502/lamps/svetodiod_small_502.mdl",
                z = 0,
                color = Color(255, 50, 45),
                var = "IST"
            },
            sprite = {
                bright = 0.5,
                size = 0.25,
                scale = 0.01,
                color = Color(255, 50, 45),
                z = -1.4,
            }
        }
    })

    MEL.NewButtonMap(ent, "AutostopValve", {
        pos = Vector(365.8, -67.6, -56),
        ang = Angle(0, 0, 90),
        width = 130,
        height = 40,
        scale = 0.1,
        hideseat = 0.1,
        -- hide = true,
        -- screenHide = true,
        buttons = {
            {
                ID = "AutostopValveSet",
                x = 0,
                y = 0,
                w = 130,
                h = 40,
                tooltip = "Сорвать срывной клапан"
            },
        }
    })

    MEL.InjectIntoClientFunction(ent, "Initialize", function(wagon)
        wagon.Door1 = false
        wagon.Door2 = false
        wagon.Door3 = false
        wagon.Otsek1 = false
        wagon.Otsek2 = false
        wagon.ParkingBrake1 = true
        wagon.ParkingBrake2 = true
        wagon.DoorStates = {}
        wagon.DoorLoopStates = {}
        for i = 0, 3 do
            for k = 0, 1 do
                wagon.DoorStates[(k == 1 and "DoorL" or "DoorR") .. (i + 1)] = false
            end
        end
    end)

    MEL.InjectIntoServerFunction(ent, "Initialize", function(wagon)
        local pneumoPow = 0.8 + (math.random() ^ 1.55) * 0.4
        wagon.FrontCouple.EKKDisconnected = true
        table.insert(wagon.InteractionZones, {
            ID = "AutostopValveToggle",
            Pos = Vector(377, -66, -50),
            Radius = 20,
        })
    end, 1)

    if SERVER then
        table.insert(ent.SyncTable, "VKST")
        function ent.TriggerLightSensor(wagon, coil, plate)
            if plate.PlateType == METROSTROI_UPPSSENSOR then wagon.UPPS:TriggerSensor(coil, plate) end
        end
    end

    MEL.InjectIntoServerFunction(ent, "OnButtonPress", function(wagon, button, ply)
        if button == "KVT" then
            wagon.KVT:TriggerInput("Set", 1)
            wagon.KVTR:TriggerInput("Set", 1)
            return MEL.Return
        end
    end)

    MEL.InjectIntoServerFunction(ent, "OnButtonRelease", function(wagon, button, ply)
        if button == "KVT" then
            wagon.KVT:TriggerInput("Set", 0)
            wagon.KVTR:TriggerInput("Set", 0)
            return MEL.Return
        end
    end)

    ent.InitializeSystems = function(wagon)
        -- Электросистема 81-710
        wagon:LoadSystem("Electric", "81_717_Electric_EXT")
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
        -- Резисторы для цепей управления
        --wagon:LoadSystem("YAS_44V")
        wagon:LoadSystem("Reverser", "PR_722D")
        -- Реостатный контроллер для управления пусковыми сопротивления
        wagon:LoadSystem("RheostatController", "EKG_17B")
        -- Групповой переключатель положений
        wagon:LoadSystem("PositionSwitch", "PKG_761")
        -- Кулачковый контроллер
        wagon:LoadSystem("KV", "KV_70")
        -- Контроллер резервного управления
        wagon:LoadSystem("KRU")
        -- Ящики с реле и контакторами
        wagon:LoadSystem("BV", "BV_630")
        wagon:LoadSystem("LK_755A")
        wagon:LoadSystem("YAR_13B", "YAR_13B_EXT")
        wagon:LoadSystem("YAR_27", "YAR_27_EXT", "MSK")
        wagon:LoadSystem("YAK_36")
        wagon:LoadSystem("YAK_37E")
        wagon:LoadSystem("YAS_44V")
        wagon:LoadSystem("YARD_2")
        wagon:LoadSystem("PR_14X_Panels")
        -- Пневмосистема 81-717
        wagon:LoadSystem("Pneumatic", "81_717_Pneumatic_EXT")
        -- Панель управления 81-717
        wagon:LoadSystem("Panel", "81_717_Panel_EXT")
        -- Everything else
        wagon:LoadSystem("Battery")
        wagon:LoadSystem("PowerSupply", "BPSN_EXT")
        wagon:LoadSystem("ALS_ARS", "ALS_ARS_D")
        wagon:LoadSystem("Horn")
        wagon:LoadSystem("IGLA_CBKI", "IGLA_CBKI1_EXT")
        wagon:LoadSystem("IGLA_PCBK")
        wagon:LoadSystem("UPPS")
        wagon:LoadSystem("BZOS", "81_718_BZOS")
        wagon:LoadSystem("Announcer", "81_71_Announcer", "AnnouncementsASNP")
        wagon:LoadSystem("ASNP", "81_71_ASNP_EXT")
        wagon:LoadSystem("ASNP_VV", "81_71_ASNP_VV")
        wagon:LoadSystem("RouteNumber", "81_71_RouteNumber", 2)
        wagon:LoadSystem("LastStation", "81_71_LastStation", "717", "destination")
    end

    function ent.UpdateLampsColors(wagon)
        local lCol, lCount = Vector(), 0
        local rand = math.random() > 0.8 and 1 or math.random(0.95, 0.99)
        if wagon.LampType == 1 then
            local r, g, col = 15, 15
            local typ = math.Round(math.random())
            local rnd = 0.5 + math.random() * 0.5
            for i = 1, 12 do
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
            for i = 1, 25 do
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
                    if not IsValid(ent) then return end
                    wagon.BV:TriggerInput("Enable", 1)
                end)
            end

            wagon.GV:TriggerInput("Set", val < 4 and 1 or 0)
            wagon._SpawnerStarted = val
        end

        wagon.Pneumatic.TrainLinePressure = val == 3 and math.random() * 4 or val == 2 and 4.5 + math.random() * 3 or 7.6 + math.random() * 0.6
        wagon.Pneumatic.WorkingChamberPressure = val == 3 and math.random() * 1.0 or val == 2 and 4.0 + math.random() * 1.0 or 5.2
        if val == 4 then wagon.Pneumatic.BrakeLinePressure = 5.2 end
    end
end