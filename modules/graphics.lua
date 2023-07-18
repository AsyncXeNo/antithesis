local log = require("libs.log")
local inspect = require("libs.inspect").inspect
local concord = require("libs.Concord")


-- COMPONENTS

--[[
    Background
]]
concord.component(
    "Background",

    function (component, image, alpha, bg_mix)
        component.image = image or love.graphics.newCanvas(GAME_WIDTH, GAME_HEIGHT)
        component.alpha = alpha or 0.9
        component.bg_mix = bg_mix or { 0, 0, 0, 1 }
    end
)


-- SYSTEMS
BackgroundSystem = concord.system {
    pool = {"Background"}
}

function BackgroundSystem:update()
    
end

function BackgroundSystem:draw()
    for _,e in ipairs(self.pool) do
        love.graphics.setBackgroundColor(unpack(e.Background.bg_mix))
        love.graphics.setColor(1, 1, 1, e.Background.alpha)
        love.graphics.draw(e.Background.image, 0, 0, 0, GAME_WIDTH/e.Background.image:getWidth(), GAME_HEIGHT/e.Background.image:getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    end
end
