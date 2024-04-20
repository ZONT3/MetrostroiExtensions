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
local LanguageIDC = MEL.Constants.LanguageID
local SpawnerC = MEL.Constants.Spawner
local function handle_buttons(id_parts, phrase, enttable)
end

local function handle_spawner(id_parts, id, phrase, ent_table, ent_class)
    if not ent_table.Spawner then return end
    local field_lookup = MEL.SpawnerByFields[ent_class][id_parts[LanguageIDC.Spawner.NAME]]
    if not field_lookup then return end
    local field_index = field_lookup.index
    local field = ent_table.Spawner[field_index]
    local field_value = id_parts[LanguageIDC.Spawner.VALUE]
    if field_value == LanguageIDC.Spawner.VALUE_NAME then
        field[SpawnerC.TRANSLATION] = phrase
    elseif field[SpawnerC.TYPE] == SpawnerC.TYPE_LIST and istable(field[SpawnerC.List.ELEMENTS]) and field_lookup.list_elements[field_value] then
        field[SpawnerC.List.ELEMENTS][field_lookup.list_elements[field_value]] = Metrostroi.GetPhrase(id)
    end
end

local ENTITY_HANDLERS = {
    ["Buttons"] = handle_buttons,
    ["Spawner"] = handle_spawner
}

function MEL.UpdateLanguages(lang)
    if SERVER then return end

    local choosed_lang = lang or Metrostroi.ChoosedLang
    if not Metrostroi or not Metrostroi.Languages or not Metrostroi.Languages[choosed_lang] then return end
    for id, phrase in pairs(Metrostroi.CurrentLanguageTable) do
        if id == "lang" then continue end
        if string.StartsWith(id, LanguageIDC.Entity.PREFIX) then
            local id_parts = string.Explode(".", id:sub(#LanguageIDC.Entity.PREFIX + 1, -1))
            if id_parts[LanguageIDC.Entity.CLASS] == "Category" then continue end
            local ent_class = id_parts[LanguageIDC.Entity.CLASS]
            local ent_table = MEL.EntTables[ent_class]
            local handler = ENTITY_HANDLERS[id_parts[LanguageIDC.Entity.TYPE]]
            if handler then handler(id_parts, id, phrase, ent_table, ent_class) end
        end
    end
end

cvars.AddChangeCallback("metrostroi_language", function(cvar, old, value) MEL.UpdateLanguages(value) end, "ext_language")