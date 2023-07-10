local log = require "libs.log"
local inspect = require("libs.inspect").inspect


-- HELPERS

local function projectileBase(entity, parent, offset, velocity)
    return entity
    :give("Position",
        parent.Position.x + offset.x,
        parent.Position.y + offset.y
    )
    :give("Movable", {
        x = velocity.x,
        y = velocity.y
    })
end


local function getProjectileCollidingFunction(parent)

    return function(self, other)

        local isParentInvalid = parent.Stats == nil
        local isOtherInvalid = other.Stats == nil
        if (isParentInvalid or isOtherInvalid) then
            log.debug("Something is off. Add more info, lazy devs!")
            return
        end

        --Player = true, Enemy = false
        local myTeam = parent.Information ~= nil and parent.Information.name == "Player"
        local otherTeam = other.Information ~= nil and other.Information.name == "Player"

        if myTeam ~= otherTeam then
            other.Stats.current.hp = other.Stats.current.hp - parent.Stats.current.damage
        end

    end
    
end


--[[
    Projectile    
]]

function SimpleProjectile(entity, parent, offset, velocity, radius, color, mode)
    projectileBase(entity, parent, offset, velocity)
    :give("CircleRenderer", radius, color, mode)
    :give("Collider", "CIRCLE", {r=radius},  {x=0,y=0}, getProjectileCollidingFunction(parent))
end


function FancyProjectile(entity, parent, offset, velocity, sprite)
    projectileBase(entity, parent, offset, velocity)
    :give("SimpleSpriteRenderer", sprite)
    :give(
        "Collider",
        "CIRCLE",
        { r = entity.SimpleSpriteRenderer.loaded:getWidth() / 2 },
        {
            x = entity.SimpleSpriteRenderer.loaded:getWidth() / 2,
            y = entity.SimpleSpriteRenderer.loaded:getWidth() / 2
        },
        getProjectileCollidingFunction(parent)
    )
end
