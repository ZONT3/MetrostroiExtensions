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

MEL.DefineRecipe("salon_seat_types", "717_714")

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
                cap_model = MODELS_ROOT .. "couch_cap_l.mdl",
                cap_o_callback = function(wagon, cent)
                    cent:SetLocalAngles(Angle(0, 70, -70))
                    cent:SetLocalPos(Vector(-285, 410, 13))
                end
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
                cap_model = MODELS_ROOT .. "couch_new_cap.mdl",
                cap_o_callback = function(wagon, cent)
                    cent:SetLocalAngles(Angle(0, 70, -70))
                    cent:SetLocalPos(Vector(-285, 410, 13))
                end
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
