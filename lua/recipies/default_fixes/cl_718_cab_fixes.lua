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

MEL.DefineRecipe("718_cab_fixes", "gmod_subway_81-718")
function RECIPE:Inject(ent, entclass)
    -- bruh
    MEL.ModifyButtonMap(ent, "ARS", nil, function(button)
        if button.ID == "!Speedometer1" then
            button.x = 105.4
            button.model.scale = 1.25
            button.model.z = 0
        end
        if button.ID == "!Speedometer2" then
            button.x = 120
            button.model.scale = 1.25
            button.model.z = 0
        end
    end)
    -- а это спорно. знаю.
    MEL.UpdateCallback(ent, "route1", function(wagon, cent)
        cent:SetColor(Color(255, 0, 0))
    end)
    MEL.UpdateCallback(ent, "route2", function(wagon, cent)
        cent:SetColor(Color(255, 0, 0))
    end)
end
