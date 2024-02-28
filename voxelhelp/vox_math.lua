local vox_math = { 
    table_factorial = {
        1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 39916800, 
        479001600, 6227020800, 87178291200, 1307674368000, 20922789888000, 
        355687428096000, 6402373705728000, 121645100408832000, 
        2432902008176640000, 51090942171709440000, 1124000727777607680000, 
        25852016738884976640000, 620448401733239439360000, 
        15511210043330985984000000, 403291461126605635584000000, 
        10888869450418352160768000000, 304888344611713860501504000000, 
        8841761993739701954543616000000, 265252859812191058636308480000000,
        8222838654177922817725562880000000,
        263130836933693530167218012160000000,
        8683317618811886495518194401280000000}, 
    vector3 = { } 
}

-- Onran Part

-- vox_math.vector3

---Добавляет второй вектор к первому вектору и возвращает
-- @param x0y0z0 — первый вектор
-- @param x1y1z1 — второй вектор
-- @return Итоговый вектор
function vox_math.vector3.add(x0, y0, z0, x1, y1, z1)
    return x0 + x1, y0 + y1, z0 + z1
end

---Вычитает из первого вектора второй вектор и возвращает
-- @param x0y0z0 — первый вектор
-- @param x1y1z1 — второй вектор
-- @return Итоговый вектор
function vox_math.vector3.sub(x0, y0, z0, x1, y1, z1)
    return x0 - x1, y0 - y1, z0 - z1
end

---Умножает первый вектор на второй вектор и возвращает
-- @param x0y0z0 — первый вектор
-- @param x1y1z1 — второй вектор
-- @return Итоговый вектор
function vox_math.vector3.mul(x0, y0, z0, x1, y1, z1)
    return x0 * x1, y0 * y1, z0 * z1
end

---Делит первый вектор на второй и возвращает
-- @param x0y0z0 — первый вектор
-- @param x1y1z1 — второй вектор
-- @return Итоговый вектор
function vox_math.vector3.div(x0, y0, z0, x1, y1, z1)
    return x0 / x1, y0 / y1, z0 / z1
end

function vox_math.vector3.floordiv(x0, y0, z0, x1, y1, z1)
    return math.floor(x0/x1), math.floor(y0/y1), math.floor(z0/z1)

---Вычисляет величину вектора
-- @param xyz — вектор
-- @return Итоговый вектор
function vox_math.vector3.mag(x, y, z)
    return vox_math.sqrt(x*x+y*y+z*z)
end

---Переворачивает знаки значений вектора
-- @param xyz — вектор
-- @return Итоговый вектор
function vox_math.vector3.inverse(x, y, z)
    return -x, -y, -z
end

---Сравнивает 2 вектора
-- @param x0y0z0 — первый вектор
-- @param x1y1z1 — второй вектор
-- @return true если два вектора равны, иначе false
function vox_math.vector3.equals(x0, y0, z0, x1, y1, z1)
    return x0 == x1 and y0 == y1 and z0 == z1
end

---Округляет все значения вектора к меньшему
-- @param xyz — вектор
-- @return Округлённый к меньшему вектор
function vox_math.vector3.floor(x, y, z)
    return math.floor(x), math.floor(y), math.floor(z)
end

---Округляет все значения вектора к большему
-- @param xyz — вектор
-- @return Округлённый к большему вектор
function vox_math.vector3.ceil(x, y, z)
    return math.ceil(x), math.ceil(y), math.ceil(z)
end

---Округляет все значения вектора и возвращает вектор
-- @param xyz — вектор
-- @return Округлённый вектор
function vox_math.vector3.round(x, y, z)
    return vox_math.round(x), vox_math.round(y), vox_math.round(z)
end

---Вычисляет дистанцию между первым и вторым вектором
-- @param x0y0z0 — первый вектор
-- @param x1y1z1 — второй вектор
-- @return Дистанция между векторами
-- function by Cogitary
function vox_math.vector3.distance(x0,y0,z0,x1,y1,z1) -- дистанция от A(x0,y0,z0) до B(x1,y1,z1)
    return ((x1-x0)^2+(y1-y0)^2+(z1-z0)^2)^(0.5)
end

--

---Отсекает дробную часть числа и возвращает результат
-- @param n — число
-- @return Целая часть числа n
function vox_math.int(n)
    return n >= 0 and math.floor(n) or n - n % -1
end

-- Part by Cogitary

---Вычисляет факториал числа
-- @param n — число
-- @return Факториал числа n
function vox_math.factorial(n)
    if n < 33 then return vox_math.table_factorial[n]
    elseif n<0 then error("Voxel Help Math: Parameter \"n\" must always be greater than -1")
    else return n * vox_math.factorial(n - 1) end
end

---Вычисляет факториал числа без рекурсии
-- @param n — число
-- @return Факториал числа n
function vox_math.factorialSaves(n) -- non stack overflow
    if n < 33 then return vox_math.table_factorial[n]
    elseif n < 0 then error("Voxel Help Math: Parameter \"n\" must always be greater than -1") 
    else local f = 1 for i = 2, n do f = f * i end end
    return f
end

---Ограничение числа в определённом диапазоне
-- @param n — число
-- @param min — минимальное значение
-- @param max — максимальное значение
-- @return Если число n меньше min, то число min, если число n больше числа max, то число max, иначе число n
function vox_math.clamp(n,min,max) 
    return n > max and max or n < min and min or n 
end

---Округление числа
-- @param n — число
-- @return Целое число
function vox_math.round(n)
    return n >= 0 and math.floor(n + 0.5) or math.ceil(n - 0.5)
end

function vox_math.gcd(a, b) -- нод
    while b ~= 0 do a, b = b, a % b end
    return a
end

function vox_math.lcm(a, b) -- нок
    return a*b / vox_math.gcd(a, b)
end


--  Cокращает дроби
--- Приводит дробь к ее простейшей форме.
-- @param a — числитель дроби.
-- @param b — знаменатель дроби.
-- @return два целых числа, представляющих сокращенную форму дроби.
-- Пример: 5/10 уменьшается до 1/2, 
--         3/90 уменьшается до 1/30, 
--         2/54 уменьшается до 1/27.
-- использование: vox_math.reduct(5,10)
function vox_math.reduct(a, b) 
   local k = vox_math.gcd(a,b)
   return vox_math.int(a/k), vox_math.int(b/k)
end

---Вычисляет знак числа
-- @param n — число
-- @return Знак числа, если число равно нулю то 0, если число положительное то 1, если число отрицательное то -1
function vox_math.sign(n)-- определения знака
    return n < 0 and -1 or 1
end

--  Целочисленное деление (a//b)
--  @param a, b : [Real]
--  @return a//b : [int]
function vox_math.floordiv(a, b)
    return math.floor(a/b)
end

--Integrate (APPROX)
--- Вычисляет определенный интеграл функции `f` на интервале `[a, b]`.
-- Функция использует правило трапеций для аппроксимации определенного интеграла.
-- @function vox_math.integral
-- @param f Функция для интегрирования.
-- @param a Начало интервала интегрирования.
-- @param b Конец интервала, по которому производится интегрирование.
-- @return Примерное значение интеграла.

-- @usage
-- -- Пример: аппроксимировать интеграл sin(x) от 0 до pi/2 (1,57...)
-- >> print(vox_math.integral(math.sin, 0, 1.57)) -- Выводит 1
--
-- -- Пример: аппроксимировать интеграл sin(x) от -pi до pi
-- >> print(vox_math.integral(math.sin, -math.pi, math.pi)) -- Выводит 0

-- Пример: вычисление натурального логарифма с использованием определенного интеграла
--    function vox_math.ln(n)
--        if n > 0 then 
--             return vox_math.integral(F,1,n) 
--        end
--    end
function vox_math.integrate(f,a,b) 
    if math.abs(a-b) < 30 then
        local steps = 1e6
        local h = (b - a) / steps
        local sum = 0.5 * (f(a) + f(b))
        for i = 1, steps - 1 do
            sum = sum + f(a + i * h)
        end
        return vox_math.round(h * sum,6)
    end
end



--- Диффур (approx)
-- Функция работает как простой численный дифференциал (дифференциальный оператор)
-- Например, если у нас есть функция f(x) = sin(x) в точке x = 0 и мы хотим взять производную
--  f'(x) = cos(x), тогда мы будем использовать эту функцию как D(sin, 0) и результат должен быть 1, так как cos(0) = 1.
-- @param F - функция для дифференциации
-- @param x - точка, в которой будет рассчитана производная
-- @return производная функции в точке x
local Dfunc = function (F, x)
    if F == nil then return 0 end
    local h = 1e-10 
    return (F(x + h) - F(x)) / h
end
vox_math.D = Dfunc
vox_math.derivative = Dfunc


--- Экспанента
-- @param x - аргумент экспоненты
-- @return значение экспоненты в точке x
function vox_math.exp(x)
    return 2.71828182845904523536028747135^x
end

--- Дистанция между двумя 2D векторами
-- @param x0y0 - первый вектор
-- @param x1y1 - второй вектор
-- @return Дистанция между векторами
function vox_math.dist2(x0,y0,x1,y1) 
    return ((x1-x0)^2+(y1-y0)^2)^0.5
end

function vox_math.hypot(x, y)
    x = math.abs(x)
    y = math.abs(y)
    return x > y and x*(1 + (y / x) * (y / x))^0.5 or y*(1 + (x / y) * (x / y))^0.5
  end

--- Дистанция между двумя точками
-- @param x0 - первая точка
-- @param x1 - вторая точка
-- @return Дистанция между точками
function vox_math.distline(x0,x1)
    return math.abs(x1-x0)
end

---Вычисляет минимум и максимум двух чисел
-- @param num1 - первое число
-- @param num2 - второе число
-- @return Минимум и максимум
function vox_math.minmax(num1,num2)
    return math.min(num1,num2), math.max(num1,num2)
end

------------------------------------------------

-- Операции перевода
--- Переход к полярным координатам
-- @param x  x-координата в декартовой системе координат
-- @param y  y-координата в декартовой системе координат
-- @return r  Радиус в полярной системе координат
-- @return phi  Угол в полярной системе координат
function vox_math.toPolar(x,y)
    local r = (x*x+y*y)^0.5
    local phi = math.atan2(y,x)
    return r, phi
end

--- Переход к декартовым координатам
-- @param x  Радиус в полярной системе координат
-- @param y  Угол в полярной системе координат
-- @return  x-координата в декартовой системе координат
-- @return  y-координата в декартовой системе координат
function vox_math.toCart(x,y)
    local r = x
    local phi = y
    return (r * math.cos(phi)), (r * math.sin(phi))
end

--- Переход к цилиндрическим координатам
-- @param x  x-координата в декартовой системе координат
-- @param y  y-координата в декартовой системе координат
-- @param z  z-координата в декартовой системе координат
-- @return r  Радиус в цилиндрической системе координат
-- @return theta  Угол в цилиндрической системе координат
-- @return y  y-координата в декартовой системе координат (неизменная)
function  vox_math.toCylind(x, y, z)
    local r = (x*x + z*z)^0.5
    local theta = math.atan2(z, x)
    return r, theta, y
end


-- Static
--- Расчёт биномиального коэффициента nk
-- (Выполняет расчёт количества возможностей выбора k элементов из множества длиною в n элементов без учёта порядка)
-- @param n Количество элементов в множестве
-- @param k Количество выбранных элементов
-- @return Число комбинаций
function vox_math.binomial(n, k)
    if (k < 0) or (n < 0) or (k > n) then
        error("Voxel Help Math: Неверный(ые) параметр(ы)")
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


--- Расчёт количества комбинаций из n элементов по k
-- (Выполняет расчёт количества способов выбора k элементов из множества n элементов без учёта порядка)
-- @param n Количество элементов в множестве
-- @param k Количество выбранных элементов
-- @return Число комбинаций
function vox_math.combinations(n, k) 
    return vox_math.factorial(n) / (vox_math.factorial(k) * vox_math.factorial(n - k))
end

--- Подсчёт количества способов выбора n элементов из множества m
-- (Выполняет расчёт количества перестановок из n элементов без учёта порядка)
-- @param n Количество выбранных элементов
-- @param m Количество элементов в множестве
-- @return Число комбинаций или nil и сообщение об ошибке
function vox_math.A(n, m)
    if n < 0 or m < 0 or n > m then 
        return nil, "Некорректный ввод" 
    end
    local result = 1
    for i = m, m-n+1, -1 do 
        result = result * i 
    end
    return result
end

--  Пифагоровы тройки 
--  @param n, m (integer)
--  @return a,b,c (integer)
function pyth(m, n)
    local i = m*m
    local j = n*n
    return i-j,2*m*n,i+j
end


-- Символ Кронекера
function delta_kron(i,j)
    return 1 if i == j else 0
end

--  Проверка --
--  Является ли число квадратом другого числа.
function is_square(n)
    return n > 0 and math.floor(math.sqrt(n)) ^ 2 == n
end

--  Является ли число степенью другого числа.
function is_power(a, b)
    return a > 0 and b > 0 and math.floor(a ^ (1 / b)) ^ b == a
end

--  Является ли число числом Пифагора (число, которое дает три пары чисел).
function is_prime(n)
    if n < 2 then
        return false
    end
    for i = 2, math.ceil(math.sqrt(n)) do
        if n % i == 0 then
            return false
        end
    end
    return true
end

function is_perfect(n)
    local sum = 0
    for i = 1, n - 1 do
        if n % i == 0 then
            sum = sum + i
        end
    end
    return sum == n
end

-- function is_amicable(a, b)
--     local sum1 = 0
--     local sum2 = 0
--     for i = 1, a - 1 do
--         if a % i == 0 then
--             sum1 = sum1 + i
--         end
--     end
--     for j = 1, b - 1 do
--         if b % j == 0 then
--             sum2 = sum2 + j
--         end
--     end
--     return sum1 == sum2
-- end

function is_mersenne(n)
    return n > 1 and 2 ^ n - 1 == n
end

function is_pyth(n)
    local found = false
    for a = 1, n - 1 do
        for b = a, n - 1 do
            if a ^ 2 + b ^ 2 == n then
                found = true
                break
            end
        end
        if found then
            break
        end
    end
    return found
end

return vox_math
