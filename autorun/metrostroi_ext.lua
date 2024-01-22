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
    print("[MetrostroiExtensions] Loading recipe "..name)
    RECIPE.ClassName = name
    RECIPE.TrainType = ent_type
    
    RECIPE.Init = RECIPE.Init or function() end

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
        ErrorNoHalt("[MetrostroiExtensions] No entites for "..train_type..". Perhaps an typo?")
    end
    return ent_classes
end

function inject()
    -- getting all train entity tables
    local ent_tables = {}
    for _, ent_class in pairs(Metrostroi.TrainClasses) do
        ent_tables[ent_class] = scripted_ents.GetStored(ent_class).t
    end
    -- call Inject method on every ent that recipe changes
    for i = 1, MetrostroiExtensions.InjectStack:Size() do
        local recipe = MetrostroiExtensions.InjectStack:Pop()
        for _, ent_class in pairs(getEntsByTrainType(recipe.TrainType)) do
            recipe:Inject(ent_tables[ent_class], ent_class)
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
    timer.Simple(0.3, function()
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
        for _, recipe in pairs(MetrostroiExtensions.Recipes) do
            initRecipe(recipe)
            inject()
        end
    end )
end
if CLIENT then
    net.Receive( "MetrostroiExtDoReload", function( len, ply )
        print("[MetrostroiExtensions] Reloading recipies...")
        for _, recipe in pairs(MetrostroiExtensions.Recipes) do
            initRecipe(recipe)
            inject()
        end    
    end )
end


-- helper methods

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
        ent.ClientProps[clientprop_name]["modelcallback"] = function(ent)
            local new_modelpath = new_modelcallback(ent)
            return new_modelpath or old_modelcallback(ent)
        end
    end
end