local json = load_script("voxelhelp:json.lua")

vox_json = { }

function vox_json.encode(object)
	return json.stringify(object)
end

function vox_json.decode(jsonStr)
	return json.parse(jsonStr);
end

return vox_json