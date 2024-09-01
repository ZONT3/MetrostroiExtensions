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
            --PAM
            isKVR = true
        end
        return isKVR and 3 or 2
    end)
end

function RECIPE:Inject(ent)
    MEL.InjectIntoServerFunction(ent, "TrainSpawnerUpdate", function(wagon)
        local isKVR = wagon:GetNW2Int("WagonType") == 2
        wagon:SetNW2Bool("KVR", isKVR)
        local type_ = wagon:GetNW2Int("Type")
        local passtex = "Def_717SPBWhite"
        local cabtex = "Def_PUAV"
        local seats = false
        local num = wagon.WagonNumber
        if type_ == 1 then --PAKSDM
            passtex = isKVR and (num <= 8888 and "Def_717SPBWhite" or num < 10000 and "Def_717SPBWood3" or "Def_717SPBCyan") or "Def_717SPBWhite"
            cabtex = isKVR and "Def_PAKSD2" or "Def_PAKSD"
            if isKVR and wagon.UPO then -- why UPO is nil?
                wagon.UPO.Buzz = math.random() > 0.7 and 2 or math.random() > 0.7 and 1
            else
                wagon.UPO.Buzz = math.random() > 0.4 and 2 or math.random() > 0.4 and 1
            end

            wagon:SetNW2Bool("NewUSS", isKVR or math.random() > 0.3)
        elseif type_ == 2 then
            seats = math.random() > 0.2
            wagon:SetNW2Bool("NewUSS", isKVR or math.random() > 0.3)
        end

        wagon:SetNW2Int("Crane", isKVR and 1 or 0)
        wagon:SetNW2Bool("NewSeats", isKVR or seats)
        wagon:SetNW2String("PassTexture", passtex)
        wagon:SetNW2String("CabTexture", cabtex)
        wagon:SetNW2Bool("NewSeats", isKVR or seats)
        wagon:UpdateTextures()
        wagon:UpdateLampsColors()
    end, 1)
end
