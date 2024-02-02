-- Xertis Part

vox_math = { }

function vox_math.new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function vox_math.abs(n)
    return n < 0 and -n or n
end

function vox_math.max(num1, num2)
    return (num1 >= num2) and num1 or num2
end

function vox_math.min(num1, num2)
    return (num1 <= num2) and num1 or num2
end


-- Onran Part

function vox_math.e()
    return 2.71828182846
end

function vox_math.pi()
    return 3.14159265358979323846
end

function vox_math.positive_infinity()
    return 1.0 / 0.0
end

function vox_math.negative_infinity()
    return -1.0 / 0.0
end


function vox_math.int(n)
    return n >= 0 and vox_math.floor(n) or n - n % -1
end

function vox_math.ceil(n)
    local nint = vox_math.int(n)
    return n > nint and nint + 1 or nint
end

-- Part by function (kraject)

function vox_math.factorial(n)
    if n == 0 then return 1
    elseif n<0 then error("err [n!]<0")
    else return n * vox_math.factorial(n - 1) end
end

function vox_math.pow(base, power)
    return base ^ power
end

function vox_math.clamp(n,min,max)
    if n > max then return max
    elseif n < min then return min
    else return n end
end

function vox_math.floor(n)
    return n - n % 1
end

function vox_math.round(n)
    return num >= 0 and vox_math.floor(num + 0.5) or vox_math.ceil(num - 0.5)
end

function vox_math.gcd(a, b) -- нод
    while b ~= 0 do a, b = b, a % b end
    return a
end

function vox_math.lcm(a, b) -- нок
    return a*b / vox_math.gcd(a, b)
end

function vox_math.reduct(a, b) --сокращает дроби
    -- 5/10 -> 1/2
    -- 3/90 -> 1/30
    -- 2/54 -> 1/27 
   local k = vox_math.gcd(a,b)
   return (a//k),(b//k)
end

function vox_math.sign(n) -- определения знака
    if n == 0 then
        return 0
    end

    return n / vox_math.abs(n)
end

function vox_math.modf(n) -- возврат целой и дробной части
    return vox_math.floor(n),vox_math.abs(vox_math.floor(n)-n)
end

local function F(x)
    if x~=0 then return 1/x end  
end

function vox_math.integral(f,a,b) -- определённый интеграл 
    -- f <=> f(x) 
    -- например интегрирование f(x)= sin(x) от 0 до 1.57..., тогда
    --  integral(sin,0,1.57...) => 0.999... --> 1.
    --  integral(sin,-pi,pi) => 0
    --  [function vox_math.F(...)], a,b=... => integral(vox_math.F,a,b)
    --  [function G(...)], a1,a2=... => integral(G, a1, a2)
    local steps = 1e6
    local h = (b - a) / steps
    local sum = 0.5 * (f(a) + f(b))
    for i = 1, steps - 1 do
        sum = sum + f(a + i * h)
    end
    return vox_math.round(h * sum,6)
end


function vox_math.D(f,x) --диффур
    --      dy/dx <=> D(y, x) -- df/dx == D(f,x)
    --      [function vox_math.sin(t)] => D(vox_math.sin, x) 
    --      x=0 => D(sin, x) == 1  [y=sin(x) => dy/dx=cos(x)]
    --      omega=12, [function F(...)] => D(F, omega) == ...

    local h = 1e-12
    return (f(x+h)-f(x))/h
end

function vox_math.log(n, base) -- лог-м
    if base > 0 or base ~= 1 or n > 0 then
        return vox_math.integral(F,1,n) / vox_math.integral(F,1,base)
    end
end

function vox_math.ln(n) -- натуральный лог-м
    if n > 0 then return vox_math.integral(F,1,n) end
end

function vox_math.log10(n) -- десятичный лог-м ... log10 == lg == log(n=..., base=10)
    if n > 0 then return vox_math.integral(F,1,n)/vox_math.ln(10) end
end


function vox_math.exp(x) -- экспанента
    return vox_math.e()^x
end

function vox_math.sqrt(n) --радикал
    if n >= 0 then return n^(1/2) end
end

function vox_math.inverse_sqrt(x)
    return 1/vox_math.sqrt(x)
end

function vox_math.modf(n) -- возврат целой и дробной части
    return vox_math.floor(n),vox_math.abs(vox_math.floor(n)-n)
end

function vox_math.dist(x0,y0,z0,x1,y1,z1) -- дистанция от A(x0,y0,z0) до B(x1,y1,z1)
    if x0 and y0 and z0 and x1 and y1 and z1 ~= nil then 
        return ((x1-x0)^2+(y1-y0)^2+(z1-z0)^2)^(1/2)
    end
end

function vox_math.dist2(x0,y0,x1,y1) 
    return vox_math.sqrt((x1-x0)^2+(y1-y0)^2)
end

function vox_math.hypot(x,y)
    return vox_math.sqrt(x*x+y*y)
end

function vox_math.distline(x0,x1)
    return vox_math.abs(x1-x0)
end


--trigonometric func
function vox_math.sin(x)
    local t = x%(vox_math.pi()*2)
    local term
    local sin = 0
    local sign = 1
    local pow = 1
    local epsilon = 1e-16

    while true do
        term = sign * ((t ^ pow) /  vox_math.factorial(pow))
        sin = sin + term
        if vox_math.abs(term) < epsilon then
            break
        end
        sign = -sign
        pow = pow + 2
    end
    return sin

end

function vox_math.cos(x)
    return vox_math.sin(x + vox_math.pi()/2)
end


function vox_math.tan(n)  -- tg == tan
    if n~=0 then return vox_math.sin(n)/vox_math.cos(n) end
end

function vox_math.ctan(n) -- ctg == cot == ctan
    if n~=0 then return vox_math.cos(n)/vox_math.sin(n) end
end

function vox_math.sec(n)
    if n~=0 then return 1/vox_math.cos(n) end
end

function vox_math.cosec(n)
    if n~=0 then return 1/vox_math.sin(n) end
end

-- reverse trigonometric func
function vox_math.atan2(y, x)
    local func = 0
    local k = y/x
    for n=0,1000 do
        func = func + ((-1)^n)*((k^(2*n+1))/(2*n+1))
    end
    return func
end



-- hyperbolic func
-- x = ch(t)
-- y = sh(t)
function vox_math.sh(n) -- гипербо-ий синус
    return ((vox_math.e()^n)-(vox_math.e()^(-n)))/2
end

function vox_math.ch(n) -- гипербо-ий косинус
    return ((vox_math.e()^n)+(vox_math.e()^(-n)))/2
end

function vox_math.tanh(x)
    return vox_math.sh(x)/vox_math.ch(x)
end

function vox_math.cth(x)
    return 1/vox_math.tanh(x)
end

function vox_math.sch(x)
    if x ~= 0 then return 1/vox_math.ch(x) end
end

function vox_math.csch(x)
    if x ~= 0 then return 1/vox_math.sh(x) end
end

function vox_math.arsh(x)
    return vox_math.ln(x+vox_math.sqrt(x^2+1))
end

function vox_math.arth(x)
    if vox_math.abs(x)<1 then 
        return vox_math.ln((vox_math.sqrt(1-x^2))/(1-x))
    end
end

function vox_math.arch(x)
    if x >= 1 then return vox_math.ln(x+vox_math.sqrt(x^2-1)) end
end

function vox_math.arcth(x)
    if vox_math.abs(x) > 1 then 
        return vox_math.ln((vox_math.sqrt(x^2-1))/(x-1))
    end
end

function vox_math.arsch(x)
    if x > 0 and x <= 1 then
        return vox_math.ln((1+vox_math.sqrt(1-x^2))/(x))
    end
end

------------------------------------------------



-- oper translate
function vox_math.rad(alpha) -- из градусов в радианы
    return (alpha*vox_math.pi())/180
end

function vox_math.deg(alpha) --из радианов в градусы
    return (alpha*180)/vox_math.pi()
end

function vox_math.toPolar(x,y) -- переход на полярные координаты
    local r = (x^2+y^2)^0.5
    local phi = vox_math.atan2(y,x)
    return r, phi
end

function vox_math.toCart(x,y) -- переход на декартовые координаты
    local r = x
    local phi = y
    return (r * vox_math.cos(phi)), (r * vox_math.sin(phi))
end

function  vox_math.toCylind(x, y, z) -- переход в цилиндрические координаты
    local r = vox_math.sqrt(x*x + z*z)
    local theta = vox_math.atan2(z, x) --возврат угла в градусах
    return r, theta, y
end

--Static
function vox_math.Binomial(n, k)
    if (k < 0) or (n < 0) or (k > n) then
        error("404")
    end
    if k > n/2 then
        k = n - k
    end
    local result = 1.0
    for i = 1, k do
        result = result * (n - (k - i))
        result = result / i
    end
    return result
end

function vox_math.A(n, m)
    if n < 0 or m < 0 or n > m then
        return nil, "Invalid input"
    end
    local result = 1
    for i = m, m-n+1, -1 do
        result = result * i
    end
    return result
end

--Experimental Func (Random)
function vox_math.generateRandomSeed(iteration) -- 
    local time = world.get_day_time() / iteration * vox_math.randomLargeInt()
    local  worldSeed = world.get_seed();
    return time * (worldSeed * 2)
end


function vox_math.randomLargeInt() -- Большие числа (Не зависит от итераций)
    return vox_math.round(vox_math.random()*vox_math.pi()*78319*world.get_day_time(),0)
end

function vox_math.randomInt(min, max, iteration) -- Числа на отрезке (Зависит от итераций)
    if iteration == nil then
        iteration = world.get_day_time() / 59
    end
    
    local m = 2385482343
    local aa = 48271      
    local c = 0          
    local seed = vox_math.generateRandomSeed(iteration)       

    seed = (min * seed + c) % m

    return vox_math.abs(vox_math.floor((seed / (m / (max - min + 1))) + min))
end

function vox_math.random()
    local daytime = world.get_day_time()
    return (vox_math.abs(vox_math.sin(3/(daytime-0.5))/vox_math.cos(2/(daytime-0.5))))
end

return vox_math
