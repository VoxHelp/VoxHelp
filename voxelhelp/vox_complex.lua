-- Complex Operation
-- z = a + bi 
local vox_complex = {}
vox_complex.__index = vox_complex

function vox_complex.new(real, imag)
   local self = setmetatable({}, vox_complex)
   self.real = real or 0
   self.imag = imag or 0
   return self
end

function vox_complex.__add(c1, c2)
   return vox_complex.new(c1.real + c2.real, c1.imag + c2.imag)
end

function vox_complex.__sub(c1, c2)
   return vox_complex.new(c1.real - c2.real, c1.imag - c2.imag)
end


function vox_complex.__mul(c1, c2)
   return vox_complex.new(c1.real * c2.real - c1.imag * c2.imag, c1.real * c2.imag + c1.imag * c2.real)
end

function vox_complex.__eq(c1, c2)
    return c1.real == c2.real and c1.imag == c2.imag
end

function vox_complex:abs() --модуль числа (a) -> a:abs()
    return vox_math.sqrt(self.real^2 + self.imag^2)
end
 
function vox_complex:conjugate() -- сопряженное число (a) -> a:conjugate()
    return vox_complex.new(self.real, -self.imag)
end

function vox_complex.__div(c1, c2)
    local denominator = c2:abs() ^ 2
    local numerator = c1 * c2:conjugate()
    return vox_complex.new(numerator.real / denominator, numerator.imag / denominator)
end


function vox_complex.__tostring(c) --вывод
    return c.real .. " + " .. c.imag .. "i"
end 
