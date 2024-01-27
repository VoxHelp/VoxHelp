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
    return vox_math:rand_max(100) <= chance
end

function vox_math:randomAny()
    return vox_math:rand_max(2147483647)
end

function vox_math:rand_max(max)
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

function vox_math:random()
    return (vox_math:abs(math.sin(50/(world:get_day_time()-0.5))/math.cos(90/(world:get_day_time()-0.5))))%1
end


function vox_math:normaldist(mean, var)
    local function bxm()
        local u1, u2, r, theta = 0, 0, 0, 0
        repeat
          u1 = vox_math:random()
          u2 = vox_math:random()%10
          r = vox_math:sqrt(-2 * math.log(u1))
          theta = 2 * math.pi * u2
        until r ~= 0
        return r * vox_math:cos(theta), r * vox_math:sin(theta)
    end

    local _std = vox_math:sqrt(var)
    local x1, x2 = bxm()
    return mean + (_std * x1)

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

function vox_math:subfactorial(n)
    if n < 0 then error('err [n < 0]') end
    if n <= 1 then
        return 1 - n
    end
    local result = self:subfactorial(n - 1)
    return n * result - ((n % 2) == 0 and 1 or -1)
end


---------
function vox_math:pow(base, power)
    return base ^ power
end
  
function vox_math:clamp(n, min, max)
    if n > max then return max
    elseif n < min then return min
    else return n end
end

function vox_math:floor(n)
    return n - n % 1
end

function vox_math:round(n, ndp)
    if ndp == nil then ndp = 1 end
    local delta = 10^(ndp or 0)
    return vox_math:floor(n*delta+0.5)/delta
end

function vox_math:gcd(a, b)
    while b ~= 0 do a, b = b, a % b end
    return a
end

function vox_math:lcm(a, b)
    return a*b / vox_math:gcd(a, b)
end

function vox_math:sign(n)
    if n == 0 then
        return 0
    end

    return n / vox_math:abs(n)
end

 -- ф-ция для log
local function F(x)
    if x~=0 then return 1/x end  
end

function vox_math:integral(f,a,b) -- определённый интеграл 
    -- f <=> f(x) 
    -- например интегрирование f(x)= sin(x) от 0 до 1.57, тогда
    --  integral(sin,0,1.57) => 0.999... --> 1.
    --  integral(sin,-pi,pi) => 0
    --  [function vox_math:F(...)], a,b=... => integral(vox_math:F,a,b)
    --  [function G(...)], a1,a2=... => integral(G, a1, a2)
    local steps = 1e6
    local h = (b - a) / steps
    local sum = 0.5 * (f(a) + f(b))
    for i = 1, steps - 1 do
        sum = sum + f(a + i * h)
    end
    return vox_math:round(h * sum,6)
end


function vox_math:D(f,x) --диффур
    -- dy/dx <=> D(y, x) -- df/dx == D(f,x)
    -- [function vox_math:sin(t)] => D(vox_math:sin, x) 
    -- x=0 => D(sin, x) == 1  [y=sin(x) => dy/dx=cos(x)]
    -- omega=12, [function F(...)] => D(F, omega) == ...

    local h = 1e-12
    return (f(x+h)-f(x))/h
end



function vox_math:log(n, base) -- лог-м
    if base > 0 or base ~= 1 or n > 0 then
        return vox_math:integral(F,1,n) / vox_math:integral(F,1,base)
    end
end

function vox_math:ln(n) -- натуральный лог-м
    if n > 0 then return vox_math:integral(F,1,n) end
end

function vox_math:log10(n) -- десятичный лог-м ... log10 == lg == log(n=..., base=10)
    if n > 0 then return vox_math:integral(F,1,n)/vox_math:ln(10) end
end

function vox_math:exp(x) -- экспанента
    return vox_math:e()^x
end

function vox_math:sqrt(n) --радикал
    if n >= 0 then return n^(1/2) end
end

function vox_math:inverse_sqrt(x) -- обратный радикал
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
    return vox_math:deg(func)
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
-- x = ch(t)
-- y = sh(t)
-- при любых x => ch^2 - sh^2 = 1
-- sh(x + y) = sh(x) * ch(y) + ch(x) * sh(y)
-- sh(2x) = 2*sh(x)*ch(x)
-- ch(2x) = ch^2(x) + sh^2(y)
function vox_math:sh(n) -- гипербо-ий синус
    return ((vox_math:e()^n)-(vox_math:e()^(-n)))/2
end

function vox_math:ch(n) -- гипербо-ий косинус
    return ((vox_math:e()^n)+(vox_math:e()^(-n)))/2
end

function vox_math:tanh(x)
    return vox_math:sh(x)/vox_math:ch(x)
end

function vox_math:cth(x)
    return 1/vox_math:tanh(x)
end

function vox_math:sch(x)
    if x ~= 0 then return 1/vox_math:ch(x) end
end

function vox_math:csch(x)
    if x ~= 0 then return 1/vox_math:sh(x) end
end

function vox_math:arsh(x)
    return vox_math:ln(x+vox_math:sqrt(x^2+1))
end

function vox_math:arth(x)
    if vox_math:abs(x)<1 then 
        return vox_math:ln((vox_math:sqrt(1-x^2))/(1-x))
    end
end

function vox_math:arch(x)
    if x >= 1 then return vox_math:ln(x+vox_math:sqrt(x^2-1)) end
end

function vox_math:arcth(x)
    if vox_math:abs(x) > 1 then 
        return vox_math:ln((vox_math:sqrt(x^2-1))/(x-1))
    end
end

function vox_math:arsch(x)
    if x > 0 and x <= 1 then
        return vox_math:ln((1+vox_math:sqrt(1-x^2))/(x))
    end
end
------------------------------------------------


function vox_math:binonial(n, k)
    return vox_math:factorial(n) / (vox_math:factorial(k)*vox_math:factorial(n-k))
end


-- Поворота элемента на угол phi
local function rotate(x, y, phi)
    local newX = x * vox_math:cos(phi) - y * vox_math:sin(phi)
    local newY = x * vox_math:sin(phi) + y * vox_math:cos(phi)
    return newX, newY
  end

--



-- oper translate
function vox_math:rad(alpha) -- из градусов в радианы
    return (alpha*vox_math:pi())/180
end

function vox_math:deg(alpha) --из радианов в градусы
    return (alpha*180)/vox_math:pi()
end


function vox_math:cartToPolar(x,y) -- переход на полярные координаты
    local r = (x^2+y^2)^0.5
    local phi = vox_math:atan2(y,x)
    return r, phi
end

function vox_math:polarToCart(x,y) -- переход на декартовые координаты
    local r = x
    local phi = y
    return (r * vox_math:cos(phi)), (r * vox_math:sin(phi))
end
---
