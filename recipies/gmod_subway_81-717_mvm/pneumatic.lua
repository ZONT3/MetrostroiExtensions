MetrostroiExtensions.DefineRecipe("pneumatic")
local MODELS_ROOT = "models/metrostroi_extensions/81-717/"

function RECIPE:Init()
end

function RECIPE:Inject(ent, entclass)
    -- pipes
    MetrostroiExtensions.UpdateModelCallback(ent, "brake_valve_013", function(ent)
        return MODELS_ROOT.."pneumatic/pneumatic_013_pipes1.mdl"
    end)
    MetrostroiExtensions.UpdateCallback(ent, "brake_valve_013", function(ent, cent)
        cent:SetPos(ent:LocalToWorld(Vector(431.059, -32.6815, -30.4057)))
    end)
    -- 013
    MetrostroiExtensions.UpdateModelCallback(ent, "brake013", function(ent)
        return MODELS_ROOT.."pneumatic/pneumatic_013_handle1.mdl"
    end)
    MetrostroiExtensions.UpdateCallback(ent, "brake013", function(ent, cent)
        cent:SetPos(ent:LocalToWorld(Vector(431.09, -20.3065, -7.20722)))
    end)
    -- EPV
    MetrostroiExtensions.MoveButtonMap(ent, "EPVDisconnect", Vector(430,-38,-45), Angle(270, -50, 0))
    MetrostroiExtensions.UpdateModelCallback(ent, "EPV_disconnect", function(ent)
        return MODELS_ROOT.."pneumatic/pneumatic_013_pipes1_crane3.mdl"
    end)
    MetrostroiExtensions.UpdateCallback(ent, "EPV_disconnect", function(ent, cent)
        cent:SetPos(ent:LocalToWorld(Vector(428.908, -41.2631, -37.6619)))
        cent:SetAngles(ent:LocalToWorldAngles(Angle(0, 0, -15)))
    end)
    -- driver valve
    MetrostroiExtensions.MoveButtonMap(ent, "DriverValveDisconnect", Vector(425,-23,-26))
    MetrostroiExtensions.UpdateModelCallback(ent, "valve_disconnect", function(ent)
        return MODELS_ROOT.."pneumatic/pneumatic_013_pipes1_crane1.mdl"
    end)
    MetrostroiExtensions.UpdateCallback(ent, "valve_disconnect", function(ent, cent)
        cent:SetPos(ent:LocalToWorld(Vector(429.561, -21.8424, -32.4603)))
        cent:SetAngles(ent:LocalToWorldAngles(Angle(0, 50, 0)))
    end)
    -- parking brake
    MetrostroiExtensions.MoveButtonMap(ent, "ParkingBrake", Vector(430, -20.5, -38), Angle(0, 0, 0))
    MetrostroiExtensions.UpdateModelCallback(ent, "parking_brake", function(ent)
        return MODELS_ROOT.."pneumatic/pneumatic_013_pipes1_crane2.mdl"
    end)
    MetrostroiExtensions.UpdateCallback(ent, "parking_brake", function(ent, cent)
        cent:SetPos(ent:LocalToWorld(Vector(433.97, -23.9104, -38.7451)))
        cent:SetAngles(ent:LocalToWorldAngles(Angle(0, 90, 0)))
    end)
    -- horn crane
    MetrostroiExtensions.NewClientProp(ent, "horn_crane", {
        model = MODELS_ROOT.."pneumatic/pneumatic_013_pipes1_crane4.mdl",
        pos = Vector(454.052, -5.84146, -31.7479),
        ang = Angle(0,0,0),
    })
    -- UAVA
    MetrostroiExtensions.UpdateCallback(ent, "UAVALever", function(ent, cent)
        ent:ShowHide("UAVALever", false)
    end)
    MetrostroiExtensions.MoveButtonMap(ent, "UAVAPanel", Vector(426,-57,-25))
    MetrostroiExtensions.NewClientProp(ent, "UAVALever_new", {
        model = MODELS_ROOT.."pneumatic/pneumatic_pipes1_lever_uava.mdl",
        pos = Vector(425.131, -58.714, -32.0369),
        ang = Angle(0,0,0),
        hideseat=0.2,
    })
    MetrostroiExtensions.NewClientProp(ent, "UAVA_cap", {
        model = MODELS_ROOT.."pneumatic/pneumatic_pipes1_cap_uava.mdl",
        pos = Vector(418.022, -58.1148, -26.6543),
        ang = Angle(0,0,0),
        hideseat=0.2,
    })
    MetrostroiExtensions.InjectIntoServerFunction(ent, "Think", function(self)
        self:SetPackedBool("UAVA_cap", self.UAVAContact.Value > 0.5)
    end)
    MetrostroiExtensions.InjectIntoClientFunction(ent, "Think", function(self)
        self:Animate("UAVALever_new",   self:GetPackedBool("UAVA") and 1 or 0, 0, 1, 64, 0.8)
        self:Animate("UAVA_cap", self:GetPackedBool("UAVA_cap") and 1 or 0, 0, 1, 256, 0.8)
    end)
end
