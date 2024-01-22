# How to use metrostroi_extensions recipe system
1. Create a folder with ent name (like `gmod_subway_81-717_mvm_custom`) or train family (like `717` - **this will change it on every 717 (mvm, lvz, mvm_custom)**).
2. Inside this folder create a recipe file with your name (e.g. example.lua).
This recipe file should look like this:
```lua
-- file path: lua/recipies/717/example.lua
-- define your recipe - like normal metrostroi system
MetrostroiExtensions.DefineRecipe("cabs")

-- WARNING: all recipies runs SHARED
function RECIPE:Init()
    -- this function should init some data to use inside recipe
end
```

> [!WARNING]  
> All recipies **SHOULD** be idempotent (shouldn't change state if it's already preserved) *(read why we need it at ...)*