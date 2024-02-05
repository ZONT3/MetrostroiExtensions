MetrostroiExtensions.DefineRecipe("voltmeters")
local MODELS_ROOT = "models/metrostroi_extensions/81-717/"

function RECIPE:InjectSpawner(entclass)
    MetrostroiExtensions.AddSpawnerField("gmod_subway_81-717_mvm_custom", {
        [1] = "VoltmeterType",
        [2] = "Spawner.717.VoltmeterType",
        [3] = "List",
        [4] = {"Spawner.717.Common.Random", "Spawner.717.Voltmeter.Default", "Spawner.717.Voltmeter.Round"}
    }, true)
end

function RECIPE:Inject(ent, entclass)
    -- Создаем новый clientprop с нашей моделью вольтметра
    MetrostroiExtensions.NewClientProp(ent, "voltmeter_body", {
        model = MODELS_ROOT.."voltmeters/Voltmeters_Default.mdl",
        pos = Vector(0,0,0),
        ang = Angle(0,0,0),
        modelcallback = function(ent)
            -- т.к. вольтметры зависят от значения в спавнере, меняем мо 
            local voltmeters = {
                [1] = "voltmeters/Voltmeters_Default.mdl",
                [2] = "voltmeters/Voltmeters_Round1.mdl"
            }
            return MODELS_ROOT..voltmeters[ent:GetNW2Int("VoltmeterType", 1)]
        end
    }, "VoltmeterType")
    MetrostroiExtensions.NewClientProp(ent, "voltmeter_glow", {
        model = MODELS_ROOT.."voltmeters/Voltmeters_Round1_lit.mdl",
        pos = Vector(452.909, -29.7786, 15.2064),
        ang = Angle(0,0,0),
    }, "VoltmeterType")
    MetrostroiExtensions.UpdateCallback(ent, "voltmeter", function(ent, cent)
        local value = ent:GetNW2Int("VoltmeterType", 1)
        local value_to_pos = {
            [1] = {Vector(452.246277,-30.519978,12.287716), Angle(90.5,0,40)},
            [2] = {Vector(454.288,-27.9389,14.3), Angle(90,0,30)}
        }
        cent:SetPos(ent:LocalToWorld(value_to_pos[value][1]))
        cent:SetAngles(ent:LocalToWorldAngles(value_to_pos[value][2]))
    end)
    MetrostroiExtensions.MarkClientPropForReload(ent, "voltmeter", "VoltmeterType")
    MetrostroiExtensions.UpdateCallback(ent, "ampermeter", function(ent, cent)
        local value = ent:GetNW2Int("VoltmeterType", 1)
        local value_to_pos = {
            [1] = {Vector(452.269592,-30.540430,16.922098), Angle(90.5,0,40)},
            [2] = {Vector(452.006,-31.8885,14.5), Angle(90,0,30)}
        }
        cent:SetPos(ent:LocalToWorld(value_to_pos[value][1]))
        cent:SetAngles(ent:LocalToWorldAngles(value_to_pos[value][2]))
    end)
    MetrostroiExtensions.MarkClientPropForReload(ent, "ampermeter", "VoltmeterType")
    MetrostroiExtensions.InjectIntoClientFunction(ent, "Think", function(self)
        self.PanelLights = self:GetPackedBool("PanelLights")
        self:ShowHide("voltmeter_glow",self.PanelLights and self:GetNW2Int("VoltmeterType", 1) == 2)
    end)
    MetrostroiExtensions.InjectIntoClientFunction(ent, "UpdateWagonNumber", function(self)
        if self:GetNW2Int("VoltmeterType", 1) == 2 then
            self.Lights[44].brightness = 0
            self.Lights[45].brightness = 0
        else
            self.Lights[44].brightness = 1
            self.Lights[45].brightness = 1
        end
        self:SetLightPower(44,self:GetPackedBool("PanelLights"), 0)
        self:SetLightPower(45,self:GetPackedBool("PanelLights"), 0)
    end)
end
