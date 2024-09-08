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
MEL.DefineRecipe("717_lvz_kvr_chooser", "717_714_lvz")
function RECIPE:InjectSpawner(entclass)
    MEL.AddSpawnerField(entclass, {
        [1] = "WagonType",
        [2] = "Spawner.717.WagonType",
        [3] = "List",
        [4] = {"Random", "81-717", "81-717.5 (KVR)"}
    }, function(wagon, elements_length)
        local type_ = wagon:GetNW2Int("Type")
        local isKVR = false
        if type_ == 1 then
            isKVR = wagon.WagonNumber >= 8875 or math.random() > 0.5
        elseif typ == 3 then
            isKVR = true
        end
        return isKVR and 3 or 2
    end)
end
