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
MEL.ElementMappings = {} -- mapping per wagon, per field for list elements (key - entclass, value - (key - field_name, value - (key - name of element, value - index)))
local function getSpawnerEntclass(ent_or_entclass)
    local entclass = MEL.GetEntclass(ent_or_entclass)
    if table.HasValue(MEL.TrainFamilies["717_714_mvm"], entclass) then entclass = "gmod_subway_81-717_mvm_custom" end
    return entclass
end

function MEL.MarkClientPropForReload(ent_or_entclass, clientprop_name, field_name)
    local entclass = MEL.GetEntclass(ent_or_entclass)
    if not MEL.ClientPropsToReload[entclass] then MEL.ClientPropsToReload[entclass] = {} end
    if not MEL.ClientPropsToReload[entclass][field_name] then MEL.ClientPropsToReload[entclass][field_name] = {} end
    table.insert(MEL.ClientPropsToReload[entclass][field_name], clientprop_name)
end

function MEL.AddSpawnerField(ent_or_entclass, field_data, is_random_field, overwrite)
    local entclass = getSpawnerEntclass(ent_or_entclass)
    local spawner = scripted_ents.GetStored(entclass).t.Spawner
    if not spawner then return end
    if MEL.Debug or overwrite then
        -- check if we have field with same name, remove it if needed
        for i, field in pairs(spawner) do
            if istable(field) and #field ~= 0 and field[1] == field_data[1] then table.remove(spawner, i) end
        end
    end

    if is_random_field then
        local entclass_random = MEL.GetEntclass(ent_or_entclass)
        if not MEL.RandomFields[entclass_random] then MEL.RandomFields[entclass_random] = {} end
        local field_type = field_data[3]
        if field_type == "List" then
            table.insert(MEL.RandomFields[entclass_random], {field_data[1], field_data[3], #field_data[4]})
        elseif field_type == "Slider" then
            table.insert(MEL.RandomFields[entclass_random], {field_data[1], field_data[3], field_data[5], field_data[6]})
        end
    end

    table.insert(spawner, field_data)
end

function MEL.RemoveSpawnerField(ent_or_entclass, field_name)
    local entclass = getSpawnerEntclass(ent_or_entclass)
    local spawner = scripted_ents.GetStored(entclass).t.Spawner
    if not spawner then return end
    for i, field in pairs(spawner) do
        if istable(field) and #field ~= 0 and field[1] == field_name then table.remove(spawner, i) end
    end
end

-- TODO: Document that shit
local function updateMapping(entclass, field_name, mapping_name, new_index)
    if not MEL.ElementMappings[entclass] then MEL.ElementMappings[entclass] = {} end
    if not MEL.ElementMappings[entclass][field_name] then MEL.ElementMappings[entclass][field_name] = {} end
    MEL.ElementMappings[entclass][field_name][mapping_name] = new_index
end

function MEL.AddSpawnerListElement(ent_or_entclass, field_name, element)
    local entclass = getSpawnerEntclass(ent_or_entclass)
    local spawner = scripted_ents.GetStored(entclass).t.Spawner
    if not spawner then return end
    for _, field in pairs(spawner) do
        if field and #field > 0 and field[1] == field_name then
            -- just add it lol
            local new_index = table.insert(field[4], element)
            -- for god sake, if some shitty inject will insert element and not append it - i would be so mad
            updateMapping(ent_or_entclass, field_name, element, new_index)
            return
        end
    end
end

function MEL.GetMappingValue(ent_or_entclass, field_name, element)
    local entclass = getSpawnerEntclass(ent_or_entclass)
    if MEL.ElementMappings[entclass] and MEL.ElementMappings[entclass][field_name] and MEL.ElementMappings[entclass][field_name][element] then return MEL.ElementMappings[entclass][field_name][element] end
    -- try to find index of it, if it non-existent in our ElementMappings cache
    local spawner = scripted_ents.GetStored(entclass).t.Spawner
    for _, field in pairs(spawner) do
        if istable(field) and #field > 0 and field[1] == field_name then
            for i, field_elem in pairs(field[4]) do
                if field_elem == element then
                    updateMapping(entclass, field_name, element, i)
                    return i
                end
            end
        end
    end
end