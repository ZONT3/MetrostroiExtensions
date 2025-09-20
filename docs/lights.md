<!--
 Copyright (C) 2025 Anatoly Raev

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU Affero General Public License as
 published by the Free Software Foundation, either version 3 of the
 License, or (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.
-->


### MEL.OverrideSetLightPowerPower - перезаписать состояние включения источника света
/// admonition
    type: tip

Данную функцию стоит использовать, если вам необходимо состояние включения источника света (power в SetLightPower).
К примеру, вы хотите изменить стандартную логику какого-либо источника света
///
`MEL.OverrideSetLightPowerPower(ent, index, value_callback)` - перезаписать состояние включения источника света

*(scope: Client)*

* `ent` - энтити вагона
* `index` - индекс источника света
* `value_callback` - функция, которая принимает энтити вагона, а возвращает текущее значение для power

**Пример использования**:
```lua
-- делаем так, что спрайт левого красного огня всегда горит
MEL.OverrideSetLightPowerPower(ent, 8, function(ent)
    return true
end)
```

### MEL.OverrideSetLightPowerBrightness - перезаписать яркость источника света
/// admonition
    type: tip

Данную функцию стоит использовать, если вам необходимо яркость источника света (brightness в SetLightPower).
К примеру, вы хотите изменить стандартную логику какого-либо источника света
///
`MEL.OverrideSetLightPowerBrightness(ent, index, value_callback)` - перезаписать яркость источника света

*(scope: Client)*

* `ent` - энтити вагона
* `index` - индекс источника света
* `value_callback` - функция, которая принимает энтити вагона, а возвращает текущее значение для brightness

**Пример использования**:
```lua
-- делаем так, что спрайт левого красного огня всегда горит в пол накала
MEL.OverrideSetLightPowerBrightness(ent, 8, function(ent)
    return 0.5
end)
```
