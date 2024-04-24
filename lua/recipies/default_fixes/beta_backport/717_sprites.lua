MEL.DefineRecipe("717_sprites", "gmod_subway_81-717_mvm")
function RECIPE:Inject(ent)
    if SERVER then return end
    for i, button in pairs(ent.ButtonMap.Block5_6.buttons) do
        if button.ID == "!L1Light" then
            button.model = table.Copy(ent.ButtonMapCopy.Block5_6.buttons[i].model)
            button.model.sprite = {
                bright = 0.5,
                size = .5,
                scale = 0.03,
                z = 20,
                color = Color(255, 60, 40)
            }
        end
    end
    Metrostroi.GenerateClientProps(ent)
end

function RECIPE:InjectNeeded()
    if Metrostroi.Version > 1537278077 then
        return false
    end
    return true
end