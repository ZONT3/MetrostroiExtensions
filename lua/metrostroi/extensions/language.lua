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
-- нагло спизжено из дефолт мс)))))))))))))
function MEL.LoadLanguage(lang, force)
    if SERVER then return end
    if not Metrostroi.Languages[lang] then return end
    local ENTl = list.GetForEdit("SpawnableEntities")
    local SWEPl = list.GetForEdit("Weapon")
    Metrostroi.CurrentLanguageTable = Metrostroi.Languages[lang] or {}
    for id, phrase in pairs(Metrostroi.CurrentLanguageTable) do
        if id == "lang" then continue end
        if id:sub(1, 9) == "Entities." then
            local tbl = string.Explode(".", id:sub(10, -1))
            if tbl[1] == "Category" then
                local cat = tbl[2]
                continue
            end

            local class = tbl[1]
            local ENT = scripted_ents.GetStored(class)
            if not ENT then
                continue
            else
                ENT = ENT.t
            end

            if tbl[2] == "Name" then
                if not ENTl[class] then
                    if ENT.Spawner then ENT.Spawner.Name = phrase end
                    continue
                end

                ENTl[class].PrintName = phrase
            elseif tbl[2] == "Buttons" then
                if not ENT.ButtonMap[tbl[3]] then continue end
                local button
                for k, v in pairs(ENT.ButtonMap[tbl[3]].buttons) do
                    if v.ID == tbl[4] then
                        v.tooltip = phrase
                        button = v
                        break
                    end
                end
            elseif tbl[2] == "Spawner" then
                if not ENT.Spawner then continue end
                for i, v in pairs(ENT.Spawner) do
                    if type(v) == "function" then continue end
                    if v[1] == tbl[3] then
                        if tbl[4] == "Name" then
                            v[2] = phrase
                        elseif v[3] == "List" and v[4] then
                            local numb = tonumber(tbl[4])
                            if numb and type(v[4]) ~= "function" and v[4][numb] then v[4][numb] = phrase end
                        else
                        end
                    end
                end
            end
        elseif id:sub(1, 8) == "Weapons." then
            local tbl = string.Explode(".", id:sub(9, -1))
            local class = tbl[1]
            local SWEP = weapons.GetStored(class)
            if not SWEP then continue end
            if tbl[2] == "Name" then
                SWEP.PrintName = phrase
                SWEPl[class].PrintName = phrase
            elseif tbl[2] == "Purpose" then
                SWEP.Purpose = phrase
                --SWEPl[class].Purpose = phrase
            elseif tbl[2] == "Instructions" then
                SWEP.Instructions = phrase
                --SWEPl[class].Instructions = phrase
            end
        else
        end
    end

    if force or GetConVarNumber("metrostroi_language_softreload") ~= 1 then
        RunConsoleCommand("spawnmenu_reload")
        hook.Run("GameContentChanged")
    end
end