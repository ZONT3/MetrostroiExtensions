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
MEL.AnimateOverrides = {} -- table with Animate overrides
-- (key: ent_class, value: (key: clientProp name, value: sequential table to unpack into animate (starting from min)))
MEL.AnimateValueOverrides = {} -- table with Animate value overrides
-- (key: ent_class, value: (key: clientProp name, value: function to get value))
MEL.ShowHideOverrides = {} -- table with ShowHide value overrides
-- (key: ent_class, value: (key: clientProp name, value: function to get value))
MEL.DecoratorCache = {} -- table with cached values like angles and vectors for CachedDecorator
-- (key: ent_class, value: (key: decorator name, (key: key, value: cached value)))
function MEL.UpdateModelCallback(ent, clientprop_name, new_modelcallback, field_name, error_on_nil)
    if CLIENT then
        if not ent.ClientProps or not ent.ClientProps[clientprop_name] then
            if error_on_nil then MEL._LogError(Format("no such clientprop with name %s", clientprop_name)) end
            return
        end

        local old_modelcallback = ent.ClientProps[clientprop_name]["modelcallback"] or function() end
        ent.ClientProps[clientprop_name]["modelcallback"] = function(wagon)
            local new_modelpath = new_modelcallback(wagon)
            return new_modelpath or old_modelcallback(wagon)
        end

        if field_name then MEL.MarkClientPropForReload(ent, clientprop_name, field_name) end
    end
end

function MEL._OverrideAnimate(ent)
    function ent.Animate(wagon, clientProp, value, min, max, speed, damping, stickyness)
        local id = clientProp
        -- maybe reuse old function and just unpack our overrides into it?
        if MEL.AnimateOverrides[MEL.GetEntclass(wagon)] and MEL.AnimateOverrides[MEL.GetEntclass(wagon)][id] then
            local override = MEL.AnimateOverrides[MEL.GetEntclass(wagon)][id]
            if isfunction(override) then override = override(wagon) end
            min = override[1]
            max = override[2]
            speed = override[3]
            damping = override[4]
            stickyness = override[5]
        end

        if MEL.AnimateValueOverrides[MEL.GetEntclass(wagon)] and MEL.AnimateValueOverrides[MEL.GetEntclass(wagon)][id] then
            local value_callback = MEL.AnimateValueOverrides[MEL.GetEntclass(wagon)][id]
            value = value_callback(wagon)
        end

        local anims = wagon.Anims
        if not anims[id] then
            anims[id] = {}
            anims[id].val = value
            anims[id].value = min + (max - min) * value
            anims[id].V = 0.0
            anims[id].block = false
            anims[id].stuck = false
            anims[id].P = value
        end

        if wagon.Hidden[id] or wagon.Hidden.anim[id] then return 0 end
        if anims[id].Ignore then
            if RealTime() - anims[id].Ignore < 0 then
                return anims[id].value
            else
                anims[id].Ignore = nil
            end
        end

        local val = anims[id].val
        if value ~= val then anims[id].block = false end
        if anims[id].block then
            if anims[id].reload and IsValid(wagon.ClientEnts[clientProp]) then
                wagon.ClientEnts[clientProp]:SetPoseParameter("position", anims[id].value)
                anims[id].reload = false
            end
            return anims[id].value --min + (max-min)*anims[id].val
        end

        --if wagon["_anim_old_"..id] == value then return wagon["_anim_old_"..id] end
        -- Generate sticky value
        if stickyness and damping then
            if math.abs(anims[id].P - value) < stickyness and anims[id].stuck then
                value = anims[id].P
                anims[id].stuck = false
            else
                anims[id].P = value
            end
        end

        local dT = FrameTime() --wagon.DeltaTime
        if damping == false then
            local dX = speed * dT
            if value > val then val = val + dX end
            if value < val then val = val - dX end
            if math.abs(value - val) < dX then
                val = value
                anims[id].V = 0
            else
                anims[id].V = dX
            end
        else
            -- Prepare speed limiting
            local delta = math.abs(value - val)
            local max_speed = 1.5 * delta / dT
            local max_accel = 0.5 / dT
            -- Simulate
            local dX2dT = (speed or 128) * (value - val) - anims[id].V * (damping or 8.0)
            if dX2dT > max_accel then dX2dT = max_accel end
            if dX2dT < -max_accel then dX2dT = -max_accel end
            anims[id].V = anims[id].V + dX2dT * dT
            if anims[id].V > max_speed then anims[id].V = max_speed end
            if anims[id].V < -max_speed then anims[id].V = -max_speed end
            val = math.max(0, math.min(1, val + anims[id].V * dT))
            -- Check if value got stuck
            if math.abs(dX2dT) < 0.001 and stickyness and dT > 0 then anims[id].stuck = true end
        end

        local retval = min + (max - min) * val
        if IsValid(wagon.ClientEnts[clientProp]) then wagon.ClientEnts[clientProp]:SetPoseParameter("position", retval) end
        if math.abs(anims[id].V) == 0 and math.abs(val - value) == 0 and not anims[id].stuck then anims[id].block = true end
        anims[id].val = val
        anims[id].oldival = value
        anims[id].oldspeed = speed
        anims[id].value = retval
        return retval
    end
end

function MEL.OverrideAnimate(ent, clientProp, min_or_callback, max, speed, damping, stickyness)
    local ent_class = MEL.GetEntclass(ent)
    if not MEL.AnimateOverrides[ent_class] then MEL.AnimateOverrides[ent_class] = {} end
    if isfunction(min_or_callback) then
        MEL.AnimateOverrides[ent_class][clientProp] = min_or_callback
        return
    end

    MEL.AnimateOverrides[ent_class][clientProp] = {min_or_callback, max, speed, damping, stickyness}
end

function MEL.OverrideAnimateValue(ent, clientProp, value_callback)
    local ent_class = MEL.GetEntclass(ent)
    if not MEL.AnimateValueOverrides[ent_class] then MEL.AnimateValueOverrides[ent_class] = {} end
    MEL.AnimateValueOverrides[ent_class][clientProp] = value_callback
end

function MEL.UpdateCallback(ent, clientprop_name, new_callback, field_name, error_on_nil)
    if CLIENT then
        if not ent.ClientProps[clientprop_name] then
            if error_on_nil then MEL._LogError(Format("no such clientprop with name %s", clientprop_name)) end
            return
        end

        local old_callback = ent.ClientProps[clientprop_name]["modelcallback"] or function() end
        ent.ClientProps[clientprop_name]["callback"] = function(wagon, cent)
            old_callback(wagon, cent)
            new_callback(wagon, cent)
        end

        if field_name then MEL.MarkClientPropForReload(ent, clientprop_name, field_name) end
    end
end

function MEL.DeleteClientProp(ent, clientprop_name, error_on_nil)
    if CLIENT then
        if not ent.ClientProps[clientprop_name] then
            if error_on_nil then MEL._LogError(Format("no such clientprop with name %s", clientprop_name)) end
            return
        end

        ent.ClientProps[clientprop_name] = nil
    end
end

function MEL.NewClientProp(ent, clientprop_name, clientprop_info, field_name, do_not_override)
    if CLIENT then
        if override and ent.ClientProps[clientprop_name] then
            MEL._LogError(Format("there is already clientprop with name %s! are you sure you want to override it?", clientprop_name))
            return
        end

        ent.ClientProps[clientprop_name] = clientprop_info
        if field_name then MEL.MarkClientPropForReload(ent, clientprop_name, field_name) end
    end
end

function MEL._OverrideShowHide(ent)
    if SERVER then return end
    function ent.ShowHide(wagon, clientProp, value, over)
        -- можно использовать аргумент over, но идея хуйня
        if MEL.ShowHideOverrides[MEL.GetEntclass(wagon)] and MEL.ShowHideOverrides[MEL.GetEntclass(wagon)][clientProp] then value = MEL.ShowHideOverrides[MEL.GetEntclass(wagon)][clientProp](wagon) end
        if wagon.Hidden.override[clientProp] then return end
        if value == true and (wagon.Hidden[clientProp] or over) then
            wagon.Hidden[clientProp] = false
            if not IsValid(wagon.ClientEnts[clientProp]) and wagon:SpawnCSEnt(clientProp) then wagon.UpdateRender = true end
            return true
        elseif value ~= true and (not wagon.Hidden[clientProp] or over) then
            if IsValid(wagon.ClientEnts[clientProp]) then
                wagon.ClientEnts[clientProp]:Remove()
                wagon.UpdateRender = true
            end

            wagon.Hidden[clientProp] = true
            return true
        end
    end
end

function MEL.OverrideShowHide(ent, clientprop_name, value_callback)
    local ent_class = MEL.GetEntclass(ent)
    if not MEL.ShowHideOverrides[ent_class] then MEL.ShowHideOverrides[ent_class] = {} end
    MEL.ShowHideOverrides[ent_class][clientprop_name] = value_callback
end

function MEL.CachedDecorator(ent_or_entclass, decorator_name, getter, precision)
    local ent_class = MEL.GetEntclass(ent_or_entclass)
    if not MEL.DecoratorCache[ent_class] then MEL.DecoratorCache[ent_class] = {} end
    if not MEL.DecoratorCache[ent_class][decorator_name] then MEL.DecoratorCache[ent_class][decorator_name] = {} end
    if not precision then precision = 2 end
    return function(value)
        local rounded_value = math.Round(value, precision)
        local cache = MEL.DecoratorCache[ent_class][decorator_name]
        if not cache[rounded_value] then cache[rounded_value] = getter(rounded_value) end
        return cache[rounded_value]
    end
end

function MEL._OverrideSetLightPower(ent)
    function ent.SetLightPower(wagon, index, power, brightness)
        if wagon.HiddenLamps[index] then return end
        local lightData = wagon.LightsOverride[index] or wagon.Lights[index]
        if not lightData then return end
        brightness = brightness or 1
        if lightData[1] == "glow" or lightData[1] == "light" then
            if lightData.panel and not wagon.SpritesEnabled or lightData.aa and wagon.AAEnabled then return end
            wagon.LightBrightness[index] = brightness * (lightData.brightness or 0.5)
            if power and wagon.Sprites[index] then return end
            wagon.Sprites[index] = nil
            if not power then return end
            wagon.Sprites[index] = util.GetPixelVisibleHandle()
            lightData.mat = Metrostroi.MakeSpriteTexture(lightData.texture or "sprites/light_glow02", lightData[1] == "light")
            return
        end

        if power and IsValid(wagon.GlowingLights[index]) then
            if lightData[1] == "headlight" and IsValid(wagon.GlowingLights[index]) then
                -- Check if light already glowing
                if brightness ~= wagon.LightBrightness[index] then
                    local light = wagon.GlowingLights[index]
                    light:SetBrightness(brightness * (lightData.brightness or 1.25))
                    light:Update()
                    wagon.LightBrightness[index] = brightness
                end
                return
            elseif lightData[1] == "glow" or lightData[1] == "light" then
                brightness = brightness * (lightData.brightness or 0.5)
                if brightness ~= wagon.LightBrightness[index] then
                    local light = wagon.GlowingLights[index]
                    light:SetBrightness(brightness)
                    wagon.LightBrightness[index] = brightness
                end
                return
            elseif lightData[1] == "dynamiclight" then
                if brightness ~= wagon.LightBrightness[index] then
                    local light = wagon.GlowingLights[index]
                    light:SetLightStrength(brightness)
                    wagon.LightBrightness[index] = brightness
                end
                return
            end
        end

        if IsValid(wagon.GlowingLights[index]) then wagon.GlowingLights[index]:Remove() end
        wagon.GlowingLights[index] = nil
        wagon.LightBrightness[index] = brightness
        if not power then return end
        -- Create light
        if lightData[1] == "light" or lightData[1] == "glow" then
            local light = ents.CreateClientside("gmod_train_sprite")
            light:SetPos(wagon:LocalToWorld(lightData[2]))
            --light:SetLocalAngles(lightData[3])
            -- Set parameters
            brightness = brightness * (lightData.brightness or 0.5)
            light:SetColor(lightData[4])
            light:SetBrightness(brightness)
            light:SetTexture((lightData.texture or "sprites/light_glow02") .. ".vmt", lightData[1] == "light")
            light:SetSize(lightData.scale or 1.0)
            light:Set3D(false)
            wagon.GlowingLights[index] = light
        elseif lightData[1] == "headlight" and (not lightData.backlight or wagon.RedLights) and (not lightData.panellight or wagon.OtherLights) then
            local light = ProjectedTexture()
            light:SetPos(wagon:LocalToWorld(lightData[2]))
            light:SetAngles(wagon:LocalToWorldAngles(lightData[3]))
            --light:SetParent(wagon)
            --light:SetLocalPos(lightData[2])
            --light:SetLocalAngles(lightData[3])
            -- Set parameters
            if lightData.headlight and wagon.HeadlightShadows or not lightData.headlight and wagon.OtherShadows then
                light:SetEnableShadows((lightData.shadows or 0) > 0)
            else
                light:SetEnableShadows(false)
            end

            if (lightData.shadows or 0) > 0 then
                light:SetFarZ(math.max(lightData.farz or 2048, 10))
            else
                light:SetFarZ(lightData.farz or 2048)
            end

            light:SetNearZ(lightData.nearz or 16)
            if lightData.fov then light:SetFOV(lightData.fov or 120) end
            if lightData.hfov then light:SetHorizontalFOV(lightData.hfov) end
            if lightData.vfov then light:SetVerticalFOV(lightData.vfov or 120) end
            light:SetOrthographic(false)
            -- Set Brightness
            light:SetBrightness(brightness * (lightData.brightness or 1.25))
            light:SetColor(lightData[4])
            light:SetTexture(lightData.texture or "effects/flashlight001")
            -- Turn light on
            light:Update() --"effects/flashlight/caustics"
            wagon.GlowingLights[index] = light
        elseif lightData[1] == "dynamiclight" then
            local light = ents.CreateClientside("gmod_train_dlight")
            light:SetParent(wagon)
            -- Set position
            light:SetLocalPos(lightData[2])
            --light:SetLocalAngles(lightData[3])
            -- Set parameters
            light:SetDColor(lightData[4])
            light:SetSize(lightData.distance)
            light:SetBrightness(lightData.brightness or 2)
            light:SetLightStrength(brightness)
            -- Turn light on
            light:Spawn()
            wagon.GlowingLights[index] = light
        end
    end
end
