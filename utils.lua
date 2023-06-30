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