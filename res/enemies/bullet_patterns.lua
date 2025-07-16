ProjectilePattern = {}

function ProjectilePattern.base(color, mode, radius, starting_radius)
    return {
        color = color,
        mode = mode,
        radius = radius,
        start_radius = starting_radius
    }
end

function ProjectilePattern.line(base, num)
    return Table.join(base, {
        lines = num
    })
end

function ProjectilePattern.angles(base, start_angle, angle_diff)
    return Table.join(base,{
        start_angle = start_angle,
        end_angle = start_angle+angle_diff,
    })
end

function ProjectilePattern.speed(base, speed, interval)
    return Table.join(base, {
        speed = speed,
        interval = interval
    })
end

return ProjectilePattern