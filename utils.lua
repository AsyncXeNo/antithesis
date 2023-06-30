Vector = {}

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

function Vector.magnitude(vec)
    return math.sqrt(vec.x*vec.x + vec.y*vec.y)
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