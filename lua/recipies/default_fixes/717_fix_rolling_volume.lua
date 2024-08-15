MEL.DefineRecipe("717_fix_rolling_volume", "717_714_mvm")
function RECIPE:Inject(ent)
    MEL.InjectIntoSharedFunction(ent, "InitializeSounds", function(wagon)
        wagon.SoundPositions["rolling_10"][4] = 0.2
        if wagon.SoundPositions["rolling_32"] then wagon.SoundPositions["rolling_32"][4] = 0.4 end
    end, 1)
end
