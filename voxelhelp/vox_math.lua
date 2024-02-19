local vox_math = { vector3 = { } }

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
    return math.round(x), math.round(y), math.round(z)
end

---Вычисляет дистанцию между первым и вторым вектором
-- @param x0y0z0 — первый вектор
-- @param x1y1z1 — второй вектор
-- @return Дистанция между векторами
-- function by Cogitary
function vox_math.vector3.distance(x0,y0,z0,x1,y1,z1) -- дистанция от A(x0,y0,z0) до B(x1,y1,z1)
    return ((x1-x0)^2+(y1-y0)^2+(z1-z0)^2)^(1/2)
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
    if n == 0 then return 1
    elseif n<0 then error("Voxel Help Math: Parameter \"n\" must always be greater than -1")
    else return n * vox_math.factorial(n - 1) end
end

---Вычисляет факториал числа без рекурсии
-- @param n — число
-- @return Факториал числа n
function vox_math.factorialSaves(n) -- non stack overflow
    if n < 0 then error("Voxel Help Math: Parameter \"n\" must always be greater than -1") end
    local f = 1 for i = 2, n do f = f * i end
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
    return n == 0 and 0 or n / math.abs(n)
end

--- Вычисляет определенный интеграл функции `f` на интервале `[a, b]`.
-- Функция использует правило трапеций для аппроксимации определенного интеграла.
-- @function vox_math.integral
-- @param f Функция для интегрирования.
-- @param a Начало интервала интегрирования.
-- @param b Конец интервала, по которому производится интегрирование.
-- @return Примерное значение интеграла.

-- @usage
-- -- Пример: аппроксимировать интеграл sin(x) от 0 до pi/2 (1,57...)
-- print(vox_math.integral(math.sin, 0, 1.57)) -- Выводит 1
--
-- -- Пример: аппроксимировать интеграл sin(x) от -pi до pi
-- print(vox_math.integral(math.sin, -math.pi, math.pi)) -- Выводит 0

-- Пример: вычисление натурального логарифма с использованием определенного интеграла
--    function vox_math.ln(n)
--        if n > 0 then 
--             return vox_math.integral(F,1,n) 
--        end
--    end
function vox_math.integral(f,a,b) 
    local steps = 1e6
    local h = (b - a) / steps
    local sum = 0.5 * (f(a) + f(b))
    for i = 1, steps - 1 do
        sum = sum + f(a + i * h)
    end
    return vox_math.round(h * sum,6)
end


-- Диффур
--- Функция работает как простой численный дифференциал (дифференциальный оператор)
-- Например, если у нас есть функция f(x) = sin(x) в точке x = 0 и мы хотим взять производную
--  f'(x) = cos(x), тогда мы будем использовать эту функцию как D(sin, 0) и результат должен быть 1, так как cos(0) = 1.
-- @param f - функция для дифференциации
-- @param x - точка, в которой будет рассчитана производная
-- @return производная функции в точке x
function vox_math.D(f, x)
    local h = 1e-12  -- точность 
    return (f(x + h) - f(x)) / h
end


--- Экспанента
-- @param x - аргумент экспоненты
-- @return значение экспоненты в точке x
function vox_math.exp(x)
    return math.e^x
end

--- Дистанция между двумя 2D векторами
-- @param x0y0 - первый вектор
-- @param x1y1 - второй вектор
-- @return Дистанция между векторами
function vox_math.dist2(x0,y0,x1,y1) 
    return ((x1-x0)^2+(y1-y0)^2)^0.5
end

function vox_math.hypot(x,y)
    return (x*x+y*y)^0.5
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

function vox_math.coth(x) -- гипербо-ий котангенс
    return 1/vox_math.tanh(x)
end

function vox_math.sch(x) -- гипербо-ий секас
    if x ~= 0 then return 1/vox_math.ch(x) end
end

function vox_math.csch(x) -- гипербо-ий косекас
    if x ~= 0 then return 1/vox_math.sh(x) end
end

function vox_math.arsh(x) -- гипербо-ий обратный синус
    return vox_math.ln(x+(x^2+1)^0.5)
end

function vox_math.arth(x) -- гипербо-ий обратный тангенс
    if math.abs(x)<1 then 
        return vox_math.ln(((1-x^2)^0.5)/(1-x))
    end
end

function vox_math.arch(x) -- гипербо-ий обратный косинус
    if x >= 1 then return vox_math.ln(x+(x^2-1)^0.5) end
end

function vox_math.arcth(x) -- гипербо-ий обратный котангенс
    if math.abs(x) > 1 then 
        return vox_math.ln(((x^2-1)^0.5)/(x-1))
    end
end

function vox_math.arsch(x) -- гипербо-ий обратный секас
    if x > 0 and x <= 1 then
        return vox_math.ln((1+(1-x^2)^0.5)/(x))
    end
end

------------------------------------------------

-- Операции перевода


--- Переход к полярным координатам
-- @param x  x-координата в декартовой системе координат
-- @param y  y-координата в декартовой системе координат
-- @return r  Радиус в полярной системе координат
-- @return phi  Угол в полярной системе координат
function vox_math.toPolar(x,y)
    local r = (x^2+y^2)^0.5
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

return vox_math