load_script("voxelhelp:vox_list.lua")

vox_arrays = { }

function vox_arrays.createArrayFromElement(element)
	local array = { }
	array[0] = element
	return array
end

function vox_arrays.array_contains(array, element)

	for i = 0, #array do
		if array[i] == element then
			return true
		end
	end

	return false
end

function vox_arrays.toList(array)
	local list = vox_list:new()

	if array ~= nil then
		for i = 0, #array do
			list:add(array[i])
		end
	end

	return list
end

return vox_arrays
