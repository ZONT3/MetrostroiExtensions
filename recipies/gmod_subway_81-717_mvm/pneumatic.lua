MetrostroiExtensions.DefineRecipe("pneumatic")
local MODELS_ROOT = "models/metrostroi_extensions/81-717/"

function RECIPE:Init()
end

function RECIPE:Inject(ent, entclass)
    MetrostroiExtensions.UpdateModelCallback(ent, "brake_valve_013", function(ent)
        return MODELS_ROOT.."pneumatic/pneumatic_013_pipes1.mdl"
    end)
    MetrostroiExtensions.UpdateCallback(ent, "brake_valve_013", function(ent, cent)
        cent:SetPos(ent:LocalToWorld(Vector(431.059, -32.6815, -30.4057)))
    end)
    MetrostroiExtensions.UpdateModelCallback(ent, "brake013", function(ent)
        return MODELS_ROOT.."pneumatic/pneumatic_013_handle1.mdl"
    end)
    MetrostroiExtensions.UpdateCallback(ent, "brake013", function(ent, cent)
        cent:SetPos(ent:LocalToWorld(Vector(431.09, -20.3065, -7.20722)))
    end)
    MetrostroiExtensions.UpdateModelCallback(ent, "EPV_disconnect", function(ent)
        return MODELS_ROOT.."pneumatic/pneumatic_013_pipes1_crane3.mdl"
    end)
    MetrostroiExtensions.UpdateCallback(ent, "EPV_disconnect", function(ent, cent)
        cent:SetPos(ent:LocalToWorld(Vector(428.908, -41.2631, -37.6619)))
        cent:SetAngles(ent:LocalToWorldAngles(Angle(0, 0, -15)))
    end)
    MetrostroiExtensions.UpdateModelCallback(ent, "valve_disconnect", function(ent)
        return MODELS_ROOT.."pneumatic/pneumatic_013_pipes1_crane1.mdl"
    end)
    MetrostroiExtensions.UpdateCallback(ent, "valve_disconnect", function(ent, cent)
        cent:SetPos(ent:LocalToWorld(Vector(429.561, -21.8424, -32.4603)))
        cent:SetAngles(ent:LocalToWorldAngles(Angle(0, 0, 0)))
    end)
    MetrostroiExtensions.UpdateModelCallback(ent, "parking_brake", function(ent)
        return MODELS_ROOT.."pneumatic/pneumatic_013_pipes1_crane2.mdl"
    end)
    MetrostroiExtensions.UpdateCallback(ent, "parking_brake", function(ent, cent)
        cent:SetPos(ent:LocalToWorld(Vector(433.97, -23.9104, -38.7451)))
        cent:SetAngles(ent:LocalToWorldAngles(Angle(0, 90, 0)))
    end)
    MetrostroiExtensions.NewClientProp(ent, "horn_crane", {
        model = MODELS_ROOT.."pneumatic/pneumatic_013_pipes1_crane4.mdl",
        pos = Vector(454.052, -5.84146, -31.7479),
        ang = Angle(0,0,0),
    })
    MetrostroiExtensions.UpdateModelCallback(ent, "UAVALever", function(ent)
        return MODELS_ROOT.."pneumatic/pneumatic_pipes1_lever_uava.mdl"
    end)
    MetrostroiExtensions.UpdateCallback(ent, "UAVALever", function(ent, cent)
        cent:SetPos(ent:LocalToWorld(Vector(425.131, -58.714, -32.0369)))
        cent:SetAngles(ent:LocalToWorldAngles(Angle(0, 0, 0)))
    end)
    MetrostroiExtensions.NewClientProp(ent, "UAVAcap", {
        model = MODELS_ROOT.."pneumatic/pneumatic_pipes1_cap_uava.mdl",
        pos = Vector(418.022, -58.1148, -26.6543),
        ang = Angle(0,0,0),
    })
    MetrostroiExtensions.InjectIntoClientFunction(ent, "Think", function(self)
        self:Animate("UAVALever",   self:GetPackedBool("UAVA") and 1 or 0,0,1, 1,  3,false)
    end, 1)
end
