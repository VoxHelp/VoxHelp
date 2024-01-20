vox_meta = { varsTable = { } }

function vox_meta:new(varsTable)
    local o = { varsTable = { } }
    setmetatable(o, self)
    self.__index = self
    self.varsTable = varsTable or { }
    return o
end

function vox_meta:setVar(x, y, z, varname, value)
   if self.varsTable[x] == nil then
      self.varsTable[x] = {}
   end

   if self.varsTable[x][y] == nil then
      self.varsTable[x][y] = {}
   end

   if self.varsTable[x][y][z] == nil then
      self.varsTable[x][y][z] = {}
   end

   self.varsTable[x][y][z][varname] = value
end

function vox_meta:getVar(x, y, z, varname)
   if self.varsTable[x] ~= nil then
       if self.varsTable[x][y] ~= nil then
            if self.varsTable[x][y][z] ~= nil then
               return self.varsTable[x][y][z][varname]
           end
       end
   end
   return nil
end