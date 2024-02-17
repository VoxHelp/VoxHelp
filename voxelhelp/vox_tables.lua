vox_tables = { }

function vox_tables.add(tableVal, newValue)
	vox_tables:insert(tableVal, #tableVal, newValue)
end

function vox_tables.insert(tableVal, index, newValue)
	tableVal[index] = newValue
end

function vox_tables.new(length, hash)
	local table = { }

	local addent = 0

	if hash then
		addent = 1
	end

	for i = 0, length do
		table[i + addent] = 0
	end

	return table
end

function vox_tables.alwaysTable(object)
	if object == nil or type(object) ~= "table" then
		return { }
	else
		return object;
	end
end

return vox_tables