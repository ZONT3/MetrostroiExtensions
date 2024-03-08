-- Copyright (c) Anatoly Raev, 2024. All right reserved
-- 
-- Unauthorized copying of any file in this repository, via any medium is strictly prohibited. 
-- All rights reserved by the Civil Code of the Russian Federation, Chapter 70.
-- Proprietary and confidential.
-- ------------
-- Авторские права принадлежат Раеву Анатолию Анатольевичу.
-- 
-- Копирование любого файла, через любой носитель абсолютно запрещено.
-- Все авторские права защищены на основании ГК РФ Глава 70.
-- Автор оставляет за собой право на защиту своих авторских прав согласно законам Российской Федерации.
MEL.DefineRecipe("kv_types", "gmod_subway_81-717_mvm")

RECIPE.Description = "This recipe adds ability to choose kv's."

local MODELS_ROOT = "models/metrostroi_train/81-717/"

function RECIPE:Init()
    self.Specific.KVList = {
        {"Spawner.717.KvTypeCustom.Black", MODELS_ROOT .. "kv_black.mdl"},
        {"Spawner.717.KvTypeCustom.White", MODELS_ROOT .. "kv_white.mdl"},
        {"Spawner.717.KvTypeCustom.Wood", MODELS_ROOT .. "kv_wood.mdl"},
        {"Spawner.717.KvTypeCustom.Yellow", MODELS_ROOT .. "kv_yellow.mdl"},
    }
end

function RECIPE:InjectSpawner(entclass)
    local fields = {"Spawner.717.Common.Random"}
    for key, value in pairs(MEL.RecipeSpecific.KVList) do
       table.insert(fields, value[1])
    end
    MEL.AddSpawnerField(entclass, {
        [1] = "KvTypeCustom",
        [2] = "Spawner.717.KvTypeCustom",
        [3] = "List",
        [4] = fields
    }, true)
end

function RECIPE:Inject(ent, entclass)
    MEL.UpdateModelCallback(ent, "Controller", function(wagon)
        if wagon.Anims.Controller then wagon.Anims.Controller.reload = true end
        return MEL.RecipeSpecific.KVList[wagon:GetNW2Int("KvTypeCustom", 1)][2]
    end)
    MEL.UpdateCallback(ent, "Controller", function(wagon, cent)
        local callback = MEL.RecipeSpecific.KVList[wagon:GetNW2Int("KvTypeCustom", 1)][3]
        if callback then
            callback(wagon, cent)
        end
    end)
    MEL.MarkClientPropForReload(ent, "Controller", "KvTypeCustom")
end