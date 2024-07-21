MEL.DefineRecipe("all_rendermode_none", "all")

function RECIPE:Inject(ent, entclass)
    -- we just hide ALL seats. cause fuck metrostroi.
    MEL.InjectIntoServerFunction(ent, "Initialize", function(wagon)
        for _, obj in pairs(wagon:GetTable()) do
            if isentity(obj) and obj:IsVehicle() then
                local seat = obj
                seat:SetRenderMode(RENDERMODE_NONE)
                seat:GetPhysicsObject():EnableCollisions(false)
                seat:DrawShadow(false)
            end
        end
    end, 10)
end
