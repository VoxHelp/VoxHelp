local json = load_script("voxelhelp:modules/json.lua")
local vox_list = load_script("voxelhelp:vox_list.lua")
local vox_help = load_script("voxelhelp:vox_help.lua")
local vox_arrays = load_script("voxelhelp:vox_arrays.lua")
local vox_tables = load_script("voxelhelp:vox_tables.lua")

local vox_metadata = { internal = { }, prettyStoring = false, metadata = { metadataVersion = "1.6", global = { } , blocks = { } }, allowedTypes = vox_arrays.toList({ "nil", "boolean", "string", "number", "table" }) }

function vox_metadata.internal.checkKey(key)
	if key == nil then
		error("Voxel Help Metadata: Metadata key is nil")
	end
end

function vox_metadata.internal.checkType(object)
	local type = type(object);

	if not vox_metadata.allowedTypes:contains(type) then
		error("Voxel Help Metadata Error: Not allowed object type \""..type.."\"")
	end
end

function vox_metadata.internal.toMetaKey(x, y, z)
	return x..","..y..","..z
end

function vox_metadata.internal.updateMeta(x, y, z, posKey)
	if vox_metadata.metadata["blocks"][posKey] == nil then
		vox_metadata.metadata["blocks"][posKey] = { }
	end
end

function vox_metadata.getMetadataVersion()
	return vox_metadata.metadataVersion
end

function vox_metadata.internal.getGlobalTableTree(pathesArray)
	local pathes = vox_arrays.toList(pathesArray)

	local parentTableKey = nil
	local parentTable = nil
	local previousTable = nil

	if pathes:size() > 0 then
		for i = 0, pathes:iterations() do

			local path = pathes:get(i)

			if previousTable ~= nil then
				local currentTable = vox_tables.alwaysTable(previousTable[path])
				previousTable[path] = currentTable
				previousTable = currentTable
			else
				parentTableKey = path
				parentTable = vox_tables.alwaysTable(vox_metadata.getGlobalMeta(path))
				previousTable = parentTable
			end
		end
	end

	return parentTableKey, parentTable, previousTable
end

function vox_metadata.setGlobalMetaByPath(key, value, pathesArray)
	local parentTableKey, parentTable, previousTable = vox_metadata.internal.getGlobalTableTree(pathesArray)

	if parentTable ~= nil then
		previousTable[key] = value

		vox_metadata.setGlobalMeta(parentTableKey, parentTable)
	end
end

function vox_metadata.getGlobalMetaByPath(key, pathesArray)
	local parentTableKey, parentTable, previousTable = vox_metadata.internal.getGlobalTableTree(pathesArray)

	if previousTable ~= nil then
		return previousTable[key]
	else
		return nil
	end
end

function vox_metadata.setGlobalMeta(key, value)
	vox_metadata.internal.checkType(value)

	vox_metadata.metadata["global"][key] = value
end

function vox_metadata.getGlobalMeta(key)
	return vox_metadata.metadata["global"][key]
end

function vox_metadata.existsMeta(x, y, z)
	return vox_metadata.metadata["blocks"][vox_metadata.internal.toMetaKey(x, y, z)] ~= nil
end

function vox_metadata.deleteMeta(x, y, z)
	vox_metadata.metadata["blocks"][vox_metadata.internal.toMetaKey(x, y, z)] = nil
end

function vox_metadata.copyMeta(x1, y1, z1, x2, y2, z2)
	vox_metadata.metadata["blocks"][vox_metadata.internal.toMetaKey(x2, y2, z2)] = vox_metadata.metadata["blocks"][vox_metadata.internal.toMetaKey(x1, y1, z1)]
end

function vox_metadata.moveMeta(x1, y1, z1, x2, y2, z2)
	vox_metadata.copyMeta(x1, y1, z1, x2, y2, z2)
	vox_metadata.deleteMeta(x1, y1, z1)
end

function vox_metadata.setMeta(x, y, z, key, value)
	vox_metadata.internal.checkKey(key)

	vox_metadata.internal.checkType(value)

	local posKey = vox_metadata.internal.toMetaKey(x, y, z)

	vox_metadata.internal.updateMeta(x, y, z, posKey)

	vox_metadata.metadata["blocks"][posKey][key] = value
end

function vox_metadata.getMeta(x, y, z, key)
	vox_metadata.internal.checkKey(key)

	local posKey = vox_metadata.internal.toMetaKey(x, y, z)

	vox_metadata.internal.updateMeta(x, y, z, posKey)

	if vox_metadata.metadata["blocks"][posKey] == nil then
		return nil
	end

	return vox_metadata.metadata["blocks"][posKey][key]
end

function vox_metadata.load()
	local filePath = vox_metadata.getMetadataAbsoluteFilePath()

	if file.exists(filePath) then
		local rawMetadata = file.read(filePath)

		if rawMetadata ~= nil then
			vox_metadata.metadata = json.deserialize(rawMetadata)

			if vox_metadata.metadata["blocks"] == nil then
				vox_metadata.metadata["blocks"] = { }
			end

			if vox_metadata.metadata["global"] == nil then
				vox_metadata.metadata["global"] = { }
			end
		end
	end
end

function vox_metadata.store()
	file.write(vox_metadata.getMetadataAbsoluteFilePath(), json.serialize(vox_metadata.metadata, vox_metadata.prettyStoring))
end

function vox_metadata.getMetadataAbsoluteFilePath(saving)
	return vox_help.getAbsoluteVoxelHelpSavesPath(saving) .. "/metadata.json"
end

return vox_metadata