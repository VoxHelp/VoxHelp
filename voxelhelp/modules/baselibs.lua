local _load_script = load_script

local function load_script(path)
	path = path..".lua"

	if _load_script ~= nil then
		return _load_script("voxelhelp:pure/"..path)
	else
		return dofile("../pure/"..path)
	end
end

local luamath = load_script("luamath")
local luabit32 = load_script("luabit32")

luamath.internal.setbit32(luabit32)
luabit32.internal.setmath(luamath)

local function baselibs()
	math = luamath
	bit32 = luabit32
end

return baselibs, luamath, luabit32