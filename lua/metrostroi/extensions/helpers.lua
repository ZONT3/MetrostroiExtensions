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


MEL.SpawnerByFields = {}  -- lookup table for accessing spawner fields by name and list elements by default, non-translated name

local SpawnerC = MEL.Constants.Spawner

local function populateSpawnerByFields()
    for _, train_class in pairs(MEL.TrainClasses) do
        local ent_table = MEL.EntTables[train_class]
        if not ent_table.Spawner then continue end
        MEL.SpawnerByFields[train_class] = {}
        for field_i, field in pairs(ent_table.Spawner) do
            if istable(field) and isstring(field[SpawnerC.NAME]) then
                local field_name = field[SpawnerC.NAME]
                if MEL.SpawnerByFields[train_class][field_name] then continue end
                MEL.SpawnerByFields[train_class][field_name] = {index = field_i, list_elements = {}}
                if field[SpawnerC.TYPE] == SpawnerC.TYPE_LIST and istable(field[SpawnerC.List.ELEMENTS]) then
                    for list_i, name in pairs(field[SpawnerC.List.ELEMENTS]) do
                        MEL.SpawnerByFields[train_class][field_name].list_elements[name] = list_i
                    end
                end
            end
        end
    end
end

function MEL._LoadHelpers()
    populateSpawnerByFields()
end