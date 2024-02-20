local json = { }
local default_json= load_script("voxelhelp:json/json.lua")
local pretty_json = load_script("voxelhelp:json/pretty/json.lua")

function json.serialize(object, pretty)
	if pretty then
		return pretty_json.stringify(object, nil, 4)
	else
		return default_json.stringify(object)
	end
end

function json.deserialize(jsonStr)
	return default_json.parse(jsonStr);
end

return json