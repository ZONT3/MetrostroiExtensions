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
MEL.DefineRecipe("rendermode_none")
function RECIPE:Init()
end

function RECIPE:Inject(ent, entclass)
    MEL.InjectIntoServerFunction(ent, "Initialize", function(wagon)
        for _, obj in pairs(wagon:GetTable()) do
            if isentity(obj) and obj:IsVehicle() then
                local seat = obj
                seat:SetRenderMode(RENDERMODE_NONE)
                seat:GetPhysicsObject():EnableCollisions(false)
                seat:DrawShadow(false)
                seat:SetNoDraw(true)
            end
        end
    end, 10)
end