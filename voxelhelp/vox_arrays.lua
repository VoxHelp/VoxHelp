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
		local len = #array

		if len > 0 then
			for i = 1, #array do
				list:add(array[i])
			end
		end
	end

	return list
end

function vox_arrays.size(array) --размер массива
    local size = 0
    for _, _ in pairs(array) do
        size = size + 1
    end
    return size
end

function vox_arrays.toString(array) --преобразование массива в строку
    local str = "{"
    for i, value in ipairs(array) do
        if i ~= 1 then str = str .. ", " end
        str = str .. tostring(value)
    end
    return str .. "}"
end

function vox_arrays.some(array, func) -- проверка наличия элемента в массиве
    for _, value in ipairs(array) do
        if func(value) then return true end
    end
    return false
end

function vox_arrays.every(array, func) -- проверка отсутствие элемента
    for _, value in ipairs(array) do
        if not func(value) then return false end
    end
    return true
end

function vox_arrays.clear()
	local self = {}
	return self
end

return vox_arrays