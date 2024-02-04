vox_list = { }

function vox_list:fromElement(element)
    o = vox_list:new()
    o:add(element)
    return o
end

function vox_list:new(_size)
    local o = { _size = 0, _table = { } }
    setmetatable(o, self)
    self.__index = self
    self._size = _size or 0
    self._table = { }
    return o
end

function vox_list:toArray()
    local array = { }

    if self:size() > 0 then
        for i = 0, self:iterations() do
            array[i + 1] = self:get(i)
        end
    end

    return array
end

function vox_list:print()
    local msg = "Size: %i\nIterations: %i"
    print(msg:format(self:size(), self:iterations()))

    if self:size() > 0 then
        for i = 0, self:iterations() do
            print(self:get(i))
        end
    end
end

function vox_list:iterations()
    local size = self:size()

    if size <= 1 then return 0 else return size - 1 end
end

function vox_list:size()
    return self._size
end

function vox_list:addList(list)

    if list == nil or list:size() <= 0 then
        return false
    end

    for i = 0, list:iterations() do
        self:add(list:get(i))
    end

    return true
end

function vox_list:add(element)
    local setResult = self:set(element, self._size)

    if setResult then
        self._size = self._size + 1
    end
    
    return setResult
end

function vox_list:set(element, index)
    if index < 0 then
        return false
    end

    if self:size() < index then
        self._size = index
    end

    self._table[index] = element
    return true
end

function vox_list:get(index)
    if index > self:iterations() or index < 0 then
        local msg = "Invalid index %i, list size: %i, list iterations: %s"
        error(msg:format(index, self:size(), self:iterations()))
    end

    return self._table[index]
end

function vox_list:clone()
    local clone = vox_list:new()

    if self._size > 0 then
        for i = 0, self:iterations() do
            clone:add(self:get(i))
        end
    end

    return clone
end

function vox_list:contains(element)
    return self:indexOf(element) ~= -1
end

function vox_list:indexOf(element)

    for i = 0, self:iterations() do
        if self:get(i) == element then
            return i
        end
    end

    return -1
end

function vox_list:remove(element)
    return self:removeAt(self:indexOf(element))
end

function vox_list:removeAt(index)
    if index < 0 or index >= self._size then
        return false
    end

    local clone = vox_list:new()

    if self._size > 0 then
        for i = 0, self:iterations() do

            if i ~= index then
                clone:add(self:get(i))
            end
        end
    end
    
    self._table = clone._table
    self._size = clone._size

    return true
end