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
function MEL.MoveButtonMap(ent, buttonmap_name, new_pos, new_ang)
    if CLIENT then
        local buttonmap = ent.ButtonMap[buttonmap_name]
        if not buttonmap then
            MEL._LogError(Format("no such buttonmap: %s", bu))
            return
        end

        buttonmap.pos = new_pos
        if new_ang then buttonmap.ang = new_ang end
        if not buttonmap.buttons then return end
        for i, button in pairs(buttonmap.buttons) do
            button.model = table.Copy(ent.ButtonMapCopy[buttonmap_name].buttons[i].model)
        end

        Metrostroi.GenerateClientProps(ent)
    end
end

function MEL.MoveButtonMapButton(ent, buttonmap_name, button_name, x, y)
    if CLIENT then
        local buttonmap = ent.ButtonMap[buttonmap_name]
        if not buttonmap then
            MEL._LogError(Format("no such buttonmap: %s", bu))
            return
        end

        local ent_class = MEL.GetEntclass(ent)
        local button_index = MEL.ButtonmapButtonMappings[ent_class][buttonmap_name]
        if not button_index then
            for i, button in pairs(buttonmap.buttons) do
                if button.ID == button_name then
                    button_index = i
                    break
                end
            end
        end
        if not button_index then
            MEL._LogError(Format("can't find button %s in buttonmap %s", button_name, buttonmap_name))
            return
        end
        if x then buttonmap.buttons[button_index].x = x end
        if y then buttonmap.buttons[button_index].y = y end
        buttonmap.buttons[button_index].model = table.Copy(ent.ButtonMapCopy[buttonmap_name].buttons[button_index].model)
        Metrostroi.GenerateClientProps(ent)
    end
end

function MEL.NewButtonMap(ent, buttonmap_name, buttonmap_data, do_not_override)
    if CLIENT then
        if do_not_override and ent.ButtonMap[buttonmap_name] then
            MEL._LogError(Format("there is already buttonmap with name %s! are you sure you want to override it?", buttonmap_name))
            return
        end

        ent.ButtonMap[buttonmap_name] = buttonmap_data
    end
end

function MEL.NewButtonMapButton(ent, buttonmap_name, button_data)
    if CLIENT then
        if not ent.ButtonMap then
            -- хм?
            return
        end

        local buttonmap = ent.ButtonMap[buttonmap_name]
        if not buttonmap then
            MEL._LogError(Format("no such buttonmap: %s", buttonmap_name))
            return
        end

        local ent_class = MEL.GetEntclass(ent)
        local button_index = MEL.ButtonmapButtonMappings[ent_class][buttonmap_name]
        if not button_index then
            for i, button in pairs(buttonmap.buttons) do
                if button.ID == button_data.ID then
                    button_index = i
                    return
                end
            end
        end

        if button_index then
            buttonmap.buttons[button_index] = button_data
            return
        end

        table.insert(buttonmap.buttons, button_data)
    end
end