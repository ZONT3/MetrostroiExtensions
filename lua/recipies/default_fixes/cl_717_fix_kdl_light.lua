MEL.DefineRecipe("717_fix_kdl_light", "gmod_subway_81-717_mvm")
function RECIPE:Inject(ent)
    -- TODO: make this work...
    -- in default MS KDLSet and KDLRSet have too big lfar, and cause of that we can see light from it on PB
    MEL.ModifyButtonMap(ent, "Block5_6", function() end, function(button) if button.ID == "KDLSet" or button.ID == "KDLRSet" then button.model.lamp.lfar = 2 end end)
    MEL.ModifyButtonMap(ent, "Block7", function() end, function(button) if button.ID == "KDPSet" then button.model.lamp.lfar = 2 end end)
end
