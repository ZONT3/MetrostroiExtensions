-- Copyright (C) 2025 Anatoly Raev
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Affero General Public License as
-- published by the Free Software Foundation, either version 3 of the
-- License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Affero General Public License for more details.
--
-- You should have received a copy of the GNU Affero General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.
MEL.DefineRecipe("719_buttonmaps", "gmod_subway_81-719")
RECIPE.BackportPriority = 14
function RECIPE:Inject(ent)
    if true then return end
    local buttonOverrides = {
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
            },
            ParkingBrakeToggle = {
                var = "ParkingBrake"
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
        FrontDoor = {
            FrontDoor ={
                noTooltip = true,
            }
        },
        RearDoor = {
            RearDoor ={
                noTooltip = true,
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
        MEL.NewButtonMap(ent, "Voltages", {
            pos = Vector(-464.3, -15.2, 60.7),
            ang = Angle(0, 90, 90),
            width = 145,
            height = 75,
            scale = 0.0625,
            hideseat = 0.2,
            buttons = {
                {
                    ID = "!BatteryVoltage",
                    x = 0,
                    y = 0,
                    w = 72.5,
                    h = 75,
                    tooltip = "",
                    tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.BatteryVoltage"), ent:GetPackedRatio("BatteryVoltage") * 150) end
                },
                {
                    ID = "!BatteryCurrent",
                    x = 72.5,
                    y = 0,
                    w = 72.5,
                    h = 75,
                    tooltip = "",
                    tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.BatteryCurrent"), ent:GetPackedRatio("BatteryCurrent") * 500) end
                },
            }
        })

        MEL.NewButtonMap(ent, "Pressures", {
            pos = Vector(-464.3, 6.3, 61),
            ang = Angle(0, 90, 90),
            width = 160,
            height = 80,
            scale = 0.0625,
            hideseat = 0.2,
            buttons = {
                {
                    ID = "!BCPressure",
                    x = 0,
                    y = 0,
                    w = 80,
                    h = 80,
                    tooltip = "",
                    tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.BCPressure"), ent:GetPackedRatio("BCPressure") * 6) end
                },
                {
                    ID = "!BLTLPressure",
                    x = 80,
                    y = 0,
                    w = 80,
                    h = 80,
                    tooltip = "",
                    tooltipFunc = function(ent) return Format(Metrostroi.GetPhrase("Train.Buttons.BLTLPressure"), ent:GetPackedRatio("TLPressure") * 16, ent:GetPackedRatio("BLPressure") * 16) end
                },
            }
        })

        Metrostroi.GenerateClientProps(ent)
    end)
end

function RECIPE:InjectNeeded()
    if Metrostroi.Version > 1537278077 then return false end
    return true
end
