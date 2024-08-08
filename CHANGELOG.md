## 0.5.1 (2024-08-08)

### Fix

- **AddSpawnerField**: add check for nil pos

## 0.5.0 (2024-08-08)

### Feat

- call button_callback for buttons even without model

### Refactor

- AddSpawnerField new changes from f54e459

## 0.4.0 (2024-07-21)

### Feat

- add new spawner mapping helper functions.
- add fixes for 718 cab
- add more GetMappingValue error handling
- new number ranges for 717/714. close #24

### Fix

- add more error handling into AddSpawnerField and GetEntclass
- inject randomFieldHelper into interim too, check for CustomSetting on 717/714
- fix KDL light pollution, close #37
- add additional backports for 718/719

## 0.3.0 (2024-07-11)

### Feat

- 718/719 backports

## 0.2.2 (2024-07-10)

### Fix

- **platform_backport.lua**: fix errors when trying to load passengers

## 0.2.1 (2024-07-08)

### Refactor

- refactor weighted autorandom

## 0.2.0 (2024-07-08)

### Feat

- add weighted random

### Fix

- **sh_extensions_lib.lua**: return back system inject
- **sh_extensions_lib.lua**: fix injectAnimationReloadHelper

### Refactor

- **sh_extensions_lib.lua**: remove unused print in injectAnimationReloadHelper

## 0.1.1 (2024-07-06)

### Refactor

- use DefineRecipe as train type chooser
