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
MEL.DefineRecipe("salon_lamp_types", "717_714")
RECIPE.Description = "This recipe adds ability to customize salon lamp types."
local MODELS_ROOT = "models/metrostroi_train/81-717/"
local MAX_GLOW_COUNT = 48
local COLOR_WHITE = Vector(255, 255, 255)
local logError = MEL.LogErrorFactory()
local function getLampData(wagon)
    local lamp_data = MEL.RecipeSpecific.SalonLampList[wagon:GetNW2Int("SalonLampType", 1)]
    if MEL.Helpers.Is717(wagon:GetClass()) then
        return lamp_data.head
    else
        return lamp_data.int
    end
end

local function getGlowData(wagon)
    return getLampData(wagon).glow
end

function RECIPE:Init()
    -- Я не стал трогать дефолт рандомы, так что снизу говнокод, предупреждаю)
    self.Specific.SalonLampList = {
        {
            name = "Type1",
            head = {
                model = MODELS_ROOT .. "lamps_type1.mdl",
                glow = {
                    model = MODELS_ROOT .. "lamps/lamp_typ1.mdl",
                    count = 12,
                    callback = function(wagon, cent, i) cent:SetPos(wagon:LocalToWorld(Vector(333.949 - 66.66 * (i - 1), 0, 67.7))) end
                }
            },
            int = {
                model = MODELS_ROOT .. "lamps_type1_int.mdl",
                glow = {
                    model = MODELS_ROOT .. "lamps/lamp_typ1.mdl",
                    count = 13,
                    callback = function(wagon, cent, i) cent:SetPos(wagon:LocalToWorld(Vector(394.5 - 66.65 * (i - 1), 0, 67.608))) end
                }
            },
            random_color = function(lamp_amount)
                local colors = {}
                local typ = math.Round(math.random())
                local rnd = 0.5 + math.random() * 0.5
                for i = 1, lamp_amount do
                    local chtp = math.random() > rnd
                    if typ == 0 and not chtp or typ == 1 and chtp then
                        local g = math.random() * 15
                        table.insert(colors, Vector(240 + g, 240 + g, 255))
                    else
                        local b = -5 + math.random() * 20
                        table.insert(colors, Vector(255, 255, 235 + b))
                    end
                end
                return colors
            end,
            emergency_Ip = 3.6
        },
        {
            name = "Type2",
            head = {
                model = MODELS_ROOT .. "lamps_type2.mdl",
                glow = {
                    model = MODELS_ROOT .. "lamps/lamp_typ2.mdl",
                    count = 25,
                    callback = function(wagon, cent, i) cent:SetPos(wagon:LocalToWorld(Vector(354.1 - 32.832 * (i - 1), 0, 68.2))) end
                }
            },
            int = {
                model = MODELS_ROOT .. "lamps_type2_interim.mdl",
                glow = {
                    model = MODELS_ROOT .. "lamps/lamp_typ2.mdl",
                    count = 27,
                    callback = function(wagon, cent, i) cent:SetPos(wagon:LocalToWorld(Vector(354.1 - 32.832 * (i - 3), 0, 68.2))) end
                }
            },
            random_color = function(lamp_amount)
                local colors = {}
                local rnd1, rnd2 = 0.7 + math.random() * 0.3, math.random()
                local typ = math.Round(math.random())
                for i = 1, lamp_amount do
                    local chtp = math.random() > rnd1
                    local r, g, b = 0, 0, 0
                    if typ == 0 and not chtp or typ == 1 and chtp then
                        if math.random() > rnd2 then
                            r = -20 + math.random() * 25
                            g = 0
                        else
                            g = -5 + math.random() * 15
                            r = g
                        end

                        table.insert(colors, Vector(245 + r, 228 + g, 189))
                    else
                        if math.random() > rnd2 then
                            g = math.random() * 15
                            b = g
                        else
                            g = 15
                            b = -10 + math.random() * 25
                        end

                        table.insert(colors, Vector(255, 235 + g, 235 + b))
                    end
                end
                return colors
            end,
            emergency_Ip = 7
        },
    }
end

function RECIPE:InjectSpawner(entclass)
    local fields = {"Random"}
    for key, value in pairs(MEL.RecipeSpecific.SalonLampList) do
        table.insert(fields, value.name)
    end

    -- actually adding a new field and removing old one - random is hardcoded... again......
    MEL.AddSpawnerField(entclass, {
        [1] = "SalonLampType",
        [2] = "Spawner.717.SalonLampType",
        [3] = "List",
        [4] = fields
    }, true)

    MEL.RemoveSpawnerField(entclass, "LampType")
end

function RECIPE:Inject(ent, entclass)
    -- remove default lamps
    MEL.DeleteClientProp(ent, "lamps1")
    MEL.DeleteClientProp(ent, "lamps2")
    MEL.DeleteClientProp(ent, "lamps")
    for i = 0, 26 do
        MEL.DeleteClientProp(ent, "lamp1_" .. i + 1)
        MEL.DeleteClientProp(ent, "lamp2_" .. i + 1)
    end

    -- add new clientprops
    MEL.NewClientProp(ent, "salon_lamps_base", {
        model = MODELS_ROOT .. "lamps_type1.mdl",
        pos = Vector(0, 0, 0),
        ang = Angle(0, 0, 0),
        hide = 1.5,
        modelcallback = function(wagon) return getLampData(wagon).model end,
        callback = function(wagon, cent)
            local lamp_data = getLampData(wagon)
            if lamp_data.callback then lamp_data.callback(wagon, cent) end
        end
    }, "SalonLampType")

    for i = 1, MAX_GLOW_COUNT do
        -- first two glows always used (first one is emergency lighting, second one is main lighting)
        MEL.NewClientProp(ent, "salon_lamps_glow" .. i, {
            model = MODELS_ROOT .. "lamps/lamp_typ1.mdl",
            pos = Vector(0, 0, 0),
            ang = Angle(0, 0, 0),
            hideseat = 1.1,
            modelcallback = function(wagon)
                local glow_data = getGlowData(wagon)
                if glow_data.count == 1 and i == 1 then return glow_data.model_emergency end
                return glow_data.model
            end,
            callback = function(wagon, cent)
                local glow_data = getGlowData(wagon)
                if i > 2 and i > glow_data.count then
                    cent:SetNoDraw(true)
                    return
                end

                if glow_data.callback then glow_data.callback(wagon, cent, i) end
            end
        }, "SalonLampType")
    end

    ent.UpdateLampsColors = function(wagon)
        local lamp_data = MEL.RecipeSpecific.SalonLampList[wagon:GetNW2Int("SalonLampType", 1)]
        local lamp_amount = lamp_data.int.glow.count
        if string.find(wagon:GetClass(), "717") then lamp_amount = lamp_data.head.glow.count end
        if not wagon.SalonLamps then
            wagon.SalonLamps = {
                broken = {}
            }
        end

        local rand = math.random() > 0.8 and 1 or math.random(0.95, 0.99)
        local colors = {COLOR_WHITE}
        if lamp_data.random_color then colors = lamp_data.random_color(lamp_amount) end
        local mean_color_sum, mean_count, mean_current_lamp_id = Vector(), 0, 11
        for i = 1, lamp_amount do
            local color = colors[i] or COLOR_WHITE
            wagon:SetNW2Vector("SalonLampColor" .. i, color)
            wagon.SalonLamps.broken[i] = math.random() > rand and math.random() > 0.7
            if not lamp_data.light_color then
                mean_color_sum = mean_color_sum + color
                mean_count = mean_count + 1
                if i % (lamp_amount / 3) < 1 then
                    if mean_current_lamp_id > 13 then
                        logError("mean_current_lamp_id is more, than available lamps. Please report this error. Lamp name: " .. lamp_data.name .. ", lamp model id: " .. i)
                        return
                    end

                    local mean_color = (mean_color_sum / mean_count) / 255
                    wagon:SetNW2Vector("lampD" .. mean_current_lamp_id, Vector(mean_color.r, mean_color.g ^ 3, mean_color.b ^ 3) * 255)
                    mean_color_sum, mean_count = Vector(), 0
                    mean_current_lamp_id = mean_current_lamp_id + 1
                end
            end
        end

        if lamp_data.light_color then
            local light_color = lamp_data.light_color
            for i = 11, 13 do
                wagon:SetNW2Vector("lampD" .. i, Vector(light_color.r, light_color.g, light_color.b))
            end
            return
        end

        -- 13 + 1 cause we do +1 in last iteration while counting mean color, if everything goes normally
        if mean_current_lamp_id ~= 13 + 1 then
            -- if we didn't changed colors on all lights, than just do it manually (but get a mean from ALL colors)
            mean_color_sum = Vector()
            for _, color in pairs(colors) do
                mean_color_sum = mean_color_sum + (color or COLOR_WHITE)
            end

            local mean_color = (mean_color_sum / #colors) / 255
            for i = 11, 13 do
                wagon:SetNW2Vector("lampD" .. i, Vector(mean_color.r, mean_color.g ^ 3, mean_color.b ^ 3) * 255)
            end
        end
    end

    MEL.InjectIntoServerFunction(ent, "Think", function(wagon)
        local lamp_data = MEL.RecipeSpecific.SalonLampList[wagon:GetNW2Int("SalonLampType", 1)]
        local lamp_amount = lamp_data.int.glow.count
        if string.find(wagon:GetClass(), "717") then lamp_amount = lamp_data.head.glow.count end
        local emergencyLights = wagon.Panel.EmergencyLights > 0
        local mainLights = wagon.Panel.MainLights > 0.0
        wagon:SetPackedBool("EmergencyLights", emergencyLights)
        wagon:SetPackedBool("MainLights", mainLights)
        if lamp_amount == 1 then return end
        local Ip = lamp_data.emergency_Ip or 1
        if not wagon.SalonLamps then
            wagon.SalonLamps = {
                broken = {}
            }
        end

        for i = 1, lamp_amount do
            if mainLights or emergencyLights and math.ceil((i + Ip) % Ip) == 1 then
                if not wagon.SalonLamps[i] and not wagon.SalonLamps.broken[i] then wagon.SalonLamps[i] = CurTime() + math.Rand(0.1, math.Rand(0.5, 2)) end
            else
                wagon.SalonLamps[i] = nil
            end

            if wagon.SalonLamps[i] and CurTime() - wagon.SalonLamps[i] > 0 then
                wagon:SetPackedBool("SalonLampEnabled" .. i, true)
            else
                wagon:SetPackedBool("SalonLampEnabled" .. i, false)
            end
        end
    end)

    MEL.InjectIntoClientFunction(ent, "Think", function(wagon)
        local lamp_data = getLampData(wagon)
        local glow_data = lamp_data.glow
        if glow_data.count == 1 then
            local emergencyLights = wagon:GetPackedBool("EmergencyLights")
            local mainLights = wagon:GetPackedBool("MainLights")
            wagon:ShowHide("salon_lamps_glow1", emergencyLights and not mainLights)
            wagon:ShowHide("salon_lamps_glow2", mainLights)
        else
            for i = 1, glow_data.count do
                local color_vector = wagon:GetNW2Vector("SalonLampColor" .. i)
                local color = Color(color_vector.x, color_vector.y, color_vector.z)
                local state = wagon:Animate("SalonLamp" .. i, wagon:GetPackedBool("SalonLampEnabled" .. i) and 1 or 0, 0, 1, 6, false)
                wagon:ShowHideSmooth("salon_lamps_glow" .. i, state, color)
            end
        end
        -- for i = 11, 13 do
        --     local color_vector = wagon:GetNW2Vector("SalonLampLightColor" .. i)
        --     if wagon.LightsOverride[i].vec_ext ~= color_vector then
        --         wagon.LightsOverride[i].vec_ext = color_vector
        --         wagon.LightsOverride[i][4] = Color(color_vector.x, color_vector.y, color_vector.z)
        --         wagon:SetLightPower(i, false)
        --     else
        --         wagon:SetLightPower(i, active_lights > 0, active_lights / glow_data.count)
        --     end
        -- end
    end, 1)
end
