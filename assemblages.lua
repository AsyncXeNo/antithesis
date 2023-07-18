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
            return
        end

        --Player = true, Enemy = false
        local myTeam = parent.Player ~= nil
        local otherTeam = other.Player ~= nil

        -- myTeam <=/=> otherTeam
        if myTeam ~= otherTeam then
            if other.Stats.current.shield > 0 then
                other.Stats.current.shield = math.max(other.Stats.current.shield - parent.Stats.current.damage,0)
            else
                other.Stats.current.hp = other.Stats.current.hp - parent.Stats.current.damage
            end    
            self:destroy()
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
    :give("Information",
        "Projectile",
        "Simple",
        {radius = radius}
    )
end


function FancyProjectile(entity, parent, offset, velocity, index, speed)
    projectileBase(entity, parent, offset, velocity)
    :give("ComplexSpriteRenderer", index, speed)
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
    :give(
        "Information",
        "Fancy",
        {
            radius = math.max(entity.SimpleSpriteRenderer.loaded:getWidth()/2, entity.SimpleSpriteRenderer.loaded:getHeight()/2)
        }
    )
end
