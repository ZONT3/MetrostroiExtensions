# Работа со спавнером
MetrostroiExtensionsLib позволяет добавлять новые поля и инжектится в существующие без вреда другим инжектам. MetrostroiExtensionsLib умеет автоматически пересоздавать модели при изменении значения поля спавнера. Также, при добавлении новых полей, MetrostroiExtensionsLib умеет автоматически добавлять необходимый код для работы рандома в списках - почти прозрачно для программиста

## Описание таблицы Spawner (ext формат)
* `Name`* - имя поля
* `Translation`* - отображаемое название как строка. Желательно использовать строку переводов
* `Type`* - тип поля: `List`, `Slider` или `Boolean`
* `Section` - секция в спавнере. Рекомендуется использовать одно из трех: Body, Cabine, Interior
* `Subection` - дополнительная секция в спавнере
* `WagonCallback` - callback. Будет вызван для каждого вагона в составе. Получает энтити вагона, значение поля, был ли перевернут данный вагон, индекс вагона, общее количество вагонов, правый ли клик был использован
* `Default` - стандартное значение
* Список (`List`):
    * `Elements`* - таблица со строками - элементы списка (может быть строкой переводов (и скорее всего должна быть)) ИЛИ функция, возвращающая таблицу со строками
    * `ChangeCallback` - callback. Будет вызван при выборе элемента в списке. Получает объект DComboBox, а также таблицу со всеми панелями, отрисовываемыми спавнером
* Слайдер (`slider`):
    * `Decimals`* - количество точек после запятой (см. [DNumSliders:SetDecimals](https://wiki.facepunch.com/gmod/DNumSlider:SetDecimals))
    * `Min`* - минимальное значение
    * `Max`* - максимальное значение
* Галочка (`boolean`):
    * `ChangeCallback` - callback. Будет вызван при смене значения галочки. Получает объект DCheckBox, а также таблицу со всеми панелями, отрисовываемыми спавнером.

## Описание таблицы Spawner (классический формат)
* `[1]`* - имя поля
* `[2]`* - отображаемое название как строка. Желательно использовать строку переводов
* `[3]`* - тип поля: `list`, `slider` или `boolean`
* Список (`list`):
    * `[4]`* - таблица со строками - элементы списка (может быть строкой переводов (и скорее всего должна быть)) ИЛИ функция, возвращающая таблицу со строками
    * `[5]` - стандартное значение данного поля
    * `[6]` - callback. Будет вызван для каждого вагона в составе. Получает энтити вагона, значение поля, был ли перевернут данный вагон, индекс вагона, общее количество вагонов, правый ли клик был использован
    * `[7]` - callback. Будет вызван при выборе элемента в списке. Получает объект DComboBox, а также таблицу со всеми панелями, отрисовываемыми спавнером
* Слайдер (`slider`):
    * `[4]`* - количество точек после запятой (см. [DNumSliders:SetDecimals](https://wiki.facepunch.com/gmod/DNumSlider:SetDecimals))
    * `[5]`* - минимальное значение
    * `[6]`* - максимальное значение
    * `[7]` - стандартное значение
    * `[8]` - callback. См. callback списка (`list`) [6].
* Галочка (`boolean`):
    * `[4]` - стандартное значение
    * `[5]` - callback. См. callback списка (`list`) [6].
    * `[6]` - callback. Будет вызван при смене значения галочки. Получает объект DCheckBox, а также таблицу со всеми панелями, отрисовываемыми спавнером.

Если `[1]` это число, пропуск будет добавлен `[1]` раз

Если поле - пустая таблица, пропуск будет добавлен 1 раз

## Авторандом

Если при добавлении нового списка (или слайдера) через [MEL.AddSpawnerField](spawner.md#meladdspawnerfield-) передать в качестве последнего аргумента `true`, то тогда MetrostroiExtensionsLib автоматически пометит это поле как содержащее рандом в качестве первого элемента.

### Для списков:

При выборе первого элемента в данном списке, будет автоматически получено рандомное значение от 2 до длинны списка. Данное значение будет доступно как значение обычного параметра в спавнере (тоесть, данное значение можно будет получить через `self:GetNW2Int("<имя поля>")`).

Если выбран любой другой элемент, то значение поля будет равно `значению поля - 1` (тоесть, если бы элемента рандом в списке не было)

Пример:
> Есть список VoltmeterType со значениями random, default, round.
>
> Если выбрать первый элемент, то `self:GetNW2Int("VoltmeterType")` вернет случайное значение от 1 до 2 (так как помимо random, элементов в списке всего два)
>
> Если выбрать второй элемент, то `self:GetNW2Int("VoltmeterType")` вернет значение 1 - ведь данный элемент первый, если не учитывать элемент random
>
> Соответственно верно и для третьего элемента - `self:GetNW2Int("VoltmeterType")` вернет 2

Также рандом бывает взвешенным - тоесть, у каждого элемента в списке разный шанс выпадения

### Для слайдеров:
При выборе значения 0 - будет выбрано случайное число от min до max значения слайдера


## MEL.AddSpawnerField - Добавить новое поле в спавнер
`MEL.AddSpawnerField(ent_or_entclass, field_data, random_field_data, overwrite, pos)` - добавляет новое поле в спавнер. Автоматически передобавляет его при перезагрузке.

*(scope: Shared)*

* `ent_or_entclass` - энтити или имя энтити вагона, в таблицу Spawner которого необходимо добавить данное поле
* `field_data` - информация о поле. См. [Описание таблицы Spawner](spawner.md#spawner)
* `[random_field_data]` - информация о рандоме поля.
    * Если `[random_field_data]` - true, то тогда будет выбрано случайное значение из списка (или из диапазона слайдера)
    * Если `[random_field_data]` - таблица, то данная таблица будет использоваться как веса для взвешенного рандома.
    * Если `[random_field_data]` - функция, то данная функция будет вызвана для получения значения рандома. Функция принимает вагон и количество элементов, возвращает индекс выбранного элемента (с учетом первого элемента в списке, который "Random")
* `[overwrite]` - если данный флаг - true, то тогда данное поле перезапишется. Иначе будет вызвана ошибка. Полезно для замены существующих полей (но используйте с осторожностью!)
* `[pos]` - положение в списке полей в спавнере. По умолчанию добавляется в конец.


**Пример использования**:
```lua
-- поле типа галочка
MEL.AddSpawnerField(entclass, {
    [1] = "SomeField",
    [2] = "Spawner.717.SomeField",
    [3] = "Boolean",
    [4] = false
})

-- поле типа список с равноценным рандомом
MEL.AddSpawnerField(entclass, {
    [1] = "SomeField",
    [2] = "Spawner.717.SomeField",
    [3] = "List",
    [4] = {"Random", "Type1", "Type2"}
}, true)

-- поле типа слайдер с равноценным рандомом
MEL.AddSpawnerField(ent_class, {
    [1] = "DirtLevelCustom",
    [2] = "Spawner.717.DirtLevel",
    [3] = "Slider",
    [4] = 2,
    [5] = 0,
    [6] = 1,
    [7] = 0,
    [8] = function(wagon, value)
        wagon:SetNW2Float("DirtLevelCustom", value)
    end
}, true)

-- поле типа список с взвешенным рандомом
MEL.AddSpawnerField(entclass, {
    [1] = "SomeField",
    [2] = "Spawner.717.SomeField",
    [3] = "List",
    [4] = {"Random", "Common", "Normal", "Rare", "Epic"}
}, {1000, 100, 10, 1})

-- поле типа список с кастомным рандомом
MEL.AddSpawnerField(entclass, {
    [1] = "WagonType",
    [2] = "Spawner.717.WagonType",
    [3] = "List",
    [4] = {"Random", "81-717", "81-717.5 (KVR)"}
}, function(wagon, elements_length)
    local type_ = wagon:GetNW2Int("Type")
    local isKVR = false
    if type_ == 1 then
        isKVR = wagon.WagonNumber >= 8875 or math.random() > 0.5
    elseif typ == 3 then
        isKVR = true
    end
    return isKVR and 3 or 2
end)
```

## MEL.RemoveSpawnerField - удалить поле из спавнера
`MEL.RemoveSpawnerField(ent_or_entclass, field_name)` - удаляет поле из спавнера.

*(scope: Shared)*

* `ent_or_entclass` - энтити или имя энтити вагона
* `field_name` - имя поля.

**Пример использования**:
```lua
MEL.RemoveSpawnerField(ent, "SomeField")
MEL.RemoveSpawnerField("gmod_subway_81-775", "SomeField")
```


## MEL.FindSpawnerField - найти поле в спавнере
`MEL.FindSpawnerField(ent_or_entclass, field_name)` - находит поле в спавнере и возвращает ссылку на его таблицу

*(scope: Shared)*

* `ent_or_entclass` - энтити или имя энтити вагона
* `field_name` - имя поля.

**Пример использования**:
```lua
local SpawnerConstants = include("metrostroi/extensions/constants/spawner.lua")

-- находим поле Scheme и меняем функцию, которая возвращает элементы списка
MEL.FindSpawnerField("gmod_subway_81-775", "Scheme")[SpawnerConstants.List.ELEMENTS] = function()
    local Schemes = {}
    for k, v in pairs(Metrostroi.Skins["717_new_schemes"] or {}) do
        Schemes[k] = v.name or k
    end
    return Schemes
end
```

## MEL.IsRandomField - используется ли рандом для данного поля
`MEL.IsRandomField(ent_or_entclass, field_name)` - проверяет, используется ли рандом MetrostroiExtensionsLib в данном поле

*(scope: Shared)*

* `ent_or_entclass` - энтити или имя энтити вагона
* `field_name` - имя поля.

**Пример использования**:
```lua
MEL.IsRandomField("gmod_subway_81-775", "SomeFieldWithRandom") -- вернет true
MEL.IsRandomField("gmod_subway_81-775", "SomeFieldWithoutRandom") -- вернет false
```

## Маппинги
Как мы знаем, в спавнере в списках используются индексы, а не названия выбранных полей. Но представьте себе такой сценарий:

1. Вы добавили своё поле с тремя элементами One, Two, Three
2. Другой инжект добавил в ваше поле новый элемент Zero в самое начало списка
3. Из-за того, что вы использовали индексацию по цифрам, теперь индекс 1 отвечает за Zero.

По итогу ваш рецепт начинает работать неправильно.

Чтобы не допускать таких ситуаций, в Metrostroi Extensions существует механизм маппингов. Он позволяет сопоставлять название поля с его индексом автоматически.

### MEL.GetMappingValue - получить текущий индекс элемента в поле
`MEL.GetMappingValue(ent_or_entclass, field_name, element)` - помогает узнать индекс элемента по его названию в поле

*(scope: Shared)*

* `ent_or_entclass` - энтити или имя энтити вагона
* `field_name` - имя поля
* `element` - имя элемента

**Пример использования**:
```lua
-- представим поле SomeField с тремя элементами - {"Type1", "Type2", "Type3"}
MEL.GetMappingValue(ent, "SomeField", "Type2") -- вернет 2
```

### MEL.IsSpawnerSelected - выбран ли данный элемент в спавнере
`MEL.IsSpawnerSelected(ent_or_entclass, field_name, element)` - помогает проверить выбран ли какой-либо элемент в спавнере.

*(scope: Shared)*

* `ent_or_entclass` - энтити или имя энтити вагона
* `field_name` - имя поля
* `element` - имя элемента

**Пример использования**:
```lua
-- представим поле SomeField с тремя элементами - {"Type1", "Type2", "Type3"}
-- в данный момент выбран элемент Type1
MEL.IsSpawnerSelected(ent, "SomeField", "Type2") -- вернет false
MEL.IsSpawnerSelected(ent, "SomeField", "Type1") -- вернет true
```

### MEL.GetSelectedSpawnerName - имя текущего выбранного элемента в поле
`MEL.GetSelectedSpawnerName(ent_or_entclass, field_name, element)` - помогает узнать название элемента, который сейчас выбран.

*(scope: Shared)*

* `ent_or_entclass` - энтити или имя энтити вагона
* `field_name` - имя поля

**Пример использования**:
```lua
-- представим поле SomeField с тремя элементами - {"Type1", "Type2", "Type3"}
-- в данный момент выбран элемент Type1
MEL.GetSelectedSpawnerName(ent, "SomeField") -- вернет Type1
```

### MEL.GetRealSpawnerValue - реальный индекс выбранного элемента без учета рандома
`MEL.GetRealSpawnerValue(ent_or_entclass, field_name)` - помогает узнать реальный индекс выбранного в спавнере поля. Не уменьшает на единицу значения рандомных полей.

*(scope: Shared)*

* `ent_or_entclass` - энтити или имя энтити вагона
* `field_name` - имя поля

**Пример использования**:
```lua
-- представим поле SomeField с тремя элементами - {"Random", "Type1", "Type2"}
-- данное поле создано через Metrostroi Extensions и помечено в нем как рандомное
-- в данный момент выбран элемент Type1
MEL.GetRealSpawnerValue(ent, "SomeField") -- вернет 2
-- представим поле OtherField с тремя элементами - {"Type1", "Type2"}
-- в данный момент выбран элемент Type1
MEL.GetRealSpawnerValue(ent, "OtherField") -- вернет 1
```
