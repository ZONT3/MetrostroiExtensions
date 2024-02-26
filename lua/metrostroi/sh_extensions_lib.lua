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
if SERVER then AddCSLuaFile() end
if not MetrostroiExtensionsLib then MetrostroiExtensionsLib = {} end
MEL = MetrostroiExtensionsLib  -- alias. 23 symbols vs 3. and we name it MetrostroiExtensionLib because there is fly's old Metrostroi Extensions.
MEL.Debug = true -- helps with autoreload, but may introduce problems. Disable in production!
MEL.BaseRecipies = {}
MEL.Recipes = {}
MEL.DisabledRecipies = {}

MEL.InjectStack = {}
MEL.FunctionInjectStack = {}

MEL.ClientPropsToReload = {} -- client props, injected with Metrostroi Extensions, that needs to be reloaded on spawner update
-- (key: entity class, value: table with key as field name and table with props as value)
MEL.RandomFields = {} -- all fields, that marked as random (first value is list eq. random) (key: entity class, value: {field_name, amount_of_entries}) 
MEL.ElementMappings = {} -- mapping per wagon, per field for list elements (key - ent_class, value - (key - field_name, value - (key - name of element, value - index)))

MEL.RecipeSpecific = {} -- table with things, that can and should be shared between recipies
-- lookup table for train families
MEL.TrainFamilies = {
    -- for 717 we don't need to modify _custom entity, cause it's used just for spawner
    ["717"] = {"gmod_subway_81-717_lvz", "gmod_subway_81-717_mvm",},
    ["717_714"] = {"gmod_subway_81-717_lvz", "gmod_subway_81-717_mvm", "gmod_subway_81-714_lvz", "gmod_subway_81-714_mvm"},
    ["717_714_mvm"] = {"gmod_subway_81-717_mvm", "gmod_subway_81-714_mvm"},
    ["717_714_lvz"] = {"gmod_subway_81-717_lvz", "gmod_subway_81-714_lvz"},
}

MEL.ent_tables = {}
MEL.train_classes = {}
-- logger methods
local LOG_PREFIX = "[MetrostroiExtensionsLib] "
function logInfo(msg)
    print(LOG_PREFIX .. "Info: " .. msg)
end
function logDebug(msg)
    if MetrostroiExtensions.Debug then
        print(LOG_PREFIX .. "Debug: " .. msg)
    end
end
function logError(msg)
    ErrorNoHaltWithStack(LOG_PREFIX .. "Error!: " .. msg .. "\n")
end

-- helper methods
function getEntclass(ent_or_entclass)
    if not ent_or_entclass then
        logError("For some reason, ent_or_entclass in getEntclass is nil. Please report this error.")
    end
    -- get entclass from ent table or from str entclass 
    if istable(ent_or_entclass) then return ent_or_entclass.ent_class end
    if isentity(ent_or_entclass) then return ent_or_entclass:GetClass() end
    return ent_or_entclass
end

function injectIntoEntFunction(ent_or_entclass, function_name, function_to_inject, priority)
    -- negative priority - inject before default function
    -- positive priority - inject after default function
    -- zero - default function priority, error!
    local entclass = getEntclass(ent_or_entclass)
    if priority == 0 then logError("when injecting function with name " .. function_name .. ": priority couldn't be zero") end
    if not MEL.FunctionInjectStack[entclass] then MEL.FunctionInjectStack[entclass] = {} end
    if not MEL.FunctionInjectStack[entclass][function_name] then MEL.FunctionInjectStack[entclass][function_name] = {} end
    local inject_priority = priority or -1
    if not MEL.FunctionInjectStack[entclass][function_name][inject_priority] then MEL.FunctionInjectStack[entclass][function_name][inject_priority] = {} end
    table.insert(MEL.FunctionInjectStack[entclass][function_name][inject_priority], function_to_inject)
end

function MEL.MarkClientPropForReload(ent_or_entclass, clientprop_name, field_name)
    local entclass = getEntclass(ent_or_entclass)
    if not MEL.ClientPropsToReload[entclass] then MEL.ClientPropsToReload[entclass] = {} end
    if not MEL.ClientPropsToReload[entclass][field_name] then MEL.ClientPropsToReload[entclass][field_name] = {} end
    table.insert(MEL.ClientPropsToReload[entclass][field_name], clientprop_name)
end

function MEL.InjectIntoClientFunction(ent_or_entclass, function_name, function_to_inject, priority)
    if SERVER then return end
    injectIntoEntFunction(ent_or_entclass, function_name, function_to_inject, priority)
end

function MEL.InjectIntoServerFunction(ent_or_entclass, function_name, function_to_inject, priority)
    if CLIENT then return end
    injectIntoEntFunction(ent_or_entclass, function_name, function_to_inject, priority)
end

function getSpawnerEntclass(ent_or_entclass)
    local entclass = getEntclass(ent_or_entclass)
    if table.HasValue(MEL.TrainFamilies["717_714_mvm"], entclass) then
        entclass = "gmod_subway_81-717_mvm_custom"
    end
    return entclass
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
        local entclass_random = getEntclass(ent_or_entclass)
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

-- TODO: Document that shit
function updateMapping(ent_class, field_name, mapping_name, new_index)
    if not MEL.ElementMappings[ent_class] then
        MEL.ElementMappings[ent_class] = {}
    end
    if not MEL.ElementMappings[ent_class][field_name] then
        MEL.ElementMappings[ent_class][field_name] = {}
    end
    MEL.ElementMappings[ent_class][field_name][mapping_name] = new_index
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
    if MEL.ElementMappings[ent_class] and MEL.ElementMappings[ent_class][field_name] then
        return MEL.ElementMappings[entclass][field_name][element]
    end
    -- try to find index of it, if it non-existent in our ElementMappings cache
    local spawner = scripted_ents.GetStored(entclass).t.Spawner
    for _, field in pairs(spawner) do
        if field and #field > 0 and field[1] == field_name then
            for i, field_elem in pairs(field[4]) do
                if field_elem == element then
                    updateMapping(entclass, field_name, element, i)
                    return i
                end
            end
        end
    end
end

function MEL.UpdateModelCallback(ent, clientprop_name, new_modelcallback)
    if CLIENT then
        local old_modelcallback = ent.ClientProps[clientprop_name]["modelcallback"] or function() end
        ent.ClientProps[clientprop_name]["modelcallback"] = function(self)
            local new_modelpath = new_modelcallback(self)
            return new_modelpath or old_modelcallback(self)
        end
    end
end

function MEL.UpdateCallback(ent, clientprop_name, new_callback)
    if CLIENT then
        local old_callback = ent.ClientProps[clientprop_name]["modelcallback"] or function() end
        ent.ClientProps[clientprop_name]["callback"] = function(self, cent)
            old_callback(self, cent)
            new_callback(self, cent)
        end
    end
end

function MEL.NewClientProp(ent, clientprop_name, clientprop_info, field_name)
    if CLIENT then ent.ClientProps[clientprop_name] = clientprop_info end
    if field_name then MEL.MarkClientPropForReload(ent, clientprop_name, field_name) end
end

function MEL.MoveButtonMap(ent, buttonmap_name, new_pos, new_ang)
    if CLIENT then
        local buttonmap = ent.ButtonMap[buttonmap_name]
        buttonmap.pos = new_pos
        if new_ang then buttonmap.ang = new_ang end
    end
end

function MEL.NewButtonMap(ent, buttonmap_name, buttonmap_data)
    if CLIENT then ent.ButtonMap[buttonmap_name] = buttonmap_data end
end

function MEL.DefineRecipe(name)
    if not MEL.BaseRecipies[name] then MEL.BaseRecipies[name] = {} end
    RECIPE = MEL.BaseRecipies[name]
    RECIPE_NAME = name
end

function loadRecipe(filename, ent_type, side)
    local name = ent_type .. "_" .. string.sub(filename, 1, string.find(filename, "%.lua") - 1)
    local filepath = "recipies/" .. ent_type .. "/" .. filename
    -- load recipe
    if SERVER and side ~= "sv" then AddCSLuaFile(filepath) end
    include(filepath)
    logInfo("loading recipe " .. name .. " from " .. filepath)
    RECIPE.ClassName = name
    RECIPE.Description = RECIPE.Description or "No description"
    RECIPE.TrainType = ent_type
    RECIPE.Specific = {}
    RECIPE.Init = RECIPE.Init or function() end
    RECIPE.BeforeInject = RECIPE.BeforeInject or function() end
    RECIPE.InjectNeeded = RECIPE.InjectNeeded or function() return true end
    RECIPE.Inject = RECIPE.Inject or function() end
    RECIPE.InjectSpawner = RECIPE.InjectSpawner or function() end
    if MEL.Recipes[RECIPE_NAME] then
        logError("Recipe with name \"" .. RECIPE_NAME .. "\" already exists. Refusing to load recipe from " .. filepath .. ".")
        return
    end
    MEL.Recipes[RECIPE_NAME] = RECIPE
    -- initialize recipe
    initRecipe(RECIPE)
    RECIPE = nil
end

function initRecipe(recipe)
    recipe:Init()
    if not ConVarExists("metrostroi_ext_" .. recipe.ClassName) then
        -- add convar that will be able to disable that recipe on server
        CreateConVar("metrostroi_ext_" .. recipe.ClassName,
                        1, {FCVAR_ARCHIVE, FCVAR_REPLICATED},
                        "Status of Metrostroi extensions recipe \"" .. recipe.ClassName .. "\": " .. recipe.Description .. ".",
                        0, 1)
    end
    if GetConVar("metrostroi_ext_" .. recipe.ClassName):GetBool() then
        -- if recipe enabled, add it to inject stack
        table.insert(MEL.InjectStack, recipe)
    end
    -- add recipe scepific things
    for key, value in pairs(recipe.Specific) do
        MEL.RecipeSpecific[key] = value
    end
end

function getEntsByTrainType(train_type)
    -- firstly, check for "all" train_type
    if train_type == "all" then return MEL.train_classes end
    -- then try to find it as entity class
    if table.HasValue(MEL.train_classes, train_type) then return {train_type} end
    -- then try to check it in lookup table
    -- why? just imagine 717: we have 5p, we have some other modifications
    -- and you probably don't want to have a new default 717 cabine in 7175p
    if MEL.TrainFamilies[train_type] then return MEL.TrainFamilies[train_type] end
    -- and finally try to find by searching train family in classname
    local ent_classes = {}
    for _, ent_class in pairs(MEL.train_classes) do
        local contains_train_type, _ = string.find(ent_class, train_type)
        if contains_train_type then table.insert(ent_classes, ent_class) end
    end

    if #ent_classes == 0 then logError("no entities for " .. train_type .. ". Perhaps a typo?") end
    return ent_classes
end

function getTrainEntTables()
    for name in pairs(scripted_ents.GetList()) do
        local prefix = "gmod_subway_"
        if string.sub(name,1,#prefix) == prefix and scripted_ents.Get(name).Base == "gmod_subway_base" then
            table.insert(MEL.train_classes,name)
        end
    end
    for _, ent_class in pairs(MEL.train_classes) do
        local ent_table = scripted_ents.GetStored(ent_class).t
        ent_table.ent_class = ent_class -- add ent_class for convience
        MEL.ent_tables[ent_class] = ent_table
    end
end


function injectRandomFieldHelper(ent_class)
    if MEL.RandomFields[ent_class] then
        -- add helper inject to server TrainSpawnerUpdate in order to automaticly handle random value
        -- hack. iknowiknowiknow its bad
        MEL.InjectIntoServerFunction(ent_class, "TrainSpawnerUpdate", function(wagon, ...)
            math.randomseed(wagon.WagonNumber + wagon.SubwayTrain.EKKType)
            local custom = tobool(wagon.CustomSettings or true)
            for _, data in pairs(MEL.RandomFields[ent_class]) do
                local key = data[1]
                local field_type = data[2]
                if field_type == "List" then
                    local amount_of_values = data[3]
                    local value = wagon:GetNW2Int(key, 1)
                    if not custom or value == 1 then value = math.random(2, amount_of_values) end
                    wagon:SetNW2Int(key, value - 1)
                elseif field_type == "Slider" then
                    local min = data[3]
                    local max = data[4]
                    local value = wagon:GetNW2Float(key, min)
                    if not custom or value == min then wagon:SetNW2Float(key, math.random(min + 1, max)) end
                end
            end
            math.randomseed(os.time())
        end, -10)
    end
end

function injectFieldUpdateHelper(ent_class)
    if MEL.ClientPropsToReload[ent_class] then
        -- add helper inject to server UpdateWagonNumber in order to reload all models, that we should
        if ent_class == "gmod_subway_81-717_mvm_custom" then
            ent_class_inject = "gmod_subway_81-717_mvm"
        else
            ent_class_inject = ent_class
        end

        MEL.InjectIntoClientFunction(ent_class_inject, "UpdateWagonNumber", function(self)
            for key, props in pairs(MEL.ClientPropsToReload[ent_class]) do
                local value = self:GetNW2Int(key, 1)
                if MEL.Debug or self[key] ~= value then
                    for _, prop_name in pairs(props) do
                        self:RemoveCSEnt(prop_name)
                    end

                    self[key] = value
                end
            end
        end)
    end
end

function injectFunction(ent_class, ent_table)
    if MEL.FunctionInjectStack[ent_class] then
        -- yep, this is O(N^2). funny, cause there is probably better way to achieve priority system
        for function_name, priorities in pairs(MEL.FunctionInjectStack[ent_class]) do
            local before_stack = {}
            local after_stack = {}
            for priority, function_stack in SortedPairs(priorities) do
                if priority < 0 then
                    table.insert(before_stack, function_stack)
                elseif priority > 0 then
                    table.insert(after_stack, function_stack)
                end
            end

            -- maybe compile every func from stack?
            -- check for missing function from some wagon
            if not ent_table[function_name] then
                logError("can't inject into " .. ent_class .. ": function " .. function_name .. " doesn't exists")
                continue
            end

            if not ent_table["Default" .. function_name] then ent_table["Default" .. function_name] = ent_table[function_name] end
            local builded_inject = function(wagon, ...)
                for i = #before_stack, 1, -1 do
                    for _, inject_function in pairs(before_stack[i]) do
                        inject_function(wagon, unpack({...} or {}), true)
                    end
                end
                local ret_val = ent_table["Default" .. function_name](wagon, unpack({...} or {}))
                for i = 1, #after_stack do
                    for _, inject_function in pairs(after_stack[i]) do
                        inject_function(wagon, ret_val, unpack({...} or {}), false)
                    end
                end
                return ret_val
            end
            ent_table[function_name] = builded_inject
            for _, ent in ipairs(ents.FindByClass(ent_class) or {}) do
                ent[function_name] = builded_inject
            end
        end
    end
end

function inject()
    -- method that finalizes inject on all trains. called after init of recipies
    for _, recipe in pairs(MEL.InjectStack) do
        recipe:BeforeInject()
    end
    for _, recipe in pairs(MEL.InjectStack) do
        -- call Inject method on every ent that recipe changes
        for _, ent_class in pairs(getEntsByTrainType(recipe.TrainType)) do
            if recipe:InjectNeeded(ent_class) then
                recipe:InjectSpawner(ent_class)
                recipe:Inject(MEL.ent_tables[ent_class], ent_class)
                if MEL.Debug then
                    -- call Inject method on all alredy spawner ent that recipe changes (if debug enabled)
                    for _, ent in ipairs(ents.FindByClass(ent_class) or {}) do
                        recipe:Inject(ent, ent_class)
                    end
                end
            end
        end
    end
    RunConsoleCommand("metrostroi_language_reload")
    -- reload all languages in order to update 
    for ent_class, ent_table in pairs(MEL.ent_tables) do
        injectRandomFieldHelper(ent_class)
        injectFieldUpdateHelper(ent_class)
        injectFunction(ent_class, ent_table)
    end
end

-- load all recipies
local _, folders = file.Find("recipies/*", "LUA")
for _, folder in pairs(folders) do
    local train_type = folder
    local files, _ = file.Find("recipies/" .. folder .. "/*.lua", "LUA")
    for _, File in pairs(files) do
        if not File then -- for some reason, File can be nil...
            continue
        end

        local side = string.sub(File, 1, 2)
        if side == "sv" and SERVER then -- Чтобы не дай бог не попало клиенту
            loadRecipe(File, train_type, "sv")
        else
            loadRecipe(File, train_type, side)
        end
    end
end

-- injection logic
-- debug uses timers as inject logic
-- production uses hook GM:InitPostEntity
hook.Add("InitPostEntity", "MetrostroiExtensionsLibInject", function()
    timer.Simple(1, function()
        getTrainEntTables()
        inject()
    end)
end)


-- reload command:
-- reloads all recipies on client and server
if SERVER then
    util.AddNetworkString("MetrostroiExtDoReload")
    concommand.Add("metrostroi_ext_reload", function(ply, cmd, args)
        net.Start("MetrostroiExtDoReload")
        net.Broadcast()
        logInfo("reloading recipies...")
        -- clear all inject stacks
        MEL.InjectStack = {}
        MEL.FunctionInjectStack = {}
        MEL.ClientPropsToReload = {}
        MEL.RandomFields = {}
        for _, recipe in pairs(MEL.Recipes) do
            initRecipe(recipe)
        end

        getTrainEntTables()
        inject()
    end)
end

if CLIENT then
    net.Receive("MetrostroiExtDoReload", function(len, ply)
        logInfo("reloading recipies...")
        -- clear all inject stacks
        MEL.InjectStack = {}
        MEL.FunctionInjectStack = {}
        MEL.ClientPropsToReload = {}
        MEL.RandomFields = {}
        for _, recipe in pairs(MEL.Recipes) do
            initRecipe(recipe)
        end

        getTrainEntTables()
        inject()
        -- try to reload all spawned trains csents and buttonmaps
        for k, v in ipairs(ents.FindByClass("gmod_subway_*")) do
            v.ClientPropsInitialized = false
            v:ClearButtons()
        end
    end)
end