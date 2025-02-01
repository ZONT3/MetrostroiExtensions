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

MEL.DefineRecipe("717_fix_rolling_volume", "717_714_mvm")
function RECIPE:Inject(ent)
    MEL.InjectIntoSharedFunction(ent, "InitializeSounds", function(wagon)
        wagon.SoundPositions["rolling_10"][4] = 0.2
        if wagon.SoundPositions["rolling_32"] then wagon.SoundPositions["rolling_32"][4] = 0.4 end
    end, 1)
end
