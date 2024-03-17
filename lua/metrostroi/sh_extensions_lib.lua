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
MEL = MetrostroiExtensionsLib -- alias. 23 symbols vs 3. and we name it MetrostroiExtensionLib because there is fly's old Metrostroi Extensions.
MEL.Debug = true -- helps with autoreload, but may introduce problems. Disable in production!
MEL.BaseRecipies = {}
MEL.Recipes = {}
MEL.DisabledRecipies = {}
MEL.InjectStack = {}
MEL.RecipeSpecific = {} -- table with things, that can and should be shared between recipies

-- lookup table for train families
MEL.TrainFamilies = {
    -- for 717 we don't need to modify _custom entity, cause it's used just for spawner
    ["717"] = {"gmod_subway_81-717_lvz", "gmod_subway_81-717_mvm",},
    ["717_714"] = {"gmod_subway_81-717_lvz", "gmod_subway_81-717_mvm", "gmod_subway_81-714_lvz", "gmod_subway_81-714_mvm"},
    ["717_714_mvm"] = {"gmod_subway_81-717_mvm", "gmod_subway_81-714_mvm"},
    ["717_714_lvz"] = {"gmod_subway_81-717_lvz", "gmod_subway_81-714_lvz"},
}

MEL.InjectIntoSpawnedEnt = false -- temp global variable
MEL.ent_tables = {}
MEL.train_classes = {}
-- logger methods
local LOG_PREFIX = "[MetrostroiExtensionsLib] "
local WARNING_COLOR = Color(255, 255, 0)

local function logDebug(msg)
    if MEL.Debug then print(LOG_PREFIX .. "Debug: " .. msg) end
end

local function logInfo(msg)
    print(LOG_PREFIX .. "Info: " .. msg)
end

local function logWarning(msg)
    MsgC(WARNING_COLOR, LOG_PREFIX .. "Warning: " .. msg .. "\n")
end

local function logError(msg)
    ErrorNoHaltWithStack(LOG_PREFIX .. "Error!: " .. msg .. "\n")
end

function MEL.LogErrorFactory()
    return function(msg) logError("error from recipe " .. RECIPE.Name .. ": " .. msg) end
end

function MEL.LogWarningFactory()
    return function(msg) logWarning("warning from recipe " .. RECIPE.Name .. ": " .. msg) end
end

function MEL.LogInfoFactory()
    return function(msg) logInfo("info from recipe " .. RECIPE.Name .. ": " .. msg) end
end

-- helper methods
function MEL.GetEntclass(ent_or_entclass)
    if not ent_or_entclass then logError("for some reason, ent_or_entclass in GetEntclass is nil. Please report this error.") end
    -- get entclass from ent table or from str entclass 
    if istable(ent_or_entclass) then return ent_or_entclass.entclass end
    if isentity(ent_or_entclass) then return ent_or_entclass:GetClass() end
    return ent_or_entclass
end

-- load all methods
local methodModules = file.Find("metrostroi/extensions/*.lua","LUA")

for _, moduleName in pairs(methodModules) do
    if SERVER then
        include("metrostroi/extensions/" .. moduleName)
        AddCSLuaFile("metrostroi/extensions/" .. moduleName)
    else
        include("metrostroi/extensions/" .. moduleName)
    end
end


function MEL.DefineRecipe(name, train_type)
    if not MEL.BaseRecipies[name] then MEL.BaseRecipies[name] = {} end
    RECIPE = MEL.BaseRecipies[name]
    RECIPE.TrainType = train_type
    RECIPE.Name = name
end

local function initRecipe(recipe)
    recipe:Init()
    if not ConVarExists("metrostroi_ext_" .. recipe.ClassName) then
        -- add convar that will be able to disable that recipe on server
        CreateConVar("metrostroi_ext_" .. recipe.ClassName, 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Status of Metrostroi extensions recipe \"" .. recipe.ClassName .. "\": " .. recipe.Description .. ".", 0, 1)
    end

    if GetConVar("metrostroi_ext_" .. recipe.ClassName):GetBool() then
        -- if recipe enabled, add it to inject stack
        table.insert(MEL.InjectStack, recipe)
    end

    -- add recipe specific things
    for key, value in pairs(recipe.Specific) do
        MEL.RecipeSpecific[key] = value
    end
end

local function loadRecipe(filename, scope)
    local File = string.GetFileFromFilename(filename)
    -- load recipe
    if SERVER and scope ~= "sv" then AddCSLuaFile(filename) end
    include(filename)
    if not RECIPE then
        logError("looks like RECIPE table for " .. filename .. " is nil. Ensure that DefineRecipe was called.")
        return
    end

    if not RECIPE.TrainType then
        logError("looks like you forgot to specify train type for " .. filename .. ". Refusing to load it.")
        return
    end

    if RECIPE.Name ~= string.sub(File, 1, string.find(File, "%.lua") - 1) then logWarning("recipe \"" .. RECIPE.Name .. "\" file name and name defined in DefineRecipe differs. Consider renaming your file.") end
    local class_name = nil
    if istable(RECIPE.TrainType) then
        class_name = table.concat(RECIPE.TrainType, "-") .. "_" .. RECIPE.Name
    else
        class_name = RECIPE.TrainType .. "_" .. RECIPE.Name
    end

    logInfo("loading recipe " .. RECIPE.Name .. " from " .. filename)
    RECIPE.ClassName = class_name
    RECIPE.Description = RECIPE.Description or "No description"
    RECIPE.Specific = {}
    RECIPE.Init = RECIPE.Init or function() end
    RECIPE.BeforeInject = RECIPE.BeforeInject or function() end
    RECIPE.InjectNeeded = RECIPE.InjectNeeded or function() return true end
    RECIPE.Inject = RECIPE.Inject or function() end
    RECIPE.InjectSpawner = RECIPE.InjectSpawner or function() end
    if MEL.Recipes[RECIPE.Name] then
        logError("recipe with name \"" .. RECIPE.Name .. "\" already exists. Refusing to load recipe from " .. filename .. ".")
        return
    end

    MEL.Recipes[RECIPE.Name] = RECIPE
    -- initialize recipe
    initRecipe(RECIPE)
    RECIPE = nil
end

local function getEntsByTrainType(train_type)
    if istable(train_type) then return train_type end
    -- firstly, check for "all" train_type
    if train_type == "all" then return MEL.train_classes end
    -- then try to find it as entity class
    if table.HasValue(MEL.train_classes, train_type) then return {train_type} end
    -- then try to check it in lookup table
    -- why? just imagine 717: we have 5p, we have some other modifications
    -- and you probably don't want to have a new default 717 cabine in 7175p
    if MEL.TrainFamilies[train_type] then return MEL.TrainFamilies[train_type] end
    -- and finally try to find by searching train family in classname
    local entclasses = {}
    for _, entclass in pairs(MEL.train_classes) do
        local contains_train_type, _ = string.find(entclass, train_type)
        if contains_train_type then table.insert(entclasses, entclass) end
    end

    if #entclasses == 0 then logError("no entities for " .. train_type .. ". Perhaps a typo?") end
    return entclasses
end

local function getTrainEntTables()
    for name in pairs(scripted_ents.GetList()) do
        local prefix = "gmod_subway_"
        if string.sub(name, 1, #prefix) == prefix and scripted_ents.Get(name).Base == "gmod_subway_base" then table.insert(MEL.train_classes, name) end
    end

    for _, entclass in pairs(MEL.train_classes) do
        local ent_table = scripted_ents.GetStored(entclass).t
        ent_table.entclass = entclass -- add entclass for convience
        MEL.ent_tables[entclass] = ent_table
    end
end

local function injectRandomFieldHelper(entclass)
    if not MEL.RandomFields[entclass] then return end
    -- add helper inject to server TrainSpawnerUpdate in order to automaticly handle random value
    -- hack. iknowiknowiknow its bad
    MEL.InjectIntoServerFunction(entclass, "TrainSpawnerUpdate", function(wagon, ...)
        math.randomseed(wagon.WagonNumber + wagon.SubwayTrain.EKKType)
        local custom = wagon.CustomSettings and true or false
        for _, data in pairs(MEL.RandomFields[entclass]) do
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
    end, -100)
end

local function injectFieldUpdateHelper(entclass)
    if MEL.ClientPropsToReload[entclass] then
        -- add helper inject to server UpdateWagonNumber in order to reload all models, that we should
        if entclass == "gmod_subway_81-717_mvm_custom" then
            entclass_inject = "gmod_subway_81-717_mvm"
        else
            entclass_inject = entclass
        end

        MEL.InjectIntoClientFunction(entclass_inject, "UpdateWagonNumber", function(self)
            for key, props in pairs(MEL.ClientPropsToReload[entclass] or {}) do
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

local function injectFunction(entclass, ent_table)
    if MEL.FunctionInjectStack[entclass] then
        -- yep, this is O(N^2). funny, cause there is probably better way to achieve priority system
        for function_name, priorities in pairs(MEL.FunctionInjectStack[entclass]) do
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
                logError("can't inject into " .. entclass .. ": function " .. function_name .. " doesn't exists!")
                continue
            end

            if not ent_table["Default" .. function_name] then ent_table["Default" .. function_name] = ent_table[function_name] end
            local builded_inject = function(wagon, ...)
                local closeBaseFunction = true
                for i = #before_stack, 1, -1 do
                    for _, inject_function in pairs(before_stack[i]) do
                        closeBaseFunction = inject_function(wagon, unpack({...} or {}), true)
                    end
                end

                if closeBaseFunction == false then return closeBaseFunction end
                local ret_val = ent_table["Default" .. function_name](wagon, unpack({...} or {}))
                for i = 1, #after_stack do
                    for _, inject_function in pairs(after_stack[i]) do
                        inject_function(wagon, ret_val, unpack({...} or {}), false)
                    end
                end
                return ret_val
            end

            ent_table[function_name] = builded_inject
            for _, ent in ipairs(ents.FindByClass(entclass) or {}) do
                ent[function_name] = builded_inject
            end
        end
    end
end

local function inject()
    -- method that finalizes inject on all trains. called after init of recipies
    for _, recipe in pairs(MEL.InjectStack) do
        recipe:BeforeInject()
    end

    for _, recipe in pairs(MEL.InjectStack) do
        -- call Inject method on every ent that recipe changes
        for _, entclass in pairs(getEntsByTrainType(recipe.TrainType)) do
            if recipe:InjectNeeded(entclass) then
                recipe:InjectSpawner(entclass)
                recipe:Inject(MEL.ent_tables[entclass], entclass)
                if MEL.Debug then
                    -- call Inject method on all alredy spawner ent that recipe changes (if debug enabled)
                    -- mark this call of inject as for entity (needed for InjectInto*Function)
                    MEL.InjectIntoSpawnedEnt = true
                    for _, ent in ipairs(ents.FindByClass(entclass) or {}) do
                        recipe:Inject(ent, entclass)
                    end

                    MEL.InjectIntoSpawnedEnt = false
                end
            end
        end
    end

    for entclass, ent_table in pairs(MEL.ent_tables) do
        injectRandomFieldHelper(entclass)
        injectFieldUpdateHelper(entclass)
        injectFunction(entclass, ent_table)
    end

    -- reload all languages
    -- why we are just using metrostroi_language_reload?:
    -- 1. im lazy
    -- 2. there are a lot of things that can be translatable and injected by recipe: buttonmaps, spawner things, other shit. so metrostroi_language_reload will do everything
    -- 3. im lazy
    RunConsoleCommand("metrostroi_language_reload")
end

-- load all recipies recursively
logInfo("loading recipies...")
local recipe_files = {}
local function findRecipies(folder)
    print(folder)
    local found_files, found_folders = file.Find(folder .. "/*", "LUA")
    for _, recipe_file in pairs(found_files) do
        table.insert(recipe_files, folder .. "/" .. recipe_file)
    end
    if found_folders and #found_folders > 0 then
        for _, found_folder in pairs(found_folders) do
            findRecipies(folder .. "/" .. found_folder)
        end
    end
end

findRecipies("recipies")
for _, recipe_file in pairs(recipe_files) do
    if not recipe_file then -- for some reason, File can be nil...
        continue
    end

    local scope = string.sub(string.GetFileFromFilename(recipe_file), 1, 2)
    if scope == "sv" and SERVER then -- Чтобы не дай бог не попало клиенту
        loadRecipe(recipe_file, train_type, "sv")
    else
        loadRecipe(recipe_file, train_type, side)
    end
end
-- injection logic
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