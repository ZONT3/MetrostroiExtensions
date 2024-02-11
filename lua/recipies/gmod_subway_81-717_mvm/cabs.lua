MetrostroiExtensions.DefineRecipe("cabs")
local MODELS_ROOT = "models/metrostroi_extensions/81-717/"

function RECIPE:Init()
end

function RECIPE:Inject(ent, entclass)
    MetrostroiExtensions.UpdateModelCallback(ent, "cabine_mvm", function(ent)
        return MODELS_ROOT.."cabine_mvm.mdl"
    end)
    MetrostroiExtensions.UpdateModelCallback(ent, "cabine_lvz", function(ent)
        return MODELS_ROOT.."cabine_lvz.mdl"
    end)
end
