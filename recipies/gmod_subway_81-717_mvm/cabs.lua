MetrostroiExtensions.DefineRecipe("cabs")
local MODELS_ROOT = "models/metrostroiextensions/81-717/"

function RECIPE:Init()
end

function RECIPE:Inject(ent, entclass)
    MetrostroiExtensions.UpdateModelCallback(ent, "cabine_mvm", function(ent)
        return MODELS_ROOT.."base_mvm.mdl"
    end)
    MetrostroiExtensions.UpdateModelCallback(ent, "cabine_lvz", function(ent)
        return MODELS_ROOT.."base_lvz.mdl"
    end)
end
