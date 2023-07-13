local log = require "libs.log"

require("constants")

Vector = {}
List = {}
States = {}
Color = {}
math.easingFunctions = {}

function math.clamp(x, min, max)

    if x < min then return min end
    if x > max then return max end
    return x

end

function math.sign(num)

    if (num < 0) then return -1
    elseif (num > 0) then return 1
    else return 0 end

end

function math.round(num)
    return math.floor(num+0.5)
end

function math.lerp(a, b, t)
    return a + (b-a) * t
end

function math.easingFunctions.easeInOutSine(a, b, t)
    
end

function math.easingFunctions.easeInOutQuint(a, b, t)
    return a + (b-a) * ((t < 0.5) and (16 * math.pow(t,5)) or (1 - math.pow(-2 * t + 2, 5) / 2))
end

function Vector.magnitude(vec)
    return math.sqrt(vec.x*vec.x + vec.y*vec.y)
end

function List.combineLists(t1, t2)
    local t3 = {}
    for i=1,#t1 do
        t3[i] = t1[i]
    end
    for i=#t3+1,#t2+#t3+1 do
        t3[i] = t2[i-#t3]
    end
    return t3
end

function Color.fromRGB(red, blue, green, alpha)

    return {red/255, blue/255, green/255, alpha/255}

end

function Vector.normalize(vec)
    local mag = Vector.magnitude(vec)
    return {
        x = vec.x / (math.toBool(mag) and mag or 1),
        y = vec.y / (math.toBool(mag) and mag or 1)
    }
end

function math.toNumber(bool)
    if (bool) then return 1 else return 0 end
end

function math.toBool(num)
    if (num ~= 0) then return true else return false end
end

function States.table(tab, state)
    tab[ENTRY_STATE] = state
    return tab
end