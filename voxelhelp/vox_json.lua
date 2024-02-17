local json = load_script("voxelhelp:json/json.lua")
local pretty_json = load_script("voxelhelp:json/pretty/json.lua")

vox_json = { }

function vox_json.encode(object, pretty)
	if pretty then
		return pretty_json.stringify(object, nil, 4)
	else
		return json.stringify(object)
	end
end

function vox_json.decode(jsonStr)
	return json.parse(jsonStr);
end

return vox_json