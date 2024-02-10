if SERVER then
    AddCSLuaFile()
end

if not MetrostroiExtensions then
    MetrostroiExtensions = {}
end
MetrostroiExtensions.Debug = true  -- helps with autoreload, but may introduce problems. Disable in production!

MetrostroiExtensions.BaseRecipies = {}
MetrostroiExtensions.Recipes = {}
MetrostroiExtensions.InjectStack = util.Stack()
MetrostroiExtensions.FunctionInjectStack = {}

MetrostroiExtensions.ClientPropsToReload = {}  -- client props, injected with Metrostroi Extensions, that needs to be reloaded on spawner update
-- (key: entity class, value: table with key as field name and table with props as value)
MetrostroiExtensions.RandomFields = {}  -- all fields, that marked as random (first value is list eq. random) (key: entity class, value: {field_name, amount_of_entries}) 

MetrostroiExtensions.ent_tables = {}


-- helper methods
function getEntclass(ent_or_entclass)
    -- get entclass from ent table or from str entclass 
    if type(ent_or_entclass) == "table" then
        return ent_or_entclass.ent_class
    end
    return ent_or_entclass
end

function injectIntoEntFunction(ent_or_entclass, function_name, function_to_inject, priority)
        -- negative priority - inject before default function
        -- positive priority - inject after default function
        -- zero - default function priority, error!
        local entclass = getEntclass(ent_or_entclass)
        if priority == 0 then
            ErrorNoHaltWithStack("[MetrostroiExtensions]: error when injecting function with name "..function_name..": priority couldn't be zero")
        end
        if not MetrostroiExtensions.FunctionInjectStack[entclass] then
            MetrostroiExtensions.FunctionInjectStack[entclass] = {}
        end
        if not MetrostroiExtensions.FunctionInjectStack[entclass][function_name] then
            MetrostroiExtensions.FunctionInjectStack[entclass][function_name] = {}
        end
        local inject_priority = priority or -1
        if not MetrostroiExtensions.FunctionInjectStack[entclass][function_name][inject_priority] then
            MetrostroiExtensions.FunctionInjectStack[entclass][function_name][inject_priority] = {}
        end
        table.insert(MetrostroiExtensions.FunctionInjectStack[entclass][function_name][inject_priority], function_to_inject)
end

function MetrostroiExtensions.MarkClientPropForReload(ent_or_entclass, clientprop_name, field_name)
    local entclass = getEntclass(ent_or_entclass)
    if not MetrostroiExtensions.ClientPropsToReload[entclass] then
        MetrostroiExtensions.ClientPropsToReload[entclass] = {}
    end
    if not MetrostroiExtensions.ClientPropsToReload[entclass][field_name] then
        MetrostroiExtensions.ClientPropsToReload[entclass][field_name] = {}
    end
    table.insert(MetrostroiExtensions.ClientPropsToReload[entclass][field_name], clientprop_name)
end

function MetrostroiExtensions.InjectIntoClientFunction(ent_or_entclass, function_name, function_to_inject, priority)
    if SERVER then return end
    injectIntoEntFunction(ent_or_entclass, function_name, function_to_inject, priority)
end

function MetrostroiExtensions.InjectIntoServerFunction(ent_or_entclass, function_name, function_to_inject, priority)
    if CLIENT then return end
    injectIntoEntFunction(ent_or_entclass, function_name, function_to_inject, priority)
end

function MetrostroiExtensions.AddSpawnerField(ent_or_entclass, field_data, is_list_random)
    local entclass = getEntclass(ent_or_entclass)
    spawner = scripted_ents.GetStored(entclass).t.Spawner
    if MetrostroiExtensions.Debug then
        -- check if we have field with same name, remove it if needed
        for i, field in pairs(spawner) do
            if istable(field) and #field ~= 0 and field[1] == field_data[1] then
                table.remove(spawner, i)
            end
        end 
    end
    if is_list_random then
        if not MetrostroiExtensions.RandomFields[entclass] then
            MetrostroiExtensions.RandomFields[entclass] = {}
        end
        table.insert(MetrostroiExtensions.RandomFields[entclass], {field_data[1], #field_data[4]})
    end
    table.insert(spawner, field_data)
end

function MetrostroiExtensions.UpdateModelCallback(ent, clientprop_name, new_modelcallback)
    if CLIENT then
        local old_modelcallback = ent.ClientProps[clientprop_name]["modelcallback"] or function() end
        ent.ClientProps[clientprop_name]["modelcallback"] = function(self)
            local new_modelpath = new_modelcallback(self)
            return new_modelpath or old_modelcallback(self)
        end
    end
end

function MetrostroiExtensions.UpdateCallback(ent, clientprop_name, new_callback)
    if CLIENT then
        local old_callback = ent.ClientProps[clientprop_name]["modelcallback"] or function() end
        ent.ClientProps[clientprop_name]["callback"] = function(self, cent)
            old_callback(self, cent)
            new_callback(self, cent)
        end
    end
end

function MetrostroiExtensions.NewClientProp(ent, clientprop_name, clientprop_info, field_name)
    if CLIENT then
        ent.ClientProps[clientprop_name] = clientprop_info
    end
    if field_name then
        MetrostroiExtensions.MarkClientPropForReload(ent.ent_class, clientprop_name, field_name)
    end
end

function MetrostroiExtensions.MoveButtonMap(ent, buttonmap_name, new_pos, new_ang)
    if CLIENT then
        local buttonmap = ent.ButtonMap[buttonmap_name]
        buttonmap.pos = new_pos
        if new_ang then
            buttonmap.ang = new_ang
        end
    end
end

function MetrostroiExtensions.NewButtonMap(ent, buttonmap_name, buttonmap_data)
    if CLIENT then
        ent.ButtonMap[buttonmap_name] = buttonmap_data
    end
end

function MetrostroiExtensions.DefineRecipe(name)
    if not MetrostroiExtensions.BaseRecipies[name] then
        MetrostroiExtensions.BaseRecipies[name] = {}
    end
    RECIPE = MetrostroiExtensions.BaseRecipies[name]
    RECIPE_NAME = name
end

function loadRecipe(filename, ent_type)
    local name = ent_type.."_"..string.sub(filename,1,string.find(filename,"%.lua")-1)
    local filepath = "recipies/"..ent_type.."/"..filename

    -- load recipe
    if SERVER then
		AddCSLuaFile(filepath)
	end
	include(filepath)
    print("[MetrostroiExtensions] Loading recipe "..name.." from "..filepath)
    RECIPE.ClassName = name
    RECIPE.TrainType = ent_type
    
    RECIPE.Init = RECIPE.Init or function() end
    RECIPE.Inject = RECIPE.Inject or function() end
    RECIPE.InjectSpawner = RECIPE.InjectSpawner or function() end

    MetrostroiExtensions.Recipes[RECIPE_NAME] = RECIPE
    -- initialize recipe
    initRecipe(RECIPE)

	RECIPE = nil
end

function initRecipe(recipe)
    recipe:Init()
    -- add it to inject stack
    MetrostroiExtensions.InjectStack:Push(recipe)
end

-- lookup table for train families
local train_families = {
    -- for 717 we don't need to modify _custom entity, cause it's used just for spawner
    ["717"] = {
        "gmod_subway_81-717_lvz",
        "gmod_subway_81-717_mvm",
    }
}

function getEntsByTrainType(train_type)
    -- firstly, check for "all" train_type
    if train_type == "all" then
        return Metrostroi.TrainClasses
    end
    -- then try to find it as entity class
    if table.HasValue(Metrostroi.TrainClasses, train_type) then
        return {train_type}
    end
    -- then try to check it in lookup table
    -- why? just imagine 717: we have 5p, we have some other modifications
    -- and you probably don't want to have a new default 717 cabine in 7175p
    if train_families[train_type] then
        return train_families[train_type]
    end
    -- and finally try to find by searching train family in classname
    local ent_classes = {}
    for _, ent_class in pairs(Metrostroi.TrainClasses) do
        local contains_train_type, _ = string.find(ent_class, train_type)
        if contains_train_type then
            table.insert(ent_classes, ent_class)
        end
    end
    if #ent_classes == 0 then
        ErrorNoHalt("[MetrostroiExtensions] No entites for "..train_type..". Perhaps a typo?")
    end
    return ent_classes
end

function getTrainEntTables()
    for _, ent_class in pairs(Metrostroi.TrainClasses) do
        local ent_table = scripted_ents.GetStored(ent_class).t
        ent_table.ent_class = ent_class  -- add ent_class for convience
        MetrostroiExtensions.ent_tables[ent_class] = ent_table 
    end
end

function inject()
    -- method that finalizes inject on all trains. called after init of recipies
    for i = 1, MetrostroiExtensions.InjectStack:Size() do
        local recipe = MetrostroiExtensions.InjectStack:Pop()
        -- call Inject method on every ent that recipe changes
        for _, ent_class in pairs(getEntsByTrainType(recipe.TrainType)) do
            recipe:InjectSpawner(ent_class)
            recipe:Inject(MetrostroiExtensions.ent_tables[ent_class], ent_class)
            if MetrostroiExtensions.Debug then
                -- call Inject method on all alredy spawner ent that recipe changes (if debug enabled)
                for _, ent in ipairs(ents.FindByClass(ent_class) or {}) do
                    recipe:Inject(ent, ent_class)
                end
            end
        end
        
    end
    for ent_class, ent_table in pairs(MetrostroiExtensions.ent_tables) do
        if MetrostroiExtensions.RandomFields[ent_class] then
            -- add helper inject to server TrainSpawnerUpdate in order to automaticly handle random value
            -- hack. iknowiknowiknow its bad
            if ent_class == "gmod_subway_81-717_mvm_custom" then ent_class_inject = "gmod_subway_81-717_mvm" else ent_class_inject = ent_class end
            MetrostroiExtensions.InjectIntoServerFunction(ent_class_inject, "TrainSpawnerUpdate", function(self)
                for _, data in pairs(MetrostroiExtensions.RandomFields[ent_class]) do
                    local key = data[1]
                    local amount_of_values = data[2]
                    local value = self:GetNW2Int(key, 1)
                    if value == 1 then
                        value = math.random(2, amount_of_values)
                    end
                    self:SetNW2Int(key, value - 1)
                end
            end)
        end
        if MetrostroiExtensions.ClientPropsToReload[ent_class] then
            -- add helper inject to server UpdateWagonNumber in order to reload all models, that we should
            if ent_class == "gmod_subway_81-717_mvm_custom" then ent_class_inject = "gmod_subway_81-717_mvm" else ent_class_inject = ent_class end
            MetrostroiExtensions.InjectIntoClientFunction(ent_class_inject, "UpdateWagonNumber", function(self)
                for key, props in pairs(MetrostroiExtensions.ClientPropsToReload[ent_class]) do
                    local value = self:GetNW2Int(key, 1)
                    if MetrostroiExtensions.Debug or self[key] ~= value then
                        for _, prop_name in pairs(props) do
                            self:RemoveCSEnt(prop_name)
                        end
                        self[key] = value
                    end
                end
            end)
        end
        if MetrostroiExtensions.FunctionInjectStack[ent_class] then
            -- yep, this is O(N^2). funny, cause there is probably better way to achieve priority system
            for function_name, priorities in pairs(MetrostroiExtensions.FunctionInjectStack[ent_class]) do
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
                    ErrorNoHalt("[MetrostroiExtensions] Can't inject into "..ent_class..": function "..function_name.." doesn't exists\n")
                    continue
                end
                if not ent_table["Default"..function_name] then
                    ent_table["Default"..function_name] = ent_table[function_name]
                end
                ent_table[function_name] = function(self)
                    for i = #before_stack, 1, -1 do
                        for _, inject_function in pairs(before_stack[i]) do
                            inject_function(self)
                        end
                    end
                    local ret_val = ent_table["Default"..function_name](self)
                    for i = 1, #after_stack do
                        for _, inject_function in pairs(after_stack[i]) do
                            inject_function(self, ret_val)
                        end
                    end
                    return ret_val
                end
                if MetrostroiExtensions.Debug then
                    -- reinject function on all already spawned ents
                    for _, ent in ipairs(ents.FindByClass(ent_class) or {}) do
                        ent[function_name] = function(self)
                            for i = #before_stack, 1, -1 do
                                for _, inject_function in pairs(before_stack[i]) do
                                    inject_function(self)
                                end
                            end
                            local ret_val = ent["Default"..function_name](self)
                            for i = 1, #after_stack do
                                for _, inject_function in pairs(after_stack[i]) do
                                    inject_function(self, ret_val)
                                end
                            end
                            return ret_val
                        end
                    end
                end
            end
        end
    end
end

-- load all recipies
local _, folders = file.Find("recipies/*", "LUA")

for _, folder in pairs(folders) do
    local train_type = folder
    local files, _ = file.Find("recipies/"..folder.."/*.lua", "LUA")
    for _, File in pairs(files) do
        if not File then -- for some reason, File can be nil...
            continue 
        end
        loadRecipe(File, train_type)
    end
end
-- injection logic
-- debug uses timers as inject logic
-- production uses hook GM:InitPostEntity
if MetrostroiExtensions.Debug then
    timer.Simple(1.3, function()
        getTrainEntTables()
        inject()
    end)
else
    error("not implemented")
end

-- reload command:
-- reloads all recipies on client and server
if SERVER then
    util.AddNetworkString("MetrostroiExtDoReload")
    concommand.Add( "metrostroi_ext_reload", function( ply, cmd, args )
        net.Start("MetrostroiExtDoReload")
        net.Broadcast()
        print("[MetrostroiExtensions] Reloading recipies...")
        -- clear all inject stacks
        MetrostroiExtensions.InjectStack = util.Stack()
        MetrostroiExtensions.FunctionInjectStack = {}
        MetrostroiExtensions.ClientPropsToReload = {}
        MetrostroiExtensions.RandomFields = {}
        for _, recipe in pairs(MetrostroiExtensions.Recipes) do
            initRecipe(recipe)
        end
        getTrainEntTables()
        inject()
    end )
end
if CLIENT then
    net.Receive( "MetrostroiExtDoReload", function( len, ply )
        print("[MetrostroiExtensions] Reloading recipies...")
        -- clear all inject stacks
        MetrostroiExtensions.InjectStack = util.Stack()
        MetrostroiExtensions.FunctionInjectStack = {}
        MetrostroiExtensions.ClientPropsToReload = {}
        MetrostroiExtensions.RandomFields = {}
        for _, recipe in pairs(MetrostroiExtensions.Recipes) do
            initRecipe(recipe)
        end
        getTrainEntTables()
        inject()
        -- try to reload all spawned trains csents and buttonmaps
        for k, v in ipairs(ents.FindByClass( "gmod_subway_*" )) do
            v.ClientPropsInitialized = false
            v:ClearButtons()
        end
    end )
end


