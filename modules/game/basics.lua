local concord = require "libs.Concord"
local log = require "libs.log"
local inspect = require("libs.inspect").inspect
require("utils")


-- COMPONENTS

--[[
    Player
]]
concord.component(
    "Player",
    function(component) 
        component.extendedHUD = false
    end
)

--[[
    Name
]]
concord.component(
    "Information",

    function(component, name, description, extra)

        component.name = name
        component.description = description
        
        component.extra = extra or {}
            
    end
)

--[[
    Stats
]]
concord.component(
    "Stats",

    function (component, damage, hp, shield, regen, armor, armor_pen)

        component.base = {
            damage = damage,
            maxHp = hp,
            armor = armor,
            armor_pen = armor_pen,
            maxShield = shield,
            regen = regen
        }

    end
)

--[[
    Position
]]
concord.component(
    "Position",

    function(component, x, y)

        component.x = x or 0
        component.y = y or 0

    end
)


--[[
    Movable
]]
concord.component(
    "Movable",

    function(component, vel, maxVel, acceleration, friction)

        component.vel = vel or { x = 0, y = 0 }
        component.maxVel = maxVel or { x = 3000, y = 3000 }
        component.acceleration = acceleration or { x = 0, y = 0 }
        component.friction = friction or { x = 0, y = 0 }

    end
)

-- SYSTEMS

--[[
    Movement System
]]

MovementSystem = concord.system {
    pool = { "Position", "Movable" }
}

function MovementSystem:update(dt)

    for _,e in ipairs(self.pool) do
        e.Movable.vel.x = math.clamp(
            e.Movable.vel.x + e.Movable.acceleration.x * dt,
            -e.Movable.maxVel.x,
            e.Movable.maxVel.x
        )
        e.Movable.vel.y = math.clamp(
            e.Movable.vel.y + e.Movable.acceleration.y * dt,
            -e.Movable.maxVel.y,
            e.Movable.maxVel.y
        )

        local newVelFriction = {
            x = e.Movable.vel.x - math.sign(e.Movable.vel.x) * e.Movable.friction.x * dt,
            y = e.Movable.vel.y - math.sign(e.Movable.vel.y) * e.Movable.friction.y * dt
        }

        local doesCrossZero = {
            x = (e.Movable.vel.x) * (newVelFriction.x) < 0,
            y = (e.Movable.vel.y) * (newVelFriction.y) < 0
        }

        if (e.Movable.vel.x ~= 0 and doesCrossZero.x) or (e.Movable.vel.x == 0) then
            e.Movable.vel.x = 0;
        else
            e.Movable.vel.x = newVelFriction.x
        end

        if (e.Movable.vel.y ~= 0 and doesCrossZero.y) or (e.Movable.vel.y == 0) then
            e.Movable.vel.y = 0;
        else
            e.Movable.vel.y = newVelFriction.y
        end
        
        e.Position.x = e.Position.x + e.Movable.vel.x * dt
        e.Position.y = e.Position.y + e.Movable.vel.y * dt

    end

end

--[[
    Stats System
]]

StatsSystem = concord.system{
    pool = { "Stats" }
}

function StatsSystem:update(dt)
    for _, e in ipairs(self.pool) do
        if e.Stats.current.hp <= 0 then
            if e.Information and e.Information.name == "Player" then
                log.error("Lol, player not found, game don't work. Git gud")
            end
            e:destroy()
        end
        
        e.Stats.current.shield = math.min(e.Stats.current.shield + e.Stats.current.regen * dt, e.Stats.current.maxShield)
    end
end