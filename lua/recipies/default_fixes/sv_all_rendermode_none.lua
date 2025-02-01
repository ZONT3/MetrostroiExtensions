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

MEL.DefineRecipe("all_rendermode_none", "all")

function RECIPE:Inject(ent, entclass)
    -- we just hide ALL seats. cause fuck metrostroi.
    MEL.InjectIntoServerFunction(ent, "Initialize", function(wagon)
        for _, obj in pairs(wagon:GetTable()) do
            if isentity(obj) and obj:IsVehicle() then
                local seat = obj
                seat:SetRenderMode(RENDERMODE_NONE)
                seat:GetPhysicsObject():EnableCollisions(false)
                seat:DrawShadow(false)
            end
        end
    end, 10)
end
