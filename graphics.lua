local concord = require "libs.Concord"
local log = require "libs.log"
require "constants"
local spritesheetIndex = require "res.spritesheets"

-- COMPONENTS

--[[
    Point Renderer
]]
concord.component(
    "PointRenderer",

    function(component) end
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
    SimpleSpriteRenderer
]]
concord.component(
    "SimpleSpriteRenderer",

    function(component, sprite)

        component.sprite = sprite or log.error('No sprite')

    end
)

--[[
    ComplexSpriteRenderer
]]
concord.component {
    "ComplexSpriteRenderer",

    function(component, index, fps, frame)
        
        component.spritesheet = index or log.error('No sprite')
        component.fps = fps
        component.frame = frame or 0

    end
}

--[[
    Circle Renderer
]]
concord.component(
    "CircleRenderer",
    
    function(component, radius, color, mode)

        component.radius = radius or 0
        component.color = color or {1, 0, 0, 1}
        component.mode = "fill"

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
    complexSpritePool = {"Position", "ComplexSpriteRenderer"}
}

function RenderSystem:init()

    for _,e in ipairs(self.simpleSpritePool) do
        e.SimpleSpriteRenderer.loaded = love.graphics.newImage(SPRITES_PATH .. spritesheetIndex[e.SimpleSpriteRenderer.sprite].path)
    end

    for _,e in ipairs(self.complexSpritePool) do
        local sprite = spritesheetIndex[e.ComplexSpriteRenderer.index]
        e.ComplexSpriteRenderer.spritesheet = love.graphics.newImage(SPRITES_PATH .. sprite.path)
        local no_col = e.ComplexSpriteRenderer.spritesheet:getWidth() / sprite.size.x
        for i=1, sprite.frames, 1 do
            e.ComplexSpriteRenderer.frames[i] = love.graphics.newQuad(
                ((i-1) % no_col) * sprite.size.x + ((i-2) % no_col) * sprite.padding.x,
                ((i-1) / no_col) * sprite.size.y + ((i-2) / no_col) * sprite.padding.y,
                sprite.size.x, 
                sprite.size.y, 
                e.ComplexSpriteRenderer.spritesheet:getWidth(), 
                e.ComplexSpriteRenderer.spritesheet:getHeight()
            )
        end
    end

end

function RenderSystem:update(dt) 

    for _,e in ipairs(self.complexSpritePool) do
        e.ComplexSpriteRenderer.frame = e.ComplexSpriteRenderer.frame + e.ComplexSpriteRenderer.fps * dt
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

    end

    for _,e in ipairs(self.circlePool) do
        love.graphics.setColor(unpack(e.CircleRenderer.color))
        love.graphics.circle(
            e.CircleRenderer.mode, 
            e.Position.x, 
            e.Position.y, 
            e.CircleRenderer.radius
        )
    end

    for _,e in ipairs(self.simpleSpritePool) do
        love.graphics.draw(
            e.SimpleSpriteRenderer.loaded, 
            e.Position.x - e.SimpleSpriteRenderer.loaded:getWidth()/2, 
            e.Position.y - e.SimpleSpriteRenderer.loaded:getHeight()/2
        )
    end

    for _,e in ipairs(self.complexSpritePool) do
        love.graphics.draw(e.ComplexSpriteRenderer.spritesheet, e.ComplexSpriteRenderer.quads[e.ComplexSpriteRenderer.frame])
    end

end


