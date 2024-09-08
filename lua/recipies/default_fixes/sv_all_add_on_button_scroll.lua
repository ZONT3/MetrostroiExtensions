MEL.DefineRecipe("all_add_on_button_scroll", "all")
function RECIPE:Inject(ent, entclass)
    function ent.OnButtonScroll(wagon, button, delta, ply)
    end
end
