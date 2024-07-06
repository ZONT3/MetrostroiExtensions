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
MEL.ClientPropsToReload = {} -- client props, injected with Metrostroi Extensions, that needs to be reloaded on spawner update
-- (key: entity class, value: table with key as field name and table with props as value)
MEL.RandomFields = {} -- all fields, that marked as random (first value is list eq. random) (key: entity class, value: {field_name, amount_of_entries})
local SpawnerC = MEL.Constants.Spawner
local function getSpawnerEntclass(ent_or_entclass)
    local ent_class = MEL.GetEntclass(ent_or_entclass)
    -- TODO: HasValue is slow, needs refactor
    if table.HasValue(MEL.TrainFamilies["717_714_mvm"], ent_class) then ent_class = "gmod_subway_81-717_mvm_custom" end
    return ent_class
end

function MEL.FindSpawnerField(ent_or_entclass, field_name)
    local ent_class = MEL.GetEntclass(ent_or_entclass)
    local spawner = MEL.EntTables[ent_class].Spawner
    if MEL.SpawnerFieldMappings[ent_class] and MEL.SpawnerFieldMappings[ent_class][field_name] then
        return spawner[MEL.SpawnerFieldMappings[ent_class][field_name].index]
    end
    for i, field in pairs(spawner) do
        if istable(field) and isnumber(i) and #field ~= 0 and field[SpawnerC.NAME] == field_name then return field end
    end
end

function MEL.MarkClientPropForReload(ent_or_entclass, clientprop_name, field_name)
    local ent_class = MEL.GetEntclass(ent_or_entclass)
    if not MEL.ClientPropsToReload[ent_class] then MEL.ClientPropsToReload[ent_class] = {} end
    if not MEL.ClientPropsToReload[ent_class][field_name] then MEL.ClientPropsToReload[ent_class][field_name] = {} end
    table.insert(MEL.ClientPropsToReload[ent_class][field_name], clientprop_name)
end

function MEL.AddSpawnerField(ent_or_entclass, field_data, is_random_field, overwrite)
    local ent_class = getSpawnerEntclass(ent_or_entclass)
    local spawner = MEL.EntTables[ent_class].Spawner
    if not spawner then return end
    if MEL.Debug or overwrite then
        -- check if we have field with same name, remove it if needed
        for i, field in pairs(spawner) do
            if istable(field) and isnumber(i) and #field ~= 0 and field[SpawnerC.NAME] == field_data[SpawnerC.NAME] then table.remove(spawner, i) end
        end
    end

    if is_random_field then
        local entclass_random = MEL.GetEntclass(ent_or_entclass)
        if not MEL.RandomFields[entclass_random] then MEL.RandomFields[entclass_random] = {} end
        local field_type = field_data[SpawnerC.TYPE]
        local random_data = {
            name = field_data[SpawnerC.NAME],
            type_ = field_type
        }

        if field_type == SpawnerC.TYPE_LIST then
            random_data.elements_length = #field_data[SpawnerC.List.ELEMENTS]
        elseif field_type == SpawnerC.TYPE_SLIDER then
            random_data.min = field_data[SpawnerC.Slider.MIN_VALUE]
            random_data.max = field_data[SpawnerC.Slider.MAX_VALUE]
            random_data.decimals = field_data[SpawnerC.Slider.DECIMALS]
        end

        table.insert(MEL.RandomFields[entclass_random], random_data)
    end

    table.insert(spawner, field_data)
end

function MEL.RemoveSpawnerField(ent_or_entclass, field_name)
    local ent_class = getSpawnerEntclass(ent_or_entclass)
    local spawner = MEL.EntTables[ent_class].Spawner
    if not spawner then return end
    for i, field in pairs(spawner) do
        if istable(field) and #field ~= 0 and field[SpawnerC.NAME] == field_name then table.remove(spawner, i) end
    end
end

-- TODO: Document that shit
-- local function updateMapping(entclass, field_name, mapping_name, new_index)
--     if not MEL.ElementMappings[entclass] then MEL.ElementMappings[entclass] = {} end
--     if not MEL.ElementMappings[entclass][field_name] then MEL.ElementMappings[entclass][field_name] = {} end
--     MEL.ElementMappings[entclass][field_name][mapping_name] = new_index
-- end
-- function MEL.AddSpawnerListElement(ent_or_entclass, field_name, element)
--     local entclass = getSpawnerEntclass(ent_or_entclass)
--     local spawner = scripted_ents.GetStored(entclass).t.Spawner
--     if not spawner then return end
--     for _, field in pairs(spawner) do
--         if field and #field > 0 and field[1] == field_name then
--             -- just add it lol
--             local new_index = table.insert(field[4], element)
--             -- for god sake, if some shitty inject will insert element and not append it - i would be so mad
--             updateMapping(ent_or_entclass, field_name, element, new_index)
--             return
--         end
--     end
-- end
function MEL.GetMappingValue(ent_or_entclass, field_name, element)
    local ent_class = getSpawnerEntclass(ent_or_entclass)
    if MEL.SpawnerFieldMappings[ent_class] and MEL.SpawnerFieldMappings[ent_class][field_name] and MEL.SpawnerFieldMappings[ent_class][field_name].list_elements[element] then return MEL.SpawnerFieldMappings[ent_class][field_name].list_elements[element] end
    local ent_table = MEL.EntTables[ent_class]
    if not ent_table then
        ent_table = MEL.getEntTable(ent_class)
    end
    -- try to find index of it, if it non-existent in our SpawnerFieldMappings cache
    for field_i, field in pairs(ent_table.Spawner) do
        if istable(field) and isstring(field[SpawnerC.NAME]) and field[SpawnerC.NAME] == field_name then
            if MEL.SpawnerFieldMappings[ent_class][field_name] and field[SpawnerC.TYPE] == SpawnerC.TYPE_LIST then
                -- just update list_elements and try to find it
                MEL.SpawnerFieldMappings[ent_class][field_name].list_elements[element] = MEL.Helpers.getListElementIndex(field, element)
            end

            MEL.SpawnerFieldMappings[ent_class][field_name] = {
                index = field_i,
                list_elements = {}
            }

            if field[SpawnerC.TYPE] == SpawnerC.TYPE_LIST and istable(field[SpawnerC.List.ELEMENTS]) then MEL.SpawnerFieldMappings[ent_class][field_name].list_elements[element] = MEL.Helpers.getListElementIndex(field, element) end
        end
    end
end
