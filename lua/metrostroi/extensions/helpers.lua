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


MEL.SpawnerByFields = {}  -- constains lookup table for accessing spawner fields by name

local ENTITY_SPAWNER_FIELDNAME_INDEX = 1
local function populateSpawnerByFields()
    for _, train_class in pairs(MEL.TrainClasses) do
        local ent_table = MEL.EntTables[train_class]
        if not ent_table.Spawner then continue end
        MEL.SpawnerByFields[train_class] = {}
        for i, field in pairs(ent_table.Spawner) do
            if istable(field) and isstring(field[ENTITY_SPAWNER_FIELDNAME_INDEX]) then
                MEL.SpawnerByFields[train_class][field[ENTITY_SPAWNER_FIELDNAME_INDEX]] = i
            end
        end
    end
end

function MEL._LoadHelpers()
    populateSpawnerByFields()
end