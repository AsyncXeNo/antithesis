local concord = require("libs.Concord")
local inspect = require("libs.inspect").inspect
local log = require("libs.log")
local controls = require("controls")

require "utils"
require "assemblages"

-- COMPONENTS

--[[
    Controllable
]]
concord.component(
    "Controllable",

    function(component)
        component.vars = {}
    end
)


-- SYSTEMS
InputSystem = concord.system {
    enablePool = { "Controllable" },
    movePool = { "Controllable", "Movable"},
    shootPool = { "Controllable",  "Stats", "Information"}
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
    end

    for _,e in ipairs(self.shootPool) do
        
        e.Controllable.vars.timeElapsed = e.Controllable.vars.timeElapsed or 0
        if e.Controllable.vars.timeElapsed > 0 then
            e.Controllable.vars.timeElapsed = e.Controllable.vars.timeElapsed - dt
        end
        if (e.Controllable.shoot and e.Controllable.vars.timeElapsed <= 0) then
            log.info("Pew!")
            concord.entity(e:getWorld()):assemble(SimpleProjectile, e, {x=0,y=20}, {x=0,y=-1000}, 5, Color.fromRGB(224, 183, 16, 255), "fill")
            e.Controllable.vars.timeElapsed = 0.5
        end
    end

end