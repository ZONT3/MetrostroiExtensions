MetrostroiExtensions.DefineRecipe("rendermode_none")

function RECIPE:Init()
end

function RECIPE:Inject(ent, entclass)
    MetrostroiExtensions.InjectIntoServerFunction(ent, "Initialize", function(self)
        for _, key in pairs(table.GetKeys(self:GetTable())) do
            if isentity(self[key]) and self[key]:IsVehicle() then
                local seat = self[key]
                seat:SetRenderMode(RENDERMODE_NONE)
                seat:GetPhysicsObject():EnableCollisions(false)
                seat:DrawShadow(false)
                seat:SetNoDraw(true)
            end
        end
    end, 10)
end
