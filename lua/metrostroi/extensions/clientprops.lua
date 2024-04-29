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
function MEL.UpdateModelCallback(ent, clientprop_name, new_modelcallback, error_on_nil)
    if CLIENT then
        if error_on_nil and not ent.ClientProps[clientprop_name] then
            MEL._LogError(Format("no such clientprop with name %s", clientprop_name))
            return
        end
        local old_modelcallback = ent.ClientProps[clientprop_name]["modelcallback"] or function() end
        ent.ClientProps[clientprop_name]["modelcallback"] = function(self)
            local new_modelpath = new_modelcallback(self)
            return new_modelpath or old_modelcallback(self)
        end
    end
end

function MEL.UpdateCallback(ent, clientprop_name, new_callback, error_on_nil)
    if CLIENT then
        if not ent.ClientProps[clientprop_name] then
            if error_on_nil then MEL._LogError(Format("no such clientprop with name %s", clientprop_name)) end
            return
        end
        local old_callback = ent.ClientProps[clientprop_name]["modelcallback"] or function() end
        ent.ClientProps[clientprop_name]["callback"] = function(self, cent)
            old_callback(self, cent)
            new_callback(self, cent)
        end
    end
end

function MEL.DeleteClientProp(ent, clientprop_name, error_on_nil)
    if CLIENT then
        if not ent.ClientProps[clientprop_name] then
            if error_on_nil then MEL._LogError(Format("no such clientprop with name %s", clientprop_name)) end
            return
        end
        ent.ClientProps[clientprop_name] = nil
    end
end

function MEL.NewClientProp(ent, clientprop_name, clientprop_info, field_name, do_not_override)
    if CLIENT then
        if override and ent.ClientProps[clientprop_name] then
            MEL._LogError(Format("there is already clientprop with name %s! are you sure you want to override it?", clientprop_name))
            return
        end
        ent.ClientProps[clientprop_name] = clientprop_info
        if field_name then MEL.MarkClientPropForReload(ent, clientprop_name, field_name) end
    end
end