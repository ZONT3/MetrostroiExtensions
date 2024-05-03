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
MEL.DefineRecipe("salon_seats", "717_714_mvm")
RECIPE.Description = "This recipe adds ability to customize salon seats."
local MODELS_ROOT = "models/metrostroi_train/81-717/"
function RECIPE:Init()
    self.Specific.SalonSeatList = {
        {
            name = "Old",
            head = {
                model = MODELS_ROOT .. "couch_old.mdl",
                cap_model = MODELS_ROOT .. "couch_cap_l.mdl"
            },
            int = {
                model = MODELS_ROOT .. "couch_old_int.mdl",
                cap_model = MODELS_ROOT .. "couch_cap_l.mdl"
            }
        },
        {
            name = "New",
            head = {
                model = MODELS_ROOT .. "couch_new.mdl",
                cap_model = MODELS_ROOT .. "couch_new_cap.mdl"
            },
            int = {
                model = MODELS_ROOT .. "couch_new_int.mdl",
                cap_model = MODELS_ROOT .. "couch_new_cap.mdl"
            }
        },
    }
end

function RECIPE:InjectSpawner(entclass)
    local fields = {"Random"}
    for key, value in pairs(MEL.RecipeSpecific.SalonSeatList) do
        table.insert(fields, value.name)
    end

    -- why we overwrite it?
    -- 1. default metrostroi uses FOUR FUCKING MODELS for achieving customization of seats.
    -- 2. random is so hard-coded, that it would be more work for me to just overwrite their random, than damage done by that change
    -- 3. just use ext for your new seats lol, its just gonna save you A LOT of time
    MEL.AddSpawnerField(entclass, {
        [1] = "SeatTypeCustom",
        [2] = "Spawner.717.SeatType",
        [3] = "List",
        [4] = fields
    }, true)

    MEL.RemoveSpawnerField(entclass, "SeatType")
end

function RECIPE:Inject(ent, entclass)
    MEL.DeleteClientProp(ent, "seats_new")
    MEL.DeleteClientProp(ent, "seats_new_cap")
    MEL.DeleteClientProp(ent, "seats_old")
    MEL.DeleteClientProp(ent, "seats_old_cap")
    if string.find(entclass, "717") then
        MEL.NewClientProp(ent, "seats", {
            model = "models/metrostroi_train/81-717/couch_old.mdl",
            modelcallback = function(wagon) return MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].head.model end,
            callback = function(wagon, cent)
                local callback = MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].head.callback
                if callback then callback(wagon, cent) end
            end,
            pos = Vector(0, 0, 0),
            ang = Angle(0, 0, 0),
            hide = 1.5,
        }, "SeatTypeCustom")

        MEL.NewClientProp(ent, "seats_cap", {
            model = "models/metrostroi_train/81-717/couch_cap_l.mdl",
            modelcallback = function(wagon) return MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].head.cap_model end,
            callback = function(wagon, cent)
                local callback = MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].head.cap_callback
                if callback then callback(wagon, cent) end
            end,
            pos = Vector(0, 0, 0),
            ang = Angle(0, 0, 0),
            hideseat = 0.8,
        }, "SeatTypeCustom")
    else
        MEL.DeleteClientProp(ent, "seats_new_cap_o")
        MEL.DeleteClientProp(ent, "seats_old_cap_o")
        MEL.NewClientProp(ent, "seats", {
            model = "models/metrostroi_train/81-717/couch_old.mdl",
            modelcallback = function(wagon) return MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].int.model end,
            callback = function(wagon, cent)
                local callback = MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].int.callback
                if callback then callback(wagon, cent) end
            end,
            pos = Vector(0, 0, 0),
            ang = Angle(0, 0, 0),
            hide = 1.5,
        }, "SeatTypeCustom")

        MEL.NewClientProp(ent, "seats_cap", {
            model = "models/metrostroi_train/81-717/couch_cap_l.mdl",
            modelcallback = function(wagon) return MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].int.cap_model end,
            callback = function(wagon, cent)
                local callback = MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].int.cap_callback
                if callback then callback(wagon, cent) end
            end,
            pos = Vector(0, 0, 0),
            ang = Angle(0, 0, 0),
            hideseat = 0.8,
        }, "SeatTypeCustom")

        MEL.NewClientProp(ent, "seats_cap_o", {
            model = "models/metrostroi_train/81-717/couch_cap_l.mdl",
            modelcallback = function(wagon)
                local config = MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].int
                return config.cap_o_model or config.cap_model
            end,
            callback = function(wagon, cent)
                local callback = MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].int.cap_o_callback
                if callback then callback(wagon, cent) end
            end,
            pos = Vector(-285, 410, 13),
            ang = Angle(0, 70, -70),
            hideseat = 0.8,
        }, "SeatTypeCustom")

        MEL.InjectIntoClientFunction(ent, "Think", function(wagon)
            local cap_opened = wagon:GetPackedBool("CouchCap")
            wagon:ShowHide("seats_cap", not cap_opened)
            wagon:ShowHide("seats_cap_o", cap_opened)
        end)
    end
end