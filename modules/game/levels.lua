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
    },
    shootPool = {
        "Timeline",
        "Stats"
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

        elseif action.type == "shoot" then

            if(e.Stats == nil) then
                log.error("Cannot perform action \"shoot\" without Stats component")
                e.Timeline.curIndex = e.Timeline.curIndex + 1
            end

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

    for _,e in ipairs(self.shootPool) do
        local action = e.Timeline.actions[e.Timeline.curIndex]

        if action == nil then return end

        if action.type == "shoot" then
            if (action.args.type == "burst") then

                e.Timeline.vars.lastShot = e.Timeline.vars.lastShot or 0

                -- Right is 0 deg and the angle goes sideways, like Unity
                -- Angle in degrees
                local start_angle = action.args.start_angle
                local end_angle = action.args.end_angle
                local number_lines = action.args.lines
                local offset = end_angle - start_angle / (number_lines-1)
                local speed = action.args.speed
                local parent_offset = action.args.start_radius

                local bullet_type = action.args.bullet_type

                local radius = action.args.radius
                local color = action.args.color
                local mode  = action.args.mode

                local sprite_index = action.args.sprite
                local sprite_speed = action.args.anim_speed

                local spawn_func
                if bullet_type == "simple" then
                    spawn_func = function(velocity, direction)
                        concord.entity(e:getWorld()):assemble(
                            SimpleProjectile, e,
                            {x = direction.x * parent_offset, y = direction.y * parent_offset},
                            velocity,
                            radius,
                            color,
                            mode
                        )
                    end
                elseif bullet_type == "fancy" then
                    spawn_func = function(velocity, direction)
                        concord.entity(e:getWorld()):assemble(
                            FancyProjectile, e,
                            {x = direction.x * parent_offset, y = direction.y * parent_offset},
                            velocity,
                            sprite_index,
                            sprite_speed
                        )
                    end
                end

                if (e.Timeline.vars.lastShot <= 0) then
                    for i=0,number_lines-1,1 do
                        local angle = start_angle + (offset * i)
                        local direction = {
                            x = math.cos(angle * math.pi / 180),
                            y = math.sin(angle * math.pi / 180)
                        }
                        local velocity = {
                            x = direction.x * speed,
                            y = direction.y * speed
                        }
                        spawn_func(velocity, direction)
                    end
                    e.Timeline.vars.lastShot = action.args.interval
                end

                action.args.duration = action.args.duration - dt
                e.Timeline.vars.lastShot = e.Timeline.vars.lastShot - dt

                if action.args.duration < 0 then
                    e.Timeline.vars.lastShot = nil
                    e.Timeline.curIndex = e.Timeline.curIndex + 1
                end
            end
        end
    end
end