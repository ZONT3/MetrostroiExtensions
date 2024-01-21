-- DEBUG: helps with autoreload. Disable in production!!!
DEBUG = true

-- region spawner
-- region 717
timer.Simple(3, function()
	local new_spawner_fields = {
		{"VoltmeterType", "Тип вольтметров" , "List" , {"Случайно", "Квадратный","Круглый"}},
	}
    local ENT = scripted_ents.GetStored("gmod_subway_81-717_mvm_custom")  
    if ENT and ENT.t and ENT.t.Spawner then 
		for _, field in pairs(new_spawner_fields) do
			if DEBUG then
				-- remove old entries
				for i, existing_field in pairs(ENT.t.Spawner) do
					if type(existing_field) == "table" and type(i) == "number" and existing_field[1] == field[1] then
						table.remove(ENT.t.Spawner, i)
					end
				end
			end
			table.insert(ENT.t.Spawner, field)
		end
    end 
end
)
-- endregion
-- endregion



function updateModelCallback(ent, prop_name, modelcallback) 
	ent.ClientProps[prop_name]["modelcallback"] = modelcallback
end

function updateCallback(ent, prop_name, callback) 
	ent.ClientProps[prop_name]["callback"] = callback
end

function injectIntoENTFunction(ent, function_name, injected_function) 
	if not ent["Default"..function_name] then
		ent["Default"..function_name] = ent[function_name]
	end
	ent[function_name] = injected_function
end

-- region 717
timer.Simple(1.3, function()
	local MODELS_ROOT = "models/metrostroiextensions/81-717/"
	local ENT = scripted_ents.GetStored( "gmod_subway_81-717_mvm" ).t

	if CLIENT then
		-- replace cabs
		updateModelCallback(ENT, "cabine_mvm", function(ent)
			return MODELS_ROOT.."base_mvm.mdl"
		end)
		updateModelCallback(ENT, "cabine_lvz", function(ent)
			return MODELS_ROOT.."base_lvz.mdl"
		end)

		-- add new voltmeter
		ENT.ClientProps["voltmeter_body"] = {
			model = MODELS_ROOT.."voltmeters/Voltmeters_Default.mdl",
			pos = Vector(0,0,0),
			ang = Angle(0,0,0),
			modelcallback = function(ent,cent)
				local voltmeters = {
					[1] = "voltmeters/Voltmeters_Default.mdl",
					[2] = "voltmeters/Voltmeters_Round1.mdl"
				}
				return MODELS_ROOT..voltmeters[ent:GetNW2Int("VoltmeterType", 1)]
			end
		}
		ENT.ClientProps["voltmeter_glow"] = {
			model = MODELS_ROOT.."voltmeters/Voltmeters_Round1_lit.mdl",
			pos = Vector(452.909, -29.7786, 15.2064),
			ang = Angle(0,0,0),
			modelcallback = function(ent,cent)
				local voltmeters_glow = {
					[1] = "voltmeters/Voltmeters_Round1_lit.mdl",
					[2] = "voltmeters/Voltmeters_Round1_lit.mdl"
				}
				return MODELS_ROOT..voltmeters_glow[ent:GetNW2Int("VoltmeterType", 1)]
			end,
		}
		updateCallback(ENT, "voltmeter", function(ent,cent)
			if ent:GetNW2Int("VoltmeterType", 1) == 2 then
				cent:SetPos(ent:LocalToWorld(Vector(454.288,-27.9389,14.3)))
				cent:SetAngles(ent:LocalToWorldAngles(Angle(90,0,30)))
			end
		end)
		updateCallback(ENT, "ampermeter", function(ent,cent)
			if ent:GetNW2Int("VoltmeterType", 1) == 2 then
				cent:SetPos(ent:LocalToWorld(Vector(452.006,-31.8885,14.5)))
				cent:SetAngles(ent:LocalToWorldAngles(Angle(90,0,30)))
			end
		end)

		injectIntoENTFunction(ENT, "Think", function(self)
			-- voltmeter
			self.PanelLights = self:GetPackedBool("PanelLights")
			self:ShowHide("voltmeter_glow",self.PanelLights and self:GetNW2Int("VoltmeterType", 1) == 2)
			local _return = self:DefaultThink()
			return _return 
		end)

		injectIntoENTFunction(ENT, "UpdateWagonNumber", function(self)
			local check_reload = {
				["VoltmeterType"] = {"voltmeter_body", "voltmeter_glow", "voltmeter", "ampermeter"}
			}
			for key, models in pairs(check_reload) do
				local value = self:GetNW2Int(key, 1)
				if self[key] ~= value then
					for _, model_name in pairs(models) do
						self:RemoveCSEnt(model_name)
					end
					self[key] = value
				end
			end
			-- voltmeter
			if self:GetNW2Int("VoltmeterType", 1) == 2 then
				self.Lights[44].brightness = 0
				self.Lights[45].brightness = 0
			else
				self.Lights[44].brightness = 1
				self.Lights[45].brightness = 1
			end
			self:SetLightPower(44,self:GetPackedBool("PanelLights"), 0)
    		self:SetLightPower(45,self:GetPackedBool("PanelLights"), 0)
			local _return = self:DefaultUpdateWagonNumber()
			return _return 
		end)
	end
	if SERVER then
		injectIntoENTFunction(ENT, "TrainSpawnerUpdate", function(self)
			local check_random = {{"VoltmeterType", 2}}
			for _, data in pairs(check_random) do
				local value = self:GetNW2Int(data[1])
				if value == 1 then
					value = math.random(2, data[2]+1)
				end
				self:SetNW2Int(data[1], value-1)
			end
			local _return = self:DefaultTrainSpawnerUpdate()
			return _return 
		end)
	end
end 
)
-- endregion
