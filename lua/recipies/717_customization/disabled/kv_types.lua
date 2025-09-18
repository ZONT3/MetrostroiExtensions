-- Copyright (C) 2025 Anatoly Raev
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Affero General Public License as
-- published by the Free Software Foundation, either version 3 of the
-- License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Affero General Public License for more details.
--
-- You should have received a copy of the GNU Affero General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

MEL.DefineRecipe("kv_types", "gmod_subway_81-717_mvm")
RECIPE.Description = "This recipe adds ability to choose kv's."
local MODELS_ROOT = "models/metrostroi_train/81-717/"
function RECIPE:Init()
    self.Specific.KVList = {{"Black", MODELS_ROOT .. "kv_black.mdl"}, {"White", MODELS_ROOT .. "kv_white.mdl"}, {"Wood", MODELS_ROOT .. "kv_wood.mdl"}, {"Yellow", MODELS_ROOT .. "kv_yellow.mdl"},}
end

function RECIPE:InjectSpawner(entclass)
    local fields = {"Random"}
    for key, value in pairs(MEL.RecipeSpecific.KVList) do
        table.insert(fields, value[1])
    end

    MEL.AddSpawnerField(entclass, {
        Name = "KvTypeCustom",
        Section = "Cabine",
        Translation = "Spawner.717.KvTypeCustom",
        Type = "Combobox",
        Elements = fields
    }, true)
end

function RECIPE:Inject(ent, entclass)
    MEL.UpdateModelCallback(ent, "Controller", function(wagon)
        if wagon.Anims.Controller then wagon.Anims.Controller.reload = true end
        return MEL.RecipeSpecific.KVList[wagon:GetNW2Int("KvTypeCustom", 1)][2]
    end)

    MEL.UpdateCallback(ent, "Controller", function(wagon, cent)
        local callback = MEL.RecipeSpecific.KVList[wagon:GetNW2Int("KvTypeCustom", 1)][3]
        if callback then callback(wagon, cent) end
    end)

    MEL.MarkClientPropForReload(ent, "Controller", "KvTypeCustom")
end
