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
MEL.SpawnerFieldMappings = {} -- lookup table for accessing spawner fields by name and list elements by default, non-translated name
-- (key: train_class, value: (key: field_name, value: {index = index_of_field, list_elements = (key: name of list element, value: index)}))
if CLIENT then
    CreateClientConVar("metrostroi_shadows4", 0, true)
    CreateClientConVar("metrostroi_sprites", 1, true)
    CreateClientConVar("metrostroi_cabz", 0, true)
    CreateClientConVar("metrostroi_disableseatshadows", 0, true)
    function Metrostroi.GenerateClientProps()
        print("new one!")
        local self = ENT
        if not self.AutoAnimNames then self.AutoAnimNames = {} end
        local ret = "self.table = {\n"
        --local reti = 0
        for id, panel in pairs(self.ButtonMap) do
            if not panel.buttons then continue end
            if not panel.props then panel.props = {} end
            for name, buttons in pairs(panel.buttons) do
                --if reti > 8 then reti=0; ret=ret.."\n" end
                if buttons.tooltipFunc then
                    local func = buttons.tooltipFunc
                    buttons.tooltipState = function(ent)
                        local str = func(ent)
                        if not str then return "" end
                        return "\n[" .. str:gsub("\n", "]\n[") .. "]"
                    end
                elseif buttons.varTooltip then
                    local states = buttons.states or {"Train.Buttons.Off", "Train.Buttons.On"}
                    local count = #states - 1
                    buttons.tooltipState = function(ent) return Format("\n[%s]", Metrostroi.GetPhrase(states[math.floor(buttons.varTooltip(ent) * count + 0.5) + 1]):gsub("\n", "]\n[")) end
                elseif buttons.var then
                    local var = buttons.var
                    local st1, st2 = "Train.Buttons.Off", "Train.Buttons.On"
                    if buttons.states then
                        st1 = buttons.states[1]
                        st2 = buttons.states[2]
                    end

                    buttons.tooltipState = function(ent) return Format("\n[%s]", Metrostroi.GetPhrase(ent:GetPackedBool(var) and st2 or st1):gsub("\n", "]\n[")) end
                end

                if buttons.model then
                    local config = buttons.model
                    local name = config.name or buttons.ID
                    if config.tooltipFunc then
                        local func = config.tooltipFunc
                        buttons.tooltipState = function(ent)
                            local str = func(ent)
                            if not str then return "" end
                            return "\n[" .. str:gsub("\n", "]\n[") .. "]"
                        end
                    elseif config.varTooltip then
                        local states = config.states or {"Train.Buttons.Off", "Train.Buttons.On"}
                        local count = #states - 1
                        local func = config.getfunc
                        if config.varTooltip == true and func then
                            buttons.tooltipState = function(ent) return Format("\n[%s]", Metrostroi.GetPhrase(states[math.floor(config.func(ent) * count + 0.5) + 1]):gsub("\n", "]\n[")) end
                        elseif config.varTooltip ~= true then
                            buttons.tooltipState = function(ent) return Format("\n[%s]", Metrostroi.GetPhrase(states[math.floor(config.varTooltip(ent) * count + 0.5) + 1]):gsub("\n", "]\n[")) end
                        end
                    elseif config.var and (not config.noTooltip and not buttons.ID:find("Set") or config.noTooltip == false) then
                        local var = config.var
                        local st1, st2 = "Train.Buttons.Off", "Train.Buttons.On"
                        if config.states then
                            st1 = config.states[1]
                            st2 = config.states[2]
                        end

                        buttons.tooltipState = function(ent) return Format("\n[%s]", Metrostroi.GetPhrase(ent:GetPackedBool(var) and st2 or st1)) end
                    end

                    if config.model then
                        table.insert(panel.props, name)
                        self.ClientProps[name] = {
                            model = config.model or "models/metrostroi/81-717/button07.mdl",
                            pos = Metrostroi.PositionFromPanel(id, config.pos or buttons.ID, config.z or 0.2, config.x or 0, config.y or 0),
                            ang = Metrostroi.AngleFromPanel(id, config.ang),
                            color = config.color,
                            colora = config.colora,
                            skin = config.skin or 0,
                            config = config,
                            cabin = config.cabin,
                            hide = panel.hide or config.hide,
                            hideseat = panel.hideseat or config.hideseat,
                            bscale = config.bscale,
                            scale = config.scale,
                        }

                        --[[if config.varTooltip then
                            local states = config.states or {"Train.Buttons.On","Train.Buttons.Off"}
                            local count = (#states-1)
                            buttons.tooltipState = function(ent)
                                local text = "\n["
                                for i,t in ipairs(states) do
                                    if i == #states then
                                        text = text..Metrostroi.GetPhrase(t)
                                    else
                                        text = text..Metrostroi.GetPhrase(t).."|"
                                    end
                                end
                                text = text.."]"
                                return text,states[math.floor(config.varTooltip(ent)+0.5)*count+1]
                            end
                        elseif (config.var and not config.noTooltip) then
                            local var = config.var
                            local st1,st2 = "Train.Buttons.On","Train.Buttons.Off"
                            if config.states then
                                st1 = config.states[1]
                                st2 = config.states[2]
                            end
                            buttons.tooltipState = function(ent)
                                return Format("\n[%s|%s]",Metrostroi.GetPhrase(st1),Metrostroi.GetPhrase(st2)),ent:GetPackedBool(var) and st1 or st2
                            end
                        end]]
                        if config.var then
                            local var = config.var
                            local vmin, vmax = config.vmin or 0, config.vmax or 1
                            local min, max = config.min or 0, config.max or 1
                            local speed, damping, stickyness = config.speed or 16, config.damping or false, config.stickyness or nil
                            local func = config.getfunc
                            local i
                            if func then
                                if config.disable then
                                    i = table.insert(self.AutoAnims, function(ent)
                                        ent:Animate(name, func(ent, vmin, vmax, var), min, max, speed, damping, stickyness)
                                        ent:HideButton(config.disable, ent:GetPackedBool(var))
                                    end)
                                elseif config.disableinv then
                                    i = table.insert(self.AutoAnims, function(ent)
                                        ent:Animate(name, func(ent, vmin, vmax, var), min, max, speed, damping, stickyness)
                                        ent:HideButton(config.disableinv, not ent:GetPackedBool(var))
                                    end)
                                elseif config.disableoff and config.disableon then
                                    i = table.insert(self.AutoAnims, function(ent)
                                        ent:Animate(name, func(ent, vmin, vmax, var), min, max, speed, damping, stickyness)
                                        ent:HideButton(config.disableoff, ent:GetPackedBool(var))
                                        ent:HideButton(config.disableon, not ent:GetPackedBool(var))
                                    end)
                                elseif config.disablevar then
                                    i = table.insert(self.AutoAnims, function(ent)
                                        ent:HideButton(name, ent:GetPackedBool(config.disablevar))
                                        ent:Animate(name, func(ent, vmin, vmax, var), min, max, speed, damping, stickyness)
                                    end)
                                else
                                    i = table.insert(self.AutoAnims, function(ent) ent:Animate(name, func(ent, vmin, vmax), min, max, speed, damping, stickyness) end)
                                end
                            else
                                if config.disable then
                                    i = table.insert(self.AutoAnims, function(ent)
                                        ent:Animate(name, ent:GetPackedBool(var) and vmax or vmin, min, max, speed, damping, stickyness)
                                        ent:HideButton(config.disable, ent:GetPackedBool(var))
                                    end)
                                elseif config.disableinv then
                                    i = table.insert(self.AutoAnims, function(ent)
                                        ent:Animate(name, ent:GetPackedBool(var) and vmax or vmin, min, max, speed, damping, stickyness)
                                        ent:HideButton(config.disableinv, not ent:GetPackedBool(var))
                                    end)
                                elseif config.disableoff and config.disableon then
                                    i = table.insert(self.AutoAnims, function(ent)
                                        ent:Animate(name, ent:GetPackedBool(var) and vmax or vmin, min, max, speed, damping, stickyness)
                                        ent:HideButton(config.disableoff, ent:GetPackedBool(var))
                                        ent:HideButton(config.disableon, not ent:GetPackedBool(var))
                                    end)
                                elseif config.disablevar then
                                    i = table.insert(self.AutoAnims, function(ent)
                                        ent:HideButton(name, ent:GetPackedBool(config.disablevar))
                                        ent:Animate(name, ent:GetPackedBool(var) and vmax or vmin, min, max, speed, damping, stickyness)
                                    end)
                                else
                                    i = table.insert(self.AutoAnims, function(ent) ent:Animate(name, ent:GetPackedBool(var) and vmax or vmin, min, max, speed, damping, stickyness) end)
                                end
                            end

                            self.AutoAnimNames[i] = name
                        end
                    end

                    if config.sound or config.sndvol and config.var then
                        local id = config.sound or config.var
                        local sndid = config.sndid or buttons.ID
                        local vol, pitch, min, max = config.sndvol, config.sndpitch, config.sndmin, config.sndmax
                        local func, snd = config.getfunc, config.snd
                        local vmin, vmax = config.vmin or 0, config.vmax or 1
                        local var = config.var
                        local ang = config.sndang
                        --if func then
                        --self.ClientSounds[id] = {sndid,function(ent,var) return snd(func(ent,vmin,vmax),var) end,vol or 1,pitch or 1,min or 100,max or 1000,ang or Angle(0,0,0)}
                        --else
                        if not self.ClientSounds[id] then self.ClientSounds[id] = {} end
                        table.insert(self.ClientSounds[id], {sndid, function(ent, var) return snd(var > 0, var) end, vol or 1, pitch or 1, min or 100, max or 1000, ang or Angle(0, 0, 0)})
                        --end
                    end

                    if config.plomb then
                        local pconfig = config.plomb
                        local pname = name .. "_pl"
                        if pconfig.model then
                            table.insert(panel.props, pname)
                            self.ClientProps[pname] = {
                                model = pconfig.model,
                                pos = Metrostroi.PositionFromPanel(id, config.pos or buttons.ID, (config.z or 0.2) + (pconfig.z or 0.2), (config.x or 0) + (pconfig.x or 0), (config.y or 0) + (pconfig.y or 0)),
                                ang = Metrostroi.AngleFromPanel(id, pconfig.ang or config.ang),
                                color = pconfig.color or pconfig.color,
                                skin = pconfig.skin or config.skin or 0,
                                config = pconfig,
                                cabin = pconfig.cabin,
                                hide = panel.hide or config.hide,
                                hideseat = panel.hideseat or config.hideseat,
                                bscale = pconfig.bscale or config.bscale,
                                scale = pconfig.scale or config.scale,
                            }
                        end

                        if pconfig.var then
                            local var = pconfig.var
                            if pconfig.model then
                                local i = table.insert(self.AutoAnims, function(ent) ent:SetCSBodygroup(pname, 1, ent:GetPackedBool(var) and 0 or 1) end)
                                self.AutoAnimNames[i] = pname
                            end

                            local id, tooltip = buttons.ID, buttons.tooltip
                            local pid, ptooltip = pconfig.ID, pconfig.tooltip
                            buttons.plombed = function(ent)
                                if ent:GetPackedBool(var) then
                                    return Format("%s\n%s", buttons.tooltip, Metrostroi.GetPhrase("Train.Buttons.Sealed") or "Plombed"), pid, Color(255, 150, 150), true
                                else
                                    return buttons.tooltip, id, false
                                end
                            end
                        end
                    end

                    if config.lamp then
                        local lconfig = config.lamp
                        local lname = name .. "_lamp"
                        table.insert(panel.props, lname)
                        self.ClientProps[lname] = {
                            model = lconfig.model or "models/metrostroi/81-717/button07.mdl",
                            pos = Metrostroi.PositionFromPanel(id, config.pos or buttons.ID, (config.z or 0.2) + (lconfig.z or 0.2), (config.x or 0) + (lconfig.x or 0), (config.y or 0) + (lconfig.y or 0)),
                            ang = Metrostroi.AngleFromPanel(id, lconfig.ang or config.ang),
                            color = lconfig.color or config.color,
                            skin = lconfig.skin or config.skin or 0,
                            config = lconfig,
                            cabin = lconfig.cabin,
                            igrorepanel = true,
                            hide = panel.hide or config.hide,
                            hideseat = panel.hideseat or config.hideseat,
                            bscale = lconfig.bscale or config.bscale,
                            scale = lconfig.scale or config.scale,
                        }

                        if lconfig.anim then
                            local i = table.insert(self.AutoAnims, function(ent) ent:AnimateFrom(lname, name) end)
                            self.AutoAnimNames[i] = lname
                        end

                        if lconfig.lcolor then
                            self.Lights[lname] = {
                                "headlight",
                                Metrostroi.PositionFromPanel(id, config.pos or buttons.ID, (config.z or 0.2) + (lconfig.z or 0.2) + (lconfig.lz or 0.2), (config.x or 0) + (lconfig.x or 0) + (lconfig.lx or 0), (config.y or 0) + (lconfig.y or 0) + (lconfig.ly or 0)),
                                Metrostroi.AngleFromPanel(id, lconfig.lang or lconfig.ang or config.ang) + Angle(90, 0, 0),
                                lconfig.lcolor,
                                farz = lconfig.lfar or 8,
                                nearz = lconfig.lnear or 1,
                                shadows = lconfig.lshadows or 1,
                                brightness = lconfig.lbright or 1,
                                fov = lconfig.lfov,
                                texture = lconfig.ltex or "effects/flashlight/soft",
                                panellight = true,
                                hidden = lname,
                            }
                            --[[self.ClientProps[lname.."TEST"] = {
                                model = "models/metrostroi_train/81-703/cabin_cran_334.mdl",
                                pos = Metrostroi.PositionFromPanel(id,config.pos or buttons.ID,(config.z or 0.2)+(lconfig.z or 0.2)+(lconfig.lz or 0.2),(config.x or 0)+(lconfig.x or 0)+(lconfig.lx or 0),(config.y or 0)+(lconfig.y or 0)+(lconfig.ly or 0)),
                                ang = Metrostroi.AngleFromPanel(id,lconfig.lang or lconfig.ang or config.ang)+Angle(-180,180,0),
                                scale=0.1,
                            }]]
                            --[[table.insert(self.AutoAnims, function(ent)
                                ent:AnimateFrom(lname,name)
                            end)]]
                        end

                        if lconfig.var then
                            --ret=ret.."\""..lconfig.var.."\","
                            --reti = reti + 1
                            local var, animvar = lconfig.var, lname .. "_anim"
                            local min, max = lconfig.min or 0, lconfig.max or 1
                            local speed = lconfig.speed or 10
                            local func = lconfig.getfunc
                            local light = lconfig.lcolor
                            if func then
                                table.insert(self.AutoAnims, function(ent)
                                    local val = ent:Animate(animvar, func(ent, min, max, var), 0, 1, speed, false)
                                    ent:ShowHideSmooth(lname, val)
                                    if light then ent:SetLightPower(lname, val > 0, val) end
                                end)
                            else
                                local i = table.insert(self.AutoAnims, function(ent)
                                    --print(lname,ent.SmoothHide[lname])
                                    local val = ent:Animate(animvar, ent:GetPackedBool(var) and max or min, 0, 1, speed, false)
                                    ent:ShowHideSmooth(lname, val)
                                    if light then ent:SetLightPower(lname, val > 0, val) end
                                end)
                            end
                        end
                    end

                    if config.lamps then
                        for k, lconfig in ipairs(config.lamps) do
                            local lname = name .. "_lamp" .. k
                            table.insert(panel.props, lname)
                            self.ClientProps[lname] = {
                                model = lconfig.model or "models/metrostroi/81-717/button07.mdl",
                                pos = Metrostroi.PositionFromPanel(id, config.pos or buttons.ID, (config.z or 0.2) + (lconfig.z or 0.2), (config.x or 0) + (lconfig.x or 0), (config.y or 0) + (lconfig.y or 0)),
                                ang = Metrostroi.AngleFromPanel(id, lconfig.ang or config.ang),
                                color = lconfig.color or config.color,
                                skin = lconfig.skin or config.skin or 0,
                                config = lconfig,
                                cabin = lconfig.cabin,
                                igrorepanel = true,
                                hide = panel.hide or config.hide,
                                hideseat = panel.hideseat or config.hideseat,
                                bscale = lconfig.bscale or config.bscale,
                                scale = lconfig.scale or config.scale,
                            }

                            if lconfig.var then
                                --ret=ret.."\""..lconfig.var.."\","
                                --reti = reti + 1
                                local var, animvar = lconfig.var, lname .. "_anim"
                                local min, max = lconfig.min or 0, lconfig.max or 1
                                local speed = lconfig.speed or 10
                                local func = lconfig.getfunc
                                if func then
                                    table.insert(self.AutoAnims, function(ent)
                                        local val = ent:Animate(animvar, func(ent, min, max, var), 0, 1, speed, false)
                                        ent:ShowHideSmooth(lname, val)
                                    end)
                                else
                                    table.insert(self.AutoAnims, function(ent)
                                        --print(lname,ent.SmoothHide[lname])
                                        local val = ent:Animate(animvar, ent:GetPackedBool(var) and max or min, 0, 1, speed, false)
                                        ent:ShowHideSmooth(lname, val)
                                    end)
                                end
                            end
                        end
                    end

                    if config.sprite then
                        local sconfig = config.sprite
                        local hideName = sconfig.hidden or config.lamp and name .. "_lamp" or name
                        self.Lights[sconfig.lamp or name] = {
                            sconfig.glow and "glow" or "light",
                            Metrostroi.PositionFromPanel(id, config.pos or buttons.ID, (config.z or 0.5) + (sconfig.z or 0.2), (config.x or 0) + (sconfig.x or 0), (config.y or 0) + (sconfig.y or 0)),
                            Metrostroi.AngleFromPanel(id, sconfig.ang or config.ang) + Angle(90, 0, 0),
                            sconfig.color or sconfig.color,
                            brightness = sconfig.bright,
                            texture = sconfig.texture or "sprites/light_glow02",
                            scale = sconfig.scale or 0.02,
                            vscale = sconfig.vscale,
                            size = sconfig.size,
                            hidden = hideName,
                            aa = sconfig.aa,
                            panel = sconfig.panel ~= false,
                        }

                        local i
                        if sconfig.getfunc then
                            local func = sconfig.getfunc
                            i = table.insert(self.AutoAnims, function(ent)
                                local val = func(ent)
                                ent:SetLightPower(name, not ent.Hidden[hideName] and val > 0, val)
                            end)
                        elseif sconfig.var then
                            --ret=ret.."\""..lconfig.var.."\","
                            --reti = reti + 1
                            local var, animvar = sconfig.var, name .. "_sanim"
                            local speed = sconfig.speed or 10
                            i = table.insert(self.AutoAnims, function(ent)
                                local val = ent:Animate(animvar, ent:GetPackedBool(var) and 1 or 0, 0, 1, speed, false)
                                ent:SetLightPower(name, val > 0, val)
                            end)
                        elseif sconfig.lamp then
                            local lightName = sconfig.lamp
                            i = table.insert(self.AutoAnims, function(ent)
                                local val = ent.Anims[lightName] and ent.Anims[lightName].value or 0
                                ent:SetLightPower(lightName, val > 0, val)
                            end)
                        elseif config.lamp and config.lamp.var then
                            local lname = name .. "_lamp"
                            local lightName = lname .. "_anim"
                            i = table.insert(self.AutoAnims, function(ent)
                                local val = ent.Anims[lightName] and ent.Anims[lightName].value or 0
                                ent:SetLightPower(name, val > 0, val)
                            end)
                        end

                        if not i then
                            ErrorNoHalt("Bad sprite " .. name .. "/" .. hideName .. ", no controlable function...\n")
                        else
                            self.AutoAnimNames[i] = hideName
                        end
                    end

                    if config.labels then
                        for k, aconfig in ipairs(config.labels) do
                            local aname = name .. "_label" .. k
                            table.insert(panel.props, aname)
                            self.ClientProps[aname] = {
                                model = aconfig.model or "models/metrostroi/81-717/button07.mdl",
                                pos = Metrostroi.PositionFromPanel(id, config.pos or buttons.ID, (config.z or 0.2) + (aconfig.z or 0.2), (config.x or 0) + (aconfig.x or 0), (config.y or 0) + (aconfig.y or 0)),
                                ang = Metrostroi.AngleFromPanel(id, aconfig.ang or config.ang),
                                color = aconfig.color or config.color,
                                colora = aconfig.colora or config.colora,
                                skin = aconfig.skin or config.skin or 0,
                                config = aconfig,
                                cabin = aconfig.cabin,
                                igrorepanel = true,
                                hide = panel.hide or config.hide,
                                hideseat = panel.hideseat or config.hideseat,
                                bscale = aconfig.bscale or config.bscale,
                                scale = aconfig.scale or config.scale,
                            }
                        end
                    end

                    buttons.model = nil
                end
            end
        end

        for k, v in pairs(self.ClientProps) do
            if not v.model then continue end
            -- Metrostroi.PrecacheModels[v.model] = true
        end

        for k, v in pairs(self.Lights or {}) do
            if not v.hidden then continue end
            local cP = self.ClientProps[v.hidden]
            if not cP then
                ErrorNoHalt("No clientProp " .. v.hidden .. " in entity " .. self.Folder .. "\n")
                continue
            end

            if not cP.lamps then cP.lamps = {} end
            table.insert(cP.lamps, k)
        end
        --ret = ret.."\n}"
        --SetClipboardText(ret)
    end
end

local SpawnerC = MEL.Constants.Spawner
MEL.Helpers = {}
--List of spawned trains
Metrostroi.SpawnedTrains = {}
for k, ent in pairs(ents.GetAll()) do
    if ent.Base == "gmod_subway_base" or ent:GetClass() == "gmod_subway_base" then Metrostroi.SpawnedTrains[ent] = true end
end

hook.Add("EntityRemoved", "MetrostroiTrains", function(ent) if Metrostroi.SpawnedTrains[ent] then Metrostroi.SpawnedTrains[ent] = nil end end)
if SERVER then
    hook.Add("OnEntityCreated", "MetrostroiTrains", function(ent) if ent.Base == "gmod_subway_base" or ent:GetClass() == "gmod_subway_base" then Metrostroi.SpawnedTrains[ent] = true end end)
else
    hook.Add("OnEntityCreated", "MetrostroiTrains", function(ent) if ent:GetClass() == "gmod_subway_base" or scripted_ents.IsBasedOn(ent:GetClass(), "gmod_subway_base") then Metrostroi.SpawnedTrains[ent] = true end end)
end

function MEL.Helpers.getListElementIndex(field_table, element_name)
    if field_table[SpawnerC.TYPE] == SpawnerC.TYPE_LIST and istable(field_table[SpawnerC.List.ELEMENTS]) then
        for list_i, name in pairs(field_table[SpawnerC.List.ELEMENTS]) do
            if name == element_name then return list_i end
        end
    end
end

local function populateSpawnerFieldMappings()
    for _, train_class in pairs(MEL.TrainClasses) do
        local ent_table = MEL.EntTables[train_class]
        if not ent_table.Spawner then continue end
        MEL.SpawnerFieldMappings[train_class] = {}
        for field_i, field in pairs(ent_table.Spawner) do
            if istable(field) and isstring(field[SpawnerC.NAME]) then
                local field_name = field[SpawnerC.NAME]
                if MEL.SpawnerFieldMappings[train_class][field_name] then continue end
                MEL.SpawnerFieldMappings[train_class][field_name] = {
                    index = field_i,
                    list_elements = {}
                }

                if field[SpawnerC.TYPE] == SpawnerC.TYPE_LIST and istable(field[SpawnerC.List.ELEMENTS]) then
                    for list_i, name in pairs(field[SpawnerC.List.ELEMENTS]) do
                        MEL.SpawnerFieldMappings[train_class][field_name].list_elements[name] = list_i
                    end
                end
            end
        end
    end
end

function MEL._LoadHelpers()
    populateSpawnerFieldMappings()
end