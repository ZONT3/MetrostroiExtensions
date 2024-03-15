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
MEL.DefineRecipe("salon_lamp_types", "717_714_mvm")
RECIPE.Description = "This recipe adds ability to customize salon lamp types."
local MODELS_ROOT = "models/metrostroi_train/81-717/"
local MAX_GLOW_COUNT = 48
--TODO: lamp enable/disable, color variation
function RECIPE:Init()
    -- Я не стал трогать дефолт рандомы, так что снизу говнокод, предупреждаю)
    self.Specific.SalonLampList = {
        {
            name = "Spawner.717.SalonLampType.Type1",
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
                        g = math.random() * 15
                        table.insert(colors, Vector(240 + g, 240 + g, 255))
                    else
                        b = -5 + math.random() * 20
                        table.insert(colors, Vector(255, 255, 235 + b))
                    end
                end
                return colors
            end,
            emergency_Ip = 3.6
        },
        {
            name = "Spawner.717.SalonLampType.Type2",
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
    local fields = {"Spawner.717.Common.Random"}
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
        modelcallback = function(wagon)
            local lamp_data = MEL.RecipeSpecific.SalonLampList[wagon:GetNW2Int("SalonLampType", 1)]
            if string.find(wagon:GetClass(), "717") then
                return lamp_data.head.model
            else
                return lamp_data.int.model
            end
        end
    }, "SalonLampType")

    for i = 1, MAX_GLOW_COUNT do
        MEL.NewClientProp(ent, "salon_lamps_glow" .. i, {
            model = MODELS_ROOT .. "lamps/lamp_typ1.mdl",
            pos = Vector(0, 0, 0),
            ang = Angle(0, 0, 0),
            hideseat = 1.1,
            modelcallback = function(wagon)
                local lamp_data = MEL.RecipeSpecific.SalonLampList[wagon:GetNW2Int("SalonLampType", 1)]
                if string.find(wagon:GetClass(), "717") then
                    return lamp_data.head.glow.model
                else
                    return lamp_data.int.glow.model
                end
            end,
            callback = function(wagon, cent)
                local lamp_data = MEL.RecipeSpecific.SalonLampList[wagon:GetNW2Int("SalonLampType", 1)]
                if string.find(wagon:GetClass(), "717") then
                    if i > lamp_data.head.glow.count then
                        cent:SetNoDraw(true)
                        return
                    end

                    if lamp_data.head.glow.callback then lamp_data.head.glow.callback(wagon, cent, i) end
                else
                    if i > lamp_data.int.glow.count then
                        cent:SetNoDraw(true)
                        return
                    end

                    if lamp_data.int.glow.callback then lamp_data.int.glow.callback(wagon, cent, i) end
                end
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
        local colors = {}
        if lamp_data.random_color then colors = lamp_data.random_color(lamp_amount) end
        for i = 1, lamp_amount do
            wagon:SetNW2Vector("salon_lamp_color" .. i, colors[i] or Vector(255, 255, 255))
            wagon.SalonLamps.broken[i] = math.random() > rand and math.random() > 0.7
        end
    end

    MEL.InjectIntoServerFunction(ent, "Think", function(wagon)
        local lamp_data = MEL.RecipeSpecific.SalonLampList[wagon:GetNW2Int("SalonLampType", 1)]
        local lamp_amount = lamp_data.int.glow.count
        if string.find(wagon:GetClass(), "717") then lamp_amount = lamp_data.head.glow.count end
        local lightsActive1 = wagon.Panel.EmergencyLights > 0
        local lightsActive2 = wagon.Panel.MainLights > 0.0
        local mul = 0
        local Ip = lamp_data.emergency_Ip
        if not wagon.SalonLamps then
            wagon.SalonLamps = {
                broken = {}
            }
        end

        for i = 1, lamp_amount do
            if lightsActive2 or (lightsActive1 and math.ceil((i + Ip) % Ip) == 1) then
                if not wagon.SalonLamps[i] and not wagon.SalonLamps.broken[i] then wagon.SalonLamps[i] = CurTime() + math.Rand(0.1, math.Rand(0.5, 2)) end
            else
                wagon.SalonLamps[i] = nil
            end

            if wagon.SalonLamps[i] and CurTime() - wagon.SalonLamps[i] > 0 then
                mul = mul + 1
                wagon:SetPackedBool("salon_lamp_enabled" .. i, true)
            else
                wagon:SetPackedBool("salon_lamp_enabled" .. i, false)
            end
        end

        wagon:SetLightPower(11, mul > 0, mul / lamp_amount)
        wagon:SetLightPower(12, mul > 0, mul / lamp_amount)
        wagon:SetLightPower(13, mul > 0, mul / lamp_amount)
    end)

    MEL.InjectIntoClientFunction(ent, "Think", function(wagon)
        local lamp_data = MEL.RecipeSpecific.SalonLampList[wagon:GetNW2Int("SalonLampType", 1)]
        local lamp_amount = lamp_data.int.glow.count
        if string.find(wagon:GetClass(), "717") then lamp_amount = lamp_data.head.glow.count end
        for i = 1, lamp_amount do
            local colV = wagon:GetNW2Vector("salon_lamp_color" .. i)
            local col = Color(colV.x, colV.y, colV.z)
            wagon:ShowHideSmooth("salon_lamps_glow" .. i, wagon:Animate("Salon_lamps_glow" .. i, wagon:GetPackedBool("salon_lamp_enabled" .. i) and 1 or 0, 0, 1, 6, false), col)
        end
    end)
end