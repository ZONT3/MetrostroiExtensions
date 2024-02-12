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
local string = string
local table = table
local baseclass = baseclass
module("ext_recipe_registry")
local recipe_classes = recipe_classes or {}
local recipies = recipies or {}
recipe_classes.base_recipe = {}
recipe_classes.base_recipe.Name = "Base Recipe"
recipe_classes.base_recipe.ID = -1
recipe_classes.base_recipe.EntityClass = "all" -- runs on ALL trains!
function recipe_classes.base_recipe:Init() end

function recipe_classes.base_recipe:Remove()
	recipies[self.ID] = nil
	self:OnRemove()
end

baseclass.Set("ext_base_recipe", recipe_classes.base_recipe)
function Register(classtbl, name)
	name = string.lower(name)
	baseclass.Set(name, classtbl)
	classtbl.BaseClass = baseclass.Get(classtbl.Base)
	recipe_classes[name] = classtbl
end

function InitRecipe(class)
	if not recipe_classes[class] then error("Tried to create new recipe from non-existant class: " .. class) end
	local newRecipe = table.Copy(recipe_classes[class])
	table.insert(recipies, newRecipe)
	newRecipe:Init()
	return newRecipe
end

--Returns a table of all classes.
function GetClasses()
	return recipe_classes
end

--Returns a list of all current recipies objects.
function GetAll()
	return recipies
end