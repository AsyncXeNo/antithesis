local concord = require "libs.Concord"
local inspect = require("libs.inspect").inspect
local log = require "libs.log"

local sprites = require "res.sprites"

require "constants"
require "utils"

require "libs.gradient"


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

function MessageBoxSystem:draw()
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


--[[
    HUD System
]]


HUDSystem = concord.system {
    pool = {"Player"}
}

function HUDSystem:update(dt)
    
end

function HUDSystem:draw()
    for _,e in ipairs(self.pool) do
        
        --[[
            HP BAR
        ]]

        local start_hp = HUD.start_hp_box
        local stat_size = HUD.stat_box
        
        local hp_mul = (e.Stats.current.hp / e.Stats.base.maxHp)

        love.gradient.draw(
            function()
                love.graphics.rectangle(
                    "fill",
                    start_hp.x,
                    start_hp.y,
                    stat_size.x * hp_mul,
                    stat_size.y
                )
            end,
            "linear",
            start_hp.x + (stat_size.x * hp_mul) / 2,
            start_hp.y + (stat_size.y) / 2,
            (stat_size.x * hp_mul) / 2,
            stat_size.y / 2,
            Color.fromRGB(unpack(HUD.color.hp.start_col)),
            Color.fromRGB(unpack(HUD.color.hp.end_col))
        )

        love.graphics.setColor(1,1,1,1)

        local hp_bar = love.graphics.newImage(SPRITES_PATH .. sprites['hp_bar'].path)

        local x_diff = math.abs(stat_size.x - hp_bar:getWidth())
        local y_diff = math.abs(stat_size.y - hp_bar:getHeight())
        
        love.graphics.draw(hp_bar, HUD.start_hp_box.x - x_diff , HUD.start_hp_box.y - y_diff/2)

        love.graphics.setLineWidth(1)

        --[[
            SHIELD BAR
        ]]

        local start_shield = HUD.start_shield_box
        
        local shield_mul = (e.Stats.current.shield / e.Stats.current.maxShield)

        love.gradient.draw(
            function()
                love.graphics.rectangle(
                    "fill",
                    start_shield.x,
                    start_shield.y,
                    stat_size.x * shield_mul,
                    stat_size.y
                )
            end,
            "linear",
            start_shield.x + (stat_size.x * shield_mul) / 2,
            start_shield.y + (stat_size.y) / 2,
            (stat_size.x * shield_mul) / 2,
            stat_size.y / 2,
            Color.fromRGB(unpack(HUD.color.shield.start_col)),
            Color.fromRGB(unpack(HUD.color.shield.end_col))
        )

        love.graphics.setColor(1,1,1,1)

        local shield_bar = love.graphics.newImage(SPRITES_PATH .. sprites['shield_bar'].path)

        local x_diff = math.abs(stat_size.x - shield_bar:getWidth())
        local y_diff = math.abs(stat_size.y - shield_bar:getHeight())

        love.graphics.draw(shield_bar, HUD.start_shield_box.x - x_diff , HUD.start_shield_box.y - y_diff/2)

        love.graphics.setLineWidth(1)

        --[[
            HUD OUTLINE
        ]]
            

        if e.Player.extendedHUD then
            love.graphics.setColor(Color.fromRGB(unpack(HUD.color.outer)))
            love.graphics.setLineWidth(1)
            love.graphics.rectangle("line",
                HUD.start_box.x,
                HUD.start_box.y,
                HUD.box_more.x,
                HUD.box_more.y
            )
            love.graphics.setColor(1, 1, 1, 1)
        else
            love.graphics.setColor(Color.fromRGB(unpack(HUD.color.outer)))
            love.graphics.setLineWidth(1)
            love.graphics.rectangle("line",
                HUD.start_box.x,
                HUD.start_box.y,
                HUD.box_normal.x,
                HUD.box_normal.y
            )
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end