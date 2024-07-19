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
MEL.DefineRecipe("cab_fixes", "gmod_subway_81-718")
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
