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
MEL.DefineRecipe("signal_backport", {"gmod_track_signal"})
RECIPE.BackportPriority = true
function RECIPE:Inject(ent)
    ent.OldRouteNumberSetup = {
        "1234D",
        "WKFX",
        "LR",
        Vector(6, 0, 10.5),
        {
            D = 4
        },
        {
            ["F"] = 0,
            ["L"] = 2,
            ["R"] = 0,
            W = 3,
            K = 4
        }
    }

    for i = 0, 2 do
        --SERVER
        ent.TrafficLightModels[i].ArsBox = {
            model = "models/metrostroi/signals/mus/ars_box.mdl"
        }

        ent.TrafficLightModels[i].ArsBoxMittor = {
            model = "models/metrostroi/signals/mus/ars_box_mittor.mdl"
        }

        --CLIENT
        ent.TrafficLightModels[i].LampIndicator = {
            model = "models/metrostroi/signals/mus/light_lampindicator",
            Vector(0.2),
            Vector(1),
            Vector(8),
            Vector(-0.9, 1, 1),
            Vector(3, 0, 3),
            Vector(-1, 1, 0.85)
        }

        ent.TrafficLightModels[i].LampBase = {
            model = "models/metrostroi/signals/mus/lamp_base.mdl"
        }

        ent.TrafficLightModels[i].SignLetterSmall = {
            model = "models/metrostroi/signals/mus/sign_letter_small.mdl",
            Vector(1.5, 0, 0),
            Vector(-1.5, 0, 0)
        }

        ent.TrafficLightModels[i].SignLetter = {
            model = "models/metrostroi/signals/mus/sign_letter.mdl",
            z = 5.85
        }

        ent.TrafficLightModels[i].LetMaterials = {
            str = "models/metrostroi/signals/let/"
        }

        ent.TrafficLightModels[i].RouteNumberOffset = Vector(10, 0, 0)
        ent.TrafficLightModels[i].DoubleOffset = Vector(0, 0, 1.62)
        ent.TrafficLightModels[i].RouteNumberOffset2 = Vector(0, 0, 7.2)
        ent.TrafficLightModels[i].SpecRouteNumberOffset = Vector(3, -1, 3)
        ent.TrafficLightModels[i].RouteNumberOffset3 = Vector(10.5, 0, -6)
        ent.TrafficLightModels[i].SpecRouteNumberOffset2 = Vector(-0.8, 1, 0.94)
        ent.TrafficLightModels[i].RouaOffset = Vector(6.2, 0, 24.5)
    end

    if SERVER then
        function MSignalSayHook(ply, comm, fromULX)
            if ulx and not fromULX then return end
            for i, sig in pairs(ents.FindByClass("gmod_track_signal")) do
                local comm = comm
                if comm:sub(1, 8) == "!sactiv " then
                    comm = comm:sub(9, -1):upper()
                    comm = string.Explode(":", comm)
                    if sig.Routes then
                        for k, v in pairs(sig.Routes) do
                            if (v.RouteName and v.RouteName:upper() == comm[1] or comm[1] == "*") and v.Emer then
                                if sig.LastOpenedRoute and k ~= sig.LastOpenedRoute then sig:CloseRoute(sig.LastOpenedRoute) end
                                v.IsOpened = true
                                break
                            end
                        end
                    end
                elseif comm:sub(1, 10) == "!sdeactiv " then
                    comm = comm:sub(11, -1):upper()
                    comm = string.Explode(":", comm)
                    if sig.Routes then
                        for k, v in pairs(sig.Routes) do
                            if (v.RouteName and v.RouteName:upper() == comm[1] or comm[1] == "*") and v.Emer then
                                v.IsOpened = false
                                break
                            end
                        end
                    end
                elseif comm:sub(1, 8) == "!sclose " then
                    comm = comm:sub(9, -1):upper()
                    comm = string.Explode(":", comm)
                    if comm[1] == sig.Name then
                        if sig.Routes[1] and sig.Routes[1].Manual then
                            sig:CloseRoute(1)
                        else
                            if not sig.Close then sig.Close = true end
                            if sig.InvationSignal then sig.InvationSignal = false end
                            if (sig.LastOpenedRoute and sig.LastOpenedRoute == 1) or sig.Routes[1].Repeater then
                                sig:CloseRoute(1)
                            else
                                sig:OpenRoute(1)
                            end
                        end
                    elseif sig.Routes then
                        for k, v in pairs(sig.Routes) do
                            if v.RouteName and v.RouteName:upper() == comm[1] then
                                if sig.LastOpenedRoute and k ~= sig.LastOpenedRoute then sig:CloseRoute(sig.LastOpenedRoute) end
                                sig:CloseRoute(k)
                            end
                        end
                    end
                elseif comm:sub(1, 7) == "!sopen " then
                    comm = comm:sub(8, -1):upper()
                    comm = string.Explode(":", comm)
                    if comm[1] == sig.Name then
                        if comm[2] then
                            if sig.NextSignals[comm[2]] then
                                local Route
                                for k, v in pairs(sig.Routes) do
                                    if v.NextSignal == comm[2] then
                                        Route = k
                                        break
                                    end
                                end

                                sig:OpenRoute(Route)
                            end
                        else
                            if sig.Routes[1] and sig.Routes[1].Manual then
                                sig:OpenRoute(1)
                            elseif sig.Close then
                                sig.Close = false
                            end
                        end
                    elseif sig.Routes then
                        for k, v in pairs(sig.Routes) do
                            if v.RouteName and v.RouteName:upper() == comm[1] then
                                if sig.LastOpenedRoute and k ~= sig.LastOpenedRoute then sig:CloseRoute(sig.LastOpenedRoute) end
                                sig:OpenRoute(k)
                            end
                        end
                    end
                elseif comm:sub(1, 7) == "!sopps " then
                    comm = comm:sub(8, -1):upper()
                    comm = string.Explode(":", comm)
                    if comm[1] == sig.Name then sig.InvationSignal = true end
                elseif comm:sub(1, 7) == "!sclps " then
                    comm = comm:sub(8, -1):upper()
                    comm = string.Explode(":", comm)
                    if comm[1] == sig.Name then sig.InvationSignal = false end
                elseif comm:sub(1, 7) == "!senao " then
                    comm = comm:sub(8, -1):upper()
                    comm = string.Explode(":", comm)
                    if comm[1] == sig.Name then if sig.AODisabled then sig.AODisabled = false end end
                elseif comm:sub(1, 8) == "!sdisao " then
                    comm = comm:sub(9, -1):upper()
                    comm = string.Explode(":", comm)
                    if comm[1] == sig.Name then if sig.ARSSpeedLimit == 2 then sig.AODisabled = true end end
                end
            end
        end

        hook.Add("PlayerSay", "metrostroi-signal-say", function(ply, comm) MSignalSayHook(ply, comm) end)
        MEL.InjectIntoServerFunction(ent, "Initialize", function(wagon)
            wagon:SetModel(wagon.TrafficLightModels[wagon.SignalType or 0].ArsBox.model)
            wagon.OccupiedOld = false
            wagon.ControllerLogicCheckOccupied = false
            wagon.ControllerLogicOverride325Hz = false
            wagon.Override325Hz = false
        end, 1)

        MEL.InjectIntoServerFunction(ent, "PreInitalize", function(wagon)
            if wagon.Left then
                wagon:SetModel(wagon.TrafficLightModels[wagon.SignalType or 0].ArsBoxMittor.model)
            else
                wagon:SetModel(wagon.TrafficLightModels[wagon.SignalType or 0].ArsBox.model)
            end
        end, 1)

        MEL.InjectIntoServerFunction(ent, "GetARS", function(wagon, ARSID, Force1_5, Force2_6) if wagon.OverrideTrackOccupied then return ARSID == 2, MEL.Return end end)
        function ent.GetRS(wagon)
            if wagon.OverrideTrackOccupied or not wagon.TwoToSix or not wagon.ARSSpeedLimit then return false end
            if wagon.ARSSpeedLimit ~= 0 and wagon.ARSSpeedLimit == 2 then return false end
            if wagon.ControllerLogic and wagon.ControllerLogicOverride325Hz then return wagon.Override325Hz end
            return (wagon.ARSSpeedLimit > 4 or wagon.ARSSpeedLimit == 4 and wagon.Approve0) and (not wagon.ARSNextSpeedLimit or wagon.ARSNextSpeedLimit >= wagon.ARSSpeedLimit)
        end

        function ent.CheckOccupation(wagon)
            --print(wagon.FoundedAll)
            --if not wagon.FoundedAll then return end
            if not wagon.Close and not wagon.KGU then --not wagon.OverrideTrackOccupied and
                if wagon.Node and wagon.TrackPosition then wagon.Occupied, wagon.OccupiedBy, wagon.OccupiedByNow = Metrostroi.IsTrackOccupied(wagon.Node, wagon.TrackPosition.x, wagon.TrackPosition.forward, wagon.ARSOnly and "ars" or "light", wagon) end
                if wagon.Routes[wagon.Route] and wagon.Routes[wagon.Route].Manual then wagon.Occupied = wagon.Occupied or not wagon.Routes[wagon.Route].IsOpened end
                if wagon.OccupiedByNowOld ~= wagon.OccupiedByNow then
                    wagon.InvationSignal = false
                    wagon.AODisabled = false
                    wagon.OccupiedByNowOld = wagon.OccupiedByNow
                end
            else
                wagon.NextSignalLink = nil
                wagon.Occupied = wagon.Close or wagon.KGU --wagon.OverrideTrackOccupied or
            end
        end

        function ent.ARSLogic(wagon, tim)
            --print(wagon.FoundedAll)
            --if not wagon.FoundedAll then return end
            if not wagon.Routes or not wagon.NextSignals then return end
            -- Check track occuping
            if not wagon.Routes[wagon.Route or 1].Repeater then
                wagon:CheckOccupation()
                if wagon.Occupied then if wagon.Routes[wagon.Route or 1].Manual then wagon.Routes[wagon.Route or 1].IsOpened = false end end
                if wagon.Occupied or not wagon.NextSignalLink or not wagon.NextSignalLink.FreeBS then
                    wagon.FreeBS = 0
                else
                    wagon.FreeBS = math.min(30, wagon.NextSignalLink.FreeBS + 1) -- old 10 freebs - костыль
                end

                if wagon.FreeBS - (wagon.OldBSState or wagon.FreeBS) > 1 then
                    local Free = wagon.FreeBS
                    timer.Simple(tim + 0.1, function()
                        if not IsValid(wagon) then return end
                        if wagon.NextSignalLink and wagon.NextSignalLink.FreeBS + 1 - wagon.OldBSState > 1 then
                            wagon.FreeBS = Free
                            wagon.OldBSState = Free
                        end
                    end)

                    wagon.FreeBS = wagon.OldBSState
                end

                wagon.OldBSState = wagon.FreeBS
                if wagon.FreeBS == 1 then
                    wagon.OccupiedBy = wagon
                elseif wagon.FreeBS > 1 then
                    wagon.AutostopEnt = nil
                end

                if wagon.OccupiedByNow ~= wagon.AutostopEnt and wagon.AutostopEnt ~= wagon.CurrentAutostopEnt then wagon.AutostopEnt = nil end
            end

            if wagon.OldRoute ~= wagon.Route then
                wagon.InvationSignal = false
                wagon.AODisabled = false
                wagon.OldRoute = wagon.Route
            end

            --Removing NSL
            wagon.NextSignalLink = nil
            --Set the first route, if no switches in route or no switches
            --or not wagon.Switches
            if #wagon.Routes == 1 and (wagon.Routes[1].Switches == "" or not wagon.Routes[1].Switches) then
                wagon.NextSignalLink = wagon.NextSignals[wagon.Routes[1].NextSignal]
                wagon.Route = 1
            else
                local route
                --Finding right route
                for i = 1, #wagon.Routes do
                    --If all switches right - get this route!
                    if wagon.SwitchesFunction[i] and wagon.SwitchesFunction[i]() and (not wagon.Routes[i].Manual and not wagon.Routes[i].Emer or wagon.Routes[i].IsOpened) then
                        --if wagon.Route ~= i then
                        route = i
                        --wagon.NextSignalLink = nil
                        --end
                    elseif not wagon.SwitchesFunction[i] and (not wagon.Routes[i].Manual and not wagon.Routes[i].Emer or wagon.Routes[i].IsOpened) then
                        route = i
                        --wagon.NextSignalLink = nil
                    end
                end

                if wagon.Route ~= route and (not wagon.Routes[route] or not wagon.Routes[route].Emer) then
                    wagon.Route = route
                    wagon.NextSignalLink = false
                else
                    if wagon.Route ~= route then wagon.Route = route end
                    wagon.NextSignalLink = wagon.Routes[route] and wagon.NextSignals[wagon.Routes[route].NextSignal]
                end
            end

            if wagon.NextSignalLink == nil then
                if wagon.Occupied then
                    wagon.NextSignalLink = wagon
                    wagon.FreeBS = 0
                    --wagon.Route = 1
                end
            end

            if wagon.Routes[wagon.Route] then
                if wagon.Routes[wagon.Route or 1].Repeater then
                    wagon.RealName = IsValid(wagon.NextSignalLink) and wagon.NextSignalLink.RealName or wagon.Name
                else
                    wagon.RealName = wagon.Name
                end

                if wagon.Routes[wagon.Route or 1].Repeater then
                    wagon.RealName = IsValid(wagon.NextSignalLink) and wagon.NextSignalLink.Name or wagon.Name
                    wagon.ARSSpeedLimit = IsValid(wagon.NextSignalLink) and wagon.NextSignalLink.ARSSpeedLimit or 1
                    wagon.ARSNextSpeedLimit = IsValid(wagon.NextSignalLink) and wagon.NextSignalLink.ARSNextSpeedLimit or 1
                    wagon.FreeBS = IsValid(wagon.NextSignalLink) and wagon.NextSignalLink.FreeBS or 0
                elseif wagon.Routes[wagon.Route].ARSCodes then
                    local ARSCodes = wagon.Routes[wagon.Route].ARSCodes
                    wagon.ARSNextSpeedLimit = IsValid(wagon.NextSignalLink) and wagon.NextSignalLink.ARSSpeedLimit or tonumber(ARSCodes[1])
                    wagon.ARSSpeedLimit = tonumber(ARSCodes[math.min(#ARSCodes, wagon.FreeBS + 1)]) or 0
                    if wagon.AODisabled and wagon.ARSSpeedLimit ~= 2 then wagon.AODisabled = false end
                    if (wagon.InvationSignal or wagon.AODisabled) and wagon.ARSSpeedLimit == 2 then wagon.ARSSpeedLimit = 1 end
                end
            end

            if wagon.NextSignalLink ~= false and (wagon.Occupied or not wagon.NextSignalLink or not wagon.NextSignalLink.FreeBS) then if wagon.Routes[wagon.Route or 1].Manual then wagon.Routes[wagon.Route or 1].IsOpened = false end end
        end

        function ent.Think(wagon)
            if wagon.PostInitalized then return end
            --DEBUG
            if Metrostroi.SignalDebugCV:GetBool() then
                wagon:SetNW2Bool("Debug", true)
                local next = wagon.NextSignalLink
                local pos = wagon.TrackPosition
                local prev = wagon.PrevSig
                if next then
                    next.PrevSig = wagon
                    local nextpos = wagon.NextSignalLink.TrackPosition
                    wagon:SetNW2String("NextSignalName", next.Name)
                    if pos and nextpos then
                        wagon:SetNW2Float("DistanceToNext", nextpos.x - pos.x)
                    else
                        wagon:SetNW2Float("DistanceToNext", 0)
                    end

                    wagon:SetNW2Int("NextPosID", nextpos and nextpos.path and nextpos.path.id or 0)
                    wagon:SetNW2Float("NextPos", nextpos and nextpos.x or 0)
                else
                    wagon:SetNW2String("NextSignalName", "N/A")
                    wagon:SetNW2Float("DistanceToNext", 0)
                    wagon:SetNW2Float("NextPos", 0)
                    wagon:SetNW2Float("NextPosID", 0)
                end

                if prev then
                    local prevpos = prev.TrackPosition
                    if pos and prevpos then
                        wagon:SetNW2Float("DistanceToPrev", -prevpos.x + pos.x)
                    else
                        wagon:SetNW2Float("DistanceToPrev", 0)
                    end

                    wagon:SetNW2String("PrevSignalName", wagon.PrevSig.Name)
                    wagon:SetNW2Int("PrevPosID", prevpos and prevpos.path and prevpos.path.id or 0)
                    wagon:SetNW2Float("PrevPos", prevpos and prevpos.x or 0)
                else
                    wagon:SetNW2String("PrevSignalName", "N/A")
                    wagon:SetNW2Int("PrevPosID", 0)
                    wagon:SetNW2Float("PrevPos", 0)
                end

                wagon:SetNW2Float("Pos", pos and pos.x or 0)
                wagon:SetNW2Int("PosID", pos and pos.path and pos.path.id or 0)
                wagon:SetNW2Bool("CurrentRoute", wagon.Route or -1)
                wagon:SetNW2Bool("Occupied", wagon.Occupied)
                wagon:SetNW2Bool("2/6", wagon.TwoToSix)
                wagon:SetNW2Int("FreeBS", wagon.FreeBS)
                wagon:SetNW2Bool("LinkedToController", wagon.Controllers ~= nil)
                wagon:SetNW2Int("ControllersNumber", wagon.Controllers ~= nil and #wagon.Controllers or -1)
                wagon:SetNW2Bool("BlockedByController", wagon.ControllerLogic)
                for i = 0, 8 do
                    if i == 3 or i == 5 then continue end
                    wagon:SetNW2Bool("CurrentARS" .. i, wagon:GetARS(i))
                end

                wagon:SetNW2Bool("CurrentARS325", wagon:GetRS())
                wagon:SetNW2Bool("CurrentARS325_2", wagon:Get325HzAproove0())
            end

            if not wagon.ControllerLogic then
                if not wagon.Routes or #wagon.Routes == 0 then
                    -- ErrorNoHalt(Format("Metrostroi:Signal %s don't have a routes!\n", wagon.Name))
                    return
                end

                if not wagon.Routes[wagon.Route or 1] then
                    ErrorNoHalt(Format("Metrostroi:Signal %s have a null %s route!!\n", wagon.Name, wagon.Route))
                    return
                end

                wagon.PrevTime = wagon.PrevTime or 0
                if (CurTime() - wagon.PrevTime) > 1.0 then
                    wagon.PrevTime = CurTime() + math.random(0.5, 1.5)
                    wagon:ARSLogic(wagon.PrevTime - CurTime())
                end

                wagon.RouteNumberOverrite = nil
                local number = ""
                if wagon.MU or wagon.ARSOnly or wagon.RouteNumberSetup and wagon.RouteNumberSetup ~= "" or wagon.RouteNumber and wagon.RouteNumber ~= "" then
                    if wagon.NextSignalLink then
                        if not wagon.NextSignalLink.Red and not wagon.Red then
                            wagon.RouteNumberOverrite = wagon.NextSignalLink.RouteNumberOverrite ~= "" and wagon.NextSignalLink.RouteNumberOverrite or wagon.NextSignalLink.RouteNumber
                        else
                            wagon.RouteNumberOverrite = wagon.RouteNumber
                        end

                        if (not wagon.Red or wagon.InvationSignal) and wagon.Routes[wagon.Route or 1].EnRou then
                            if wagon.NextSignalLink.RouteNumberOverrite then number = number .. wagon.NextSignalLink.RouteNumberOverrite end
                            if wagon.NextSignalLink.RouteNumber and not wagon.AutoEnabled then number = number .. wagon.NextSignalLink.RouteNumber end
                        end

                        --print(wagon.Name,wagon.NextSignalLink.RouteNumberOverrite)
                        wagon.RouteNumberOverrite = (wagon.RouteNumberOverrite or "") .. number
                    else
                        wagon.RouteNumberOverrite = wagon.RouteNumber
                    end
                end

                if wagon.InvationSignal and wagon.GoodInvationSignal == -1 then number = number .. "W" end
                if wagon.KGU then number = number .. "K" end
                if number then wagon:SetNW2String("Number", number) end
                if wagon.Occupied ~= wagon.OccupiedOld then
                    hook.Run("Metrostroi.Signaling.ChangeRCState", wagon.Name, wagon.Occupied, wagon)
                    wagon.OccupiedOld = wagon.Occupied
                end

                if wagon.ARSOnly then
                    if wagon.Sprites then
                        for k, v in pairs(wagon.Sprites) do
                            SafeRemoveEntity(v)
                            wagon.Sprites[k] = nil
                        end

                        if wagon.ARSOnly and wagon.Sprites then wagon.Sprites = nil end
                    end

                    wagon:SetNW2String("Signal", "")
                    wagon.AutoEnabled = not wagon.ARSOnly
                    return
                end

                wagon.AutoEnabled = false
                wagon.Red = nil
                if not wagon.Routes[wagon.Route or 1].Lights then return end
                local Route = wagon.Routes[wagon.Route or 1]
                local index = 1
                local offset = wagon.RenderOffset[wagon.SignalType] or Vector(0, 0, 0)
                wagon.Sig = ""
                wagon.Colors = ""
                for k, v in ipairs(wagon.Lenses) do
                    if wagon.Routes[wagon.Route or 1].Repeater and IsValid(wagon.NextSignalLink) and (not wagon.Routes[wagon.Route or 1].Lights or wagon.Routes[wagon.Route or 1].Lights == "") then break end
                    if v ~= "M" then
                        --get the some models data
                        local data = #v ~= 1 and wagon.TrafficLightModels[wagon.SignalType][#v - 1] or wagon.TrafficLightModels[wagon.SignalType][wagon.Signal_IS]
                        if not data then continue end
                        for i = 1, #v do
                            --Get the LightID and check, is this light must light up
                            local LightID = IsValid(wagon.NextSignalLink) and math.min(#Route.LightsExploded, wagon.FreeBS + 1) or 1
                            local AverageState = Route.LightsExploded[LightID]:find(tostring(index)) or ((v[i] == "W" and wagon.InvationSignal and wagon.GoodInvationSignal == index) and 1 or 0)
                            local MustBlink = (v[i] == "W" and wagon.InvationSignal and wagon.GoodInvationSignal == index) or (AverageState > 0 and Route.LightsExploded[LightID][AverageState + 1] == "b") --Blinking, when next is "b" (or it's invasion signal')
                            wagon.Sig = wagon.Sig .. (AverageState > 0 and (MustBlink and 2 or 1) or 0)
                            if AverageState > 0 then
                                if wagon.GoodInvationSignal ~= index then wagon.Colors = wagon.Colors .. (MustBlink and v[i]:lower() or v[i]:upper()) end
                                if v[i] == "R" then
                                    wagon.AutoEnabled = not wagon.NonAutoStop
                                    wagon.Red = true
                                end
                            end

                            index = index + 1
                        end
                    end
                end
            else
                local number = wagon.RouteNumberReplace or ""
                if wagon.ControllerLogicCheckOccupied then
                    wagon.PrevTime = wagon.PrevTime or 0
                    if (CurTime() - wagon.PrevTime) > 0.5 then
                        wagon.PrevTime = CurTime() + math.random(0.5, 1.5)
                        if wagon.Node and wagon.TrackPosition then wagon.Occupied, wagon.OccupiedBy, wagon.OccupiedByNow = Metrostroi.IsTrackOccupied(wagon.Node, wagon.TrackPosition.x, wagon.TrackPosition.forward, wagon.ARSOnly and "ars" or "light", wagon) end
                    end

                    if wagon.Occupied ~= wagon.OccupiedOld then
                        hook.Run("Metrostroi.Signaling.ChangeRCState", wagon.Name, wagon.Occupied, wagon)
                        wagon.OccupiedOld = wagon.Occupied
                    end
                end

                --[[
                if wagon.MU or wagon.ARSOnly or wagon.RouteNumberSetup and wagon.RouteNumberSetup ~= "" or wagon.RouteNumber and wagon.RouteNumber ~= "" then
                    if wagon.NextSignalLink then
                        if not wagon.NextSignalLink.AutoEnabled and not wagon.AutoEnabled then
                            wagon.RouteNumberOverrite = wagon.NextSignalLink.RouteNumberOverrite ~= "" and wagon.NextSignalLink.RouteNumberOverrite or wagon.NextSignalLink.RouteNumber
                        else
                            wagon.RouteNumberOverrite = wagon.RouteNumber
                        end
                        if wagon.NextSignalLink.RouteNumberOverrite and not wagon.AutoEnabled and (wagon.Routes[wagon.Route or 1].EnRou or wagon.InvationSignal) then
                            number = number..wagon.NextSignalLink.RouteNumberOverrite
                        end
                        if wagon.NextSignalLink.RouteNumber and (wagon.Routes[wagon.Route or 1].EnRou and not wagon.AutoEnabled or wagon.InvationSignal) then
                            number = number..wagon.NextSignalLink.RouteNumber
                        end
                        --print(wagon.Name,wagon.NextSignalLink.RouteNumberOverrite)
                        wagon.RouteNumberOverrite = (wagon.RouteNumberOverrite or "")..number
                    else
                        wagon.RouteNumberOverrite = wagon.RouteNumber
                    end
                end]]
                if wagon.InvationSignal and wagon.GoodInvationSignal == -1 then number = number .. "W" end
                if wagon.KGU then number = number .. "K" end
                if number then wagon:SetNW2String("Number", number) end
                local index = 1
                wagon.Colors = ""
                for k, v in ipairs(wagon.Lenses) do
                    if v ~= "M" then
                        --get the some models data
                        local data = #v ~= 1 and wagon.TrafficLightModels[wagon.SignalType][#v - 1] or wagon.TrafficLightModels[wagon.SignalType][wagon.Signal_IS]
                        if not data then continue end
                        for i = 1, #v do
                            if wagon.Sig[index] == "1" or wagon.Sig[index] == "2" then wagon.Colors = wagon.Colors .. v[i]:lower() end
                            index = index + 1
                        end
                    end
                end
            end

            if wagon.Controllers then
                for k, v in pairs(wagon.Controllers) do
                    if wagon.Sig ~= v.Sig then
                        local Route = wagon.Routes[wagon.Route or 1]
                        local LightID = IsValid(wagon.NextSignalLink) and math.min(#Route.LightsExploded, wagon.FreeBS + 1) or 1
                        local lights = Route.LightsExploded[LightID]
                        v:TriggerOutput("LenseEnabled", wagon, Route.LightsExploded[LightID])
                        v.Sig = wagon.Sig
                    end

                    if v.OldIS ~= wagon.InvationSignal then
                        if wagon.InvationSignal then
                            v:TriggerOutput("LenseEnabled", wagon, "I")
                        else
                            v:TriggerOutput("LenseDisabled", wagon, "I")
                        end

                        v.OldIS = wagon.InvationSignal
                    end
                end
            end

            wagon:SetNW2String("Signal", wagon.Sig)
            if not wagon.AutostopPresent then wagon:SetNW2Bool("Autostop", wagon.AutoEnabled) end
            wagon:NextThink(CurTime() + 0.25)
            return true
        end
    end

    if CLIENT then
        function ent.SpawnMainModels(wagon, pos, ang, LenseNum, add)
            local TLM = wagon.TrafficLightModels[wagon.LightType]
            for k, v in pairs(TLM) do
                if type(v) == "string" and not k:find("long") then
                    local idx = add and v .. add or v
                    if IsValid(wagon.Models[1][idx]) then
                        break
                    else
                        local k_long = k .. "_long"
                        if TLM[k_long] and LenseNum >= 7 then
                            wagon.Models[1][idx] = ClientsideModel(TLM[k_long], RENDERGROUP_OPAQUE)
                            wagon.LongOffset = Vector(0, 0, TLM[k .. "_long_pos"])
                        else
                            wagon.Models[1][idx] = ClientsideModel(v, RENDERGROUP_OPAQUE)
                        end

                        wagon.Models[1][idx]:SetPos(wagon:LocalToWorld(pos))
                        wagon.Models[1][idx]:SetAngles(wagon:LocalToWorldAngles(ang))
                        wagon.Models[1][idx]:SetParent(wagon)
                    end
                end
            end
        end

        function ent.SpawnHeads(wagon, ID, model, pos, ang, glass, notM, add)
            if not IsValid(wagon.Models[1][ID]) then
                wagon.Models[1][ID] = ClientsideModel(model, RENDERGROUP_OPAQUE)
                wagon.Models[1][ID]:SetPos(wagon:LocalToWorld(pos))
                wagon.Models[1][ID]:SetAngles(wagon:LocalToWorldAngles(ang))
                wagon.Models[1][ID]:SetParent(wagon)
            end

            if wagon.RN and wagon.RN == wagon.RouteNumbers.sep then wagon.RN = wagon.RN + 1 end
            local id = wagon.RN
            local rouid = id and "rou" .. id
            if rouid and not IsValid(wagon.Models[1][rouid]) then
                local rnadd = (wagon.RouteNumbers[id] and wagon.RouteNumbers[id][1] ~= "X") and (wagon.RouteNumbers[id][3] and not wagon.RouteNumbers[id][2] and "2" or "") or "5"
                local LampIndicator = wagon.TrafficLightModels[wagon.LightType].LampIndicator
                wagon.Models[1][rouid] = ClientsideModel(LampIndicator.model .. rnadd .. ".mdl", RENDERGROUP_OPAQUE)
                wagon.Models[1][rouid]:SetPos(wagon:LocalToWorld(pos - wagon.RouteNumberOffset * (wagon.Left and LampIndicator[1] or LampIndicator[2])))
                wagon.Models[1][rouid]:SetAngles(wagon:GetAngles())
                wagon.Models[1][rouid]:SetParent(wagon)
                if wagon.RouteNumbers[id] then wagon.RouteNumbers[id].pos = pos - wagon.RouteNumberOffset * (wagon.Left and LampIndicator[1] or LampIndicator[2]) end
                wagon.RN = wagon.RN + 1
            end

            if notM then
                if glass then
                    local ID_glass = tostring(ID) .. "_glass"
                    for i, tbl in pairs(glass) do
                        local ID_glassi = ID_glass .. i
                        if not IsValid(wagon.Models[1][ID_glassi]) then --NEWLENSES
                            wagon.Models[1][ID_glassi] = ClientsideModel(tbl[1], RENDERGROUP_OPAQUE)
                            wagon.Models[1][ID_glassi]:SetPos(wagon:LocalToWorld(pos + tbl[2] * (add and Vector(-1, 1, 1) or 1)))
                            wagon.Models[1][ID_glassi]:SetAngles(wagon:LocalToWorldAngles(ang))
                            wagon.Models[1][ID_glassi]:SetParent(wagon)
                        end
                    end
                end
            end
        end

        function ent.SetLight(wagon, ID, ID2, pos, ang, skin, State, Change)
            local IsStateAboveZero = State > 0
            local IDID2 = ID .. ID2
            local IsModelValid = IsValid(wagon.Models[3][IDID2])
            if IsModelValid then
                if IsStateAboveZero then
                    if Change then wagon.Models[3][IDID2]:SetColor(Color(255, 255, 255, State * 255)) end
                else
                    wagon.Models[3][IDID2]:Remove()
                end
            elseif IsStateAboveZero then
                wagon.Models[3][IDID2] = ClientsideModel(wagon.TrafficLightModels[wagon.LightType].LampBase.model, RENDERGROUP_OPAQUE)
                wagon.Models[3][IDID2]:SetPos(wagon:LocalToWorld(pos))
                wagon.Models[3][IDID2]:SetAngles(wagon:LocalToWorldAngles(ang))
                wagon.Models[3][IDID2]:SetSkin(skin)
                wagon.Models[3][IDID2]:SetParent(wagon)
                wagon.Models[3][IDID2]:SetRenderMode(RENDERMODE_TRANSCOLOR)
                -- wagon.Models[3][IDID2]:SetColor(Color(255, 255, 255, 0))
                wagon.Models[3][IDID2]:SetColor(Color(255, 255, 255, State * 255))
            end
        end

        function ent.SpawnLetter(wagon, i, model, pos, letter, double)
            local LetMaterials = wagon.TrafficLightModels[wagon.LightType].LetMaterials.str
            local LetMaterialsStart = LetMaterials .. "let_start"
            local LetMaterialsletter = LetMaterials .. letter
            if double ~= false and not IsValid(wagon.Models[2][i]) and (wagon.Double or not wagon.Left) and (not letter:match("s[1-3]") or letter == "s3" or wagon.Double and wagon.Left) then
                wagon.Models[2][i] = ClientsideModel(model, RENDERGROUP_OPAQUE)
                wagon.Models[2][i]:SetAngles(wagon:LocalToWorldAngles(Angle(0, 180, 0)))
                wagon.Models[2][i]:SetPos(wagon:LocalToWorld(wagon.BasePosition + pos))
                wagon.Models[2][i]:SetParent(wagon)
                for k, v in pairs(wagon.Models[2][i]:GetMaterials()) do
                    if v:find(LetMaterialsStart) then wagon.Models[2][i]:SetSubMaterial(k - 1, LetMaterialsletter) end
                end
            end

            local id = i .. "d"
            if not double and not IsValid(wagon.Models[2][id]) and (wagon.Double or wagon.Left) and (not letter:match("s[1-3]") or letter == "s3" or wagon.Double and not wagon.Left) then
                wagon.Models[2][id] = ClientsideModel(model, RENDERGROUP_OPAQUE)
                wagon.Models[2][id]:SetAngles(wagon:LocalToWorldAngles(Angle(0, 180, 0)))
                wagon.Models[2][id]:SetPos(wagon:LocalToWorld((wagon.BasePosition + pos) * Vector(-1, 1, 1)))
                wagon.Models[2][id]:SetParent(wagon)
                for k, v in pairs(wagon.Models[2][id]:GetMaterials()) do
                    if v:find(LetMaterialsStart) then wagon.Models[2][id]:SetSubMaterial(k - 1, LetMaterialsletter) end
                end
            end
        end

        local C_RenderDistance = GetConVar("metrostroi_signal_distance")
        local timer = CurTime()
        hook.Add("Think", "MetrostroiRenderSignals", function()
            if CurTime() - timer < 1.5 or not IsValid(LocalPlayer()) then return end
            timer = CurTime()
            local plyPos = LocalPlayer():GetPos()
            local dist = C_RenderDistance:GetInt()
            for _, sig in pairs(ents.FindByClass("gmod_track_signal")) do
                if not IsValid(sig) then continue end
                local sigPos = sig:GetPos()
                sig.RenderDisable = sigPos:Distance(plyPos) > dist or math.abs(plyPos.z - sigPos.z) > 1500
            end
        end)

        function ent.Think(wagon)
            if wagon.PostInitalized then return end
            --DEBUG
            if Metrostroi.SignalDebugCV:GetBool() then
                wagon:SetNW2Bool("Debug", true)
                local next = wagon.NextSignalLink
                local pos = wagon.TrackPosition
                local prev = wagon.PrevSig
                if next then
                    next.PrevSig = wagon
                    local nextpos = wagon.NextSignalLink.TrackPosition
                    wagon:SetNW2String("NextSignalName", next.Name)
                    if pos and nextpos then
                        wagon:SetNW2Float("DistanceToNext", nextpos.x - pos.x)
                    else
                        wagon:SetNW2Float("DistanceToNext", 0)
                    end

                    wagon:SetNW2Int("NextPosID", nextpos and nextpos.path and nextpos.path.id or 0)
                    wagon:SetNW2Float("NextPos", nextpos and nextpos.x or 0)
                else
                    wagon:SetNW2String("NextSignalName", "N/A")
                    wagon:SetNW2Float("DistanceToNext", 0)
                    wagon:SetNW2Float("NextPos", 0)
                    wagon:SetNW2Float("NextPosID", 0)
                end

                if prev then
                    local prevpos = prev.TrackPosition
                    if pos and prevpos then
                        wagon:SetNW2Float("DistanceToPrev", -prevpos.x + pos.x)
                    else
                        wagon:SetNW2Float("DistanceToPrev", 0)
                    end

                    wagon:SetNW2String("PrevSignalName", wagon.PrevSig.Name)
                    wagon:SetNW2Int("PrevPosID", prevpos and prevpos.path and prevpos.path.id or 0)
                    wagon:SetNW2Float("PrevPos", prevpos and prevpos.x or 0)
                else
                    wagon:SetNW2String("PrevSignalName", "N/A")
                    wagon:SetNW2Int("PrevPosID", 0)
                    wagon:SetNW2Float("PrevPos", 0)
                end

                wagon:SetNW2Float("Pos", pos and pos.x or 0)
                wagon:SetNW2Int("PosID", pos and pos.path and pos.path.id or 0)
                wagon:SetNW2Bool("CurrentRoute", wagon.Route or -1)
                wagon:SetNW2Bool("Occupied", wagon.Occupied)
                wagon:SetNW2Bool("2/6", wagon.TwoToSix)
                wagon:SetNW2Int("FreeBS", wagon.FreeBS)
                wagon:SetNW2Bool("LinkedToController", wagon.Controllers ~= nil)
                wagon:SetNW2Int("ControllersNumber", wagon.Controllers ~= nil and #wagon.Controllers or -1)
                wagon:SetNW2Bool("BlockedByController", wagon.ControllerLogic)
                for i = 0, 8 do
                    if i == 3 or i == 5 then continue end
                    wagon:SetNW2Bool("CurrentARS" .. i, wagon:GetARS(i))
                end

                wagon:SetNW2Bool("CurrentARS325", wagon:GetRS())
                wagon:SetNW2Bool("CurrentARS325_2", wagon:Get325HzAproove0())
            end

            if not wagon.ControllerLogic then
                if not wagon.Routes or #wagon.Routes == 0 then
                    ErrorNoHalt(Format("Metrostroi:Signal %s don't have a routes!\n", wagon.Name))
                    return
                end

                if not wagon.Routes[wagon.Route or 1] then
                    ErrorNoHalt(Format("Metrostroi:Signal %s have a null %s route!!\n", wagon.Name, wagon.Route))
                    return
                end

                wagon.PrevTime = wagon.PrevTime or 0
                if (CurTime() - wagon.PrevTime) > 1.0 then
                    wagon.PrevTime = CurTime() + math.random(0.5, 1.5)
                    wagon:ARSLogic(wagon.PrevTime - CurTime())
                end

                wagon.RouteNumberOverrite = nil
                local number = ""
                if wagon.MU or wagon.ARSOnly or wagon.RouteNumberSetup and wagon.RouteNumberSetup ~= "" or wagon.RouteNumber and wagon.RouteNumber ~= "" then
                    if wagon.NextSignalLink then
                        if not wagon.NextSignalLink.Red and not wagon.Red then
                            wagon.RouteNumberOverrite = wagon.NextSignalLink.RouteNumberOverrite ~= "" and wagon.NextSignalLink.RouteNumberOverrite or wagon.NextSignalLink.RouteNumber
                        else
                            wagon.RouteNumberOverrite = wagon.RouteNumber
                        end

                        if (not wagon.Red or wagon.InvationSignal) and wagon.Routes[wagon.Route or 1].EnRou then
                            if wagon.NextSignalLink.RouteNumberOverrite then number = number .. wagon.NextSignalLink.RouteNumberOverrite end
                            if wagon.NextSignalLink.RouteNumber and not wagon.AutoEnabled then number = number .. wagon.NextSignalLink.RouteNumber end
                        end

                        --print(wagon.Name,wagon.NextSignalLink.RouteNumberOverrite)
                        wagon.RouteNumberOverrite = (wagon.RouteNumberOverrite or "") .. number
                    else
                        wagon.RouteNumberOverrite = wagon.RouteNumber
                    end
                end

                if wagon.InvationSignal and wagon.GoodInvationSignal == -1 then number = number .. "W" end
                if wagon.KGU then number = number .. "K" end
                if number then wagon:SetNW2String("Number", number) end
                if wagon.Occupied ~= wagon.OccupiedOld then
                    hook.Run("Metrostroi.Signaling.ChangeRCState", wagon.Name, wagon.Occupied, wagon)
                    wagon.OccupiedOld = wagon.Occupied
                end

                if wagon.ARSOnly then
                    if wagon.Sprites then
                        for k, v in pairs(wagon.Sprites) do
                            SafeRemoveEntity(v)
                            wagon.Sprites[k] = nil
                        end

                        if wagon.ARSOnly and wagon.Sprites then wagon.Sprites = nil end
                    end

                    wagon:SetNW2String("Signal", "")
                    wagon.AutoEnabled = not wagon.ARSOnly
                    return
                end

                wagon.AutoEnabled = false
                wagon.Red = nil
                if not wagon.Routes[wagon.Route or 1].Lights then return end
                local Route = wagon.Routes[wagon.Route or 1]
                local index = 1
                local offset = wagon.RenderOffset[wagon.SignalType] or Vector(0, 0, 0)
                wagon.Sig = ""
                wagon.Colors = ""
                for k, v in ipairs(wagon.Lenses) do
                    if wagon.Routes[wagon.Route or 1].Repeater and IsValid(wagon.NextSignalLink) and (not wagon.Routes[wagon.Route or 1].Lights or wagon.Routes[wagon.Route or 1].Lights == "") then break end
                    if v ~= "M" then
                        --get the some models data
                        local data = #v ~= 1 and wagon.TrafficLightModels[wagon.SignalType][#v - 1] or wagon.TrafficLightModels[wagon.SignalType][wagon.Signal_IS]
                        if not data then continue end
                        for i = 1, #v do
                            --Get the LightID and check, is this light must light up
                            local LightID = IsValid(wagon.NextSignalLink) and math.min(#Route.LightsExploded, wagon.FreeBS + 1) or 1
                            local AverageState = Route.LightsExploded[LightID]:find(tostring(index)) or ((v[i] == "W" and wagon.InvationSignal and wagon.GoodInvationSignal == index) and 1 or 0)
                            local MustBlink = (v[i] == "W" and wagon.InvationSignal and wagon.GoodInvationSignal == index) or (AverageState > 0 and Route.LightsExploded[LightID][AverageState + 1] == "b") --Blinking, when next is "b" (or it's invasion signal')
                            wagon.Sig = wagon.Sig .. (AverageState > 0 and (MustBlink and 2 or 1) or 0)
                            if AverageState > 0 then
                                if wagon.GoodInvationSignal ~= index then wagon.Colors = wagon.Colors .. (MustBlink and v[i]:lower() or v[i]:upper()) end
                                if v[i] == "R" then
                                    wagon.AutoEnabled = not wagon.NonAutoStop
                                    wagon.Red = true
                                end
                            end

                            index = index + 1
                        end
                    end
                end
            else
                local number = wagon.RouteNumberReplace or ""
                if wagon.ControllerLogicCheckOccupied then
                    wagon.PrevTime = wagon.PrevTime or 0
                    if (CurTime() - wagon.PrevTime) > 0.5 then
                        wagon.PrevTime = CurTime() + math.random(0.5, 1.5)
                        if wagon.Node and wagon.TrackPosition then wagon.Occupied, wagon.OccupiedBy, wagon.OccupiedByNow = Metrostroi.IsTrackOccupied(wagon.Node, wagon.TrackPosition.x, wagon.TrackPosition.forward, wagon.ARSOnly and "ars" or "light", wagon) end
                    end

                    if wagon.Occupied ~= wagon.OccupiedOld then
                        hook.Run("Metrostroi.Signaling.ChangeRCState", wagon.Name, wagon.Occupied, wagon)
                        wagon.OccupiedOld = wagon.Occupied
                    end
                end

                --[[
		if wagon.MU or wagon.ARSOnly or wagon.RouteNumberSetup and wagon.RouteNumberSetup ~= "" or wagon.RouteNumber and wagon.RouteNumber ~= "" then
			if wagon.NextSignalLink then
				if not wagon.NextSignalLink.AutoEnabled and not wagon.AutoEnabled then
					wagon.RouteNumberOverrite = wagon.NextSignalLink.RouteNumberOverrite ~= "" and wagon.NextSignalLink.RouteNumberOverrite or wagon.NextSignalLink.RouteNumber
				else
					wagon.RouteNumberOverrite = wagon.RouteNumber
				end
				if wagon.NextSignalLink.RouteNumberOverrite and not wagon.AutoEnabled and (wagon.Routes[wagon.Route or 1].EnRou or wagon.InvationSignal) then
					number = number..wagon.NextSignalLink.RouteNumberOverrite
				end
				if wagon.NextSignalLink.RouteNumber and (wagon.Routes[wagon.Route or 1].EnRou and not wagon.AutoEnabled or wagon.InvationSignal) then
					number = number..wagon.NextSignalLink.RouteNumber
				end
				--print(wagon.Name,wagon.NextSignalLink.RouteNumberOverrite)
				wagon.RouteNumberOverrite = (wagon.RouteNumberOverrite or "")..number
			else
				wagon.RouteNumberOverrite = wagon.RouteNumber
			end
		end]]
                if wagon.InvationSignal and wagon.GoodInvationSignal == -1 then number = number .. "W" end
                if wagon.KGU then number = number .. "K" end
                if number then wagon:SetNW2String("Number", number) end
                local index = 1
                wagon.Colors = ""
                for k, v in ipairs(wagon.Lenses) do
                    if v ~= "M" then
                        --get the some models data
                        local data = #v ~= 1 and wagon.TrafficLightModels[wagon.SignalType][#v - 1] or wagon.TrafficLightModels[wagon.SignalType][wagon.Signal_IS]
                        if not data then continue end
                        for i = 1, #v do
                            if wagon.Sig[index] == "1" or wagon.Sig[index] == "2" then wagon.Colors = wagon.Colors .. v[i]:lower() end
                            index = index + 1
                        end
                    end
                end
            end

            if wagon.Controllers then
                for k, v in pairs(wagon.Controllers) do
                    if wagon.Sig ~= v.Sig then
                        local Route = wagon.Routes[wagon.Route or 1]
                        local LightID = IsValid(wagon.NextSignalLink) and math.min(#Route.LightsExploded, wagon.FreeBS + 1) or 1
                        local lights = Route.LightsExploded[LightID]
                        v:TriggerOutput("LenseEnabled", wagon, Route.LightsExploded[LightID])
                        v.Sig = wagon.Sig
                    end

                    if v.OldIS ~= wagon.InvationSignal then
                        if wagon.InvationSignal then
                            v:TriggerOutput("LenseEnabled", wagon, "I")
                        else
                            v:TriggerOutput("LenseDisabled", wagon, "I")
                        end

                        v.OldIS = wagon.InvationSignal
                    end
                end
            end

            wagon:SetNW2String("Signal", wagon.Sig)
            if not wagon.AutostopPresent then wagon:SetNW2Bool("Autostop", wagon.AutoEnabled) end
            wagon:NextThink(CurTime() + 0.25)
            return true
        end
    end
end