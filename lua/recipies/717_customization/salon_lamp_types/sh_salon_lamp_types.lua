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

MEL.DefineRecipe("salon_lamp_types", "717_714")
local MODELS_ROOT = "models/metrostroi_train/81-717/"
function RECIPE:Init()
    -- Я не стал трогать дефолт рандомы, так что снизу говнокод, предупреждаю)
    self.Specific.SalonLampList = {
        {
            name = "Type1",
            base_needed = true,
            head = {
                model = MODELS_ROOT .. "lamps_type1.mdl",
                glow = {
                    model = MODELS_ROOT .. "lamps/lamp_typ1.mdl",
                    count = 12,
                    callback = function(wagon, cent, i) cent:SetPos(wagon:LocalToWorld(Vector(333.949 - 66.66 * (i - 1), 0, 67.7))) end
                },
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
            base_needed = true,
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
