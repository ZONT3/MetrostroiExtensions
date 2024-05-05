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
MEL.DefineRecipe("717_lights", "gmod_subway_81-717_mvm")
RECIPE.BackportPriority = true

local newLights = {
    [8] = {
        "light",
        Vector(460, -45, 52),
        Angle(0, 0, 0),
        Color(255, 50, 50),
        brightness = 0.2,
        scale = 2.5,
        texture = "sprites/light_glow02",
        size = 2
    },
    [9] = {
        "light",
        Vector(460, 45, 52),
        Angle(0, 0, 0),
        Color(255, 50, 50),
        brightness = 0.2,
        scale = 2.5,
        texture = "sprites/light_glow02",
        size = 2
    },
    -- Cabin
    [10] = {
        "dynamiclight",
        Vector(425, 0, 30),
        Angle(0, 0, 0),
        Color(216, 161, 92),
        distance = 550,
        brightness = 0.25,
        hidden = "salon"
    },
    -- Interior
    [11] = {
        "dynamiclight",
        Vector(200, 0, -0),
        Angle(0, 0, 0),
        Color(255, 245, 245),
        brightness = 3,
        distance = 400,
        fov = 180,
        farz = 128,
        changable = true
    },
    [12] = {
        "dynamiclight",
        Vector(0, 0, -0),
        Angle(0, 0, 0),
        Color(255, 245, 245),
        brightness = 3,
        distance = 400,
        fov = 180,
        farz = 128,
        changable = true
    },
    [13] = {
        "dynamiclight",
        Vector(-200, 0, -0),
        Angle(0, 0, 0),
        Color(255, 245, 245),
        brightness = 3,
        distance = 400,
        fov = 180,
        farz = 128,
        changable = true
    },
    -- Side lights
    [15] = {
        "light",
        Vector(-52, 67, 45.5) + Vector(0, 0.9, 3.25),
        Angle(0, 0, 0),
        Color(254, 254, 254),
        brightness = 0.1,
        scale = 0.2,
        texture = "sprites/light_glow02",
        size = 1.5
    },
    [16] = {
        "light",
        Vector(-52, 67, 45.5) + Vector(0, 0.9, -0.02),
        Angle(0, 0, 0),
        Color(40, 240, 122),
        brightness = 0.1,
        scale = 0.2,
        texture = "sprites/light_glow02",
        size = 1.5
    },
    [17] = {
        "light",
        Vector(-52, 67, 45.5) + Vector(0, 0.9, -3.3),
        Angle(0, 0, 0),
        Color(254, 210, 18),
        brightness = 0.1,
        scale = 0.2,
        texture = "sprites/light_glow02",
        size = 1.5
    },
    [18] = {
        "light",
        Vector(39, -67, 45.5) + Vector(0, -0.9, 3.25),
        Angle(0, 0, 0),
        Color(254, 254, 254),
        brightness = 0.1,
        scale = 0.2,
        texture = "sprites/light_glow02",
        size = 1.5
    },
    [19] = {
        "light",
        Vector(39, -67, 45.5) + Vector(0, -0.9, -0.02),
        Angle(0, 0, 0),
        Color(40, 240, 122),
        brightness = 0.1,
        scale = 0.2,
        texture = "sprites/light_glow02",
        size = 1.5
    },
    [20] = {
        "light",
        Vector(39, -67, 45.5) + Vector(0, -0.9, -3.3),
        Angle(0, 0, 0),
        Color(254, 210, 18),
        brightness = 0.1,
        scale = 0.2,
        texture = "sprites/light_glow02",
        size = 1.5
    },
    [21] = {
        "light",
        Vector(0, 67, 53.5) + Vector(3.25, 0.9, -0.02),
        Angle(0, 0, 0),
        Color(254, 254, 254),
        brightness = 0.1,
        scale = 0.2,
        texture = "sprites/light_glow02",
        size = 1.5
    },
    [22] = {
        "light",
        Vector(0, 67, 53.5) + Vector(-0.06, 0.9, -0.02),
        Angle(0, 0, 0),
        Color(40, 240, 122),
        brightness = 0.1,
        scale = 0.2,
        texture = "sprites/light_glow02",
        size = 1.5
    },
    [23] = {
        "light",
        Vector(0, 67, 53.5) + Vector(-3.33, 0.9, -0.02),
        Angle(0, 0, 0),
        Color(254, 210, 18),
        brightness = 0.1,
        scale = 0.2,
        texture = "sprites/light_glow02",
        size = 1.5
    },
    [24] = {
        "light",
        Vector(0, -67, 53.5) + Vector(3.33, -0.9, -0.02),
        Angle(0, 0, 0),
        Color(254, 254, 254),
        brightness = 0.1,
        scale = 0.2,
        texture = "sprites/light_glow02",
        size = 1.5
    },
    [25] = {
        "light",
        Vector(0, -67, 53.5) + Vector(0.06, -0.9, -0.02),
        Angle(0, 0, 0),
        Color(40, 240, 122),
        brightness = 0.1,
        scale = 0.2,
        texture = "sprites/light_glow02",
        size = 1.5
    },
    [26] = {
        "light",
        Vector(0, -67, 53.5) + Vector(-3.28, -0.9, -0.02),
        Angle(0, 0, 0),
        Color(254, 210, 18),
        brightness = 0.1,
        scale = 0.2,
        texture = "sprites/light_glow02",
        size = 1.5
    },
    [30] = {
        "light",
        Vector(455, -45, -23.5),
        Angle(0, 0, 0),
        Color(255, 220, 180),
        brightness = 0.2,
        scale = 2.5,
        texture = "sprites/light_glow02",
        changable = true,
        size = 2
    },
    [31] = {
        "light",
        Vector(455, 45, -23.5),
        Angle(0, 0, 0),
        Color(255, 220, 180),
        brightness = 0.2,
        scale = 2.5,
        texture = "sprites/light_glow02",
        changable = true,
        size = 2
    },
    [32] = {
        "light",
        Vector(455, 0, 52),
        Angle(0, 0, 0),
        Color(255, 220, 180),
        brightness = 0.2,
        scale = 2.5,
        texture = "sprites/light_glow02",
        changable = true,
        size = 2
    },
    Lamp_RTM1 = {
        "light",
        Vector(414.367554, -32.449749, 6.717192),
        Angle(0, 0, 0),
        Color(255, 180, 60),
        brightness = 0.4,
        scale = 0.03,
        texture = "sprites/light_glow02",
        hidden = "Lamp_RTM1"
    },
    Lamp_RTM2 = {
        "light",
        Vector(447.35, -32.82, -0.90),
        Angle(0, 0, 0),
        Color(255, 180, 60),
        brightness = 0.4,
        scale = 0.03,
        texture = "sprites/light_glow02",
        hidden = "Lamp_RTM2"
    },
    Lamps_cab1 = {
        "light",
        Vector(396.5, 14.8, 53),
        Angle(0, 0, 0),
        Color(255, 220, 180),
        brightness = 0.25,
        scale = 0.2,
        texture = "sprites/light_glow02",
        hidden = "Lamps_cab1"
    },
    Lamps_cab2 = {
        "light",
        Vector(428, -1.5, 60),
        Angle(0, 0, 0),
        Color(255, 220, 180),
        brightness = 0.35,
        scale = 0.25,
        texture = "sprites/light_glow02",
        hidden = "Lamps_cab2"
    },
    Lamps2_cab1 = {
        "light",
        Vector(396.5, 14.8, 52.5),
        Angle(0, 0, 0),
        Color(255, 220, 180),
        brightness = 0.25,
        scale = 0.2,
        texture = "sprites/light_glow02",
        hidden = "Lamps2_cab1"
    },
    Lamps2_cab2 = {
        "light",
        Vector(428, -1.3, 59.2),
        Angle(0, 0, 0),
        Color(255, 220, 180),
        brightness = 0.35,
        scale = 0.25,
        texture = "sprites/light_glow02",
        hidden = "Lamps2_cab2"
    },
}

function RECIPE:Inject(ent)
    if CLIENT then
        local lights = ent.Lights
        lights[3].hidden = "salon"
        lights[4].hidden = "salon"
        lights[40].farz = 7
        lights[40].hidden = "pult_mvm_classic"
        lights[41].farz = 7
        lights[41].hidden = "pult_mvm_classic"
        lights[42].farz = 7
        lights[42].hidden = "pult_mvm_classic"
        lights[43].farz = 7
        lights[43].hidden = "pult_mvm_classic"
        lights[44].farz = 5.05
        lights[44].hidden = "pult_mvm_classic"
        lights[45].farz = 5.05
        lights[45].hidden = "pult_mvm_classic"
        for id, light in pairs(newLights) do
            ent.Lights[id] = light
        end
    end
end

function RECIPE:InjectNeeded()
    if Metrostroi.Version > 1537278077 then return false end
    return true
end