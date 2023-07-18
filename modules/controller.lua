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
        component.held = {}
        component.pressed = {}
    end
)


-- SYSTEMS
InputSystem = concord.system {
    enablePool = { "Controllable" },
    movePool = { "Controllable", "Movable"},
    shootPool = { "Controllable",  "Stats", "Information"},
    metaPool = { "Controllable", "Player"},
    otherScreenPool = { "Controllable", "Background" }
}


function InputSystem:keypressed(pressed, scancode, isrepeat)
    for _,e in ipairs(self.enablePool) do

        for k,v in pairs(controls) do
            for key,enabled in pairs(v) do
                if (key == pressed) and enabled then
                    e.Controllable.pressed[k] = true
                end
            end
        end
    end
end


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
            e.Controllable.held[k] = flag
        end
    end

    for _,e in ipairs(self.movePool) do
        -- log.info(math.toNumber(e.Controllable.moveRight) - math.toNumber(e.Controllable.moveLeft))
        local movDir = {
            x = math.toNumber(e.Controllable.held.moveRight) - math.toNumber(e.Controllable.held.moveLeft),
            y = math.toNumber(e.Controllable.held.moveDown) - math.toNumber(e.Controllable.held.moveUp)
        }
        -- log.info(inspect(movDir))
        movDir = Vector.normalize(movDir)

        local maxVel = {
            x = e.Movable.maxVel.x - math.toNumber(e.Controllable.held.precision) * (e.Movable.maxVel.x / 2),
            y = e.Movable.maxVel.y - math.toNumber(e.Controllable.held.precision) * (e.Movable.maxVel.y / 2)
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
        if (e.Controllable.held.shoot and e.Controllable.vars.timeElapsed <= 0) then
            log.info("Pew!")
            concord.entity(e:getWorld()):assemble(SimpleProjectile, e, {x=0,y=20}, {x=0,y=-1000}, 5, Color.fromRGB(224, 183, 16, 255), "fill")
            e.Controllable.vars.timeElapsed = 0.3
        end
    end

    for _,e in ipairs(self.metaPool) do

        if (e.Controllable.pressed.pause) then

            love.graphics.captureScreenshot( function (image)
                
                concord.entity(GameState.pause_menu)
                    :give("Background", love.graphics.newImage(image), 0.6)
                    :give("Controllable")
                    :give("Menu", {
                        {name = "Continue", value = function() log.info("Continuing, supposedly...") end},
                        {name = "Options", value = function() log.info("OPTIONS") end},
                        {name = "Main Menu", value = function() log.info("Does not exist...") end},
                        {name = "Exit", value = function()
                            love.event.quit()
                        end},
                    }, {2})
                    
                CurrentGameState = "pause_menu"
                log.debug("switching to pause menu")
                
            end)

            e.Controllable.pressed.pause = nil

        end

    end

    for _, e in ipairs(self.otherScreenPool) do
        
        if (e.Controllable.pressed.pause) then
            
            if (CurrentGameState == "pause_menu") then
                
                GameState.pause_menu:clear()
                CurrentGameState = "game"
                log.debug("switching back to game")

            end
            e.Controllable.pressed.pause = nil
        end

    end

end