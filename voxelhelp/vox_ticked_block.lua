local vox_tables = load_script("voxelhelp:vox_tables.lua")
local vox_list = load_script("voxelhelp:vox_list.lua")
local vox_metadata = load_script("voxelhelp:vox_metadata.lua")

local vox_ticked_block = { onTick = nil }

local tickedBlocksTable = nil
local subscribedBlocks = nil
local blockName = nil
local initialized

function vox_ticked_block:tick(tps)
	if subscribedBlocks:size() > 0 then
	    for i = 0, subscribedBlocks:iterations() do
	    	if i < subscribedBlocks:size() then
		    	local subBlock = subscribedBlocks:get(i)
		    	local subBlockId = get_block(subBlock.x, subBlock.y, subBlock.z)

		    	if subBlockId ~= -1 then
				    vox_ticked_block.onTick(subBlock.x, subBlock.y, subBlock.z, tps)
				end
	    	end
	    end
	end
end

function vox_ticked_block:subscribe(x, y, z)
	subscribedBlocks:add({ x = x, y = y, z = z })

	vox_ticked_block:internal_updateSubscribedBlocksTable()
end

function vox_ticked_block:unsubscribe(x, y, z)
	if subscribedBlocks:size() > 0 then
		local someChanges = false

	    for i = 0, subscribedBlocks:iterations() do
	   	    if i < subscribedBlocks:size() then
		    	local block = subscribedBlocks:get(i)

			    if block.x == x and block.y == y and block.z == z then
			    	someChanges = true
			    	subscribedBlocks:removeAt(i)
			    end
			end
	    end

	    if someChanges then
	    	vox_ticked_block:internal_updateSubscribedBlocksTable()
		end
	end
end

function vox_ticked_block:internal_updateSubscribedBlocksTable()
	vox_metadata.setGlobalMetaByPath(blockName, subscribedBlocks:toArray(), { "voxelhelp", "tickedBlocks" })
end

function vox_ticked_block:initialized()
	return initialized
end

function vox_ticked_block:initialize(_blockName)
	if vox_ticked_block:initialized() then
		error("Voxel Help Ticked Block: Already initialized")
	end

	initialized = false

	blockName = _blockName
	
	subscribedBlocks = vox_arrays.toList(vox_tables.alwaysTable(vox_metadata.getGlobalMetaByPath(blockName, { "voxelhelp", "tickedBlocks" })))

	initialized = true
end

return vox_ticked_block