local concord = require("libs.Concord")
local inspect = require("libs.inspect").inspect
local log = require("libs.log")

-- COMPONENTS

--[[
    Timeline
]]
concord.component(
    "Timeline",

    function (component, actions)

        component.actions = actions
        component.curIndex = 1
        component.vars = {}

    end
)

-- SYSTEMS

TimelineSystem = concord.system {
    generalPool = {
        "Timeline",
    },
    movPool = {
        "Timeline",
        "Position",
    },
    advMovPool = {
        "Timeline",
        "Movable",
        "Position",
    }
}

function TimelineSystem:update(dt)

    for _, e in ipairs(self.generalPool) do
        local action = e.Timeline.actions[e.Timeline.curIndex]

        if action == nil then
            e:getWorld():removeEntity(e)
            return

        elseif action.type == "move" then

            if(e.Position == nil) then
                log.error("Cannot perform action \"move\" without Position component")
                e.Timeline.curIndex = e.Timeline.curIndex + 1
            end

        elseif action.type == "wait" then
            
            if action.args.duration < 0 then
                e.Timeline.curIndex = e.Timeline.curIndex + 1
            end
            action.args.duration = action.args.duration - dt
            
        end
    end
    
    for _, e in ipairs(self.movPool) do
        local action = e.Timeline.actions[e.Timeline.curIndex]

        if action.type == "move" then
            if e.Timeline.vars.initialPos == nil then
                e.Timeline.vars.initialPos = {
                    x = e.Position.x,
                    y = e.Position.y
                }
            end

            e.Timeline.vars.timePassed = (e.Timeline.vars.timePassed or 0) + dt
            
            local desiredLocation = {
                x = action.args.pos.x,
                y = action.args.pos.y,
            }

            local t = e.Timeline.vars.timePassed / action.args.duration
            
            local nextLocation

            if action.args.func ~= nil then
                nextLocation = {
                    x = action.args.func(e.Timeline.vars.initialPos.x, desiredLocation.x, t),
                    y = action.args.func(e.Timeline.vars.initialPos.y, desiredLocation.y, t)
                }
            else
                nextLocation = {
                    x = math.lerp(e.Timeline.vars.initialPos.x, desiredLocation.x, t),
                    y = math.lerp(e.Timeline.vars.initialPos.y, desiredLocation.y, t)
                }
            end

            if e.Timeline.vars.timePassed > action.args.duration then
                e.Timeline.vars.timePassed = nil
                e.Timeline.vars.initialPos = nil
                e.Timeline.curIndex = e.Timeline.curIndex + 1
            else
                e.Position.x = nextLocation.x
                e.Position.y = nextLocation.y
            end
        end
    end
end