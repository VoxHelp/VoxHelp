local vox_container = {}

function vox_container:new(object)
    local o = { object = nil }
    setmetatable(o, self)
    self.__index = self
    self.object = object
    return o
end

function vox_container:get()
	return self.object
end

function vox_container:set(object)
	self.object = object
end

return vox_container