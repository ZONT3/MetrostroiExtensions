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
    if MEL.SpawnerFieldMappings[ent_class] and MEL.SpawnerFieldMappings[ent_class][field_name] then return spawner[MEL.SpawnerFieldMappings[ent_class][field_name].index] end
    for i, field in pairs(spawner) do
        if istable(field) and isnumber(i) and #field ~= 0 and field[SpawnerC.NAME] == field_name then return field end
    end
end

local function addToReloadTable(ent_class, clientprop_name, field_name)
    if not MEL.ClientPropsToReload[ent_class][field_name] then MEL.ClientPropsToReload[ent_class][field_name] = {} end
    table.insert(MEL.ClientPropsToReload[ent_class][field_name], clientprop_name)
end

function MEL.MarkClientPropForReload(ent_or_entclass, clientprop_name, field_name_or_names)
    local ent_class = MEL.GetEntclass(ent_or_entclass)
    if not MEL.ClientPropsToReload[ent_class] then MEL.ClientPropsToReload[ent_class] = {} end
    if isstring(field_name_or_names) then
        addToReloadTable(ent_class, clientprop_name, field_name_or_names)
    elseif istable(field_name_or_names) then
        for _, field_name in pairs(field_name_or_names) do
            addToReloadTable(ent_class, clientprop_name, field_name)
        end
    else
        MEL._LogError("field_name_or_names is neither string nor table. can't mark nothing for reload, y'now m8?")
    end
end

function MEL.AddSpawnerField(ent_or_entclass, field_data, random_field_data, overwrite, pos)
    if not ent_or_entclass then
        MEL._LogError("please provide ent_or_entclass in AddSpawnerField")
        return
    end

    local ent_class = getSpawnerEntclass(ent_or_entclass)
    local spawner = MEL.EntTables[ent_class].Spawner
    if not spawner then return end
    local old_pos = nil
    if MEL.Debug or overwrite then
        -- check if we have field with same name, remove it if needed
        for i, existing_field in pairs(spawner) do
            if istable(existing_field) and isnumber(i) and #existing_field ~= 0 and existing_field[SpawnerC.NAME] == field_data[SpawnerC.NAME] then
                old_pos = i
                table.remove(spawner, old_pos)
            end
        end
    end

    if random_field_data then
        local entclass_random = MEL.GetEntclass(ent_or_entclass)
        if not MEL.RandomFields[entclass_random] then MEL.RandomFields[entclass_random] = {} end
        local field_type = field_data[SpawnerC.TYPE]
        local random_data = {
            name = field_data[SpawnerC.NAME],
            type_ = field_type
        }

        if istable(random_field_data) then random_data.distribution = random_field_data end
        if field_type == SpawnerC.TYPE_LIST then
            random_data.elements_length = #field_data[SpawnerC.List.ELEMENTS]
        elseif field_type == SpawnerC.TYPE_SLIDER then
            random_data.min = field_data[SpawnerC.Slider.MIN_VALUE]
            random_data.max = field_data[SpawnerC.Slider.MAX_VALUE]
            random_data.decimals = field_data[SpawnerC.Slider.DECIMALS]
        end

        MEL.RandomFields[entclass_random][field_data[SpawnerC.NAME]] = random_data
    end

    if old_pos then
        table.insert(spawner, old_pos, field_data)
    elseif pos then
        table.insert(spawner, pos, field_data)
    else
        table.insert(spawner, field_data)
    end
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
    if not field_name then
        MEL._LogError("please provide field_name for which to obtain spawner mapping value")
        return
    end

    if not element then
        MEL._LogError("please provide element for which to obtain spawner mapping value")
        return
    end

    local ent_class = getSpawnerEntclass(ent_or_entclass)
    if MEL.SpawnerFieldMappings[ent_class] and MEL.SpawnerFieldMappings[ent_class][field_name] and MEL.SpawnerFieldMappings[ent_class][field_name].list_elements[element] then return MEL.SpawnerFieldMappings[ent_class][field_name].list_elements[element] end
    local ent_table = MEL.getEntTable(ent_class)
    if not ent_table or not ent_table.Spawner then
        MEL._LogError(Format("Spawner for %s is nil. Please check whenever you provided correct ent_or_entclass", ent_class))
        return
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

function MEL.IsRandomField(ent_or_entclass, field_name)
    local ent_class = MEL.GetEntclass(ent_or_entclass)
    return MEL.RandomFields[ent_class] and MEL.RandomFields[ent_class][field_name]
end

function MEL.GetRealSpawnerValue(ent, field_name)
    if not (isentity(ent) and IsValid(ent)) then
        MEL._LogError("please pass valid entity inside GetRealSpawnerValue. Make sure that you don't pass ent from recipe, but some entity like from function inject.")
        return
    end

    local ent_class = MEL.GetEntclass(ent)
    local value = ent:GetNW2Int(field_name)
    if not value then MEL._LogError(Format("field with name %s doesn't exists in %s. Perhaps a typo?", field_name, ent_class)) end
    if MEL.IsRandomField(ent_class, field_name) then
        value = value + 1 -- first value - is "random"
    end
    return value
end

function MEL.IsSpawnerSelected(ent, field_name, element)
    if not (isentity(ent) and IsValid(ent)) then
        MEL._LogError("please pass valid entity inside IsSpawnerSelected. Make sure that you don't pass ent from recipe, but some entity like from function inject.")
        return
    end

    local ent_class = MEL.GetEntclass(ent)
    local value = MEL.GetRealSpawnerValue(ent, field_name)
    return value == MEL.GetMappingValue(ent_class, field_name, element)
end

function MEL.GetSelectedSpawnerName(ent, field_name)
    if not (isentity(ent) and IsValid(ent)) then
        MEL._LogError("please pass valid entity inside GetSelectedSpawnerName. Make sure that you don't pass ent from recipe, but some entity like from function inject.")
        return
    end

    local ent_class = getSpawnerEntclass(ent)
    local mappings = MEL.SpawnerFieldMappings[ent_class][field_name].list_elements_indexed
    if not mappings then
        MEL._LogError(Format("SpawnerFieldMapping for %s is nil. Please check whenever you provided correct ent inside GetSelectedSpawnerName", ent_class))
        return
    end

    local value = MEL.GetRealSpawnerValue(ent, field_name)
    return mappings[value] -- this could be nil, but it shouldn't lol
end
