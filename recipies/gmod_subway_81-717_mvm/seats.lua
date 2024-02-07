MetrostroiExtensions.DefineRecipe("cabs")
local MODELS_ROOT = "models/metrostroi_extensions/81-717/"

function RECIPE:InjectSpawner(entclass)
    MetrostroiExtensions.AddSpawnerField("gmod_subway_81-717_mvm_custom", {
        [1] = "SeatType",
        [2] = "Spawner.717.SeatType",
        [3] = "List",
        [4] = {"Spawner.717.Common.Random", "Spawner.717.Seat.Type1", "Spawner.717.Seat.Type2"}
    }, true)
end

function RECIPE:Inject(ent, entclass)
end
