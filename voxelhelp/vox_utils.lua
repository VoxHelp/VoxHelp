local vox_arrays = load_script("voxelhelp:vox_arrays.lua")
local vox_math = load_script("voxelhelp:vox_math.lua")
local vox_list = load_script("voxelhelp:vox_list.lua")

local vox_utils = { }

function vox_utils.getShiftedPositionRelativeRotation(x, y, z, shift)
	local coords = { }

	coords[1], coords[2], coords[3] = vox_utils.getBlockDirectionVector(x, y, z)

	for i = 1, #coords do
		if coords[i] ~= 0 then
			if coords[i] < 0 then
				coords[i] = -shift
			else
				coords[i] = shift
			end
		end
	end

	return vox_math.vector3.add(x, y, z, coords[1], coords[2], coords[3])
end

local directions =
{
	["1000010-10"] = { 0, 0, 1 },
	["001-1000-10"] = { -1, 0, 0 },
	["-10000-10-10"] = { 0, 0, -1 },
	["00-11000-10"] = { 1, 0, 0 },
	["100010001"] = { 0, 1, 0 },
	["1000-1000-1"] = { 0, -1, 0 }
}

function vox_utils.blockRotationIsPositive(x, y, z)
	local dirX, dirY, dirZ = vox_utils.getBlockDirectionVector(x, y, z)

	if dirX == -1 or dirY == -1 or dirZ == -1 then
		return false
	else
		return true
	end
end

function vox_utils.blockRotationIsNegative(x, y, z)
	return not vox_utils.blockRotationIsPositive(x, y, z)
end

function vox_utils.getBlockDirectionVector(x, y, z)
	local xrx, xry, xrz = get_block_X(x, y, z)
	local yrx, yry, yrz = get_block_Y(x, y, z)
	local zrx, zry, zrz = get_block_Z(x, y, z)

	local direction = directions[xrx..xry..xrz..yrx..yry..yrz..zrx..zry..zrz]

	if direction == nil then
		return nil, nil, nil
	else
		return direction[1], direction[2], direction[3]
	end
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
		checkedMeta = { }
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
	local key = x..y..z

	if checkedMeta[key] then
		return -1, -1, -1
	else
		checkedMeta[key] = true
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

function vox_utils.stop()
	while true do end
end

return vox_utils