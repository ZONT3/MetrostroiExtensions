local utils = {preset = {}}

local SCHEMA_PATH = "file:///E:/devserver/gmod/garrysmod/addons/MetrostroiExtensions/data_static/spawner_schema_v1.json"
local SPAWNER_FOLDER = "metrostroi_extensions/spawner"

function utils.preset.export(settings)
	-- editing same object by link. would it cause problems? it shouldn't :)
	settings["$schema"] = SCHEMA_PATH
	-- pretty print in MEL.Debug
	return util.TableToJSON(settings, MEL.IsDebug())
end


-- We probably can use cookie library, but why when we already have preset functionality that we can reuse?
function utils.preset.saveLatest(settings)
	local path = Format("%s/latest", SPAWNER_FOLDER)
	file.CreateDir(path)
	settingsJson = utils.preset.export(settings)
	file.Write(Format("%s/%s.json", path, settings.entityClass), settingsJson)
end

function utils.preset.loadLatest(entityClass)
	local path = Format("%s/latest", SPAWNER_FOLDER)
	settingsJson = file.Read(Format("%s/%s.json", path, entityClass))
	if not settingsJson then return end
	return util.JSONToTable(settingsJson)
end

function utils.resizeWidth(width)
	-- return ScrW() * width / 1920
	return width
end

function utils.resizeHeight(height)
	-- return ScrH() * height / 1080
	return height
end

function utils.convertToNamedFormat(spawner)
	local convertedSpawner = {}
	for i in ipairs(spawner) do
		convertedSpawner[i] = MEL.Helpers.SpawnerEnsureNamedFormat(spawner[i])
	end
	return convertedSpawner
end

return utils
