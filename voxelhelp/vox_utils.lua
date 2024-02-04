vox_arrays = load_script("voxelhelp:vox_arrays.lua")
load_script("voxelhelp:vox_runtime_meta.lua")
load_script("voxelhelp:vox_list.lua")

vox_utils = { }

function vox_utils.getShiftedPositionRelativeRotation(x, y, z, shift, states)
	if states == nil then
		states = get_block_states(x, y, z)
	end

	if states == 5 then
		y = y - shift
	elseif states == 4 then
		y = y + shift
	elseif states == 0 then
		z = z + shift
	elseif states == 2 then
		z = z - shift
	elseif states == 3 then
		x = x + shift
	elseif states == 1 then
		x = x - shift
	end

	return x, y, z
end

function vox_utils.toBlockIndices(namesList)
	local ids = vox_list:new()

	for i = 0, namesList:iterations() do
		ids:add(block_index(namesList:get(i)))
	end

	return ids
end

function vox_utils.toBlockNames(indicesList)
	local names = vox_list:new()

	for i = 0, indicesList:iterations() do
		names:add(block_name(indicesList:get(i)))
	end

	return names
end

function vox_utils.findClosestBlockAlongChain(x, y, z, chainBlockName, targetNames)
	return vox_utils.findClosestBlockAlongChainByIDs(x, y, z, block_index(chainBlockName), vox_utils.toBlockIndices(targetNames))
end

function vox_utils.findClosestBlockAlongChainByIDs(x, y, z, chainId, targetIds, checkedMeta)
	if checkedMeta == nil then
		checkedMeta = vox_runtime_meta:new()
	end

	for i = -1, 1, 2 do
		fx, fy, fz = vox_utils.internal_nextChain(x, y + i, z, chainId, targetIds, checkedMeta)
		if fy ~= -1 then
			return fx, fy, fz
		end

		fx, fy, fz = vox_utils.internal_nextChain(x + i, y, z, chainId, targetIds, checkedMeta)
		if fy ~= -1 then
			return fx, fy, fz
		end

		fx, fy, fz = vox_utils.internal_nextChain(x, y, z + i, chainId, targetIds, checkedMeta)
		if fy ~= -1 then
			return fx, fy, fz
		end
	end
	return -1, -1, -1
end

function vox_utils.internal_nextChain(x, y, z, chainId, targetIds, checkedMeta)
	if checkedMeta:getVar(x, y, z, "isChecked") then
		return -1, -1, -1
	else
		checkedMeta:setVar(x, y, z, "isChecked", true)
	end

	local blockId = get_block(x, y, z)

	if blockId == chainId then
		if vox_utils.isAnyBlockNearbyByIDs(x, y, z, targetIds) then
			return x, y, z
		end

		return vox_utils.findClosestBlockAlongChainByIDs(x, y, z, chainId, targetIds, checkedMeta)
	end
	return -1, -1, -1
end

function vox_utils.replaceBlocksAlongChain(x, y, z, targetBlockName, replacementBlockName)
	vox_utils.replaceBlocksAlongChainByIDs(x, y, z, block_index(targetBlockName), block_index(replacementBlockName))
end

function vox_utils.replaceBlocksAlongChainByIDs(x, y, z, targetId, replacementId)
	for i = -1, 1, 2 do
		vox_utils.internal_tryReplaceBlockAlongChain(x, y + i, z, targetId, replacementId)
		vox_utils.internal_tryReplaceBlockAlongChain(x + i, y, z, targetId, replacementId)
		vox_utils.internal_tryReplaceBlockAlongChain(x, y, z + i, targetId, replacementId)
	end
end

function vox_utils.internal_tryReplaceBlockAlongChain(x, y, z, targetId, replacementId)
	local blockId = get_block(x, y, z)
	if blockId == targetId and blockId ~= replacementId then
		set_block(x, y, z, replacementId, get_block_states(x, y, z))
		vox_utils.replaceBlocksAlongChainByIDs(x, y, z, targetId, replacementId)
	end
end

function vox_utils.replaceAnyBlocksNearby(x, y, z, blocksList, replacement)
	return vox_utils.replaceAnyBlocksNearbyByIDs(x, y, z, vox_utils.toBlockIndices(blocksList), block_index(replacement))
end

function vox_utils.replaceAnyBlocksNearbyByIDs(x, y, z, blocks, replacementId)
	for i = -1, 1, 2 do
		if blocks:contains(get_block(x + i, y, z)) then
			set_block(x + i, y, z, replacementId, get_block_states(x + i, y, z))
		end

		if blocks:contains(get_block(x, y + i, z)) then
			set_block(x, y + i, z, replacementId, get_block_states(x, y + i, z))
		end

		if blocks:contains(get_block(x, y, z + i)) then
			set_block(x, y, z + i, replacementId, get_block_states(x, y, z + i))
		end
	end
end

function vox_utils.getPositionsOfNearbyBlocks(x, y, z, blocksList)
	return vox_utils.getPositionsOfNearbyBlocksByIDs(x, y, z, vox_utils.toBlockIndices(blocksList))
end

function vox_utils.getNearbyBlocks(x, y, z)

	local nearbyBlocks = vox_list:new()

	for i = -1, 1, 2 do
		vox_utils.internal_addToNearbyBlocks(nearbyBlocks, x + i, y, z)
		vox_utils.internal_addToNearbyBlocks(nearbyBlocks, x, y + i, z)
		vox_utils.internal_addToNearbyBlocks(nearbyBlocks, x, y, z + i)
	end

	return nearbyBlocks
end

function vox_utils.internal_addToNearbyBlocks(nearbyBlocks, x, y, z)
	nearbyBlocks:add({ name = block_name(get_block(x, y, z)), x = x, y = y, z = z })
end

function vox_utils.getNearbyBlocksNames(x, y, z)

	local nearbyBlocks = vox_list:new()

	for i = -1, 1, 2 do
		nearbyBlocks:add(block_name(get_block(x + i, y, z)))
		nearbyBlocks:add(block_name(get_block(x, y + i, z)))
		nearbyBlocks:add(block_name(get_block(x, y, z + i)))
	end

	return nearbyBlocks
end

function vox_utils.getPositionsOfNearbyBlocksByIDs(x, y, z, blocks)

	local nearbyBlocks = vox_list:new()

	for i = -1, 1, 2 do
		vox_utils.internal_tryAddToNearbyBlocks(x + i, y, z, nearbyBlocks, blocks)
		vox_utils.internal_tryAddToNearbyBlocks(x, y + i, z, nearbyBlocks, blocks)
		vox_utils.internal_tryAddToNearbyBlocks(x, y, z + i, nearbyBlocks, blocks)
	end

	return nearbyBlocks
end

function vox_utils.internal_tryAddToNearbyBlocks(x, y, z, nearbyBlocks, blocks)
	if blocks:contains(get_block(x, y, z)) then
		nearbyBlocks:add( { x = x, y = y, z = z } )
	end
end

function vox_utils.isAnyBlockNearby(x, y, z, blocksList)
	return vox_utils.isAnyBlockNearbyByIDs(x, y, z, vox_utils.toBlockIndices(blocksList))
end

function vox_utils.isAnyBlockNearbyByIDs(x, y, z, blocks)

	for i = -1, 1, 2 do
		if blocks:contains(get_block(x + i, y, z)) then
			return true
		end

		if blocks:contains(get_block(x , y + i, z)) then
			return true
		end

		if blocks:contains(get_block(x, y, z + i)) then
			return true
		end
	end
	return false
end

return vox_utils