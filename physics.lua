local concord = require 'libs.Concord'
local inspect = require('libs.inspect')
local log = require 'libs.log'


-- COMPONENTS

--[[
    Collider
]]
concord.component(
    "Collider",

    function (component, type, values, offset, colliding_func)

        component.type = type  -- BOX | CIRCLE
        component.values = values
        component.offset = offset or { x = 0, y = 0 }
        component.colliding_func = colliding_func or function() end
        
    end
)


-- SYSTEMS

CollisionSystem = concord.system{
    pool = {"Position", "Collider" },
    debugPool = {"Position", "Collider", "Information"}
}

function CollisionSystem:update(dt)

    for _,e1 in ipairs(self.pool) do
        for _,e2 in ipairs(self.pool) do
            if (e1 ~= e2) then
                if (self:isColliding(e1, e2)) then
                    log.info("Colliding!")
                    e1.Collider.colliding_func(e1, e2)
                end
            end
        end
    end

    for _,e1 in ipairs(self.debugPool) do
        for _,e2 in ipairs(self.debugPool) do
            if (e1 ~= e2) then
                if (self:isColliding(e1, e2)) then
                    log.info("Colliding!")
                    log.info("e1: " .. e1.Information.name)
                    log.info("e2: " .. e2.Information.name)
                end
            end
        end
    end

end


function CollisionSystem:isColliding(c1, c2)
    if c1.Collider.type == "BOX" then
        if c2.Collider.type == "BOX" then return self:collidingBB(c1, c2)
        elseif c2.Collider.type == "CIRCLE" then return self:collidingBC(c1, c2)
        end
    elseif c1.Collider.type == "CIRCLE" then
        if c2.Collider.type == "BOX" then return self:collidingBC(c2, c1)
        elseif c2.Collider.type == "CIRCLE" then return self:collidingCC(c1, c2)
        end
    end
end


function CollisionSystem:collidingBB(b1,b2)
    local distance = {}
    distance.x = math.abs(b1.Position.x - b2.Position.x)
    distance.y = math.abs(b1.Position.y - b2.Position.y)
    
    local w1 = b1.Collider.values.width/2
    local w2 = b2.Collider.values.width/2
    local h1 = b1.Collider.values.height/2
    local h2 = b2.Collider.values.height/2
    
    local x_axis = distance.x <= w1+w2
    local y_axis = distance.y <= h1+h2
    
    return x_axis and y_axis
end


function CollisionSystem:collidingBC(b,c)
    local distance = {}
    distance.x = math.abs(c.Position.x - b.Position.x)
    distance.y = math.abs(c.Position.y - b.Position.y)

    if (distance.x > (b.Collider.values.width / 2 + c.Collider.values.r)) then return false end
    if (distance.y > (b.Collider.values.height / 2 + c.Collider.values.r)) then return false end

    if (distance.x <= (b.Collider.values.width / 2)) then return true end 
    if (distance.y <= (b.Collider.values.height / 2)) then return true end

    local cornerDistance_sq = (distance.x - b.Collider.values.width/2)^2 + (distance.y - b.Collider.values.height/2)^2

    return (cornerDistance_sq <= (c.Collider.values.r^2))
end


function CollisionSystem:collidingCC(c1, c2)
    local r1 = c1.Collider.values.r
    local r2 = c2.Collider.values.r
    local distance = math.sqrt((c1.Position.x - c2.Position.x)^2 + (c1.Position.y - c2.Position.y)^2)
    if distance > r1+r2 then return false end
    return true
end
