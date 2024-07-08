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
if not MEL.SpawnerFieldMappings then
    MEL.SpawnerFieldMappings = {} -- lookup table for accessing spawner fields by name and list elements by default, non-translated name
end

-- (key: train_class, value: (key: field_name, value: {index = index_of_field, list_elements = (key: name of list element, value: index)}))
if not MEL.ButtonmapButtonMappings then
    MEL.ButtonmapButtonMappings = {} -- lookup table for accessing button of buttonmap by its id
end

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

function MEL.Helpers.getWeightedRandomValue(distribution)
    local total = 0
    for _, part in pairs(distribution) do
        total = total + part
    end

    local random = math.random(total)
    local cursor = 0
    for i = 1, #distribution do
        cursor = cursor + distribution[i]
        if cursor >= random then
            return i
        end
    end
    MEL._LogError("getWeightedRandomValue is broken lol. Please report this error")
end

function MEL.GetButtonmapButtonMapping(ent_or_entclass, buttonmap_name, button_name, ignore_error)
    local ent_class = MEL.GetEntclass(ent_or_entclass)
    if not MEL.getEntTable(ent_class).ButtonMap then return end
    local buttonmap = MEL.getEntTable(ent_class).ButtonMap[buttonmap_name]
    if not MEL.ButtonmapButtonMappings[ent_class] then MEL.ButtonmapButtonMappings[ent_class] = {} end
    if not MEL.ButtonmapButtonMappings[ent_class][buttonmap_name] then MEL.ButtonmapButtonMappings[ent_class][buttonmap_name] = {} end
    local button_index = MEL.ButtonmapButtonMappings[ent_class][buttonmap_name][button_name]
    if not button_index and buttonmap_name == "IGLAButtons_C" then print(button_name, "wtf") end
    if not button_index then
        for i, button in pairs(buttonmap.buttons) do
            if button.ID and button.ID == button_name then
                MEL.ButtonmapButtonMappings[ent_class][buttonmap_name][button_name] = i
                button_index = i
            end
        end
    end

    if not ignore_error and not button_index then
        MEL._LogError(Format("can't find button %s in buttonmap %s", button_name, buttonmap_name))
        return
    end
    return button_index
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

local function populateButtonmapButtonMappings()
    if SERVER then return end
    for _, train_class in pairs(MEL.TrainClasses) do
        local ent_table = MEL.EntTables[train_class]
        if not ent_table.ButtonMap then continue end
        MEL.ButtonmapButtonMappings[train_class] = {}
        for buttonmap_name, buttonmap in pairs(ent_table.ButtonMap) do
            if not buttonmap.buttons then continue end
            for i, button in pairs(buttonmap.buttons) do
                if not istable(button) or not button.ID then continue end
                if not MEL.ButtonmapButtonMappings[train_class][buttonmap_name] then MEL.ButtonmapButtonMappings[train_class][buttonmap_name] = {} end
                MEL.ButtonmapButtonMappings[train_class][buttonmap_name][button.ID] = i
            end
        end
    end
end

function MEL._LoadHelpers()
    populateButtonmapButtonMappings()
    populateSpawnerFieldMappings()
end
