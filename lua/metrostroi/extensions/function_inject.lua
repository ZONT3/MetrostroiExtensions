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
MEL.FunctionInjectStack = {}

local function injectIntoEntFunction(ent_or_entclass, function_name, function_to_inject, priority)
    -- negative priority - inject before default function
    -- positive priority - inject after default function
    -- zero - default function priority, error!
    -- that shit is not idempotent, so if there would be like 10 wagons spawned and we will reload anything, same code will be called 10*10 times. 
    -- very bad, so that flag helps us just ignore that spawned wagons 
    if MEL.InjectIntoSpawnedEnt then return end
    local entclass = MEL.GetEntclass(ent_or_entclass)
    if priority == 0 then logError("when injecting function with name " .. function_name .. ": priority couldn't be zero") end
    if not MEL.FunctionInjectStack[entclass] then MEL.FunctionInjectStack[entclass] = {} end
    if not MEL.FunctionInjectStack[entclass][function_name] then MEL.FunctionInjectStack[entclass][function_name] = {} end
    local inject_priority = priority or -1
    if not MEL.FunctionInjectStack[entclass][function_name][inject_priority] then MEL.FunctionInjectStack[entclass][function_name][inject_priority] = {} end
    table.insert(MEL.FunctionInjectStack[entclass][function_name][inject_priority], function_to_inject)
end



function MEL.InjectIntoClientFunction(ent_or_entclass, function_name, function_to_inject, priority)
    if SERVER then return end
    injectIntoEntFunction(ent_or_entclass, function_name, function_to_inject, priority)
end

function MEL.InjectIntoServerFunction(ent_or_entclass, function_name, function_to_inject, priority)
    if CLIENT then return end
    injectIntoEntFunction(ent_or_entclass, function_name, function_to_inject, priority)
end

function MEL.InjectIntoSharedFunction(ent_or_entclass, function_name, function_to_inject, priority)
    injectIntoEntFunction(ent_or_entclass, function_name, function_to_inject, priority)
end
