vox_tables = { }

function vox_tables.add(tableVal, newValue)
	vox_tables:insert(tableVal, #tableVal, newValue)
end

function vox_tables.insert(tableVal, index, newValue)
	tableVal[index] = newValue
end
