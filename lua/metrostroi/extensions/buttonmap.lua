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
function MEL.MoveButtonMap(ent, buttonmap_name, new_pos, new_ang, reload_name)
    if CLIENT then
        local buttonmap = ent.ButtonMap[buttonmap_name]
        buttonmap.pos = new_pos
        if new_ang then buttonmap.ang = new_ang end
        if not buttonmap.buttons then return end
        for _, button in pairs(buttonmap.buttons) do
            MEL.UpdateCallback(ent, button.ID, function(wagon, cent)
                cent:SetPos(wagon:LocalToWorld(Metrostroi.PositionFromPanel(buttonmap_name, button.ID, 0, 0, 0, wagon)))
            end)
            if reload_name then MEL.MarkClientPropForReload(ent, button.ID, reload_name) end
        end
    end
end

function MEL.NewButtonMap(ent, buttonmap_name, buttonmap_data)
    if CLIENT then ent.ButtonMap[buttonmap_name] = buttonmap_data end
end