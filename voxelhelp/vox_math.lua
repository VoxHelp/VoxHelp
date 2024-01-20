-- Xertis Part

vox_math = { }

local math_data = { }

function vox_math:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function vox_math:abs(n)
    if n < 0 then
        n = -n
    end
    
    return n
end

function vox_math:max(num1, num2)
    local maxx = 0
    if num1 > num2 then
        maxx = num1
    elseif num1 <= num2 then
        maxx = num2
    end
    return maxx
end
        
function vox_math:min(num1, num2)
    local minn = 1000
    if num1 < num2 then
        minn = num2
    elseif num1 <= num2 then
        minn = num1
    end
    return minn
end

-- Onran Part

function vox_math:e()
    return 2.71828182846
end

function vox_math:pi()
    return 3.14159265358979323846
end

function vox_math:positive_infinity()
    return 1.0 / 0.0
end

function vox_math:negative_infinity()
    return -1.0 / 0.0
end

function vox_math:cos(x)
    local pi = vox_math:pi()
    while x < 0 do 
        x = x + 2 * pi 
    end

    while x > 2 * pi do 
        x = x - 2 * pi
    end
    local t = 1;
    local cos = t;
    local a = 1
    while a < 40 do
        local mult = -x * x / ( (2 * a)* (2 * a - 1))
        t = t * mult
        cos = cos + t
        a = a + 1
    end
    return cos;
end

function vox_math:int(n)
    if n >= 0 then
        return vox_math:floor(n)
    else
        return n - n % -1
    end
end

function vox_math:ceil(n)
    local nint = vox_math:int(n)
    if n <= 0 then
        return nint
    else
        if nint == n then
            return nint
        else
            return nint + 1
        end
    end
end

function vox_math:generateRandomSeed()
    local time = world.get_day_time();
    local  wseed = world.get_seed();
    return time * (wseed * 2)
end

function vox_math:randomseed(randomseed)
    math_data["seed"] = randomseed
end

function vox_math:random1to2()
    return vox_math:randomBool(50)
end

function vox_math:randomBool(chance)
    return vox_math:random(100) <= chance
end

function vox_math:randomAny()
    return vox_math:random(2147483647)
end

function vox_math:random(max)
    if math_data["seed"] == nil then
        math_data["seed"] = vox_math:generateRandomSeed()
    end

    math_data["seed"] = (710425941047 * math_data["seed"] + 813633012810) % 711719770602
    local result = seed
    if max < result then
        result = result % max
    end

    return result
end

-- Part by function (kraject)

function vox_math:sin(x)
    local term
    local sin = 0
    local sign = 1
    local pow = 1
    local epsilon = 1e-16

    while true do
        term = sign * ((x ^ pow) /  vox_math:factorial(pow))
        sin = sin + term
        if vox_math:abs(term) < epsilon then
            break
        end
        sign = -sign
        pow = pow + 2
    end

    return sin

end

function vox_math:factorial(n)
    local fact = 1
    for i = 2, n do
        fact = fact * i
    end
    return fact
end

function vox_math:pow(base, power)
    return base ^ power
end

function vox_math:clamp(n,min,max)
    if n > max then return max
    elseif n < min then return min
    else return n end
end

function vox_math:floor(n)
    return n - n % 1
end

function vox_math:round(n)
    local powerResult = vox_math:pow(2, 52)
    return n + powerResult - powerResult    
end

function vox_math:sign(n)
    if n == 0 then
        return 0
    end

    return n / vox_math:abs(n)
end

 -- vox_math:internal_f(x) для log
function vox_math:internal_f(x)
    return 1/x  
end

function vox_math:integral(f,a,b) -- определённый интеграл 
    local steps = 1e6
    local h = (b - a) / steps
    local sum = 0.5 * (vox_math:internal_f(a) + vox_math:internal_f(b))
    for i = 1, steps - 1 do
        sum = sum + vox_math:internal_f(a + i * h)
    end
    return h * sum
end

function vox_math:log(n, base)
    if base > 0 or base ~= 1 or n > 0 then
        return vox_math:integral(f,1,n) / vox_math:integral(f,1,base)
    end
end

function vox_math:ln(n) -- натуральный лог-м
    if n > 0 then return vox_math:integral(f,1,n) end
end

function vox_math:log10(n) -- десятичный лог-м ... log10 == lg == log(n=..., base=10)
    if n > 0 then return vox_math:integral(f,1,n)/vox_math:ln(10) end
end

function vox_math:exp(x) -- экспанента
    return vox_math:e()^x
end

function vox_math:sqrt(n) --радикал
    if n >= 0 then return n^(1/2) end
end

function vox_math:inverse_sqrt(x)
    return 1/vox_math:sqrt(x)
end

function vox_math:modf(n) -- возврат целой и дробной части
    return vox_math:floor(n),vox_math:abs(vox_math:floor(n)-n)
end

function vox_math:dist(x0,y0,z0,x1,y1,z1) -- дистанция от A(x0,y0,z0) до B(x1,y1,z1)
    if x0 and y0 and z0 and x1 and y1 and z1 ~= nil then 
        return ((x1-x0)^2+(y1-y0)^2+(z1-z0)^2)^(1/2)
    end
end

function vox_math:tan(n)  -- tg == tan
    if n~=0 then return vox_math:sin(n)/vox_math:cos(n) end
end

function vox_math:ctan(n) -- ctg == cot == ctan
    if n~=0 then return vox_math:cos(n)/vox_math:sin(n) end
end

function vox_math:sec(n)
    if n~=0 then return 1/vox_math:cos(n) end
end

function vox_math:cosec(n)
    if n~=0 then return 1/vox_math:sin(n) end
end

-- reverse trigonometric func
function vox_math:atan2(y, x)
    local func = 0
    local k = y/x
    for n=0,1000 do
        func = func + ((-1)^n)*((k^(2*n+1))/(2*n+1))
    end
    return vox_math:rad_to_deg(func)
end

function vox_math:atan(y, x)
    local func = 0
    local k = y/x
    for n=0,1000 do
        func = func + ((-1)^n)*((k^(2*n+1))/(2*n+1))
    end
    return func
end

-- hyperbolic func (base)
-- решения задач связанных для описания поворотов в двумерных подпространствах.
function vox_math:sh(n)
    return ((vox_math:e()^n)-(vox_math:e()^(-n)))/2
end

function vox_math:ch(n)
    return ((vox_math:e()^n)+(vox_math:e()^(-n)))/2
end

--
function vox_math:cartesianToPolar(x,y) -- переход на полярные координаты
    local r = (x^2+y^2)^0.5
    local phi = vox_math:atan2(y,x)
    return r, phi
end

function vox_math:polarToCartesian(x,y) -- переход на декартовые координаты
    local r = x
    local phi = y
    return (r * vox_math:cos(phi)), (r * vox_math:sin(phi))
end


-- oper translate
function vox_math:deg_to_rad(alpha) -- из градусов в радианы
    return (alpha*vox_math:pi())/180
end

function vox_math:rad_to_deg(alpha) --из радианов в градусы
    return (alpha*180)/vox_math:pi()
end