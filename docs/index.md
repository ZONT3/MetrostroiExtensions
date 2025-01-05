<h1 align="center">
**MetrostroiExtensionsLib** - простой способ написать инжект!
</h1>

**MetrostroiExtensionsLib** добавляет библиотеку для инжекта в поезда аддона *Metrostroi*.

Многие вещи, о которых забывают создатели инжектов **MetrostroiExtensionsLib** учитывает за вас - сохраните себе нервы!

# Быстрое начало (мини-тутор)
Давайте попробуем сделать максимально простой *рецепт*:
* Добавим кнопку на пульт, которая будет печатать сообщение в чат

А потом:
* Добавим новый проп в салон
* Сделаем новое выпадающее меню в спавнере, которое позволит выбирать модель для пропа в салоне
* Заставим эту кнопку быть менять цвет нашего пропа в салоне

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

Создадим наш первый рецепт - в папке `pult` создадим файл с именем `hello_world.lua`. Внутрь него вставим следующий код:
```lua
MEL.DefineRecipe("hello_world", "717")
RECIPE.Description = "This recipe adds new prop into interior and simple example button"
```

Хм, не густо. Но именно так выглядит самый простой рецепт, который можно только себе представить. Да, он *(почти)* ничего не делает. Давайте разберем каждую строчку по отдельности:

1. `MEL.DefineRecipe("hello_world", "717")` - данная строчка инициализирует наш рецепт. Она дает *MEL* понять, что это рецепт с именем `hello_world` и его необходимо инжектить во все 717 типа МВМ и ЛВЗ (в метрострое МВМ - это МСК, ЛВЗ - это СПБ). Помимо `717` есть множество других способов задать вагоны, в которые необходимо инжектится. См. [MEL.DefineRecipe](#)
2. `RECIPE.Description = "This recipe adds new prop into interior and simple example button"` - данная строчка добавляет описание данному рецепту. Это описание будет полезно как для вас, так и для администраторов серверов и других разработчиков. Этот описание будет отображаться в [MEL ConVars](#), с помощью которых можно отключить каждый рецепт по отдельности.

Но ведь наш рецепт ничего не делает! Давайте вдохнем в него жизни. Для начала попробуем сделать самую банальную (как по мне) вещь - добавим статичную модель в наш состав.

Для этого определим функцию `RECIPE:Inject(ent, entclass)` - данная функция будет выполнена на каждом вагоне, соотвествующему типу, определенному в [MEL.DefineRecipe](#) (заспавненные энтити тоже считаются!).

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

Давайте наконец вдохнем в него жизнь - воспользуемся функцией `MEL.NewClientProp`, передав в неё энтити, название пропа и [описание пропа](#), чтобы создать новый клиентпроп:

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

На самом деле - данный рецепт полностью валидный и рабочий. Но нам нужно вызвать **реинжект** - заставить *MEL* заново внести все наши изменения в составы. Для этого вызовем консольную команду `metrostroi_ext_reload`. (Вызов данной команды можно автоматизировать на каждое сохрание файла - см. [автоматизация metrostroi_ext_reload](#))

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
* `MEL.AddSpawnerField` - функция для инжекта в спавнер. На вход получает класс энтити, в который необходимо инжектится и описание поля (см. [Формат полей спавнера Metrostroi](#)).

Внимательный читатель заметит, что в `MEL.AddSpawnerField` последним аргументом мы передаем `true`. Данный аргумент является флагом того, что первый аргумент в данном списке - рандом.

Если до этого вы разрабатывали инжекты в *Metrostroi*, то вы возможно знаете, какая головная боль добавить рандом в спавнере. *MEL* решает данную проблему за вас. См. подробнее [AutoRandom](#).

Если теперь мы вызовем `metrostroi_ext_reload`, то в спавнере действительно появилось выпадающее меню. Но в данный есть пара моментов:

* Оно не работает
* У него странное название и вообще всё на английском

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

Погодите-ка... хрень какая-то, так ведь? Почему мы передаем строчку в `MEL.NewClientProp`, и это заставляет данный код работать правильно?

Давайте разбираться:

*MEL* добавляет ещё один удобный функционал, связанный со спавнером - [ClientProp Reload](#). Данный функционал будет пересоздавать ваш клиентпроп при изменении определенного поля в спавнере (и не только поля - на самом деле при изменении любой сетевой переменной вагона).

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
end)
```

Также инжектится можно не только в серверные функции - а ещё в клиентские, shared и даже функции систем! См. [инжект в функции](#)
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
                    var = "KRZD",
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

Теперь (предварительно залетев в модельку бочки/арбуза/конуса) у кнопки есть модель, но нет анимации. Исправим это, добавив кнопку в
