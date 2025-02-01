# Вспомогательные функции
## MEL.Helpers.Is717 - проверить, головной ли это вагон 81-717
`MEL.Helpers.Is717(entclass)` - проверить, головной ли это вагон 81-717

*(scope: Shared)*

* `entclass` - имя энтити вагона

**Пример использования**:
```lua
MEL.Helpers.Is717("gmod_subway_81-717_mvm") -- вернет true
MEL.Helpers.Is717("gmod_subway_81-717_lvz") -- вернет true
MEL.Helpers.Is717("gmod_subway_81-714_mvm") -- вернет false
MEL.Helpers.Is717("gmod_subway_81-714_lvz") -- вернет false
MEL.Helpers.Is717("gmod_subway_81-775") -- вернет false
```

## MEL.Helpers.Is714 - проверить, промежуточной ли это вагон 81-714
`MEL.Helpers.Is714(entclass)` - проверить, промежуточной ли это вагон 81-714

*(scope: Shared)*

* `entclass` - имя энтити вагона

**Пример использования**:
```lua
MEL.Helpers.Is714("gmod_subway_81-717_mvm") -- вернет false
MEL.Helpers.Is714("gmod_subway_81-717_lvz") -- вернет false
MEL.Helpers.Is714("gmod_subway_81-714_mvm") -- вернет true
MEL.Helpers.Is714("gmod_subway_81-714_lvz") -- вернет true
MEL.Helpers.Is714("gmod_subway_81-775") -- вернет false
```

## MEL.Helpers.IsSPB - проверить, СПБ ли это версия вагонов 81-717
`MEL.Helpers.IsSPB(entclass)` - проверить, СПБ ли это версия вагонов 81-717

*(scope: Shared)*

* `entclass` - имя энтити вагона

**Пример использования**:
```lua
MEL.Helpers.Is714("gmod_subway_81-717_mvm") -- вернет false
MEL.Helpers.Is714("gmod_subway_81-717_lvz") -- вернет true
MEL.Helpers.Is714("gmod_subway_81-714_mvm") -- вернет false
MEL.Helpers.Is714("gmod_subway_81-714_lvz") -- вернет true
MEL.Helpers.Is714("gmod_subway_81-775") -- вернет false
```
