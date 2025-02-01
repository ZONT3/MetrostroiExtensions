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

MEL.DefineRecipe("717_fix_kdl_light", "gmod_subway_81-717_mvm")
function RECIPE:Inject(ent)
    -- TODO: make this work...
    -- in default MS KDLSet and KDLRSet have too big lfar, and cause of that we can see light from it on PB
    MEL.ModifyButtonMap(ent, "Block5_6", function() end, function(button) if button.ID == "KDLSet" or button.ID == "KDLRSet" then button.model.lamp.lfar = 2 end end)
    MEL.ModifyButtonMap(ent, "Block7", function() end, function(button) if button.ID == "KDPSet" then button.model.lamp.lfar = 2 end end)
end
