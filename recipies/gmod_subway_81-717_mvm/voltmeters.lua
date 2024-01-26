MetrostroiExtensions.DefineRecipe("voltmeters")
local MODELS_ROOT = "models/metrostroiextensions/81-717/"

function RECIPE:InjectSpawner(entclass)
    MetrostroiExtensions.AddSpawnerField("gmod_subway_81-717_mvm_custom", {
        [1] = "VoltmeterType",
        [2] = "Spawner.717.VoltmeterType",
        [3] = "List",
        [4] = {"Spawner.717.Common.Random", "Spawner.717.Voltmeter.Default", "Spawner.717.Voltmeter.Round"}
    }, true)
end

function RECIPE:Inject(ent, entclass)
    MetrostroiExtensions.NewClientProp(ent, "voltmeter", {
        model = MODELS_ROOT.."voltmeters/Voltmeters_Default.mdl",
        pos = Vector(0,0,0),
        ang = Angle(0,0,0),
        modelcallback = function(_ent)
            local voltmeters = {
                [1] = "voltmeters/Voltmeters_Default.mdl",
                [2] = "voltmeters/Voltmeters_Round1.mdl"
            }
            print(_ent:GetNW2Int("VoltmeterType", 1))
            return MODELS_ROOT..voltmeters[_ent:GetNW2Int("VoltmeterType", 1)]
        end
    }, "VoltmeterType")
end
