local concord = require("libs.Concord")
local inspect = require("libs.inspect").inspect
local log = require("libs.log")
local controls = require("controls")

-- COMPONENTS

--[[
    Controllable
]]
concord.component(
    "Controllable",

    function(component, hp)

        component.hp = hp or 100
        
    end
)


-- SYSTEMS
InputSystem = concord.system {
    enablePool = { "Controllable" },
    movePool = { "Controllable", "Movable"}
}


function InputSystem:update(dt)

    for _,e in ipairs(self.enablePool) do

        for k,v in pairs(controls) do
            local flag = false
            for key,enabled in pairs(v) do
               if love.keyboard.isDown(key) then
                    flag = enabled
                    break
               end 
            end
            e.Controllable[k] = flag
        end
    end

    for _,e in ipairs(self.movePool) do
        -- log.info(math.toNumber(e.Controllable.moveRight) - math.toNumber(e.Controllable.moveLeft))
        local movDir = {
            x = math.toNumber(e.Controllable.moveRight) - math.toNumber(e.Controllable.moveLeft),
            y = math.toNumber(e.Controllable.moveDown) - math.toNumber(e.Controllable.moveUp)
        }
        -- log.info(inspect(movDir))
        movDir = Vector.normalize(movDir)

        local maxVel = {
            x = e.Movable.maxVel.x - math.toNumber(e.Controllable.precision) * (e.Movable.maxVel.x / 2),
            y = e.Movable.maxVel.y - math.toNumber(e.Controllable.precision) * (e.Movable.maxVel.y / 2)
        }
        
        -- log.info(inspect(maxVel))
        e.Movable.vel = {
            x = (math.toBool(movDir.x) and (movDir.x * maxVel.x) or e.Movable.vel.x),
            y = (math.toBool(movDir.y) and (movDir.y * maxVel.y) or e.Movable.vel.y)
        }
        log.info(inspect(e.Movable.vel))
    end

end