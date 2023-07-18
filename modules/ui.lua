local concord = require("libs.Concord")
local inspect = require("libs.inspect").inspect
local log = require("libs.log")

require "constants"
require "modules.controller"

-- COMPONENTS

--[[
    Menu
]]
concord.component(
    "Menu",

    function (component, options, pointer, text_props)
        component.text_props = text_props or { font= "Coders Crux", size=30 }
        component.options = options
        component.pointer = pointer  -- Consult docs/ui.md
        component.font = love.graphics.newFont(FONTS_PATH .. component.text_props.font .. ".ttf", component.text_props.size)
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
        
        if (e.Controllable.pressed.moveUp) then

            local current = e.Menu.options
            local selected

            for _,p in ipairs(e.Menu.pointer) do
                if (type(current[p].value) == "table") then
                    current = current[p].value
                else
                    selected = p
                end
            end

            -- lua_selected-1 = normal_selected, normal_selected-1 = next_selected
            -- => lua_selected-2 = next_selected
            selected = ((selected-2) % Table.len(current))+1

            e.Menu.pointer[#e.Menu.pointer] = selected

            e.Controllable.pressed.moveUp = false

        elseif (e.Controllable.pressed.moveDown) then
            
            local current = e.Menu.options
            local selected

            for _,p in ipairs(e.Menu.pointer) do
                if (type(current[p].value) == "table") then
                    current = current[p].value
                else
                    selected = p
                end
            end

            -- lua_selected-1 = normal_selected, normal_selected+1 = next_selected
            -- => lua_selected = next_selected
            selected = (selected % Table.len(current))+1
            
            e.Menu.pointer[#e.Menu.pointer] = selected

            e.Controllable.pressed.moveDown = false

        elseif (e.Controllable.pressed.action) then
            
            local current = e.Menu.options
            local selected

            for _,p in ipairs(e.Menu.pointer) do
                if (type(current[p].value) == "table") then
                    current = current[p].value
                else
                    selected = p
                end
            end

            current[selected].value() 
            e.Controllable.pressed.action = false
        end
    end
end

function MenuSystem:draw() 

    for _,e in ipairs(self.pool) do

        local current = e.Menu.options
        local selected = nil
        for _,p in ipairs(e.Menu.pointer) do
            if (type(current[p].value) == "table") then
                current = current[p].value
            else
                selected = p
            end
        end

        local menu_box = {
            ["height"] = 3*MENU.option_box.in_between + (Table.len(current) * (e.Menu.text_props.size + MENU.option_box.in_between)),
            ["width"] = MENU.option_box.width + MENU.option_box.start_padding
        }
        
        local start_box = {
            x = 0.5*GAME_WIDTH - menu_box.width/2,
            y = 0.5*GAME_HEIGHT - menu_box.height/2,
        }

        -- love.graphics.rectangle(
        --     "line",
        --     start_box.x,
        --     start_box.y,
        --     menu_box.width,
        --     menu_box.height
        -- )

        local current_y = start_box.y + 2*MENU.option_box.in_between

        for index,option in ipairs(current) do
            
            love.graphics.printf(
                option.name,
                e.Menu.font,
                start_box.x + MENU.option_box.start_padding,
                start_box.y + 2*MENU.option_box.in_between + (MENU.option_box.in_between + MENU.font_size)*(index-1) + e.Menu.text_props.size / 2,
                MENU.option_box.width,
                "left"
            )

            if (index == selected) then
                local arrow = "->"

                love.graphics.printf(
                    {{1, 0, 0, 1}, arrow},
                    e.Menu.font,
                    start_box.x,
                    start_box.y + 2*MENU.option_box.in_between + (MENU.option_box.in_between + MENU.font_size)*(index-1) + e.Menu.text_props.size / 2,
                    MENU.option_box.start_padding-10,
                    "right"
                )
            end
            
        end

    end

end

