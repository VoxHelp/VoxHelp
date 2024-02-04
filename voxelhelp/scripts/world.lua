load_script("voxelhelp:vox_metadata.lua")

function on_world_open()
	print("Voxel Help: Loading metadata")
	vox_metadata.internal_load()
end

function on_world_save()
	print("Voxel Help: Saving metadata")
	vox_metadata.internal_store()
end