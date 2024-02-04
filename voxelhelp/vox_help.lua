vox_help = { version = "1.6" }

function vox_help.getAbsoluteVoxelHelpSavesPath(saving)
	local path = file.resolve("world:voxelhelp")

	local worldPath = file.resolve("world:")

	local mkdirVoxelHelp = true

	if not file.exists(worldPath) then
		if saving then
			file.mkdir(worldPath)
		else
			mkdirVoxelHelp = false
		end
	end

	if not file.exists(path) and mkdirVoxelHelp then
		if not pcall(file.mkdir, path) then
			print("Voxel Help: Failed to create \"voxelhelp\" directory in world save")
		end
	end

	return path
end

return vox_help