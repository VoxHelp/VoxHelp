load_script("voxelhelp:vox_json.lua")
load_script("voxelhelp:vox_list.lua")
load_script("voxelhelp:vox_help.lua")
load_script("voxelhelp:vox_arrays.lua")

vox_metadata = { metadata = { metadataVersion = "1.6", global = { } , blocks = { } }, allowedTypes = vox_arrays.toList({ "nil", "boolean", "string", "number", "table" }) }

function vox_metadata.internal_checkType(object)
	local type = type(object);

	if not vox_metadata.allowedTypes:contains(type) then
		error("Voxel Help Metadata Error: Not allowed object type \""..type.."\"")
	end
end

function vox_metadata.getMetadataVersion()
	return vox_metadata.metadataVersion
end

function vox_metadata.internal_getGlobalTableTree(pathesArray)
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
	local parentTableKey, parentTable, previousTable = vox_metadata.internal_getGlobalTableTree(pathesArray)

	if parentTable ~= nil then
		previousTable[key] = value

		vox_metadata.setGlobalMeta(parentTableKey, parentTable)
	else
		print("nu pizdos")
	end
end

function vox_metadata.getGlobalMetaByPath(key, pathesArray)
	local parentTableKey, parentTable, previousTable = vox_metadata.internal_getGlobalTableTree(pathesArray)

	if previousTable ~= nil then
		return previousTable[key]
	else
		return nil
	end
end

function vox_metadata.setGlobalMeta(key, value)
	vox_metadata.internal_checkType(value)

	vox_metadata.metadata["global"][key] = value
end

function vox_metadata.getGlobalMeta(key)
	return vox_metadata.metadata["global"][key]
end

function vox_metadata.deleteMeta(x, y, z)
	vox_metadata.metadata["blocks"][x..y..z] = nil
end

function vox_metadata.copyMeta(x1, y1, z1, x2, y2, z2)
	vox_metadata.metadata["blocks"][x2..y2..z2] = vox_metadata.metadata["blocks"][x1..y1..z1]
end

function vox_metadata.moveMeta(x1, y1, z1, x2, y2, z2)
	vox_metadata.copyMeta(x1, y1, z1, x2, y2, z2)
	vox_metadata.deleteMeta(x1, y1, z1)
end

function vox_metadata.setMeta(x, y, z, key, value)
	vox_metadata.internal_checkType(value)

	local posKey = x..y..z

	if vox_metadata.metadata["blocks"][posKey] == nil then
		vox_metadata.metadata["blocks"][posKey] = { }
	end

	vox_metadata.metadata["blocks"][posKey][key] = value
end

function vox_metadata.getMeta(x, y, z, key)
	local posKey = x..y..z

	if vox_metadata.metadata["blocks"][posKey] == nil then
		return nil
	end

	return vox_metadata.metadata["blocks"][posKey][key]
end

function vox_metadata.internal_load()
	local filePath = vox_metadata.getMetadataAbsoluteFilePath()

	if file.exists(filePath) then
		local rawMetadata = file.read(filePath)

		if rawMetadata ~= nil then
			vox_metadata.metadata = vox_json.decode(rawMetadata)

			if vox_metadata.metadata["blocks"] == nil then
				vox_metadata.metadata["blocks"] = { }
			end

			if vox_metadata.metadata["global"] == nil then
				vox_metadata.metadata["global"] = { }
			end
		end
	end
end

function vox_metadata.internal_store()
	file.write(vox_metadata.getMetadataAbsoluteFilePath(true), vox_json.encode(vox_metadata.metadata))
end

function vox_metadata.getMetadataAbsoluteFilePath()
	return vox_help.getAbsoluteVoxelHelpSavesPath() .. "/metadata.json"
end

return vox_metadata