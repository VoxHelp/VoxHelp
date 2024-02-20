local vox_help = { version = "1.6" }

function vox_help.getAbsoluteVoxelHelpSavesPath()
	local path = "world:voxelhelp"

	if not file.exists(path) and file.exists("world:world.json") then
		if not pcall(file.mkdir, path) then
			print("Voxel Help: Failed to create \"voxelhelp\" directory in world save")
		end
	end

	return path
end

return vox_help