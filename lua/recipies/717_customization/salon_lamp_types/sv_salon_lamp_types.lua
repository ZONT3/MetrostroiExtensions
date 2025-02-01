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
local COLOR_WHITE = Vector(255, 255, 255)

function RECIPE:Inject(ent)
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
end
