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
local ID_ENTITY_CLASS_INDEX = 1
local ID_ENTITY_TYPE_INDEX = 2
local ID_ENTITY_PREFIX = "Entities."
local function handle_buttons(id_parts, phrase, enttable)
end

-- todo: может вынести эти константы как общие для всего?
local ID_SPAWNER_FIELDNAME_INDEX = 3
local ID_SPAWNER_FIELDVALUE_INDEX = 4
local ID_SPAWNER_FIELDVALUE_NAME = "Name"
-- local ENTITY_SPAWNER_FIELDNAME_INDEX = 1
local ENTITY_SPAWNER_FIELDTRANSLATION_INDEX = 2
local ENTITY_SPAWNER_FIELDTYPE_INDEX = 3
local ENTITY_SPAWNER_FIELDTYPE_LIST = "List"
local ENTITY_SPAWNER_LISTELEMENTS_INDEX = 4
local function handle_spawner(id_parts, phrase, ent_table, ent_class)
    if not ent_table.Spawner then return end
    local field_index = MEL.SpawnerByFields[ent_class][id_parts[ID_SPAWNER_FIELDNAME_INDEX]]
    if not field_index then return end
    local field = ent_table.Spawner[field_index]
    local field_value = id_parts[ID_SPAWNER_FIELDVALUE_INDEX]
    if field_value == ID_SPAWNER_FIELDVALUE_NAME then
        field[ENTITY_SPAWNER_FIELDTRANSLATION_INDEX] = phrase
    elseif field[ENTITY_SPAWNER_FIELDTYPE_INDEX] == ENTITY_SPAWNER_FIELDTYPE_LIST and istable(field[ENTITY_SPAWNER_LISTELEMENTS_INDEX]) then
        for i, list_elem in pairs(field[ENTITY_SPAWNER_LISTELEMENTS_INDEX]) do
            if list_elem == field_value then
                field[ENTITY_SPAWNER_LISTELEMENTS_INDEX][i] = phrase
             end
        end
    end
end

local ENTITY_HANDLERS = {
    ["Buttons"] = handle_buttons,
    ["Spawner"] = handle_spawner
}

function MEL.UpdateLanguages(lang)
    local lang = lang or Metrostroi.ChoosedLang
    if not Metrostroi or not Metrostroi.Languages or not Metrostroi.Languages[lang] then return end
    Metrostroi.CurrentLanguageTable = Metrostroi.Languages[lang] or {}
    for id, phrase in pairs(Metrostroi.CurrentLanguageTable) do
        if id == "lang" then continue end
        if string.StartsWith(id, ID_ENTITY_PREFIX) then
            local id_parts = string.Explode(".", id:sub(#ID_ENTITY_PREFIX + 1, -1))
            if id_parts[ID_ENTITY_CLASS_INDEX] == "Category" then continue end
            local ent_class = id_parts[ID_ENTITY_CLASS_INDEX]
            local ent_table = MEL.EntTables[ent_class]
            local handler = ENTITY_HANDLERS[id_parts[ID_ENTITY_TYPE_INDEX]]
            if handler then handler(id_parts, phrase, ent_table, ent_class) end
        end
    end
end

cvars.AddChangeCallback("metrostroi_language", function(cvar, old, value)
    MEL.UpdateLanguages(value)
end, "ext_language")
--     if id:sub(1, 9) == "Entities." then
--         local tbl = string.Explode(".", id:sub(10, -1))
--         if tbl[1] == "Category" then
--             continue
--         end
--         local class = tbl[1]
--         local ENT = scripted_ents.GetStored(class)
--         if not ENT then
--             continue
--         else
--             ENT = ENT.t
--         end
--         if tbl[2] == "Name" then
--             if not ENTl[class] then
--                 if ENT.Spawner then ENT.Spawner.Name = phrase end
--                 continue
--             end
--             ENTl[class].PrintName = phrase
--         elseif tbl[2] == "Buttons" then
--             if not ENT.ButtonMap[tbl[3]] then continue end
--             for k, v in pairs(ENT.ButtonMap[tbl[3]].buttons) do
--                 if v.ID == tbl[4] then
--                     v.tooltip = phrase
--                     button = v
--                     break
--                 end
--             end
--         elseif tbl[2] == "Spawner" then
--             if not ENT.Spawner then continue end
--             for i, v in pairs(ENT.Spawner) do
--                 if type(v) == "function" then continue end
--                 if v[1] == tbl[3] then
--                     if tbl[4] == "Name" then
--                         v[2] = phrase
--                     elseif v[3] == "List" and v[4] then
--                         if isnumber(v[4]) then
--                             local numb = tonumber(tbl[4])
--                             if numb and type(v[4]) ~= "function" and v[4][numb] then v[4][numb] = phrase end
--                         elseif istable(v[4]) then
--                             for i, field in pairs(v[4]) do
--                                 local field_name = string.Explode(".", field)
--                                 print(field_name[#field_name])
--                             end
--                         end
--                     else
--                     end
--                 end
--             end
--         end
--     elseif id:sub(1, 8) == "Weapons." then
--         local tbl = string.Explode(".", id:sub(9, -1))
--         local class = tbl[1]
--         local SWEP = weapons.GetStored(class)
--         if not SWEP then continue end
--         if tbl[2] == "Name" then
--             SWEP.PrintName = phrase
--             SWEPl[class].PrintName = phrase
--         elseif tbl[2] == "Purpose" then
--             SWEP.Purpose = phrase
--         elseif tbl[2] == "Instructions" then
--             SWEP.Instructions = phrase
--         end
--     end
-- end
-- if force or GetConVarNumber("metrostroi_language_softreload") ~= 1 then
--     RunConsoleCommand("spawnmenu_reload")
--     hook.Run("GameContentChanged")
-- end