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
function injectIntoEntFunction(entclass, function_name, function_to_inject, priority)
        -- negative priority - inject before default function
        -- positive priority - inject after default function
        -- zero - default function priority, error!
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

function MetrostroiExtensions.MarkClientPropForReload(entclass, clientprop_name, field_name)
    --[[
        Marks props for reload on spawner update. Only works then debug is enabled, if field_name is not set.
        Args:
            * entclass: entity class of train where we should reload this prop on
            * clientprop_name: name of client prop
            * field_name: if this set, then this prop will be reloaded only then value of spawner field with field_name is changed
        Scope: Client
    ]]
    if not MetrostroiExtensions.ClientPropsToReload[entclass] then
        MetrostroiExtensions.ClientPropsToReload[entclass] = {}
    end
    if not field_name then field_name = "debug_reload" end
    if not MetrostroiExtensions.ClientPropsToReload[entclass][field_name] then
        MetrostroiExtensions.ClientPropsToReload[entclass][field_name] = {}
    end
    table.insert(MetrostroiExtensions.ClientPropsToReload[entclass][field_name], clientprop_name)
end

function MetrostroiExtensions.InjectIntoENTClientFunction(entclass, function_name, function_to_inject, priority)
    --[[
        Injects into default ENT client method.
        Args:
            * entclass: entity class of train where we should inject into function
            * function_name: name of function, where you want to inject to
            * function_to_inject: function, that you want to inject. Recieves ent (usually we call it self) and all arguments of default function.
            * priority: priority in function inject stack.
                Functions with negative priority will be called BEFORE default function, and lower values will be called sooner (-100 will be called sooner, than -10)
                Functions with positive priority will be called AFTER default function, and higher values will be called sooner (100 will be called sooner, than 10)
                Functions with same priority will be called in order, that they was injected.
                Priority can't be zero. If priority isn't specified, it defaults to -1 (e.g. function will be called just before calling default function)
        Scope: Client
    ]]
    if SERVER then return end
    injectIntoEntFunction(entclass, function_name, function_to_inject, priority)
end

function MetrostroiExtensions.InjectIntoENTServerFunction(entclass, function_name, function_to_inject, priority)
    --[[
        Injects into default ENT server method.
        Args:
            * entclass: entity class of train where we should inject into function
            * function_name: name of function, where you want to inject to
            * function_to_inject: function, that you want to inject. Recieves ent (usually we call it self) and all arguments of default function.
            * priority: priority in function inject stack.
                Functions with negative priority will be called BEFORE default function, and lower values will be called sooner (-100 will be called sooner, than -10)
                Functions with positive priority will be called AFTER default function, and higher values will be called sooner (100 will be called sooner, than 10)
                Functions with same priority will be called in order, that they was injected.
                Priority can't be zero. If priority isn't specified, it defaults to -1 (e.g. function will be called just before calling default function)
        Scope: Server
    ]]
    if CLIENT then return end
    injectIntoEntFunction(entclass, function_name, function_to_inject, priority)
end

function MetrostroiExtensions.InjectIntoTrainSpawnerUpdate(entclass, function_to_inject, priority)
    --[[
        Injects into default TrainSpawnerUpdate server method. Called on every update by train spawner
        Args:
            * entclass: entity class of train where we should inject into function
            * function_to_inject: function, that you want to inject. Recieves all arguments of default function.
            * priority: priority in function inject stack.
                Functions with negative priority will be called BEFORE default function, and lower values will be called sooner (-100 will be called sooner, than -10)
                Functions with positive priority will be called AFTER default function, and higher values will be called sooner (100 will be called sooner, than 10)
                Functions with same priority will be called in order, that they was injected.
                Priority can't be zero. If priority isn't specified, it defaults to -1 (e.g. function will be called just before calling default function)
        Scope: Server
    ]]
    MetrostroiExtensions.InjectIntoENTServerFunction(entclass, "TrainSpawnerUpdate", function_to_inject, priority)
end

function MetrostroiExtensions.InjectIntoUpdateWagonNumber(entclass, function_to_inject, priority)
    --[[
        Injects into default TrainSpawnerUpdate client method. Called on every update by train spawner
        Args:
            * entclass: entity class of train where we should inject into function
            * function_to_inject: function, that you want to inject. Recieves all arguments of default function.
            * priority: priority in function inject stack.
                Functions with negative priority will be called BEFORE default function, and lower values will be called sooner (-100 will be called sooner, than -10)
                Functions with positive priority will be called AFTER default function, and higher values will be called sooner (100 will be called sooner, than 10)
                Functions with same priority will be called in order, that they was injected.
                Priority can't be zero. If priority isn't specified, it defaults to -1 (e.g. function will be called just before calling default function)
        Scope: Client
    ]]
    MetrostroiExtensions.InjectIntoENTClientFunction(entclass, "UpdateWagonNumber", function_to_inject, priority)
end

function MetrostroiExtensions.InjectIntoClientThink(entclass, function_to_inject, priority)
    --[[
        Injects into default Think client method. Called on every tick
        Args:
            * entclass: entity class of train where we should inject into function
            * function_to_inject: function, that you want to inject. Recieves all arguments of default function.
            * priority: priority in function inject stack.
                Functions with negative priority will be called BEFORE default function, and lower values will be called sooner (-100 will be called sooner, than -10)
                Functions with positive priority will be called AFTER default function, and higher values will be called sooner (100 will be called sooner, than 10)
                Functions with same priority will be called in order, that they was injected.
                Priority can't be zero. If priority isn't specified, it defaults to -1 (e.g. function will be called just before calling default function)
        Scope: Client
    ]]
    MetrostroiExtensions.InjectIntoENTClientFunction(entclass, "Think", function_to_inject, priority)
end

function MetrostroiExtensions.AddSpawnerField(entclass, field_data, is_list_random)
    --[[
        Adds a new field to ent spawner. Automaticly re-adds this field on reload.
        Args:
            * entclass: entity class of train, where we should add a new field. For 717 you probably want to use "gmod_subway_81-717_mvm_custom"
            * field_data: field data in default metrostroi format
                [1]* - field name
                [2]* - display name as translation string (Spawner.{TrainType}.{FieldName}) (can be anything, actually)
                [3]* - type of field ("List", "Boolean" or "Slider")
                for list:
                    [4]* - list items as strings (can be translation strings (and probably should))
                        If your first list value is random - set is_list_random as true.
                        This will automaticly get random value for this setting for you.
                    [5] - default value as index of list item
                    [6] - callback function, that will be called on every ent in train. Recieves ent, field_value, is_rotated, index_of_wagon, total_wagons 
                    [7] - settings table
                for slider:
                    [4]* - decimal places (see DNumSliders:SetDecimals)
                    [5]* - min value
                    [6]* - max value
                    [7] - default value as number
                    [8] - callback function. See list [6] for function signature.
                for boolean:
                    [4] - default value as true or false
                    [5] - callback function. See list [6] for function signature.
                    [6] - callback function for GUI. Called on change of value. Recieves DCheckBox and VGUI.
                if [1] is number, than break will be added [1] times
                if field is empty table, break will be added one time
        Scope: Shared
    ]]
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
    --[[
        Updates modelcallback of existing ClientProp. Use this function for changing existing model.
        Args:
            * ent: entity of train where we should update clientprop modelcallback
            * clientprop_name: clientprop name
            * new_modelcallback: function, that recieves ent and should return new modelpath for that clientprop.
                Return nil, if you want to use default value of default modelcallback
        Scope: Client
    ]]
    if CLIENT and istable(ent) then
        local old_modelcallback = ent.ClientProps[clientprop_name]["modelcallback"] or function() end
        ent.ClientProps[clientprop_name]["modelcallback"] = function(self)
            local new_modelpath = new_modelcallback(self)
            return new_modelpath or old_modelcallback(self)
        end
    end
end

function MetrostroiExtensions.UpdateCallback(ent, clientprop_name, new_callback)
    --[[
        Inject into callback of existing ClientProp. Use this function for changing spawner prop somehow.
        Args:
            * ent: entity of train where we should update clientprop modelcallback
            * clientprop_name: clientprop name
            * new_callback: function, that recieves wagon ent and ent of prop.
        Scope: Client
    ]]
    if CLIENT and istable(ent) then
        local old_callback = ent.ClientProps[clientprop_name]["modelcallback"] or function() end
        ent.ClientProps[clientprop_name]["callback"] = function(self, cent)
            old_callback(self, cent)
            new_callback(self, cent)
        end
    end
end

function MetrostroiExtensions.NewClientProp(ent, clientprop_name, clientprop_info, field_name)
    --[[
        Adds new clientprop to entity. 
        Args:
            * ent: entity of train where we should add new clientprop
            * clientprop_name: clientprop name
            * clientprop_info: clientprop info in default metrostroi format
                model - model of this clientprop
                modelcallback - callback to change model dynamicly. Recieves wagon ent.
                    Should return path to a model to use.
                    If callback returns nil, default model will be used.
                pos - position of prop local to wagon ent
                ang - angle of prop local to wagon ent
                skin - skin of prop (defaults to 0)
                scale - scale of prop
                bscale - scale of bone with id=0. See Entity:ManipulateBoneScale
                bodygroup - table of bodygroups, where key - is bodygroup id, and value - is bodygroup value
                color - color of prop
                colora - color of prop with alpha value
                callback - callback, that recieves wagon ent and newly created prop. Called after creation of prop.
                nohide - flag to not hide this entity
                hide - if this value set, it would be used as coef for renderDistance
                    (in simpler words - from what distance we should hide this ent)
                hideseat - if this value set, then if player is in seat of other wagon this value would be used same as hide
            * field_name: if this set, then this model will be reloaded on update of spawner field with field_name
        Scope: Client
    ]]
    if CLIENT and istable(ent) then
        ent.ClientProps[clientprop_name] = clientprop_info
    end
    if field_name then
        MetrostroiExtensions.MarkClientPropForReload(ent.ent_class, clientprop_name, field_name)
    end
end

function MetrostroiExtensions.NewButtonMap(ent, buttonmap_name, buttonmap_info)
    --[[
        Adds new buttonmap to entity. 
        Args:
            * ent: entity of train where we should add new buttonmap
            * buttonmap_name: clientprop name
            * buttonmap_info: clientprop info in default metrostroi format
                pos - position of buttonmap local to wagon ent
                ang - angle of prop local to wagon ent
                width - width of buttonmap
                height - width of buttonmap
                scale - scale of buttonmap
                sensor -  ¯\_(ツ)_/¯
                system -  ¯\_(ツ)_/¯
                hide - if this value set, it would be used as coef for renderDistance
                    (in simpler words - from what distance we should hide this ent)
                hideseat - if this value set, then if player is in seat of other wagon this value would be used same as hide
                buttons: table of buttons, with format like this:
                    *ID - id of a button
                    x - x coordinate of button local to buttonmap
                    y - y coordinate of button local to buttonmap
                    radius - interaction radius of button, used if w or h is not set
                    w - width of interaction zone
                    h - height of interaction zone
                    tooltip - fallback tooltip. You probably want to set empty string ("") and provide tooltip in translations
                    model:
                        name - name of button model. Defaults to button id
                        model - model of button. Defaults to models/metrostroi/81-717/button07.mdl
                        pos - position of button model. Defaults to position of button. 
                        ang - angle of button model relative to buttonmap. 
                        color - color of button model
                        colora - color of button model with alpha value
                        skin - skin of button model
                        hide - if this value set, it would be used as coef for renderDistance
                            (in simpler words - from what distance we should hide this ent)
                        hideseat - if this value set, then if player is in seat of other wagon this value would be used same as hide
                        scale - scale of button
                        bscale - scale of bone with id=0. See Entity:ManipulateBoneScale
                        vmin - start value of animation used in getfunc
                        vmax - end value of animation used in getfunc
                        min - start value of animation
                        max - end value of animation
                        speed - speed of animation
                        damping - damping of animation
                        stickyness - stickyness of animation
                        var - NW2 bool, that will be used for animation of this model
                        getfunc - function, to get bool for animation. Recieves ent, vmin, vmax, var
                        disable - if current button toggled, than this button will be hidden. Useful for krishki
                        disableinv - same as disabled, but inverted
                        disableoff and disableon - if current button is off, than disableoff will be hidden. if current button is on, than disableon will be hidden.
                        disablevar - if this var is true, then current button will be disabled
                        sound - id of sound. defaults to ID



            * field_name: if this set, then this model will be reloaded on update of spawner field with field_name
        Scope: Client
    ]]
    if CLIENT and istable(ent) then
        ent.ClientProps[clientprop_name] = clientprop_info
    end
    if field_name then
        MetrostroiExtensions.MarkClientPropForReload(ent.ent_class, clientprop_name, field_name)
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
    -- firstly, try to find it as entity class
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

function get_train_ent_tables()
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
        end
    end
    for ent_class, ent_table in pairs(MetrostroiExtensions.ent_tables) do
        if MetrostroiExtensions.RandomFields[ent_class] then
            -- add helper inject to server TrainSpawnerUpdate in order to automaticly handle random value
            -- hack. iknowiknowiknow its bad
            if ent_class == "gmod_subway_81-717_mvm_custom" then ent_class_inject = "gmod_subway_81-717_mvm" else ent_class_inject = ent_class end
            MetrostroiExtensions.InjectIntoTrainSpawnerUpdate(ent_class_inject, function(self)
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
            MetrostroiExtensions.InjectIntoUpdateWagonNumber(ent_class_inject, function(self)
                for key, props in pairs(MetrostroiExtensions.ClientPropsToReload[ent_class]) do
                    local value = self:GetNW2Int(key, 1)
                    if self[key] ~= value then
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
                print(function_name)
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
        get_train_ent_tables()
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
        get_train_ent_tables()
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
        get_train_ent_tables()
        inject()
    end )
end


