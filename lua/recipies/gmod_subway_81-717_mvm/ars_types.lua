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
MEL.DefineRecipe("ars_types", "gmod_subway_81-717_mvm")

RECIPE.Description = "This recipe adds ability to modify arses."

local MODELS_ROOT = "models/metrostroi_train/81-717/pult/"

function RECIPE:Init()
    self.Specific.ARSList = {
        {
            name = "Spawner.717.ARS.1",
            model = MODELS_ROOT .. "ars_square.mdl",
            buttonmap = "Block2_2",
            speed_type = "Top"
        },
        {
            name = "Spawner.717.ARS.2",
            model = MODELS_ROOT .. "ars_round.mdl",
            buttonmap = "Block2_1",
            speed_type = "Left"
        },
        {
            name = "Spawner.717.ARS.3",
            model = MODELS_ROOT .. "ars_round_yellow.mdl",
            buttonmap = "Block2_1",
            speed_type = "Left"
        },
        {
            name = "Spawner.717.ARS.4",
            model = MODELS_ROOT .. "ars_old.mdl",
            buttonmap = "Block2_3",
            speed_type = "Arrow"
        },
        {
            name = "Spawner.717.ARS.5",
            model = MODELS_ROOT .. "ars_old_yellow.mdl",
            buttonmap = "Block2_3",
            speed_type = "Arrow"
        },
    }
end

local buttonmaps = {}
function RECIPE:InjectSpawner(entclass)
    local fields = {"Spawner.717.Common.Random"}
    for key, value in pairs(MEL.RecipeSpecific.ARSList) do
       table.insert(fields, value.name)
       table.insert(buttonmaps, value.buttonmap)
    end
    MEL.RemoveSpawnerField(entclass, "ARSType")
    MEL.AddSpawnerField(entclass, {
        [1] = "ARSTypeCustom",
        [2] = "Spawner.717.ARS",
        [3] = "List",
        [4] = fields
    }, true, true)
end

function RECIPE:Inject(ent, entclass)
    MEL.UpdateModelCallback(ent, "ars_mvm", function(wagon)
        return MEL.RecipeSpecific.ARSList[wagon:GetNW2Int("ARSTypeCustom", 1)].model
    end)
    MEL.UpdateCallback(ent, "ars_mvm", function(wagon, cent)
        local callback = MEL.RecipeSpecific.ARSList[wagon:GetNW2Int("ARSTypeCustom", 1)].callback
        if callback then
            callback(wagon, cent)
        end
    end)
    MEL.MarkClientPropForReload(ent, "ars_mvm", "KvTypeCustom")
    MEL.InjectIntoClientFunction(ent, "Think", function(wagon)
        -- hide not right buttonmaps
        local ARSType = wagon:GetNW2Int("ARSTypeCustom", 1)
        for _, buttonmap in pairs(buttonmaps) do
            wagon:HidePanel(buttonmap, MEL.RecipeSpecific.ARSList[ARSType].buttonmap ~= buttonmap)
        end
        local speed_type = MEL.RecipeSpecific.ARSList[ARSType].speed_type
        wagon:ShowHide("speed", speed_type == "Arrow")
        if wagon:GetPackedBool("LUDS") then
            local speed = wagon:GetPackedRatio("Speed") * 100.0
            if speed_type == "Top" and IsValid(wagon.ClientEnts["SSpeed1"]) then
                wagon.ClientEnts["SSpeed1"]:SetSkin(math.floor(speed) % 10)
            end
            if speed_type == "Top" and IsValid(wagon.ClientEnts["SSpeed2"]) then
                wagon.ClientEnts["SSpeed2"]:SetSkin(math.floor(speed / 10))
            end
            if speed_type == "Left" and IsValid(wagon.ClientEnts["RSpeed1"]) then
                wagon.ClientEnts["RSpeed1"]:SetSkin(math.floor(speed) % 10)
            end
            if speed_type == "Left" and IsValid(wagon.ClientEnts["RSpeed2"]) then
                wagon.ClientEnts["RSpeed2"]:SetSkin(math.floor(speed / 10))
            end
        end
    end)
    MEL.InjectIntoServerFunction(ent, "TrainSpawnerUpdate", function(wagon)
        wagon:SetNW2Int("ARSType", 0)  -- just to hide all default btnmaps
    end)
end