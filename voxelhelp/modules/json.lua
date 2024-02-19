local json = { }
local vox_json = load_script("voxelhelp:vos_json")

function json.serialize(obj, pretty)
	return vox_json.encode(obj, pretty)
end

function json.deserialize(str)
	return vox_json.decode(str)
end

return json