local luamath = { 
    e = 2.71828182845904523536028747135, 
    pi = 3.14159265358979323846264338328, 
    half_pi = 1.5707963267948966192, -- Pi/2
    two_pi = 6.2831853071795864769, -- 2*Pi
    radian = 57.2957795130823208767981548141, -- 1 rad == 53 deg
    sqrt_two = 1.41421356237309504880168872421, -- sqrt(2)
    phi = 1.61803398874989484820458683437, --golden rot
    huge = 1.0 / 0.0, 
    internal = { 
        randMax = 32767, 
        holdrand = 0, 
        log2 = 0.69314718055994530942, 
        nan = 0 / 0 
    } 
}

local bit32 = bit32

function luamath.internal.setbit32(newbit32)
    bit32 = newbit32
end

-- random functions
function luamath.random(min, max)
    local r = luamath.internal.rand() % luamath.internal.randMax / luamath.internal.randMax

    if min == nil and max == nil then
        return r
    elseif max == nil then
        return luamath.floor(r*min)+1
    elseif min == nil then
        error("max isn't nil, but min is nil")
    else
        return luamath.floor(r*(min-max+1))+max
    end
end

function luamath.randomseed(seed)
    luamath.internal.holdrand = seed
    luamath.internal.rand()
end

function luamath.internal.rand()
    luamath.internal.holdrand = luamath.internal.holdrand * 214013 + 2531011
    return bit32.band(bit32.rshift(luamath.internal.holdrand, 16), luamath.internal.randMax)
end

--

function luamath.internal.factorial(n)
    if n == 0 then return 1
    elseif n<0 then error("err [n!]<0")
    else return n * luamath.internal.factorial(n - 1) end
end

function luamath.internal.int(n)
    return n >= 0 and luamath.floor(n) or n - n % -1
end

function luamath.internal.round(n)
    return n >= 0 and luamath.floor(n + 0.5) or luamath.ceil(n - 0.5)
end

--

function luamath.ceil(n)
    local nint = luamath.internal.int(n)
    return n > nint and nint + 1 or nint
end

function luamath.abs(n)
    return n < 0 and -n or n
end

function luamath.max(num1, num2)
    return (num1 >= num2) and num1 or num2
end

function luamath.min(num1, num2)
    return (num1 <= num2) and num1 or num2
end

function luamath.pow(base, power)
    return base ^ power
end


function luamath.floor(n)
    return n - n % 1
end

function luamath.fmod(x, y)
    return x - luamath.floor(x / y) * y
end

--- Возврат целой и дробной части
-- @param  число
-- @return целая часть, дробная часть числа
function luamath.modf(x)
    local floored = luamath.floor(x)
    return floored, luamath.abs(floored-x)
end

--- Экспанента
-- @param x - аргумент экспоненты
-- @return значение экспоненты в точке x
function luamath.exp(x)
    return luamath.e^x
end

-- hyperbolic func
-- x = ch(t)
-- y = sh(t)
function luamath.sinh(x) -- гипербо-ий синус
    return (luamath.e^x-luamath.e^(-x))/2
end

function luamath.cosh(x)
    return (luamath.e^x+luamath.e^(-x))/2
end

function luamath.tanh(x)
    local t = x
    if (t>=0 and t) or -t < 800 then
        return (luamath.e^t-luamath.e^(-t))/(luamath.e^(-t)+luamath.e^t)
    else return t > 0 and 1 or t < 0 and -1 or 0 end
end

function luamath.internal.f(x)
    if x~=0 then return 1/x end  
end

function luamath.internal.integral(f,a,b)
    local steps = 1e6
    local h = (b - a) / steps
    local sum = 0.5 * (luamath.internal.f(a) + luamath.internal.f(b))
    for i = 1, steps - 1 do
        sum = sum + luamath.internal.f(a + i * h)
    end
    return h * sum
end

function luamath.log(n, base)
    if base == nil then
        return luamath.internal.ln(n) or luamath.internal.nan
    end

    if base > 0 or base ~= 1 or n > 0 then
        return luamath.internal.integral(F,1,n) / luamath.internal.integral(F,1,base)
    end
end

function luamath.internal.ln(n)
    if n > 0 then return luamath.internal.integral(F,1,n) end
end

function luamath.log10(n)
    if n > 0 then return luamath.internal.integral(F,1,n)/2.3025850929940456840 end
end

function luamath.sqrt(n)
    if n >= 0 then return n^(0.5) end
end

function luamath.sin(t)
    t = t%6.28318530718
    return t - t^3/6 + t^5/120 - t^7/5040 + t^9/362880 - t^11/39916800 + t^13/6227020800 - t^15/1307674368000 + t^17/355687428096000 - t^19/121645100408832000 + t^21/51090942171709440000 - t^23/25852016738884976640000 + t^25/15511210043330985984000000 - t^27/10888869450418352160768000000 + t^29/8841761993739701954543616000000 - t^31/8222838654177922817725562880000000 + t^33/8683317618811886495518194401280000000 - t^35/10333147966386144929666651337523200000000 + t^37/13763753091226345046315979581580902400000000
end

function luamath.cos(t)
    return luamath.sin(t + luamath.half_pi)
end

function luamath.tan(n)
    if n~=0 then return luamath.sin(n)/luamath.cos(n) end
end

function luamath.sec(t)
    return 1/luamath.cos(t)
end

function luamath.csc(t)
    return 1/luamath.sin(t)
end

function luamath.atan(t)
    if t < 1 and t > -1 then
        return (-t + t^3/3 - t^5/5 + t^7/7 - t^9/9 + t^11/11 - t^13/13 + t^15/15 - t^17/17 + t^19/19 - t^21/21 + t^23/23 - t^25/25 + t^27/27 - t^29/29 + t^31/31 - t^33/33 + t^35/35 - t^37/37 + t^39/39 - t^41/41 + t^43/43 - t^45/45 + t^47/47 - t^49/49 + t^51/51 - t^53/53 + t^55/55 - t^57/57 + t^59/59 - t^61/61 + t^63/63 - t^65/65 + t^67/67 - t^69/69 + t^71/71 - t^73/73 + t^75/75 - t^77/77 + t^79/79 - t^81/81 + t^83/83 - t^85/85 + t^87/87 - t^89/89 + t^91/91 - t^93/93 + t^95/95 - t^97/97 + t^99/99 - t^101/101 + t^103/103 - t^105/105 + t^107/107 - t^109/109 + t^111/111 - t^113/113 + t^115/115 - t^117/117 + t^119/119 - t^121/121 + t^123/123 - t^125/125 + t^127/127 - t^129/129 + t^131/131 - t^133/133 + t^135/135 - t^137/137 + t^139/139 - t^141/141)*(-1)
    else
        return -(1/(201*t^201)) + 1/(199*t^199) - 1/(197*t^197) + 1/(195*t^195) - 1/(193*t^193) + 1/(191*t^191) - 1/(189*t^189) + 1/(187*t^187) - 1/(185*t^185) + 1/(183*t^183) - 1/(181*t^181) + 1/(179*t^179) - 1/(177*t^177) + 1/(175*t^175) - 1/(173*t^173) + 1/(171*t^171) - 1/(169*t^169) + 1/(167*t^167) - 1/(165*t^165) + 1/(163*t^163) - 1/(161*t^161) + 1/(159*t^159) - 1/(157*t^157) + 1/(155*t^155) - 1/(153*t^153) + 1/(151*t^151) - 1/(149*t^149) + 1/(147*t^147) - 1/(145*t^145) + 1/(143*t^143) - 1/(141*t^141) + 1/(139*t^139) - 1/(137*t^137) + 1/(135*t^135) - 1/(133*t^133) + 1/(131*t^131) - 1/(129*t^129) + 1/(127*t^127) - 1/(125*t^125) + 1/(123*t^123) - 1/(121*t^121) + 1/(119*t^119) - 1/(117*t^117) + 1/(115*t^115) - 1/(113*t^113) + 1/(111*t^111) - 1/(109*t^109) + 1/(107*t^107) - 1/(105*t^105) + 1/(103*t^103) - 1/(101*t^101) + 1/(99*t^99) - 1/(97*t^97) + 1/(95*t^95) - 1/(93*t^93) + 1/(91*t^91) - 1/(89*t^89) + 1/(87*t^87) - 1/(85*t^85) + 1/(83*t^83) - 1/(81*t^81) + 1/(79*t^79) - 1/(77*t^77) + 1/(75*t^75) - 1/(73*t^73) + 1/(71*t^71) - 1/(69*t^69) + 1/(67*t^67) - 1/(65*t^65) + 1/(63*t^63) - 1/(61*t^61) + 1/(59*t^59) - 1/(57*t^57) + 1/(55*t^55) - 1/(53*t^53) + 1/(51*t^51) - 1/(49*t^49) + 1/(47*t^47) - 1/(45*t^45) + 1/(43*t^43) - 1/(41*t^41) + 1/(39*t^39) - 1/(37*t^37) + 1/(35*t^35) - 1/(33*t^33) + 1/(31*t^31) - 1/(29*t^29) + 1/(27*t^27) - 1/(25*t^25) + 1/(23*t^23) - 1/(21*t^21) + 1/(19*t^19) - 1/(17*t^17) + 1/(15*t^15) - 1/(13*t^13) + 1/(11*t^11) - 1/(9*t^9) + 1/(7*t^7) - 1/(5*t^5) + 1/(3*t^3) + (-2 + luamath.pi * (t^2)^0.5)/(2*t)
    end
end

function luamath.atan2(y, x)
    return luamath.atan(y/x)
end

function luamath.asin(t)
    if t < -luamath.half_pi or t > luamath.half_pi then return luamath.internal.nan end
    return t +t^3/6 + (3*t^5)/40 + (5*t^7)/112 + (35*t^9)/1152 + (63*t^11)/2816 + (231*t^13)/13312 + (143*t^15)/10240 + (6435*t^17)/557056 + (12155*t^19)/1245184 + (46189*t^21)/5505024 + (88179*t^23)/12058624 + (676039*t^25)/104857600 + (1300075*t^27)/226492416 + (5014575*t^29)/973078528 + (9694845*t^31)/2080374784 + (100180065*t^33)/23622320128 + (116680311*t^35)/30064771072 + (2268783825*t^37)/635655159808 + (1472719325*t^39)/446676598784 + (34461632205*t^41)/11269994184704 + (67282234305*t^43)/23639499997184 + (17534158031*t^45)/6597069766656 + (514589420475*t^47)/206708186021888 + (8061900920775*t^49)/3448068464705536 + (5267108601573*t^51)/2392537302040576 + (61989816618513*t^53)/29836347531329536 + (121683714103007*t^55)/61924494876344320 + (956086325095055*t^57)/513410357520236544 + (1879204156221315*t^59)/1062849512059437056 + (7391536347803839*t^61)/4395513236313604096 + (2077805148460987*t^63)/1297036692682702848 + (916312070471295267*t^65)/599519182395560427520 + (1804857108504066435*t^67)/1235931852938539958272 + (2371086789603381395*t^69)/1697100454781278748672 + (14023284727082855679*t^71)/10477750633867025317888 + (110628135069209194801*t^73)/86183188312371025149952 + (218266320541953276229*t^75)/177088743107611695513600 + (123082511583808238475*t^77)/103892062623132194701312 + (1701063429324939500975*t^79)/1492267808586807887527936 + (26876802183334044115405*t^81)/24480747847196240787800064 + (53098072606098965203605*t^83)/50170421514007110750306304 + (41972762155297277256183*t^85)/41103477866897391940009984 + (138282355937994905688975*t^87)/140235395075296984265916416 + (3281063172710606398620225*t^89)/3443020734262463889563189248 + (927030547210298315800635*t^91)/1005826281919371473355538432 + (8558238530042898944420355*t^93)/9594035304461697130468212736 + (10160632127157314065928847*t^95)/11760430373211112611541680128 + (1608766753466574727105400775*t^97)/1921282940970910186643440795648 + (353855725819178568093478175*t^99)/435754893828453856764491726848 + (12611418068195524166851562157 *t^101)/16004088827881396193895877967872 + (24975553429171528252000152507*t^103)/32642002955876907088540107538432 + (65961077005247882306564505339*t^105)/88735542015976058104769224376320 + (392032816163265715595619229845*t^107)/542554456897682183840588971900928 + (1553611530721090058101157688645*t^109)/2210782646798032076210250390175744 + (1026325193021811008078946594317*t^111)/1500898310670223611372096595165184 + (48823755610894723670041316558223*t^113)/73341193126804440252993260650233856 + (96790954105808838152888925808407*t^115)/149278534682876294320251769465077760 + (127942065772046165374508350206515*t^117)/202499577482858277512689356839583744 + (761146865864206848244956456313335*t^119)/1235766652331288975590258126354382848 + (6038431802522707662743321220085791*t^121)/10052286718123426288835040893370105856
end

function luamath.acos(x)
    if x < -1 or x > 1 then return luamath.internal.nan end
    if x == -1 then return luamath.pi end
    if x ==  0 then return luamath.half_pi end
    if x ==  1 then return 0 end
    return 2*luamath.asin(0.7071067811865475244*(1-x)^(0.5))
end

function luamath.rad(alpha)
    return alpha*0.01745329251994329576923690768
end

function luamath.deg(alpha)
    return alpha*luamath.radian

function luamath.ldexp(x, pow)
    return x * (2 ^ pow)
end

function luamath.frexp(x)
    if x == 0 then return 0.0,0.0 end
    local e = luamath.floor(luamath.log(luamath.abs(x)) / luamath.internal.log2)
    if e > 0 then
        x = x * 2^-e
    else
        x = x / 2^e
    end

    if luamath.abs(x) >= 1.0 then
        x,e = x/2,e+1
    end

    return x,e
end

return luamath
