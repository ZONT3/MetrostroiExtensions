MetrostroiExtensions.DefineRecipe("rendermode_none")

function RECIPE:Init()
end

function RECIPE:Inject(ent, entclass)
    MetrostroiExtensions.InjectIntoServerFunction(ent, "Initialize", function(self)
        for _, obj in pairs(self:GetTable()) do
            if isentity(obj) and obj:IsVehicle() then
                local seat = obj
                seat:SetRenderMode(RENDERMODE_NONE)
                seat:GetPhysicsObject():EnableCollisions(false)
                seat:DrawShadow(false)
                seat:SetNoDraw(true)
            end
        end
    end, 10)
end
