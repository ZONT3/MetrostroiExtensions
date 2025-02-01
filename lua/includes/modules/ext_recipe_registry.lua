-- Copyright (C) 2025 Anatoly Raev
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Affero General Public License as
-- published by the Free Software Foundation, either version 3 of the
-- License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Affero General Public License for more details.
--
-- You should have received a copy of the GNU Affero General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

local string_lower = string.lower
local table_Copy = table.Copy
local table_Insert = table.insert
local baseclass_Set = baseclass.Set
local baseclass_Get = baseclass.Get
module("ext_recipe_registry")
local recipe_classes = recipe_classes or {}
local recipies = recipies or {}
recipe_classes.base_recipe = {}
recipe_classes.base_recipe.Name = "Base Recipe"
recipe_classes.base_recipe.ID = -1
recipe_classes.base_recipe.EntityClass = "all" -- runs on ALL trains!
function recipe_classes.base_recipe:Init()
end

function recipe_classes.base_recipe:Remove()
	recipies[self.ID] = nil
	self:OnRemove()
end

baseclass_Set("ext_base_recipe", recipe_classes.base_recipe)
function Register(classtbl, name)
	name = string_lower(name)
	baseclass.Set(name, classtbl)
	classtbl.BaseClass = baseclass_Get(classtbl.Base)
	recipe_classes[name] = classtbl
end

function InitRecipe(class)
	if not recipe_classes[class] then error("Tried to create new recipe from non-existant class: " .. class) end
	local newRecipe = table_Copy(recipe_classes[class])
	table_Insert(table_Insertrecipies, newRecipe)
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
