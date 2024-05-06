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
MEL.DefineRecipe("717_buttonmaps", "gmod_subway_81-717_mvm")
RECIPE.BackportPriority = true
function RECIPE:Inject(ent)
    if SERVER then return end
    local strength = {
        [0] = 0.86,
        [1] = 0.29,
        [2] = 0.71,
        [3] = 0.71,
        [4] = 0.57,
        [5] = 0.71,
        [6] = 0.86,
        [7] = 0.43,
        [8] = 1.00,
        [9] = 0.86,
    }

    local buttonOverrides = {
        Block5_6 = {
            ["!L1Light"] = {
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.03,
                    z = 20,
                    color = Color(255, 60, 40)
                }
            },
            ["R_Program1Set"] = {
                noTooltip = false,
                states = {"Train.Buttons.0", "Common.ALL.Program1"}
            },
            ["R_Program2Set"] = {
                noTooltip = false,
                states = {"Train.Buttons.0", "Common.ALL.Program2"}
            },
            ["VUD1Toggle"] = {
                states = {"Train.Buttons.Unlocked", "Train.Buttons.Locked"}
            },
            ["KDLKToggle"] = {
                noTooltip = true,
            },
            ["KDLRKToggle"] = {
                noTooltip = true,
            },
            ["DoorSelectToggle"] = {
                states = {"Train.Buttons.Left", "Train.Buttons.Right"}
            },
            ["OtklBVKToggle"] = {
                noTooltip = true,
            },
            ["ConverterProtectionSet"] = {
                tooltipFunc = function(ent) return ent:GetPackedBool("RZP") and Metrostroi.GetPhrase("Train.Buttons.RZP") end
            },
            ["ALSFreqToggle"] = {
                states = {"Train.Buttons.Freq1/5", "Train.Buttons.Freq2/6"}
            },
            ["KDLSet"] = {
                lamp = {
                    model = "models/metrostroi_train/81-717/buttons/lamp_button_1.mdl",
                    anim = true,
                    var = "DoorsLeftL",
                    speed = 9,
                    z = 2.2,
                    color = Color(255, 130, 80),
                    lcolor = Color(255, 110, 40),
                    lz = 8,
                    lfov = 145,
                    lfar = 16,
                    lnear = 8,
                    lshadows = 0
                },
                sprite = {
                    bright = 0.2,
                    size = .485,
                    scale = 0.1,
                    z = 5,
                    color = Color(255, 130, 80)
                }
            },
            ["KDLRSet"] = {
                lamp = {
                    model = "models/metrostroi_train/81-717/buttons/lamp_button_1.mdl",
                    anim = true,
                    var = "DoorsLeftL",
                    speed = 9,
                    z = 2.2,
                    color = Color(255, 130, 80),
                    lcolor = Color(255, 110, 40),
                    lz = 8,
                    lfov = 145,
                    lfar = 16,
                    lnear = 8,
                    lshadows = 0
                },
                sprite = {
                    bright = 0.2,
                    size = .485,
                    scale = 0.1,
                    z = 5,
                    color = Color(255, 130, 80)
                },
            },
            ["!GreenRPLight"] = {
                lamp = {
                    model = "models/metrostroi_train/81-717/buttons/slc_77_lamp.mdl",
                    ang = 2,
                    x = -0.3,
                    y = -0.3,
                    z = 20.6,
                    var = "GreenRP",
                    color = Color(100, 255, 100)
                },
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.03,
                    z = 20,
                    color = Color(100, 255, 100)
                },
            },
            ["!AVULight"] = {
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.03,
                    z = 20,
                    color = Color(255, 60, 40)
                }
            },
            ["!LKVPLight"] = {
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.03,
                    z = 20,
                    color = Color(255, 170, 110)
                }
            },
            ["!SPLight"] = {
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.03,
                    z = 20,
                    color = Color(100, 255, 50)
                }
            },
            ["ConverterProtectionSet"] = {
                lamp = {
                    model = "models/metrostroi_train/81-717/buttons/lamp_button_2.mdl",
                    anim = true,
                    var = "RZP",
                    speed = 9,
                    z = 2.2,
                    lcolor = Color(255, 130, 40),
                    lz = 8,
                    lfov = 145,
                    lfar = 16,
                    lnear = 8,
                    lshadows = 0
                },
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.1,
                    z = 6,
                    color = Color(255, 130, 40)
                },
            }
        },
        Block7 = {
            ["!PNT"] = {
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.03,
                    z = 20,
                    color = Color(255, 170, 110)
                },
            },
            ["KDPSet"] = {
                lamp = {
                    model = "models/metrostroi_train/81-717/buttons/lamp_button_1.mdl",
                    anim = true,
                    var = "DoorsRightL",
                    speed = 9,
                    z = 2.2,
                    color = Color(255, 130, 80),
                    lcolor = Color(255, 110, 40),
                    lz = 10,
                    lfov = 145,
                    lfar = 16,
                    lnear = 8,
                    lshadows = 0
                },
                sprite = {
                    bright = 0.2,
                    size = .485,
                    scale = 0.1,
                    z = 5,
                    color = Color(255, 130, 80)
                },
            },
            ["KAHKToggle"] = {
                plomb = {
                    model = "models/metrostroi_train/81/plomb.mdl",
                    ang = 160,
                    x = -30,
                    y = -29.5,
                    z = 1,
                    var = "KAHPl",
                    ID = "KAHPl",
                },
                noTooltip = true,
            },
            ["!PNW"] = {
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.03,
                    z = 20,
                    color = Color(255, 130, 90)
                },
            },
            ["KDPKToggle"] = {
                noTooltip = true,
            },
        },
        Block1 = {
            ["!BatteryVoltage"] = {
                tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.BatteryVoltage"), ent:GetPackedRatio("BatteryVoltage") * 150) end
            }
        },
        Block3 = {
            ["!BLTLPressure"] = {
                tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.BLTLPressure"), ent:GetPackedRatio("TLPressure") * 16, ent:GetPackedRatio("BLPressure") * 16) end
            },
            ["!BCPressure"] = {
                tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.BCPressure"), ent:GetPackedRatio("BCPressure") * 6) end
            }
        },
        Block2_2 = {
            ["!Speedometer1"] = {
                tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.Speed"), math.floor(ent:GetPackedRatio("Speed") * 100)) end,
                sprite = {
                    bright = 0.1,
                    size = .5,
                    scale = 0.02,
                    vscale = 0.025,
                    z = 1,
                    color = Color(225, 250, 20),
                    getfunc = function(ent)
                        if not ent:GetPackedBool("LUDS") then return 0 end
                        return strength[math.floor(ent:GetPackedRatio("Speed") * 10) % 10]
                    end
                },
            },
            ["!Speedometer2"] = {
                tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.Speed"), math.floor(ent:GetPackedRatio("Speed") * 100)) end,
                sprite = {
                    bright = 0.1,
                    size = .5,
                    scale = 0.02,
                    vscale = 0.025,
                    z = 1,
                    color = Color(225, 250, 20),
                    getfunc = function(ent)
                        if not ent:GetPackedBool("LUDS") then return 0 end
                        return strength[math.floor(ent:GetPackedRatio("Speed") * 100) % 10]
                    end
                },
            },
            ["!ARSOch"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(255, 20, 40),
                    z = -1,
                }
            },
            ["!ARS0"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(255, 20, 40),
                    z = -1,
                }
            },
            ["!ARS40"] = {
                sprite = {
                    bright = 0.1,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(150, 100, 30),
                    z = -1,
                }
            },
            ["!ARS60"] = {
                sprite = {
                    bright = 0.1,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                }
            },
            ["!ARS70"] = {
                sprite = {
                    bright = 0.1,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                }
            },
            ["!ARS80"] = {
                sprite = {
                    bright = 0.1,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                }
            },
            ["!LampLSD1"] = {
                sprite = {
                    bright = 0.1,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                }
            },
            ["!LampLSD2"] = {
                sprite = {
                    bright = 0.1,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                }
            },
            ["!LampLVD"] = {
                sprite = {
                    bright = 0.1,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                }
            },
            ["!LampLHRK"] = {
                sprite = {
                    bright = 0.1,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(150, 100, 30),
                    z = -1,
                }
            },
            ["!LampLST"] = {
                sprite = {
                    bright = 0.1,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                }
            },
            ["!LampRP"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(255, 20, 40),
                    z = -1,
                }
            },
            ["!LampLSN"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(255, 20, 40),
                    z = -1,
                }
            },
            ["!LampLKVD"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(255, 20, 40),
                    z = -1,
                }
            },
            ["!LampLKVC"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(255, 20, 40),
                    z = -1,
                }
            },
            ["!LampLKT"] = {
                sprite = {
                    bright = 0.1,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                }
            },
            ["!LampLEKK"] = {
                sprite = {
                    bright = 0.1,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                }
            },
            ["!LampLN"] = {
                sprite = {
                    bright = 0.1,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                }
            },
            ["!LampLRS"] = {
                sprite = {
                    bright = 0.1,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                }
            }
        },
        Block2_3 = {
            ["!Speedometer"] = {
                tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.Speed"), math.floor(ent:GetPackedRatio("Speed") * 100)) end
            },
            ["!LPU"] = {
                lamp = {
                    model = "models/metrostroi_train/81-717/buttons/slc_77_lamp.mdl",
                    ang = 14,
                    x = -0.3,
                    y = -0.3,
                    z = 20.6,
                    color = Color(255, 130, 90),
                    var = "RS"
                },
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.03,
                    z = 20,
                    color = Color(255, 130, 90)
                },
            },
            ["!LKVD"] = {
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.03,
                    z = 20,
                    color = Color(255, 60, 40)
                }
            },
            ["!LKT"] = {
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.03,
                    z = 20,
                    color = Color(100, 255, 100)
                },
            },
            ["!LRP"] = {
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.03,
                    z = 20,
                    color = Color(255, 60, 40)
                },
            },
            ["!LKVC"] = {
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.03,
                    z = 20,
                    color = Color(255, 60, 40)
                },
            },
            ["!LVD"] = {
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.03,
                    z = 20,
                    color = Color(100, 255, 100)
                },
            },
            ["!LST"] = {
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.03,
                    z = 20,
                    color = Color(255, 170, 110)
                },
            }
        },
        Block2_1 = {
            ["!Speedometer1"] = {
                tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.Speed"), math.floor(ent:GetPackedRatio("Speed") * 100)) end,
                sprite = {
                    bright = 0.1,
                    size = .5,
                    scale = 0.02,
                    vscale = 0.025,
                    z = 1,
                    color = Color(225, 250, 20),
                    getfunc = function(ent)
                        if not ent:GetPackedBool("LUDS") then return 0 end
                        return strength[math.floor(ent:GetPackedRatio("Speed") * 10) % 10]
                    end
                },
            },
            ["!Speedometer2"] = {
                tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.Speed"), math.floor(ent:GetPackedRatio("Speed") * 100)) end,
                sprite = {
                    bright = 0.1,
                    size = .5,
                    scale = 0.02,
                    vscale = 0.025,
                    z = 1,
                    color = Color(225, 250, 20),
                    getfunc = function(ent)
                        if not ent:GetPackedBool("LUDS") then return 0 end
                        return strength[math.floor(ent:GetPackedRatio("Speed") * 100) % 10]
                    end
                },
            },
            ["!ARSOch"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(255, 56, 30),
                    z = -1,
                }
            },
            ["!ARS0"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(255, 56, 30),
                    z = -1,
                }
            },
            ["!ARS40"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(255, 168, 000),
                    z = -1,
                }
            },
            ["!ARS60"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(175, 250, 20),
                    z = -1,
                }
            },
            ["!ARS70"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(175, 250, 20),
                    z = -1,
                }
            },
            ["!ARS80"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(175, 250, 20),
                    z = -1,
                }
            },
            ["!LampLSD1"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(175, 250, 20),
                    z = -1,
                }
            },
            ["!LampLSD2"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(175, 250, 20),
                    z = -1,
                }
            },
            ["!LampLHRK"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(255, 168, 000),
                    z = -1,
                }
            },
            ["!LampRP"] = {
                lamp = {
                    speed = 24,
                    model = "models/metrostroi_train/81-502/lamps/svetodiod_small_502.mdl",
                    color = Color(255, 56, 30),
                    z = -3.5,
                    var = "RP",
                    getfunc = function(ent) return math.Clamp((ent:GetPackedRatio("RPR") - 0.45) * 7, 0, 1) end
                },
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(255, 56, 30),
                    z = -1,
                }
            },
            ["!LampLSN"] = {
                lamp = {
                    speed = 24,
                    model = "models/metrostroi_train/81-502/lamps/svetodiod_small_502.mdl",
                    color = Color(255, 56, 30),
                    z = -3.5,
                    var = "SN",
                    getfunc = function(ent) return ent:GetPackedRatio("RPR") ^ 2 end
                },
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(255, 56, 30),
                    z = -1,
                }
            },
            ["!LampLN"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(175, 250, 20),
                    z = -1,
                }
            },
            ["!LampLKVD"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(255, 56, 30),
                    z = -1,
                }
            },
            ["!LampLKT"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(175, 250, 20),
                    z = -1,
                }
            },
            ["!LampLKVC"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(255, 56, 30),
                    z = -1,
                }
            },
            ["!LampLRS"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(175, 250, 20),
                    z = -1,
                }
            },
            ["!LampLVD"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(175, 250, 20),
                    z = -1,
                }
            },
            ["!LampLST"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(175, 250, 20),
                    z = -1,
                }
            }
        },
        BZOS_C = {
            -- todo: copy to BZOS_R (WHYYYYY)
            ["!VH1"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(175, 250, 20),
                    z = -4,
                }
            },
            ["!VH2"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(255, 56, 30),
                    z = -4,
                }
            }
        },
        CabVent_C = {
            -- todo: copy to CabVent_R
            ["PVK-"] = {
                states = {"Train.Buttons.Off", "Train.Buttons.VentHalf", "Train.Buttons.VentFull"},
                varTooltip = function(ent) return ent:GetPackedRatio("PVK") end,
            },
            ["PVK+"] = {
                states = {"Train.Buttons.Off", "Train.Buttons.VentHalf", "Train.Buttons.VentFull"},
                varTooltip = function(ent) return ent:GetPackedRatio("PVK") end,
            }
        },
        HelperPanel_C = {
            -- todo: copy to HelperPanel_R
            ["VUD2Toggle"] = {
                states = {"Train.Buttons.Unlocked", "Train.Buttons.Locked"},
            }
        },
        Stopkran = {
            ["EmergencyBrakeValveToggle"] = {
                states = {"Train.Buttons.Closed", "Train.Buttons.Opened"},
                var = "EmergencyBrakeValve"
            }
        },
        IGLAButtons_C = {
            -- todo: copy to IGLAButtons_R
            ["IGLA1Set"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(175, 250, 20),
                    x = 1,
                    y = -4.7,
                    z = -2.3
                }
            },
            ["IGLA2Set"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(175, 250, 20),
                    x = 0.6,
                    y = -4.7,
                    z = -2.3
                }
            },
            ["IGLA3Set"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(175, 250, 20),
                    x = 0.2,
                    y = -4.7,
                    z = -2.3
                }
            },
            ["IGLA4Set"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(175, 250, 20),
                    x = 0,
                    y = -4.7,
                    z = -2.3
                }
            },
            ["!IGLAFire"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(255, 56, 30),
                    z = -2.4,
                }
            },
            ["!IGLAErr"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(255, 168, 000),
                    z = -2.4,
                }
            }
        },
        DriverValveBLDisconnect = {
            ["DriverValveBLDisconnectToggle"] = {
                states = {"Train.Buttons.Closed", "Train.Buttons.Opened"},
            }
        },
        DriverValveTLDisconnect = {
            ["DriverValveTLDisconnectToggle"] = {
                states = {"Train.Buttons.Closed", "Train.Buttons.Opened"},
            }
        },
        EPKDisconnect = {
            ["EPKToggle"] = {
                states = {"Train.Buttons.Closed", "Train.Buttons.Opened"},
            }
        },
        EPVDisconnect = {
            ["EPKToggle"] = {
                states = {"Train.Buttons.Closed", "Train.Buttons.Opened"},
            }
        },
        DriverValveDisconnect = {
            ["DriverValveDisconnectToggle"] = {
                states = {"Train.Buttons.Closed", "Train.Buttons.Opened"},
            }
        },
        FrontPneumatic = {
            ["FrontBrakeLineIsolationToggle"] = {
                var = "FbI",
                states = {"Train.Buttons.Opened", "Train.Buttons.Closed"}
            },
            ["FrontTrainLineIsolationToggle"] = {
                var = "FtI",
                states = {"Train.Buttons.Opened", "Train.Buttons.Closed"}
            }
        },
        RearPneumatic = {
            ["RearTrainLineIsolationToggle"] = {
                var = "RtI",
                states = {"Train.Buttons.Opened", "Train.Buttons.Closed"}
            },
            ["RearBrakeLineIsolationToggle"] = {
                var = "RbI",
                states = {"Train.Buttons.Opened", "Train.Buttons.Closed"}
            }
        },
        GV = {
            ["GVToggle"] = {
                states = {"Train.Buttons.Disconnected", "Train.Buttons.On"}
            }
        },
        AirDistributor = {
            ["AirDistributorDisconnectToggle"] = {
                var = "AD",
                states = {"Train.Buttons.On", "Train.Buttons.Off"}
            }
        },
        HVMeters = {
            ["!EnginesCurrent"] = {
                tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.EnginesCurrent"), ent:GetPackedRatio("EnginesCurrent") * 1000 - 500) end
            },
            ["!HighVoltage"] = {
                tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.EnginesVoltage"), ent:GetPackedRatio("EnginesVoltage") * 1000) end
            }
        }
    }

    if not ent.ButtonMap then
        print("ahtung!")
        return
    end

    for buttonmap_name, overrides in pairs(buttonOverrides) do
        for i, button in pairs(ent.ButtonMap[buttonmap_name].buttons) do
            if overrides[button.ID] then
                local override = overrides[button.ID]
                if not ent.ButtonMapCopy[buttonmap_name] then
                    MEL._LogWarning(Format("no such buttonmap %s", buttonmap_name))
                    continue
                end

                if not ent.ButtonMapCopy[buttonmap_name].buttons[i] then
                    MEL._LogWarning(Format("no such buttonmap (%s) button (%d, %s)", buttonmap_name, i, button.ID))
                    continue
                end

                local copy_button = ent.ButtonMapCopy[buttonmap_name].buttons[i]
                if ent.ButtonMapCopy[buttonmap_name].buttons[i].model then
                    button.model = table.Copy(ent.ButtonMapCopy[buttonmap_name].buttons[i].model)
                    if override.sprite then
                        button.model.sprite = override.sprite
                        copy_button.model.sprite = table.Copy(override.sprite)
                    end
                    if override.lamp then
                        button.model.lamp = override.lamp
                        copy_button.model.lamp = table.Copy(override.lamp)
                    end
                    if override.plomb then
                        button.model.plomb = override.plomb
                        copy_button.model.plomb = table.Copy(override.plomb)
                    end
                    if override.noTooltip then
                        button.model.noTooltip = override.noTooltip
                        copy_button.model.noTooltip = override.noTooltip
                    end
                    if override.tooltip then
                        button.model.tooltip = override.tooltip
                        copy_button.model.tooltip = override.tooltip
                    end
                    if override.states then
                        button.model.states = override.states
                        copy_button.model.states = table.Copy(override.states)
                    end
                    if override.var then
                        button.model.var = override.var
                        copy_button.model.var = override.var
                    end
                    if override.varTooltip then
                        button.model.varTooltip = override.varTooltip
                        copy_button.model.varTooltip = override.varTooltip
                    end
                    if override.tooltipFunc then
                        button.model.tooltipFunc = override.tooltipFunc
                        copy_button.model.tooltipFunc = override.tooltipFunc
                    end
                else
                    if override.tooltip then
                        button.tooltip = override.tooltip
                        copy_button.tooltip = override.tooltip
                    end
                    if override.states then
                        button.states = override.states
                        copy_button.states = table.Copy(override.states)
                    end
                    if override.var then
                        button.var = override.var
                        copy_button.var = override.var
                    end
                    if override.varTooltip then
                        button.varTooltip = override.varTooltip
                        copy_button.varTooltip = override.varTooltip
                    end
                    if override.tooltipFunc then
                        button.tooltipFunc = override.tooltipFunc
                        copy_button.tooltipFunc = override.tooltipFunc
                    end
                end
            end
        end
    end

    Metrostroi.GenerateClientProps(ent)
end

function RECIPE:InjectNeeded()
    if Metrostroi.Version > 1537278077 then return false end
    return true
end