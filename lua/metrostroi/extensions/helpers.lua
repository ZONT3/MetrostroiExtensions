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
MEL.SpawnerFieldMappings = {} -- lookup table for accessing spawner fields by name and list elements by default, non-translated name
-- (key: train_class, value: (key: field_name, value: {index = index_of_field, list_elements = (key: name of list element, value: index)}))
MEL.ButtonmapButtonMappigns = {} -- lookup table for accessing button of buttonmap by its id
--  (key: train_class, value: (key: buttonmap name, value: (key: button id, value: its index))

local SpawnerC = MEL.Constants.Spawner
MEL.Helpers = {}

function MEL.Helpers.getListElementIndex(field_table, element_name)
    if field_table[SpawnerC.TYPE] == SpawnerC.TYPE_LIST and istable(field_table[SpawnerC.List.ELEMENTS]) then
        for list_i, name in pairs(field_table[SpawnerC.List.ELEMENTS]) do
            if name == element_name then return list_i end
        end
    end
end

local function populateSpawnerFieldMappings()
    for _, train_class in pairs(MEL.TrainClasses) do
        local ent_table = MEL.EntTables[train_class]
        if not ent_table.Spawner then continue end
        MEL.SpawnerFieldMappings[train_class] = {}
        for field_i, field in pairs(ent_table.Spawner) do
            if istable(field) and isstring(field[SpawnerC.NAME]) then
                local field_name = field[SpawnerC.NAME]
                if MEL.SpawnerFieldMappings[train_class][field_name] then continue end
                MEL.SpawnerFieldMappings[train_class][field_name] = {
                    index = field_i,
                    list_elements = {}
                }

                if field[SpawnerC.TYPE] == SpawnerC.TYPE_LIST and istable(field[SpawnerC.List.ELEMENTS]) then
                    for list_i, name in pairs(field[SpawnerC.List.ELEMENTS]) do
                        MEL.SpawnerFieldMappings[train_class][field_name].list_elements[name] = list_i
                    end
                end
            end
        end
    end
end

local function populateButtonmapButtonMappigns()
    if SERVER then return end
    for _, train_class in pairs(MEL.TrainClasses) do
        local ent_table = MEL.EntTables[train_class]
        if not ent_table.ButtonMap then continue end
        MEL.ButtonmapButtonMappigns[train_class] = {}
        for buttonmap_name, buttonmap in pairs(ent_table.ButtonMap) do
            for i, button in pairs(buttonmap) do
                if not istable(button) or not button.ID then continue end
                MEL.ButtonmapButtonMappigns[train_class][button.ID] = i
            end
        end
    end
end


function MEL._LoadHelpers()
    populateButtonmapButtonMappigns()
    populateSpawnerFieldMappings()
end