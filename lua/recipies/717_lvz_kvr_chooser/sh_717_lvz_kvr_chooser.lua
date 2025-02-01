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
