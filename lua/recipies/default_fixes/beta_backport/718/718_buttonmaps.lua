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
MEL.DefineRecipe("718_buttonmaps", "gmod_subway_81-718")
RECIPE.BackportPriority = 12
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

function RECIPE:Inject(ent)
    if SERVER then return end
    local buttonOverrides = {
        Main = {
            SB1Set = {
                lamp = {
                    model = "models/metrostroi_train/81-717/buttons/lamp_button_2.mdl",
                    anim = true,
                    var = "HL3",
                    speed = 6,
                    z = 2.2,
                    lcolor = Color(255, 130, 40),
                    lz = 16,
                    lfov = 160,
                    lfar = 5,
                    lnear = 1,
                    lshadows = 0
                },
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.1,
                    z = 6,
                    color = Color(255, 130, 40)
                },
            },
            SB2Set = {
                lamp = {
                    model = "models/metrostroi_train/81-717/buttons/lamp_button_2.mdl",
                    anim = true,
                    var = "HL4",
                    speed = 6,
                    z = 2.2,
                    lcolor = Color(255, 130, 40),
                    lz = 16,
                    lfov = 160,
                    lfar = 5,
                    lnear = 1,
                    lshadows = 0
                },
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.1,
                    z = 6,
                    color = Color(255, 130, 40)
                },
            },
            SB4Set = {
                lamp = {
                    model = "models/metrostroi_train/81-717/buttons/lamp_button_2.mdl",
                    anim = true,
                    var = "HL5",
                    speed = 6,
                    z = 2.2,
                    lcolor = Color(255, 130, 40),
                    lz = 16,
                    lfov = 160,
                    lfar = 5,
                    lnear = 1,
                    lshadows = 0
                },
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.1,
                    z = 6,
                    color = Color(255, 130, 40)
                },
            },
            SB6KToggle = {
                noTooltip = true
            },
            SB7KToggle = {
                noTooltip = true
            },
            SB13Set = {
                lamp = {
                    model = "models/metrostroi_train/81-717/buttons/lamp_button_2.mdl",
                    anim = true,
                    var = "HL6",
                    getfunc = function(ent) return ent:GetPackedRatio("HL6") end,
                    speed = 6,
                    z = 2.2,
                    lcolor = Color(255, 130, 40),
                    lz = 16,
                    lfov = 160,
                    lfar = 5,
                    lnear = 1,
                    lshadows = 0
                },
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.1,
                    z = 6,
                    color = Color(255, 130, 40)
                },
                tooltipFunc = function(wagon) return wagon:GetPackedBool("HL6") and Metrostroi.GetPhrase("Train.Buttons.HL6") end
            },
            SB16Set = {
                lamp = {
                    model = "models/metrostroi_train/81-717/buttons/lamp_button_2.mdl",
                    anim = true,
                    var = "HL7",
                    speed = 6,
                    z = 2.2,
                    lcolor = Color(255, 130, 40),
                    lz = 16,
                    lfov = 160,
                    lfar = 5,
                    lnear = 1,
                    lshadows = 0
                },
                sprite = {
                    bright = 0.2,
                    size = .5,
                    scale = 0.1,
                    z = 6,
                    color = Color(255, 130, 40)
                },
                tooltipFunc = function(wagon) return wagon:GetPackedBool("HL7") and Metrostroi.GetPhrase("Train.Buttons.HL7") end
            },
        },
        Left = {
            ["!BatteryVoltage"] = {
                tooltipFunc = function(wagon) return Format(Metrostroi.GetPhrase("Train.Buttons.BatteryVoltage"), wagon:GetPackedRatio("BatteryVoltage") * 150) end
            }
        },
        Right = {
            ["SA5/1Toggle"] = {
                states = {"Train.Buttons.LHalf", "Train.Buttons.LFull"}
            }
        },
        CabVent = {
            ["PVK-"] = {
                states = {"Train.Buttons.Off", "Train.Buttons.VentHalf", "Train.Buttons.VentFull"},
                varTooltip = function(wagon) return wagon:GetPackedRatio("PVK") end
            },
            ["PVK+"] = {
                states = {"Train.Buttons.Off", "Train.Buttons.VentHalf", "Train.Buttons.VentFull"},
                varTooltip = function(ent) return ent:GetPackedRatio("PVK") end
            }
        },
        DriverValveDisconnect = {
            DriverValveDisconnectToggle = {
                states = {"Train.Buttons.Closed", "Train.Buttons.Opened"},
            },
            ParkingBrakeToggle = {
                states = {"Train.Buttons.Closed", "Train.Buttons.Opened"},
            },
            EPKToggle = {
                states = {"Train.Buttons.Closed", "Train.Buttons.Opened"},
            }
        },
        VPU = {
            SAP14Toggle = {
                states = {"Train.Buttons.Freq1/5", "Train.Buttons.Freq2/6"}
            }
        },
        Battery = {
            ["VTPR-"] = {
                states = {"Train.Buttons.0", "Train.Buttons.VTRAll", "Train.Buttons.VTRF", "Train.Buttons.VTRB"},
                varTooltip = function(ent) return ent:GetPackedRatio("VTPR") end
            },
            ["VTPR+"] = {
                states = {"Train.Buttons.0", "Train.Buttons.VTRAll", "Train.Buttons.VTRF", "Train.Buttons.VTRB"},
                varTooltip = function(ent) return ent:GetPackedRatio("VTPR") end
            }
        },
        ARS = {
            ["!Speedometer1"] = {
                tooltipFunc = function(wagon) return Format(Metrostroi.GetPhrase("Train.Buttons.Speed"), math.floor(wagon:GetPackedRatio("Speed") * 100)) end,
                sprite = {
                    bright = 0.1,
                    size = .5,
                    scale = 0.02,
                    vscale = 0.025,
                    z = 1,
                    color = Color(225, 250, 20),
                    aa = true,
                    getfunc = function(wagon)
                        if not wagon:GetPackedBool("Speedometer") then return 0 end
                        return strength[math.floor(wagon:GetPackedRatio("Speed") * 10) % 10]
                    end
                },
            },
            ["!Speedometer2"] = {
                tooltipFunc = function(wagon) return Format(Metrostroi.GetPhrase("Train.Buttons.Speed"), math.floor(wagon:GetPackedRatio("Speed") * 100)) end,
                sprite = {
                    bright = 0.1,
                    size = .5,
                    scale = 0.02,
                    vscale = 0.025,
                    z = 1,
                    color = Color(225, 250, 20),
                    aa = true,
                    getfunc = function(wagon)
                        if not wagon:GetPackedBool("Speedometer") then return 0 end
                        return strength[math.floor(wagon:GetPackedRatio("Speed") * 100) % 10]
                    end
                },
            },
            ["!SD"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.05,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                    aa = true
                }
            },
            ["!KT"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.05,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                    aa = true
                }
            },
            ["!RS"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.05,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                    aa = true
                }
            },
            ["!SK"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.05,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                    aa = true
                }
            },
            ["!04"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.05,
                    vscale = 0.02,
                    color = Color(255, 20, 40),
                    z = -1,
                    aa = true
                }
            },
            ["!0"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.05,
                    vscale = 0.02,
                    color = Color(255, 20, 40),
                    z = -1,
                    aa = true
                }
            },
            ["!40"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.05,
                    vscale = 0.02,
                    color = Color(150, 100, 30),
                    z = -1,
                    aa = true
                }
            },
            ["!60"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.05,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                    aa = true
                }
            },
            ["!70"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.05,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                    aa = true
                }
            },
            ["!80"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.05,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                    aa = true
                }
            },
            ["!KES"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(255, 20, 40),
                    z = -1,
                    aa = true
                }
            },
            ["!ST"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(255, 20, 40),
                    z = -1,
                    aa = true
                }
            },
            ["!CUV"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(255, 20, 40),
                    z = -1,
                    aa = true
                }
            },
            ["!AVU"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(255, 20, 40),
                    z = -1,
                    aa = true
                }
            },
            ["!AIP"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(255, 20, 40),
                    z = -1,
                    aa = true
                }
            },
            ["!RIP"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                    aa = true
                }
            },
            ["!KVD"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                    aa = true
                }
            },
            ["!VS1"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                    aa = true
                }
            },
            ["!VS2"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.03,
                    vscale = 0.02,
                    color = Color(125, 200, 15),
                    z = -1,
                    aa = true
                }
            }
        },
        BZOS = {
            ["!VH2"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(255, 56, 30),
                    z = 0,
                }
            },
            ["!VH1"] = {
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = Color(175, 250, 20),
                    z = 0,
                }
            },
        },
        UAVAPanel = {
            UAVACToggle = {
                var = "UAVAC",
                states = {"Train.Buttons.UAVAOff", "Train.Buttons.UAVAOn"}
            }
        },
        Stopkran = {
            ["EmergencyBrakeValveToggle"] = {
                states = {"Train.Buttons.Closed", "Train.Buttons.Opened"},
                var = "EmergencyBrakeValve"
            }
        },
        FrontPneumatic = {
            FrontBrakeLineIsolationToggle = {
                var = "FbI",
                states = {"Train.Buttons.Opened", "Train.Buttons.Closed"}
            },
            FrontTrainLineIsolationToggle = {
                var = "FtI",
                states = {"Train.Buttons.Opened", "Train.Buttons.Closed"}
            }
        },
        RearPneumatic = {
            RearTrainLineIsolationToggle = {
                var = "RtI",
                states = {"Train.Buttons.Opened", "Train.Buttons.Closed"}
            },
            RearBrakeLineIsolationToggle = {
                var = "RbI",
                states = {"Train.Buttons.Opened", "Train.Buttons.Closed"}
            }
        },
        GV = {
            GVToggle = {
                states = {"Train.Buttons.Disconnected", "Train.Buttons.On"}
            }
        },
        AirDistributor = {
            AirDistributorDisconnectToggle = {
                var = "AD",
                states = {"Train.Buttons.On", "Train.Buttons.Off"}
            }
        },
        CabinDoor = {
            CabinDoor = {
                noTooltip = true
            }
        },
        OtsekDoor1 = {
            OtsekDoor1 = {
                var = "OtsekDoor1",
                sndid = "door_otsek1",
                states = {"Train.Buttons.Closed", "Train.Buttons.Opened"}
            }
        },
        OtsekDoor2 = {
            OtsekDoor2 = {
                var = "OtsekDoor2",
                sndid = "door_otsek2",
                states = {"Train.Buttons.Closed", "Train.Buttons.Opened"}
            }
        },
        PassengerDoor = {
            PassengerDoor = {
                noTooltip = true,
            }
        },
        RearDoor = {
            RearDoor = {
                noTooltip = true
            }
        },
        PneumaticPanels = {
            ["!BLTLPressure"] = {
                tooltipFunc = function(wagon) return Format(Metrostroi.GetPhrase("Train.Buttons.BLTLPressure"), wagon:GetPackedRatio("TLPressure") * 16, wagon:GetPackedRatio("BLPressure") * 16) end
            },
            ["!BCPressure"] = {
                tooltipFunc = function(wagon) return Format(Metrostroi.GetPhrase("Train.Buttons.BCPressure"), wagon:GetPackedRatio("BCPressure") * 6) end
            }
        },
        HVMeters = {
            ["!I13"] = {
                tooltipFunc = function(wagon) return Format(Metrostroi.GetPhrase("Train.Buttons.EnginesCurrent"), wagon:GetPackedRatio("EnginesCurrent13") * 1000 - 500) end
            },
            ["!I24"] = {
                tooltipFunc = function(wagon) return Format(Metrostroi.GetPhrase("Train.Buttons.EnginesCurrent"), wagon:GetPackedRatio("EnginesCurrent24") * 1000 - 500) end
            },
            ["!HVVoltage"] = {
                tooltipFunc = function(wagon) return Format(Metrostroi.GetPhrase("Train.Buttons.EnginesVoltage"), wagon:GetPackedRatio("EnginesVoltage") * 1000) end
            },
            ["!BatteryCurrent"] = {
                tooltipFunc = function(wagon) return Format(Metrostroi.GetPhrase("Train.Buttons.BatteryCurrent"), wagon:GetPackedRatio("BatteryCurrent") * 150) end
            }
        },
    }

    local function placeLamps(name)
        if not ent.ButtonMap[name] or not ent.ButtonMap[name].buttons then return end
        ent.ButtonMap[name] = table.Copy(ent.ButtonMapCopy[name])
        local nAdd = name:sub(name:find("_") + 1, -1)
        for i, button in pairs(ent.ButtonMap[name].buttons) do
            button.ID = nAdd .. button.ID
            button.model = {
                --model = "models/metrostroi_train/81/lamp.mdl", z = -25,
                lamp = {
                    speed = 16,
                    model = "models/metrostroi_train/81-502/lamps/svetodiod_small_502.mdl",
                    bscale = Vector(0.7, 0.7, 0.7),
                    z = -5,
                    var = button.var,
                    color = button.col == "y" and Color(255, 168, 0) or button.col == "r" and Color(255, 56, 30) or button.col == "g" and Color(175, 250, 20) or Color(255, 255, 255),
                },
                sprite = {
                    bright = 0.5,
                    size = 0.25,
                    scale = 0.01,
                    color = button.col == "y" and Color(255, 168, 0) or button.col == "r" and Color(255, 56, 30) or button.col == "g" and Color(175, 250, 20) or Color(255, 255, 255),
                    z = -3,
                }
            }

            button.var = nil
        end
    end

    timer.Simple(1, function()
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

                    if ent.ButtonMapCopy[buttonmap_name].buttons[i].model then
                        button.model = table.Copy(ent.ButtonMapCopy[buttonmap_name].buttons[i].model)
                        if override.sprite then button.model.sprite = override.sprite end
                        if override.lamp then button.model.lamp = override.lamp end
                        if override.plomb then button.model.plomb = override.plomb end
                        if override.noTooltip then button.model.noTooltip = override.noTooltip end
                        if override.tooltip then button.model.tooltip = override.tooltip end
                        if override.states then button.model.states = override.states end
                        if override.var then button.model.var = override.var end
                        if override.sndid then button.model.sndid = override.sndid end
                        if override.varTooltip then button.model.varTooltip = override.varTooltip end
                        if override.tooltipFunc then button.model.tooltipFunc = override.tooltipFunc end
                    else
                        if override.tooltip then button.tooltip = override.tooltip end
                        if override.states then button.states = override.states end
                        if override.var then button.var = override.var end
                        if override.varTooltip then button.varTooltip = override.varTooltip end
                        if override.tooltipFunc then button.tooltipFunc = override.tooltipFunc end
                    end
                end
            end
        end
        placeLamps("BUP_MVSU")
        placeLamps("BUP_MLUP")
        placeLamps("BUP_MUVS1")
        placeLamps("BUP_MUVS2")
        placeLamps("BUP_MS")
        placeLamps("BUP_MP")
        Metrostroi.GenerateClientProps(ent)
    end)
end

function RECIPE:InjectNeeded()
    if Metrostroi.Version > 1537278077 then return false end
    return true
end
