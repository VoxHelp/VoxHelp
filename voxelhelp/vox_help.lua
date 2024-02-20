local vox_help = { version = "1.6" }

function vox_help.getAbsoluteVoxelHelpSavesPath(saving)
	local worldPath = "world:"
	local vhSavesPath = worldPath.."voxelhelp"

	if not file.exists(worldPath) and saving then
		file.mkdir(worldPath)
	end

	if not file.exists(vhSavesPath) and file.exists(worldPath) then
		if not pcall(file.mkdir, vhSavesPath) then
			print("Voxel Help: Failed to create \"voxelhelp\" directory in world save")
		end
	end

	return vhSavesPath
end

return vox_help