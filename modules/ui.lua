local concord = require("libs.Concord")
local inspect = require("libs.inspect").inspect
local log = require("libs.log")

require "constants"


-- COMPONENTS

--[[
    Menu
]]
concord.component(
    "Menu",

    function (component, options, pointer)
        component.options = component.options
        component.pointer = pointer  -- Consult docs/ui.md
    end
)


-- SYSTEMS

--[[
    Menu System
]]
MenuSystem = concord.system{
    pool = {"Menu", "Controllable"}
}

function MenuSystem:update(dt)
    for _,e in ipairs(self.pool) do
        
        
        
    end
end

function MenuSystem:draw() 

    for _,e in ipairs(self.pool) do
        
        local start_box = {
            x = 0.5*GAME_WIDTH - MENU.box.x/2,
            y = 0.5*GAME_HEIGHT - MENU.box.y/2,
        }

        love.graphics.rectangle(
            "line",
            start_box.x,
            start_box.y,
            MENU.box.x,
            MENU.box.y
        )
        
    end
    
end

