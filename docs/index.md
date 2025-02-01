<h1 align="center">
<b>MetrostroiExtensionsLib</b> - простой способ написать инжект!
</h1>

**MetrostroiExtensionsLib** добавляет библиотеку для инжекта в поезда аддона *Metrostroi*.

Многие вещи, о которых забывают создатели инжектов **MetrostroiExtensionsLib** учитывает за вас - сохраните себе нервы!

# Быстрое начало (мини-туториал)
Давайте попробуем сделать достаточно простой *рецепт*:

* Добавим новый проп в салон
* Сделаем новое выпадающее меню в спавнере, которое позволит выбирать модель для пропа в салоне

А потом:

* Добавим кнопку, которая будет печатать сообщение в чат
* Заставим эту кнопку менять цвет нашего пропа в салоне

## Дисклеймер
Данное руководство подразумевает, что вы имеете базовые знания программирования и языка Lua. Также данное руководство предполагает, что вы ранее имели опыт разработки под Garry's Mod GLUA и понимаете его базовые сущности (по типу проп, энтити и т.д.).

## Основные термины
* **Инжект** - изменение существующего состава, путем "вставки" нового контента уже после его создания без изменения его исходного кода
* **Рецепт** - код, который определяет, как и каким образом нужно изменить что либо в составе
* **ClientProp** (или **клиентский проп**) - клиентская модель, тоесть моделька которая отрисовывается на клиенте
* **ButtonMap** (или **баттнмапа**) - специальная карта, определяющая местоположение и функции кнопок
* **MEL** - сокращенное от *MetrostroiExtensionsLib* - используется как сокращенное название в коде и в документации.

## Создание нового рецепта
### Начало
Для создания рецепта нам необходимо создать новый аддон. Рекомендуем поднять свой выделенный сервер (*srcds*), с установленным *Metrostroi*, *MetrostroiExtensionsLib* и *Turbostroi*. (см. [установка srcds Garry's Mod](https://wiki.facepunch.com/gmod/Downloading_a_Dedicated_Server))
### Создание локального аддона
Если вы создали выделенный сервер, то локальный аддон необходимо создавать на нем - Garry's Mod автоматически скачает ваши рецепты (из вашего аддона) к вам на клиент

Давайте перейдем в папку с аддонами: `<что-то до этого>\steamapps\common\GarrysMod\garrysmod\addons` *(в случае с выделенным сервером - `<что-то до этого>\garrysmod\addons`)*

Внутри данной папки будут находится все локальные аддоны. Создадим наш новый локальный аддон - для этого просто создадим новую папку с любым именем.

Так как мы работаем с lua кодом, то внутри локального аддона необходимо будет создать папку `lua` - по итогу у вас должен получится примерно вот такой путь:
`<что-то до этого>\garrysmod\addons\<имя аддона>\lua`
### Создание и инициализация рецепта MEL
*MetrostroiExtensionsLib* автоматически загрузит ваши рецепты, если они будут лежать в папке **recipies**.

Внутри папки **recipies** может быть сколько угодно вложенных папок. К примеру, для нашего удобства, если мы будем изменять пульт 81-717, можно создать следующую структуру папок:

`<что-то до этого>\garrysmod\addons\<имя аддона>\lua\recipies\717\pult\`

/// admonition
    type: tip

Есть особая "магическая" папка - *disabled*. Она может находится в любой другой папке, но все рецепты внутри неё не будут загружены.
///

Создадим наш первый рецепт - в папке `recepies` (или в другой папке внутри `recepies`) создадим файл с именем `hello_world.lua`. Внутрь него вставим следующий код:
```lua
MEL.DefineRecipe("hello_world", "717")
RECIPE.Description = "This recipe adds new prop into interior and simple example button"
```

Хм, не густо. Но именно так выглядит самый простой рецепт, который можно только себе представить. Да, он *(почти)* ничего не делает. Давайте разберем каждую строчку по отдельности:

1. `MEL.DefineRecipe("hello_world", "717")` - данная строчка инициализирует наш рецепт. Она дает *MEL* понять, что это рецепт с именем `hello_world` и его необходимо инжектить во все 717 типа МВМ и ЛВЗ (в метрострое МВМ - это МСК, ЛВЗ - это СПБ). Помимо `717` есть множество других способов задать вагоны, в которые необходимо инжектится. См. [MEL.DefineRecipe](recipe_basics.md)
2. `RECIPE.Description = "This recipe adds new prop into interior and simple example button"` - данная строчка добавляет описание данному рецепту. Это описание будет полезно как для вас, так и для администраторов серверов и других разработчиков. Этот описание будет отображаться в [MEL ConVars](recipe_basics.md#_3), с помощью которых можно отключить каждый рецепт по отдельности.

Но ведь наш рецепт ничего не делает! Давайте вдохнем в него жизни. Для начала попробуем сделать самую банальную (как по мне) вещь - добавим статичную модель в наш состав.

Для этого определим функцию `RECIPE:Inject(ent, entclass)` - данная функция будет выполнена на каждом вагоне, соотвествующему типу, определенному в [MEL.DefineRecipe](recipe_basics.md) (заспавненные энтити тоже считаются!).

Эта функция получает на вход как само энтити, так и класс (название) энтити

Получим следующий код:

```lua
MEL.DefineRecipe("hello_world", "717")
RECIPE.Description = "This recipe adds new prop into interior and simple example button"

function RECIPE:Inject(ent, entclass)

end
```

### Добавление статичного ClientProp
И мы получили... рецепт, который ничего не делает ;(

Давайте наконец вдохнем в него жизнь - воспользуемся функцией `MEL.NewClientProp`, передав в неё энтити, название пропа и [описание пропа](clientprops.md#clientprops), чтобы создать новый клиентпроп:

```lua
MEL.DefineRecipe("hello_world", "717")
RECIPE.Description = "This recipe adds new prop into interior and simple example button"

function RECIPE:Inject(ent, entclass)
    MEL.NewClientProp(ent, "hello_world_prop", {
        model = "models/props_junk/watermelon01.mdl",
        pos = Vector(0, 0, 0),
        ang = Angle(0, 0, 0),
    })
end
```

И... (после спавна 81-717) опять ничего!

На самом деле - данный рецепт полностью валидный и рабочий. Но нам нужно вызвать **реинжект** - заставить *MEL* заново внести все наши изменения в составы. Для этого вызовем консольную команду `metrostroi_ext_reload`. (Вызов данной команды можно автоматизировать на каждое сохрание файла - см. [автоматизация metrostroi_ext_reload](recipe_basics.md#metrostroi_ext_reload-))

Теперь внутри всех головных вагонах 81-717, в самом центре салона появился арбуз. Хорошо, но что если мы хотим видеть тут не только арбуз?

### Добавление поля в спавнер
Попробуем поработать со спавнером. *MEL* позволяет удобно и быстро работать со спавнером *Metrostroi*, учитывая все сложные моменты за вас. Давайте же создадим новое выпадающее меню с выбором модельки:

```lua
MEL.DefineRecipe("hello_world", "717")
RECIPE.Description = "This recipe adds new prop into interior and simple example button"

function RECIPE:InjectSpawner(entclass)
    MEL.AddSpawnerField(entclass, {
        [1] = "HelloWorldPropType",
        [2] = "Spawner.717.HelloWorldPropType",
        [3] = "List",
        [4] = {"Random", "Watermelon", "TrafficCone", "Barrel"}
    }, true)
end

function RECIPE:Inject(ent, entclass)
    MEL.NewClientProp(ent, "hello_world_prop", {
        model = "models/props_junk/watermelon01.mdl",
        pos = Vector(0, 0, 0),
        ang = Angle(0, 0, 0),
    })
end
```

Ого, что-то новое. Давайте разбираться:

* `RECIPE:InjectSpawner` - специальная функция, внутри которой нам нужно инжектится в спавнер. На вход получает класс энтити, вызывается ровно один раз на каждый класс энтити
* `MEL.AddSpawnerField` - функция для инжекта в спавнер. На вход получает класс энтити, в который необходимо инжектится и описание поля (см. [Формат полей спавнера Metrostroi](spawner.md#spawner)).

Внимательный читатель заметит, что в `MEL.AddSpawnerField` последним аргументом мы передаем `true`. Данный аргумент является флагом того, что первый аргумент в данном списке - рандом.

Если до этого вы разрабатывали инжекты в *Metrostroi*, то вы возможно знаете, какая головная боль добавить рандом в спавнере. *MEL* решает данную проблему за вас. См. подробнее [AutoRandom](spawner.md#_2).

Если теперь мы вызовем `metrostroi_ext_reload`, то в спавнере действительно появилось выпадающее меню. Но в данный есть пара моментов:

* Оно не работает
* У него странное название и вообще всё на английском

Давайте для начала разберемся с переводами
### Переводы в Metrostroi
В Metrostroi можно добавлять переводы для разных языков. Metrostroi Extensions позволяет легко и просто добавлять их для кастомных полей в спавнере. Создадим новый файл в папке `lua/metrostroi_data/languages` и назовем его `en_test.lua` - это будет файл английских переводов для нашего тестового аддона. Внутри напишем следующее:
```lua
return [[
# Metrostroi Extensions example addon translations

[en]
Entities.gmod_subway_81-717_mvm_custom.Spawner.HelloWorldPropType.Name = Hello World Prop Type
Entities.gmod_subway_81-717_mvm_custom.Spawner.HelloWorldPropType.Random = @[Common.Spawner.Random]
Entities.gmod_subway_81-717_mvm_custom.Spawner.HelloWorldPropType.Watermelon = Watermelon
Entities.gmod_subway_81-717_mvm_custom.Spawner.HelloWorldPropType.TrafficCone = Traffic cone
Entities.gmod_subway_81-717_mvm_custom.Spawner.HelloWorldPropType.Barrel = Barrel
]]
```

Надеюсь, формат примерно очевиден :)

Создадим такой же файл, только для российских переводов - `ru_test.lua`, он будет очень похож на файл с английскими переводами:
```lua
return [[
# Metrostroi Extensions example addon translations

[ru]
Entities.gmod_subway_81-717_mvm_custom.Spawner.HelloWorldPropType.Name = Тип тестового пропа
Entities.gmod_subway_81-717_mvm_custom.Spawner.HelloWorldPropType.Random = @[Common.Spawner.Random]
Entities.gmod_subway_81-717_mvm_custom.Spawner.HelloWorldPropType.Watermelon = Арбуз
Entities.gmod_subway_81-717_mvm_custom.Spawner.HelloWorldPropType.TrafficCone = Конус
Entities.gmod_subway_81-717_mvm_custom.Spawner.HelloWorldPropType.Barrel = Бочка
]]
```

Вызовем `metrostroi_language_reload` в консоли, переоткроем спавнер... И о чудо, теперь у нас появились переводы!

### Вдохнем жизнь в клиентпроп...
Давайте разберемся с самым основным - заставим его работать:

```lua
MEL.DefineRecipe("hello_world", "717")
RECIPE.Description = "This recipe adds new prop into interior and simple example button"

function RECIPE:InjectSpawner(entclass)
    MEL.AddSpawnerField(entclass, {
        [1] = "HelloWorldPropType",
        [2] = "Spawner.717.HelloWorldPropType",
        [3] = "List",
        [4] = {"Random", "Watermelon", "TrafficCone", "Barrel"}
    }, true)
end

function RECIPE:Inject(ent, entclass)
    MEL.NewClientProp(ent, "hello_world_prop", {
        model = "models/props_junk/watermelon01.mdl",
        modelcallback = function(wagon, cent)
            local models = {
                "models/props_junk/watermelon01.mdl",
                "models/props_junk/TrafficCone001a.mdl",
                "models/props_borealis/bluebarrel001.mdl"
            }
            return models[wagon:GetNW2Int("HelloWorldPropType")]
        end,
        pos = Vector(0, 0, 0),
        ang = Angle(0, 0, 0),
    })
end
```
*(надеюсь, к этому моменту вы уже уяснили, что после каждого изменения необходимо вызывать `metrostroi_ext_reload`)*

У пропа появилось интересное поле `modelcallback` - в данном пропе хранится [callback](https://ru.wikipedia.org/wiki/Callback_(%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5)), который будет вызываться для того, чтобы выяснить, какую-же модельку нам надо заспавнить.

Внутри данного callback мы просто получаем согласно индексу из нашего спавнера модель (спавнер для выпадающих менюшек передает нам индексы - первый элемент это 1, второй это 2 и т.д.)

Но... Оно не работает! Точнее работает, но для того, чтобы получить новую модель, необходимо полностью переспавнить состав. Не порядок - давайте думать, как это исправить:

```lua
MEL.DefineRecipe("hello_world", "717")
RECIPE.Description = "This recipe adds new prop into interior and simple example button"

function RECIPE:InjectSpawner(entclass)
    MEL.AddSpawnerField(entclass, {
        [1] = "HelloWorldPropType",
        [2] = "Spawner.717.HelloWorldPropType",
        [3] = "List",
        [4] = {"Random", "Watermelon", "TrafficCone", "Barrel"}
    }, true)
end

function RECIPE:Inject(ent, entclass)
    MEL.NewClientProp(ent, "hello_world_prop", {
        model = "models/props_junk/watermelon01.mdl",
        modelcallback = function(wagon, cent)
            local models = {
                "models/props_junk/watermelon01.mdl",
                "models/props_junk/TrafficCone001a.mdl",
                "models/props_borealis/bluebarrel001.mdl"
            }
            return models[wagon:GetNW2Int("HelloWorldPropType")]
        end,
        pos = Vector(0, 0, 0),
        ang = Angle(0, 0, 0),
    }, "HelloWorldPropType")
end
```

Погодите-ка... странно как-то, так ведь? Почему мы передаем строчку в `MEL.NewClientProp`, и это заставляет данный код работать правильно?

Давайте разбираться:

*MEL* добавляет ещё один удобный функционал, связанный со спавнером - [Автоперезагрузку пропов](clientprops.md#_3). Данный функционал будет пересоздавать ваш клиентпроп при изменении определенного поля в спавнере (и не только поля - на самом деле при изменении любой сетевой переменной вагона).

Передав четвертым аргументом имя сетевой переменной (которая равна имени поля в спавнере) мы пометили данный клиентпроп для пересоздания при изменении этого поля в спавнере.

Мы также можем пометить данный клиентпроп отдельно вне функции `MEL.NewClientProp` - с помощью фукнкии `MEL.MarkClientPropForReload`

### Пробуем добавить кнопку
Давайте теперь добавим простую кнопку, которая будет приветствовать мир в консоли нашего сервера

Для этого создадим новую баттнмапу - карту кнопок, используя функцию `MEL.NewButtonMap`:

```lua
MEL.DefineRecipe("hello_world", "717")
RECIPE.Description = "This recipe adds new prop into interior and simple example button"
function RECIPE:InjectSpawner(entclass)
    MEL.AddSpawnerField(entclass, {
        [1] = "HelloWorldPropType",
        [2] = "Spawner.717.HelloWorldPropType",
        [3] = "List",
        [4] = {"Random", "Watermelon", "TrafficCone", "Barrel"}
    }, true)
end

function RECIPE:Inject(ent, entclass)
    MEL.NewClientProp(ent, "hello_world_prop", {
        model = "models/props_junk/watermelon01.mdl",
        modelcallback = function(wagon, cent)
            local models = {"models/props_junk/watermelon01.mdl", "models/props_junk/TrafficCone001a.mdl", "models/props_borealis/bluebarrel001.mdl"}
            return models[wagon:GetNW2Int("HelloWorldPropType")]
        end,
        pos = Vector(0, 0, 0),
        ang = Angle(0, 0, 0),
    }, "HelloWorldPropType")

    MEL.NewButtonMap(ent, "HelloWorld", {
        pos = Vector(0, 0, 0),
        ang = Angle(0, 90, 90),
        width = 100,
        height = 100,
        scale = 0.0625, -- на самом деле это 1/16
        buttons = {
            {
                ID = "GreetWorld",
                x = 0,
                y = 0,
                w = 100,
                h = 100,
                tooltip = "Hello world!",
            },
        }
    })
end
```

(включите отладочную информацию в Q > Утилиты > Metrostroi > Клиент (дополнительно)). О чудо, в середине нашего салона появилась "кнопка", правда без модельки и... она ничего не делает :(

Вдохнем в неё жизнь!
### Инжект в стандартные функции

```lua
MEL.DefineRecipe("hello_world", "717")
RECIPE.Description = "This recipe adds new prop into interior and simple example button"
function RECIPE:InjectSpawner(entclass)
    MEL.AddSpawnerField(entclass, {
        [1] = "HelloWorldPropType",
        [2] = "Spawner.717.HelloWorldPropType",
        [3] = "List",
        [4] = {"Random", "Watermelon", "TrafficCone", "Barrel"}
    }, true)
end

function RECIPE:Inject(ent, entclass)
    MEL.NewClientProp(ent, "hello_world_prop", {
        model = "models/props_junk/watermelon01.mdl",
        modelcallback = function(wagon, cent)
            local models = {"models/props_junk/watermelon01.mdl", "models/props_junk/TrafficCone001a.mdl", "models/props_borealis/bluebarrel001.mdl"}
            return models[wagon:GetNW2Int("HelloWorldPropType")]
        end,
        pos = Vector(0, 0, 0),
        ang = Angle(0, 0, 0),
    }, "HelloWorldPropType")

    MEL.NewButtonMap(ent, "HelloWorld", {
        pos = Vector(0, 0, 0),
        ang = Angle(0, 90, 90),
        width = 100,
        height = 100,
        scale = 0.0625, -- на самом деле это 1/16
        buttons = {
            {
                ID = "GreetWorld",
                x = 0,
                y = 0,
                w = 100,
                h = 100,
                tooltip = "Hello world!",
            },
        }
    })

    MEL.InjectIntoServerFunction(ent, "OnButtonPress", function(wagon, button, ply)
        if button == "GreetWorld" then
            ply:ChatPrint("Hello World!")
            return MEL.Return
        end
    end)
end
```

`MEL.InjectIntoServerFunction` позволяет нам заинжектится в код любой **серверной** функции. В данном примере мы инжектимся в код функции `OnButtonPress` - данная функция вызывается на каждое нажатие кнопки внутри вагона - в неё передается имя кнопки и игрок, нажавший на неё.

Так как нам интересна только наша добавленная кнопка с именем `GreetWorld`, то добавим if. Внутри этого if напишем игроку в чат `Hello world`.

Внимательный читатель спросит - а что делает `return MEL.Return`? Нужно ли его писать в каждом инжекте в функцию?

`MEL.Return` позволяет сделать *return из исходной функции*. Тоесть, если вызвать `MEL.Return`, то выполнение функции вовсе прекратится. Но если не вызывать `MEL.Return`, оставшийся код функции (как исходной, так и код инжектов в эту функцию других рецептов) будет продолжать выполнятся.

В данном случае мы используем `MEL.Return` из-за того, что мы уже нашли нужную нам кнопку - нет смысла искать ещё кнопки, ведь мы их не найдем. Но также `MEL.Return` можно использовать для возврата какого-то значения из исходной функции. Для этого необходимо передать сначала возвращаемые аргументы, а последним значением - `MEL.Return`

К примеру, в Metrostroi есть функция `GetDriverName()` - она возвращает имя текущего машиниста. Представим, что мы хотим немного изменить её поведение - мы будем всегда возвращать слово `<REDACTED>` - на нашем сервере это секретная информация.

```lua
MEL.InjectIntoServerFunction(ent, "GetDriverName", function(wagon)
    return "<REDACTED>", MEL.Return
end, -1)
```

Обратите внимание на то, что мы *инжектимся с приоритетом -1*. Таким образом, мы выполняем наш код **до начала выполнения стандартного кода**. А из-за того, что мы возвращаем MEL.Return, мы даже не доходим до стандартного кода.

Также инжектится можно не только в серверные функции - а ещё в клиентские, shared и даже функции систем! См. [инжект в функции](function_inject.md)
### Модель у кнопки
Сделаем уже наконец нашу кнопку - кнопкой.

```lua
MEL.DefineRecipe("hello_world", "717")
RECIPE.Description = "This recipe adds new prop into interior and simple example button"
function RECIPE:InjectSpawner(entclass)
    MEL.AddSpawnerField(entclass, {
        [1] = "HelloWorldPropType",
        [2] = "Spawner.717.HelloWorldPropType",
        [3] = "List",
        [4] = {"Random", "Watermelon", "TrafficCone", "Barrel"}
    }, true)
end

function RECIPE:Inject(ent, entclass)
    MEL.NewClientProp(ent, "hello_world_prop", {
        model = "models/props_junk/watermelon01.mdl",
        modelcallback = function(wagon, cent)
            local models = {"models/props_junk/watermelon01.mdl", "models/props_junk/TrafficCone001a.mdl", "models/props_borealis/bluebarrel001.mdl"}
            return models[wagon:GetNW2Int("HelloWorldPropType")]
        end,
        pos = Vector(0, 0, 0),
        ang = Angle(0, 0, 0),
    }, "HelloWorldPropType")

    MEL.NewButtonMap(ent, "HelloWorld", {
        pos = Vector(0, 0, 0),
        ang = Angle(0, 90, 90),
        width = 100,
        height = 100,
        scale = 0.0625, -- на самом деле это 1/16
        buttons = {
            {
                ID = "GreetWorld",
                x = 0,
                y = 0,
                w = 100,
                h = 100,
                tooltip = "Hello world!",
                model = {
                    model = "models/metrostroi_train/81-710/ezh3_button_black.mdl",
                    var = "GreetWorld",
                    speed = 16,
                    vmin = 1,
                    vmax = 0,
                    sndvol = 0.07,
                    snd = function(val) return val and "button3_on" or "button3_off" end,
                    sndmin = 60,
                    sndmax = 1e3 / 3,
                    sndang = Angle(-90, 0, 0),
                },
            },
        }
    })

    MEL.InjectIntoServerFunction(ent, "OnButtonPress", function(wagon, button, ply) if button == "GreetWorld" then ply:ChatPrint("Hello World!") end end)
end
```

Теперь (предварительно залетев в модельку бочки/арбуза/конуса) у кнопки есть модель, но нет анимации. Давайте же исправим это!

### О анимациях и системах в Metrostroi
Небольшой ликбез:

1. Анимация - это какое-то изменение положения чего-либо в игре
2. В Metrostroi мы можем анимировать модели, у которых уже присутствует костная анимация (подробнее по [ссылке](https://developer.valvesoftware.com/wiki/$sequence))
3. В Metrostroi из коробки есть функция Animate
<!-- 4. Animate принимает:
    * имя клиентпропа
    * текущее значение анимации (от 0 до 1, обычно зависит от сетевой переменной, простым языком - обычно или 0, или 1, редко используются промежуточные значения),
    * минимальное положение анимации
    * максимально положение анимации
    * скорость анимации
    * "затухание" ([затухающие колебания](https://ru.wikipedia.org/wiki/%D0%97%D0%B0%D1%82%D1%83%D1%85%D0%B0%D1%8E%D1%89%D0%B8%D0%B5_%D0%BA%D0%BE%D0%BB%D0%B5%D0%B1%D0%B0%D0%BD%D0%B8%D1%8F))
    * "сопротивление" анимации -->
4. Для кнопок на баттонмапах есть встроенный механизм анимации

Для того, чтобы анимация у нас была синхронизирована на всех клиентах, нам нужна сетевая переменная.
Конечно, мы можем добавить сетевую переменную в Initialize на сервере, в Think её передавать всем клиентам, отдельно добавить OnButtonPress и реализовать логику нашей кнопки, но это слишком объемно (и тупо)

В Metrostroi для этого обычно используются *системы* - переиспользуемые "строительные блоки" с какой-либо логикой. И для нас уже написали систему кнопок и переключателей - можно даже посмотреть, [как она реализована](https://github.com/metrostroi-repo/MetrostroiAddon/blob/dev/lua/metrostroi/systems/sys_relay.lua)

Причем, система может загрузить другую систему. К примеру, существует система 81_717_Panel - система, в которой только лишь загружаются другие системы кнопок.

Но системы могут быть загружены во внутрь Turbostroi.
#### Кто такой этот ваш турбострой?
Как мы знаем, большинство процессоров в современном мире имеет несколько ядер. В современном процессоре их может быть 12, 24, 36, и даже намного больше!

Но Source, на котором работает Garry's Mod (да и сам движок Lua Garry's mod), из-за того, что был написан в 2000-ых годах (когда даже четыре ядра было редкостью) не умеет разделять нагрузку на несколько ядер. Именно поэтому нам необходим Turbostroi - это отдельная программа, которая по сути - выполняет тот же Lua код, просто разделяя его на разные ядра.

Но из-за того, что Turbostroi - это отдельная программа, мы не можем также гибко коммуницировать с ней, как внутри процесса Garry's mod. Поэтому и изменять системы, подгруженные во внутрь Turbostroi с помощью Metrostroi Extensions - *невозможно* (пока что :))

#### А причем тут кнопки?
К сожалению, 81_717_Panel подгруженна в Turbostroi... В идеальном мире мы бы смогли заинжектится с помощью MEL.InjectIntoSystemFunction в 81_717_Panel и добавить нашу новую кнопку. Но нам придется делать это в другом месте...

И сделаем мы это в функции InitializeSystems! Именно эта функция при спавне состава загружает все базовые системы, и, кстати, 81_717_Panel в том же числе. Просто возьмем и...
```lua
MEL.InjectIntoSharedFunction(ent, "InitializeSystems", function(wagon)
    wagon:LoadSystem("GreetWorld", "Relay", "Switch", {bass = true})
end)
```
В этом куске кода мы:

* Заинжектились в InitializeSystems
* Загрузили новую систему Relay в переменную GreetWorld с параметром "Switch" (тем самым указав, что это простой "тупой" переключатель)
* Также указали, что для него стоит добавить логику звуков

Также нам надо чуть-чуть модифицировать нашу ButtonMap с нашей кнопкой.
С системой кнопки в Metrostroi мы можем взаимодействовать по разному - мы можем использовать её как переключатель (тумблер), можем как кнопку, а можем вообще как кнопку с фиксацией, или как трехпозиционный переключатель, или как... Короче, вариантов использования - масса :)

Но для того, чтобы указать, что мы будем делать с нашей кнопкой, мы должны менять имя (ID) самой кнопки.
```diff
-                ID = "GreetWorld",
+                ID = "GreetWorldSet",
```
Постфиксом `Set` мы сказали, что данная кнопка на нашей баттнмапе будет систему-кнопку с именем GreetWorld задавать в ровно то значение, в котором сейчас кнопка на баттнмапе. Простым языком, если кнопку в игре мы зажмем, то кнопка-система тоже будет зажата, а как только мы её отпустим - она тоже отпустится.

Ещё мы можем переключать её (`Toggle`), зажимать или отпускать (`Open`, `Close`), блокировать (`Block`) и делать ещё много крутых вещей.

Давайте же применим это в нашем рецепте:
```lua
MEL.DefineRecipe("hello_world", "717")
RECIPE.Description = "This recipe adds new prop into interior and simple example button"
function RECIPE:InjectSpawner(entclass)
    MEL.AddSpawnerField(entclass, {
        [1] = "HelloWorldPropType",
        [2] = "Spawner.717.HelloWorldPropType",
        [3] = "List",
        [4] = {"Random", "Watermelon", "TrafficCone", "Barrel"}
    }, true)
end

function RECIPE:Inject(ent, entclass)
    MEL.NewClientProp(ent, "hello_world_prop", {
        model = "models/props_junk/watermelon01.mdl",
        modelcallback = function(wagon, cent)
            local models = {"models/props_junk/watermelon01.mdl", "models/props_junk/TrafficCone001a.mdl", "models/props_borealis/bluebarrel001.mdl"}
            return models[wagon:GetNW2Int("HelloWorldPropType")]
        end,
        pos = Vector(0, 0, 0),
        ang = Angle(0, 0, 0),
    }, "HelloWorldPropType")

    MEL.InjectIntoSharedFunction(ent, "InitializeSystems", function(wagon)
        wagon:LoadSystem("GreetWorld", "Relay", "Switch", {bass = true})
    end)
    MEL.NewButtonMap(ent, "HelloWorld", {
        pos = Vector(0, 0, 0),
        ang = Angle(0, 90, 90),
        width = 100,
        height = 100,
        scale = 0.0625, -- на самом деле это 1/16
        buttons = {
            {
                ID = "GreetWorldSet",
                x = 0,
                y = 0,
                w = 100,
                h = 100,
                tooltip = "Hello world!",
                model = {
                    model = "models/metrostroi_train/81-710/ezh3_button_black.mdl",
                    var = "GreetWorld",
                    speed = 16,
                    vmin = 1,
                    vmax = 0,
                    sndvol = 0.07,
                    snd = function(val) return val and "button3_on" or "button3_off" end,
                    sndmin = 60,
                    sndmax = 1e3 / 3,
                    sndang = Angle(-90, 0, 0),
                },
            },
        }
    })

    MEL.InjectIntoServerFunction(ent, "OnButtonPress", function(wagon, button, ply) if button == "GreetWorldSet" then ply:ChatPrint("Hello World!") end end)
end
```

Ииии... Кнопка все ещё не анимирована! Почему так? Все просто: мы не добавили переменную нашей кнопки в "таблицу синхронизации" - эта таблица синхронизации отправляет новые значения из систем на клиент при каждом из изменении.

В Metrostroi Extensions для этого есть удобная функция - MEL.AddToSyncTable

```lua
    MEL.AddToSyncTable(ent, "GreetWorld")
```

Полный рецепт:
```lua
MEL.DefineRecipe("hello_world", "717")
RECIPE.Description = "This recipe adds new prop into interior and simple example button"
function RECIPE:InjectSpawner(entclass)
    MEL.AddSpawnerField(entclass, {
        [1] = "HelloWorldPropType",
        [2] = "Spawner.717.HelloWorldPropType",
        [3] = "List",
        [4] = {"Random", "Watermelon", "TrafficCone", "Barrel"}
    }, true)
end

function RECIPE:Inject(ent, entclass)
    MEL.NewClientProp(ent, "hello_world_prop", {
        model = "models/props_junk/watermelon01.mdl",
        modelcallback = function(wagon, cent)
            local models = {"models/props_junk/watermelon01.mdl", "models/props_junk/TrafficCone001a.mdl", "models/props_borealis/bluebarrel001.mdl"}
            return models[wagon:GetNW2Int("HelloWorldPropType")]
        end,
        pos = Vector(0, 0, 0),
        ang = Angle(0, 0, 0),
    }, "HelloWorldPropType")

    MEL.InjectIntoSharedFunction(ent, "InitializeSystems", function(wagon)
        wagon:LoadSystem("GreetWorld", "Relay", "Switch", {bass = true})
    end)
    MEL.AddToSyncTable(ent, "GreetWorld")
    MEL.NewButtonMap(ent, "HelloWorld", {
        pos = Vector(0, 0, 0),
        ang = Angle(0, 90, 90),
        width = 100,
        height = 100,
        scale = 0.0625, -- на самом деле это 1/16
        buttons = {
            {
                ID = "GreetWorldSet",
                x = 0,
                y = 0,
                w = 100,
                h = 100,
                tooltip = "Hello world!",
                model = {
                    model = "models/metrostroi_train/81-710/ezh3_button_black.mdl",
                    var = "GreetWorld",
                    speed = 16,
                    vmin = 1,
                    vmax = 0,
                    sndvol = 0.07,
                    snd = function(val) return val and "button3_on" or "button3_off" end,
                    sndmin = 60,
                    sndmax = 1e3 / 3,
                    sndang = Angle(-90, 0, 0),
                },
            },
        }
    })

    MEL.InjectIntoServerFunction(ent, "OnButtonPress", function(wagon, button, ply) if button == "GreetWorldSet" then ply:ChatPrint("Hello World!") end end)
end
```

Ура! У нас есть кнопка, по нажатии на которую проигрывается анимация, правильно работает её логика, а ещё целый проп с выпадайкой в спавнере и рандомом.

Но давайте же попробуем заставить нашу кнопку как нибудь взаимодействовать с нашим пропом. Допустим, сделаем так, что она будет случайно менять цвет нашего пропа.

Для этого мы:

* Заинжектимся в клиентский Think
* Получим наш проп, проверим, что в данный момент он существует в мире (игрок находится достаточно близко к нему, чтобы игра его отрисовывала)
* При изменении значения сетевой переменной GreetWorld (при нажатии на кнопку) - зададим пропу случайный цвет

```lua
MEL.InjectIntoClientFunction(ent, "Think", function(wagon)
    if wagon.OldGreetWorld ~= wagon:GetNW2Bool("GreetWorld") then
        wagon.OldGreetWorld = wagon:GetNW2Bool("GreetWorld")

        local hello_world_prop = wagon.ClientEnts["hello_world_prop"]
        -- wagon.OldGreetWorld == true нужен только для того, чтобы менять цвет только при нажатии кнопки, не менять его второй раз при отпускании
        if wagon.OldGreetWorld == true and IsValid(hello_world_prop) then
            hello_world_prop:SetColor(Color(math.random(0, 255), math.random(0, 255), math.random(0, 255)))
        end
    end
end)
```

Надеюсь, к этому моменту вы уже понимаете, что делает данный код. Если нет - есть место для роста :)

На данном примере данное руководство подходит к концу. Но это только вершина айсберга из того, что умеет делать Metrostroi Extensions.

К примеру, ещё можно:

* изменять существующую кнопку или даже целую баттнмапу (MEL.ModifyButtonMap, MEL.MoveButtonMap или MEL.MoveButtonMapButton)
* добавлять новые кнопки на существующие баттнмапы (MEL.NewButtonMapButton)
* гибко работать со спавнером
* перезаписывать стандартные значения, которые возвращают Animate, ShowHide и даже HidePanel
и многое-многое другое...
