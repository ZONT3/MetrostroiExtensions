MEL.DefineRecipe("714_add_lvz_flag", "gmod_subway_81-714_mvm")
function RECIPE:Inject(ent, entclass)
    MEL.InjectIntoServerFunction(ent, "TrainSpawnerUpdate", function(wagon)
        if wagon.CustomSettings then
            wagon:SetNW2Bool("LVZ", wagon:GetNW2Int("BodyType") == 2)
        end
    end)
end
