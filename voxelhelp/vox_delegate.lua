vox_delegate = { }

function vox_delegate:new(entry)
    local o = { entry = nil }
    setmetatable(o, self)
    self.__index = self
    self.entry = entry or nil
    return o
end

function vox_delegate:invoke(...)
	if self.entry == nil or self.entry.ref == nil then
		return nil
	else
		return self.entry.ref(...)
	end
end