local concord = require "libs.Concord"
local log = require "libs.log"
local inspect = require ("libs.inspect")
require "constants"
local spritesheetIndex = require "res.spritesheets"

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
    Point Renderer
]]
concord.component(
    "PointRenderer",

    function(component) end
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

function RenderSystem:update(dt)

    for _,e in ipairs(self.complexSpritePool) do
        local sprite = spritesheetIndex[e.ComplexSpriteRenderer.index]
        e.ComplexSpriteRenderer.frame = (e.ComplexSpriteRenderer.frame + e.ComplexSpriteRenderer.speed * dt) % sprite.frames
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
        log.info(inspect(e.ComplexSpriteRenderer.quads))
        love.graphics.draw(e.ComplexSpriteRenderer.spritesheet, e.ComplexSpriteRenderer.quads[math.floor(e.ComplexSpriteRenderer.frame)+1], e.Position.x, e.Position.y)
    end

end


