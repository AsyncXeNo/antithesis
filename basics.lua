local concord = require "libs.Concord"
local log = require "libs.log"
local inspect = require("libs.inspect").inspect
require("utils")


-- COMPONENTS

--[[
    Name
]]
concord.component(
    "Information",

    function(component, name, description)

        component.name = name
        component.description = description
            
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