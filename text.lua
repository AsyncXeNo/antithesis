local concord = require "libs.Concord"
local inspect = require("libs.inspect").inspect
local log = require "libs.log"
require "constants"

-- COMPONENTS

--[[
    MessageBox
]]
concord.component(
    "MessageBox",
    
    function (component, text, text_props, duration, size, border)
        if type(text) == "string" then text = {text} end
        component.text = text
        component.text_props = text_props or { font= "Coders Crux", size=20 }
        component.duration = duration or 5  -- seconds
        component.size = size or {width=150, height=75}
        component.border = border or {width = 3, color = {1, 0.12, 0.44}}

        component.counting = 0
        component.alpha = 1
        component.font = love.graphics.newFont(FONTS_PATH .. component.text_props.font .. ".ttf", component.text_props.size)
    end

)


--SYSTEMS

--[[
    MessageBoxSystem
]]

MessageBoxSystem = concord.system {
    pool = {
        "Position",
        "MessageBox"
    }
}

function MessageBoxSystem:init()
    for _,e in ipairs(self.pool) do
    end
end

function MessageBoxSystem:update(dt)
    for _,e in ipairs(self.pool) do
        e.MessageBox.counting = e.MessageBox.counting + dt
        if e.MessageBox.counting +0.5 >= e.MessageBox.duration then
            e.MessageBox.alpha = e.MessageBox.alpha - dt*2
        end
        if e.MessageBox.counting >= e.MessageBox.duration then
            e:destroy()
        end
    end
end

function  MessageBoxSystem:draw()
    for _, e in ipairs(self.pool) do
        love.graphics.setColor(0,0,0, e.MessageBox.alpha)
        love.graphics.rectangle(
            "fill",
            e.Position.x - e.MessageBox.size.width / 2,
            e.Position.y - e.MessageBox.size.height / 2,
            e.MessageBox.size.width,
            e.MessageBox.size.height,
            e.MessageBox.size.width/16,
            e.MessageBox.size.width/16
        )
        local b_color = List.combineLists(e.MessageBox.border.color, {e.MessageBox.alpha})
        love.graphics.setColor(b_color)
        love.graphics.setLineWidth(e.MessageBox.border.width)
        love.graphics.rectangle(
            "line",
            e.Position.x - e.MessageBox.size.width / 2,
            e.Position.y - e.MessageBox.size.height / 2,
            e.MessageBox.size.width,
            e.MessageBox.size.height,
            e.MessageBox.size.width/16,
            e.MessageBox.size.width/16
        )
        love.graphics.setColor(1,1,1,e.MessageBox.alpha)

        love.graphics.printf(
            e.MessageBox.text,
            e.MessageBox.font,
            e.Position.x - e.MessageBox.size.width / 2,
            e.Position.y - e.MessageBox.text_props.size / 4,
            e.MessageBox.size.width,
            "center"
        )
    end
end