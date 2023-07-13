local concord = require "libs.Concord"
local log = require "libs.log"
local inspect = require ("libs.inspect")
require "constants"
local spritesheetIndex = require "res.spritesheets"
local sprites = require "res.sprites"
-- COMPONENTS

--[[
    SimpleSpriteRenderer
]]
concord.component(
    "SimpleSpriteRenderer",

    function(component, sprite)

        component.sprite = sprite or log.error('No sprite')
        component.loaded = love.graphics.newImage(SPRITES_PATH .. spritesheetIndex[component.sprite].path)

    end
)

--[[
    ComplexSpriteRenderer
]]
concord.component (
    "ComplexSpriteRenderer",

    function(component, index, speed, frame)
        
        component.index = index or log.error('No sprite')
        component.speed = speed
        component.frame = frame or 0
        component.quads = {}
        local sprite = spritesheetIndex[component.index]
        component.spritesheet = love.graphics.newImage(SPRITES_PATH .. sprite.path)
        local no_col = component.spritesheet:getWidth() / sprite.size.x
        for i=1, sprite.frames, 1 do
            component.quads[i] = love.graphics.newQuad(
                ((i-1) % no_col) * sprite.size.x + (math.max((i-2),0) % no_col) * sprite.padding.x,
                math.floor((i-1) / no_col) * sprite.size.y + math.floor(math.max((i-2),0) / no_col) * sprite.padding.y,
                sprite.size.x,
                sprite.size.y,
                component.spritesheet:getWidth(),
                component.spritesheet:getHeight()
            )
        end
    end
)

--[[
    Animator
]]
concord.component(
    "Animator",

    function(component, states, transitions, variables)
        
        component.states = states
        component.currentState = states[ENTRY_STATE]
        component.transitions = transitions
        component.variables = variables

        for _,t in ipairs(component.transitions) do
            if #t.condition % 2 == 0 then
                t.condition[#t.condition] = nil
            end
        end

    end
)

--[[
    Box Renderer
]]
concord.component(
    "BoxRenderer",

    function(component, width, height, color, mode)

        component.width = width or 50
        component.height = height or 50
        component.color = color or {1, 0, 0, 1}
        component.mode = mode or "fill"

    end
)


--[[
    CircleRenderer
]]
concord.component(
    "CircleRenderer",
    
    function(component, radius, color, mode)

        component.radius = radius or 0
        component.color = color or {1, 0, 0, 1}
        component.mode = "fill"

    end
)

--[[
    Particles
]]
concord.component(
    "Particles",

    function(component, texture, buffer, config_func, fizzle_out, duration)
        component.system = love.graphics.newParticleSystem(love.graphics.newImage(SPRITES_PATH .. sprites[texture].path), buffer)
        config_func(component.system)
        component.fizzle_out = fizzle_out
        component.duration = duration
    end
)

--SYSTEMS

--[[
    RenderSystem
]]
RenderSystem = concord.system {
    boxPool = {"Position", "BoxRenderer"},
    circlePool = {"Position", "CircleRenderer"},
    simpleSpritePool = {"Position", "SimpleSpriteRenderer"},
    complexSpritePool = {"Position", "ComplexSpriteRenderer"},
    customAnimPool = {"ComplexSpriteRenderer", "Animator"}
}

function RenderSystem:getMapping(current, table)
    local value = current
    for k,v in pairs(table) do
        if type(v) == "table" then
            local d = RenderSystem:getMapping(current, v)
            value = value[d]
        else
            value = value[v]
        end
    end
    return value
end

function RenderSystem:update(dt)

    for _,e in ipairs(self.complexSpritePool) do
        local sprite = spritesheetIndex[e.ComplexSpriteRenderer.index]
        e.ComplexSpriteRenderer.frame = (e.ComplexSpriteRenderer.frame + e.ComplexSpriteRenderer.speed * dt) % sprite.frames
    end

    for _, e in ipairs(self.customAnimPool) do
        local vars = {}
        --Update the values of all variables
        for k, v in pairs(e.Animator.variables) do
            vars[k] = RenderSystem:getMapping(e, v)
        end

        -- current = Timeline.current[Timeline.index].test = "debug"
        -- .. current .. = .. 'debug' ..

        --Check all the transitions that start from the current animation
        for k, v in pairs(e.Animator.transitions) do
            if v.from == e.Animator.currentState then
                local str = ""
                for a,c in ipairs(v.condition) do
                    if a % 2 == 0 then
                        if c == "AND" then 
                            str = str .. " and "
                        elseif c == "OR" then
                            str = str .. " or "
                        end
                    else
                        local replaced = c
                        for index, var in pairs(vars) do
                            if type(var) == "string" then
                                var = "'" .. var .. "'"
                            end
                            replaced = string.gsub(replaced, index, var)
                        end
                        str = str .. replaced
                    end
                end

                local func = assert(loadstring("return " .. str))
                if func() then
                    e.Animator.currentState = v.to
                    local AnimCurrentState = e.Animator.states[e.Animator.currentState]
                    e.ComplexSpriteRenderer.speed = AnimCurrentState.speed
                    e.ComplexSpriteRenderer.index = AnimCurrentState.spritesheet
                    e.ComplexSpriteRenderer.frame = 0
                    e.ComplexSpriteRenderer.quads = {}
                    local sprite = spritesheetIndex[e.ComplexSpriteRenderer.index]
                    e.ComplexSpriteRenderer.spritesheet = love.graphics.newImage(SPRITES_PATH .. sprite.path)
                    local no_col = e.ComplexSpriteRenderer.spritesheet:getWidth() / sprite.size.x
                    for i=1, sprite.frames, 1 do
                        e.ComplexSpriteRenderer.quads[i] = love.graphics.newQuad(
                            ((i-1) % no_col) * sprite.size.x + (math.max((i-2),0) % no_col) * sprite.padding.x,
                            math.floor((i-1) / no_col) * sprite.size.y + math.floor(math.max((i-2),0) / no_col) * sprite.padding.y,
                            sprite.size.x,
                            sprite.size.y,
                            e.ComplexSpriteRenderer.spritesheet:getWidth(),
                            e.ComplexSpriteRenderer.spritesheet:getHeight()
                        )
                    end
                end
            end
        end
    end

end

function RenderSystem:draw()

    for _,e in ipairs(self.boxPool) do
        love.graphics.setColor(unpack(e.BoxRenderer.color))
        love.graphics.rectangle(
            e.BoxRenderer.mode,
            e.Position.x - e.BoxRenderer.width / 2,
            e.Position.y - e.BoxRenderer.height / 2,
            e.BoxRenderer.width, e.BoxRenderer.height
        )
        love.graphics.setColor{1, 1, 1, 1}
    end

    for _,e in ipairs(self.circlePool) do
        love.graphics.setColor(unpack(e.CircleRenderer.color))
        love.graphics.circle(
            e.CircleRenderer.mode,
            e.Position.x,
            e.Position.y,
            e.CircleRenderer.radius
        )
        love.graphics.setColor{1, 1, 1, 1}
    end

    for _,e in ipairs(self.simpleSpritePool) do
        love.graphics.draw(
            e.SimpleSpriteRenderer.loaded,
            e.Position.x - e.SimpleSpriteRenderer.loaded:getWidth()/2,
            e.Position.y - e.SimpleSpriteRenderer.loaded:getHeight()/2
        )
    end

    for _,e in ipairs(self.complexSpritePool) do
        love.graphics.draw(e.ComplexSpriteRenderer.spritesheet, e.ComplexSpriteRenderer.quads[math.floor(e.ComplexSpriteRenderer.frame)+1], e.Position.x, e.Position.y)
    end

end

ParticleSystem = concord.system {
    pool = {"Particles", "Position"}
}

function ParticleSystem:update(dt)
    for _,e in ipairs(self.pool) do
        if e.Particles.fizzle_out <= 0 then
            e.Particles.system:setEmissionRate(0)
        end
        if e.Particles.duration <= 0 then
            e:destroy()
            return
        end
        e.Particles.duration = e.Particles.duration - dt
        e.Particles.fizzle_out = e.Particles.fizzle_out - dt
        e.Particles.system:update(dt)
    end
end

function ParticleSystem:draw()
    for _,e in ipairs(self.pool) do
        love.graphics.draw(e.Particles.system, e.Position.x, e.Position.y)
    end
end